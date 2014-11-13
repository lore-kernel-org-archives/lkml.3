Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085AbaKMPhd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 10:37:33 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:46335 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753959AbaKMPh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 10:37:29 -0500
X-Listener-Flag: 11101
From: Yingjoe Chen <yingjoe.chen@mediatek.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Marc Zyngier <marc.zyngier@arm.com>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Grant Likely <grant.likely@linaro.org>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Yijing Wang <wangyijing@huawei.com>, <srv_heupstream@mediatek.com>,
        <yingjoe.chen@gmail.com>, <hc.yen@mediatek.com>,
        <eddie.huang@mediatek.com>, <nathan.chung@mediatek.com>,
        <yh.chen@mediatek.com>, Sascha Hauer <kernel@pengutronix.de>
Subject: [PATCH v6 1/6] irqdomain: Use consistent prototype for irq_domain_free_irqs_*
Date: Thu, 13 Nov 2014 23:37:04 +0800
Message-ID: <1415893029-2971-2-git-send-email-yingjoe.chen@mediatek.com>
X-Mailer: git-send-email 1.8.1.1.dirty
In-Reply-To: <1415893029-2971-1-git-send-email-yingjoe.chen@mediatek.com>
References: <1415893029-2971-1-git-send-email-yingjoe.chen@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK: N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using irq_domain_free_irqs_top() directly in irq_domain_ops, gcc
generate the following warnings:

../drivers/irqchip/irq-gic.c:879:2: warning: initialization from incompatible pointer type [enabled by default]
../drivers/irqchip/irq-gic.c:879:2: warning: (near initialization for 'gic_irq_domain_hierarchy_ops.free') [enabled by default]

Change to use consistent prototype for all irq_domain_free_irqs*

Better to fold this into "irqdomain: Introduce new interfaces to
support hierarchy irqdomains"

Signed-off-by: Yingjoe Chen <yingjoe.chen@mediatek.com>
---
 include/linux/irqdomain.h | 8 +++++---
 kernel/irq/irqdomain.c    | 8 ++++----
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
index 640a1ec..534dd72 100644
--- a/include/linux/irqdomain.h
+++ b/include/linux/irqdomain.h
@@ -270,9 +270,10 @@ extern void irq_domain_set_info(struct irq_domain *domain, unsigned int virq,
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
 				int irq_base, unsigned int nr_irqs, void *arg)
@@ -284,7 +285,8 @@ static inline int irq_domain_alloc_irqs_parent(struct irq_domain *domain,
 }
 
 static inline void irq_domain_free_irqs_parent(struct irq_domain *domain,
-					int irq_base, unsigned int nr_irqs)
+					unsigned int irq_base,
+					unsigned int nr_irqs)
 {
 	if (domain->parent && domain->parent->ops->free)
 		domain->parent->ops->free(domain->parent, irq_base, nr_irqs);
diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 8b0edde..705fb57 100644
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
1.8.1.1.dirty

