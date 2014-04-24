Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932217AbaDXPbo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 11:31:44 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:49535 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754569AbaDXPbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 11:31:39 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH v3 3/7] of: introduce of_dma_is_coherent() helper
Date: Thu, 24 Apr 2014 11:30:03 -0400
Message-ID: <1398353407-2345-4-git-send-email-santosh.shilimkar@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398353407-2345-1-git-send-email-santosh.shilimkar@ti.com>
References: <1398353407-2345-1-git-send-email-santosh.shilimkar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The of_dma_is_coherent() helper parses the given DT device
node to see if the "dma-coherent" property is supported and
returns true or false accordingly.

If the arch is always coherent or always noncoherent, then the default
DMA ops has to be specified accordingly.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Olof Johansson <olof@lixom.net>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/of/platform.c       |   23 +++++++++++++++++++++++
 include/linux/of_platform.h |    6 ++++++
 2 files changed, 29 insertions(+)

diff --git a/drivers/of/platform.c b/drivers/of/platform.c
index 404d1da..48de98f 100644
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -485,4 +485,27 @@ int of_platform_populate(struct device_node *root,
 	return rc;
 }
 EXPORT_SYMBOL_GPL(of_platform_populate);
+
+/**
+ * of_dma_is_coherent - Check if device is coherent
+ * @np:	device node
+ *
+ * It returns true if "dma-coherent" property was found
+ * for this device in DT.
+ */
+bool of_dma_is_coherent(struct device_node *np)
+{
+	struct device_node *node = of_node_get(np);
+
+	while (node) {
+		if (of_property_read_bool(node, "dma-coherent")) {
+			of_node_put(node);
+			return true;
+		}
+		node = of_get_next_parent(node);
+	}
+	of_node_put(node);
+	return false;
+}
+EXPORT_SYMBOL_GPL(of_dma_is_coherent);
 #endif /* CONFIG_OF_ADDRESS */
diff --git a/include/linux/of_platform.h b/include/linux/of_platform.h
index 05cb4a9..b9a3cb2 100644
--- a/include/linux/of_platform.h
+++ b/include/linux/of_platform.h
@@ -72,6 +72,7 @@ extern int of_platform_populate(struct device_node *root,
 				const struct of_device_id *matches,
 				const struct of_dev_auxdata *lookup,
 				struct device *parent);
+extern bool of_dma_is_coherent(struct device_node *np);
 #else
 static inline int of_platform_populate(struct device_node *root,
 					const struct of_device_id *matches,
@@ -80,6 +81,11 @@ static inline int of_platform_populate(struct device_node *root,
 {
 	return -ENODEV;
 }
+
+static inline bool of_dma_is_coherent(struct device_node *np)
+{
+	return false;
+}
 #endif
 
 #endif	/* _LINUX_OF_PLATFORM_H */
-- 
1.7.9.5

