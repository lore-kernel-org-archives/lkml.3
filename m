Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814AbaKSOcn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 09:32:43 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:63053 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006AbaKSOcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 09:32:42 -0500
Date: Wed, 19 Nov 2014 15:29:39 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: Andy Whitcroft <apw@canonical.com>
Cc: Serge Hallyn <serge.hallyn@ubuntu.com>, Neil Brown <neilb@suse.de>,
        linux-unionfs@vger.kernel.org,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: How to cope with two incompatible overlayfs formats out in the
 wild
Message-ID: <20141119142939.GA1915@tucsk>
References: <CAJfpegtG68g=dDi7j-WfhkuJidZRBg46vyuWg8CTrW3TrW_nYw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegtG68g=dDi7j-WfhkuJidZRBg46vyuWg8CTrW3TrW_nYw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2014 at 03:28:03PM +0100, Miklos Szeredi wrote:
> If we'd have a different filesystem type for the old and new formats,
> then that would solve both (checking /proc/filesystems would indicate
> which one is supported).
> 
> Unfortunately that would mean having to change "overlayfs" type to
> something else in 3.18.  Question is, is there some sane name which
> would fit?  "overlayfs2" is perhaps the best, but I'm not overly
> enthusiastic about it.

How 'bout just "overlay"?

Minimal patch follows.

I'd be happy to rename "fs/overlayfs" to "fs/overlay" and
"Documentation/filesystems/overlayfs.txt" to
"Documentation/filesystems/overlay.txt" as well, but that should be a separate
patch that just does renames and nothing else.

Thanks,
Miklos
----

Subject: ovl: rename filesystem type to "overlay"
From: Miklos Szeredi <mszeredi@suse.cz>

Some distributions carry an "old" format of overlayfs while mainline has a
"new" format.

The distros will possibly want to keep the old overlayfs alongside the new
for compatibility reasons.

To make it possible to differentiate the two versions change the name of
the new one from "overlayfs" to "overlay".

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Reported-by: Serge Hallyn <serge.hallyn@ubuntu.com>
Cc: Andy Whitcroft <apw@canonical.com>
---
 Documentation/filesystems/overlayfs.txt |    2 +-
 MAINTAINERS                             |    2 +-
 fs/Makefile                             |    2 +-
 fs/overlayfs/Kconfig                    |    2 +-
 fs/overlayfs/Makefile                   |    4 ++--
 fs/overlayfs/super.c                    |    6 +++---
 6 files changed, 9 insertions(+), 9 deletions(-)

--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -24,7 +24,7 @@ MODULE_AUTHOR("Miklos Szeredi <miklos@sz
 MODULE_DESCRIPTION("Overlay filesystem");
 MODULE_LICENSE("GPL");
 
-#define OVERLAYFS_SUPER_MAGIC 0x794c764f
+#define OVERLAYFS_SUPER_MAGIC 0x794c7630
 
 struct ovl_config {
 	char *lowerdir;
@@ -776,11 +776,11 @@ static struct dentry *ovl_mount(struct f
 
 static struct file_system_type ovl_fs_type = {
 	.owner		= THIS_MODULE,
-	.name		= "overlayfs",
+	.name		= "overlay",
 	.mount		= ovl_mount,
 	.kill_sb	= kill_anon_super,
 };
-MODULE_ALIAS_FS("overlayfs");
+MODULE_ALIAS_FS("overlay");
 
 static int __init ovl_init(void)
 {
--- a/Documentation/filesystems/overlayfs.txt
+++ b/Documentation/filesystems/overlayfs.txt
@@ -64,7 +64,7 @@ is formed.
 At mount time, the two directories given as mount options "lowerdir" and
 "upperdir" are combined into a merged directory:
 
-  mount -t overlayfs overlayfs -olowerdir=/lower,upperdir=/upper,\
+  mount -t overlay overlay -olowerdir=/lower,upperdir=/upper,\
 workdir=/work /merged
 
 The "workdir" needs to be an empty directory on the same filesystem
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6888,7 +6888,7 @@ F:	drivers/scsi/osd/
 F:	include/scsi/osd_*
 F:	fs/exofs/
 
-OVERLAYFS FILESYSTEM
+OVERLAY FILESYSTEM
 M:	Miklos Szeredi <miklos@szeredi.hu>
 L:	linux-fsdevel@vger.kernel.org
 S:	Supported
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -104,7 +104,7 @@ obj-$(CONFIG_QNX6FS_FS)		+= qnx6/
 obj-$(CONFIG_AUTOFS4_FS)	+= autofs4/
 obj-$(CONFIG_ADFS_FS)		+= adfs/
 obj-$(CONFIG_FUSE_FS)		+= fuse/
-obj-$(CONFIG_OVERLAYFS_FS)	+= overlayfs/
+obj-$(CONFIG_OVERLAY_FS)	+= overlayfs/
 obj-$(CONFIG_UDF_FS)		+= udf/
 obj-$(CONFIG_SUN_OPENPROMFS)	+= openpromfs/
 obj-$(CONFIG_OMFS_FS)		+= omfs/
--- a/fs/overlayfs/Kconfig
+++ b/fs/overlayfs/Kconfig
@@ -1,4 +1,4 @@
-config OVERLAYFS_FS
+config OVERLAY_FS
 	tristate "Overlay filesystem support"
 	help
 	  An overlay filesystem combines two filesystems - an 'upper' filesystem
--- a/fs/overlayfs/Makefile
+++ b/fs/overlayfs/Makefile
@@ -2,6 +2,6 @@
 # Makefile for the overlay filesystem.
 #
 
-obj-$(CONFIG_OVERLAYFS_FS) += overlayfs.o
+obj-$(CONFIG_OVERLAY_FS) += overlay.o
 
-overlayfs-objs := super.o inode.o dir.o readdir.o copy_up.o
+overlay-objs := super.o inode.o dir.o readdir.o copy_up.o
