Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903AbaFIISq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 04:18:46 -0400
Received: from mga11.intel.com ([192.55.52.93]:14069 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754845AbaFIISY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:18:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="352319863"
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
Subject: [Patch V4 09/42] x86, ACPI, irq: fix possible eror in GSI to IRQ mapping for legacy IRQ
Date: Mon,  9 Jun 2014 16:19:38 +0800
Message-Id: <1402302011-23642-10-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1402302011-23642-1-git-send-email-jiang.liu@linux.intel.com>
References: <1402302011-23642-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A default identity mapping between GSI and IRQ is built for legacy IRQs.
So when overriding the default identity mapping for legacy IRQs,
we should also invalidate isa_irq_to_gsi[gsi] when setting
isa_irq_to_gsi[irq] = gsi.  Otherwise there may be two entries with the
same GSI in the isa_irq_to_gsi array, and acpi_isa_irq_to_gsi() may give
wrong result.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/kernel/acpi/boot.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index f201579cd0df..d6493863bd4b 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -366,6 +366,13 @@ static void __init mp_override_legacy_irq(u8 bus_irq, u8 polarity, u8 trigger,
 
 	mp_save_irq(&mp_irq);
 
+	/*
+	 * Reset default identity mapping if gsi is also an legacy IRQ,
+	 * otherwise there will be more than one entry with the same GSI
+	 * and acpi_isa_irq_to_gsi() may give wrong result.
+	 */
+	if (gsi < NR_IRQS_LEGACY && isa_irq_to_gsi[gsi] == gsi)
+		isa_irq_to_gsi[gsi] = ACPI_INVALID_GSI;
 	isa_irq_to_gsi[bus_irq] = gsi;
 }
 
@@ -621,7 +628,8 @@ EXPORT_SYMBOL_GPL(acpi_gsi_to_irq);
 
 int acpi_isa_irq_to_gsi(unsigned isa_irq, u32 *gsi)
 {
-	if (isa_irq < NR_IRQS_LEGACY) {
+	if (isa_irq < NR_IRQS_LEGACY &&
+	    isa_irq_to_gsi[isa_irq] != ACPI_INVALID_GSI) {
 		*gsi = isa_irq_to_gsi[isa_irq];
 		return 0;
 	}
-- 
1.7.10.4

