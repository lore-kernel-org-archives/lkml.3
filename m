Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440AbaKHSRG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 13:17:06 -0500
Received: from mga11.intel.com ([192.55.52.93]:17466 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753976AbaKHSRD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 13:17:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="413534184"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Grant Likely <grant.likely@linaro.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: [Patch Part3 v3 28/38] x86, irq: Clean up io_apic.h
Date: Sun,  9 Nov 2014 02:13:28 +0800
Message-Id: <1415470418-10874-29-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1415470418-10874-1-git-send-email-jiang.liu@linux.intel.com>
References: <1415470418-10874-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clean up io_apic.h by:
1) moving definition of struct mp_ioapic_gsi into io_apic.c
2) changing mp_pin_to_gsi() and mp_ioapic_gsi_routing() as static
3) killing unused MP_MAX_IOAPIC_PIN
4) killing useless forward declaration
5) killing useless comments

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/include/asm/io_apic.h |   14 ++------------
 arch/x86/kernel/apic/io_apic.c |   23 ++++++++---------------
 2 files changed, 10 insertions(+), 27 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 21578af00243..b569ae098eb1 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -113,9 +113,6 @@ extern int nr_ioapics;
 
 extern int mpc_ioapic_id(int ioapic);
 extern unsigned int mpc_ioapic_addr(int ioapic);
-extern struct mp_ioapic_gsi *mp_ioapic_gsi_routing(int ioapic);
-
-#define MP_MAX_IOAPIC_PIN 127
 
 /* # of MP IRQ source entries */
 extern int mp_irq_entries;
@@ -135,6 +132,8 @@ extern int noioapicquirk;
 /* -1 if "noapic" boot option passed */
 extern int noioapicreroute;
 
+extern u32 gsi_top;
+
 extern unsigned long io_apic_irqs;
 
 #define IO_APIC_IRQ(x) (((x) >= NR_IRQS_LEGACY) || ((1 << (x)) & io_apic_irqs))
@@ -146,7 +145,6 @@ extern unsigned long io_apic_irqs;
 #define io_apic_assign_pci_irqs \
 	(mp_irq_entries && !skip_ioapic_setup && io_apic_irqs)
 
-struct irq_cfg;
 extern void ioapic_insert_resources(void);
 extern int arch_early_ioapic_init(void);
 
@@ -174,15 +172,8 @@ struct ioapic_domain_cfg {
 	struct device_node		*dev;
 };
 
-struct mp_ioapic_gsi{
-	u32 gsi_base;
-	u32 gsi_end;
-};
-extern u32 gsi_top;
-
 extern int mp_find_ioapic(u32 gsi);
 extern int mp_find_ioapic_pin(int ioapic, u32 gsi);
-extern u32 mp_pin_to_gsi(int ioapic, int pin);
 extern int mp_map_gsi_to_irq(u32 gsi, unsigned int flags,
 			     struct irq_alloc_info *info);
 extern void mp_unmap_irq(int irq);
@@ -231,7 +222,6 @@ static inline int arch_early_ioapic_init(void) { return 0; }
 static inline void print_IO_APICs(void) {}
 #define gsi_top (NR_IRQS_LEGACY)
 static inline int mp_find_ioapic(u32 gsi) { return 0; }
-static inline u32 mp_pin_to_gsi(int ioapic, int pin) { return UINT_MAX; }
 static inline int mp_map_gsi_to_irq(u32 gsi, unsigned int flags,
 				    struct irq_alloc_info *info)
 {
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 7a3679e43b67..a915ee005148 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -63,7 +63,6 @@
 #define	for_each_ioapic_pin(idx, pin)	\
 	for_each_ioapic((idx))		\
 		for_each_pin((idx), (pin))
-
 #define for_each_irq_pin(entry, head) \
 	list_for_each_entry(entry, &head, list)
 
@@ -94,6 +93,11 @@ struct mp_chip_data {
 	bool isa_irq;
 };
 
+struct mp_ioapic_gsi {
+	u32 gsi_base;
+	u32 gsi_end;
+};
+
 static struct ioapic {
 	/*
 	 * # of IRQ routing registers
@@ -124,7 +128,7 @@ unsigned int mpc_ioapic_addr(int ioapic_idx)
 	return ioapics[ioapic_idx].mp_config.apicaddr;
 }
 
-struct mp_ioapic_gsi *mp_ioapic_gsi_routing(int ioapic_idx)
+static inline struct mp_ioapic_gsi *mp_ioapic_gsi_routing(int ioapic_idx)
 {
 	return &ioapics[ioapic_idx].gsi_config;
 }
@@ -136,7 +140,7 @@ static inline int mp_ioapic_pin_count(int ioapic)
 	return gsi_cfg->gsi_end - gsi_cfg->gsi_base + 1;
 }
 
-u32 mp_pin_to_gsi(int ioapic, int pin)
+static inline u32 mp_pin_to_gsi(int ioapic, int pin)
 {
 	return mp_ioapic_gsi_routing(ioapic)->gsi_base + pin;
 }
@@ -1146,8 +1150,7 @@ static int pin_2_irq(int idx, int ioapic, int pin, unsigned int flags)
 	return  mp_map_pin_to_irq(gsi, idx, ioapic, pin, flags, NULL);
 }
 
-int mp_map_gsi_to_irq(u32 gsi, unsigned int flags,
-		      struct irq_alloc_info *info)
+int mp_map_gsi_to_irq(u32 gsi, unsigned int flags, struct irq_alloc_info *info)
 {
 	int ioapic, pin, idx;
 
@@ -1709,7 +1712,6 @@ static int __init timer_irq_works(void)
  * This is not complete - we should be able to fake
  * an edge even if it isn't on the 8259A...
  */
-
 static unsigned int startup_ioapic_irq(struct irq_data *data)
 {
 	int was_pending = 0, irq = data->irq;
@@ -1727,15 +1729,6 @@ static unsigned int startup_ioapic_irq(struct irq_data *data)
 	return was_pending;
 }
 
-/*
- * Level and edge triggered IO-APIC interrupts need different handling,
- * so we use two separate IRQ descriptors. Edge triggered IRQs can be
- * handled with the level-triggered descriptor, but that one has slightly
- * more overhead. Level-triggered interrupts cannot be handled with the
- * edge-triggered handler, without risking IRQ storms and other ugly
- * races.
- */
-
 static void __target_IO_APIC_irq(unsigned int irq, struct irq_cfg *cfg,
 				 struct mp_chip_data *data)
 {
-- 
1.7.10.4

