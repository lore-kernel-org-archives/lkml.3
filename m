Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752028AbaANW74 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 17:59:56 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:55269 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580AbaANW7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 17:59:25 -0500
Message-Id: <39f0fd65345f4c2b75b036234514ca02279fc21f.1389738151.git.joshc@codeaurora.org>
In-Reply-To: <cover.1389738151.git.joshc@codeaurora.org>
References: <cover.1389738151.git.joshc@codeaurora.org>
From: Josh Cartwright <joshc@codeaurora.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, Sagar Dharia <sdharia@codeaurora.org>,
        Gilad Avidov <gavidov@codeaurora.org>,
        Michael Bohan <mbohan@codeaurora.org>
Subject: [PATCH v4 6/6] regmap: spmi: support base and extended register
 spaces
Date: Tue, 14 Jan 2014 12:41:40 -0600
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SPMI states that a slave may contain two register spaces, the Base
register space is a 5-bit byte-addressable space accessed via the
Register Read/Write and Register Zero Write command sequences, and the
Extended register space: a 16-bit byte-addressable space accessed via
the Extended Read/Write and Extended Read/Write Long command sequences.

Provide support for accessing both of these spaces, taking advantage of
the more bandwidth-efficient commands ('Register 0 Write' vs 'Register
Write', and 'Extended Register Read/Write' vs 'Extended Register
Read/Write Long') when possible.

Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
---
 drivers/base/regmap/regmap-spmi.c | 228 ++++++++++++++++++++++++++++++++------
 include/linux/regmap.h            |  12 +-
 2 files changed, 205 insertions(+), 35 deletions(-)

diff --git a/drivers/base/regmap/regmap-spmi.c b/drivers/base/regmap/regmap-spmi.c
index ac23910..d7026dc 100644
--- a/drivers/base/regmap/regmap-spmi.c
+++ b/drivers/base/regmap/regmap-spmi.c
@@ -22,69 +22,235 @@
 #include <linux/module.h>
 #include <linux/init.h>
 
-static int regmap_spmi_read(void *context,
-			    const void *reg, size_t reg_size,
-			    void *val, size_t val_size)
+static int regmap_spmi_base_read(void *context,
+				 const void *reg, size_t reg_size,
+				 void *val, size_t val_size)
 {
+	u8 addr = *(u8 *)reg;
+	int err = 0;
+
+	BUG_ON(reg_size != 1);
+
+	while (val_size-- && !err)
+		err = spmi_register_read(context, addr++, val++);
+
+	return err;
+}
+
+static int regmap_spmi_base_gather_write(void *context,
+					 const void *reg, size_t reg_size,
+					 const void *val, size_t val_size)
+{
+	const u8 *data = val;
+	u8 addr = *(u8 *)reg;
+	int err = 0;
+
+	BUG_ON(reg_size != 1);
+
+	/*
+	 * SPMI defines a more bandwidth-efficient 'Register 0 Write' sequence,
+	 * use it when possible.
+	 */
+	if (addr == 0 && val_size) {
+		err = spmi_register_zero_write(context, *data);
+		if (err)
+			goto err_out;
+
+		data++;
+		addr++;
+		val_size--;
+	}
+
+	while (val_size) {
+		err = spmi_register_write(context, addr, *data);
+		if (err)
+			goto err_out;
+
+		data++;
+		addr++;
+		val_size--;
+	}
+
+err_out:
+	return err;
+}
+
+static int regmap_spmi_base_write(void *context, const void *data,
+				  size_t count)
+{
+	BUG_ON(count < 1);
+	return regmap_spmi_base_gather_write(context, data, 1, data + 1,
+					     count - 1);
+}
+
+static struct regmap_bus regmap_spmi_base = {
+	.read				= regmap_spmi_base_read,
+	.write				= regmap_spmi_base_write,
+	.gather_write			= regmap_spmi_base_gather_write,
+	.reg_format_endian_default	= REGMAP_ENDIAN_NATIVE,
+	.val_format_endian_default	= REGMAP_ENDIAN_NATIVE,
+};
+
+/**
+ * regmap_init_spmi_base(): Create regmap for the Base register space
+ * @sdev:	SPMI device that will be interacted with
+ * @config:	Configuration for register map
+ *
+ * The return value will be an ERR_PTR() on error or a valid pointer to
+ * a struct regmap.
+ */
+struct regmap *regmap_init_spmi_base(struct spmi_device *sdev,
+				     const struct regmap_config *config)
+{
+	return regmap_init(&sdev->dev, &regmap_spmi_base, sdev, config);
+}
+EXPORT_SYMBOL_GPL(regmap_init_spmi_base);
+
+/**
+ * devm_regmap_init_spmi_base(): Create managed regmap for Base register space
+ * @sdev:	SPMI device that will be interacted with
+ * @config:	Configuration for register map
+ *
+ * The return value will be an ERR_PTR() on error or a valid pointer
+ * to a struct regmap.  The regmap will be automatically freed by the
+ * device management code.
+ */
+struct regmap *devm_regmap_init_spmi_base(struct spmi_device *sdev,
+					  const struct regmap_config *config)
+{
+	return devm_regmap_init(&sdev->dev, &regmap_spmi_base, sdev, config);
+}
+EXPORT_SYMBOL_GPL(devm_regmap_init_spmi_base);
+
+static int regmap_spmi_ext_read(void *context,
+				const void *reg, size_t reg_size,
+				void *val, size_t val_size)
+{
+	int err = 0;
+	size_t len;
+	u16 addr;
+
 	BUG_ON(reg_size != 2);
-	return spmi_ext_register_readl(context, *(u16 *)reg,
-				       val, val_size);
+
+	addr = *(u16 *)reg;
+
+	/*
+	 * Split accesses into two to take advantage of the more
+	 * bandwidth-efficient 'Extended Register Read' command when possible
+	 */
+	while (addr <= 0xFF && val_size) {
+		len = min_t(size_t, val_size, 16);
+
+		err = spmi_ext_register_read(context, addr, val, len);
+		if (err)
+			goto err_out;
+
+		addr += len;
+		val += len;
+		val_size -= len;
+	}
+
+	while (val_size) {
+		len = min_t(size_t, val_size, 8);
+
+		err = spmi_ext_register_readl(context, addr, val, val_size);
+		if (err)
+			goto err_out;
+
+		addr += len;
+		val += len;
+		val_size -= len;
+	}
+
+err_out:
+	return err;
 }
 
-static int regmap_spmi_gather_write(void *context,
-				    const void *reg, size_t reg_size,
-				    const void *val, size_t val_size)
+static int regmap_spmi_ext_gather_write(void *context,
+					const void *reg, size_t reg_size,
+					const void *val, size_t val_size)
 {
+	int err = 0;
+	size_t len;
+	u16 addr;
+
 	BUG_ON(reg_size != 2);
-	return spmi_ext_register_writel(context, *(u16 *)reg, val, val_size);
+
+	addr = *(u16 *)reg;
+
+	while (addr <= 0xFF && val_size) {
+		len = min_t(size_t, val_size, 16);
+
+		err = spmi_ext_register_write(context, addr, val, len);
+		if (err)
+			goto err_out;
+
+		addr += len;
+		val += len;
+		val_size -= len;
+	}
+
+	while (val_size) {
+		len = min_t(size_t, val_size, 8);
+
+		err = spmi_ext_register_writel(context, addr, val, len);
+		if (err)
+			goto err_out;
+
+		addr += len;
+		val += len;
+		val_size -= len;
+	}
+
+err_out:
+	return err;
 }
 
-static int regmap_spmi_write(void *context, const void *data,
-			     size_t count)
+static int regmap_spmi_ext_write(void *context, const void *data,
+				 size_t count)
 {
 	BUG_ON(count < 2);
-	return regmap_spmi_gather_write(context, data, 2, data + 2, count - 2);
+	return regmap_spmi_ext_gather_write(context, data, 2, data + 2,
+					    count - 2);
 }
 
-static struct regmap_bus regmap_spmi = {
-	.read				= regmap_spmi_read,
-	.write				= regmap_spmi_write,
-	.gather_write			= regmap_spmi_gather_write,
+static struct regmap_bus regmap_spmi_ext = {
+	.read				= regmap_spmi_ext_read,
+	.write				= regmap_spmi_ext_write,
+	.gather_write			= regmap_spmi_ext_gather_write,
 	.reg_format_endian_default	= REGMAP_ENDIAN_NATIVE,
 	.val_format_endian_default	= REGMAP_ENDIAN_NATIVE,
 };
 
 /**
- * regmap_init_spmi(): Initialize register map
- *
- * @sdev: Device that will be interacted with
- * @config: Configuration for register map
+ * regmap_init_spmi_ext(): Create regmap for Ext register space
+ * @sdev:	Device that will be interacted with
+ * @config:	Configuration for register map
  *
  * The return value will be an ERR_PTR() on error or a valid pointer to
  * a struct regmap.
  */
-struct regmap *regmap_init_spmi(struct spmi_device *sdev,
-				const struct regmap_config *config)
+struct regmap *regmap_init_spmi_ext(struct spmi_device *sdev,
+				    const struct regmap_config *config)
 {
-	return regmap_init(&sdev->dev, &regmap_spmi, sdev, config);
+	return regmap_init(&sdev->dev, &regmap_spmi_ext, sdev, config);
 }
-EXPORT_SYMBOL_GPL(regmap_init_spmi);
+EXPORT_SYMBOL_GPL(regmap_init_spmi_ext);
 
 /**
- * devm_regmap_init_spmi(): Initialise managed register map
- *
- * @sdev: Device that will be interacted with
- * @config: Configuration for register map
+ * devm_regmap_init_spmi_ext(): Create managed regmap for Ext register space
+ * @sdev:	SPMI device that will be interacted with
+ * @config:	Configuration for register map
  *
  * The return value will be an ERR_PTR() on error or a valid pointer
  * to a struct regmap.  The regmap will be automatically freed by the
  * device management code.
  */
-struct regmap *devm_regmap_init_spmi(struct spmi_device *sdev,
+struct regmap *devm_regmap_init_spmi_ext(struct spmi_device *sdev,
 				     const struct regmap_config *config)
 {
-	return devm_regmap_init(&sdev->dev, &regmap_spmi, sdev, config);
+	return devm_regmap_init(&sdev->dev, &regmap_spmi_ext, sdev, config);
 }
-EXPORT_SYMBOL_GPL(devm_regmap_init_spmi);
+EXPORT_SYMBOL_GPL(devm_regmap_init_spmi_ext);
 
 MODULE_LICENSE("GPL");
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index e559078..847e7e6 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -321,8 +321,10 @@ struct regmap *regmap_init_i2c(struct i2c_client *i2c,
 			       const struct regmap_config *config);
 struct regmap *regmap_init_spi(struct spi_device *dev,
 			       const struct regmap_config *config);
-struct regmap *regmap_init_spmi(struct spmi_device *dev,
-			       const struct regmap_config *config);
+struct regmap *regmap_init_spmi_base(struct spmi_device *dev,
+				     const struct regmap_config *config);
+struct regmap *regmap_init_spmi_ext(struct spmi_device *dev,
+				    const struct regmap_config *config);
 struct regmap *regmap_init_mmio_clk(struct device *dev, const char *clk_id,
 				    void __iomem *regs,
 				    const struct regmap_config *config);
@@ -335,8 +337,10 @@ struct regmap *devm_regmap_init_i2c(struct i2c_client *i2c,
 				    const struct regmap_config *config);
 struct regmap *devm_regmap_init_spi(struct spi_device *dev,
 				    const struct regmap_config *config);
-struct regmap *devm_regmap_init_spmi(struct spmi_device *dev,
-				     const struct regmap_config *config);
+struct regmap *devm_regmap_init_spmi_base(struct spmi_device *dev,
+					  const struct regmap_config *config);
+struct regmap *devm_regmap_init_spmi_ext(struct spmi_device *dev,
+					 const struct regmap_config *config);
 struct regmap *devm_regmap_init_mmio_clk(struct device *dev, const char *clk_id,
 					 void __iomem *regs,
 					 const struct regmap_config *config);
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

