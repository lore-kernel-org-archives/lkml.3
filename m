Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588Ab3IESG3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 14:06:29 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:57571 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124Ab3IESG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 14:06:27 -0400
From: Rob Herring <robherring2@gmail.com>
To: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@linaro.org>
Subject: [PATCH] of: clean-up ifdefs in of_irq.h
Date: Thu,  5 Sep 2013 13:06:14 -0500
Message-Id: <1378404374-13650-1-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

Much of of_irq.h is needlessly ifdef'ed. Clean this up and minimize the
amount ifdef'ed code. This fixes some  build warnings when CONFIG_OF
is not enabled (seen on i386 and x86_64):

include/linux/of_irq.h:82:7: warning: 'struct device_node' declared inside parameter list [enabled by default]
include/linux/of_irq.h:82:7: warning: its scope is only this definition or declaration, which is probably not what you want [enabled by default]
include/linux/of_irq.h:87:47: warning: 'struct device_node' declared inside parameter list [enabled by default]

Compile tested on i386, sparc and arm.

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Grant Likely <grant.likely@linaro.org>
Signed-off-by: Rob Herring <rob.herring@calxeda.com>
---
Randy,

After looking at this some more, I think it makes sense to just
fix these needless ifdefs now and be done with it.

Rob

 include/linux/of_irq.h | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/include/linux/of_irq.h b/include/linux/of_irq.h
index 535cecf..fcd63ba 100644
--- a/include/linux/of_irq.h
+++ b/include/linux/of_irq.h
@@ -1,8 +1,6 @@
 #ifndef __OF_IRQ_H
 #define __OF_IRQ_H
 
-#if defined(CONFIG_OF)
-struct of_irq;
 #include <linux/types.h>
 #include <linux/errno.h>
 #include <linux/irq.h>
@@ -10,14 +8,6 @@ struct of_irq;
 #include <linux/ioport.h>
 #include <linux/of.h>
 
-/*
- * irq_of_parse_and_map() is used by all OF enabled platforms; but SPARC
- * implements it differently.  However, the prototype is the same for all,
- * so declare it here regardless of the CONFIG_OF_IRQ setting.
- */
-extern unsigned int irq_of_parse_and_map(struct device_node *node, int index);
-
-#if defined(CONFIG_OF_IRQ)
 /**
  * of_irq - container for device_node/irq_specifier pair for an irq controller
  * @controller: pointer to interrupt controller device tree node
@@ -71,11 +61,17 @@ extern int of_irq_to_resource(struct device_node *dev, int index,
 extern int of_irq_count(struct device_node *dev);
 extern int of_irq_to_resource_table(struct device_node *dev,
 		struct resource *res, int nr_irqs);
-extern struct device_node *of_irq_find_parent(struct device_node *child);
 
 extern void of_irq_init(const struct of_device_id *matches);
 
-#endif /* CONFIG_OF_IRQ */
+#if defined(CONFIG_OF)
+/*
+ * irq_of_parse_and_map() is used by all OF enabled platforms; but SPARC
+ * implements it differently.  However, the prototype is the same for all,
+ * so declare it here regardless of the CONFIG_OF_IRQ setting.
+ */
+extern unsigned int irq_of_parse_and_map(struct device_node *node, int index);
+extern struct device_node *of_irq_find_parent(struct device_node *child);
 
 #else /* !CONFIG_OF */
 static inline unsigned int irq_of_parse_and_map(struct device_node *dev,
-- 
1.8.1.2

