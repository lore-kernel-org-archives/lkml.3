Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758508AbaLJXff (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 18:35:35 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:40367 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758395AbaLJXfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 18:35:08 -0500
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: mingo@redhat.com, peterz@infradead.org
Cc: tglx@linutronix.de, hpa@zytor.com, konrad.wilk@oracle.com,
        david.vrabel@citrix.com, masami.hiramatsu.pt@hitachi.com,
        rostedt@goodmis.org, luto@amacapital.net, JBeulich@suse.com,
        jgross@suse.com, bpoirier@suse.de, x86@kernel.org,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        "Luis R. Rodriguez" <mcgrof@suse.com>, Borislav Petkov <bp@suse.de>
Subject: [PATCH v2 2/2] x86/xen: allow privcmd hypercalls to be preempted
Date: Wed, 10 Dec 2014 15:34:47 -0800
Message-Id: <1418254487-9988-3-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1418254487-9988-1-git-send-email-mcgrof@do-not-panic.com>
References: <1418254487-9988-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@suse.com>

Xen has support for splitting heavy work work into a series
of hypercalls, called multicalls, and preempting them through
what Xen calls continuation [0]. Despite this though without
CONFIG_PREEMPT preemption won't happen and while enabling
CONFIG_RT_GROUP_SCHED can at times help its not enough to
make a system usable. Such is the case for example when
creating a > 50 GiB HVM guest, we can get softlockups [1] with:.

kernel: [  802.084335] BUG: soft lockup - CPU#1 stuck for 22s! [xend:31351]

The softlock up triggers on the TASK_UNINTERRUPTIBLE hanger check
(default 120 seconds), on the Xen side in this particular case
this happens when the following Xen hypervisor code is used:

xc_domain_set_pod_target() -->
  do_memory_op() -->
    arch_memory_op() -->
      p2m_pod_set_mem_target()
	-- long delay (real or emulated) --

This happens on arch_memory_op() on the XENMEM_set_pod_target memory
op even though arch_memory_op() can handle continuation via
hypercall_create_continuation() for example.

Machines over 50 GiB of memory are on high demand and hard to come
by so to help replicate this sort of issue long delays on select
hypercalls have been emulated in order to be able to test this on
smaller machines [2].

On one hand this issue can be considered as expected given that
CONFIG_PREEMPT=n is used however we have forced voluntary preemption
precedent practices in the kernel even for CONFIG_PREEMPT=n through
the usage of cond_resched() sprinkled in many places. To address
this issue with Xen hypercalls though we need to find a way to aid
to the schedular in the middle of hypercalls. We are motivated to
address this issue on CONFIG_PREEMPT=n as otherwise the system becomes
rather unresponsive for long periods of time; in the worst case, at least
only currently by emulating long delays on select io disk bound
hypercalls, this can lead to filesystem corruption if the delay happens
for example on SCHEDOP_remote_shutdown (when we call 'xl <domain> shutdown').

We can address this problem by trying to check if we should schedule
on the xen timer in the middle of a hypercall on the return from the
timer interrupt. We want to be careful to not always force voluntary
preemption though so to do this we only selectively enable preemption
on very specific xen hypercalls.

This enables hypercall preemption by selectively forcing checks for
voluntary preempting only on ioctl initiated private hypercalls
where we know some folks have run into reported issues [1].

[0] http://xenbits.xen.org/gitweb/?p=xen.git;a=commitdiff;h=42217cbc5b3e84b8c145d8cfb62dd5de0134b9e8;hp=3a0b9c57d5c9e82c55dd967c84dd06cb43c49ee9
[1] https://bugzilla.novell.com/show_bug.cgi?id=861093
[2] http://ftp.suse.com/pub/people/mcgrof/xen/emulate-long-xen-hypercalls.patch

Based on original work by: David Vrabel <david.vrabel@citrix.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: David Vrabel <david.vrabel@citrix.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Jan Beulich <JBeulich@suse.com>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 arch/x86/kernel/entry_32.S | 21 +++++++++++++++++++++
 arch/x86/kernel/entry_64.S | 17 +++++++++++++++++
 drivers/xen/Makefile       |  2 +-
 drivers/xen/preempt.c      | 17 +++++++++++++++++
 drivers/xen/privcmd.c      |  2 ++
 include/xen/xen-ops.h      | 26 ++++++++++++++++++++++++++
 6 files changed, 84 insertions(+), 1 deletion(-)
 create mode 100644 drivers/xen/preempt.c

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 344b63f..40b5c0c 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -982,7 +982,28 @@ ENTRY(xen_hypervisor_callback)
 ENTRY(xen_do_upcall)
 1:	mov %esp, %eax
 	call xen_evtchn_do_upcall
+#ifdef CONFIG_PREEMPT
 	jmp  ret_from_intr
+#else
+	GET_THREAD_INFO(%ebp)
+#ifdef CONFIG_VM86
+	movl PT_EFLAGS(%esp), %eax	# mix EFLAGS and CS
+	movb PT_CS(%esp), %al
+	andl $(X86_EFLAGS_VM | SEGMENT_RPL_MASK), %eax
+#else
+	movl PT_CS(%esp), %eax
+	andl $SEGMENT_RPL_MASK, %eax
+#endif
+	cmpl $USER_RPL, %eax
+	jae resume_userspace		# returning to v8086 or userspace
+	DISABLE_INTERRUPTS(CLBR_ANY)
+	cmpb $0,PER_CPU_VAR(xen_in_preemptible_hcall)
+	jz resume_kernel
+	movb $0,PER_CPU_VAR(xen_in_preemptible_hcall)
+	call cond_resched_irq
+	movb $1,PER_CPU_VAR(xen_in_preemptible_hcall)
+	jmp resume_kernel
+#endif /* CONFIG_PREEMPT */
 	CFI_ENDPROC
 ENDPROC(xen_hypervisor_callback)
 
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index c0226ab..0ccdd06 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1170,7 +1170,23 @@ ENTRY(xen_do_hypervisor_callback)   # do_hypervisor_callback(struct *pt_regs)
 	popq %rsp
 	CFI_DEF_CFA_REGISTER rsp
 	decl PER_CPU_VAR(irq_count)
+#ifdef CONFIG_PREEMPT
 	jmp  error_exit
+#else
+	movl %ebx, %eax
+	RESTORE_REST
+	DISABLE_INTERRUPTS(CLBR_NONE)
+	TRACE_IRQS_OFF
+	GET_THREAD_INFO(%rcx)
+	testl %eax, %eax
+	je error_exit_user
+	cmpb $0,PER_CPU_VAR(xen_in_preemptible_hcall)
+	jz retint_kernel
+	movb $0,PER_CPU_VAR(xen_in_preemptible_hcall)
+	call cond_resched_irq
+	movb $1,PER_CPU_VAR(xen_in_preemptible_hcall)
+	jmp retint_kernel
+#endif /* CONFIG_PREEMPT */
 	CFI_ENDPROC
 END(xen_do_hypervisor_callback)
 
@@ -1398,6 +1414,7 @@ ENTRY(error_exit)
 	GET_THREAD_INFO(%rcx)
 	testl %eax,%eax
 	jne retint_kernel
+error_exit_user:
 	LOCKDEP_SYS_EXIT_IRQ
 	movl TI_flags(%rcx),%edx
 	movl $_TIF_WORK_MASK,%edi
diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
index 2140398..2ccd359 100644
--- a/drivers/xen/Makefile
+++ b/drivers/xen/Makefile
@@ -2,7 +2,7 @@ ifeq ($(filter y, $(CONFIG_ARM) $(CONFIG_ARM64)),)
 obj-$(CONFIG_HOTPLUG_CPU)		+= cpu_hotplug.o
 endif
 obj-$(CONFIG_X86)			+= fallback.o
-obj-y	+= grant-table.o features.o balloon.o manage.o
+obj-y	+= grant-table.o features.o balloon.o manage.o preempt.o
 obj-y	+= events/
 obj-y	+= xenbus/
 
diff --git a/drivers/xen/preempt.c b/drivers/xen/preempt.c
new file mode 100644
index 0000000..b5a3e98
--- /dev/null
+++ b/drivers/xen/preempt.c
@@ -0,0 +1,17 @@
+/*
+ * Preemptible hypercalls
+ *
+ * Copyright (C) 2014 Citrix Systems R&D ltd.
+ *
+ * This source code is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either version 2 of the
+ * License, or (at your option) any later version.
+ */
+
+#include <xen/xen-ops.h>
+
+#ifndef CONFIG_PREEMPT
+DEFINE_PER_CPU(bool, xen_in_preemptible_hcall);
+EXPORT_SYMBOL_GPL(xen_in_preemptible_hcall);
+#endif
diff --git a/drivers/xen/privcmd.c b/drivers/xen/privcmd.c
index 569a13b..59ac71c 100644
--- a/drivers/xen/privcmd.c
+++ b/drivers/xen/privcmd.c
@@ -56,10 +56,12 @@ static long privcmd_ioctl_hypercall(void __user *udata)
 	if (copy_from_user(&hypercall, udata, sizeof(hypercall)))
 		return -EFAULT;
 
+	xen_preemptible_hcall_begin();
 	ret = privcmd_call(hypercall.op,
 			   hypercall.arg[0], hypercall.arg[1],
 			   hypercall.arg[2], hypercall.arg[3],
 			   hypercall.arg[4]);
+	xen_preemptible_hcall_end();
 
 	return ret;
 }
diff --git a/include/xen/xen-ops.h b/include/xen/xen-ops.h
index 7491ee5..8333821 100644
--- a/include/xen/xen-ops.h
+++ b/include/xen/xen-ops.h
@@ -46,4 +46,30 @@ static inline efi_system_table_t __init *xen_efi_probe(void)
 }
 #endif
 
+#ifdef CONFIG_PREEMPT
+
+static inline void xen_preemptible_hcall_begin(void)
+{
+}
+
+static inline void xen_preemptible_hcall_end(void)
+{
+}
+
+#else
+
+DECLARE_PER_CPU(bool, xen_in_preemptible_hcall);
+
+static inline void xen_preemptible_hcall_begin(void)
+{
+	__this_cpu_write(xen_in_preemptible_hcall, true);
+}
+
+static inline void xen_preemptible_hcall_end(void)
+{
+	__this_cpu_write(xen_in_preemptible_hcall, false);
+}
+
+#endif /* CONFIG_PREEMPT */
+
 #endif /* INCLUDE_XEN_OPS_H */
-- 
2.1.1

