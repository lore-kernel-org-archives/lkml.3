Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057AbaIOUUy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 16:20:54 -0400
Received: from mail-qa0-f52.google.com ([209.85.216.52]:52725 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755070AbaIOUUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 16:20:50 -0400
Date: Mon, 15 Sep 2014 16:20:37 -0400
From: Milosz Tanski <milosz@adfin.com>
To: linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org, Mel Gorman <mgorman@suse.de>,
        Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>,
        Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH 2/7] Define new syscalls readv2,preadv2,writev2,pwritev2
Message-ID: <057d758976db2fcce58e394abaa0d55e48cdeec1.1410810247.git.milosz@adfin.com>
References: <cover.1410810247.git.milosz@adfin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1410810247.git.milosz@adfin.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New syscalls with an extra flag argument. For now all flags except for 0 are
not supported.

Signed-off-by: Milosz Tanski <milosz@adfin.com>
---
 fs/read_write.c                   |  100 +++++++++++++++++++++++++++++++++++++
 include/linux/syscalls.h          |   12 +++++
 include/uapi/asm-generic/unistd.h |   10 +++-
 3 files changed, 121 insertions(+), 1 deletion(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 4747247..6c5030a 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -902,6 +902,29 @@ SYSCALL_DEFINE3(readv, unsigned long, fd, const struct iovec __user *, vec,
 	return ret;
 }
 
+SYSCALL_DEFINE4(readv2, unsigned long, fd, const struct iovec __user *, vec,
+		unsigned long, vlen, int, flags)
+{
+	struct fd f = fdget_pos(fd);
+	ssize_t ret = -EBADF;
+
+	if (flags & ~0)
+		return -EINVAL;
+
+	if (f.file) {
+		loff_t pos = file_pos_read(f.file);
+		ret = vfs_readv(f.file, vec, vlen, &pos, flags);
+		if (ret >= 0)
+			file_pos_write(f.file, pos);
+		fdput_pos(f);
+	}
+
+	if (ret > 0)
+		add_rchar(current, ret);
+	inc_syscr(current);
+	return ret;
+}
+
 SYSCALL_DEFINE3(writev, unsigned long, fd, const struct iovec __user *, vec,
 		unsigned long, vlen)
 {
@@ -922,6 +945,29 @@ SYSCALL_DEFINE3(writev, unsigned long, fd, const struct iovec __user *, vec,
 	return ret;
 }
 
+SYSCALL_DEFINE4(writev2, unsigned long, fd, const struct iovec __user *, vec,
+		unsigned long, vlen, int, flags)
+{
+	struct fd f = fdget_pos(fd);
+	ssize_t ret = -EBADF;
+
+	if (flags & ~0)
+		return -EINVAL;
+
+	if (f.file) {
+		loff_t pos = file_pos_read(f.file);
+		ret = vfs_writev(f.file, vec, vlen, &pos, flags);
+		if (ret >= 0)
+			file_pos_write(f.file, pos);
+		fdput_pos(f);
+	}
+
+	if (ret > 0)
+		add_wchar(current, ret);
+	inc_syscw(current);
+	return ret;
+}
+
 static inline loff_t pos_from_hilo(unsigned long high, unsigned long low)
 {
 #define HALF_LONG_BITS (BITS_PER_LONG / 2)
@@ -952,6 +998,33 @@ SYSCALL_DEFINE5(preadv, unsigned long, fd, const struct iovec __user *, vec,
 	return ret;
 }
 
+SYSCALL_DEFINE6(preadv2, unsigned long, fd, const struct iovec __user *, vec,
+		unsigned long, vlen, unsigned long, pos_l, unsigned long, pos_h,
+		int, flags)
+{
+	loff_t pos = pos_from_hilo(pos_h, pos_l);
+	struct fd f;
+	ssize_t ret = -EBADF;
+
+	if (flags & ~0)
+		return -EINVAL;
+	if (pos < 0)
+		return -EINVAL;
+
+	f = fdget(fd);
+	if (f.file) {
+		ret = -ESPIPE;
+		if (f.file->f_mode & FMODE_PREAD)
+			ret = vfs_readv(f.file, vec, vlen, &pos, flags);
+		fdput(f);
+	}
+
+	if (ret > 0)
+		add_rchar(current, ret);
+	inc_syscr(current);
+	return ret;
+}
+
 SYSCALL_DEFINE5(pwritev, unsigned long, fd, const struct iovec __user *, vec,
 		unsigned long, vlen, unsigned long, pos_l, unsigned long, pos_h)
 {
@@ -976,6 +1049,33 @@ SYSCALL_DEFINE5(pwritev, unsigned long, fd, const struct iovec __user *, vec,
 	return ret;
 }
 
+SYSCALL_DEFINE6(pwritev2, unsigned long, fd, const struct iovec __user *, vec,
+		unsigned long, vlen, unsigned long, pos_l, unsigned long, pos_h,
+		int, flags)
+{
+	loff_t pos = pos_from_hilo(pos_h, pos_l);
+	struct fd f;
+	ssize_t ret = -EBADF;
+
+	if (flags & ~0)
+		return -EINVAL;
+	if (pos < 0)
+		return -EINVAL;
+
+	f = fdget(fd);
+	if (f.file) {
+		ret = -ESPIPE;
+		if (f.file->f_mode & FMODE_PWRITE)
+			ret = vfs_writev(f.file, vec, vlen, &pos, flags);
+		fdput(f);
+	}
+
+	if (ret > 0)
+		add_wchar(current, ret);
+	inc_syscw(current);
+	return ret;
+}
+
 #ifdef CONFIG_COMPAT
 
 static ssize_t compat_do_readv_writev(int type, struct file *file,
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 0f86d85..0c49ae4 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -559,19 +559,31 @@ asmlinkage long sys_readahead(int fd, loff_t offset, size_t count);
 asmlinkage long sys_readv(unsigned long fd,
 			  const struct iovec __user *vec,
 			  unsigned long vlen);
+asmlinkage long sys_readv2(unsigned long fd,
+			  const struct iovec __user *vec,
+			  unsigned long vlen, int flags);
 asmlinkage long sys_write(unsigned int fd, const char __user *buf,
 			  size_t count);
 asmlinkage long sys_writev(unsigned long fd,
 			   const struct iovec __user *vec,
 			   unsigned long vlen);
+asmlinkage long sys_writev2(unsigned long fd,
+			    const struct iovec __user *vec,
+			    unsigned long vlen, int flags);
 asmlinkage long sys_pread64(unsigned int fd, char __user *buf,
 			    size_t count, loff_t pos);
 asmlinkage long sys_pwrite64(unsigned int fd, const char __user *buf,
 			     size_t count, loff_t pos);
 asmlinkage long sys_preadv(unsigned long fd, const struct iovec __user *vec,
 			   unsigned long vlen, unsigned long pos_l, unsigned long pos_h);
+asmlinkage long sys_preadv2(unsigned long fd, const struct iovec __user *vec,
+			    unsigned long vlen, unsigned long pos_l, unsigned long pos_h,
+			    int flags);
 asmlinkage long sys_pwritev(unsigned long fd, const struct iovec __user *vec,
 			    unsigned long vlen, unsigned long pos_l, unsigned long pos_h);
+asmlinkage long sys_pwritev2(unsigned long fd, const struct iovec __user *vec,
+			    unsigned long vlen, unsigned long pos_l, unsigned long pos_h,
+			    int flags);
 asmlinkage long sys_getcwd(char __user *buf, unsigned long size);
 asmlinkage long sys_mkdir(const char __user *pathname, umode_t mode);
 asmlinkage long sys_chdir(const char __user *filename);
diff --git a/include/uapi/asm-generic/unistd.h b/include/uapi/asm-generic/unistd.h
index 11d11bc..75ad687 100644
--- a/include/uapi/asm-generic/unistd.h
+++ b/include/uapi/asm-generic/unistd.h
@@ -213,6 +213,14 @@ __SC_COMP(__NR_pwrite64, sys_pwrite64, compat_sys_pwrite64)
 __SC_COMP(__NR_preadv, sys_preadv, compat_sys_preadv)
 #define __NR_pwritev 70
 __SC_COMP(__NR_pwritev, sys_pwritev, compat_sys_pwritev)
+#define __NR_readv2 280
+__SC_COMP(__NR_readv2, sys_readv2)
+#define __NR_writev2 281
+__SC_COMP(__NR_writev2, sys_writev2)
+#define __NR_preadv2 282
+__SC_COMP(__NR_preadv2, sys_preadv2)
+#define __NR_pwritev2 283
+__SC_COMP(__NR_pwritev2, sys_pwritev2)
 
 /* fs/sendfile.c */
 #define __NR3264_sendfile 71
@@ -707,7 +715,7 @@ __SYSCALL(__NR_getrandom, sys_getrandom)
 __SYSCALL(__NR_memfd_create, sys_memfd_create)
 
 #undef __NR_syscalls
-#define __NR_syscalls 280
+#define __NR_syscalls 284
 
 /*
  * All syscalls below here should go away really,
-- 
1.7.9.5

