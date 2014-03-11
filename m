Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496AbaCKVlz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 17:41:55 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:33738 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697AbaCKVly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 17:41:54 -0400
X-Originating-IP: 98.158.13.34
Date: Tue, 11 Mar 2014 14:41:41 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Alok Kataria <akataria@vmware.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Chris Wright <chrisw@sous-sol.org>,
        David Vrabel <david.vrabel@citrix.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>, Jiri Slaby <jslaby@suse.cz>,
        Kees Cook <keescook@chromium.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, x86@kernel.org,
        xen-devel@lists.xenproject.org
Subject: [PATCHv2 1/3] x86: process: Unify 32-bit and 64-bit copy_thread I/O
 bitmap handling
Message-ID: <36375e1f113abf53ebfcac87a4275a5efd9d8057.1394573469.git.josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 32-bit and 64-bit versions of copy_thread have functionally
identical handling for copying the I/O bitmap, modulo differences in
error handling.  Clean up the error paths in both by moving the copy of
the I/O bitmap to the end, to eliminate the need to free it if
subsequent copy steps fail; move the resulting identical code to a
static inline in a common header.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Acked-by: Kees Cook <keescook@chromium.org>
---
v2: Rebased and updated for changes to copy_thread; no other changes in
    patch 1/3.

 arch/x86/kernel/process-io.h | 22 ++++++++++++++++++++++
 arch/x86/kernel/process_32.c | 28 ++++++++--------------------
 arch/x86/kernel/process_64.c | 25 +++++--------------------
 3 files changed, 35 insertions(+), 40 deletions(-)
 create mode 100644 arch/x86/kernel/process-io.h

diff --git a/arch/x86/kernel/process-io.h b/arch/x86/kernel/process-io.h
new file mode 100644
index 0000000..d884444
--- /dev/null
+++ b/arch/x86/kernel/process-io.h
@@ -0,0 +1,22 @@
+#ifndef _X86_KERNEL_PROCESS_IO_H
+#define _X86_KERNEL_PROCESS_IO_H
+
+static inline int copy_io_bitmap(struct task_struct *me,
+				 struct task_struct *p)
+{
+	if (unlikely(test_tsk_thread_flag(me, TIF_IO_BITMAP))) {
+		p->thread.io_bitmap_ptr = kmemdup(me->thread.io_bitmap_ptr,
+						  IO_BITMAP_BYTES, GFP_KERNEL);
+		if (!p->thread.io_bitmap_ptr) {
+			p->thread.io_bitmap_max = 0;
+			return -ENOMEM;
+		}
+		set_tsk_thread_flag(p, TIF_IO_BITMAP);
+	} else {
+		p->thread.io_bitmap_ptr = NULL;
+	}
+
+	return 0;
+}
+
+#endif /* _X86_KERNEL_PROCESS_IO_H */
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 0de43e9..73a38c8 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -55,6 +55,8 @@
 #include <asm/debugreg.h>
 #include <asm/switch_to.h>
 
+#include "process-io.h"
+
 asmlinkage void ret_from_fork(void) __asm__("ret_from_fork");
 asmlinkage void ret_from_kernel_thread(void) __asm__("ret_from_kernel_thread");
 
@@ -134,7 +136,6 @@ int copy_thread(unsigned long clone_flags, unsigned long sp,
 {
 	struct pt_regs *childregs = task_pt_regs(p);
 	struct task_struct *tsk;
-	int err;
 
 	p->thread.sp = (unsigned long) childregs;
 	p->thread.sp0 = (unsigned long) (childregs+1);
@@ -168,34 +169,21 @@ int copy_thread(unsigned long clone_flags, unsigned long sp,
 	p->thread.fpu_counter = 0;
 	p->thread.io_bitmap_ptr = NULL;
 	tsk = current;
-	err = -ENOMEM;
 
 	memset(p->thread.ptrace_bps, 0, sizeof(p->thread.ptrace_bps));
 
-	if (unlikely(test_tsk_thread_flag(tsk, TIF_IO_BITMAP))) {
-		p->thread.io_bitmap_ptr = kmemdup(tsk->thread.io_bitmap_ptr,
-						IO_BITMAP_BYTES, GFP_KERNEL);
-		if (!p->thread.io_bitmap_ptr) {
-			p->thread.io_bitmap_max = 0;
-			return -ENOMEM;
-		}
-		set_tsk_thread_flag(p, TIF_IO_BITMAP);
-	}
-
-	err = 0;
-
 	/*
 	 * Set a new TLS for the child thread?
 	 */
-	if (clone_flags & CLONE_SETTLS)
+	if (clone_flags & CLONE_SETTLS) {
+		int err;
 		err = do_set_thread_area(p, -1,
 			(struct user_desc __user *)childregs->si, 0);
-
-	if (err && p->thread.io_bitmap_ptr) {
-		kfree(p->thread.io_bitmap_ptr);
-		p->thread.io_bitmap_max = 0;
+		if(err)
+			return err;
 	}
-	return err;
+
+	return copy_io_bitmap(tsk, p);
 }
 
 void
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 9c0280f..3b8f17c 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -50,6 +50,8 @@
 #include <asm/debugreg.h>
 #include <asm/switch_to.h>
 
+#include "process-io.h"
+
 asmlinkage extern void ret_from_fork(void);
 
 asmlinkage DEFINE_PER_CPU(unsigned long, old_rsp);
@@ -154,7 +156,6 @@ static inline u32 read_32bit_tls(struct task_struct *t, int tls)
 int copy_thread(unsigned long clone_flags, unsigned long sp,
 		unsigned long arg, struct task_struct *p)
 {
-	int err;
 	struct pt_regs *childregs;
 	struct task_struct *me = current;
 
@@ -192,23 +193,13 @@ int copy_thread(unsigned long clone_flags, unsigned long sp,
 	if (sp)
 		childregs->sp = sp;
 
-	err = -ENOMEM;
 	memset(p->thread.ptrace_bps, 0, sizeof(p->thread.ptrace_bps));
 
-	if (unlikely(test_tsk_thread_flag(me, TIF_IO_BITMAP))) {
-		p->thread.io_bitmap_ptr = kmemdup(me->thread.io_bitmap_ptr,
-						  IO_BITMAP_BYTES, GFP_KERNEL);
-		if (!p->thread.io_bitmap_ptr) {
-			p->thread.io_bitmap_max = 0;
-			return -ENOMEM;
-		}
-		set_tsk_thread_flag(p, TIF_IO_BITMAP);
-	}
-
 	/*
 	 * Set a new TLS for the child thread?
 	 */
 	if (clone_flags & CLONE_SETTLS) {
+		int err;
 #ifdef CONFIG_IA32_EMULATION
 		if (test_thread_flag(TIF_IA32))
 			err = do_set_thread_area(p, -1,
@@ -217,16 +208,10 @@ int copy_thread(unsigned long clone_flags, unsigned long sp,
 #endif
 			err = do_arch_prctl(p, ARCH_SET_FS, childregs->r8);
 		if (err)
-			goto out;
-	}
-	err = 0;
-out:
-	if (err && p->thread.io_bitmap_ptr) {
-		kfree(p->thread.io_bitmap_ptr);
-		p->thread.io_bitmap_max = 0;
+			return err;
 	}
 
-	return err;
+	return copy_io_bitmap(me, p);
 }
 
 static void
-- 
1.9.0

