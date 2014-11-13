Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934738AbaKMVcK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 16:32:10 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:33752 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934245AbaKMVcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 16:32:06 -0500
From: Pieter Smith <pieter@boesman.nl>
To: pieter@boesman.nl
Cc: Josh Triplett <josh@joshtriplett.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jeff Layton <jlayton@poochiereds.net>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Minchan Kim <minchan@kernel.org>, Fabian Frederick <fabf@skynet.be>,
        Randy Dunlap <rdunlap@infradead.org>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org (open list),
        linux-fsdevel@vger.kernel.org
Subject: [PATCH 56/56] fs/splice: full support for compiling out splice
Date: Thu, 13 Nov 2014 22:23:33 +0100
Message-Id: <1415913813-362-57-git-send-email-pieter@boesman.nl>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415913813-362-1-git-send-email-pieter@boesman.nl>
References: <pieter@boesman.nl>
 <1415913813-362-1-git-send-email-pieter@boesman.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Entirely compile out splice translation unit when the system is configured
without splice family of syscalls (i.e. CONFIG_SYSCALL_SPLICE is undefined).

add/remove: 0/26 grow/shrink: 0/22 up/down: 0/-5001 (-5001)
function                                     old     new   delta
generic_pipe_buf_nosteal                       6       -      -6
zero_fops                                    116     108      -8
urandom_fops                                 116     108      -8
simple_dir_operations                        116     108      -8
random_fops                                  116     108      -8
ramfs_file_operations                        116     108      -8
posix_clock_file_operations                  116     108      -8
pm_qos_power_fops                            116     108      -8
pipefifo_fops                                116     108      -8
perf_fops                                    116     108      -8
null_fops                                    116     108      -8
misc_fops                                    116     108      -8
memory_fops                                  116     108      -8
mem_fops                                     116     108      -8
generic_ro_fops                              116     108      -8
full_fops                                    116     108      -8
def_chr_fops                                 116     108      -8
def_blk_fops                                 116     108      -8
bad_sock_fops                                116     108      -8
bad_file_ops                                 116     108      -8
spd_release_page                              10       -     -10
PageUptodate                                  22      11     -11
lock_page                                     36      24     -12
page_cache_pipe_buf_release                   16       -     -16
empty_fops                                   232     216     -16
page_cache_pipe_buf_ops                       20       -     -20
nosteal_pipe_buf_ops                          20       -     -20
default_pipe_buf_ops                          20       -     -20
generic_splice_sendpage                       24       -     -24
splice_shrink_spd                             27       -     -27
direct_splice_actor                           47       -     -47
default_file_splice_write                     49       -     -49
wakeup_pipe_writers                           54       -     -54
write_pipe_buf                                71       -     -71
page_cache_pipe_buf_confirm                   80       -     -80
splice_grow_spd                               87       -     -87
splice_from_pipe                              93       -     -93
splice_from_pipe_next                        106       -    -106
pipe_to_sendpage                             109       -    -109
page_cache_pipe_buf_steal                    114       -    -114
generic_file_splice_read                     131       -    -131
do_splice_direct                             148       -    -148
__splice_from_pipe                           246       -    -246
splice_direct_to_actor                       416       -    -416
splice_to_pipe                               417       -    -417
default_file_splice_read                     688       -    -688
iter_file_splice_write                       702       -    -702
__generic_file_splice_read                  1109       -   -1109

Signed-off-by: Pieter Smith <pieter@boesman.nl>
---
 drivers/block/Kconfig  | 1 +
 fs/Makefile            | 4 +++-
 fs/splice.c            | 2 --
 include/linux/fs.h     | 4 ++++
 include/linux/splice.h | 3 +++
 5 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index 014a1cf..804125ea 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -210,6 +210,7 @@ config BLK_DEV_COW_COMMON
 
 config BLK_DEV_LOOP
 	tristate "Loopback device support"
+	depends on SYSCALL_SPLICE
 	---help---
 	  Saying Y here will allow you to use a regular file as a block
 	  device; you can then create a file system on that block device and
