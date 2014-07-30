Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755007AbaG3GIr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 02:08:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58308 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751735AbaG3GIp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 02:08:45 -0400
Date: Wed, 30 Jul 2014 16:08:33 +1000
From: NeilBrown <neilb@suse.de>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Ian Kent <raven@themaw.net>, autofs@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH] VFS: allow ->d_manage() to declare -EISDIR in rcu_walk
 mode.
Message-ID: <20140730160833.5eac00ec@notabene.brown>
X-Mailer: Claws Mail 3.10.1-123-gae895c (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/VDJluVxi5hQZE_pok=5O+BL"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/VDJluVxi5hQZE_pok=5O+BL
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


In REF-walk mode, ->d_manage can return -EISDIR to indicate
that the dentry is not really a mount trap (or even a mount point)
and that any mounts or any DCACHE_NEED_AUTOMOUNT flag should be
ignored.

RCU-walk mode doesn't currently support this, so if there is a dentry
with DCACHE_NEED_AUTOMOUNT set but which shouldn't be a mount-trap,
lookup_fast() will always drop in REF-walk mode.

With this patch, an -EISDIR from ->d_manage will always cause mounts
and automounts to be ignored, both in REF-walk and RCU-walk.

Cc: Ian Kent <raven@themaw.net>
Signed-off-by: NeilBrown <neilb@suse.de>

---
Hi Al,
 this patch is needed before I can make autofs4 fully support RCU-walk.
There are cases currently were directories have DCACHE_NEED_AUTOMOUNT but f=
or which
no automount is required.

Thanks,
NeilBrown


diff --git a/Documentation/filesystems/vfs.txt b/Documentation/filesystems/=
vfs.txt
index a1d0d7a30165..61d65cc65c54 100644
--- a/Documentation/filesystems/vfs.txt
+++ b/Documentation/filesystems/vfs.txt
@@ -1053,7 +1053,8 @@ struct dentry_operations {
 	If the 'rcu_walk' parameter is true, then the caller is doing a
 	pathwalk in RCU-walk mode.  Sleeping is not permitted in this mode,
 	and the caller can be asked to leave it and call again by returning
-	-ECHILD.
+	-ECHILD.  -EISDIR may also be returned to tell pathwalk to
+	ignore d_automount or any mounts.
=20
 	This function is only used if DCACHE_MANAGE_TRANSIT is set on the
 	dentry being transited from.
diff --git a/fs/namei.c b/fs/namei.c
index 985c6f368485..0abfea5697e0 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1091,10 +1091,10 @@ int follow_down_one(struct path *path)
 }
 EXPORT_SYMBOL(follow_down_one);
=20
-static inline bool managed_dentry_might_block(struct dentry *dentry)
+static inline int managed_dentry_rcu(struct dentry *dentry)
 {
-	return (dentry->d_flags & DCACHE_MANAGE_TRANSIT &&
-		dentry->d_op->d_manage(dentry, true) < 0);
+	return (dentry->d_flags & DCACHE_MANAGE_TRANSIT) ?
+		dentry->d_op->d_manage(dentry, true) : 0;
 }
=20
 /*
@@ -1110,11 +1110,16 @@ static bool __follow_mount_rcu(struct nameidata *nd=
, struct path *path,
 		 * Don't forget we might have a non-mountpoint managed dentry
 		 * that wants to block transit.
 		 */
-		if (unlikely(managed_dentry_might_block(path->dentry)))
+		switch (managed_dentry_rcu(path->dentry)) {
+		case -ECHILD:
+		default:
 			return false;
+		case -EISDIR:
+			return true;
+		}
=20
 		if (!d_mountpoint(path->dentry))
-			return true;
+			return !(path->dentry->d_flags & DCACHE_NEED_AUTOMOUNT);
=20
 		mounted =3D __lookup_mnt(path->mnt, path->dentry);
 		if (!mounted)
@@ -1130,7 +1135,8 @@ static bool __follow_mount_rcu(struct nameidata *nd, =
struct path *path,
 		 */
 		*inode =3D path->dentry->d_inode;
 	}
-	return read_seqretry(&mount_lock, nd->m_seq);
+	return read_seqretry(&mount_lock, nd->m_seq) &&
+		!(path->dentry->d_flags & DCACHE_NEED_AUTOMOUNT);
 }
=20
 static int follow_dotdot_rcu(struct nameidata *nd)
@@ -1402,11 +1408,8 @@ static int lookup_fast(struct nameidata *nd,
 		}
 		path->mnt =3D mnt;
 		path->dentry =3D dentry;
-		if (unlikely(!__follow_mount_rcu(nd, path, inode)))
-			goto unlazy;
-		if (unlikely(path->dentry->d_flags & DCACHE_NEED_AUTOMOUNT))
-			goto unlazy;
-		return 0;
+		if (likely(__follow_mount_rcu(nd, path, inode)))
+			return 0;
 unlazy:
 		if (unlazy_walk(nd, dentry))
 			return -ECHILD;

--Sig_/VDJluVxi5hQZE_pok=5O+BL
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU9iL4Tnsnt1WYoG5AQJ8+A//VvVIwNjVJZ6MV6tNY3o+s2lgC3KF0ZSf
o7B9Jw9uAsWFm+MSfOG/D00sYZvruBnlu2vL3TI84ErtVmH947mMOvToWIEVna/f
VcysCV6sfPbmwdySe6Av0Mhwtp6Q9DO0Ipc3d5U7XJuXok9C+0fxvSCO43Hkit3C
WXptetSLdQKzyE/ugi85azuXiPU6YN/D3XfpFPXg0RJ5i/aIPLed1tvOkstwNb6r
DstGI8FnEerJuYAUXzvq+A3CPtmXV+76N276omDl3ftrPHM7P0ze0y5nujgHiwD8
k1Gv4c6r8NrapXKJ+xE4Da0vlLEUY3L+wQWxN4XFFPEGUef2gAgBVLBx2fYvSsa8
n7IxJwD+m2h2t7im9m9yZHKZrMhhmELTui6wBMpBMtGjj9jkgfiwtmLipKWMXvNT
RABjc6ypDpwrGzdwDYRCnfBxgQukbLubrbMmbekv/nmcgi4sLCrnHKnXiHEzsQ9+
88rWJ0EGkFb9nwTNCV3XSA0HSFxcGkRvobHZZjsvYoa5jz2Qi/A8q10NGq8CubUw
JpIK6AV6wlxU4zBK0AZSpc6nlI1BQLlsSSIBdHct6dEwTQ4Cv26bi7xM1ODg7I/s
BRjGNeXI/wrhY3TQkWdrhbOcFzCgAXCJIoNh8CpNbsGuWuGfwsgtib/zCoI2vMZ1
ab04tIgKw1M=
=Z2dx
-----END PGP SIGNATURE-----

--Sig_/VDJluVxi5hQZE_pok=5O+BL--
