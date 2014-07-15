Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756944AbaGORIE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 13:08:04 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:46392 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755947AbaGORCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 13:02:21 -0400
From: Sam Asadi <asadi.samuel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Helge Deller <deller@gmx.de>, sam-the-6 <asadi.samuel@gmail.com>
Subject: [PATCH 85/94] parisc: fix fanotify_mark() syscall on 32bit compat kernel
Date: Tue, 15 Jul 2014 20:01:40 +0300
Message-Id: <1405443709-15288-85-git-send-email-asadi.samuel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
References: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Helge Deller <deller@gmx.de>

On parisc we can not use the existing compat implementation for fanotify_mark()
because for the 64bit mask parameter the higher and lower 32bits are ordered
differently than what the compat function expects from big endian
architectures.

Specifically:
It finally turned out, that on hppa we end up with different assignments
of parameters to kernel arguments depending on if we call the glibc
wrapper function
 int fanotify_mark (int __fanotify_fd, unsigned int __flags,
                    uint64_t __mask, int __dfd, const char *__pathname);
or directly calling the syscall manually
 syscall(__NR_fanotify_mark, ...)

Reason is, that the syscall() function is implemented as C-function and
because we now have the sysno as first parameter in front of the other
parameters the compiler will unexpectedly add an empty paramenter in
front of the u64 value to ensure the correct calling alignment for 64bit
values.
This means, on hppa you can't simply use syscall() to call the kernel
fanotify_mark() function directly, but you have to use the glibc
function instead.

This patch fixes the kernel in the hppa-arch specifc coding to adjust
the parameters in a way as if userspace calls the glibc wrapper function
fanotify_mark().

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: stable@vger.kernel.org # 3.13+
Signed-off-by: sam-the-6 <asadi.samuel@gmail.com>
---
 arch/parisc/kernel/sys_parisc32.c  |   10 ++++++++++
 arch/parisc/kernel/syscall_table.S |    2 +-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/parisc/kernel/sys_parisc32.c b/arch/parisc/kernel/sys_parisc32.c
index bb9f3b6..ec741fe 100644
--- a/arch/parisc/kernel/sys_parisc32.c
+++ b/arch/parisc/kernel/sys_parisc32.c
@@ -4,6 +4,7 @@
  * Copyright (C) 2000-2001 Hewlett Packard Company
  * Copyright (C) 2000 John Marvin
  * Copyright (C) 2001 Matthew Wilcox
+ * Copyright (C) 2014 Helge Deller <deller@gmx.de>
  *
  * These routines maintain argument size conversion between 32bit and 64bit
  * environment. Based heavily on sys_ia32.c and sys_sparc32.c.
@@ -57,3 +58,12 @@ asmlinkage long sys32_unimplemented(int r26, int r25, int r24, int r23,
     	current->comm, current->pid, r20);
     return -ENOSYS;
 }
+
+asmlinkage long sys32_fanotify_mark(compat_int_t fanotify_fd, compat_uint_t flags,
+	compat_uint_t mask0, compat_uint_t mask1, compat_int_t dfd,
+	const char  __user * pathname)
+{
+	return sys_fanotify_mark(fanotify_fd, flags,
+			((__u64)mask1 << 32) | mask0,
+			 dfd, pathname);
+}
diff --git a/arch/parisc/kernel/syscall_table.S b/arch/parisc/kernel/syscall_table.S
index c5fa7a6..84c5d3a 100644
--- a/arch/parisc/kernel/syscall_table.S
+++ b/arch/parisc/kernel/syscall_table.S
@@ -418,7 +418,7 @@
 	ENTRY_SAME(accept4)		/* 320 */
 	ENTRY_SAME(prlimit64)
 	ENTRY_SAME(fanotify_init)
-	ENTRY_COMP(fanotify_mark)
+	ENTRY_DIFF(fanotify_mark)
 	ENTRY_COMP(clock_adjtime)
 	ENTRY_SAME(name_to_handle_at)	/* 325 */
 	ENTRY_COMP(open_by_handle_at)
-- 
1.7.10.4