diff --git a/fs/Makefile b/fs/Makefile
index 90c8852..13f9cfa 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -10,7 +10,7 @@ obj-y :=	open.o read_write.o file_table.o super.o \
 		ioctl.o readdir.o select.o dcache.o inode.o \
 		attr.o bad_inode.o file.o filesystems.o namespace.o \
 		seq_file.o xattr.o libfs.o fs-writeback.o \
-		pnode.o splice.o sync.o utimes.o \
+		pnode.o sync.o utimes.o \
 		stack.o fs_struct.o statfs.o fs_pin.o
 
 ifeq ($(CONFIG_BLOCK),y)
@@ -21,6 +21,8 @@ endif
 
 obj-$(CONFIG_PROC_FS) += proc_namespace.o
 
+obj-$(CONFIG_SYSCALL_SPLICE)	+= splice.o
+
 obj-y				+= notify/
 obj-$(CONFIG_EPOLL)		+= eventpoll.o
 obj-$(CONFIG_ANON_INODES)	+= anon_inodes.o
diff --git a/fs/splice.c b/fs/splice.c
index 7c4c695..44b201b 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1316,7 +1316,6 @@ long do_splice_direct(struct file *in, loff_t *ppos, struct file *out,
 	return ret;
 }
 
-#ifdef CONFIG_SYSCALL_SPLICE
 static int splice_pipe_to_pipe(struct pipe_inode_info *ipipe,
 			       struct pipe_inode_info *opipe,
 			       size_t len, unsigned int flags);
@@ -2201,5 +2200,4 @@ COMPAT_SYSCALL_DEFINE4(sendfile64, int, out_fd, int, in_fd,
 	return do_sendfile(out_fd, in_fd, NULL, count, 0);
 }
 #endif
-#endif
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index a88de9f..5d6b759 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1504,8 +1504,10 @@ struct file_operations {
 	unsigned long (*get_unmapped_area)(struct file *, unsigned long, unsigned long, unsigned long, unsigned long);
 	int (*check_flags)(int);
 	int (*flock) (struct file *, int, struct file_lock *);
+#ifdef CONFIG_SYSCALL_SPLICE
 	ssize_t (*splice_write)(struct pipe_inode_info *, struct file *, loff_t *, size_t, unsigned int);
 	ssize_t (*splice_read)(struct file *, loff_t *, struct pipe_inode_info *, size_t, unsigned int);
+#endif /* #ifdef CONFIG_SYSCALL_SPLICE */
 	int (*setlease)(struct file *, long, struct file_lock **);
 	long (*fallocate)(struct file *file, int mode, loff_t offset,
 			  loff_t len);
@@ -2486,6 +2488,7 @@ extern int blkdev_fsync(struct file *filp, loff_t start, loff_t end,
 			int datasync);
 extern void block_sync_page(struct page *page);
 
+#ifdef CONFIG_SYSCALL_SPLICE
 /* fs/splice.c */
 extern ssize_t generic_file_splice_read(struct file *, loff_t *,
 		struct pipe_inode_info *, size_t, unsigned int);
@@ -2495,6 +2498,7 @@ extern ssize_t iter_file_splice_write(struct pipe_inode_info *,
 		struct file *, loff_t *, size_t, unsigned int);
 extern ssize_t generic_splice_sendpage(struct pipe_inode_info *pipe,
 		struct file *out, loff_t *, size_t len, unsigned int flags);
+#endif
 
 extern void
 file_ra_state_init(struct file_ra_state *ra, struct address_space *mapping);
diff --git a/include/linux/splice.h b/include/linux/splice.h
index da2751d..ecd176f 100644
--- a/include/linux/splice.h
+++ b/include/linux/splice.h
@@ -10,6 +10,7 @@
 
 #include <linux/pipe_fs_i.h>
 
+#ifdef CONFIG_SYSCALL_SPLICE
 /*
  * Flags passed in from splice/tee/vmsplice
  */
@@ -83,4 +84,6 @@ extern void splice_shrink_spd(struct splice_pipe_desc *);
 extern void spd_release_page(struct splice_pipe_desc *, unsigned int);
 
 extern const struct pipe_buf_operations page_cache_pipe_buf_ops;
+#endif /* #ifdef CONFIG_SYSCALL_SPLICE */
+
 #endif
-- 
1.9.1

