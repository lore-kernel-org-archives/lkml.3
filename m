Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102AbaIZO5T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 10:57:19 -0400
Received: from mga14.intel.com ([192.55.52.115]:48078 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756060AbaIZO5P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 10:57:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,604,1406617200"; 
   d="scan'208";a="597292626"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: [RFC v1 23/28] x86, irq: Clean up io_apic.h
Date: Fri, 26 Sep 2014 22:57:53 +0800
Message-Id: <1411743478-31435-24-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1411743478-31435-1-git-send-email-jiang.liu@linux.intel.com>
References: <1411743478-31435-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clean up io_apic.h by:
1) moving definition of struct mp_ioapic_gsi into io_apic.c
2) changing mp_pin_to_gsi() and mp_ioapic_gsi_routing() as static
3) killing unused MP_MAX_IOAPIC_PIN
4) killing useless forward declaration

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/include/asm/io_apic.h |   14 ++------------
 arch/x86/kernel/apic/io_apic.c |    9 +++++++--
 2 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index e978dc335eea..840e366ea0d3 100644
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
@@ -232,7 +223,6 @@ static inline int arch_early_ioapic_init(void) { return 0; }
 static inline void print_IO_APICs(void) {}
 #define gsi_top (NR_IRQS_LEGACY)
 static inline int mp_find_ioapic(u32 gsi) { return 0; }
-static inline u32 mp_pin_to_gsi(int ioapic, int pin) { return UINT_MAX; }
 static inline int mp_map_gsi_to_irq(u32 gsi, unsigned int flags,
 				    struct irq_alloc_info *info)
 {
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index f55ab3a8de08..4c8c22171f43 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -98,6 +98,11 @@ struct mp_pin_info {
 	u32 count;
 };
 
+struct mp_ioapic_gsi{
+	u32 gsi_base;
+	u32 gsi_end;
+};
+
 static struct ioapic {
 	/*
 	 * # of IRQ routing registers
@@ -129,7 +134,7 @@ unsigned int mpc_ioapic_addr(int ioapic_idx)
 	return ioapics[ioapic_idx].mp_config.apicaddr;
 }
 
-struct mp_ioapic_gsi *mp_ioapic_gsi_routing(int ioapic_idx)
+static struct mp_ioapic_gsi *mp_ioapic_gsi_routing(int ioapic_idx)
 {
 	return &ioapics[ioapic_idx].gsi_config;
 }
@@ -141,7 +146,7 @@ static inline int mp_ioapic_pin_count(int ioapic)
 	return gsi_cfg->gsi_end - gsi_cfg->gsi_base + 1;
 }
 
-u32 mp_pin_to_gsi(int ioapic, int pin)
+static u32 mp_pin_to_gsi(int ioapic, int pin)
 {
 	return mp_ioapic_gsi_routing(ioapic)->gsi_base + pin;
 }
-- 
1.7.10.4

