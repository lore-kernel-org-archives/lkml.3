Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823Ab3CDCVv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 21:21:51 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:49149 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794Ab3CDCVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 21:21:50 -0500
Date: Mon, 4 Mar 2013 13:21:39 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: linux-next: manual merge of the akpm tree with Linus' tree
Message-Id: <20130304132139.f9efee7b45655d9f75abf643@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__4_Mar_2013_13_21_39_+1100_hDWWe2EnhxaeGjC6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__4_Mar_2013_13_21_39_+1100_hDWWe2EnhxaeGjC6
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in mm/shmem.c
between commit 26567cdbbf1a ("fix nommu breakage in shmem.c") from Linus'
tree and commit "shmem-fix-build-regression-fix" from the akpm tree.

I fixed it up (I used the latter version - see the full new version
below) and can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --git a/include/linux/ramfs.h b/include/linux/ramfs.h
index 5bf5500..69e37c2 100644
--- a/include/linux/ramfs.h
+++ b/include/linux/ramfs.h
@@ -6,7 +6,13 @@ struct inode *ramfs_get_inode(struct super_block *sb, cons=
t struct inode *dir,
 extern struct dentry *ramfs_mount(struct file_system_type *fs_type,
 	 int flags, const char *dev_name, void *data);
=20
-#ifndef CONFIG_MMU
+#ifdef CONFIG_MMU
+static inline int
+ramfs_nommu_expand_for_mapping(struct inode *inode, size_t newsize)
+{
+	return 0;
+}
+#else
 extern int ramfs_nommu_expand_for_mapping(struct inode *inode, size_t news=
ize);
 extern unsigned long ramfs_nommu_get_unmapped_area(struct file *file,
 						   unsigned long addr,
diff --git a/mm/shmem.c b/mm/shmem.c
index b863bf3..a8d9da0 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -25,6 +25,7 @@
 #include <linux/init.h>
 #include <linux/vfs.h>
 #include <linux/mount.h>
+#include <linux/ramfs.h>
 #include <linux/pagemap.h>
 #include <linux/file.h>
 #include <linux/mm.h>
@@ -2830,8 +2831,6 @@ out4:
  * effectively equivalent, but much lighter weight.
  */
=20
-#include <linux/ramfs.h>
-
 static struct file_system_type shmem_fs_type =3D {
 	.name		=3D "tmpfs",
 	.mount		=3D ramfs_mount,
@@ -2897,7 +2896,6 @@ static struct dentry_operations anon_ops =3D {
  */
 struct file *shmem_file_setup(const char *name, loff_t size, unsigned long=
 flags)
 {
-	int error;
 	struct file *res;
 	struct inode *inode;
 	struct path path;
@@ -2932,11 +2930,10 @@ struct file *shmem_file_setup(const char *name, lof=
f_t size, unsigned long flags
 	d_instantiate(path.dentry, inode);
 	inode->i_size =3D size;
 	clear_nlink(inode);	/* It is unlinked */
-#ifndef CONFIG_MMU
+
 	res =3D ERR_PTR(ramfs_nommu_expand_for_mapping(inode, size));
 	if (IS_ERR(res))
 		goto put_dentry;
-#endif
=20
 	res =3D alloc_file(&path, FMODE_WRITE | FMODE_READ,
 		  &shmem_file_operations);

--Signature=_Mon__4_Mar_2013_13_21_39_+1100_hDWWe2EnhxaeGjC6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRNAUzAAoJEECxmPOUX5FETUAP/AvvQoW+a2qxKdUUmsyTe9Bu
vnSBTRO8IsyB/cMtXdDHAH4PMhgpcX1JoHtluGYWHax9s5SOg63VkH4gHRSraX9z
s1OIPvvEB6gNZgEmdMEtyHyKJ9ZmfskMW+wYwD9AhzmlslJf61aOvVO92lrILtb4
EV8xkte9bvOHIWp+VFwQv3ADQCV8gvTXyBKS4UV46qmF0IgWzOi5sFKUQMo0kd27
qAN3edQZL/cvS1wjETbhF5imDr6sP4aXHOS0U0Up2U8AVrt5+Mg9OI98hfYbFL8U
USqmbgkkjiUJ6bWWz9+Qn/h7YO+1lSWe303nRen91MubfLrxkIcqlVsQrsMnFvhz
7IV3FxsHZDYDanjMl9KL9mc3jaSJXWkbhTc0VbnO1WX594gnkgnhU0WMwuQ67KDh
Vcnh/zA/hzILlZ5KM9lvdD9AINZPJPL+Znh2vvZbs5Vz1STgnSTKac+N/15cAyFd
WwHEcSJ6pSFvUX2i1g1Ki7GP/RSCNz3X7z7Db6lbx5PCYewCfgwVhK6MPUBlnfP1
0o4GoATBjBtsqY2In1LEDLUe20MgWE4q+aXl4cq8eaUKOmcYotHZTE/0en9eXDed
3s9paeizpaRtgrDAidSJYq2rxhfyfbtGMEEms0VcxNGcJhr/W981TSBg7GC2Rs3O
sQhtjyTzloPtbKLhfi9c
=Pb0o
-----END PGP SIGNATURE-----

--Signature=_Mon__4_Mar_2013_13_21_39_+1100_hDWWe2EnhxaeGjC6--
