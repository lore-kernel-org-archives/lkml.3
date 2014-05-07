Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933936AbaEGPx6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 11:53:58 -0400
Received: from www.linutronix.de ([62.245.132.108]:48533 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756746AbaEGPnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 11:43:55 -0400
Message-Id: <20140507154335.959870037@linutronix.de>
User-Agent: quilt/0.60-1
Date: Wed, 07 May 2014 15:44:10 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Anvin <hpa@zytor.com>,
        Tony Luck <tony.luck@intel.com>, Peter Zijlstra <peterz@infradead.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [patch 10/32] x86: Get rid of get_nr_irqs_gsi()
References: <20140507153622.703412101@linutronix.de>
Content-Disposition: inline; filename=x86-get-rid-of-get-nr-irqs-gsi.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need to expose this outside of the ioapic code. The dynamic
allocations are guaranteed not to happen in the gsi space. See commit
62a08ae2a.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: x86@kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: xen-devel@lists.xenproject.org

---
 arch/x86/include/asm/io_apic.h   |    2 --
 arch/x86/kernel/apic/io_apic.c   |    5 -----
 drivers/xen/events/events_base.c |   17 +----------------
 3 files changed, 1 insertion(+), 23 deletions(-)

Index: tip/arch/x86/include/asm/io_apic.h
===================================================================
--- tip.orig/arch/x86/include/asm/io_apic.h
+++ tip/arch/x86/include/asm/io_apic.h
@@ -168,8 +168,6 @@ extern int save_ioapic_entries(void);
 extern void mask_ioapic_entries(void);
 extern int restore_ioapic_entries(void);
 
-extern int get_nr_irqs_gsi(void);
-
 extern void setup_ioapic_ids_from_mpc(void);
 extern void setup_ioapic_ids_from_mpc_nocheck(void);
 
Index: tip/arch/x86/kernel/apic/io_apic.c
===================================================================
--- tip.orig/arch/x86/kernel/apic/io_apic.c
+++ tip/arch/x86/kernel/apic/io_apic.c
@@ -3450,11 +3450,6 @@ static void __init probe_nr_irqs_gsi(voi
 	printk(KERN_DEBUG "nr_irqs_gsi: %d\n", nr_irqs_gsi);
 }
 
-int get_nr_irqs_gsi(void)
-{
-	return nr_irqs_gsi;
-}
-
 unsigned int arch_dynirq_lower_bound(unsigned int from)
 {
 	return from < nr_irqs_gsi ? nr_irqs_gsi : from;
Index: tip/drivers/xen/events/events_base.c
===================================================================
--- tip.orig/drivers/xen/events/events_base.c
+++ tip/drivers/xen/events/events_base.c
@@ -390,22 +390,7 @@ static void xen_irq_init(unsigned irq)
 
 static int __must_check xen_allocate_irqs_dynamic(int nvec)
 {
-	int first = 0;
-	int i, irq;
-
-#ifdef CONFIG_X86_IO_APIC
-	/*
-	 * For an HVM guest or domain 0 which see "real" (emulated or
-	 * actual respectively) GSIs we allocate dynamic IRQs
-	 * e.g. those corresponding to event channels or MSIs
-	 * etc. from the range above those "real" GSIs to avoid
-	 * collisions.
-	 */
-	if (xen_initial_domain() || xen_hvm_domain())
-		first = get_nr_irqs_gsi();
-#endif
-
-	irq = irq_alloc_descs_from(first, nvec, -1);
+	int i, irq = irq_alloc_descs(-1, 0, nvec, -1);
 
 	if (irq >= 0) {
 		for (i = 0; i < nvec; i++)


