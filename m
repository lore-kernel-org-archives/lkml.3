Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755679AbaFII2Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 04:28:16 -0400
Received: from mga11.intel.com ([192.55.52.93]:34010 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755912AbaFIIVb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:21:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="352321156"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@linaro.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        x86@kernel.org
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org
Subject: [Patch V4 25/42] x86, ACPI, irq: provide basic irqdomain support
Date: Mon,  9 Jun 2014 16:19:54 +0800
Message-Id: <1402302011-23642-26-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1402302011-23642-1-git-send-email-jiang.liu@linux.intel.com>
References: <1402302011-23642-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enhance ACPI driver to provide basic irqdomain support for IOAPIC.

We will build identity mapping for IOAPICs hosting legacy IRQs,
otherwise dynamically allocate IRQ numbers for IOAPIC pins on demand.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/kernel/acpi/boot.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 15d988cfa335..82ec56a4c6f4 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -31,6 +31,7 @@
 #include <linux/module.h>
 #include <linux/dmi.h>
 #include <linux/irq.h>
+#include <linux/irqdomain.h>
 #include <linux/slab.h>
 #include <linux/bootmem.h>
 #include <linux/ioport.h>
@@ -449,10 +450,16 @@ static int mp_register_gsi(struct device *dev, u32 gsi, int trigger,
 	return irq;
 }
 
+static struct irq_domain_ops acpi_irqdomain_ops;
+
 static int __init
 acpi_parse_ioapic(struct acpi_subtable_header * header, const unsigned long end)
 {
 	struct acpi_madt_io_apic *ioapic = NULL;
+	struct ioapic_domain_cfg cfg = {
+		.type = IOAPIC_DOMAIN_DYNAMIC,
+		.ops = &acpi_irqdomain_ops,
+	};
 
 	ioapic = (struct acpi_madt_io_apic *)header;
 
@@ -461,8 +468,12 @@ acpi_parse_ioapic(struct acpi_subtable_header * header, const unsigned long end)
 
 	acpi_table_print_madt_entry(header);
 
-	mp_register_ioapic(ioapic->id,
-			   ioapic->address, ioapic->global_irq_base, NULL);
+	/* Statically assign IRQ numbers for IOAPICs hosting legacy IRQs */
+	if (ioapic->global_irq_base < nr_legacy_irqs())
+		cfg.type = IOAPIC_DOMAIN_LEGACY;
+
+	mp_register_ioapic(ioapic->id, ioapic->address, ioapic->global_irq_base,
+			   &cfg);
 
 	return 0;
 }
-- 
1.7.10.4

