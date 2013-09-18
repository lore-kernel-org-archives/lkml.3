Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917Ab3IRN2O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 09:28:14 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:50996 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971Ab3IRN00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 09:26:26 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@linux-mips.org,
        linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 03/10] irqdomain: Introduce __irq_create_mapping()
Date: Wed, 18 Sep 2013 15:24:45 +0200
Message-Id: <1379510692-32435-4-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1379510692-32435-1-git-send-email-treding@nvidia.com>
References: <1379510692-32435-1-git-send-email-treding@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a version of irq_create_mapping() that propagates the precise
error code instead of returning 0 for all errors. It will be used in
subsequent patches to allow further propagation of error codes.

To avoid code duplication, implement irq_create_mapping() as a wrapper
around the new __irq_create_mapping().

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 kernel/irq/irqdomain.c | 59 +++++++++++++++++++++++++++++++++-----------------
 1 file changed, 39 insertions(+), 20 deletions(-)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 706724e..d2a3b01 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -374,30 +374,21 @@ unsigned int irq_create_direct_mapping(struct irq_domain *domain)
 }
 EXPORT_SYMBOL_GPL(irq_create_direct_mapping);
 
-/**
- * irq_create_mapping() - Map a hardware interrupt into linux irq space
- * @domain: domain owning this hardware interrupt or NULL for default domain
- * @hwirq: hardware irq number in that domain space
- *
- * Only one mapping per hardware interrupt is permitted. Returns a linux
- * irq number.
- * If the sense/trigger is to be specified, set_irq_type() should be called
- * on the number returned from that call.
- */
-unsigned int irq_create_mapping(struct irq_domain *domain,
-				irq_hw_number_t hwirq)
+static int __irq_create_mapping(struct irq_domain *domain,
+				irq_hw_number_t hwirq, unsigned int *virqp)
 {
-	unsigned int hint;
-	int virq;
+	unsigned int hint, virq;
+	int ret;
 
-	pr_debug("irq_create_mapping(0x%p, 0x%lx)\n", domain, hwirq);
+	pr_debug("__irq_create_mapping(0x%p, 0x%lx, %p)\n", domain, hwirq,
+		 virqp);
 
 	/* Look for default domain if nececssary */
 	if (domain == NULL)
 		domain = irq_default_domain;
 	if (domain == NULL) {
 		WARN(1, "%s(, %lx) called with NULL domain\n", __func__, hwirq);
-		return 0;
+		return -ENODEV;
 	}
 	pr_debug("-> using domain @%p\n", domain);
 
@@ -405,7 +396,11 @@ unsigned int irq_create_mapping(struct irq_domain *domain,
 	virq = irq_find_mapping(domain, hwirq);
 	if (virq) {
 		pr_debug("-> existing mapping on virq %d\n", virq);
-		return virq;
+
+		if (virqp)
+			*virqp = virq;
+
+		return 0;
 	}
 
 	/* Allocate a virtual interrupt number */
@@ -417,17 +412,41 @@ unsigned int irq_create_mapping(struct irq_domain *domain,
 		virq = irq_alloc_desc_from(1, of_node_to_nid(domain->of_node));
 	if (virq <= 0) {
 		pr_debug("-> virq allocation failed\n");
-		return 0;
+		return virq ? : -ENOSPC;
 	}
 
-	if (irq_domain_associate(domain, virq, hwirq)) {
+	ret = irq_domain_associate(domain, virq, hwirq);
+	if (ret) {
 		irq_free_desc(virq);
-		return 0;
+		return ret;
 	}
 
 	pr_debug("irq %lu on domain %s mapped to virtual irq %u\n",
 		hwirq, of_node_full_name(domain->of_node), virq);
 
+	if (virqp)
+		*virqp = virq;
+
+	return 0;
+}
+/**
+ * irq_create_mapping() - Map a hardware interrupt into linux irq space
+ * @domain: domain owning this hardware interrupt or NULL for default domain
+ * @hwirq: hardware irq number in that domain space
+ *
+ * Only one mapping per hardware interrupt is permitted. Returns a linux
+ * irq number.
+ * If the sense/trigger is to be specified, set_irq_type() should be called
+ * on the number returned from that call.
+ */
+unsigned int irq_create_mapping(struct irq_domain *domain,
+				irq_hw_number_t hwirq)
+{
+	unsigned int virq;
+
+	if (__irq_create_mapping(domain, hwirq, &virq))
+		return 0;
+
 	return virq;
 }
 EXPORT_SYMBOL_GPL(irq_create_mapping);
-- 
1.8.4

