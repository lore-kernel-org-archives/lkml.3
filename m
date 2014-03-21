Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965123AbaCUOuj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 10:50:39 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:64626 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757638AbaCUOt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 10:49:57 -0400
From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
To: grant.likely@secretlab.ca
Cc: devicetree@vger.kernel.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, robh+dt@kernel.org,
        gregory.clement@free-electrons.com,
        linux-arm-kernel@lists.infradead.org,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Subject: [PATCH v3 1/2] of: irq: Added of_find_irq_domain() to get the domain of an irq
Date: Fri, 21 Mar 2014 15:46:24 +0100
Message-Id: <1395413185-29763-2-git-send-email-jjhiblot@traphandler.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1395413185-29763-1-git-send-email-jjhiblot@traphandler.com>
References: <20140320161118.B7075C4067A@trevor.secretlab.ca>
 <1395413185-29763-1-git-send-email-jjhiblot@traphandler.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This functions does the same parsing as irq_of_parse_and_map but instead
of doing the mapping, it returns a pointer to the irq domain

Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
---
 drivers/of/irq.c       | 20 ++++++++++++++++++++
 include/linux/of_irq.h |  2 ++
 2 files changed, 22 insertions(+)

diff --git a/drivers/of/irq.c b/drivers/of/irq.c
index 9bcf2cf..7d3184f 100644
--- a/drivers/of/irq.c
+++ b/drivers/of/irq.c
@@ -46,6 +46,26 @@ unsigned int irq_of_parse_and_map(struct device_node *dev, int index)
 EXPORT_SYMBOL_GPL(irq_of_parse_and_map);
 
 /**
+ * of_find_irq_domain - Parse the DT and returns a pointer to the irq domain
+ * @dev: Device node of the device whose interrupt is concerned
+ * @index: Index of the interrupt to get the domain for
+ *
+ * This function is a wrapper that chains of_irq_parse_one() and
+ * irq_find_host() to make things easier to callers
+ */
+struct irq_domain *of_find_irq_domain(struct device_node *dev, int index)
+{
+	int rc;
+	struct of_phandle_args oirq;
+
+	rc = of_irq_parse_one(dev, index, &oirq);
+	if (rc)
+		return ERR_PTR(rc);
+
+	return irq_find_host(oirq.np);
+}
+
+/**
  * of_irq_find_parent - Given a device node, find its interrupt parent node
  * @child: pointer to device node
  *
diff --git a/include/linux/of_irq.h b/include/linux/of_irq.h
index 3f23b44..600ff0a 100644
--- a/include/linux/of_irq.h
+++ b/include/linux/of_irq.h
@@ -58,6 +58,8 @@ static inline int of_irq_count(struct device_node *dev)
  * so declare it here regardless of the CONFIG_OF_IRQ setting.
  */
 extern unsigned int irq_of_parse_and_map(struct device_node *node, int index);
+extern struct irq_domain *of_find_irq_domain(struct device_node *dev,
+					     int index);
 extern struct device_node *of_irq_find_parent(struct device_node *child);
 
 #else /* !CONFIG_OF */
-- 
1.9.0

