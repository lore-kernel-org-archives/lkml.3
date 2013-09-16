Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757440Ab3IPIfk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 04:35:40 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:59090 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756293Ab3IPIdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 04:33:22 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-i2c@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH 3/9] irqdomain: Introduce __irq_create_of_mapping()
Date: Mon, 16 Sep 2013 10:32:00 +0200
Message-Id: <1379320326-13241-4-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1379320326-13241-1-git-send-email-treding@nvidia.com>
References: <1379320326-13241-1-git-send-email-treding@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a version of irq_create_of_mapping() that propagates the precise
error code instead of returning 0 for all errors. It will be used in
subsequent patches to allow further propagation of error codes.

To avoid code duplication, implement irq_create_of_mapping() as a
wrapper around the new __irq_create_of_mapping().

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 include/linux/of_irq.h |  3 +++
 kernel/irq/irqdomain.c | 39 +++++++++++++++++++++++++++++----------
 2 files changed, 32 insertions(+), 10 deletions(-)

diff --git a/include/linux/of_irq.h b/include/linux/of_irq.h
index 535cecf..c383dd1 100644
--- a/include/linux/of_irq.h
+++ b/include/linux/of_irq.h
@@ -63,6 +63,9 @@ extern int of_irq_map_raw(struct device_node *parent, const __be32 *intspec,
 			  struct of_irq *out_irq);
 extern int of_irq_map_one(struct device_node *device, int index,
 			  struct of_irq *out_irq);
+extern int __irq_create_of_mapping(struct device_node *controller,
+				   const u32 *intspec, unsigned int intsize,
+				   unsigned int *virqp);
 extern unsigned int irq_create_of_mapping(struct device_node *controller,
 					  const u32 *intspec,
 					  unsigned int intsize);
diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index d2a3b01..9867616 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -484,39 +484,58 @@ int irq_create_strict_mappings(struct irq_domain *domain, unsigned int irq_base,
 }
 EXPORT_SYMBOL_GPL(irq_create_strict_mappings);
 
-unsigned int irq_create_of_mapping(struct device_node *controller,
-				   const u32 *intspec, unsigned int intsize)
+int __irq_create_of_mapping(struct device_node *controller, const u32 *intspec,
+			    unsigned int intsize, unsigned int *virqp)
 {
+	unsigned int type = IRQ_TYPE_NONE;
 	struct irq_domain *domain;
 	irq_hw_number_t hwirq;
-	unsigned int type = IRQ_TYPE_NONE;
 	unsigned int virq;
+	int ret;
 
 	domain = controller ? irq_find_host(controller) : irq_default_domain;
 	if (!domain) {
 		pr_warn("no irq domain found for %s !\n",
 			of_node_full_name(controller));
-		return 0;
+		return -EPROBE_DEFER;
 	}
 
 	/* If domain has no translation, then we assume interrupt line */
 	if (domain->ops->xlate == NULL)
 		hwirq = intspec[0];
 	else {
-		if (domain->ops->xlate(domain, controller, intspec, intsize,
-				     &hwirq, &type))
-			return 0;
+		ret = domain->ops->xlate(domain, controller, intspec, intsize,
+					 &hwirq, &type);
+		if (ret)
+			return ret;
 	}
 
 	/* Create mapping */
-	virq = irq_create_mapping(domain, hwirq);
-	if (!virq)
-		return virq;
+	ret = __irq_create_mapping(domain, hwirq, &virq);
+	if (ret)
+		return ret;
 
 	/* Set type if specified and different than the current one */
 	if (type != IRQ_TYPE_NONE &&
 	    type != irq_get_trigger_type(virq))
 		irq_set_irq_type(virq, type);
+
+	if (virqp)
+		*virqp = virq;
+
+	return 0;
+}
+
+unsigned int irq_create_of_mapping(struct device_node *controller,
+				   const u32 *intspec, unsigned int intsize)
+{
+	unsigned int virq;
+	int ret;
+
+	ret = __irq_create_of_mapping(controller, intspec, intsize, &virq);
+	if (ret)
+		return 0;
+
 	return virq;
 }
 EXPORT_SYMBOL_GPL(irq_create_of_mapping);
-- 
1.8.4

