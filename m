Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183AbaKIPIN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 10:08:13 -0500
Received: from mga09.intel.com ([134.134.136.24]:29518 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751948AbaKIPIJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 10:08:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,346,1413270000"; 
   d="scan'208";a="604932909"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>, x86@kernel.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [RFC Part4 v1 04/17] PCI/MSI: Replace msi_update_msg() with irq_chip_compose_msi_msg()
Date: Sun,  9 Nov 2014 23:10:26 +0800
Message-Id: <1415545839-28263-5-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1415545839-28263-1-git-send-email-jiang.liu@linux.intel.com>
References: <1415545839-28263-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function irq_chip_compose_msi_msg() can achieve the same goal as
msi_update_msg(), so kill msi_update_msg().

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/kernel/apic/msi.c |   25 ++++---------------------
 1 file changed, 4 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kernel/apic/msi.c b/arch/x86/kernel/apic/msi.c
index 12919b3c6cf4..727e4254f124 100644
--- a/arch/x86/kernel/apic/msi.c
+++ b/arch/x86/kernel/apic/msi.c
@@ -53,31 +53,16 @@ static void msi_compose_msg(struct irq_data *data, struct msi_msg *msg)
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
 static int msi_set_affinity(struct irq_data *data, const struct cpumask *mask,
 			    bool force)
 {
 	struct irq_data *parent = data->parent_data;
+	struct msi_msg msg;
 	int ret;
 
 	ret = parent->chip->irq_set_affinity(parent, mask, force);
 	if (ret >= 0 && ret != IRQ_SET_MASK_OK_DONE) {
-		struct msi_msg msg;
-
-		__get_cached_msi_msg(data->msi_desc, &msg);
-		msi_update_msg(&msg, data);
+		irq_chip_compose_msi_msg(data, &msg);
 		__write_msi_msg(data->msi_desc, &msg);
 	}
 
@@ -179,8 +164,7 @@ dmar_msi_set_affinity(struct irq_data *data, const struct cpumask *mask,
 
 	ret = parent->chip->irq_set_affinity(parent, mask, force);
 	if (ret >= 0) {
-		dmar_msi_read(data->irq, &msg);
-		msi_update_msg(&msg, data);
+		irq_chip_compose_msi_msg(data, &msg);
 		dmar_msi_write(data->irq, &msg);
 	}
 
@@ -310,8 +294,7 @@ static int hpet_msi_set_affinity(struct irq_data *data,
 
 	ret = parent->chip->irq_set_affinity(parent, mask, force);
 	if (ret >= 0 && ret != IRQ_SET_MASK_OK_DONE) {
-		hpet_msi_read(data->handler_data, &msg);
-		msi_update_msg(&msg, data);
+		irq_chip_compose_msi_msg(data, &msg);
 		hpet_msi_write(data->handler_data, &msg);
 	}
 
-- 
1.7.10.4

