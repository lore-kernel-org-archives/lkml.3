Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932304Ab3CMHae (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 03:30:34 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:44528 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755188Ab3CMHaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 03:30:30 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Cristian =?utf-8?Q?Rodr=C3=ADguez?= <crrodriguez@opensuse.org>,
        Steve French <smfrench@gmail.com>,
        Arthur Marsh <arthur.marsh@internode.on.net>
Date: Wed, 13 Mar 2013 00:30:18 -0700
Message-ID: <871ubjpxit.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+SZYS883qJq6YAokfnSvNVQWwLGcDy5YI=
X-SA-Exim-Connect-IP: 208.54.5.161
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.3091]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.0 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Linus Torvalds <torvalds@linux-foundation.org>
X-Spam-Relay-Country: 
Subject: [GIT PULL] mount namespace bug fixes 
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

Please pull the for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/user-namespace.git for-linus

   HEAD: fa7614ddd6c2368b8cd54cc67ab4b767af0a2a50 fs: Readd the fs module aliases.

This tree includes a partial revert for "fs: Limit sys_mount to only
request filesystem modules." When I added the new style module aliases
to the filesystems I deleted the old ones.  A bad move.   It turns out
that distributions like Arch linux use module aliases when constructing
ramdisks.  Which meant ultimately that an ext3 filesystem mounted with
ext4 would not result in the ext4 module being put into the ramdisk.

The other change in this tree adds a handful of filesystem module alias
I simply failed to add the first time.  Which inconvinienced a few folks
using cifs.

I don't want to inconvinience folks any longer than I have to so here
are these trivial fixes.

Eric W. Biederman (2):
      fs: Limit sys_mount to only request filesystem modules. (Part 3)
      fs: Readd the fs module aliases.

 fs/cifs/cifsfs.c         |    1 +
 fs/ext4/super.c          |    2 ++
 fs/freevxfs/vxfs_super.c |    1 +
 fs/hostfs/hostfs_kern.c  |    1 +
 fs/hpfs/super.c          |    1 +
 fs/isofs/inode.c         |    1 +
 fs/nfs/super.c           |    1 +
 fs/squashfs/super.c      |    1 +
 fs/sysv/super.c          |    1 +
 fs/udf/super.c           |    1 +
 net/sunrpc/rpc_pipe.c    |    1 +
 11 files changed, 12 insertions(+), 0 deletions(-)
---
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 1a052c0..3cf8a15 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -777,6 +777,7 @@ struct file_system_type cifs_fs_type = {
 	.kill_sb = cifs_kill_sb,
 	/*  .fs_flags */
 };
