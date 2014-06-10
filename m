Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933821AbaFJGME (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 02:12:04 -0400
Received: from mga02.intel.com ([134.134.136.20]:14113 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932895AbaFJGMB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 02:12:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,1007,1392192000"; 
   d="scan'208";a="526030379"
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
Subject: [Patch V4 22/42] x86, irq, ACPI: change __acpi_register_gsi to return IRQ number instead of GSI
Date: Tue, 10 Jun 2014 14:14:47 +0800
Message-Id: <1402380887-32512-1-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1402302011-23642-23-git-send-email-jiang.liu@linux.intel.com>
References: <1402302011-23642-23-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently __acpi_register_gsi is defined to return GSI number and
may be set to acpi_register_gsi_pic(), acpi_register_gsi_ioapic(),
acpi_register_gsi_xen_hvm() and acpi_register_gsi_xen().

Among which, acpi_register_gsi_ioapic() returns GSI number, but
acpi_register_gsi_xen_hvm() and acpi_register_gsi_xen() actually
returns IRQ number instead of GSI. And for acpi_register_gsi_pic(),
GSI number equals to IRQ number.

So change acpi_register_gsi_ioapic() to return IRQ number, it also
simplifies the code.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
Rebase due to change in patch 8.
---
 arch/x86/kernel/acpi/boot.c |   21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 9965afbd71ca..0cf311c72bce 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -419,7 +419,7 @@ static int mp_register_gsi(struct device *dev, u32 gsi, int trigger,
 
 	irq = map_gsi_to_irq(gsi);
 	if (irq < 0)
-		return ACPI_INVALID_GSI;
+		return irq;
 
 	ioapic = mp_find_ioapic(gsi);
 	if (ioapic < 0) {
@@ -444,12 +444,11 @@ static int mp_register_gsi(struct device *dev, u32 gsi, int trigger,
 			     polarity == ACPI_ACTIVE_HIGH ? 0 : 1);
 	ret = io_apic_set_pci_routing(dev, irq, &irq_attr);
 	if (ret < 0)
-		gsi = ACPI_INVALID_GSI;
+		irq = -1;
 
-	return gsi;
+	return irq;
 }
 
-
 static int __init
 acpi_parse_ioapic(struct acpi_subtable_header * header, const unsigned long end)
 {
@@ -652,11 +651,13 @@ static int acpi_register_gsi_pic(struct device *dev, u32 gsi,
 static int acpi_register_gsi_ioapic(struct device *dev, u32 gsi,
 				    int trigger, int polarity)
 {
+	int irq = gsi;
+
 #ifdef CONFIG_X86_IO_APIC
-	gsi = mp_register_gsi(dev, gsi, trigger, polarity);
+	irq = mp_register_gsi(dev, gsi, trigger, polarity);
 #endif
 
-	return gsi;
+	return irq;
 }
 
 int (*__acpi_register_gsi)(struct device *dev, u32 gsi,
@@ -674,13 +675,7 @@ int (*acpi_suspend_lowlevel)(void);
  */
 int acpi_register_gsi(struct device *dev, u32 gsi, int trigger, int polarity)
 {
-	unsigned int plat_gsi;
-
-	plat_gsi = __acpi_register_gsi(dev, gsi, trigger, polarity);
-	if (plat_gsi != ACPI_INVALID_GSI)
-		return map_gsi_to_irq(plat_gsi);
-
-	return -1;
+	return __acpi_register_gsi(dev, gsi, trigger, polarity);
 }
 EXPORT_SYMBOL_GPL(acpi_register_gsi);
 
-- 
1.7.10.4

