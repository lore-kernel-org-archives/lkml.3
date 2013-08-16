Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756300Ab3HPWiw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 18:38:52 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51544 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753619Ab3HPWit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:38:49 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Michal Simek <michal.simek@xilinx.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 120/133] microblaze: fix clone syscall
Date: Fri, 16 Aug 2013 15:34:22 -0700
Message-Id: <1376692475-28413-121-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376692475-28413-1-git-send-email-kamal@canonical.com>
References: <1376692475-28413-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Simek <michal.simek@xilinx.com>

commit dfa9771a7c4784bafd0673bc7abcee3813088b77 upstream.

Fix inadvertent breakage in the clone syscall ABI for Microblaze that
was introduced in commit f3268edbe6fe ("microblaze: switch to generic
fork/vfork/clone").

The Microblaze syscall ABI for clone takes the parent tid address in the
4th argument; the third argument slot is used for the stack size.  The
incorrectly-used CLONE_BACKWARDS type assigned parent tid to the 3rd
slot.

This commit restores the original ABI so that existing userspace libc
code will work correctly.

All kernel versions from v3.8-rc1 were affected.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/Kconfig             | 6 ++++++
 arch/microblaze/Kconfig  | 2 +-
 include/linux/syscalls.h | 5 +++++
 kernel/fork.c            | 6 ++++++
 4 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 7f8f281..acb6d03 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -373,4 +373,10 @@ config CLONE_BACKWARDS2
 	help
 	  Architecture has the first two arguments of clone(2) swapped.
 
+config CLONE_BACKWARDS3
+	bool
+	help
+	  Architecture has tls passed as the 3rd argument of clone(2),
+	  not the 5th one.
+
 source "kernel/gcov/Kconfig"
diff --git a/arch/microblaze/Kconfig b/arch/microblaze/Kconfig
index ba3b7c8..458991c 100644
--- a/arch/microblaze/Kconfig
+++ b/arch/microblaze/Kconfig
@@ -26,7 +26,7 @@ config MICROBLAZE
 	select GENERIC_ATOMIC64
 	select GENERIC_CLOCKEVENTS
 	select MODULES_USE_ELF_RELA
-	select CLONE_BACKWARDS
+	select CLONE_BACKWARDS3
 
 config SWAP
 	def_bool n
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 45e2db2..2ce3071 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -839,9 +839,14 @@ asmlinkage long sys_vfork(void);
 asmlinkage long sys_clone(unsigned long, unsigned long, int __user *, int,
 	       int __user *);
 #else
+#ifdef CONFIG_CLONE_BACKWARDS3
+asmlinkage long sys_clone(unsigned long, unsigned long, int, int __user *,
+			  int __user *, int);
+#else
 asmlinkage long sys_clone(unsigned long, unsigned long, int __user *,
 	       int __user *, int);
 #endif
+#endif
 
 asmlinkage long sys_execve(const char __user *filename,
 		const char __user *const __user *argv,
diff --git a/kernel/fork.c b/kernel/fork.c
index 5630e52..1c53e38 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1664,6 +1664,12 @@ SYSCALL_DEFINE5(clone, unsigned long, newsp, unsigned long, clone_flags,
 		 int __user *, parent_tidptr,
 		 int __user *, child_tidptr,
 		 int, tls_val)
+#elif defined(CONFIG_CLONE_BACKWARDS3)
+SYSCALL_DEFINE6(clone, unsigned long, clone_flags, unsigned long, newsp,
+		int, stack_size,
+		int __user *, parent_tidptr,
+		int __user *, child_tidptr,
+		int, tls_val)
 #else
 SYSCALL_DEFINE5(clone, unsigned long, clone_flags, unsigned long, newsp,
 		 int __user *, parent_tidptr,
-- 
1.8.1.2

