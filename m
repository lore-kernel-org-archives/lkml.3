Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757157Ab3FETfM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 15:35:12 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:16787 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756491Ab3FETfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 15:35:10 -0400
From: Mukesh Rathor <mukesh.rathor@oracle.com>
To: konrad.wilk@oracle.com
Cc: Xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: [PATCH V1]PVH: vcpu info placement, load CS selector, and remove debug printk.
Date: Wed,  5 Jun 2013 12:34:58 -0700
Message-Id: <1370460898-19988-1-git-send-email-mukesh.rathor@oracle.com>
X-Mailer: git-send-email 1.7.2.3
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch addresses 3 things:
   - Resolve vcpu info placement fixme.
   - Load CS selector for PVH after switching to new gdt.
   - Remove printk in case of failure to map pnfs in p2m. This because qemu
     has lot of expected failures when mapping HVM pages.

Signed-off-by: Mukesh Rathor <mukesh.rathor@oracle.com>
---
 arch/x86/xen/enlighten.c |   19 +++++++++++++++----
 arch/x86/xen/mmu.c       |    3 ---
 2 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index a7ee39f..d55a578 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1083,14 +1083,12 @@ void xen_setup_shared_info(void)
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
@@ -1103,6 +1101,10 @@ void xen_setup_vcpu_info_placement(void)
 	for_each_possible_cpu(cpu)
 		xen_vcpu_setup(cpu);
 
+	/* PVH always uses native IRQ ops */
+	if (xen_pvh_domain())
+		return;
+
 	/* xen_vcpu_setup managed to place the vcpu_info within the
 	   percpu area for all cpus, so make use of it */
 	if (have_vcpu_info_placement) {
@@ -1326,7 +1328,16 @@ static void __init xen_setup_stackprotector(void)
 {
 	/* PVH TBD/FIXME: investigate setup_stack_canary_segment */
 	if (xen_feature(XENFEAT_auto_translated_physmap)) {
+		unsigned long dummy;
+
 		switch_to_new_gdt(0);
+
+		asm volatile ("pushq %0\n"
+			      "leaq 1f(%%rip),%0\n"
+			      "pushq %0\n"
+			      "lretq\n"
+			      "1:\n"
+			      : "=&r" (dummy) : "0" (__KERNEL_CS));
 		return;
 	}
 	pv_cpu_ops.write_gdt_entry = xen_write_gdt_entry_boot;
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 31cc1ef..c104895 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -2527,9 +2527,6 @@ static int pvh_add_to_xen_p2m(unsigned long lpfn, unsigned long fgmfn,
 	set_xen_guest_handle(xatp.errs, &err);
 
 	rc = HYPERVISOR_memory_op(XENMEM_add_to_physmap_range, &xatp);
-	if (rc || err)
-		pr_warn("d0: Failed to map pfn (0x%lx) to mfn (0x%lx) rc:%d:%d\n",
-			lpfn, fgmfn, rc, err);
 	return rc;
 }
 
-- 
1.7.2.3

