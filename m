Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932093Ab3BWAhF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 19:37:05 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:32474 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758028Ab3BWAhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 19:37:01 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: hpa@zytor.com, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH] xen/mmu: Provide an early version of write_cr3.
Date: Fri, 22 Feb 2013 19:36:52 -0500
Message-Id: <1361579812-23709-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.0.2
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With git commit 8170e6bed465b4b0c7687f93e9948aca4358a33b
"x86, 64bit: Use a #PF handler to materialize early mappings on demand"

we started hitting an early bootup crash where the Xen hypervisor
would inform us that:

(XEN) d7:v0: unhandled page fault (ec=0000)
(XEN) Pagetable walk from ffffea000005b2d0:
(XEN)  L4[0x1d4] = 0000000000000000 ffffffffffffffff
(XEN) domain_crash_sync called from entry.S
(XEN) Domain 7 (vcpu#0) crashed on cpu#3:
(XEN) ----[ Xen-4.2.0  x86_64  debug=n  Not tainted ]----

.. that Xen was unable to context switch back to dom0.

Looking at the calling stack we find that:

  [<ffffffff8103feba>] xen_get_user_pgd+0x5a  <--
  [<ffffffff8103feba>] xen_get_user_pgd+0x5a
  [<ffffffff81042d27>] xen_write_cr3+0x77
  [<ffffffff81ad2d21>] init_mem_mapping+0x1f9
  [<ffffffff81ac293f>] setup_arch+0x742
  [<ffffffff81666d71>] printk+0x48

We are trying to figure out whether we need to up-date the user PGD
as well. Please keep in mind that under 64-bit PV guests we have
a limited amount of rings: 0 for the Hypervisor, and 1 for both
the Linux kernel and user-space. As such the Linux pvops'fied
version of write_cr3 checks if it has to update the user-space cr3
as well.

That clearly is not needed during early bootup. The
recent changes (see above git commit) streamline the X86 page table
allocation to be much simpler (And also incidentally the #PF handler
ends up in spirit being similar to how the Xen toolstack sets up
the initial page-tables).

The fix is to have an early-bootup version of cr3 that just loads
the kernel %cr3.  The later version - which also handles user-page
modifications will be used after the initial page tables have been setup.

Tested-by: "H. Peter Anvin" <hpa@zytor.com>
Reported-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/mmu.c | 42 ++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 40 insertions(+), 2 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index f5e86ee..2c82917 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1408,7 +1408,6 @@ static void __xen_write_cr3(bool kernel, unsigned long cr3)
 		xen_mc_callback(set_current_cr3, (void *)cr3);
 	}
 }
-
 static void xen_write_cr3(unsigned long cr3)
 {
 	BUG_ON(preemptible());
@@ -1434,6 +1433,45 @@ static void xen_write_cr3(unsigned long cr3)
 	xen_mc_issue(PARAVIRT_LAZY_CPU);  /* interrupts restored */
 }
 
+#ifdef CONFIG_X86_64
+/*
+ * At the start of the day - when Xen launches a guest, it has already
+ * built pagetables for the guest. We diligently look over them
+ * in xen_setup_kernel_pagetable and graft as appropiate them in the
+ * init_level4_pgt and its friends. Then when we are happy we load
+ * the new init_level4_pgt - and continue on.
+ *
+ * The generic code starts (start_kernel) and 'init_mem_mapping' sets
+ * up the rest of the pagetables. When it has completed it loads the cr3.
+ * N.B. that baremetal would start at 'start_kernel' (and the early
+ * #PF handler would create bootstrap pagetables) - so we are running
+ * with the same assumptions as what to do when write_cr3 is executed
+ * at this point.
+ *
+ * Since there are no user-page tables at all, we have two variants
+ * of xen_write_cr3 - the early bootup (this one), and the late one
+ * (xen_write_cr3). The reason we have to do that is that in 64-bit
+ * the Linux kernel and user-space are both in ring 3 while the
+ * hypervisor is in ring 0.
+ */
+static void xen_write_cr3_init(unsigned long cr3)
+{
+	BUG_ON(preemptible());
+
+	xen_mc_batch();  /* disables interrupts */
+
+	/* Update while interrupts are disabled, so its atomic with
+	   respect to ipis */
+	this_cpu_write(xen_cr3, cr3);
+
+	__xen_write_cr3(true, cr3);
+
+	xen_mc_issue(PARAVIRT_LAZY_CPU);  /* interrupts restored */
+
+	pv_mmu_ops.write_cr3 = &xen_write_cr3;
+}
+#endif
+
 static int xen_pgd_alloc(struct mm_struct *mm)
 {
 	pgd_t *pgd = mm->pgd;
@@ -2105,7 +2143,7 @@ static const struct pv_mmu_ops xen_mmu_ops __initconst = {
 #ifdef CONFIG_X86_32
 	.write_cr3 = xen_write_cr3_init,
 #else
-	.write_cr3 = xen_write_cr3,
+	.write_cr3 = xen_write_cr3_init,
 #endif
 
 	.flush_tlb_user = xen_flush_tlb,
-- 
1.8.0.2

