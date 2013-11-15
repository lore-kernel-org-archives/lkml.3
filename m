Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758306Ab3KOEy1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 23:54:27 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:57639 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758181Ab3KOEyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 23:54:01 -0500
X-AuditID: 85900ec0-d3b2cb9000001514-ed-5285a8e39e44
Subject: [PATCH -tip RFC v2 13/22] x86/trap: Use NOKPROBE_SYMBOL macro in
 trap.c
To: Ingo Molnar <mingo@kernel.org>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-arch@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        virtualization@lists.linux-foundation.org,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Fri, 15 Nov 2013 04:53:54 +0000
Message-ID: <20131115045354.27580.84725.stgit@kbuild-fedora.novalocal>
In-Reply-To: <20131115045312.27580.95902.stgit@kbuild-fedora.novalocal>
References: <20131115045312.27580.95902.stgit@kbuild-fedora.novalocal>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use NOKPROBE_SYMBOL macro to protect functions from kprobes
instead of __kprobes annotation in trap.c.
This also applies __always_inline annotation for some cases,
because NOKPROBE_SYMBOL() will inhibit inlining by referring
the symbol address.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/x86/include/asm/traps.h |    2 +-
 arch/x86/kernel/traps.c      |   20 +++++++++++++-------
 2 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/traps.h b/arch/x86/include/asm/traps.h
index 58d66fe..ca32508 100644
--- a/arch/x86/include/asm/traps.h
+++ b/arch/x86/include/asm/traps.h
@@ -68,7 +68,7 @@ dotraplinkage void do_segment_not_present(struct pt_regs *, long);
 dotraplinkage void do_stack_segment(struct pt_regs *, long);
 #ifdef CONFIG_X86_64
 dotraplinkage void do_double_fault(struct pt_regs *, long);
-asmlinkage __kprobes struct pt_regs *sync_regs(struct pt_regs *);
+asmlinkage struct pt_regs *sync_regs(struct pt_regs *);
 #endif
 dotraplinkage void do_general_protection(struct pt_regs *, long);
 dotraplinkage void do_page_fault(struct pt_regs *, unsigned long);
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index ce24c24..e751e3b 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -106,7 +106,7 @@ static inline void preempt_conditional_cli(struct pt_regs *regs)
 	preempt_count_dec();
 }
 
-static int __kprobes
+static __always_inline int
 do_trap_no_signal(struct task_struct *tsk, int trapnr, char *str,
 		  struct pt_regs *regs,	long error_code)
 {
@@ -136,7 +136,7 @@ do_trap_no_signal(struct task_struct *tsk, int trapnr, char *str,
 	return -1;
 }
 
-static void __kprobes
+static void
 do_trap(int trapnr, int signr, char *str, struct pt_regs *regs,
 	long error_code, siginfo_t *info)
 {
@@ -173,6 +173,7 @@ do_trap(int trapnr, int signr, char *str, struct pt_regs *regs,
 	else
 		force_sig(signr, tsk);
 }
+NOKPROBE_SYMBOL(do_trap);
 
 #define DO_ERROR(trapnr, signr, str, name)				\
 dotraplinkage void do_##name(struct pt_regs *regs, long error_code)	\
@@ -267,7 +268,7 @@ dotraplinkage void do_double_fault(struct pt_regs *regs, long error_code)
 }
 #endif
 
-dotraplinkage void __kprobes
+dotraplinkage void
 do_general_protection(struct pt_regs *regs, long error_code)
 {
 	struct task_struct *tsk;
@@ -313,9 +314,10 @@ do_general_protection(struct pt_regs *regs, long error_code)
 exit:
 	exception_exit(prev_state);
 }
+NOKPROBE_SYMBOL(do_general_protection);
 
 /* May run on IST stack. */
-dotraplinkage void __kprobes notrace do_int3(struct pt_regs *regs, long error_code)
+dotraplinkage void notrace do_int3(struct pt_regs *regs, long error_code)
 {
 	enum ctx_state prev_state;
 
@@ -354,6 +356,7 @@ dotraplinkage void __kprobes notrace do_int3(struct pt_regs *regs, long error_co
 exit:
 	exception_exit(prev_state);
 }
+NOKPROBE_SYMBOL(do_int3);
 
 #ifdef CONFIG_X86_64
 /*
@@ -361,7 +364,7 @@ exit:
  * for scheduling or signal handling. The actual stack switch is done in
  * entry.S
  */
-asmlinkage __kprobes struct pt_regs *sync_regs(struct pt_regs *eregs)
+asmlinkage struct pt_regs *sync_regs(struct pt_regs *eregs)
 {
 	struct pt_regs *regs = eregs;
 	/* Did already sync */
@@ -380,6 +383,7 @@ asmlinkage __kprobes struct pt_regs *sync_regs(struct pt_regs *eregs)
 		*regs = *eregs;
 	return regs;
 }
+NOKPROBE_SYMBOL(sync_regs);
 #endif
 
 /*
@@ -406,7 +410,7 @@ asmlinkage __kprobes struct pt_regs *sync_regs(struct pt_regs *eregs)
  *
  * May run on IST stack.
  */
-dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
+dotraplinkage void do_debug(struct pt_regs *regs, long error_code)
 {
 	struct task_struct *tsk = current;
 	enum ctx_state prev_state;
@@ -486,6 +490,7 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 exit:
 	exception_exit(prev_state);
 }
+NOKPROBE_SYMBOL(do_debug);
 
 /*
  * Note that we play around with the 'TS' bit in an attempt to get
@@ -657,7 +662,7 @@ void math_state_restore(void)
 }
 EXPORT_SYMBOL_GPL(math_state_restore);
 
-dotraplinkage void __kprobes
+dotraplinkage void
 do_device_not_available(struct pt_regs *regs, long error_code)
 {
 	enum ctx_state prev_state;
@@ -683,6 +688,7 @@ do_device_not_available(struct pt_regs *regs, long error_code)
 #endif
 	exception_exit(prev_state);
 }
+NOKPROBE_SYMBOL(do_device_not_available);
 
 #ifdef CONFIG_X86_32
 dotraplinkage void do_iret_error(struct pt_regs *regs, long error_code)

