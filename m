Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751423Ab3IGIlh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 04:41:37 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:55591 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091Ab3IGIlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 04:41:35 -0400
Message-ID: <522AE51A.3040103@gmail.com>
Date: Sat, 07 Sep 2013 10:34:34 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: linux-fsdevel@vger.kernel.org
CC: Vladimir Davydov <vdavydov@parallels.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 19/19] pramfs: Kconfig and makefile
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Kconfig and makefile.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---
 fs/Kconfig         |    6 +++-
 fs/Makefile        |    1 +
 fs/pramfs/Kconfig  |   72 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/pramfs/Makefile |   14 ++++++++++
 4 files changed, 91 insertions(+), 2 deletions(-)
 create mode 100644 fs/pramfs/Kconfig
 create mode 100644 fs/pramfs/Makefile

diff --git a/fs/Kconfig b/fs/Kconfig
index c229f82..fd86a48 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -17,7 +17,7 @@ source "fs/ext4/Kconfig"
 config FS_XIP
 # execute in place
 	bool
-	depends on EXT2_FS_XIP
+	depends on EXT2_FS_XIP || PRAMFS_XIP
 	default y
 
 source "fs/jbd/Kconfig"
@@ -29,7 +29,8 @@ config FS_MBCACHE
 	default y if EXT2_FS=y && EXT2_FS_XATTR
 	default y if EXT3_FS=y && EXT3_FS_XATTR
 	default y if EXT4_FS=y
-	default m if EXT2_FS_XATTR || EXT3_FS_XATTR || EXT4_FS
+	default y if PRAMFS=y && PRAMFS_XATTR
+	default m if EXT2_FS_XATTR || EXT3_FS_XATTR || EXT4_FS || PRAMFS_XATTR
 
 source "fs/reiserfs/Kconfig"
 source "fs/jfs/Kconfig"
@@ -209,6 +210,7 @@ source "fs/romfs/Kconfig"
 source "fs/pstore/Kconfig"
 source "fs/sysv/Kconfig"
 source "fs/ufs/Kconfig"
+source "fs/pramfs/Kconfig"
 source "fs/exofs/Kconfig"
 source "fs/f2fs/Kconfig"
 source "fs/efivarfs/Kconfig"
diff --git a/fs/Makefile b/fs/Makefile
index 4fe6df3..f8e70df 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -126,3 +126,4 @@ obj-y				+= exofs/ # Multiple modules
 obj-$(CONFIG_CEPH_FS)		+= ceph/
 obj-$(CONFIG_PSTORE)		+= pstore/
 obj-$(CONFIG_EFIVAR_FS)		+= efivarfs/
+obj-$(CONFIG_PRAMFS)		+= pramfs/
diff --git a/fs/pramfs/Kconfig b/fs/pramfs/Kconfig
new file mode 100644
index 0000000..0ca2402
--- /dev/null
+++ b/fs/pramfs/Kconfig
@@ -0,0 +1,72 @@
+config PRAMFS
+	tristate "Persistent and Protected RAM file system support"
+	depends on HAS_IOMEM
+	select CRC32
+	help
+	   If your system has a block of fast (comparable in access speed to
+	   system memory) and non-volatile RAM and you wish to mount a
+	   light-weight, full-featured, and space-efficient filesystem over it,
+	   say Y here, and read <file:Documentation/filesystems/pramfs.txt>.
+
+	   To compile this as a module,  choose M here: the module will be
+	   called pramfs.
+
+config PRAMFS_XIP
+	bool "Execute-in-place in PRAMFS"
+	depends on PRAMFS && BLOCK
+	help
+	   Say Y here to enable XIP feature of PRAMFS.
+
+config PRAMFS_WRITE_PROTECT
+	bool "PRAMFS write protection"
+	depends on PRAMFS && MMU && HAVE_SET_MEMORY_RO
+	default y
+	help
+	   Say Y here to enable the write protect feature of PRAMFS.
+
+config PRAMFS_XATTR
+	bool "PRAMFS extended attributes"
+	depends on PRAMFS && BLOCK
+	help
+	  Extended attributes are name:value pairs associated with inodes by
+	  the kernel or by users (see the attr(5) manual page, or visit
+	  <http://acl.bestbits.at/> for details).
+
+	  If unsure, say N.
+
+config PRAMFS_POSIX_ACL
+	bool "PRAMFS POSIX Access Control Lists"
+	depends on PRAMFS_XATTR
+	select FS_POSIX_ACL
+	help
+	  Posix Access Control Lists (ACLs) support permissions for users and
+	  groups beyond the owner/group/world scheme.
+
+	  To learn more about Access Control Lists, visit the Posix ACLs for
+	  Linux website <http://acl.bestbits.at/>.
+
+	  If you don't know what Access Control Lists are, say N.
+
+config PRAMFS_SECURITY
+	bool "PRAMFS Security Labels"
+	depends on PRAMFS_XATTR
+	help
+	  Security labels support alternative access control models
+	  implemented by security modules like SELinux.  This option
+	  enables an extended attribute handler for file security
+	  labels in the pram filesystem.
+
+	  If you are not using a security module that requires using
+	  extended attributes for file security labels, say N.
+
+config PRAMFS_TEST
+	boolean
+	depends on PRAMFS
+
+config PRAMFS_TEST_MODULE
+	tristate "PRAMFS Test"
+	depends on PRAMFS && PRAMFS_WRITE_PROTECT && m
+	select PRAMFS_TEST
+	help
+	  Say Y here to build a simple module to test the protection of
+	  PRAMFS. The module will be called pramfs_test.
diff --git a/fs/pramfs/Makefile b/fs/pramfs/Makefile
new file mode 100644
index 0000000..055f0bb
--- /dev/null
+++ b/fs/pramfs/Makefile
@@ -0,0 +1,14 @@
+#
+# Makefile for the linux pram-filesystem routines.
+#
+
+obj-$(CONFIG_PRAMFS) += pramfs.o
+obj-$(CONFIG_PRAMFS_TEST_MODULE) += pramfs_test.o
+
+pramfs-y := balloc.o dir.o file.o inode.o namei.o super.o symlink.o ioctl.o
+
+pramfs-$(CONFIG_PRAMFS_WRITE_PROTECT) += wprotect.o
+pramfs-$(CONFIG_PRAMFS_XIP) += xip.o
+pramfs-$(CONFIG_PRAMFS_XATTR) += xattr.o xattr_user.o xattr_trusted.o desctree.o
+pramfs-$(CONFIG_PRAMFS_POSIX_ACL) += acl.o
+pramfs-$(CONFIG_PRAMFS_SECURITY) += xattr_security.o
-- 
1.7.3.4
