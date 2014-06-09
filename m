Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820AbaFIISK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 04:18:10 -0400
Received: from mga14.intel.com ([192.55.52.115]:35864 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753076AbaFIISE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:18:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="352319746"
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
Subject: [Patch V4 06/42] x86, acpi, irq: kill static function irq_to_gsi()
Date: Mon,  9 Jun 2014 16:19:35 +0800
Message-Id: <1402302011-23642-7-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1402302011-23642-1-git-send-email-jiang.liu@linux.intel.com>
References: <1402302011-23642-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Static function irq_to_gsi() is only called by acpi_isa_irq_to_gsi(),
so kill function irq_to_gsi() and simplify acpi_isa_irq_to_gsi().

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/kernel/acpi/boot.c |   26 ++++++--------------------
 1 file changed, 6 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index ceb3b36f2b2c..09682766d56a 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -120,22 +120,6 @@ static unsigned int gsi_to_irq(unsigned int gsi)
 	return irq;
 }
 
-static u32 irq_to_gsi(int irq)
-{
-	unsigned int gsi;
-
-	if (irq < NR_IRQS_LEGACY)
-		gsi = isa_irq_to_gsi[irq];
-	else if (irq < gsi_top)
-		gsi = irq;
-	else if (irq < (gsi_top + NR_IRQS_LEGACY))
-		gsi = irq - gsi_top;
-	else
-		gsi = 0xffffffff;
-
-	return gsi;
-}
-
 /*
  * This is just a simple wrapper around early_ioremap(),
  * with sanity checks for phys == 0 and size == 0.
@@ -640,10 +624,12 @@ EXPORT_SYMBOL_GPL(acpi_gsi_to_irq);
 
 int acpi_isa_irq_to_gsi(unsigned isa_irq, u32 *gsi)
 {
-	if (isa_irq >= 16)
-		return -1;
-	*gsi = irq_to_gsi(isa_irq);
-	return 0;
+	if (isa_irq < NR_IRQS_LEGACY) {
+		*gsi = isa_irq_to_gsi[isa_irq];
+		return 0;
+	}
+
+	return -1;
 }
 
 static int acpi_register_gsi_pic(struct device *dev, u32 gsi,
-- 
1.7.10.4

