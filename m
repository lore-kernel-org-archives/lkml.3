Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013AbaFIISt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 04:18:49 -0400
Received: from mga11.intel.com ([192.55.52.93]:14069 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754815AbaFIISX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:18:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="352319809"
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
Date: Mon,  9 Jun 2014 16:19:37 +0800
Message-Id: <1402302011-23642-9-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1402302011-23642-1-git-send-email-jiang.liu@linux.intel.com>
References: <1402302011-23642-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function mp_register_gsi() may return invalid GSI if error happens,
so enhance acpi_register_gsi() to handle possible error cases.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/kernel/acpi/boot.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 392360c607dc..f201579cd0df 100644
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
 	unsigned int plat_gsi = gsi;
 
 	plat_gsi = (*__acpi_register_gsi)(dev, gsi, trigger, polarity);
-	irq = gsi_to_irq(plat_gsi);
+	if (plat_gsi != ACPI_INVALID_GSI)
+		return gsi_to_irq(plat_gsi);
 
-	return irq;
+	return -1;
 }
 EXPORT_SYMBOL_GPL(acpi_register_gsi);
 
-- 
1.7.10.4

