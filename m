Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696AbaEPITQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 04:19:16 -0400
Received: from mga11.intel.com ([192.55.52.93]:21090 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756172AbaEPIFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 04:05:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1065,1389772800"; 
   d="scan'208";a="540107088"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        x86@kernel.org, Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, sfi-devel@simplefirmware.org,
        Ingo Molnar <mingo@kernel.org>
Subject: [RFC Patch Part1 V1 14/30] x86, ioapic: use irq_cfg() instead of irq_get_chip_data() for better readability
Date: Fri, 16 May 2014 16:05:34 +0800
Message-Id: <1400227550-5935-15-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1400227550-5935-1-git-send-email-jiang.liu@linux.intel.com>
References: <1400227550-5935-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use defined helper function irq_cfg() instead of irq_get_chip_data() for
better readability.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/kernel/apic/io_apic.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 86f9511c97a0..8d6e4c7e7011 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -233,7 +233,7 @@ int __init arch_early_irq_init(void)
 	return 0;
 }
 
-static struct irq_cfg *irq_cfg(unsigned int irq)
+static inline struct irq_cfg *irq_cfg(unsigned int irq)
 {
 	return irq_get_chip_data(irq);
 }
@@ -275,7 +275,7 @@ static struct irq_cfg *alloc_irq_and_cfg_at(unsigned int at, int node)
 	if (res < 0) {
 		if (res != -EEXIST)
 			return NULL;
-		cfg = irq_get_chip_data(at);
+		cfg = irq_cfg(at);
 		if (cfg)
 			return cfg;
 	}
@@ -1219,7 +1219,7 @@ void __setup_vector_irq(int cpu)
 	raw_spin_lock(&vector_lock);
 	/* Mark the inuse vectors */
 	for_each_active_irq(irq) {
-		cfg = irq_get_chip_data(irq);
+		cfg = irq_cfg(irq);
 		if (!cfg)
 			continue;
 
@@ -1627,7 +1627,7 @@ __apicdebuginit(void) print_IO_APICs(void)
 		if (chip != &ioapic_chip)
 			continue;
 
-		cfg = irq_get_chip_data(irq);
+		cfg = irq_cfg(irq);
 		if (!cfg)
 			continue;
 		entry = cfg->irq_2_pin;
@@ -2268,7 +2268,7 @@ static void irq_complete_move(struct irq_cfg *cfg)
 
 void irq_force_complete_move(int irq)
 {
-	struct irq_cfg *cfg = irq_get_chip_data(irq);
+	struct irq_cfg *cfg = irq_cfg(irq);
 
 	if (!cfg)
 		return;
@@ -2541,7 +2541,7 @@ static inline void init_IO_APIC_traps(void)
 	 * 0x80, because int 0x80 is hm, kind of importantish. ;)
 	 */
 	for_each_active_irq(irq) {
-		cfg = irq_get_chip_data(irq);
+		cfg = irq_cfg(irq);
 		if (IO_APIC_IRQ(irq) && cfg && !cfg->vector) {
 			/*
 			 * Hmm.. We don't have an entry for this,
@@ -2674,7 +2674,7 @@ early_param("disable_timer_pin_1", disable_timer_pin_setup);
  */
 static inline void __init check_timer(void)
 {
-	struct irq_cfg *cfg = irq_get_chip_data(0);
+	struct irq_cfg *cfg = irq_cfg(0);
 	int node = cpu_to_node(0);
 	int apic1, pin1, apic2, pin2;
 	unsigned long flags;
@@ -2981,7 +2981,7 @@ int create_irq(void)
 
 void destroy_irq(unsigned int irq)
 {
-	struct irq_cfg *cfg = irq_get_chip_data(irq);
+	struct irq_cfg *cfg = irq_cfg(irq);
 	unsigned long flags;
 
 	irq_set_status_flags(irq, IRQ_NOREQUEST|IRQ_NOPROBE);
@@ -3117,7 +3117,7 @@ int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc,
 	if (!irq_offset)
 		write_msi_msg(irq, &msg);
 
-	setup_remapped_irq(irq, irq_get_chip_data(irq), chip);
+	setup_remapped_irq(irq, irq_cfg(irq), chip);
 
 	irq_set_chip_and_handler_name(irq, chip, handle_edge_irq, "edge");
 
@@ -3255,7 +3255,7 @@ int default_setup_hpet_msi(unsigned int irq, unsigned int id)
 
 	hpet_msi_write(irq_get_handler_data(irq), &msg);
 	irq_set_status_flags(irq, IRQ_MOVE_PCNTXT);
-	setup_remapped_irq(irq, irq_get_chip_data(irq), chip);
+	setup_remapped_irq(irq, irq_cfg(irq), chip);
 
 	irq_set_chip_and_handler_name(irq, chip, handle_edge_irq, "edge");
 	return 0;
-- 
1.7.10.4

