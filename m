Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757984AbaFUVTA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 17:19:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36191 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757085AbaFUVS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 17:18:58 -0400
Date: Sat, 21 Jun 2014 14:15:49 -0700
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-d7b830013f59cf586c1cec3caa1ce7156da59a13@git.kernel.org>
Cc: mingo@kernel.org, konrad.wilk@oracle.com, rdunlap@infradead.org,
        tony.luck@intel.com, gregkh@linuxfoundation.org, tglx@linutronix.de,
        len.brown@intel.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        jiang.liu@linux.intel.com, grant.likely@linaro.org, yinghai@kernel.org,
        joro@8bytes.org, pavel@ucw.cz, benh@kernel.crashing.org,
        bhelgaas@google.com, rjw@rjwysocki.net, paul.gortmaker@windriver.com
Reply-To: mingo@kernel.org, konrad.wilk@oracle.com, rdunlap@infradead.org,
        tony.luck@intel.com, gregkh@linuxfoundation.org, tglx@linutronix.de,
        len.brown@intel.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        jiang.liu@linux.intel.com, grant.likely@linaro.org, yinghai@kernel.org,
        joro@8bytes.org, pavel@ucw.cz, benh@kernel.crashing.org,
        bhelgaas@google.com, rjw@rjwysocki.net, paul.gortmaker@windriver.com
In-Reply-To: <1402302011-23642-31-git-send-email-jiang.liu@linux.intel.com>
References: <1402302011-23642-31-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, irq, ACPI:
  Use common irqdomain map interface to program IOAPIC pins
Git-Commit-ID: d7b830013f59cf586c1cec3caa1ce7156da59a13
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

Commit-ID:  d7b830013f59cf586c1cec3caa1ce7156da59a13
Gitweb:     http://git.kernel.org/tip/d7b830013f59cf586c1cec3caa1ce7156da59a13
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Mon, 9 Jun 2014 16:19:59 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 21 Jun 2014 23:05:43 +0200

x86, irq, ACPI: Use common irqdomain map interface to program IOAPIC pins

Refine ACPI to use common irqdomain map interface to program IOAPIC pins,
so we can unify the callsite to progam IOAPIC pins.

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
Cc: Len Brown <len.brown@intel.com>
Cc: Pavel Machek <pavel@ucw.cz>
Link: http://lkml.kernel.org/r/1402302011-23642-31-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/acpi/boot.c | 44 ++++++++++++--------------------------------
 1 file changed, 12 insertions(+), 32 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 8d9aee1..9add76f 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -405,11 +405,7 @@ static int mp_config_acpi_gsi(struct device *dev, u32 gsi, int trigger,
 static int mp_register_gsi(struct device *dev, u32 gsi, int trigger,
 			   int polarity)
 {
-	int irq;
-	int ioapic;
-	int ioapic_pin;
-	struct io_apic_irq_attr irq_attr;
-	int ret;
+	int irq, node;
 
 	if (acpi_irq_model != ACPI_IRQ_MODEL_IOAPIC)
 		return gsi;
@@ -418,39 +414,27 @@ static int mp_register_gsi(struct device *dev, u32 gsi, int trigger,
 	if (acpi_gbl_FADT.sci_interrupt == gsi)
 		return gsi;
 
+	trigger = trigger == ACPI_EDGE_SENSITIVE ? 0 : 1;
+	polarity = polarity == ACPI_ACTIVE_HIGH ? 0 : 1;
+	node = dev ? dev_to_node(dev) : NUMA_NO_NODE;
+	if (mp_set_gsi_attr(gsi, trigger, polarity, node)) {
+		pr_warn("Failed to set pin attr for GSI%d\n", gsi);
+		return -1;
+	}
+
 	irq = map_gsi_to_irq(gsi, IOAPIC_MAP_ALLOC);
 	if (irq < 0)
 		return irq;
 
-	ioapic = mp_find_ioapic(gsi);
-	if (ioapic < 0) {
-		printk(KERN_WARNING "No IOAPIC for GSI %u\n", gsi);
-		return gsi;
-	}
-
-	ioapic_pin = mp_find_ioapic_pin(ioapic, gsi);
-
-	if (ioapic_pin > MP_MAX_IOAPIC_PIN) {
-		printk(KERN_ERR "Invalid reference to IOAPIC pin "
-		       "%d-%d\n", mpc_ioapic_id(ioapic),
-		       ioapic_pin);
-		return gsi;
-	}
-
 	if (enable_update_mptable)
 		mp_config_acpi_gsi(dev, gsi, trigger, polarity);
 
-	set_io_apic_irq_attr(&irq_attr, ioapic, ioapic_pin,
-			     trigger == ACPI_EDGE_SENSITIVE ? 0 : 1,
-			     polarity == ACPI_ACTIVE_HIGH ? 0 : 1);
-	ret = io_apic_set_pci_routing(dev, irq, &irq_attr);
-	if (ret < 0)
-		irq = -1;
-
 	return irq;
 }
 
-static struct irq_domain_ops acpi_irqdomain_ops;
+static struct irq_domain_ops acpi_irqdomain_ops = {
+	.map = mp_irqdomain_map,
+};
 
 static int __init
 acpi_parse_ioapic(struct acpi_subtable_header * header, const unsigned long end)
@@ -622,10 +606,6 @@ int acpi_gsi_to_irq(u32 gsi, unsigned int *irqp)
 	int irq = map_gsi_to_irq(gsi, IOAPIC_MAP_ALLOC | IOAPIC_MAP_CHECK);
 
 	if (irq >= 0) {
-#ifdef CONFIG_X86_IO_APIC
-		if (acpi_irq_model == ACPI_IRQ_MODEL_IOAPIC)
-			setup_IO_APIC_irq_extra(gsi);
-#endif
 		*irqp = irq;
 		return 0;
 	}
