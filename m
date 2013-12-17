Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754372Ab3LQUwN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 15:52:13 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:28502 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754050Ab3LQUwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 15:52:03 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com,
        mukesh.rathor@oracle.com, jbeulich@suse.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH v11 06/12] xen/pvh: Load GDT/GS in early PV bootup code for BSP.
Date: Tue, 17 Dec 2013 15:51:37 -0500
Message-Id: <1387313503-31362-7-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1387313503-31362-1-git-send-email-konrad.wilk@oracle.com>
References: <1387313503-31362-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mukesh Rathor <mukesh.rathor@oracle.com>

During early bootup we start life using the Xen provided
GDT, which means that we are running with %cs segment set
to FLAT_KERNEL_CS (FLAT_RING3_CS64 0xe033, GDT index 261).

But for PVH we want to be use HVM type mechanism for
segment operations. As such we need to switch to the HVM
one and also reload ourselves with the __KERNEL_CS:eip
to run in the proper GDT and segment.

For HVM this is usually done in 'secondary_startup_64' in
(head_64.S) but since we are not taking that bootup
path (we start in PV - xen_start_kernel) we need to do
that in the early PV bootup paths.

For good measure we also zero out the %fs, %ds, and %es
(not strictly needed as Xen has already cleared them
for us). The %gs is loaded by 'switch_to_new_gdt'.

Signed-off-by: Mukesh Rathor <mukesh.rathor@oracle.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/enlighten.c | 39 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 37 insertions(+), 2 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index c7341d0..0d13652 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1413,8 +1413,43 @@ static void __init xen_boot_params_init_edd(void)
  * we do this, we have to be careful not to call any stack-protected
  * function, which is most of the kernel.
  */
-static void __init xen_setup_stackprotector(void)
+static void __init xen_setup_gdt(void)
 {
+	if (xen_feature(XENFEAT_auto_translated_physmap)) {
+#ifdef CONFIG_X86_64
+		unsigned long dummy;
+
+		switch_to_new_gdt(0); /* GDT and GS set */
+
+		/* We are switching of the Xen provided GDT to our HVM mode
+		 * GDT. The new GDT has  __KERNEL_CS with CS.L = 1
+		 * and we are jumping to reload it.
+		 */
+		asm volatile ("pushq %0\n"
+			      "leaq 1f(%%rip),%0\n"
+			      "pushq %0\n"
+			      "lretq\n"
+			      "1:\n"
+			      : "=&r" (dummy) : "0" (__KERNEL_CS));
+
+		/*
+		 * While not needed, we also set the %es, %ds, and %fs
+		 * to zero. We don't care about %ss as it is NULL.
+		 * Strictly speaking this is not needed as Xen zeros those
+		 * out (and also MSR_FS_BASE, MSR_GS_BASE, MSR_KERNEL_GS_BASE)
+		 *
+		 * Linux zeros them in cpu_init() and in secondary_startup_64
+		 * (for BSP).
+		 */
+		loadsegment(es, 0);
+		loadsegment(ds, 0);
+		loadsegment(fs, 0);
+#else
+		/* PVH: TODO Implement. */
+		BUG();
+#endif
+		return;
+	}
 	pv_cpu_ops.write_gdt_entry = xen_write_gdt_entry_boot;
 	pv_cpu_ops.load_gdt = xen_load_gdt_boot;
 
@@ -1499,7 +1534,7 @@ asmlinkage void __init xen_start_kernel(void)
 	 * Set up kernel GDT and segment registers, mainly so that
 	 * -fstack-protector code can be executed.
 	 */
-	xen_setup_stackprotector();
+	xen_setup_gdt();
 
 	xen_init_irq_ops();
 	xen_init_cpuid_mask();
-- 
1.8.3.1

