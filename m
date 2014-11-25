Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663AbaKYHto (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 02:49:44 -0500
Received: from mga11.intel.com ([192.55.52.93]:24366 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752086AbaKYHtl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 02:49:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,454,1413270000"; 
   d="scan'208";a="627834762"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
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
Subject: [Patch Part3 v4 11/38] x86, irq: Kill unused struct mp_pin_info
Date: Tue, 25 Nov 2014 15:49:35 +0800
Message-Id: <1416901802-24211-12-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1416901802-24211-1-git-send-email-jiang.liu@linux.intel.com>
References: <1416901802-24211-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now nobody makes use of struct mp_pin_info, so kill it.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Tested-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/kernel/apic/io_apic.c |   30 +++---------------------------
 1 file changed, 3 insertions(+), 27 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 993a0303370f..551108e35cf0 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -88,13 +88,6 @@ struct mp_chip_data {
 	bool isa_irq;
 };
 
-struct mp_pin_info {
-	int trigger;
-	int polarity;
-	int set;
-	u32 count;
-};
-
 static struct ioapic {
 	/*
 	 * # of IRQ routing registers
@@ -110,7 +103,6 @@ static struct ioapic {
 	struct mp_ioapic_gsi  gsi_config;
 	struct ioapic_domain_cfg irqdomain_cfg;
 	struct irq_domain *irqdomain;
-	struct mp_pin_info *pin_info;
 	struct resource *iomem_res;
 } ioapics[MAX_IO_APICS];
 
@@ -156,11 +148,6 @@ static inline int mp_init_irq_at_boot(int ioapic, int irq)
 	return ioapic == 0 || (irq >= 0 && irq < nr_legacy_irqs());
 }
 
-static inline struct mp_pin_info *mp_pin_info(int ioapic_idx, int pin)
-{
-	return ioapics[ioapic_idx].pin_info + pin;
-}
-
 static inline struct irq_domain *mp_ioapic_irqdomain(int ioapic)
 {
 	return ioapics[ioapic].irqdomain;
@@ -2422,7 +2409,6 @@ out:
 
 static int mp_irqdomain_create(int ioapic)
 {
-	size_t size;
 	struct irq_alloc_info info;
 	struct irq_domain *parent;
 	int hwirqs = mp_ioapic_pin_count(ioapic);
@@ -2430,11 +2416,6 @@ static int mp_irqdomain_create(int ioapic)
 	struct ioapic_domain_cfg *cfg = &ip->irqdomain_cfg;
 	struct mp_ioapic_gsi *gsi_cfg = mp_ioapic_gsi_routing(ioapic);
 
-	size = sizeof(struct mp_pin_info) * mp_ioapic_pin_count(ioapic);
-	ip->pin_info = kzalloc(size, GFP_KERNEL);
-	if (!ip->pin_info)
-		return -ENOMEM;
-
 	if (cfg->type == IOAPIC_DOMAIN_INVALID)
 		return 0;
 
@@ -2447,13 +2428,10 @@ static int mp_irqdomain_create(int ioapic)
 
 	ip->irqdomain = irq_domain_add_linear(cfg->dev, hwirqs, cfg->ops,
 					      (void *)(long)ioapic);
-	if (ip->irqdomain) {
-		ip->irqdomain->parent = parent;
-	} else {
-		kfree(ip->pin_info);
-		ip->pin_info = NULL;
+	if (!ip->irqdomain)
 		return -ENOMEM;
-	}
+
+	ip->irqdomain->parent = parent;
 
 	if (cfg->type == IOAPIC_DOMAIN_LEGACY ||
 	    cfg->type == IOAPIC_DOMAIN_STRICT)
@@ -2469,8 +2447,6 @@ static void ioapic_destroy_irqdomain(int idx)
 		irq_domain_remove(ioapics[idx].irqdomain);
 		ioapics[idx].irqdomain = NULL;
 	}
-	kfree(ioapics[idx].pin_info);
-	ioapics[idx].pin_info = NULL;
 }
 
 void __init setup_IO_APIC(void)
-- 
1.7.10.4

