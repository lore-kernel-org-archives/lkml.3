Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751544AbaHDHGy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 03:06:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52994 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751043AbaHDHGx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 03:06:53 -0400
Date: Mon, 4 Aug 2014 17:06:29 +1000
From: NeilBrown <neilb@suse.de>
To: Al Viro <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@infradead.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, Ian Kent <raven@themaw.net>,
        autofs@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH - V2] VFS: allow ->d_manage() to declare -EISDIR in rcu_walk
 mode.
Message-ID: <20140804170629.5b2c9013@notabene.brown>
In-Reply-To: <20140801184815.22dd193f@notabene.brown>
References: <20140730160833.5eac00ec@notabene.brown>
	<20140801083318.GA4907@mwanda>
	<20140801184815.22dd193f@notabene.brown>
X-Mailer: Claws Mail 3.10.1-123-gae895c (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/FH_UnyHIq_V=KHiZi1rVjDK"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/FH_UnyHIq_V=KHiZi1rVjDK
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

Bug-fixed-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Ian Kent <raven@themaw.net>
Signed-off-by: NeilBrown <neilb@suse.de>

---
Previous version of this patch had a bug causing code to be unreachable.
Please replace with this version.

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
index 9eb787e5c167..98ce4cffe51c 100644
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
@@ -1110,11 +1110,18 @@ static bool __follow_mount_rcu(struct nameidata *nd=
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
+		case 0:
+			break;
+		}
=20
 		if (!d_mountpoint(path->dentry))
-			return true;
+			return !(path->dentry->d_flags & DCACHE_NEED_AUTOMOUNT);
=20
 		mounted =3D __lookup_mnt(path->mnt, path->dentry);
 		if (!mounted)
@@ -1130,7 +1137,8 @@ static bool __follow_mount_rcu(struct nameidata *nd, =
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
@@ -1402,11 +1410,8 @@ static int lookup_fast(struct nameidata *nd,
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

--Sig_/FH_UnyHIq_V=KHiZi1rVjDK
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU98w9Tnsnt1WYoG5AQIKiA/9HtC731j4zdtAMhKUVmqBuU3+jhaxU0W6
m0atustx0sOPTDXgLXayv7Gk+wgLZhmuKaP2YhyA2gQp5qST+AP9No35wpCmyjAS
rJsBTlUOwQBKEOrL/pB39pdqzCZqTMBz481niXvcTQboAIzezgPZPt3KT7akdHm4
RK6o3ikyLQXFQWt1VLD3Mof4ihOjIBCJTbIm0Jt1T1cKUFJ7Y+VY1+Rr8WzyQs1R
46DBMSIRo+JH3PegWvY1o0Y1AmlJ/eLgrPEM4bikkgdVWQD1jk5NZr3mmng2V1NY
37m+89PlCCe68lDFUXT5oj0RsQeKZ/UIeGT2WlncvjOx6ztLohzlUzPu+JwzR3JX
lGQJ7d/gCDOKzm3+7ENYWlUXkISuyafQkxH/OcA0zd3HSRU3WuzLw8nlxfQtASEh
R47eYFvLk7/CcQbUm46BqX+CbZjn8oG4PHhW6mvrHqRzhPykWO0Atg1efwPwgPVu
LZJQV0kMGpCAcHXFWsAiylsKYfegFH2I+n6/i/2VmYw0UOvBKLWRIV62XhbPYwF/
Eo0vEd0kYtIBgasfs0QjQftQHD87TblvSnJZJeurvQKv4uKOLEmaMoxlhbnIOtFM
gqB3iwq1gn8C2YMWbpEFrEOVmSmD9qX7WkwQxIZ6HVBhss+4V3qJzGAApb8mNcEE
cDNVCTPZ89s=
=P7RO
-----END PGP SIGNATURE-----

--Sig_/FH_UnyHIq_V=KHiZi1rVjDK--
