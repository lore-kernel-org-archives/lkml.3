Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501Ab3IZSxm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 14:53:42 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:64297 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754195Ab3IZSvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 14:51:36 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
Subject: [PATCH 16/21] of: move of_address_to_resource and of_iomap declarations from sparc
Date: Thu, 26 Sep 2013 13:50:51 -0500
Message-Id: <1380221456-11192-17-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1380221456-11192-1-git-send-email-robherring2@gmail.com>
References: <1380221456-11192-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

Move of_address_to_resource and of_iomap declarations to common code. These
only differ on sparc, but the declarations are the same and don't need to
be in arch header.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: sparclinux@vger.kernel.org
---
 arch/sparc/include/asm/prom.h |  8 --------
 include/linux/of_address.h    | 30 +++++++++++++++++-------------
 2 files changed, 17 insertions(+), 21 deletions(-)

diff --git a/arch/sparc/include/asm/prom.h b/arch/sparc/include/asm/prom.h
index 60c8d7b..11ebd65 100644
--- a/arch/sparc/include/asm/prom.h
+++ b/arch/sparc/include/asm/prom.h
@@ -59,13 +59,5 @@ extern char *of_console_options;
 extern void irq_trans_init(struct device_node *dp);
 extern char *build_path_component(struct device_node *dp);
 
-/* SPARC has local implementations */
-extern int of_address_to_resource(struct device_node *dev, int index,
-				  struct resource *r);
-#define of_address_to_resource of_address_to_resource
-
-void __iomem *of_iomap(struct device_node *node, int index);
-#define of_iomap of_iomap
-
 #endif /* __KERNEL__ */
 #endif /* _SPARC_PROM_H */
diff --git a/include/linux/of_address.h b/include/linux/of_address.h
index f6fc689..e8a1797 100644
--- a/include/linux/of_address.h
+++ b/include/linux/of_address.h
@@ -60,13 +60,6 @@ extern struct of_pci_range *of_pci_range_parser_one(
 					struct of_pci_range_parser *parser,
 					struct of_pci_range *range);
 #else /* CONFIG_OF_ADDRESS */
-#ifndef of_address_to_resource
-static inline int of_address_to_resource(struct device_node *dev, int index,
-					 struct resource *r)
-{
-	return -EINVAL;
-}
-#endif
 static inline struct device_node *of_find_matching_node_by_address(
 					struct device_node *from,
 					const struct of_device_id *matches,
@@ -74,12 +67,7 @@ static inline struct device_node *of_find_matching_node_by_address(
 {
 	return NULL;
 }
-#ifndef of_iomap
-static inline void __iomem *of_iomap(struct device_node *device, int index)
-{
-	return NULL;
-}
-#endif
+
 static inline const __be32 *of_get_address(struct device_node *dev, int index,
 					u64 *size, unsigned int *flags)
 {
@@ -100,6 +88,22 @@ static inline struct of_pci_range *of_pci_range_parser_one(
 }
 #endif /* CONFIG_OF_ADDRESS */
 
+#ifdef CONFIG_OF
+extern int of_address_to_resource(struct device_node *dev, int index,
+				  struct resource *r);
+void __iomem *of_iomap(struct device_node *node, int index);
+#else
+static inline int of_address_to_resource(struct device_node *dev, int index,
+					 struct resource *r)
+{
+	return -EINVAL;
+}
+
+static inline void __iomem *of_iomap(struct device_node *device, int index)
+{
+	return NULL;
+}
+#endif
 
 #if defined(CONFIG_OF_ADDRESS) && defined(CONFIG_PCI)
 extern const __be32 *of_get_pci_address(struct device_node *dev, int bar_no,
-- 
1.8.1.2

