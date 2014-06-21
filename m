Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758429AbaFUVOr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 17:14:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35819 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756097AbaFUVOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 17:14:46 -0400
Date: Sat, 21 Jun 2014 14:13:37 -0700
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-4b92b4f754939e4ac6bb53355abbe48a5054b573@git.kernel.org>
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
In-Reply-To: <1402302011-23642-21-git-send-email-jiang.liu@linux.intel.com>
References: <1402302011-23642-21-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, irq: Simplify arch_early_irq_init()
Git-Commit-ID: 4b92b4f754939e4ac6bb53355abbe48a5054b573
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

Commit-ID:  4b92b4f754939e4ac6bb53355abbe48a5054b573
Gitweb:     http://git.kernel.org/tip/4b92b4f754939e4ac6bb53355abbe48a5054b573
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Mon, 9 Jun 2014 16:19:49 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 21 Jun 2014 23:05:42 +0200

x86, irq: Simplify arch_early_irq_init()

Simplify function arch_early_irq_init() and kill static array irq_cfgx[].

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
Link: http://lkml.kernel.org/r/1402302011-23642-21-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/apic/io_apic.c | 33 +++++++++++----------------------
 1 file changed, 11 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 4208ea9..e25e7e3 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -183,6 +183,7 @@ early_param("noapic", parse_noapic);
 
 static int io_apic_setup_irq_pin(unsigned int irq, int node,
 				 struct io_apic_irq_attr *attr);
+static struct irq_cfg *alloc_irq_and_cfg_at(unsigned int at, int node);
 
 /* Will be called in mpparse/acpi/sfi codes for saving IRQ info */
 void mp_save_irq(struct mpc_intsrc *m)
@@ -214,14 +215,10 @@ static struct irq_pin_list *alloc_irq_pin_list(int node)
 	return kzalloc_node(sizeof(struct irq_pin_list), GFP_KERNEL, node);
 }
 
-
-/* irq_cfg is indexed by the sum of all RTEs in all I/O APICs. */
-static struct irq_cfg irq_cfgx[NR_IRQS_LEGACY];
-
 int __init arch_early_irq_init(void)
 {
 	struct irq_cfg *cfg;
-	int count, node, i;
+	int i, node = cpu_to_node(0);
 
 	if (!nr_legacy_irqs())
 		io_apic_irqs = ~0UL;
@@ -234,22 +231,14 @@ int __init arch_early_irq_init(void)
 			pr_err("IOAPIC %d: suspend/resume impossible!\n", i);
 	}
 
-	cfg = irq_cfgx;
-	count = ARRAY_SIZE(irq_cfgx);
-	node = cpu_to_node(0);
-
-	for (i = 0; i < count; i++) {
-		irq_set_chip_data(i, &cfg[i]);
-		zalloc_cpumask_var_node(&cfg[i].domain, GFP_KERNEL, node);
-		zalloc_cpumask_var_node(&cfg[i].old_domain, GFP_KERNEL, node);
-		/*
-		 * For legacy IRQ's, start with assigning irq0 to irq15 to
-		 * IRQ0_VECTOR to IRQ15_VECTOR for all cpu's.
-		 */
-		if (i < nr_legacy_irqs()) {
-			cfg[i].vector = IRQ0_VECTOR + i;
-			cpumask_setall(cfg[i].domain);
-		}
+	/*
+	 * For legacy IRQ's, start with assigning irq0 to irq15 to
+	 * IRQ0_VECTOR to IRQ15_VECTOR for all cpu's.
+	 */
+	for (i = 0; i < nr_legacy_irqs(); i++) {
+		cfg = alloc_irq_and_cfg_at(i, node);
+		cfg->vector = IRQ0_VECTOR + i;
+		cpumask_setall(cfg->domain);
 	}
 
 	return 0;
@@ -3377,7 +3366,7 @@ int __init arch_probe_nr_irqs(void)
 	if (nr < nr_irqs)
 		nr_irqs = nr;
 
-	return nr_legacy_irqs();
+	return 0;
 }
 
 int io_apic_set_pci_routing(struct device *dev, int irq,
