Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228AbaEABKy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 21:10:54 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:56113 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbaEABKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 21:10:20 -0400
From: Boris BREZILLON <b.brezillon.dev@gmail.com>
To: Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Boris BREZILLON <b.brezillon.dev@gmail.com>
Subject: [RFC PATCH 2/3] of: mtd: add NAND randomizer mode retrieval
Date: Thu,  1 May 2014 03:09:51 +0200
Message-Id: <1398906592-24677-3-git-send-email-b.brezillon.dev@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398906592-24677-1-git-send-email-b.brezillon.dev@gmail.com>
References: <1398906592-24677-1-git-send-email-b.brezillon.dev@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Boris BREZILLON <b.brezillon.dev@gmail.com>
---
 drivers/of/of_mtd.c    | 35 +++++++++++++++++++++++++++++++++++
 include/linux/of_mtd.h |  6 ++++++
 2 files changed, 41 insertions(+)

diff --git a/drivers/of/of_mtd.c b/drivers/of/of_mtd.c
index a862c08..f941a5e 100644
--- a/drivers/of/of_mtd.c
+++ b/drivers/of/of_mtd.c
@@ -84,6 +84,41 @@ int of_get_nand_ecc_strength(struct device_node *np)
 EXPORT_SYMBOL_GPL(of_get_nand_ecc_strength);
 
 /**
+ * It maps 'enum nand_rnd_modes_t' found in include/linux/mtd/nand.h
+ * into the device tree binding of 'nand-rnd', so that MTD
+ * device driver can get nand rnd from device tree.
+ */
+static const char * const nand_rnd_modes[] = {
+	[NAND_RND_NONE]		= "none",
+	[NAND_RND_SOFT]		= "soft",
+	[NAND_RND_HW]		= "hw",
+};
+
+/**
+ * of_get_nand_rnd_mode - Get nand randomizer mode for given device_node
+ * @np:	Pointer to the given device_node
+ *
+ * The function gets randomizer mode string from property 'nand-rnd-mode',
+ * and return its index in nand_rnd_modes table, or errno in error case.
+ */
+int of_get_nand_rnd_mode(struct device_node *np)
+{
+	const char *pm;
+	int err, i;
+
+	err = of_property_read_string(np, "nand-rnd-mode", &pm);
+	if (err < 0)
+		return err;
+
+	for (i = 0; i < ARRAY_SIZE(nand_rnd_modes); i++)
+		if (!strcasecmp(pm, nand_rnd_modes[i]))
+			return i;
+
+	return -ENODEV;
+}
+EXPORT_SYMBOL_GPL(of_get_nand_rnd_mode);
+
+/**
  * of_get_nand_bus_width - Get nand bus witdh for given device_node
  * @np:	Pointer to the given device_node
  *
diff --git a/include/linux/of_mtd.h b/include/linux/of_mtd.h
index d0145fb..2f43362 100644
--- a/include/linux/of_mtd.h
+++ b/include/linux/of_mtd.h
@@ -15,6 +15,7 @@
 int of_get_nand_ecc_mode(struct device_node *np);
 int of_get_nand_ecc_step_size(struct device_node *np);
 int of_get_nand_ecc_strength(struct device_node *np);
+int of_get_nand_rnd_mode(struct device_node *np);
 int of_get_nand_bus_width(struct device_node *np);
 bool of_get_nand_on_flash_bbt(struct device_node *np);
 int of_get_nand_onfi_timing_mode(struct device_node *np);
@@ -36,6 +37,11 @@ static inline int of_get_nand_ecc_strength(struct device_node *np)
 	return -ENOSYS;
 }
 
+static inline int of_get_nand_rnd_mode(struct device_node *np)
+{
+	return -ENOSYS;
+}
+
 static inline int of_get_nand_bus_width(struct device_node *np)
 {
 	return -ENOSYS;
-- 
1.8.3.2

