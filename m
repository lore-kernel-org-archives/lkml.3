Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136AbaKQLCb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 06:02:31 -0500
Received: from mga02.intel.com ([134.134.136.20]:1455 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752914AbaKQLAP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 06:00:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="487988957"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yijing Wang <wangyijing@huawei.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc: Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Jiang Liu <jiang.liu@linux.intel.com>
Subject: [Patch V3 2/9] irqdomain: Use consistent prototype for irq_domain_free_irqs_*
Date: Mon, 17 Nov 2014 19:03:15 +0800
Message-Id: <1416222202-28002-3-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1416222202-28002-1-git-send-email-jiang.liu@linux.intel.com>
References: <1416222202-28002-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yingjoe Chen <yingjoe.chen@mediatek.com>

When using irq_domain_free_irqs_top() directly in irq_domain_ops, gcc
generate the following warnings:

../drivers/irqchip/irq-gic.c:879:2: warning: initialization from incompatible pointer type [enabled by default]
../drivers/irqchip/irq-gic.c:879:2: warning: (near initialization for 'gic_irq_domain_hierarchy_ops.free') [enabled by default]

Change to use consistent prototype for all irq_domain_free_irqs*

Better to fold this into "irqdomain: Introduce new interfaces to
support hierarchy irqdomains".

Signed-off-by: Yingjoe Chen <yingjoe.chen@mediatek.com>
Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 include/linux/irqdomain.h |    9 +++++----
 kernel/irq/irqdomain.c    |    8 ++++----
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
index 640a1ec54772..fbe542967c20 100644
--- a/include/linux/irqdomain.h
+++ b/include/linux/irqdomain.h
@@ -270,12 +270,13 @@ extern void irq_domain_set_info(struct irq_domain *domain, unsigned int virq,
 				void *handler_data, const char *handler_name);
 extern void irq_domain_reset_irq_data(struct irq_data *irq_data);
 extern void irq_domain_free_irqs_common(struct irq_domain *domain,
-					int virq, int nr_irqs);
+					unsigned int virq,
+					unsigned int nr_irqs);
 extern void irq_domain_free_irqs_top(struct irq_domain *domain,
-				     int virq, int nr_irqs);
+				     unsigned int virq, unsigned int nr_irqs);
 
 static inline int irq_domain_alloc_irqs_parent(struct irq_domain *domain,
-				int irq_base, unsigned int nr_irqs, void *arg)
+			unsigned int irq_base, unsigned int nr_irqs, void *arg)
 {
 	if (domain->parent && domain->parent->ops->alloc)
 		return domain->parent->ops->alloc(domain->parent, irq_base,
@@ -284,7 +285,7 @@ static inline int irq_domain_alloc_irqs_parent(struct irq_domain *domain,
 }
 
 static inline void irq_domain_free_irqs_parent(struct irq_domain *domain,
-					int irq_base, unsigned int nr_irqs)
+				unsigned int irq_base, unsigned int nr_irqs)
 {
 	if (domain->parent && domain->parent->ops->free)
 		domain->parent->ops->free(domain->parent, irq_base, nr_irqs);
diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 8b0eddee0b21..705fb573e509 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -899,8 +899,8 @@ void irq_domain_reset_irq_data(struct irq_data *irq_data)
 	irq_data->chip_data = NULL;
 }
 
-void irq_domain_free_irqs_common(struct irq_domain *domain, int virq,
-				 int nr_irqs)
+void irq_domain_free_irqs_common(struct irq_domain *domain, unsigned int virq,
+				 unsigned int nr_irqs)
 {
 	int i;
 	struct irq_data *irq_data;
@@ -913,8 +913,8 @@ void irq_domain_free_irqs_common(struct irq_domain *domain, int virq,
 	irq_domain_free_irqs_parent(domain, virq, nr_irqs);
 }
 
-void irq_domain_free_irqs_top(struct irq_domain *domain, int virq,
-			      int nr_irqs)
+void irq_domain_free_irqs_top(struct irq_domain *domain, unsigned int virq,
+			      unsigned int nr_irqs)
 {
 	int i;
 
-- 
1.7.10.4

