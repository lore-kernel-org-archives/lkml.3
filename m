Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593AbaE0IJw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 04:09:52 -0400
Received: from mga11.intel.com ([192.55.52.93]:1440 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752527AbaE0IJq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 04:09:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,917,1392192000"; 
   d="scan'208";a="538018134"
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
Subject: [Patch V3 21/37] x86, ACPI, irq: provide basic irqdomain support
Date: Tue, 27 May 2014 16:07:56 +0800
Message-Id: <1401178092-1228-22-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401178092-1228-1-git-send-email-jiang.liu@linux.intel.com>
References: <1401178092-1228-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enhance ACPI driver to provide basic irqdomain support for IOAPIC.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/kernel/acpi/boot.c |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 9525498e41d5..0632622a3798 100644
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
@@ -324,6 +325,23 @@ static void  mp_override_legacy_irq(u8 bus_irq, u8 polarity, u8 trigger,
 static int mp_register_gsi(struct device *dev, u32 gsi, int trigger,
 			   int polarity);
 
+static struct irq_domain_ops acpi_irqdomain_ops;
+
+static struct irq_domain *acpi_create_irqdomain(int idx, void *arg)
+{
+	struct mp_ioapic_gsi *gsi_cfg = mp_ioapic_gsi_routing(idx);
+
+	/*
+	 * Statically allocate IRQ number for legacy IRQs and all pins on the
+	 * first IOAPIC.
+	 */
+	if (gsi_cfg->gsi_base < NR_IRQS_LEGACY &&
+	    ioapic_dynirq_base < gsi_cfg->gsi_end)
+		ioapic_dynirq_base = gsi_cfg->gsi_end + 1;
+
+	return mp_irqdomain_create(idx, NULL, &acpi_irqdomain_ops);
+}
+
 static int __init
 acpi_parse_ioapic(struct acpi_subtable_header * header, const unsigned long end)
 {
@@ -338,7 +356,7 @@ acpi_parse_ioapic(struct acpi_subtable_header * header, const unsigned long end)
 
 	mp_register_ioapic(ioapic->id,
 			   ioapic->address, ioapic->global_irq_base,
-			   NULL, NULL);
+			   acpi_create_irqdomain, NULL);
 
 	return 0;
 }
-- 
1.7.10.4

