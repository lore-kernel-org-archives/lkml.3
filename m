Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757141Ab3BNJtW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 04:49:22 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42041 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757062Ab3BNJtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 04:49:19 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [RFC PATCH] regmap: mmio: add register clock support
Date: Thu, 14 Feb 2013 10:49:14 +0100
Message-Id: <1360835354-31740-1-git-send-email-p.zabel@pengutronix.de>
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
 drivers/base/regmap/regmap-mmio.c |   88 +++++++++++++++++++++++++++++++++++--
 include/linux/regmap.h            |    6 +++
 2 files changed, 91 insertions(+), 3 deletions(-)

diff --git a/drivers/base/regmap/regmap-mmio.c b/drivers/base/regmap/regmap-mmio.c
index f05fc74..388dbaa 100644
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
@@ -37,6 +39,9 @@ static int regmap_mmio_gather_write(void *context,
 
 	BUG_ON(reg_size != 4);
 
+	if (ctx->clk)
+		clk_prepare_enable(ctx->clk);
+
 	offset = *(u32 *)reg;
 
 	while (val_size) {
@@ -64,6 +69,9 @@ static int regmap_mmio_gather_write(void *context,
 		offset += ctx->val_bytes;
 	}
 
+	if (ctx->clk)
+		clk_disable_unprepare(ctx->clk);
+
 	return 0;
 }
 
@@ -83,6 +91,9 @@ static int regmap_mmio_read(void *context,
 
 	BUG_ON(reg_size != 4);
 
+	if (ctx->clk)
+		clk_prepare_enable(ctx->clk);
+
 	offset = *(u32 *)reg;
 
 	while (val_size) {
@@ -110,11 +121,18 @@ static int regmap_mmio_read(void *context,
 		offset += ctx->val_bytes;
 	}
 
+	if (ctx->clk)
+		clk_disable_unprepare(ctx->clk);
+
 	return 0;
 }
 
 static void regmap_mmio_free_context(void *context)
 {
+	struct regmap_mmio_context *ctx = context;
+
+	if (ctx->clk)
+		clk_put(ctx->clk);
 	kfree(context);
 }
 
@@ -128,10 +146,13 @@ static struct regmap_bus regmap_mmio = {
 	.val_format_endian_default = REGMAP_ENDIAN_NATIVE,
 };
 
-static struct regmap_mmio_context *regmap_mmio_gen_context(void __iomem *regs,
+static struct regmap_mmio_context *regmap_mmio_gen_context(struct device *dev,
+					const char *clk_id,
+					void __iomem *regs,
 					const struct regmap_config *config)
 {
 	struct regmap_mmio_context *ctx;
+	struct clk *clk;
 	int min_stride;
 
 	if (config->reg_bits != 32)
@@ -179,6 +200,16 @@ static struct regmap_mmio_context *regmap_mmio_gen_context(void __iomem *regs,
 	ctx->regs = regs;
 	ctx->val_bytes = config->val_bits / 8;
 
+	if (clk_id == NULL)
+		return ctx;
+
+	clk = clk_get(dev, clk_id);
+	if (IS_ERR(clk)) {
+		kfree(ctx);
+		return ERR_PTR(PTR_ERR(clk));
+	}
+	ctx->clk = clk;
+
 	return ctx;
 }
 
@@ -198,7 +229,7 @@ struct regmap *regmap_init_mmio(struct device *dev,
 {
 	struct regmap_mmio_context *ctx;
 
-	ctx = regmap_mmio_gen_context(regs, config);
+	ctx = regmap_mmio_gen_context(dev, NULL, regs, config);
 	if (IS_ERR(ctx))
 		return ERR_CAST(ctx);
 
@@ -207,6 +238,31 @@ struct regmap *regmap_init_mmio(struct device *dev,
 EXPORT_SYMBOL_GPL(regmap_init_mmio);
 
 /**
+ * regmap_init_mmio_clk(): Initialise register map with register clock
+ *
+ * @dev: Device that will be interacted with
+ * @clk_id: register clock consumer ID
+ * @regs: Pointer to memory-mapped IO region
+ * @config: Configuration for register map
+ *
+ * The return value will be an ERR_PTR() on error or a valid pointer to
+ * a struct regmap.
+ */
+struct regmap *regmap_init_mmio_clk(struct device *dev, const char *clk_id,
+				    void __iomem *regs,
+				    const struct regmap_config *config)
+{
+	struct regmap_mmio_context *ctx;
+
+	ctx = regmap_mmio_gen_context(dev, clk_id, regs, config);
+	if (IS_ERR(ctx))
+		return ERR_CAST(ctx);
+
+	return regmap_init(dev, &regmap_mmio, ctx, config);
+}
+EXPORT_SYMBOL_GPL(regmap_init_mmio_clk);
+
+/**
  * devm_regmap_init_mmio(): Initialise managed register map
  *
  * @dev: Device that will be interacted with
@@ -223,7 +279,7 @@ struct regmap *devm_regmap_init_mmio(struct device *dev,
 {
 	struct regmap_mmio_context *ctx;
 
-	ctx = regmap_mmio_gen_context(regs, config);
+	ctx = regmap_mmio_gen_context(dev, NULL, regs, config);
 	if (IS_ERR(ctx))
 		return ERR_CAST(ctx);
 
@@ -231,4 +287,30 @@ struct regmap *devm_regmap_init_mmio(struct device *dev,
 }
 EXPORT_SYMBOL_GPL(devm_regmap_init_mmio);
 
+/**
+ * devm_regmap_init_mmio_clk(): Initialise managed register map with clock
+ *
+ * @dev: Device that will be interacted with
+ * @clk_id: register clock consumer ID
+ * @regs: Pointer to memory-mapped IO region
+ * @config: Configuration for register map
+ *
+ * The return value will be an ERR_PTR() on error or a valid pointer
+ * to a struct regmap.  The regmap will be automatically freed by the
+ * device management code.
+ */
+struct regmap *devm_regmap_init_mmio_clk(struct device *dev, const char *clk_id,
+					 void __iomem *regs,
+					 const struct regmap_config *config)
+{
+	struct regmap_mmio_context *ctx;
+
+	ctx = regmap_mmio_gen_context(dev, clk_id, regs, config);
+	if (IS_ERR(ctx))
+		return ERR_CAST(ctx);
+
+	return devm_regmap_init(dev, &regmap_mmio, ctx, config);
+}
+EXPORT_SYMBOL_GPL(devm_regmap_init_mmio_clk);
+
 MODULE_LICENSE("GPL v2");
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index b7e95bf..5850848 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -288,6 +288,9 @@ struct regmap *regmap_init_spi(struct spi_device *dev,
 struct regmap *regmap_init_mmio(struct device *dev,
 				void __iomem *regs,
 				const struct regmap_config *config);
+struct regmap *regmap_init_mmio_clk(struct device *dev, const char *clk_id,
+				    void __iomem *regs,
+				    const struct regmap_config *config);
 
 struct regmap *devm_regmap_init(struct device *dev,
 				const struct regmap_bus *bus,
@@ -300,6 +303,9 @@ struct regmap *devm_regmap_init_spi(struct spi_device *dev,
 struct regmap *devm_regmap_init_mmio(struct device *dev,
 				     void __iomem *regs,
 				     const struct regmap_config *config);
+struct regmap *devm_regmap_init_mmio_clk(struct device *dev, const char *clk_id,
+					 void __iomem *regs,
+					 const struct regmap_config *config);
 
 void regmap_exit(struct regmap *map);
 int regmap_reinit_cache(struct regmap *map,
-- 
1.7.10.4

