Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213AbaKZXPl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 18:15:41 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58656 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbaKZXPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 18:15:38 -0500
Date: Wed, 26 Nov 2014 15:14:44 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-ca088857c213f42ad2a0a8ea2088f8f95a2fb5ad@git.kernel.org>
Cc: bp@alien8.de, yinghai@kernel.org, rdunlap@infradead.org,
        grant.likely@linaro.org, jroedel@suse.de, konrad.wilk@oracle.com,
        rjw@rjwysocki.net, jiang.liu@linux.intel.com,
        gregkh@linuxfoundation.org, benh@kernel.crashing.org,
        tglx@linutronix.de, hpa@zytor.com, tony.luck@intel.com,
        linux-kernel@vger.kernel.org, joro@8bytes.org, bhelgaas@google.com,
        mingo@kernel.org
Reply-To: rdunlap@infradead.org, yinghai@kernel.org, bp@alien8.de,
        jiang.liu@linux.intel.com, rjw@rjwysocki.net, konrad.wilk@oracle.com,
        jroedel@suse.de, grant.likely@linaro.org, tglx@linutronix.de,
        benh@kernel.crashing.org, gregkh@linuxfoundation.org, mingo@kernel.org,
        bhelgaas@google.com, joro@8bytes.org, linux-kernel@vger.kernel.org,
        hpa@zytor.com, tony.luck@intel.com
In-Reply-To: <1416901802-24211-9-git-send-email-jiang.liu@linux.intel.com>
References: <1416901802-24211-9-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, irq:
  Introduce helper functions to support hierarchy irqdomain for IOAPIC
Git-Commit-ID: ca088857c213f42ad2a0a8ea2088f8f95a2fb5ad
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

Commit-ID:  ca088857c213f42ad2a0a8ea2088f8f95a2fb5ad
Gitweb:     http://git.kernel.org/tip/ca088857c213f42ad2a0a8ea2088f8f95a2fb5ad
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Tue, 25 Nov 2014 15:49:32 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 26 Nov 2014 23:52:46 +0100

x86, irq: Introduce helper functions to support hierarchy irqdomain for IOAPIC

Introduce several helper functions, which will be used to enable
hierarchy irqdomain for IOAPIC.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Grant Likely <grant.likely@linaro.org>
Link: http://lkml.kernel.org/r/1416901802-24211-9-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/kernel/apic/io_apic.c | 59 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 59 insertions(+)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index b2618d4..721be8c 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -67,6 +67,8 @@
 #define for_each_irq_pin(entry, head) \
 	list_for_each_entry(entry, &head, list)
 
+int acpi_get_override_irq(u32 gsi, int *trigger, int *polarity);
+
 /*
  *      Is the SiS APIC rmw bug present ?
  *      -1 = don't know, 0 = no, 1 = yes
@@ -82,6 +84,7 @@ struct mp_chip_data {
 	struct IO_APIC_route_entry entry;
 	int trigger;
 	int polarity;
+	u32 count;
 	bool isa_irq;
 };
 
@@ -945,6 +948,42 @@ void ioapic_set_alloc_attr(struct irq_alloc_info *info, int node,
 	info->ioapic_valid = 1;
 }
 
+static void ioapic_copy_alloc_attr(struct irq_alloc_info *dst,
+				   struct irq_alloc_info *src,
+				   u32 gsi, int ioapic_idx, int pin)
+{
+	int trigger, polarity;
+
+	copy_irq_alloc_info(dst, src);
+	dst->type = X86_IRQ_ALLOC_TYPE_IOAPIC;
+	dst->ioapic_id = mpc_ioapic_id(ioapic_idx);
+	dst->ioapic_pin = pin;
+	dst->ioapic_valid = 1;
+	if (src && src->ioapic_valid) {
+		dst->ioapic_node = src->ioapic_node;
+		dst->ioapic_trigger = src->ioapic_trigger;
+		dst->ioapic_polarity = src->ioapic_polarity;
+	} else {
+		dst->ioapic_node = NUMA_NO_NODE;
+		if (acpi_get_override_irq(gsi, &trigger, &polarity) >= 0) {
+			dst->ioapic_trigger = trigger;
+			dst->ioapic_polarity = polarity;
+		} else {
+			/*
+			 * PCI interrupts are always polarity one level
+			 * triggered.
+			 */
+			dst->ioapic_trigger = 1;
+			dst->ioapic_polarity = 1;
+		}
+	}
+}
+
+static int ioapic_alloc_attr_node(struct irq_alloc_info *info)
+{
+	return (info && info->ioapic_valid) ? info->ioapic_node : NUMA_NO_NODE;
+}
+
 static void mp_register_handler(unsigned int irq, unsigned long trigger)
 {
 	irq_flow_handler_t hdl;
@@ -962,6 +1001,26 @@ static void mp_register_handler(unsigned int irq, unsigned long trigger)
 	__irq_set_handler(irq, hdl, 0, fasteoi ? "fasteoi" : "edge");
 }
 
+static bool mp_check_pin_attr(int irq, struct irq_alloc_info *info)
+{
+	struct mp_chip_data *data = irq_get_chip_data(irq);
+
+	/*
+	 * setup_IO_APIC_irqs() programs all legacy IRQs with default trigger
+	 * and polarity attirbutes. So allow the first user to reprogram the
+	 * pin with real trigger and polarity attributes.
+	 */
+	if (irq < nr_legacy_irqs() && data->count == 1) {
+		if (info->ioapic_trigger != data->trigger)
+			mp_register_handler(irq, data->trigger);
+		data->entry.trigger = data->trigger = info->ioapic_trigger;
+		data->entry.polarity = data->polarity = info->ioapic_polarity;
+	}
+
+	return data->trigger == info->ioapic_trigger &&
+	       data->polarity == info->ioapic_polarity;
+}
+
 static int alloc_irq_from_domain(struct irq_domain *domain, u32 gsi, int pin,
 				 struct irq_alloc_info *info)
 {
