Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933395AbaHHU5u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 16:57:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41482 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933093AbaHHUyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:54:15 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Helge Deller <deller@gmx.de>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 104/259] parisc: fix fanotify_mark() syscall on 32bit compat kernel
Date: Fri,  8 Aug 2014 13:38:47 -0700
Message-Id: <1407530482-4483-105-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@gmx.de>

commit ab8a261ba5e2dd9206da640de5870cc31d568a7c upstream.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/parisc/kernel/sys_parisc32.c  | 10 ++++++++++
 arch/parisc/kernel/syscall_table.S |  2 +-
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
index 10a0c2a..486a600 100644
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
1.9.1

