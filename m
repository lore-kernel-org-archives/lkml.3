Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886AbaA0NV4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 08:21:56 -0500
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:49023 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753850AbaA0NVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 08:21:52 -0500
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH 1/3] fs/compat: fix parameter handling for compat readv/writev syscalls
Date: Mon, 27 Jan 2014 14:21:43 +0100
Message-Id: <1390828905-52245-2-git-send-email-heiko.carstens@de.ibm.com>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1390828905-52245-1-git-send-email-heiko.carstens@de.ibm.com>
References: <1390828905-52245-1-git-send-email-heiko.carstens@de.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14012713-4966-0000-0000-000008304C84
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We got a report that the pwritev syscall does not work correctly in compat
mode on s390.

It turned out that with 72ec35163f9f "switch compat readv/writev variants
to COMPAT_SYSCALL_DEFINE" we lost the zero extension of a couple of syscall
parameters because the some parameter types haven't been converted from
unsigned long to compat_ulong_t.

This is needed for architectures where the ABI requires that the caller of
a function performed zero and/or sign extension to 64 bit of all parameters.

Cc: stable@vger.kernel.org # v3.10+
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 fs/read_write.c        | 16 ++++++++--------
 include/linux/compat.h | 16 ++++++++--------
 2 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 1193ffd03565..edc5746a902a 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -964,9 +964,9 @@ out:
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
@@ -1001,9 +1001,9 @@ COMPAT_SYSCALL_DEFINE4(preadv64, unsigned long, fd,
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
@@ -1031,9 +1031,9 @@ out:
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
@@ -1068,9 +1068,9 @@ COMPAT_SYSCALL_DEFINE4(pwritev64, unsigned long, fd,
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
index eb8a49d75ab3..c5642b83e02b 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -327,16 +327,16 @@ asmlinkage long compat_sys_keyctl(u32 option,
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
1.8.4.5

