Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755731AbaBGMAg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 07:00:36 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42466 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755291AbaBGLwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:52:32 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 193/233] fs/compat: fix parameter handling for compat readv/writev syscalls
Date: Fri,  7 Feb 2014 11:46:52 +0000
Message-Id: <1391773652-25214-194-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <heiko.carstens@de.ibm.com>

commit dfd948e32af2e7b28bcd7a490c0a30d4b8df2a36 upstream.

We got a report that the pwritev syscall does not work correctly in
compat mode on s390.

It turned out that with commit 72ec35163f9f ("switch compat readv/writev
variants to COMPAT_SYSCALL_DEFINE") we lost the zero extension of a
couple of syscall parameters because the some parameter types haven't
been converted from unsigned long to compat_ulong_t.

This is needed for architectures where the ABI requires that the caller
of a function performed zero and/or sign extension to 64 bit of all
parameters.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/read_write.c        | 16 ++++++++--------
 include/linux/compat.h | 16 ++++++++--------
 2 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 122a384..0bc0e7e 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -980,9 +980,9 @@ out:
 	return ret;
 }
 
-COMPAT_SYSCALL_DEFINE3(readv, unsigned long, fd,
+COMPAT_SYSCALL_DEFINE3(readv, compat_ulong_t, fd,
 		const struct compat_iovec __user *,vec,
-		unsigned long, vlen)
+		compat_ulong_t, vlen)
 {
 	struct fd f = fdget(fd);
 	ssize_t ret;
@@ -1017,9 +1017,9 @@ COMPAT_SYSCALL_DEFINE4(preadv64, unsigned long, fd,
 	return ret;
 }
 
-COMPAT_SYSCALL_DEFINE5(preadv, unsigned long, fd,
+COMPAT_SYSCALL_DEFINE5(preadv, compat_ulong_t, fd,
 		const struct compat_iovec __user *,vec,
-		unsigned long, vlen, u32, pos_low, u32, pos_high)
+		compat_ulong_t, vlen, u32, pos_low, u32, pos_high)
 {
 	loff_t pos = ((loff_t)pos_high << 32) | pos_low;
 	return compat_sys_preadv64(fd, vec, vlen, pos);
@@ -1047,9 +1047,9 @@ out:
 	return ret;
 }
 
-COMPAT_SYSCALL_DEFINE3(writev, unsigned long, fd,
+COMPAT_SYSCALL_DEFINE3(writev, compat_ulong_t, fd,
 		const struct compat_iovec __user *, vec,
-		unsigned long, vlen)
+		compat_ulong_t, vlen)
 {
 	struct fd f = fdget(fd);
 	ssize_t ret;
@@ -1084,9 +1084,9 @@ COMPAT_SYSCALL_DEFINE4(pwritev64, unsigned long, fd,
 	return ret;
 }
 
-COMPAT_SYSCALL_DEFINE5(pwritev, unsigned long, fd,
+COMPAT_SYSCALL_DEFINE5(pwritev, compat_ulong_t, fd,
 		const struct compat_iovec __user *,vec,
-		unsigned long, vlen, u32, pos_low, u32, pos_high)
+		compat_ulong_t, vlen, u32, pos_low, u32, pos_high)
 {
 	loff_t pos = ((loff_t)pos_high << 32) | pos_low;
 	return compat_sys_pwritev64(fd, vec, vlen, pos);
diff --git a/include/linux/compat.h b/include/linux/compat.h
index ec1aee4..caa5385 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -326,16 +326,16 @@ asmlinkage long compat_sys_keyctl(u32 option,
 			      u32 arg2, u32 arg3, u32 arg4, u32 arg5);
 asmlinkage long compat_sys_ustat(unsigned dev, struct compat_ustat __user *u32);
 
-asmlinkage ssize_t compat_sys_readv(unsigned long fd,
-		const struct compat_iovec __user *vec, unsigned long vlen);
-asmlinkage ssize_t compat_sys_writev(unsigned long fd,
-		const struct compat_iovec __user *vec, unsigned long vlen);
-asmlinkage ssize_t compat_sys_preadv(unsigned long fd,
+asmlinkage ssize_t compat_sys_readv(compat_ulong_t fd,
+		const struct compat_iovec __user *vec, compat_ulong_t vlen);
+asmlinkage ssize_t compat_sys_writev(compat_ulong_t fd,
+		const struct compat_iovec __user *vec, compat_ulong_t vlen);
+asmlinkage ssize_t compat_sys_preadv(compat_ulong_t fd,
 		const struct compat_iovec __user *vec,
-		unsigned long vlen, u32 pos_low, u32 pos_high);
-asmlinkage ssize_t compat_sys_pwritev(unsigned long fd,
+		compat_ulong_t vlen, u32 pos_low, u32 pos_high);
+asmlinkage ssize_t compat_sys_pwritev(compat_ulong_t fd,
 		const struct compat_iovec __user *vec,
-		unsigned long vlen, u32 pos_low, u32 pos_high);
+		compat_ulong_t vlen, u32 pos_low, u32 pos_high);
 asmlinkage long comat_sys_lseek(unsigned int, compat_off_t, unsigned int);
 
 asmlinkage long compat_sys_execve(const char __user *filename, const compat_uptr_t __user *argv,
-- 
1.8.3.2

