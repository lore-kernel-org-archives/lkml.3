Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752387AbaKIPJD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 10:09:03 -0500
Received: from mga02.intel.com ([134.134.136.20]:62538 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752353AbaKIPJA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 10:09:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,346,1413270000"; 
   d="scan'208";a="604933103"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Yijing Wang <wangyijing@huawei.com>,
        Alexander Gordeev <agordeev@redhat.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [RFC Part4 v1 08/17] PCI/MSI: Use irq_chip.irq_write_msi_msg() to share common code
Date: Sun,  9 Nov 2014 23:10:30 +0800
Message-Id: <1415545839-28263-9-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1415545839-28263-1-git-send-email-jiang.liu@linux.intel.com>
References: <1415545839-28263-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change PCI MSI code to use irq_chip.irq_write_msi_msg() to share more
common code later.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/pci/msi.c   |   24 ++++++------------------
 include/linux/msi.h |    3 +++
 2 files changed, 9 insertions(+), 18 deletions(-)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index b811739b43c5..cc6207e3b6bc 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -1111,7 +1111,7 @@ int msi_domain_set_affinity(struct irq_data *data, const struct cpumask *mask,
 	ret = parent->chip->irq_set_affinity(parent, mask, force);
 	if (ret >= 0 && ret != IRQ_SET_MASK_OK_DONE) {
 		irq_chip_compose_msi_msg(data, &msg);
-		__write_msi_msg(data->msi_desc, &msg);
+		irq_chip_write_msi_msg(data, &msg);
 	}
 
 	return ret;
@@ -1177,32 +1177,20 @@ static void msi_domain_free(struct irq_domain *domain, unsigned int virq,
 	irq_domain_free_irqs_top(domain, virq, nr_irqs);
 }
 
-static void msi_domain_activate(struct irq_domain *domain,
-				struct irq_data *irq_data)
+void msi_domain_activate(struct irq_domain *domain, struct irq_data *irq_data)
 {
 	struct msi_msg msg;
 
-	/*
-	 * irq_data->chip_data is MSI/MSI-X offset.
-	 * MSI-X message is written per-IRQ, the offset is always 0.
-	 * MSI message denotes a contiguous group of IRQs, written for 0th IRQ.
-	 */
-	if (irq_data->chip_data)
-		return;
-
 	BUG_ON(irq_chip_compose_msi_msg(irq_data, &msg));
-	__write_msi_msg(irq_data->msi_desc, &msg);
+	irq_chip_write_msi_msg(irq_data, &msg);
 }
 
-static void msi_domain_deactivate(struct irq_domain *domain,
-				  struct irq_data *irq_data)
+void msi_domain_deactivate(struct irq_domain *domain, struct irq_data *irq_data)
 {
 	struct msi_msg msg;
 
-	if (!irq_data->chip_data) {
-		memset(&msg, 0, sizeof(msg));
-		__write_msi_msg(irq_data->msi_desc, &msg);
-	}
+	memset(&msg, 0, sizeof(msg));
+	irq_chip_write_msi_msg(irq_data, &msg);
 }
 
 static struct irq_domain_ops msi_domain_ops = {
diff --git a/include/linux/msi.h b/include/linux/msi.h
index 312197f64070..bd0f9d8c6fe1 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -81,6 +81,9 @@ struct irq_chip;
 
 int msi_domain_set_affinity(struct irq_data *data, const struct cpumask *mask,
 			    bool force);
+void msi_domain_activate(struct irq_domain *domain, struct irq_data *irq_data);
+void msi_domain_deactivate(struct irq_domain *domain,
+			   struct irq_data *irq_data);
 struct irq_domain *msi_create_irq_domain(struct device_node *of_node,
 					 struct irq_chip *chip,
 					 struct irq_domain *parent);
-- 
1.7.10.4

