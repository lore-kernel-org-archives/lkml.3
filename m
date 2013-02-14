Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934762Ab3BNQjP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 11:39:15 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48159 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757950Ab3BNQjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 11:39:13 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH] regmap: mmio: add register clock support
Date: Thu, 14 Feb 2013 17:39:08 +0100
Message-Id: <1360859948-22473-1-git-send-email-p.zabel@pengutronix.de>
X-Mailer: git-send-email 1.7.10.4
X-SA-Exim-Connect-IP: 10.1.0.7
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some mmio devices have a dedicated interface clock that needs
to be enabled to access their registers. This patch optionally
enables a clock before accessing registers in the regmap_bus
callbacks.

I added (devm_)regmap_init_mmio_clk variants of the init
functions that have an added clk_id string parameter. This
is passed to clk_get to request the clock from the clk
framework.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/base/regmap/regmap-mmio.c |   79 +++++++++++++++++++++++++++++++------
 include/linux/regmap.h            |   47 +++++++++++++++++++---
 2 files changed, 107 insertions(+), 19 deletions(-)

diff --git a/drivers/base/regmap/regmap-mmio.c b/drivers/base/regmap/regmap-mmio.c
index f05fc74..98745dd 100644
--- a/drivers/base/regmap/regmap-mmio.c
+++ b/drivers/base/regmap/regmap-mmio.c
@@ -16,6 +16,7 @@
  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
+#include <linux/clk.h>
 #include <linux/err.h>
 #include <linux/init.h>
 #include <linux/io.h>
