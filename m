Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756747Ab3HRUix (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 16:38:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43746 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756529Ab3HRUfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 16:35:15 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Michal Simek <michal.simek@xilinx.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 04/45] microblaze: fix clone syscall
Date: Sun, 18 Aug 2013 13:35:53 -0700
Message-Id: <20130818203621.300794639@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
In-Reply-To: <20130818203620.996166594@linuxfoundation.org>
References: <20130818203620.996166594@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/Kconfig             |    6 ++++++
 arch/microblaze/Kconfig  |    2 +-
 include/linux/syscalls.h |    5 +++++
 kernel/fork.c            |    6 ++++++
 4 files changed, 18 insertions(+), 1 deletion(-)

--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -404,6 +404,12 @@ config CLONE_BACKWARDS2
 	help
 	  Architecture has the first two arguments of clone(2) swapped.
 
+config CLONE_BACKWARDS3
+	bool
+	help
+	  Architecture has tls passed as the 3rd argument of clone(2),
+	  not the 5th one.
+
 config ODD_RT_SIGACTION
 	bool
 	help
--- a/arch/microblaze/Kconfig
+++ b/arch/microblaze/Kconfig
@@ -28,7 +28,7 @@ config MICROBLAZE
 	select GENERIC_CLOCKEVENTS
 	select GENERIC_IDLE_POLL_SETUP
 	select MODULES_USE_ELF_RELA
-	select CLONE_BACKWARDS
+	select CLONE_BACKWARDS3
 
 config SWAP
 	def_bool n
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -802,9 +802,14 @@ asmlinkage long sys_vfork(void);
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
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1675,6 +1675,12 @@ SYSCALL_DEFINE5(clone, unsigned long, ne
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


