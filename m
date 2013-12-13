Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752372Ab3LMCNl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 21:13:41 -0500
Received: from mail-qc0-f182.google.com ([209.85.216.182]:42098 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846Ab3LMCKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 21:10:53 -0500
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        george.dunlap@eu.citrix.com, ian.jackson@eu.citrix.com,
        mukesh.rathor@oracle.com, tim@xen.org, jbeulich@suse.com,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH V10 14/14] xen/pvh: vcpu info placement, load CS selector, and remove debug printk.
Date: Thu, 12 Dec 2013 21:10:21 -0500
Message-Id: <1386900621-27528-15-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1386900621-27528-1-git-send-email-konrad.wilk@oracle.com>
References: <1386900621-27528-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mukesh Rathor <mukesh.rathor@oracle.com>

This patch addresses 3 things:
   - Resolve vcpu info placement fixme.
   - Load CS selector for PVH after switching to new gdt.
   - Remove printk in case of failure to map pnfs in p2m. This because qemu
     has lot of expected failures when mapping HVM pages.

Signed-off-by: Mukesh Rathor <mukesh.rathor@oracle.com>
[v1: Added #ifdef for 64-bit]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/enlighten.c |   23 +++++++++++++++++++----
 arch/x86/xen/mmu.c       |    3 ---
 2 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 0bfbe92..329dad9 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1132,14 +1132,12 @@ void xen_setup_shared_info(void)
 		HYPERVISOR_shared_info =
 			(struct shared_info *)__va(xen_start_info->shared_info);
 
-	/* PVH TBD/FIXME: vcpu info placement in phase 2 */
-	if (xen_pvh_domain())
-		return;
-
 #ifndef CONFIG_SMP
 	/* In UP this is as good a place as any to set up shared info */
 	xen_setup_vcpu_info_placement();
 #endif
+	if (xen_pvh_domain())
+		return;
 
 	xen_setup_mfn_list_list();
 }
@@ -1152,6 +1150,10 @@ void xen_setup_vcpu_info_placement(void)
 	for_each_possible_cpu(cpu)
 		xen_vcpu_setup(cpu);
 
+	/* PVH always uses native IRQ ops */
+	if (xen_pvh_domain())
+		return;
+
 	/* xen_vcpu_setup managed to place the vcpu_info within the
 	   percpu area for all cpus, so make use of it */
 	if (have_vcpu_info_placement) {
@@ -1423,7 +1425,20 @@ static void __init xen_setup_stackprotector(void)
 {
 	/* PVH TBD/FIXME: investigate setup_stack_canary_segment */
 	if (xen_feature(XENFEAT_auto_translated_physmap)) {
+		unsigned long dummy;
+
 		switch_to_new_gdt(0);
+#ifdef CONFIG_X86_64
+		asm volatile ("pushq %0\n"
+			      "leaq 1f(%%rip),%0\n"
+			      "pushq %0\n"
+			      "lretq\n"
+			      "1:\n"
+			      : "=&r" (dummy) : "0" (__KERNEL_CS));
+#else
+		/* PVH: TODO Implement. */
+		BUG();
+#endif
 		return;
 	}
 	pv_cpu_ops.write_gdt_entry = xen_write_gdt_entry_boot;
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 108fb4a..5499689 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -2534,9 +2534,6 @@ static int pvh_add_to_xen_p2m(unsigned long lpfn, unsigned long fgmfn,
 	set_xen_guest_handle(xatp.errs, &err);
 
 	rc = HYPERVISOR_memory_op(XENMEM_add_to_physmap_range, &xatp);
-	if (rc || err)
-		pr_warn("d0: Failed to map pfn (0x%lx) to mfn (0x%lx) rc:%d:%d\n",
-			lpfn, fgmfn, rc, err);
 	return rc;
 }
 
-- 
1.7.7.6

