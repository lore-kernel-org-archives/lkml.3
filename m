Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753009AbaKVVCT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 16:02:19 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:36995 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960AbaKVVCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 16:02:15 -0500
From: Pieter Smith <pieter@boesman.nl>
To: pieter@boesman.nl
Cc: Josh Triplett <josh@joshtriplett.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jeff Layton <jlayton@poochiereds.net>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 6/6] fs/splice: full support for compiling out splice
Date: Sat, 22 Nov 2014 22:00:01 +0100
Message-Id: <1416690001-20817-7-git-send-email-pieter@boesman.nl>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416690001-20817-1-git-send-email-pieter@boesman.nl>
References: <1416690001-20817-1-git-send-email-pieter@boesman.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Entirely compile out splice translation unit when the system is configured
without splice family of syscalls (i.e. CONFIG_SYSCALL_SPLICE is undefined).

add/remove: 0/25 grow/shrink: 0/5 up/down: 0/-4845 (-4845)
function                                     old     new   delta
pipe_to_null                                   4       -      -4
generic_pipe_buf_nosteal                       6       -      -6
spd_release_page                              10       -     -10
PageUptodate                                  22      11     -11
lock_page                                     36      24     -12
page_cache_pipe_buf_release                   16       -     -16
splice_write_null                             24       4     -20
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
generic_file_splice_read                     131       8    -123
do_splice_direct                             148       -    -148
__splice_from_pipe                           246       -    -246
splice_direct_to_actor                       416       -    -416
splice_to_pipe                               417       -    -417
default_file_splice_read                     688       -    -688
iter_file_splice_write                       702       4    -698
__generic_file_splice_read                  1109       -   -1109

Signed-off-by: Pieter Smith <pieter@boesman.nl>
---
 fs/Makefile            |  3 ++-
 fs/splice.c            |  2 --
 include/linux/fs.h     | 26 ++++++++++++++++++++++++++
 include/linux/splice.h | 43 +++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 71 insertions(+), 3 deletions(-)

diff --git a/fs/Makefile b/fs/Makefile
index fb7646e..9395622 100644
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
@@ -22,6 +22,7 @@ endif
 obj-$(CONFIG_PROC_FS) += proc_namespace.o
 
 obj-$(CONFIG_FSNOTIFY)		+= notify/
+obj-$(CONFIG_SYSCALL_SPLICE)	+= splice.o
 obj-$(CONFIG_EPOLL)		+= eventpoll.o
 obj-$(CONFIG_ANON_INODES)	+= anon_inodes.o
 obj-$(CONFIG_SIGNALFD)		+= signalfd.o
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
index 04c0975..9b3054e 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2449,6 +2449,7 @@ extern void block_sync_page(struct page *page);
 #define __splice_p(x) NULL
 #endif
 
+#ifdef CONFIG_SYSCALL_SPLICE
 /* fs/splice.c */
 extern ssize_t generic_file_splice_read(struct file *, loff_t *,
 		struct pipe_inode_info *, size_t, unsigned int);
@@ -2458,6 +2459,31 @@ extern ssize_t iter_file_splice_write(struct pipe_inode_info *,
 		struct file *, loff_t *, size_t, unsigned int);
 extern ssize_t generic_splice_sendpage(struct pipe_inode_info *pipe,
 		struct file *out, loff_t *, size_t len, unsigned int flags);
+#else
+static inline ssize_t generic_file_splice_read(struct file *in, loff_t *ppos,
+		struct pipe_inode_info *pipe, size_t len, unsigned int flags)
+{
+	return -EPERM;
+}
+
+static inline ssize_t default_file_splice_read(struct file *in, loff_t *ppos,
+		struct pipe_inode_info *pipe, size_t len, unsigned int flags)
+{
+	return -EPERM;
+}
+
+static inline ssize_t iter_file_splice_write(struct pipe_inode_info *pipe,
+		struct file *out, loff_t *ppos, size_t len, unsigned int flags)
+{
+	return -EPERM;
+}
+
+static inline ssize_t generic_splice_sendpage(struct pipe_inode_info *pipe,
+		struct file *out, loff_t *ppos, size_t len, unsigned int flags)
+{
+	return -EPERM;
+}
+#endif
 
 extern void
 file_ra_state_init(struct file_ra_state *ra, struct address_space *mapping);
diff --git a/include/linux/splice.h b/include/linux/splice.h
index da2751d..50ca77f 100644
--- a/include/linux/splice.h
+++ b/include/linux/splice.h
@@ -65,6 +65,7 @@ typedef int (splice_actor)(struct pipe_inode_info *, struct pipe_buffer *,
 typedef int (splice_direct_actor)(struct pipe_inode_info *,
 				  struct splice_desc *);
 
+#ifdef CONFIG_SYSCALL_SPLICE
 extern ssize_t splice_from_pipe(struct pipe_inode_info *, struct file *,
 				loff_t *, size_t, unsigned int,
 				splice_actor *);
@@ -74,13 +75,55 @@ extern ssize_t splice_to_pipe(struct pipe_inode_info *,
 			      struct splice_pipe_desc *);
 extern ssize_t splice_direct_to_actor(struct file *, struct splice_desc *,
 				      splice_direct_actor *);
+#else /* #ifdef CONFIG_SYSCALL_SPLICE */
+static inline ssize_t splice_from_pipe(struct pipe_inode_info *pipe, struct file *out,
+			 loff_t *ppos, size_t len, unsigned int flags,
+			 splice_actor *actor)
+{
+	return -EPERM;
+}
+
+static inline ssize_t __splice_from_pipe(struct pipe_inode_info *pipe, struct splice_desc *sd,
+			   splice_actor *actor)
+{
+	return -EPERM;
+}
+
+static inline ssize_t splice_to_pipe(struct pipe_inode_info *pipe,
+		       struct splice_pipe_desc *spd)
+{
+	return -EPERM;
+}
+
+static inline ssize_t splice_direct_to_actor(struct file *in, struct splice_desc *sd,
+			       splice_direct_actor *actor)
+{
+	return -EPERM;
+}
+#endif /* #ifdef CONFIG_SYSCALL_SPLICE */
 
 /*
  * for dynamic pipe sizing
  */
+#ifdef CONFIG_SYSCALL_SPLICE
 extern int splice_grow_spd(const struct pipe_inode_info *, struct splice_pipe_desc *);
 extern void splice_shrink_spd(struct splice_pipe_desc *);
 extern void spd_release_page(struct splice_pipe_desc *, unsigned int);
+#else /* #ifdef CONFIG_SYSCALL_SPLICE */
+static inline int splice_grow_spd(const struct pipe_inode_info *pipe, struct splice_pipe_desc *spd)
+{
+	return -EPERM;
+}
+
+static inline void splice_shrink_spd(struct splice_pipe_desc *spd)
+{
+}
+
+static inline void spd_release_page(struct splice_pipe_desc *spd, unsigned int i)
+{
+}
+#endif /* #ifdef CONFIG_SYSCALL_SPLICE */
 
 extern const struct pipe_buf_operations page_cache_pipe_buf_ops;
+
 #endif
-- 
1.9.1

