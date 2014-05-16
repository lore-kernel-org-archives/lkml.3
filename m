Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932220AbaEPNeS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:34:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54131 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932155AbaEPNeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:34:14 -0400
Date: Fri, 16 May 2014 06:33:15 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-d07c9f18756e8231909a9bbcbfa7502c60cbc810@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, grant.likely@linaro.org, hpa@zytor.com,
        mingo@kernel.org, konrad.wilk@oracle.com, peterz@infradead.org,
        tony.luck@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, grant.likely@linaro.org,
        linux-kernel@vger.kernel.org, konrad.wilk@oracle.com,
        peterz@infradead.org, tony.luck@intel.com, tglx@linutronix.de
In-Reply-To: <20140507154335.959870037@linutronix.de>
References: <20140507154335.959870037@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] x86: Get rid of get_nr_irqs_gsi()
Git-Commit-ID: d07c9f18756e8231909a9bbcbfa7502c60cbc810
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d07c9f18756e8231909a9bbcbfa7502c60cbc810
Gitweb:     http://git.kernel.org/tip/d07c9f18756e8231909a9bbcbfa7502c60cbc810
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 7 May 2014 15:44:10 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 16 May 2014 14:05:19 +0200

x86: Get rid of get_nr_irqs_gsi()

No need to expose this outside of the ioapic code. The dynamic
allocations are guaranteed not to happen in the gsi space. See commit
62a08ae2a.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Grant Likely <grant.likely@linaro.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: x86@kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: xen-devel@lists.xenproject.org
Link: http://lkml.kernel.org/r/20140507154335.959870037@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 arch/x86/include/asm/io_apic.h   |  2 --
 arch/x86/kernel/apic/io_apic.c   |  5 -----
 drivers/xen/events/events_base.c | 17 +----------------
 3 files changed, 1 insertion(+), 23 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 459e50a..90f97b4 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -168,8 +168,6 @@ extern int save_ioapic_entries(void);
 extern void mask_ioapic_entries(void);
 extern int restore_ioapic_entries(void);
 
-extern int get_nr_irqs_gsi(void);
-
 extern void setup_ioapic_ids_from_mpc(void);
 extern void setup_ioapic_ids_from_mpc_nocheck(void);
 
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 3c17b25..be3b574 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3450,11 +3450,6 @@ static void __init probe_nr_irqs_gsi(void)
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
diff --git a/drivers/xen/events/events_base.c b/drivers/xen/events/events_base.c
index dfa12a4..c919d3d 100644
--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
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
