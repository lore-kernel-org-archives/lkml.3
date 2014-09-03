Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932767AbaICN6J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 09:58:09 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:1602 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755478AbaICN6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 09:58:08 -0400
X-IronPort-AV: E=Sophos;i="5.04,457,1406592000"; 
   d="scan'208";a="168697129"
Message-ID: <54071E6C.4080901@citrix.com>
Date: Wed, 3 Sep 2014 14:58:04 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Mukesh Rathor <mukesh.rathor@oracle.com>, <boris.ostrovsky@oracle.com>,
        <david.vrabel@citrix.com>
CC: <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [V2 PATCH 1/1] PVH: set EFER.NX and EFER.SCE
References: <1409707176-16487-1-git-send-email-mukesh.rathor@oracle.com> <1409707176-16487-2-git-send-email-mukesh.rathor@oracle.com>
In-Reply-To: <1409707176-16487-2-git-send-email-mukesh.rathor@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/14 02:19, Mukesh Rathor wrote:
> This patch addresses two things for a pvh boot vcpu:
> 
>   - NX bug on intel: It was recenlty discovered that NX is not being
>     honored in PVH on intel since EFER.NX is not being set.
> 
>   - PVH boot hang on newer xen:  Following c/s on xen
> 
>         c/s 7645640:  x86/PVH: don't set EFER_SCE for pvh guest
> 
>     removes setting of EFER.SCE for PVH guests. As such, existing intel
>     pvh guest will no longer boot on xen after that c/s.
> 
> Both above changes will be applicable to AMD also when xen support
> of AMD pvh is added.
> 
> Also, we create a new glue assembly entry point for secondary vcpus
> because they come up on kernel page tables that have pte.NX
> bits set. As such, before anything is touched in DS/SS, EFER.NX
> must be set.
[...]
> --- a/arch/x86/xen/xen-head.S
> +++ b/arch/x86/xen/xen-head.S
> @@ -47,6 +47,35 @@ ENTRY(startup_xen)
>  
>  	__FINIT
>  
> +#ifdef CONFIG_XEN_PVH
> +#ifdef CONFIG_X86_64
> +.macro PVH_EARLY_SET_EFER

I don't think a macro is the right way to do this.  We can instead pass
a parameter to say whether it is a boot or secondary CPU.

Something like this (untested) patch?

8<----------------------------
x86/xen: Set EFER.NX and EFER.SCE in PVH guests

This patch addresses two things for a pvh boot vcpu:

  - NX bug on intel: It was recenlty discovered that NX is not being
    honored in PVH on intel since EFER.NX is not being set.

  - PVH boot hang on newer xen:  Following c/s on xen

        c/s 7645640:  x86/PVH: don't set EFER_SCE for pvh guest

    removes setting of EFER.SCE for PVH guests. As such, existing intel
    pvh guest will no longer boot on xen after that c/s.

Both above changes will be applicable to AMD also when xen support
of AMD pvh is added.

Also, we create a new glue assembly entry point for secondary vcpus
because they come up on kernel page tables that have pte.NX
bits set. As such, before anything is touched in DS/SS, EFER.NX
must be set.

Signed-off-by: Mukesh Rathor <mukesh.rathor@oracle.com>
Signed-off-by: David Vrabel <david.vrabel@citrix.com>
---
 arch/x86/xen/enlighten.c |    1 +
 arch/x86/xen/smp.c       |   34 +++++++++++++++++++++++-----------
 arch/x86/xen/smp.h       |    8 ++++++++
 arch/x86/xen/xen-head.S  |   34 ++++++++++++++++++++++++++++++++++
 4 files changed, 66 insertions(+), 11 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index c0cb11f..b111035 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1508,6 +1508,7 @@ static void __init xen_pvh_early_guest_init(void)
 		return;
 
 	xen_have_vector_callback = 1;
+	xen_pvh_cpu_early_init(0, false);
 	xen_pvh_set_cr_flags(0);
 
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 7005974..dd4ce0d 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -37,6 +37,7 @@
 #include <xen/hvc-console.h>
 #include "xen-ops.h"
 #include "mmu.h"
+#include "smp.h"
 
 cpumask_var_t xen_cpu_initialized_map;
 
@@ -99,8 +100,12 @@ static void cpu_bringup(void)
 	wmb();			/* make sure everything is out */
 }
 
