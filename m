Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669AbaA2Oej (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 09:34:39 -0500
Received: from mail-ee0-f41.google.com ([74.125.83.41]:33311 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575AbaA2Oef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 09:34:35 -0500
From: Boris BREZILLON <b.brezillon.dev@gmail.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc: Boris BREZILLON <b.brezillon.dev@gmail.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mtd@lists.infradead.org,
        dev@linux-sunxi.org
Subject: [RFC PATCH v2 02/14] of: mtd: add NAND ECC level requirements retrieval
Date: Wed, 29 Jan 2014 15:34:12 +0100
Message-Id: <1391006064-28890-3-git-send-email-b.brezillon.dev@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1391006064-28890-1-git-send-email-b.brezillon.dev@gmail.com>
References: <1391006064-28890-1-git-send-email-b.brezillon.dev@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some chip do not support automatic retrieval of ECC level requirements.
Provide an helper function to retrieve these requirements from DT.

Signed-off-by: Boris BREZILLON <b.brezillon.dev@gmail.com>
---
 drivers/of/of_mtd.c    |   25 +++++++++++++++++++++++++
 include/linux/of_mtd.h |    7 +++++++
 2 files changed, 32 insertions(+)

diff --git a/drivers/of/of_mtd.c b/drivers/of/of_mtd.c
index a27ec94..e8ced61 100644
--- a/drivers/of/of_mtd.c
+++ b/drivers/of/of_mtd.c
@@ -50,6 +50,31 @@ int of_get_nand_ecc_mode(struct device_node *np)
 EXPORT_SYMBOL_GPL(of_get_nand_ecc_mode);
 
 /**
+ * of_get_nand_ecc_level - Get nand ecc level for the given device_node
+ * @np:	Pointer to the given device_node
+ * @strengh: ECC strength
+ * @blk_size: ECC block size
+ *
+ * The function gets ecc level requirements from property 'nand-ecc-level'.
+ * Return 0 on success, -errno otherwise.
+ */
+int of_get_nand_ecc_level(struct device_node *np, u32 *strengh, u32 *blk_size)
+{
+	int err;
+
+	err = of_property_read_u32_index(np, "nand-ecc-level", 0, strengh);
+	if (err < 0)
+		return err;
+
+	err = of_property_read_u32_index(np, "nand-ecc-level", 1, blk_size);
+	if (err < 0)
+		return err;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(of_get_nand_ecc_level);
+
+/**
  * of_get_nand_bus_width - Get nand bus witdh for given device_node
  * @np:	Pointer to the given device_node
  *
diff --git a/include/linux/of_mtd.h b/include/linux/of_mtd.h
index 6f10e93..3bd8c3b 100644
--- a/include/linux/of_mtd.h
+++ b/include/linux/of_mtd.h
@@ -13,6 +13,7 @@
 
 #include <linux/of.h>
 int of_get_nand_ecc_mode(struct device_node *np);
+int of_get_nand_ecc_level(struct device_node *np, u32 *strengh, u32 *blk_size);
 int of_get_nand_bus_width(struct device_node *np);
 bool of_get_nand_on_flash_bbt(struct device_node *np);
 
@@ -23,6 +24,12 @@ static inline int of_get_nand_ecc_mode(struct device_node *np)
 	return -ENOSYS;
 }
 
+static inline int of_get_nand_ecc_level(struct device_node *np, u32 *strengh,
+					u32 *blk_size)
+{
+	return -ENOSYS;
+}
+
 static inline int of_get_nand_bus_width(struct device_node *np)
 {
 	return -ENOSYS;
-- 
1.7.9.5

