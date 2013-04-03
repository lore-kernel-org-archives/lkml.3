Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762502Ab3DCMcZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 08:32:25 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:60922 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759574Ab3DCMcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 08:32:24 -0400
Date: Wed, 03 Apr 2013 07:32:21 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [RFC] rootmpfs
To: linux-kernel@vger.kernel.org
References: <1364992208.18069.18@driftwood>
In-Reply-To: <1364992208.18069.18@driftwood> (from rob@landley.net on Wed
	Apr  3 07:30:08 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1364992341.18069.19@driftwood>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-Zpt+bwX210o4fGYkF7To"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-Zpt+bwX210o4fGYkF7To
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 04/03/2013 07:30:08 AM, Rob Landley wrote:
> Attached is my quick and dirty hack to make rootfs be tmpfs when =20
> CONFIG_TMPFS is
> enabled.

For a somewhat quantum definition of "attached".

Rob=

--=-Zpt+bwX210o4fGYkF7To
Content-Type: text/x-patch; charset=us-ascii; name=rootmpfs2.patch
Content-Disposition: attachment; filename=rootmpfs2.patch
Content-Transfer-Encoding: quoted-printable

diff --git a/fs/ramfs/inode.c b/fs/ramfs/inode.c
index c24f1e1..f875bf2 100644
--- a/fs/ramfs/inode.c
+++ b/fs/ramfs/inode.c
@@ -244,10 +244,17 @@ struct dentry *ramfs_mount(struct file_system_type *f=
s_type,
 	return mount_nodev(fs_type, flags, data, ramfs_fill_super);
 }
=20
-static struct dentry *rootfs_mount(struct file_system_type *fs_type,
+int shmem_init(void);
+int shmem_fill_super(struct super_block *sb, void *data, int silent);
+static __init struct dentry *rootfs_mount(struct file_system_type *fs_type=
,
 	int flags, const char *dev_name, void *data)
 {
+#ifdef CONFIG_TMPFS
+	if (shmem_init()) return NULL;
+	return mount_nodev(fs_type, flags, data, shmem_fill_super);
+#else
 	return mount_nodev(fs_type, flags|MS_NOUSER, data, ramfs_fill_super);
+#endif
 }
=20
 static void ramfs_kill_sb(struct super_block *sb)
diff --git a/mm/shmem.c b/mm/shmem.c
index 1c44af7..d2cb93e 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2785,6 +2785,8 @@ int __init shmem_init(void)
 {
 	int error;
=20
+	if (shmem_inode_cachep) return 0;
+
 	error =3D bdi_init(&shmem_backing_dev_info);
 	if (error)
 		goto out4;
=

--=-Zpt+bwX210o4fGYkF7To--
