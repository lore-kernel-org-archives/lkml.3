Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758155AbaFUVMx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 17:12:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35686 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754832AbaFUVMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 17:12:51 -0400
Date: Sat, 21 Jun 2014 14:11:48 -0700
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-518b2c63fcdde0723d2719bbe5b14086bdc8ec80@git.kernel.org>
Cc: mingo@kernel.org, konrad.wilk@oracle.com, rdunlap@infradead.org,
        tony.luck@intel.com, gregkh@linuxfoundation.org, tglx@linutronix.de,
        hpa@zytor.com, jiang.liu@linux.intel.com, grant.likely@linaro.org,
        linux-kernel@vger.kernel.org, yinghai@kernel.org, joro@8bytes.org,
        benh@kernel.crashing.org, bhelgaas@google.com, rjw@rjwysocki.net,
        paul.gortmaker@windriver.com
Reply-To: mingo@kernel.org, konrad.wilk@oracle.com, rdunlap@infradead.org,
        tony.luck@intel.com, gregkh@linuxfoundation.org, tglx@linutronix.de,
        hpa@zytor.com, jiang.liu@linux.intel.com, grant.likely@linaro.org,
        linux-kernel@vger.kernel.org, yinghai@kernel.org, joro@8bytes.org,
        benh@kernel.crashing.org, bhelgaas@google.com, rjw@rjwysocki.net,
        paul.gortmaker@windriver.com
In-Reply-To: <1402302011-23642-13-git-send-email-jiang.liu@linux.intel.com>
References: <1402302011-23642-13-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, ioapic: Kill static variable nr_irqs_gsi
Git-Commit-ID: 518b2c63fcdde0723d2719bbe5b14086bdc8ec80
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

Commit-ID:  518b2c63fcdde0723d2719bbe5b14086bdc8ec80
Gitweb:     http://git.kernel.org/tip/518b2c63fcdde0723d2719bbe5b14086bdc8ec80
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Mon, 9 Jun 2014 16:19:41 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 21 Jun 2014 23:05:41 +0200

x86, ioapic: Kill static variable nr_irqs_gsi

Static variable nr_irqs_gsi is used to maintain the lowest dynamic
allocatable IRQ number. It may cause trouble when enabling dynamic
IRQ allocation for IOAPIC, so use arch_dynirq_lower_bound() to
avoid directly accessing nr_irqs_gsi and kill nr_irqs_gsi.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1402302011-23642-13-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/apic/io_apic.c | 24 +++++-------------------
 1 file changed, 5 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 18ab95b..46d09ea 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -118,9 +118,6 @@ struct mpc_intsrc mp_irqs[MAX_IRQ_SOURCES];
 /* # of MP IRQ source entries */
 int mp_irq_entries;
 
-/* GSI interrupts */
-static int nr_irqs_gsi = NR_IRQS_LEGACY;
-
 #ifdef CONFIG_EISA
 int mp_bus_id_to_type[MAX_MP_BUSSES];
 #endif
@@ -3326,20 +3323,11 @@ static int __init io_apic_get_redir_entries(int ioapic)
 	return reg_01.bits.entries + 1;
 }
 
-static void __init probe_nr_irqs_gsi(void)
-{
-	int nr;
-
-	nr = gsi_top + NR_IRQS_LEGACY;
-	if (nr > nr_irqs_gsi)
-		nr_irqs_gsi = nr;
-
-	printk(KERN_DEBUG "nr_irqs_gsi: %d\n", nr_irqs_gsi);
-}
-
 unsigned int arch_dynirq_lower_bound(unsigned int from)
 {
-	return from < nr_irqs_gsi ? nr_irqs_gsi : from;
+	unsigned int min = gsi_top + NR_IRQS_LEGACY;
+
+	return from < min ? min : from;
 }
 
 int __init arch_probe_nr_irqs(void)
@@ -3349,12 +3337,12 @@ int __init arch_probe_nr_irqs(void)
 	if (nr_irqs > (NR_VECTORS * nr_cpu_ids))
 		nr_irqs = NR_VECTORS * nr_cpu_ids;
 
-	nr = nr_irqs_gsi + 8 * nr_cpu_ids;
+	nr = (gsi_top + NR_IRQS_LEGACY) + 8 * nr_cpu_ids;
 #if defined(CONFIG_PCI_MSI) || defined(CONFIG_HT_IRQ)
 	/*
 	 * for MSI and HT dyn irq
 	 */
-	nr += nr_irqs_gsi * 16;
+	nr += (gsi_top + NR_IRQS_LEGACY) * 16;
 #endif
 	if (nr < nr_irqs)
 		nr_irqs = nr;
@@ -3627,8 +3615,6 @@ fake_ioapic_page:
 		ioapic_res->end = ioapic_phys + IO_APIC_SLOT_SIZE - 1;
 		ioapic_res++;
 	}
-
-	probe_nr_irqs_gsi();
 }
 
 void __init ioapic_insert_resources(void)