@@ -26,6 +27,7 @@
 struct regmap_mmio_context {
 	void __iomem *regs;
 	unsigned val_bytes;
+	struct clk *clk;
 };
 
 static int regmap_mmio_gather_write(void *context,
@@ -34,9 +36,16 @@ static int regmap_mmio_gather_write(void *context,
 {
 	struct regmap_mmio_context *ctx = context;
 	u32 offset;
+	int ret;
 
 	BUG_ON(reg_size != 4);
 
+	if (ctx->clk) {
+		ret = clk_enable(ctx->clk);
+		if (ret < 0)
+			return ret;
+	}
+
 	offset = *(u32 *)reg;
 
 	while (val_size) {
@@ -64,6 +73,9 @@ static int regmap_mmio_gather_write(void *context,
 		offset += ctx->val_bytes;
 	}
 
+	if (ctx->clk)
+		clk_disable(ctx->clk);
+
 	return 0;
 }
 
@@ -80,9 +92,16 @@ static int regmap_mmio_read(void *context,
 {
 	struct regmap_mmio_context *ctx = context;
 	u32 offset;
+	int ret;
 
 	BUG_ON(reg_size != 4);
 
+	if (ctx->clk) {
+		ret = clk_enable(ctx->clk);
+		if (ret < 0)
+			return ret;
+	}
+
 	offset = *(u32 *)reg;
 
 	while (val_size) {
@@ -110,11 +129,20 @@ static int regmap_mmio_read(void *context,
 		offset += ctx->val_bytes;
 	}
 
+	if (ctx->clk)
+		clk_disable(ctx->clk);
+
 	return 0;
 }
 
 static void regmap_mmio_free_context(void *context)
 {
+	struct regmap_mmio_context *ctx = context;
+
+	if (ctx->clk) {
+		clk_unprepare(ctx->clk);
+		clk_put(ctx->clk);
+	}
 	kfree(context);
 }
 
@@ -128,11 +156,14 @@ static struct regmap_bus regmap_mmio = {
 	.val_format_endian_default = REGMAP_ENDIAN_NATIVE,
 };
 
-static struct regmap_mmio_context *regmap_mmio_gen_context(void __iomem *regs,
+static struct regmap_mmio_context *regmap_mmio_gen_context(struct device *dev,
+					const char *clk_id,
+					void __iomem *regs,
 					const struct regmap_config *config)
 {
 	struct regmap_mmio_context *ctx;
 	int min_stride;
+	int ret;
 
 	if (config->reg_bits != 32)
 		return ERR_PTR(-EINVAL);
@@ -179,37 +210,59 @@ static struct regmap_mmio_context *regmap_mmio_gen_context(void __iomem *regs,
 	ctx->regs = regs;
 	ctx->val_bytes = config->val_bits / 8;
 
+	if (clk_id == NULL)
+		return ctx;
+
+	ctx->clk = clk_get(dev, clk_id);
+	if (IS_ERR(ctx->clk)) {
+		ret = PTR_ERR(ctx->clk);
+		goto err_free;
+	}
+
+	ret = clk_prepare(ctx->clk);
+	if (ret < 0) {
+		clk_put(ctx->clk);
+		goto err_free;
+	}
+
 	return ctx;
+
+err_free:
+	kfree(ctx);
+
+	return ERR_PTR(ret);
 }
 
 /**
- * regmap_init_mmio(): Initialise register map
+ * regmap_init_mmio_clk(): Initialise register map with register clock
  *
  * @dev: Device that will be interacted with
+ * @clk_id: register clock consumer ID
  * @regs: Pointer to memory-mapped IO region
  * @config: Configuration for register map
  *
  * The return value will be an ERR_PTR() on error or a valid pointer to
  * a struct regmap.
  */
-struct regmap *regmap_init_mmio(struct device *dev,
-				void __iomem *regs,
-				const struct regmap_config *config)
+struct regmap *regmap_init_mmio_clk(struct device *dev, const char *clk_id,
+				    void __iomem *regs,
+				    const struct regmap_config *config)
 {
 	struct regmap_mmio_context *ctx;
 
-	ctx = regmap_mmio_gen_context(regs, config);
+	ctx = regmap_mmio_gen_context(dev, clk_id, regs, config);
 	if (IS_ERR(ctx))
 		return ERR_CAST(ctx);
 
 	return regmap_init(dev, &regmap_mmio, ctx, config);
 }
-EXPORT_SYMBOL_GPL(regmap_init_mmio);
+EXPORT_SYMBOL_GPL(regmap_init_mmio_clk);
 
 /**
- * devm_regmap_init_mmio(): Initialise managed register map
+ * devm_regmap_init_mmio_clk(): Initialise managed register map with clock
  *
  * @dev: Device that will be interacted with
+ * @clk_id: register clock consumer ID
  * @regs: Pointer to memory-mapped IO region
  * @config: Configuration for register map
  *
@@ -217,18 +270,18 @@ EXPORT_SYMBOL_GPL(regmap_init_mmio);
  * to a struct regmap.  The regmap will be automatically freed by the
  * device management code.
  */
-struct regmap *devm_regmap_init_mmio(struct device *dev,
-				     void __iomem *regs,
-				     const struct regmap_config *config)
+struct regmap *devm_regmap_init_mmio_clk(struct device *dev, const char *clk_id,
+					 void __iomem *regs,
+					 const struct regmap_config *config)
 {
 	struct regmap_mmio_context *ctx;
 
-	ctx = regmap_mmio_gen_context(regs, config);
+	ctx = regmap_mmio_gen_context(dev, clk_id, regs, config);
 	if (IS_ERR(ctx))
 		return ERR_CAST(ctx);
 
 	return devm_regmap_init(dev, &regmap_mmio, ctx, config);
 }
-EXPORT_SYMBOL_GPL(devm_regmap_init_mmio);
+EXPORT_SYMBOL_GPL(devm_regmap_init_mmio_clk);
 
 MODULE_LICENSE("GPL v2");
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index b7e95bf..f0480a3 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -285,9 +285,9 @@ struct regmap *regmap_init_i2c(struct i2c_client *i2c,
 			       const struct regmap_config *config);
 struct regmap *regmap_init_spi(struct spi_device *dev,
 			       const struct regmap_config *config);
-struct regmap *regmap_init_mmio(struct device *dev,
-				void __iomem *regs,
-				const struct regmap_config *config);
+struct regmap *regmap_init_mmio_clk(struct device *dev, const char *clk_id,
+				    void __iomem *regs,
+				    const struct regmap_config *config);
 
 struct regmap *devm_regmap_init(struct device *dev,
 				const struct regmap_bus *bus,
@@ -297,9 +297,44 @@ struct regmap *devm_regmap_init_i2c(struct i2c_client *i2c,
 				    const struct regmap_config *config);
 struct regmap *devm_regmap_init_spi(struct spi_device *dev,
 				    const struct regmap_config *config);
-struct regmap *devm_regmap_init_mmio(struct device *dev,
-				     void __iomem *regs,
-				     const struct regmap_config *config);
+struct regmap *devm_regmap_init_mmio_clk(struct device *dev, const char *clk_id,
+					 void __iomem *regs,
+					 const struct regmap_config *config);
+
+/**
+ * regmap_init_mmio(): Initialise register map
+ *
+ * @dev: Device that will be interacted with
+ * @regs: Pointer to memory-mapped IO region
+ * @config: Configuration for register map
+ *
+ * The return value will be an ERR_PTR() on error or a valid pointer to
+ * a struct regmap.
+ */
+static inline struct regmap *regmap_init_mmio(struct device *dev,
+					void __iomem *regs,
+					const struct regmap_config *config)
+{
+	return regmap_init_mmio_clk(dev, NULL, regs, config);
+}
+
+/**
+ * devm_regmap_init_mmio(): Initialise managed register map
+ *
+ * @dev: Device that will be interacted with
+ * @regs: Pointer to memory-mapped IO region
+ * @config: Configuration for register map
+ *
+ * The return value will be an ERR_PTR() on error or a valid pointer
+ * to a struct regmap.  The regmap will be automatically freed by the
+ * device management code.
+ */
+static inline struct regmap *devm_regmap_init_mmio(struct device *dev,
+					void __iomem *regs,
+					const struct regmap_config *config)
+{
+	return devm_regmap_init_mmio_clk(dev, NULL, regs, config);
+}
 
 void regmap_exit(struct regmap *map);
 int regmap_reinit_cache(struct regmap *map,
-- 
1.7.10.4

