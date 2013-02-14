Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964875Ab3BNMip (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 07:38:45 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50422 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759579Ab3BNMio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 07:38:44 -0500
Message-ID: <1360845523.22360.13.camel@pizza.hi.pengutronix.de>
Subject: Re: [RFC PATCH] regmap: mmio: add register clock support
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
Date: Thu, 14 Feb 2013 13:38:43 +0100
In-Reply-To: <20130214115621.GE13249@opensource.wolfsonmicro.com>
References: <1360835354-31740-1-git-send-email-p.zabel@pengutronix.de>
	 <20130214115621.GE13249@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:ca9c:dcff:febd:f1b5
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

Am Donnerstag, den 14.02.2013, 11:56 +0000 schrieb Mark Brown:
> On Thu, Feb 14, 2013 at 10:49:14AM +0100, Philipp Zabel wrote:
> 
> > Some mmio devices have a dedicated interface clock that needs
> > to be enabled to access their registers. This patch optionally
> > enables a clock before accessing registers in the regmap_bus
> > callbacks.
> 
> This is a good feature but a couple of concerns here.
> 
> > +	if (ctx->clk)
> > +		clk_prepare_enable(ctx->clk);
> > +
> 
> This is only going to work if prepare doesn't sleep.  That's probably
> fine for the use cases we're interested in but doesn't fill me with joy.

Good point. I moved clk_prepare/unprepare into
regmap_mmio_gen_context/free_context.

> The other thing is that we ought to check the return value.

Done.

Are you ok with the way (devm_)regmap_mmio_init_clk are added?
Maybe (devm_)regmap_mmio_init should be turned into inlines.

thanks
Philipp

From: Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH] regmap: mmio: add register clock support

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
 drivers/base/regmap/regmap-mmio.c |  108 +++++++++++++++++++++++++++++++++++--
 include/linux/regmap.h            |    6 +++
 2 files changed, 111 insertions(+), 3 deletions(-)

diff --git a/drivers/base/regmap/regmap-mmio.c b/drivers/base/regmap/regmap-mmio.c
index f05fc74..8ccac3f 100644
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
@@ -179,7 +210,27 @@ static struct regmap_mmio_context *regmap_mmio_gen_context(void __iomem *regs,
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
@@ -198,7 +249,7 @@ struct regmap *regmap_init_mmio(struct device *dev,
 {
 	struct regmap_mmio_context *ctx;
 
-	ctx = regmap_mmio_gen_context(regs, config);
+	ctx = regmap_mmio_gen_context(dev, NULL, regs, config);
 	if (IS_ERR(ctx))
 		return ERR_CAST(ctx);
 
@@ -207,6 +258,31 @@ struct regmap *regmap_init_mmio(struct device *dev,
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
@@ -223,7 +299,7 @@ struct regmap *devm_regmap_init_mmio(struct device *dev,
 {
 	struct regmap_mmio_context *ctx;
 
-	ctx = regmap_mmio_gen_context(regs, config);
+	ctx = regmap_mmio_gen_context(dev, NULL, regs, config);
 	if (IS_ERR(ctx))
 		return ERR_CAST(ctx);
 
@@ -231,4 +307,30 @@ struct regmap *devm_regmap_init_mmio(struct device *dev,
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


