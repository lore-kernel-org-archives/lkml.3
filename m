Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970Ab3FWAdT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jun 2013 20:33:19 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26238 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714Ab3FWAdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jun 2013 20:33:18 -0400
X-Authority-Analysis: v=2.0 cv=KtrPKBqN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=2fYCpg9_AZIA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=Re5Bo6QFf7kA:10 a=VwQbUJbxAAAA:8 a=x30EXVXcAAAA:8 a=X1YEgFwZpeexUfqzz8gA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=2F0HLYTCHDIA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1371947597.18733.160.camel@gandalf.local.home>
Subject: [PATCH][GIT PULL] trace,x86: Do not call local_irq_save() in
 load_current_idt()
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Seiji Aguchi <seiji.aguchi@hds.com>
Date: Sat, 22 Jun 2013 20:33:17 -0400
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Sorry for the resend, Evolution warned me about not having an
attachment but didn't warn me about no subject :-p ]

Peter,

As stated, I found the cause of the bug. I made this patch and ran it
through all my tests and it worked fine. I would have sent this out
earlier, but my main server crashed and I had to restart the tests.

Thanks,

-- Steve

Please pull the latest tip/x86/trace tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
tip/x86/trace

Head SHA1: 2b4bc78956bdcc2bb4c49b3af955be776817e897


Steven Rostedt (Red Hat) (1):
      trace,x86: Do not call local_irq_save() in load_current_idt()

----
 arch/x86/include/asm/desc.h  |   10 ++++------
 arch/x86/kernel/tracepoint.c |    4 ++++
 2 files changed, 8 insertions(+), 6 deletions(-)
---------------------------
commit 2b4bc78956bdcc2bb4c49b3af955be776817e897
Author: Steven Rostedt (Red Hat) <rostedt@goodmis.org>
Date:   Sat Jun 22 13:16:19 2013 -0400

    trace,x86: Do not call local_irq_save() in load_current_idt()
    
    As load_current_idt() is now what is used to update the IDT for the
    switches needed for NMI, lockdep debug, and for tracing, it must not
    call local_irq_save(). This is because one of the users of this is
    lockdep, which does tracing of local_irq_save() and when the debug
    trap is hit, we need to update the IDT before tracing interrupts
    being disabled. As load_current_idt() is used to do this, calling
    local_irq_save() which lockdep traces, defeats the point of calling
    load_current_idt().
    
    As interrupts are already disabled when used by lockdep and NMI, the
    only other user is tracing that can disable interrupts itself. Simply
    have the tracing update disable interrupts before calling load_current_idt()
    instead of breaking the other users.
    
    Here's the dump that happened:
    
    ------------[ cut here ]------------
    WARNING: at /work/autotest/nobackup/linux-test.git/kernel/fork.c:1196 copy_process+0x2c3/0x1398()
    DEBUG_LOCKS_WARN_ON(!p->hardirqs_enabled)
    Modules linked in:
    CPU: 1 PID: 4570 Comm: gdm-simple-gree Not tainted 3.10.0-rc3-test+ #5
    Hardware name:                  /DG965MQ, BIOS MQ96510J.86A.0372.2006.0605.1717 06/05/2006
     ffffffff81d2a7a5 ffff88006ed13d50 ffffffff8192822b ffff88006ed13d90
     ffffffff81035f25 ffff8800721c6000 ffff88006ed13da0 0000000001200011
     0000000000000000 ffff88006ed5e000 ffff8800721c6000 ffff88006ed13df0
    Call Trace:
     [<ffffffff8192822b>] dump_stack+0x19/0x1b
     [<ffffffff81035f25>] warn_slowpath_common+0x67/0x80
     [<ffffffff81035fe1>] warn_slowpath_fmt+0x46/0x48
     [<ffffffff812bfc5d>] ? __raw_spin_lock_init+0x31/0x52
     [<ffffffff810341f7>] copy_process+0x2c3/0x1398
     [<ffffffff8103539d>] do_fork+0xa8/0x260
     [<ffffffff810ca7b1>] ? trace_preempt_on+0x2a/0x2f
     [<ffffffff812afb3e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
     [<ffffffff81937fe7>] ? sysret_check+0x1b/0x56
     [<ffffffff81937fe7>] ? sysret_check+0x1b/0x56
     [<ffffffff810355cf>] SyS_clone+0x16/0x18
     [<ffffffff81938369>] stub_clone+0x69/0x90
     [<ffffffff81937fc2>] ? system_call_fastpath+0x16/0x1b
    ---[ end trace 8b157a9d20ca1aa2 ]---
    
    in fork.c:
    
     #ifdef CONFIG_PROVE_LOCKING
    	DEBUG_LOCKS_WARN_ON(!p->hardirqs_enabled); <-- bug here
    	DEBUG_LOCKS_WARN_ON(!p->softirqs_enabled);
     #endif
    
    Cc: Seiji Aguchi <seiji.aguchi@hds.com>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/arch/x86/include/asm/desc.h b/arch/x86/include/asm/desc.h
index 1377ecb..b90e5df 100644
--- a/arch/x86/include/asm/desc.h
+++ b/arch/x86/include/asm/desc.h
@@ -497,21 +497,19 @@ static inline void load_trace_idt(void)
 #endif
 
 /*
- * the load_current_idt() is called with interrupt disabled by local_irq_save()
+ * The load_current_idt() must be called with interrupts disabled
  * to avoid races. That way the IDT will always be set back to the expected
- * descriptor.
+ * descriptor. It's also called when a CPU is being initialized, and
+ * that doesn't need to disable interrupts, as nothing should be
+ * bothering the CPU then.
  */
 static inline void load_current_idt(void)
 {
-	unsigned long flags;
-
-	local_irq_save(flags);
 	if (is_debug_idt_enabled())
 		load_debug_idt();
 	else if (is_trace_idt_enabled())
 		load_trace_idt();
 	else
 		load_idt((const struct desc_ptr *)&idt_descr);
-	local_irq_restore(flags);
 }
 #endif /* _ASM_X86_DESC_H */
diff --git a/arch/x86/kernel/tracepoint.c b/arch/x86/kernel/tracepoint.c
index 1423efe..4e584a8 100644
--- a/arch/x86/kernel/tracepoint.c
+++ b/arch/x86/kernel/tracepoint.c
@@ -29,7 +29,11 @@ static void set_trace_idt_ctr(int val)
 
 static void switch_idt(void *arg)
 {
+	unsigned long flags;
+
+	local_irq_save(flags);
 	load_current_idt();
+	local_irq_restore(flags);
 }
 
 void trace_irq_vector_regfunc(void)



