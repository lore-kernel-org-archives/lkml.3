Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752278AbaGNAyS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 20:54:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53155 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750886AbaGNAyK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 20:54:10 -0400
Date: Mon, 14 Jul 2014 10:53:59 +1000
From: NeilBrown <neilb@suse.de>
To: Ian Kent <raven@themaw.net>
Cc: autofs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6 v2] autofs4: factor should_expire() out of
 autofs4_expire_indirect.
Message-ID: <20140714105359.4415aab4@notabene.brown>
In-Reply-To: <20140709234114.4525.25725.stgit@notabene.brown>
References: <20140709233541.4525.25151.stgit@notabene.brown>
	<20140709234114.4525.25725.stgit@notabene.brown>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/7CstQ_MKTudRJJAtFHXXhJg"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/7CstQ_MKTudRJJAtFHXXhJg
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


Here is a revised version of this one patch.
This one fixes a problem with refcounts on dentry and adds a comment to
clarify the behaviour of should_expire().

thanks,
NeilBrown


From: NeilBrown <neilb@suse.de>Date: Tue, 8 Jul 2014 17:14:53 +1000
Subject: [PATCH] autofs4: factor should_expire() out of autofs4_expire_indi=
rect.

Future patch will potentially call this twice, so make it
separate.

Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/fs/autofs4/expire.c b/fs/autofs4/expire.c
index 7e2f22ce6954..402ee7f1461a 100644
--- a/fs/autofs4/expire.c
+++ b/fs/autofs4/expire.c
@@ -345,6 +345,89 @@ out:
 	return NULL;
 }
=20
+/* Check if 'dentry' should expire, or return a nearby
+ * dentry that is suitable.
+ * If returned dentry is different from arg dentry,
+ * then a dget() reference was taken, else not.
+ */
+static struct dentry *should_expire(struct dentry *dentry,
+				    struct vfsmount *mnt,
+				    unsigned long timeout,
+				    int how)
+{
+	int do_now =3D how & AUTOFS_EXP_IMMEDIATE;
+	int exp_leaves =3D how & AUTOFS_EXP_LEAVES;
+	struct autofs_info *ino =3D autofs4_dentry_ino(dentry);
+	unsigned int ino_count;
+
+	/* No point expiring a pending mount */
+	if (ino->flags & AUTOFS_INF_PENDING)
+		return NULL;
+
+	/*
+	 * Case 1: (i) indirect mount or top level pseudo direct mount
+	 *	   (autofs-4.1).
+	 *	   (ii) indirect mount with offset mount, check the "/"
+	 *	   offset (autofs-5.0+).
+	 */
+	if (d_mountpoint(dentry)) {
+		DPRINTK("checking mountpoint %p %.*s",
+			dentry, (int)dentry->d_name.len, dentry->d_name.name);
+
+		/* Can we umount this guy */
+		if (autofs4_mount_busy(mnt, dentry))
+			return NULL;
+
+		/* Can we expire this guy */
+		if (autofs4_can_expire(dentry, timeout, do_now))
+			return dentry;
+		return NULL;
+	}
+
+	if (dentry->d_inode && S_ISLNK(dentry->d_inode->i_mode)) {
+		DPRINTK("checking symlink %p %.*s",
+			dentry, (int)dentry->d_name.len, dentry->d_name.name);
+		/*
+		 * A symlink can't be "busy" in the usual sense so
+		 * just check last used for expire timeout.
+		 */
+		if (autofs4_can_expire(dentry, timeout, do_now))
+			return dentry;
+		return NULL;
+	}
+
+	if (simple_empty(dentry))
+		return NULL;
+
+	/* Case 2: tree mount, expire iff entire tree is not busy */
+	if (!exp_leaves) {
+		/* Path walk currently on this dentry? */
+		ino_count =3D atomic_read(&ino->count) + 1;
+		if (d_count(dentry) > ino_count)
+			return NULL;
+
+		if (!autofs4_tree_busy(mnt, dentry, timeout, do_now))
+			return dentry;
+		/*
+		 * Case 3: pseudo direct mount, expire individual leaves
+		 *	   (autofs-4.1).
+		 */
+	} else {
+		/* Path walk currently on this dentry? */
+		struct dentry *expired;
+		ino_count =3D atomic_read(&ino->count) + 1;
+		if (d_count(dentry) > ino_count)
+			return NULL;
+
+		expired =3D autofs4_check_leaves(mnt, dentry, timeout, do_now);
+		if (expired) {
+			if (expired =3D=3D dentry)
+				dput(dentry);
+			return dentry;
+		}
+	}
+	return NULL;
+}
 /*
  * Find an eligible tree to time-out
  * A tree is eligible if :-
@@ -359,11 +442,8 @@ struct dentry *autofs4_expire_indirect(struct super_bl=
ock *sb,
 	unsigned long timeout;
 	struct dentry *root =3D sb->s_root;
 	struct dentry *dentry;
-	struct dentry *expired =3D NULL;
-	int do_now =3D how & AUTOFS_EXP_IMMEDIATE;
-	int exp_leaves =3D how & AUTOFS_EXP_LEAVES;
+	struct dentry *expired;
 	struct autofs_info *ino;
-	unsigned int ino_count;
=20
 	if (!root)
 		return NULL;
@@ -374,78 +454,12 @@ struct dentry *autofs4_expire_indirect(struct super_b=
lock *sb,
 	dentry =3D NULL;
 	while ((dentry =3D get_next_positive_subdir(dentry, root))) {
 		spin_lock(&sbi->fs_lock);
-		ino =3D autofs4_dentry_ino(dentry);
-		/* No point expiring a pending mount */
-		if (ino->flags & AUTOFS_INF_PENDING)
-			goto next;
-
-		/*
-		 * Case 1: (i) indirect mount or top level pseudo direct mount
-		 *	   (autofs-4.1).
-		 *	   (ii) indirect mount with offset mount, check the "/"
-		 *	   offset (autofs-5.0+).
-		 */
-		if (d_mountpoint(dentry)) {
-			DPRINTK("checking mountpoint %p %.*s",
-				dentry, (int)dentry->d_name.len, dentry->d_name.name);
-
-			/* Can we umount this guy */
-			if (autofs4_mount_busy(mnt, dentry))
-				goto next;
-
-			/* Can we expire this guy */
-			if (autofs4_can_expire(dentry, timeout, do_now)) {
-				expired =3D dentry;
-				goto found;
-			}
-			goto next;
-		}
-
-		if (dentry->d_inode && S_ISLNK(dentry->d_inode->i_mode)) {
-			DPRINTK("checking symlink %p %.*s",
-				dentry, (int)dentry->d_name.len, dentry->d_name.name);
-			/*
-			 * A symlink can't be "busy" in the usual sense so
-			 * just check last used for expire timeout.
-			 */
-			if (autofs4_can_expire(dentry, timeout, do_now)) {
-				expired =3D dentry;
-				goto found;
-			}
-			goto next;
-		}
-
-		if (simple_empty(dentry))
-			goto next;
-
-		/* Case 2: tree mount, expire iff entire tree is not busy */
-		if (!exp_leaves) {
-			/* Path walk currently on this dentry? */
-			ino_count =3D atomic_read(&ino->count) + 1;
-			if (d_count(dentry) > ino_count)
-				goto next;
-
-			if (!autofs4_tree_busy(mnt, dentry, timeout, do_now)) {
-				expired =3D dentry;
-				goto found;
-			}
-		/*
-		 * Case 3: pseudo direct mount, expire individual leaves
-		 *	   (autofs-4.1).
-		 */
-		} else {
-			/* Path walk currently on this dentry? */
-			ino_count =3D atomic_read(&ino->count) + 1;
-			if (d_count(dentry) > ino_count)
-				goto next;
-
-			expired =3D autofs4_check_leaves(mnt, dentry, timeout, do_now);
-			if (expired) {
+		expired =3D should_expire(dentry, mnt, timeout, how);
+		if (expired) {
+			if (expired !=3D dentry)
 				dput(dentry);
-				goto found;
-			}
+			goto found;
 		}
-next:
 		spin_unlock(&sbi->fs_lock);
 	}
 	return NULL;

