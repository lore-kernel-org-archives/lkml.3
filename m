Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859Ab3CXN6o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 09:58:44 -0400
Received: from norkia.v3.sk ([91.210.183.14]:58233 "EHLO norkia.v3.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753790Ab3CXN6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 09:58:43 -0400
From: Lubomir Rintel <lkundrak@v3.sk>
To: linux-kernel@vger.kernel.org
Cc: Lubomir Rintel <lkundrak@v3.sk>, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH] of: add managed version of of_iomap()
Date: Sun, 24 Mar 2013 14:58:13 +0100
Message-Id: <1364133493-25262-1-git-send-email-lkundrak@v3.sk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This introduces a routine devm_of_iomap(), which acts exactly like of_iomap()
apart from that managed deivce resource subsystem takes care of reclaiming the
resources wherever appropriate.

Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: devicetree-discuss@lists.ozlabs.org
Cc: Guenter Roeck <linux@roeck-us.net>
Reference: http://lists.infradead.org/pipermail/linux-rpi-kernel/2013-March/000461.html
---
 Documentation/driver-model/devres.txt |    1 +
 drivers/of/address.c                  |   21 ++++++++++++++++++++-
 include/linux/of_address.h            |   11 +++++++++++
 3 files changed, 32 insertions(+), 1 deletions(-)

diff --git a/Documentation/driver-model/devres.txt b/Documentation/driver-model/devres.txt
index b467145..e9f8bc3 100644
--- a/Documentation/driver-model/devres.txt
+++ b/Documentation/driver-model/devres.txt
@@ -268,6 +268,7 @@ IOMAP
   devm_iounmap()
   devm_ioremap_resource() : checks resource, requests memory region, ioremaps
   devm_request_and_ioremap() : obsoleted by devm_ioremap_resource()
+  devm_of_iomap()
   pcim_iomap()
   pcim_iounmap()
   pcim_iomap_table()	: array of mapped addresses indexed by BAR
diff --git a/drivers/of/address.c b/drivers/of/address.c
index 04da786..b52d7f6 100644
--- a/drivers/of/address.c
+++ b/drivers/of/address.c
@@ -629,7 +629,6 @@ struct device_node *of_find_matching_node_by_address(struct device_node *from,
 	return NULL;
 }
 
-
 /**
  * of_iomap - Maps the memory mapped IO for a given device_node
  * @device:	the device whose io range will be mapped
@@ -647,3 +646,23 @@ void __iomem *of_iomap(struct device_node *np, int index)
 	return ioremap(res.start, resource_size(&res));
 }
 EXPORT_SYMBOL(of_iomap);
+
+/**
+ * devm_of_iomap - Managed of_iomap()
+ * @dev:	generic device to map range for
+ * @np:		the device node whose io range will be mapped
+ * @index:	index of the io range
+ *
+ * Returns a pointer to the mapped memory
+ */
+void __iomem *devm_of_iomap(struct device *dev, struct device_node *np,
+								int index)
+{
+	struct resource res;
+
+	if (of_address_to_resource(np, index, &res))
+		return NULL;
+
+	return devm_ioremap(dev, res.start, resource_size(&res));
+}
+EXPORT_SYMBOL(devm_of_iomap);
diff --git a/include/linux/of_address.h b/include/linux/of_address.h
index 0506eb5..6c6f71f 100644
--- a/include/linux/of_address.h
+++ b/include/linux/of_address.h
@@ -14,6 +14,9 @@ extern struct device_node *of_find_matching_node_by_address(
 					const struct of_device_id *matches,
 					u64 base_address);
 extern void __iomem *of_iomap(struct device_node *device, int index);
+extern void __iomem *devm_of_iomap(struct device *dev,
+					struct device_node *device,
+					int index);
 
 /* Extract an address from a device, returns the region size and
  * the address space flags too. The PCI version uses a BAR number
@@ -48,6 +51,14 @@ static inline void __iomem *of_iomap(struct device_node *device, int index)
 	return NULL;
 }
 #endif
+#ifndef devm_of_iomap
+static inline void __iomem *devm_of_iomap(struct device *dev,
+					struct device_node *device,
+					int index);
+{
+	return NULL;
+}
+#endif
 static inline const __be32 *of_get_address(struct device_node *dev, int index,
 					u64 *size, unsigned int *flags)
 {
-- 
1.7.1

