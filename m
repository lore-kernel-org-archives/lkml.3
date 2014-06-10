Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978AbaFJGIQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 02:08:16 -0400
Received: from mga01.intel.com ([192.55.52.88]:25622 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750843AbaFJGIP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 02:08:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="352846529"
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
Subject: [Patch V4 08/42] x86, ACPI, irq: enhance error handling in function acpi_register_gsi()
Date: Tue, 10 Jun 2014 14:11:23 +0800
Message-Id: <1402380683-32345-1-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <alpine.DEB.2.10.1406100113070.3830@nanos>
References: <alpine.DEB.2.10.1406100113070.3830@nanos>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function mp_register_gsi() may return error code when failed to look up
or program corresponding IOAPIC pin for GSI, so enhance acpi_register_gsi()
to handle possible error cases.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
Minor changes according to review comments:
1) kill useless assignment to plat_gsi.
2) simplify usage of function pointer
---
 arch/x86/kernel/acpi/boot.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 392360c607dc..298f79616f1c 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -97,6 +97,8 @@ static u32 isa_irq_to_gsi[NR_IRQS_LEGACY] __read_mostly = {
 	0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15
 };
 
+#define	ACPI_INVALID_GSI		INT_MIN
+
 static unsigned int gsi_to_irq(unsigned int gsi)
 {
 	unsigned int irq = gsi + NR_IRQS_LEGACY;
@@ -441,7 +443,7 @@ static int mp_register_gsi(struct device *dev, u32 gsi, int trigger,
 			     polarity == ACPI_ACTIVE_HIGH ? 0 : 1);
 	ret = io_apic_set_pci_routing(dev, gsi_to_irq(gsi), &irq_attr);
 	if (ret < 0)
-		gsi = INT_MIN;
+		gsi = ACPI_INVALID_GSI;
 
 	return gsi;
 }
@@ -666,13 +668,13 @@ int (*acpi_suspend_lowlevel)(void);
  */
 int acpi_register_gsi(struct device *dev, u32 gsi, int trigger, int polarity)
 {
-	unsigned int irq;
-	unsigned int plat_gsi = gsi;
+	unsigned int plat_gsi;
 
-	plat_gsi = (*__acpi_register_gsi)(dev, gsi, trigger, polarity);
-	irq = gsi_to_irq(plat_gsi);
+	plat_gsi = __acpi_register_gsi(dev, gsi, trigger, polarity);
+	if (plat_gsi != ACPI_INVALID_GSI)
+		return gsi_to_irq(plat_gsi);
 
-	return irq;
+	return -1;
 }
 EXPORT_SYMBOL_GPL(acpi_register_gsi);
 
-- 
1.7.10.4

