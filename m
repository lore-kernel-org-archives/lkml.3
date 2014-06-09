Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932254AbaFIIWC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 04:22:02 -0400
Received: from mga01.intel.com ([192.55.52.88]:58147 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932183AbaFIIV5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:21:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="352321295"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@linaro.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        x86@kernel.org, Len Brown <lenb@kernel.org>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Kuppuswamy Sathyanarayanan 
	<sathyanarayanan.kuppuswamy@linux.intel.com>,
        Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, "H. Peter Anvin" <hpa@linux.intel.com>,
        sfi-devel@simplefirmware.org
Subject: [Patch V4 27/42] x86, SFI, irq: provide basic irqdomain support
Date: Mon,  9 Jun 2014 16:19:56 +0800
Message-Id: <1402302011-23642-28-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1402302011-23642-1-git-send-email-jiang.liu@linux.intel.com>
References: <1402302011-23642-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enhance SFI to provide basic support of irqdomain with identity mapping
between GSIs and IRQs.

Some Intel MID platforms assumes identity mapping between GSI and IRQ,
so we can't dynamically allocate IRQ number on demand.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/pci/intel_mid_pci.c      |    3 +++
 arch/x86/platform/intel-mid/sfi.c |    2 ++
 arch/x86/platform/sfi/sfi.c       |    8 +++++++-
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/x86/pci/intel_mid_pci.c b/arch/x86/pci/intel_mid_pci.c
index 84b9d672843d..fcbdc5fac2c6 100644
--- a/arch/x86/pci/intel_mid_pci.c
+++ b/arch/x86/pci/intel_mid_pci.c
@@ -217,6 +217,9 @@ static int intel_mid_pci_irq_enable(struct pci_dev *dev)
 	 * MRST only have IOAPIC, the PCI irq lines are 1:1 mapped to
 	 * IOAPIC RTE entries, so we just enable RTE for the device.
 	 */
+	if (mp_map_gsi_to_irq(dev->irq, IOAPIC_MAP_ALLOC) < 0)
+		return -EBUSY;
+
 	irq_attr.ioapic = mp_find_ioapic(dev->irq);
 	irq_attr.ioapic_pin = dev->irq;
 	irq_attr.trigger = 1; /* level */
diff --git a/arch/x86/platform/intel-mid/sfi.c b/arch/x86/platform/intel-mid/sfi.c
index 994c40bd7cb7..7161395e7de7 100644
--- a/arch/x86/platform/intel-mid/sfi.c
+++ b/arch/x86/platform/intel-mid/sfi.c
@@ -473,6 +473,8 @@ static int __init sfi_parse_devs(struct sfi_table_header *table)
 					/* PNW and CLV go with active low */
 					irq_attr.polarity = 1;
 				}
+				WARN_ON(mp_map_gsi_to_irq(irq,
+						IOAPIC_MAP_ALLOC) < 0);
 				io_apic_set_pci_routing(NULL, irq, &irq_attr);
 			}
 		} else {
diff --git a/arch/x86/platform/sfi/sfi.c b/arch/x86/platform/sfi/sfi.c
index 8f2f789c6f04..1fdaa57f41a5 100644
--- a/arch/x86/platform/sfi/sfi.c
+++ b/arch/x86/platform/sfi/sfi.c
@@ -25,6 +25,7 @@
 #include <linux/init.h>
 #include <linux/sfi.h>
 #include <linux/io.h>
+#include <linux/irqdomain.h>
 
 #include <asm/io_apic.h>
 #include <asm/mpspec.h>
@@ -70,19 +71,24 @@ static int __init sfi_parse_cpus(struct sfi_table_header *table)
 #endif /* CONFIG_X86_LOCAL_APIC */
 
 #ifdef CONFIG_X86_IO_APIC
+static struct irq_domain_ops sfi_ioapic_irqdomain_ops;
 
 static int __init sfi_parse_ioapic(struct sfi_table_header *table)
 {
 	struct sfi_table_simple *sb;
 	struct sfi_apic_table_entry *pentry;
 	int i, num;
+	struct ioapic_domain_cfg cfg = {
+		.type = IOAPIC_DOMAIN_STRICT,
+		.ops = &sfi_ioapic_irqdomain_ops,
+	};
 
 	sb = (struct sfi_table_simple *)table;
 	num = SFI_GET_NUM_ENTRIES(sb, struct sfi_apic_table_entry);
 	pentry = (struct sfi_apic_table_entry *)sb->pentry;
 
 	for (i = 0; i < num; i++) {
-		mp_register_ioapic(i, pentry->phys_addr, gsi_top, NULL);
+		mp_register_ioapic(i, pentry->phys_addr, gsi_top, &cfg);
 		pentry++;
 	}
 
-- 
1.7.10.4

