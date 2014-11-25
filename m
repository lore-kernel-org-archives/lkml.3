Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544AbaKYFzz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 00:55:55 -0500
Received: from mga11.intel.com ([192.55.52.93]:50300 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751988AbaKYFzw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 00:55:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,453,1413270000"; 
   d="scan'208";a="627798754"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: [Patch Part2 v6 25/27] PCI/MSI: Replace msi_update_msg() with irq_chip_compose_msi_msg()
Date: Tue, 25 Nov 2014 13:53:34 +0800
Message-Id: <1416894816-23245-26-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1416894816-23245-1-git-send-email-jiang.liu@linux.intel.com>
References: <1416894816-23245-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function irq_chip_compose_msi_msg() can achieve the same goal as
msi_update_msg(), so kill msi_update_msg().

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/kernel/apic/msi.c |   19 ++-----------------
 1 file changed, 2 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kernel/apic/msi.c b/arch/x86/kernel/apic/msi.c
index 8e8f2435f25e..15429aa112fe 100644
--- a/arch/x86/kernel/apic/msi.c
+++ b/arch/x86/kernel/apic/msi.c
@@ -53,19 +53,6 @@ static void irq_msi_compose_msg(struct irq_data *data, struct msi_msg *msg)
 		MSI_DATA_VECTOR(cfg->vector);
 }
 
-static void msi_update_msg(struct msi_msg *msg, struct irq_data *irq_data)
-{
-	struct irq_cfg *cfg = irqd_cfg(irq_data);
-
-	msg->data &= ~MSI_DATA_VECTOR_MASK;
-	msg->data |= MSI_DATA_VECTOR(cfg->vector);
-	msg->address_lo &= ~MSI_ADDR_DEST_ID_MASK;
-	msg->address_lo |= MSI_ADDR_DEST_ID(cfg->dest_apicid);
-	if (x2apic_enabled())
-		msg->address_hi = MSI_ADDR_BASE_HI |
-				  MSI_ADDR_EXT_DEST_ID(cfg->dest_apicid);
-}
-
 /*
  * IRQ Chip for MSI PCI/PCI-X/PCI-Express Devices,
  * which implement the MSI or MSI-X Capability Structure.
@@ -198,8 +185,7 @@ dmar_msi_set_affinity(struct irq_data *data, const struct cpumask *mask,
 
 	ret = parent->chip->irq_set_affinity(parent, mask, force);
 	if (ret >= 0) {
-		dmar_msi_read(data->irq, &msg);
-		msi_update_msg(&msg, data);
+		irq_chip_compose_msi_msg(data, &msg);
 		dmar_msi_write(data->irq, &msg);
 	}
 
@@ -329,8 +315,7 @@ static int hpet_msi_set_affinity(struct irq_data *data,
 
 	ret = parent->chip->irq_set_affinity(parent, mask, force);
 	if (ret >= 0 && ret != IRQ_SET_MASK_OK_DONE) {
-		hpet_msi_read(data->handler_data, &msg);
-		msi_update_msg(&msg, data);
+		irq_chip_compose_msi_msg(data, &msg);
 		hpet_msi_write(data->handler_data, &msg);
 	}
 
-- 
1.7.10.4