--Sig_/7CstQ_MKTudRJJAtFHXXhJg
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU8MqJznsnt1WYoG5AQI00Q//WRKPIfPJ/WwMLo4lNAN76ZQpQ5FjnXXP
NsTPDkcX293Po1EpGZOJfqcqNdvxQa8rE2LmMjQEznUbuSASzUsQjfh7BSy9fl2z
jtqKy7OI1VK6WfxYSMEq/y2N5rvxRu91E8mtOD+HIBGMgLcjrGOSmwjkD2kc8/hR
TCSrsuRERZcG7MGRiLjaNemCPsA80ckMpl+GFY/UCqZGZd8iQuwvTzL5M2UNI+ZV
qBIXLdV64DhEsF+aiXhaoHqL89iYauJl2uEkNl3/X4tjxd7LrCdRxkrJpDRKtaZj
NPU7aDAWycF/uRys8aymoguryuROXjAw//5dU2/gctqPC8LchR3CfjhXWiiOLuxE
N76rRaCqUrF3Yekbuq6yKNYyA8qyZr4K21sXjrATKfyhu7uFk68pJ5hnOk9mJFIJ
ybwM/FnChTACo+7gU1xikUHy8muGIh+qe3/wu/WnPOfRhdSYLtt5cuaWvcu4CcDY
VFw7wA8jv3nUFJVtOP4lEGksseUYARq3NRVeNZm4V26nnEFX8/3kNTwjzAGH6EdT
iihHuzrxKRxtBMpKYaYSZ4lO/kx30i8eVuXpIv949lD/qDWuG4OBPq3BT3pLC4WA
gX7z79TD34Eow+hu551AwzoWpP/nqzxaJtgXRFz70gnoChXocRFHNdnk9yAF8XUi
RaitxSBeNuQ=
=kB0u
-----END PGP SIGNATURE-----

--Sig_/7CstQ_MKTudRJJAtFHXXhJg--
