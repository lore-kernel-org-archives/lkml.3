Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751903AbaJ0FT3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 01:19:29 -0400
Received: from mga14.intel.com ([192.55.52.115]:46412 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873AbaJ0FT2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 01:19:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="406497503"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, x86@kernel.org
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, rui.zhang@intel.com,
        linux-pm@vger.kernel.org
Subject: [Patch v7 01/18] ACPI, irq: fix regression casued by 6b9fb7082409
Date: Mon, 27 Oct 2014 13:21:31 +0800
Message-Id: <1414387308-27148-2-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1414387308-27148-1-git-send-email-jiang.liu@linux.intel.com>
References: <1414387308-27148-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When IOAPIC is disabled, acpi_gsi_to_irq() should return gsi directly
instead of calling mp_map_gsi_to_irq() to translate gsi to IRQ by IOAPIC.
It fixes https://bugzilla.kernel.org/show_bug.cgi?id=84381.

Reported-by: Thomas Richter <thor@math.tu-berlin.de>
Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: rui.zhang@intel.com
Cc: <stable@vger.kernel.org> # 3.17
---
 arch/x86/kernel/acpi/boot.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index b436fc735aa4..eceba9d9e116 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -604,14 +604,19 @@ void __init acpi_pic_sci_set_trigger(unsigned int irq, u16 trigger)
 
 int acpi_gsi_to_irq(u32 gsi, unsigned int *irqp)
 {
-	int irq = mp_map_gsi_to_irq(gsi, IOAPIC_MAP_ALLOC | IOAPIC_MAP_CHECK);
+	int irq;
 
-	if (irq >= 0) {
+	if (acpi_irq_model == ACPI_IRQ_MODEL_PIC) {
+		*irqp = gsi;
+	} else {
+		irq = mp_map_gsi_to_irq(gsi,
+					IOAPIC_MAP_ALLOC | IOAPIC_MAP_CHECK);
+		if (irq < 0)
+			return -1;
 		*irqp = irq;
-		return 0;
 	}
 
-	return -1;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(acpi_gsi_to_irq);
 
-- 
1.7.10.4

