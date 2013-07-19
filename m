Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759489Ab3GSD5m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 23:57:42 -0400
Received: from mail-ye0-f178.google.com ([209.85.213.178]:55389 "EHLO
	mail-ye0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759417Ab3GSD5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 23:57:39 -0400
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xen.org,
        ian.campbell@citrix.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Lisa Nguyen <lisa@xenapiadmin.com>,
        Ben Guthro <benjamin.guthro@citrix.com>,
        Zhenzhong Duan <zhenzhong.duan@oracle.com>
Subject: [PATCH] xen: Support PV guest receiving NMIs
Date: Thu, 18 Jul 2013 23:35:50 -0400
Message-Id: <1374204950-32005-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zhenzhong Duan sent a patch that adds some of this functionality
but this code adds the remaining pieces. The kernel has the
logic to handle Xen-type-exceptions using the paravirt interface
in the assembler code. That means the nmi handler (and other exception
handlers) use the hypervisor iret and we can hook up them up.

Fortunately for us the commit 1db01b4903639fcfaec213701a494fe3fb2c490b
(xen: Clean up apic ipi interface) allows us to piggyback on the
cleanup such that the apic IPI interface will pass the right vector
value for NMI.

With this patch we can trigger NMIs within a guest.

SysRq : Show backtrace of all active CPUs
sending NMI to all CPUs:
NMI backtrace for cpu 2
CPU 2
RIP: e030:[<ffffffff8100130a>]  [<ffffffff8100130a>] xen_hypercall_vcpu_op+0xa/0x20
. snip..
Call Trace:
 [<ffffffff813afdc0>] ? xen_send_IPI_one+0x40/0x60
 [<ffffffff8104bdcb>] __xen_send_IPI_mask+0x2b/0x50
 [<ffffffff8104c6f9>] xen_send_IPI_all+0x79/0xa0
 [<ffffffff81074df9>] arch_trigger_all_cpu_backtrace+0x59/0xa0
 [<ffffffff813d16f9>] sysrq_handle_showallcpus+0x9/0x10
 [<ffffffff813d1ad9>] __handle_sysrq+0x129/0x190
 [<ffffffff813d1b40>] ? __handle_sysrq+0x190/0x190
 [<ffffffff813d1ba4>] write_sysrq_trigger+0x64/0x70
 [<ffffffff8121211b>] proc_reg_write+0x8b/0xe0
 [<ffffffff811aa1c4>] vfs_write+0xb4/0x130
 [<ffffffff811aa98a>] sys_write+0x5a/0xa0
 [<ffffffff816825e9>] system_call_fastpath+0x16/0x1b
NMI backtrace for cpu 0
CPU 0
. snip..
Call Trace:
 [<ffffffff81044180>] ? xen_safe_halt+0x10/0x20
 [<ffffffff8105746c>] default_idle+0x3c/0x130
 [<ffffffff81056cf9>] cpu_idle+0x99/0xe0
 [<ffffffff816619da>] rest_init+0x8a/0xa0
 [<ffffffff81ac10a4>] start_kernel+0x3da/0x3e7
 [<ffffffff81ac0ae8>] ? repair_env_string+0x5b/0x5b
 [<ffffffff81ac05f7>] x86_64_start_reservations+0x2a/0x2c
 [<ffffffff81ac30ce>] xen_start_kernel+0x56e/0x570
NMI backtrace for cpu 1
CPU 1
RIP: e030:[<ffffffff810013aa>]  [<ffffffff810013aa>] xen_hypercall_sched_op+0xa/0x20
.snip..
Call Trace:
 [<ffffffff81044180>] ? xen_safe_halt+0x10/0x20
 [<ffffffff8105746c>] default_idle+0x3c/0x130
 [<ffffffff81056cf9>] cpu_idle+0x99/0xe0
 [<ffffffff81044969>] ? xen_irq_enable_direct_reloc+0x4/0x4
 [<ffffffff8166801b>] cpu_bringup_and_idle+0xe/0x10
NMI backtrace for cpu 3
CPU 3
.snip..
Call Trace:
 [<ffffffff81044180>] ? xen_safe_halt+0x10/0x20
 [<ffffffff8105746c>] default_idle+0x3c/0x130
 [<ffffffff81056cf9>] cpu_idle+0x99/0xe0
 [<ffffffff81044969>] ? xen_irq_enable_direct_reloc+0x4/0x4
 [<ffffffff8166801b>] cpu_bringup_and_idle+0xe/0x10

Incidentally that means kgdb will also now work within
a PV guest without using the 'nokgdbroundup' workaround.

CC: Lisa Nguyen <lisa@xenapiadmin.com>
CC: Ben Guthro <benjamin.guthro@citrix.com>
CC: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/include/asm/xen/events.h |    1 +
 arch/x86/xen/enlighten.c          |   13 ++++++++-----
 arch/x86/xen/setup.c              |    2 ++
 arch/x86/xen/smp.c                |    5 +++++
 drivers/xen/events.c              |   10 ++++++++++
 include/xen/interface/vcpu.h      |    2 ++
 6 files changed, 28 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/xen/events.h b/arch/x86/include/asm/xen/events.h
index ca842f2..608a79d 100644
--- a/arch/x86/include/asm/xen/events.h
+++ b/arch/x86/include/asm/xen/events.h
@@ -7,6 +7,7 @@ enum ipi_vector {
 	XEN_CALL_FUNCTION_SINGLE_VECTOR,
 	XEN_SPIN_UNLOCK_VECTOR,
 	XEN_IRQ_WORK_VECTOR,
+	XEN_NMI_VECTOR,
 
 	XEN_NR_IPIS,
 };
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 2fa02bc..231382a 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -427,8 +427,7 @@ static void __init xen_init_cpuid_mask(void)
 
 	if (!xen_initial_domain())
 		cpuid_leaf1_edx_mask &=
-			~((1 << X86_FEATURE_APIC) |  /* disable local APIC */
-			  (1 << X86_FEATURE_ACPI));  /* disable ACPI */
+			~((1 << X86_FEATURE_ACPI));  /* disable ACPI */
 
 	cpuid_leaf1_ecx_mask &= ~(1 << (X86_FEATURE_X2APIC % 32));
 
@@ -735,8 +734,7 @@ static int cvt_gate_to_trap(int vector, const gate_desc *val,
 		addr = (unsigned long)xen_int3;
 	else if (addr == (unsigned long)stack_segment)
 		addr = (unsigned long)xen_stack_segment;
-	else if (addr == (unsigned long)double_fault ||
-		 addr == (unsigned long)nmi) {
+	else if (addr == (unsigned long)double_fault) {
 		/* Don't need to handle these */
 		return 0;
 #ifdef CONFIG_X86_MCE
@@ -747,7 +745,12 @@ static int cvt_gate_to_trap(int vector, const gate_desc *val,
 		 */
 		;
 #endif
-	} else {
+	} else if (addr == (unsigned long)nmi)
+		/*
+		 * Use the native version as well.
+		 */
+		;
+	else {
 		/* Some other trap using IST? */
 		if (WARN_ON(val->ist != 0))
 			return 0;
diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index 94eac5c..06e5a36 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -33,6 +33,7 @@
 /* These are code, but not functions.  Defined in entry.S */
 extern const char xen_hypervisor_callback[];
 extern const char xen_failsafe_callback[];
+extern const char nmi[];
 extern void xen_sysenter_target(void);
 extern void xen_syscall_target(void);
 extern void xen_syscall32_target(void);
@@ -538,6 +539,7 @@ void __init xen_arch_setup(void)
 				     VMASST_TYPE_pae_extended_cr3);
 
 	if (register_callback(CALLBACKTYPE_event, xen_hypervisor_callback) ||
+	    register_callback(CALLBACKTYPE_nmi, nmi) ||
 	    register_callback(CALLBACKTYPE_failsafe, xen_failsafe_callback))
 		BUG();
 
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index c1367b2..d792cce 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -572,6 +572,10 @@ static inline int xen_map_vector(int vector)
 	case IRQ_WORK_VECTOR:
 		xen_vector = XEN_IRQ_WORK_VECTOR;
 		break;
+	case NMI_VECTOR:
+	case APIC_DM_NMI:
+		xen_vector = XEN_NMI_VECTOR;
+		break;
 	default:
 		xen_vector = -1;
 		printk(KERN_ERR "xen: vector 0x%x is not implemented\n",
@@ -659,6 +663,7 @@ static irqreturn_t xen_irq_work_interrupt(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
+
 static const struct smp_ops xen_smp_ops __initconst = {
 	.smp_prepare_boot_cpu = xen_smp_prepare_boot_cpu,
 	.smp_prepare_cpus = xen_smp_prepare_cpus,
diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index a58ac43..ebb52b6 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -56,6 +56,7 @@
 #include <xen/interface/hvm/params.h>
 #include <xen/interface/physdev.h>
 #include <xen/interface/sched.h>
+#include <xen/interface/vcpu.h>
 #include <asm/hw_irq.h>
 
 /*
@@ -1213,6 +1214,15 @@ EXPORT_SYMBOL_GPL(evtchn_put);
 void xen_send_IPI_one(unsigned int cpu, enum ipi_vector vector)
 {
 	int irq = per_cpu(ipi_to_irq, cpu)[vector];
+
+	/*
+	 * In which the IRQ will be -1.
+	 */
+	if (unlikely(vector == XEN_NMI_VECTOR)) {
+		if (HYPERVISOR_vcpu_op(VCPUOP_send_nmi, cpu, NULL) < 0)
+			printk(KERN_WARNING "Sending nmi to CPU%d failed\n", cpu);
+		return;
+	}
 	BUG_ON(irq < 0);
 	notify_remote_via_irq(irq);
 }
diff --git a/include/xen/interface/vcpu.h b/include/xen/interface/vcpu.h
index 87e6f8a..b05288c 100644
--- a/include/xen/interface/vcpu.h
+++ b/include/xen/interface/vcpu.h
@@ -170,4 +170,6 @@ struct vcpu_register_vcpu_info {
 };
 DEFINE_GUEST_HANDLE_STRUCT(vcpu_register_vcpu_info);
 
+/* Send an NMI to the specified VCPU. @extra_arg == NULL. */
+#define VCPUOP_send_nmi             11
 #endif /* __XEN_PUBLIC_VCPU_H__ */
-- 
1.7.7.6

