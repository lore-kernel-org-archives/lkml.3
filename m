Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297AbaKOOVg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2014 09:21:36 -0500
Received: from mga01.intel.com ([192.55.52.88]:61402 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754190AbaKOOVc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2014 09:21:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,391,1413270000"; 
   d="scan'208";a="632446325"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yijing Wang <wangyijing@huawei.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [Patch V2 4/9] irqdomain: Introduce helper function irq_domain_add_hierarchy()
Date: Sat, 15 Nov 2014 22:24:02 +0800
Message-Id: <1416061447-9472-5-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1416061447-9472-1-git-send-email-jiang.liu@linux.intel.com>
References: <1416061447-9472-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce helper function irq_domain_add_hierarchy(), which creates
a linear irqdomain if parameter 'size' is not zero, otherwise creates
a tree irqdomain.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 include/linux/irqdomain.h |    4 ++++
 kernel/irq/irqdomain.c    |   19 +++++++++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
index ad92b0b15945..30e8c753fa98 100644
--- a/include/linux/irqdomain.h
+++ b/include/linux/irqdomain.h
@@ -248,6 +248,10 @@ int irq_domain_xlate_onetwocell(struct irq_domain *d, struct device_node *ctrlr,
 extern struct irq_data *irq_domain_get_irq_data(struct irq_domain *domain,
 						unsigned int virq);
 #ifdef	CONFIG_IRQ_DOMAIN_HIERARCHY
+extern struct irq_domain *irq_domain_add_hierarchy(struct irq_domain *parent,
+			unsigned int flags, unsigned int size,
+			struct device_node *node,
+			const struct irq_domain_ops *ops, void *host_data);
 extern int __irq_domain_alloc_irqs(struct irq_domain *domain, int irq_base,
 				   unsigned int nr_irqs, int node, void *arg,
 				   bool realloc);
diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 03fc7d018324..73c66d6f9ffc 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -742,6 +742,25 @@ static int irq_domain_alloc_descs(int virq, unsigned int cnt,
 }
 
 #ifdef	CONFIG_IRQ_DOMAIN_HIERARCHY
+struct irq_domain *irq_domain_add_hierarchy(struct irq_domain *parent,
+			unsigned int flags, unsigned int size,
+			struct device_node *node,
+			const struct irq_domain_ops *ops, void *host_data)
+{
+	struct irq_domain *domain;
+
+	if (size)
+		domain = irq_domain_add_linear(node, size, ops, host_data);
+	else
+		domain = irq_domain_add_tree(node, ops, host_data);
+	if (domain) {
+		domain->parent = parent;
+		domain->flags |= flags;
+	}
+
+	return domain;
+}
+
 static void irq_domain_insert_irq(int virq)
 {
 	struct irq_data *data;
-- 
1.7.10.4

