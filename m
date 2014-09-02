Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823AbaIBPpw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 11:45:52 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:39322 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754774AbaIBPpE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 11:45:04 -0400
From: Stanimir Varbanov <svarbanov@mm-sol.com>
To: Grant Likely <grant.likely@linaro.org>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Rob Herring <robherring2@gmail.com>,
        Rob Herring <rob.herring@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Lee Jones <lee.jones@linaro.org>, Stephen Boyd <sboyd@codeaurora.org>,
        Stanimir Varbanov <svarbanov@mm-sol.com>
Subject: [PATCH] RFC: add function for localbus address
Date: Tue,  2 Sep 2014 18:45:00 +0300
Message-Id: <1409672700-21697-1-git-send-email-svarbanov@mm-sol.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <20140729234522.E9FF1C40738@trevor.secretlab.ca>
References: <20140729234522.E9FF1C40738@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

I came down to this. Could you review? Is that
implementation closer to the suggestion made by you.

---
 drivers/of/address.c       |   49 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/of/platform.c      |   20 ++++++++++++++---
 include/linux/of_address.h |   19 +++++++++++++++++
 3 files changed, 84 insertions(+), 4 deletions(-)

diff --git a/drivers/of/address.c b/drivers/of/address.c
index e371825..86c2166 100644
--- a/drivers/of/address.c
+++ b/drivers/of/address.c
@@ -601,6 +601,32 @@ const __be32 *of_get_address(struct device_node *dev, int index, u64 *size,
 }
 EXPORT_SYMBOL(of_get_address);
 
