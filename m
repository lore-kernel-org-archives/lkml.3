Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758590AbaFUVQM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 17:16:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35949 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755828AbaFUVQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 17:16:08 -0400
Date: Sat, 21 Jun 2014 14:15:11 -0700
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-1b5d3e00d45e093fa0551c588034c3355b362f66@git.kernel.org>
Cc: mingo@kernel.org, konrad.wilk@oracle.com, david.a.cohen@linux.intel.com,
        rdunlap@infradead.org, tony.luck@intel.com, gregkh@linuxfoundation.org,
        lenb@kernel.org, tglx@linutronix.de, linux-kernel@vger.kernel.org,
        hpa@zytor.com, jiang.liu@linux.intel.com, grant.likely@linaro.org,
        yinghai@kernel.org, sathyanarayanan.kuppuswamy@linux.intel.com,
        joro@8bytes.org, benh@kernel.crashing.org, bhelgaas@google.com,
        rjw@rjwysocki.net, hpa@linux.intel.com, paul.gortmaker@windriver.com
Reply-To: mingo@kernel.org, konrad.wilk@oracle.com,
        david.a.cohen@linux.intel.com, rdunlap@infradead.org,
        tony.luck@intel.com, gregkh@linuxfoundation.org, lenb@kernel.org,
        tglx@linutronix.de, linux-kernel@vger.kernel.org, hpa@zytor.com,
        jiang.liu@linux.intel.com, grant.likely@linaro.org, yinghai@kernel.org,
        sathyanarayanan.kuppuswamy@linux.intel.com, joro@8bytes.org,
        bhelgaas@google.com, benh@kernel.crashing.org, rjw@rjwysocki.net,
        hpa@linux.intel.com, paul.gortmaker@windriver.com
In-Reply-To: <1402302011-23642-28-git-send-email-jiang.liu@linux.intel.com>
References: <1402302011-23642-28-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, SFI, irq: Provide basic irqdomain support
Git-Commit-ID: 1b5d3e00d45e093fa0551c588034c3355b362f66
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

Commit-ID:  1b5d3e00d45e093fa0551c588034c3355b362f66
Gitweb:     http://git.kernel.org/tip/1b5d3e00d45e093fa0551c588034c3355b362f66
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Mon, 9 Jun 2014 16:19:56 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 21 Jun 2014 23:05:43 +0200

x86, SFI, irq: Provide basic irqdomain support

Enhance SFI to provide basic support of irqdomain with identity mapping
between GSIs and IRQs.

Some Intel MID platforms assumes identity mapping between GSI and IRQ,
so we can't dynamically allocate IRQ number on demand.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: H. Peter Anvin <hpa@linux.intel.com>
Cc: sfi-devel@simplefirmware.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Len Brown <lenb@kernel.org>
Cc: David Cohen <david.a.cohen@linux.intel.com>
Cc: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Link: http://lkml.kernel.org/r/1402302011-23642-28-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/pci/intel_mid_pci.c      | 3 +++
 arch/x86/platform/intel-mid/sfi.c | 2 ++
 arch/x86/platform/sfi/sfi.c       | 8 +++++++-
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/x86/pci/intel_mid_pci.c b/arch/x86/pci/intel_mid_pci.c
index 84b9d67..fcbdc5fa 100644
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
index 994c40b..7161395 100644
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
index 8f2f789..1fdaa57 100644
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
 
