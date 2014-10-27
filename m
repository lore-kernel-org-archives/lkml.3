Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676AbaJ0IJZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 04:09:25 -0400
Received: from mga11.intel.com ([192.55.52.93]:44466 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751318AbaJ0IJW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 04:09:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,794,1406617200"; 
   d="scan'208";a="621212530"
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
        linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org
Subject: [Patch Part1 v3 01/20] ACPI, irq, x86: Get rid of special handling of GSI for ACPI SCI
Date: Mon, 27 Oct 2014 16:11:52 +0800
Message-Id: <1414397531-28254-2-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1414397531-28254-1-git-send-email-jiang.liu@linux.intel.com>
References: <1414397531-28254-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The IOAPIC has logic to track IOAPIC pin status, so there's no need for
special treatment for GSI used by ACPI SCI in function mp_register_gsi()
and mp_unregister_gsi().

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/kernel/acpi/boot.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index f27b33194e06..47334a918d16 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -408,10 +408,6 @@ static int mp_register_gsi(struct device *dev, u32 gsi, int trigger,
 	if (acpi_irq_model != ACPI_IRQ_MODEL_IOAPIC)
 		return gsi;
 
-	/* Don't set up the ACPI SCI because it's already set up */
-	if (acpi_gbl_FADT.sci_interrupt == gsi)
-		return mp_map_gsi_to_irq(gsi, IOAPIC_MAP_ALLOC);
-
 	trigger = trigger == ACPI_EDGE_SENSITIVE ? 0 : 1;
 	polarity = polarity == ACPI_ACTIVE_HIGH ? 0 : 1;
 	node = dev ? dev_to_node(dev) : NUMA_NO_NODE;
@@ -424,7 +420,8 @@ static int mp_register_gsi(struct device *dev, u32 gsi, int trigger,
 	if (irq < 0)
 		return irq;
 
-	if (enable_update_mptable)
+	/* Don't set up the ACPI SCI because it's already set up */
+	if (enable_update_mptable && acpi_gbl_FADT.sci_interrupt != gsi)
 		mp_config_acpi_gsi(dev, gsi, trigger, polarity);
 
 	return irq;
@@ -437,9 +434,6 @@ static void mp_unregister_gsi(u32 gsi)
 	if (acpi_irq_model != ACPI_IRQ_MODEL_IOAPIC)
 		return;
 
-	if (acpi_gbl_FADT.sci_interrupt == gsi)
-		return;
-
 	irq = mp_map_gsi_to_irq(gsi, 0);
 	if (irq > 0)
 		mp_unmap_irq(irq);
-- 
1.7.10.4

