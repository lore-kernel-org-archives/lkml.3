Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692AbaKDL74 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 06:59:56 -0500
Received: from mga01.intel.com ([192.55.52.88]:34017 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753634AbaKDL7w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 06:59:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,313,1413270000"; 
   d="scan'208";a="616765030"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [Patch Part2 v4 04/31] genirq: Introduce irq_chip.irq_compose_msi_msg() to support stacked irqchip
Date: Tue,  4 Nov 2014 20:01:38 +0800
Message-Id: <1415102525-9898-5-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1415102525-9898-1-git-send-email-jiang.liu@linux.intel.com>
References: <1415102525-9898-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add callback irq_compose_msi_msg to struct irq_chip, which will be used
to support stacked irqchip.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 include/linux/irq.h |    5 +++++
 kernel/irq/chip.c   |   17 +++++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index 0adcbbbf2e87..536b7fc6c8f4 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -29,6 +29,7 @@ struct seq_file;
 struct module;
 struct irq_desc;
 struct irq_data;
+struct msi_msg;
 typedef	void (*irq_flow_handler_t)(unsigned int irq,
 					    struct irq_desc *desc);
 typedef	void (*irq_preflow_handler_t)(struct irq_data *data);
@@ -320,6 +321,7 @@ static inline irq_hw_number_t irqd_to_hwirq(struct irq_data *d)
  *				any other callback related to this irq
  * @irq_release_resources:	optional to release resources acquired with
  *				irq_request_resources
+ * @irq_compose_msi_msg:	optional to compose message content for MSI
  * @flags:		chip specific flags
  */
 struct irq_chip {
@@ -356,6 +358,8 @@ struct irq_chip {
 	int		(*irq_request_resources)(struct irq_data *data);
 	void		(*irq_release_resources)(struct irq_data *data);
 
+	void		(*irq_compose_msi_msg)(struct irq_data *data, struct msi_msg *msg);
+
 	unsigned long	flags;
 };
 
@@ -443,6 +447,7 @@ extern void handle_percpu_devid_irq(unsigned int irq, struct irq_desc *desc);
 extern void handle_bad_irq(unsigned int irq, struct irq_desc *desc);
 extern void handle_nested_irq(unsigned int irq);
 
+extern int irq_chip_compose_msi_msg(struct irq_data *data, struct msi_msg *msg);
 #ifdef	CONFIG_IRQ_DOMAIN_HIERARCHY
 extern void irq_chip_ack_parent(struct irq_data *data);
 extern int irq_chip_retrigger_hierarchy(struct irq_data *data);
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index 12f3e72449eb..8f362db17a8a 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -867,3 +867,20 @@ int irq_chip_retrigger_hierarchy(struct irq_data *data)
 	return -ENOSYS;
 }
 #endif
+
+int irq_chip_compose_msi_msg(struct irq_data *data, struct msi_msg *msg)
+{
+	struct irq_data *pos = NULL;
+
+#ifdef	CONFIG_IRQ_DOMAIN_HIERARCHY
+	for (; data; data = data->parent_data)
+#endif
+		if (data->chip && data->chip->irq_compose_msi_msg)
+			pos = data;
+	if (!pos)
+		return -ENOSYS;
+
+	pos->chip->irq_compose_msi_msg(pos, msg);
+
+	return 0;
+}
-- 
1.7.10.4