-/* Note: cpu parameter is only relevant for PVH */
-static void cpu_bringup_and_idle(int cpu)
+/*
+ * Note: cpu parameter is only relevant for PVH. The reason for passing it
+ * is we can't do smp_processor_id until the percpu segments are loaded, for
+ * which we need the cpu number! So we pass it in rdi as first parameter.
+ */
+asmlinkage __visible void cpu_bringup_and_idle(int cpu)
 {
 #ifdef CONFIG_X86_64
 	if (xen_feature(XENFEAT_auto_translated_physmap) &&
@@ -374,11 +379,10 @@ cpu_initialize_context(unsigned int cpu, struct task_struct *idle)
 	ctxt->user_regs.fs = __KERNEL_PERCPU;
 	ctxt->user_regs.gs = __KERNEL_STACK_CANARY;
 #endif
-	ctxt->user_regs.eip = (unsigned long)cpu_bringup_and_idle;
-
 	memset(&ctxt->fpu_ctxt, 0, sizeof(ctxt->fpu_ctxt));
 
 	if (!xen_feature(XENFEAT_auto_translated_physmap)) {
+		ctxt->user_regs.eip = (unsigned long)cpu_bringup_and_idle;
 		ctxt->flags = VGCF_IN_KERNEL;
 		ctxt->user_regs.eflags = 0x1000; /* IOPL_RING1 */
 		ctxt->user_regs.ds = __USER_DS;
@@ -413,15 +417,23 @@ cpu_initialize_context(unsigned int cpu, struct task_struct *idle)
 					(unsigned long)xen_failsafe_callback;
 		ctxt->user_regs.cs = __KERNEL_CS;
 		per_cpu(xen_cr3, cpu) = __pa(swapper_pg_dir);
-#ifdef CONFIG_X86_32
-	}
-#else
-	} else
-		/* N.B. The user_regs.eip (cpu_bringup_and_idle) is called with
-		 * %rdi having the cpu number - which means are passing in
-		 * as the first parameter the cpu. Subtle!
+        }
+#ifdef CONFIG_X86_64
+	else {
+		/*
+		 * The vcpu comes on kernel page tables which have the NX pte
+		 * bit set. This means before DS/SS is touched, NX in
+		 * EFER must be set. Hence the following assembly glue code.
+		 */
+		ctxt->user_regs.eip = (unsigned long)xen_pvh_cpu_early_init;
+
+		/* N.B. The bringup function cpu_bringup_and_idle is called with
+		 * %rdi having the cpu number - which means we are passing it in
+		 * as the first parameter. Subtle!
 		 */
 		ctxt->user_regs.rdi = cpu;
+		ctxt->user_regs.rsi = 1; /* secondary_cpu == true */
+	}
 #endif
 	ctxt->user_regs.esp = idle->thread.sp0 - sizeof(struct pt_regs);
 	ctxt->ctrlreg[3] = xen_pfn_to_cr3(virt_to_mfn(swapper_pg_dir));
diff --git a/arch/x86/xen/smp.h b/arch/x86/xen/smp.h
index c7c2d89..fc2575a 100644
--- a/arch/x86/xen/smp.h
+++ b/arch/x86/xen/smp.h
@@ -8,4 +8,12 @@ extern void xen_send_IPI_allbutself(int vector);
 extern void xen_send_IPI_all(int vector);
 extern void xen_send_IPI_self(int vector);
 
+#if defined(CONFIG_XEN_PVH) && defined(CONFIG_X86_64)
+extern void xen_pvh_cpu_early_init(int cpu, bool secondary_cpu);
+#else
+static inline void xen_pvh_cpu_early_init(int cpu, bool secondary_cpu)
+{
+}
+#endif
+
 #endif
diff --git a/arch/x86/xen/xen-head.S b/arch/x86/xen/xen-head.S
index 485b695..a64b464 100644
--- a/arch/x86/xen/xen-head.S
+++ b/arch/x86/xen/xen-head.S
@@ -47,6 +47,40 @@ ENTRY(startup_xen)
 
 	__FINIT
 
+#ifdef CONFIG_XEN_PVH
+#ifdef CONFIG_X86_64
+
+/**
+ * xen_pvh_cpu_early_init() - early PVH VCPU initialization
+ * @cpu:           this cpu number (%rdi)
+ * @secondary_cpu: true if this is a secondary (non-boot) CPU (%rsi)
+ *
+ * Note: This is called as a function on the boot CPU and as the secondary
+ * CPU entry point.
+ */
+ENTRY(xen_pvh_cpu_early_init)
+        mov     %rsi, %r11
+	/* Gather features to see if NX implemented. */
+	mov     $0x80000001, %eax
+	cpuid
+	mov     %edx,%esi
+
+	mov     $MSR_EFER, %ecx
+	rdmsr
+	bts     $_EFER_SCE, %eax
+
+	bt      $20,%esi
+	jnc     1f      /* No NX, skip setting it */
+	bts     $_EFER_NX, %eax
+1:	wrmsr
+
+	cmp     $0,%r11b /* non-zero => secondary cpu */
+	jne     cpu_bringup_and_idle
+	ret
+        
+#endif /* CONFIG_X86_64 */
+#endif /* CONFIG_XEN_PVH */
+
 .pushsection .text
 	.balign PAGE_SIZE
 ENTRY(hypercall_page)
-- 
1.7.10.4

