Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689AbbAUHua (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 02:50:30 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46684 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368AbbAUHtl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 02:49:41 -0500
From: Juergen Gross <jgross@suse.com>
To: linux-kernel@vger.kernel.org, x86@kernel.org,
        xen-devel@lists.xensource.com, konrad.wilk@oracle.com,
        david.vrabel@citrix.com, boris.ostrovsky@oracle.com,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, mmarek@suse.cz,
        linux-kbuild@vger.kernel.org
Cc: Juergen Gross <jgross@suse.com>
Subject: [RESEND Patch V2 4/4] xen: use generated hypercall symbols in arch/x86/xen/xen-head.S
Date: Wed, 21 Jan 2015 08:49:25 +0100
Message-Id: <1421826565-10826-5-git-send-email-jgross@suse.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1421826565-10826-1-git-send-email-jgross@suse.com>
References: <1421826565-10826-1-git-send-email-jgross@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of manually list each hypercall in arch/x86/xen/xen-head.S
use the auto generated symbol list.

This also corrects the wrong address of xen_hypercall_mca which was
located 32 bytes higher than it should.

Symbol addresses have been verified to match the correct ones via
objdump output.

Based-on-patch-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: David Vrabel <david.vrabel@citrix.com>
---
 arch/x86/xen/xen-head.S | 63 ++++++++-----------------------------------------
 1 file changed, 10 insertions(+), 53 deletions(-)

diff --git a/arch/x86/xen/xen-head.S b/arch/x86/xen/xen-head.S
index 674b2225..8afdfcc 100644
--- a/arch/x86/xen/xen-head.S
+++ b/arch/x86/xen/xen-head.S
@@ -12,6 +12,8 @@
 
 #include <xen/interface/elfnote.h>
 #include <xen/interface/features.h>
+#include <xen/interface/xen.h>
+#include <xen/interface/xen-mca.h>
 #include <asm/xen/interface.h>
 
 #ifdef CONFIG_XEN_PVH
@@ -85,59 +87,14 @@ ENTRY(xen_pvh_early_cpu_init)
 .pushsection .text
 	.balign PAGE_SIZE
 ENTRY(hypercall_page)
-#define NEXT_HYPERCALL(x) \
-	ENTRY(xen_hypercall_##x) \
-	.skip 32
-
-NEXT_HYPERCALL(set_trap_table)
-NEXT_HYPERCALL(mmu_update)
-NEXT_HYPERCALL(set_gdt)
-NEXT_HYPERCALL(stack_switch)
-NEXT_HYPERCALL(set_callbacks)
-NEXT_HYPERCALL(fpu_taskswitch)
-NEXT_HYPERCALL(sched_op_compat)
-NEXT_HYPERCALL(platform_op)
-NEXT_HYPERCALL(set_debugreg)
-NEXT_HYPERCALL(get_debugreg)
-NEXT_HYPERCALL(update_descriptor)
-NEXT_HYPERCALL(ni)
-NEXT_HYPERCALL(memory_op)
-NEXT_HYPERCALL(multicall)
-NEXT_HYPERCALL(update_va_mapping)
-NEXT_HYPERCALL(set_timer_op)
-NEXT_HYPERCALL(event_channel_op_compat)
-NEXT_HYPERCALL(xen_version)
-NEXT_HYPERCALL(console_io)
-NEXT_HYPERCALL(physdev_op_compat)
-NEXT_HYPERCALL(grant_table_op)
-NEXT_HYPERCALL(vm_assist)
-NEXT_HYPERCALL(update_va_mapping_otherdomain)
-NEXT_HYPERCALL(iret)
-NEXT_HYPERCALL(vcpu_op)
-NEXT_HYPERCALL(set_segment_base)
-NEXT_HYPERCALL(mmuext_op)
-NEXT_HYPERCALL(xsm_op)
-NEXT_HYPERCALL(nmi_op)
-NEXT_HYPERCALL(sched_op)
-NEXT_HYPERCALL(callback_op)
-NEXT_HYPERCALL(xenoprof_op)
-NEXT_HYPERCALL(event_channel_op)
-NEXT_HYPERCALL(physdev_op)
-NEXT_HYPERCALL(hvm_op)
-NEXT_HYPERCALL(sysctl)
-NEXT_HYPERCALL(domctl)
-NEXT_HYPERCALL(kexec_op)
-NEXT_HYPERCALL(tmem_op) /* 38 */
-ENTRY(xen_hypercall_rsvr)
-	.skip 320
-NEXT_HYPERCALL(mca) /* 48 */
-NEXT_HYPERCALL(arch_1)
-NEXT_HYPERCALL(arch_2)
-NEXT_HYPERCALL(arch_3)
-NEXT_HYPERCALL(arch_4)
-NEXT_HYPERCALL(arch_5)
-NEXT_HYPERCALL(arch_6)
-	.balign PAGE_SIZE
+	.skip PAGE_SIZE
+
+#define HYPERCALL(n) \
+	.equ xen_hypercall_##n, hypercall_page + __HYPERVISOR_##n * 32; \
+	.type xen_hypercall_##n, @function; .size xen_hypercall_##n, 32
+#include <asm/xen-hypercalls.h>
+#undef HYPERCALL
+
 .popsection
 
 	ELFNOTE(Xen, XEN_ELFNOTE_GUEST_OS,       .asciz "linux")
-- 
2.1.2

