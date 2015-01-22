Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119AbbAVCRx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 21:17:53 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:32917 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753774AbbAVCRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 21:17:36 -0500
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: david.vrabel@citrix.com, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com, xen-devel@lists.xenproject.org
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        "Luis R. Rodriguez" <mcgrof@suse.com>,
        Andy Lutomirski <luto@amacapital.net>, Borislav Petkov <bp@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Jan Beulich <JBeulich@suse.com>
Subject: [RFC v3 1/2] x86/xen: add xen_is_preemptible_hypercall()
Date: Wed, 21 Jan 2015 18:17:18 -0800
Message-Id: <1421893039-426-2-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1421893039-426-1-git-send-email-mcgrof@do-not-panic.com>
References: <1421893039-426-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@suse.com>

On kernels with voluntary or no preemption we can run
into situations where a hypercall issued through userspace
will linger around as it addresses sub-operatiosn in kernel
context (multicalls). Such operations can trigger soft lockup
detection.

We want to address a way to let the kernel voluntarily preempt
such calls even on non preempt kernels, to address this we first
need to distinguish which hypercalls fall under this category.
This implements xen_is_preemptible_hypercall() which lets us do
just that by adding a secondary hypercall page, calls made via
the new page may be preempted.

Andrew had originally submitted a version of this work [0].

[0] http://lists.xen.org/archives/html/xen-devel/2014-02/msg01056.html

Based on original work by: Andrew Cooper <andrew.cooper3@citrix.com>

Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Borislav Petkov <bp@suse.de>
Cc: David Vrabel <david.vrabel@citrix.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Jan Beulich <JBeulich@suse.com>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 arch/x86/include/asm/xen/hypercall.h | 20 ++++++++++++++++++++
 arch/x86/xen/enlighten.c             |  7 +++++++
 arch/x86/xen/xen-head.S              | 18 +++++++++++++++++-
 3 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/xen/hypercall.h b/arch/x86/include/asm/xen/hypercall.h
index ca08a27..221008e 100644
--- a/arch/x86/include/asm/xen/hypercall.h
+++ b/arch/x86/include/asm/xen/hypercall.h
@@ -84,6 +84,22 @@
 
 extern struct { char _entry[32]; } hypercall_page[];
 
+#ifndef CONFIG_PREEMPT
+extern struct { char _entry[32]; } preemptible_hypercall_page[];
+
+static inline bool xen_is_preemptible_hypercall(struct pt_regs *regs)
+{
+	return !user_mode_vm(regs) &&
+		regs->ip >= (unsigned long)preemptible_hypercall_page &&
+		regs->ip < (unsigned long)preemptible_hypercall_page + PAGE_SIZE;
+}
+#else
+static inline bool xen_is_preemptible_hypercall(struct pt_regs *regs)
+{
+	return false;
+}
+#endif
+
 #define __HYPERCALL		"call hypercall_page+%c[offset]"
 #define __HYPERCALL_ENTRY(x)						\
 	[offset] "i" (__HYPERVISOR_##x * sizeof(hypercall_page[0]))
@@ -215,7 +231,11 @@ privcmd_call(unsigned call,
 
 	asm volatile("call *%[call]"
 		     : __HYPERCALL_5PARAM
+#ifndef CONFIG_PREEMPT
+		     : [call] "a" (&preemptible_hypercall_page[call])
+#else
 		     : [call] "a" (&hypercall_page[call])
+#endif
 		     : __HYPERCALL_CLOBBER5);
 
 	return (long)__res;
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 6bf3a13..9c01b48 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -84,6 +84,9 @@
 #include "multicalls.h"
 
 EXPORT_SYMBOL_GPL(hypercall_page);
+#ifndef CONFIG_PREEMPT
+EXPORT_SYMBOL_GPL(preemptible_hypercall_page);
+#endif
 
 /*
  * Pointer to the xen_vcpu_info structure or
@@ -1531,6 +1534,10 @@ asmlinkage __visible void __init xen_start_kernel(void)
 #endif
 	xen_setup_machphys_mapping();
 
+#ifndef CONFIG_PREEMPT
+	copy_page(preemptible_hypercall_page, hypercall_page);
+#endif
+
 	/* Install Xen paravirt ops */
 	pv_info = xen_info;
 	pv_init_ops = xen_init_ops;
diff --git a/arch/x86/xen/xen-head.S b/arch/x86/xen/xen-head.S
index 674b2225..6e6a9517 100644
--- a/arch/x86/xen/xen-head.S
+++ b/arch/x86/xen/xen-head.S
@@ -85,9 +85,18 @@ ENTRY(xen_pvh_early_cpu_init)
 .pushsection .text
 	.balign PAGE_SIZE
 ENTRY(hypercall_page)
+
+#ifdef CONFIG_PREEMPT
+#  define PREEMPT_HYPERCALL_ENTRY(x)
+#else
+#  define PREEMPT_HYPERCALL_ENTRY(x) \
+       .global xen_hypercall_##x ## _p ASM_NL \
+       .set preemptible_xen_hypercall_##x, xen_hypercall_##x + PAGE_SIZE ASM_NL
+#endif
 #define NEXT_HYPERCALL(x) \
 	ENTRY(xen_hypercall_##x) \
-	.skip 32
+	.skip 32 ASM_NL \
+	PREEMPT_HYPERCALL_ENTRY(x)
 
 NEXT_HYPERCALL(set_trap_table)
 NEXT_HYPERCALL(mmu_update)
@@ -138,6 +147,13 @@ NEXT_HYPERCALL(arch_4)
 NEXT_HYPERCALL(arch_5)
 NEXT_HYPERCALL(arch_6)
 	.balign PAGE_SIZE
+
+#ifndef CONFIG_PREEMPT
+ENTRY(preemptible_hypercall_page)
+	.skip PAGE_SIZE
+#endif /* CONFIG_PREEMPT */
+
+#undef NEXT_HYPERCALL
 .popsection
 
 	ELFNOTE(Xen, XEN_ELFNOTE_GUEST_OS,       .asciz "linux")
-- 
2.1.1

