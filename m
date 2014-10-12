Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751498AbaJLLKC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 07:10:02 -0400
Received: from mx1.polytechnique.org ([129.104.30.34]:52938 "EHLO
	mx1.polytechnique.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbaJLLJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 07:09:57 -0400
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Sun, 12 Oct 2014 07:09:57 EDT
From: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
To: Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        user-mode-linux-devel@lists.sourceforge.net,
        user-mode-linux-user@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] um/os-Linux: Use char[] for syscall_stub declarations
Date: Sun, 12 Oct 2014 13:02:13 +0200
Message-Id: <1413111733-10763-3-git-send-email-nicolas.iooss_linux@m4x.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1413111733-10763-1-git-send-email-nicolas.iooss_linux@m4x.org>
References: <1413111733-10763-1-git-send-email-nicolas.iooss_linux@m4x.org>
X-AV-Checked: ClamAV using ClamSMTP at svoboda.polytechnique.org (Sun Oct 12 13:03:26 2014 +0200 (CEST))
X-Spam-Flag: No, tests=bogofilter, spamicity=0.000000, queueID=2AD6E1408EF01
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When declaring __syscall_stub_start, use the same type in UML userspace
code as in arch/um/include/asm/sections.h.

While at it, also declare batch_syscall_stub as char[].

Signed-off-by: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
---
 arch/um/os-Linux/skas/mem.c     |  6 +++---
 arch/um/os-Linux/skas/process.c | 11 +++++------
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/arch/um/os-Linux/skas/mem.c b/arch/um/os-Linux/skas/mem.c
index 689b18db798f..abb02becca80 100644
--- a/arch/um/os-Linux/skas/mem.c
+++ b/arch/um/os-Linux/skas/mem.c
@@ -19,7 +19,7 @@
 #include <sysdep/ptrace.h>
 #include <sysdep/stub.h>
 
-extern unsigned long batch_syscall_stub, __syscall_stub_start;
+extern char batch_syscall_stub[], __syscall_stub_start[];
 
 extern void wait_stub_done(int pid);
 
@@ -39,8 +39,8 @@ static int __init init_syscall_regs(void)
 {
 	get_safe_registers(syscall_regs, NULL);
 	syscall_regs[REGS_IP_INDEX] = STUB_CODE +
-		((unsigned long) &batch_syscall_stub -
-		 (unsigned long) &__syscall_stub_start);
+		((unsigned long) batch_syscall_stub -
+		 (unsigned long) __syscall_stub_start);
 	return 0;
 }
 
diff --git a/arch/um/os-Linux/skas/process.c b/arch/um/os-Linux/skas/process.c
index 908579f2b0ab..fa934d0c8932 100644
--- a/arch/um/os-Linux/skas/process.c
+++ b/arch/um/os-Linux/skas/process.c
@@ -193,7 +193,7 @@ static void handle_trap(int pid, struct uml_pt_regs *regs,
 	handle_syscall(regs);
 }
 
-extern int __syscall_stub_start;
+extern char __syscall_stub_start[];
 
 static int userspace_tramp(void *stack)
 {
@@ -218,7 +218,7 @@ static int userspace_tramp(void *stack)
 		 */
 		int fd;
 		unsigned long long offset;
-		fd = phys_mapping(to_phys(&__syscall_stub_start), &offset);
+		fd = phys_mapping(to_phys(__syscall_stub_start), &offset);
 		addr = mmap64((void *) STUB_CODE, UM_KERN_PAGE_SIZE,
 			      PROT_EXEC, MAP_FIXED | MAP_PRIVATE, fd, offset);
 		if (addr == MAP_FAILED) {
@@ -245,7 +245,7 @@ static int userspace_tramp(void *stack)
 
 		unsigned long v = STUB_CODE +
 				  (unsigned long) stub_segv_handler -
-				  (unsigned long) &__syscall_stub_start;
+				  (unsigned long) __syscall_stub_start;
 
 		set_sigstack((void *) STUB_DATA, UM_KERN_PAGE_SIZE);
 		sigemptyset(&sa.sa_mask);
@@ -474,7 +474,7 @@ static int __init init_thread_regs(void)
 	/* Set parent's instruction pointer to start of clone-stub */
 	thread_regs[REGS_IP_INDEX] = STUB_CODE +
 				(unsigned long) stub_clone_handler -
-				(unsigned long) &__syscall_stub_start;
+				(unsigned long) __syscall_stub_start;
 	thread_regs[REGS_SP_INDEX] = STUB_DATA + UM_KERN_PAGE_SIZE -
 		sizeof(void *);
 #ifdef __SIGNAL_FRAMESIZE
@@ -582,8 +582,7 @@ int map_stub_pages(int fd, unsigned long code, unsigned long data,
 	struct proc_mm_op mmop;
 	int n;
 	unsigned long long code_offset;
-	int code_fd = phys_mapping(to_phys((void *) &__syscall_stub_start),
-				   &code_offset);
+	int code_fd = phys_mapping(to_phys(__syscall_stub_start), &code_offset);
 
 	mmop = ((struct proc_mm_op) { .op        = MM_MMAP,
 				      .u         =
-- 
2.1.1