+const __be32 *of_get_localbus_address(struct device_node *np, int index,
+				      u64 *size)
+{
+	struct device_node *root, *parent;
+	const __be32 *ranges, *prop = NULL;
+
+	parent = of_get_parent(np);
+	if (!parent)
+		return NULL;
+
+	root = of_find_node_by_path("/");
+
+	if (parent == root) {
+		of_node_put(parent);
+		return NULL;
+	}
+
+	ranges = of_get_property(parent, "ranges", NULL);
+	of_node_put(parent);
+
+	if (!ranges)
+		prop = of_get_address(np, index, size, NULL);
+
+	return prop;
+}
+
 unsigned long __weak pci_address_to_pio(phys_addr_t address)
 {
 	if (address > IO_SPACE_LIMIT)
@@ -665,6 +691,29 @@ int of_address_to_resource(struct device_node *dev, int index,
 }
 EXPORT_SYMBOL_GPL(of_address_to_resource);
 
+int of_localbus_address_to_resource(struct device_node *dev, int index,
+				    struct resource *r)
+{
+	const char *name = NULL;
+	const __be32 *addrp;
+	u64 size;
+
+	addrp = of_get_localbus_address(dev, index, &size);
+	if (!addrp)
+		return -EINVAL;
+
+	of_property_read_string_index(dev, "reg-names", index, &name);
+
+	memset(r, 0, sizeof(*r));
+	r->start = be32_to_cpup(addrp);
+	r->end = r->start + size - 1;
+	r->flags = IORESOURCE_REG;
+	r->name = name ? name : dev->full_name;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(of_localbus_address_to_resource);
+
 struct device_node *of_find_matching_node_by_address(struct device_node *from,
 					const struct of_device_id *matches,
 					u64 base_address)
diff --git a/drivers/of/platform.c b/drivers/of/platform.c
index 0197725..36dcbd7 100644
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -106,8 +106,9 @@ struct platform_device *of_device_alloc(struct device_node *np,
 				  struct device *parent)
 {
 	struct platform_device *dev;
-	int rc, i, num_reg = 0, num_irq;
+	int rc, i, num_reg = 0, num_localbus_reg = 0, num_irq;
 	struct resource *res, temp_res;
+	int num_resources;
 
 	dev = platform_device_alloc("", -1);
 	if (!dev)
@@ -116,22 +117,33 @@ struct platform_device *of_device_alloc(struct device_node *np,
 	/* count the io and irq resources */
 	while (of_address_to_resource(np, num_reg, &temp_res) == 0)
 		num_reg++;
+
+	while (of_localbus_address_to_resource(np,
+					num_localbus_reg, &temp_res) == 0)
+		num_localbus_reg++;
+
 	num_irq = of_irq_count(np);
 
+	num_resources = num_reg + num_localbus_reg + num_irq;
+
 	/* Populate the resource table */
-	if (num_irq || num_reg) {
-		res = kzalloc(sizeof(*res) * (num_irq + num_reg), GFP_KERNEL);
+	if (num_resources) {
+		res = kzalloc(sizeof(*res) * num_resources, GFP_KERNEL);
 		if (!res) {
 			platform_device_put(dev);
 			return NULL;
 		}
 
-		dev->num_resources = num_reg + num_irq;
+		dev->num_resources = num_resources;
 		dev->resource = res;
 		for (i = 0; i < num_reg; i++, res++) {
 			rc = of_address_to_resource(np, i, res);
 			WARN_ON(rc);
 		}
+		for (i = 0; i < num_localbus_reg; i++, res++) {
+			rc = of_localbus_address_to_resource(np, i, res);
+			WARN_ON(rc);
+		}
 		if (of_irq_to_resource_table(np, res, num_irq) != num_irq)
 			pr_debug("not all legacy IRQ resources mapped for %s\n",
 				 np->name);
diff --git a/include/linux/of_address.h b/include/linux/of_address.h
index fb7b722..10112ea 100644
--- a/include/linux/of_address.h
+++ b/include/linux/of_address.h
@@ -42,6 +42,8 @@ extern u64 of_translate_dma_address(struct device_node *dev,
 extern u64 of_translate_address(struct device_node *np, const __be32 *addr);
 extern int of_address_to_resource(struct device_node *dev, int index,
 				  struct resource *r);
+extern int of_localbus_address_to_resource(struct device_node *dev, int index,
+				  struct resource *r);
 extern struct device_node *of_find_matching_node_by_address(
 					struct device_node *from,
 					const struct of_device_id *matches,
@@ -55,6 +57,9 @@ extern void __iomem *of_iomap(struct device_node *device, int index);
 extern const __be32 *of_get_address(struct device_node *dev, int index,
 			   u64 *size, unsigned int *flags);
 
+extern const __be32 *of_get_localbus_address(struct device_node *np, int index,
+			   u64 *size);
+
 extern unsigned long pci_address_to_pio(phys_addr_t addr);
 
 extern int of_pci_range_parser_init(struct of_pci_range_parser *parser,
@@ -80,6 +85,12 @@ static inline const __be32 *of_get_address(struct device_node *dev, int index,
 	return NULL;
 }
 
+static inline const __be32 *of_get_localbus_address(struct device_node *dev,
+						    int index, u64 *size)
+{
+	return NULL;
+}
+
 static inline int of_pci_range_parser_init(struct of_pci_range_parser *parser,
 			struct device_node *node)
 {
@@ -108,6 +119,8 @@ static inline bool of_dma_is_coherent(struct device_node *np)
 #ifdef CONFIG_OF
 extern int of_address_to_resource(struct device_node *dev, int index,
 				  struct resource *r);
+extern int of_localbus_address_to_resource(struct device_node *dev, int index,
+				  struct resource *r);
 void __iomem *of_iomap(struct device_node *node, int index);
 void __iomem *of_io_request_and_map(struct device_node *device,
 					int index, char *name);
@@ -121,6 +134,12 @@ static inline int of_address_to_resource(struct device_node *dev, int index,
 	return -EINVAL;
 }
 
+static inline int of_localbus_address_to_resource(struct device_node *dev,
+						  int index, struct resource *r)
+{
+	return -EINVAL;
+}
+
 static inline void __iomem *of_iomap(struct device_node *device, int index)
 {
 	return NULL;
-- 
1.7.0.4