+MODULE_ALIAS_FS("cifs");
 const struct inode_operations cifs_dir_inode_ops = {
 	.create = cifs_create,
 	.atomic_open = cifs_atomic_open,
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 34e8552..b3818b4 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -91,6 +91,7 @@ static struct file_system_type ext2_fs_type = {
 	.fs_flags	= FS_REQUIRES_DEV,
 };
 MODULE_ALIAS_FS("ext2");
+MODULE_ALIAS("ext2");
 #define IS_EXT2_SB(sb) ((sb)->s_bdev->bd_holder == &ext2_fs_type)
 #else
 #define IS_EXT2_SB(sb) (0)
@@ -106,6 +107,7 @@ static struct file_system_type ext3_fs_type = {
 	.fs_flags	= FS_REQUIRES_DEV,
 };
 MODULE_ALIAS_FS("ext3");
+MODULE_ALIAS("ext3");
 #define IS_EXT3_SB(sb) ((sb)->s_bdev->bd_holder == &ext3_fs_type)
 #else
 #define IS_EXT3_SB(sb) (0)
diff --git a/fs/freevxfs/vxfs_super.c b/fs/freevxfs/vxfs_super.c
index 4550743..e37eb27 100644
--- a/fs/freevxfs/vxfs_super.c
+++ b/fs/freevxfs/vxfs_super.c
@@ -258,6 +258,7 @@ static struct file_system_type vxfs_fs_type = {
 	.fs_flags	= FS_REQUIRES_DEV,
 };
 MODULE_ALIAS_FS("vxfs"); /* makes mount -t vxfs autoload the module */
+MODULE_ALIAS("vxfs");
 
 static int __init
 vxfs_init(void)
diff --git a/fs/hostfs/hostfs_kern.c b/fs/hostfs/hostfs_kern.c
index fbabb90..e3c6d50 100644
--- a/fs/hostfs/hostfs_kern.c
+++ b/fs/hostfs/hostfs_kern.c
@@ -993,6 +993,7 @@ static struct file_system_type hostfs_type = {
 	.kill_sb	= hostfs_kill_sb,
 	.fs_flags 	= 0,
 };
+MODULE_ALIAS_FS("hostfs");
 
 static int __init init_hostfs(void)
 {
diff --git a/fs/hpfs/super.c b/fs/hpfs/super.c
index a307622..a0617e7 100644
--- a/fs/hpfs/super.c
+++ b/fs/hpfs/super.c
@@ -688,6 +688,7 @@ static struct file_system_type hpfs_fs_type = {
 	.kill_sb	= kill_block_super,
 	.fs_flags	= FS_REQUIRES_DEV,
 };
+MODULE_ALIAS_FS("hpfs");
 
 static int __init init_hpfs_fs(void)
 {
diff --git a/fs/isofs/inode.c b/fs/isofs/inode.c
index a67f16e..d9b8aeb 100644
--- a/fs/isofs/inode.c
+++ b/fs/isofs/inode.c
@@ -1557,6 +1557,7 @@ static struct file_system_type iso9660_fs_type = {
 	.fs_flags	= FS_REQUIRES_DEV,
 };
 MODULE_ALIAS_FS("iso9660");
+MODULE_ALIAS("iso9660");
 
 static int __init init_iso9660_fs(void)
 {
diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index 95cdcb2..2f8a29d 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -335,6 +335,7 @@ struct file_system_type nfs4_fs_type = {
 	.fs_flags	= FS_RENAME_DOES_D_MOVE|FS_BINARY_MOUNTDATA,
 };
 MODULE_ALIAS_FS("nfs4");
+MODULE_ALIAS("nfs4");
 EXPORT_SYMBOL_GPL(nfs4_fs_type);
 
 static int __init register_nfs4_fs(void)
diff --git a/fs/squashfs/super.c b/fs/squashfs/super.c
index 260e392..60553a9 100644
--- a/fs/squashfs/super.c
+++ b/fs/squashfs/super.c
@@ -489,6 +489,7 @@ static struct file_system_type squashfs_fs_type = {
 	.kill_sb = kill_block_super,
 	.fs_flags = FS_REQUIRES_DEV
 };
+MODULE_ALIAS_FS("squashfs");
 
 static const struct super_operations squashfs_super_ops = {
 	.alloc_inode = squashfs_alloc_inode,
diff --git a/fs/sysv/super.c b/fs/sysv/super.c
index a39938b..d0c6a00 100644
--- a/fs/sysv/super.c
+++ b/fs/sysv/super.c
@@ -555,6 +555,7 @@ static struct file_system_type v7_fs_type = {
 	.fs_flags	= FS_REQUIRES_DEV,
 };
 MODULE_ALIAS_FS("v7");
+MODULE_ALIAS("v7");
 
 static int __init init_sysv_fs(void)
 {
diff --git a/fs/udf/super.c b/fs/udf/super.c
index bc5b30a..9ac4057 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -118,6 +118,7 @@ static struct file_system_type udf_fstype = {
 	.kill_sb	= kill_block_super,
 	.fs_flags	= FS_REQUIRES_DEV,
 };
+MODULE_ALIAS_FS("udf");
 
 static struct kmem_cache *udf_inode_cachep;
 
diff --git a/net/sunrpc/rpc_pipe.c b/net/sunrpc/rpc_pipe.c
index a0f48a5..a9129f8 100644
--- a/net/sunrpc/rpc_pipe.c
+++ b/net/sunrpc/rpc_pipe.c
@@ -1175,6 +1175,7 @@ static struct file_system_type rpc_pipe_fs_type = {
 	.kill_sb	= rpc_kill_sb,
 };
 MODULE_ALIAS_FS("rpc_pipefs");
+MODULE_ALIAS("rpc_pipefs");
 
 static void
 init_once(void *foo)

