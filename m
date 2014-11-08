Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374AbaKHAPR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 19:15:17 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59959 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753083AbaKHAPM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 19:15:12 -0500
From: NeilBrown <neilb@suse.de>
To: Ulf Hansson <ulf.hansson@linaro.org>, Chris Ball <chris@printf.net>
Date: Sat, 08 Nov 2014 11:14:11 +1100
Subject: [PATCH 1/2] mmc: core: allow a reset gpio to be configured.
Cc: devicetree@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, GTA04 owners <gta04-owner@goldelico.com>
Message-ID: <20141108001411.5629.25179.stgit@notabene.brown>
In-Reply-To: <20141108000919.5629.55381.stgit@notabene.brown>
References: <20141108000919.5629.55381.stgit@notabene.brown>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the regulator supplying an SDIO device is shared
with another device, the turning the regulator 'on' and 'off'
will not actually cycle power and so will not reset
the device.

This is particularly a problem for some wi2si wireless modules which
have a BT module on chip and can share power lines.
Without the power-cycle, subsequent reset commands fail.

So allow a 'reset' gpio to be specified.  If provided, the
line is asserted during power-up.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 Documentation/devicetree/bindings/mmc/mmc.txt |    3 +
 drivers/mmc/core/core.c                       |    3 +
 drivers/mmc/core/host.c                       |   12 ++++
 drivers/mmc/core/slot-gpio.c                  |   70 +++++++++++++++++++++++++
 include/linux/mmc/slot-gpio.h                 |    4 +
 5 files changed, 91 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/mmc/mmc.txt b/Documentation/devicetree/bindings/mmc/mmc.txt
index 431716e37a39..06b84b3bb3ee 100644
--- a/Documentation/devicetree/bindings/mmc/mmc.txt
+++ b/Documentation/devicetree/bindings/mmc/mmc.txt
@@ -21,6 +21,9 @@ Optional properties:
   below for the case, when a GPIO is used for the CD line
 - wp-inverted: when present, polarity on the WP line is inverted. See the note
   below for the case, when a GPIO is used for the WP line
+- reset-gpios: Specify a GPIO to be asserted during power-up. This is
+  useful is power is not actually removed (e.g. due to shared
+  regulator) but a reset is needed before reconfiguration.
 - max-frequency: maximum operating clock frequency
 - no-1-8-v: when present, denotes that 1.8v card voltage is not supported on
   this system, even if the controller claims it is.
diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index d03a080fb9cd..64572c44f9b5 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -1533,6 +1533,8 @@ void mmc_power_up(struct mmc_host *host, u32 ocr)
 
 	mmc_host_clk_hold(host);
 
+	/* Reset during power-off */
+	mmc_gpio_set_rs(host, 1);
 	host->ios.vdd = fls(ocr) - 1;
 	if (mmc_host_is_spi(host))
 		host->ios.chip_select = MMC_CS_HIGH;
@@ -1568,6 +1570,7 @@ void mmc_power_up(struct mmc_host *host, u32 ocr)
 	 * time required to reach a stable voltage.
 	 */
 	mmc_delay(10);
+	mmc_gpio_set_rs(host, 0);
 
 	mmc_host_clk_release(host);
 }
diff --git a/drivers/mmc/core/host.c b/drivers/mmc/core/host.c
index 95cceae96944..42dbf7a521d4 100644
--- a/drivers/mmc/core/host.c
+++ b/drivers/mmc/core/host.c
@@ -415,6 +415,18 @@ int mmc_of_parse(struct mmc_host *host)
 	if (explicit_inv_wp ^ gpio_inv_wp)
 		host->caps2 |= MMC_CAP2_RO_ACTIVE_HIGH;
 
+	gpio = of_get_named_gpio_flags(np, "reset-gpios", 0, &flags);
+	if (gpio == -EPROBE_DEFER) {
+		ret = -EPROBE_DEFER;
+		goto out;
+	}
+	if (gpio_is_valid(gpio)) {
+		ret = mmc_gpio_request_rs(host, gpio,
+					  flags & OF_GPIO_ACTIVE_LOW);
+		if (ret < 0)
+			goto out;
+	}
+
 	if (of_find_property(np, "cap-sd-highspeed", &len))
 		host->caps |= MMC_CAP_SD_HIGHSPEED;
 	if (of_find_property(np, "cap-mmc-highspeed", &len))
diff --git a/drivers/mmc/core/slot-gpio.c b/drivers/mmc/core/slot-gpio.c
index f3bc51f9aba9..354034a8519f 100644
--- a/drivers/mmc/core/slot-gpio.c
+++ b/drivers/mmc/core/slot-gpio.c
@@ -21,10 +21,12 @@
 struct mmc_gpio {
 	struct gpio_desc *ro_gpio;
 	struct gpio_desc *cd_gpio;
+	struct gpio_desc *rs_gpio; /* reset line */
 	bool override_ro_active_level;
 	bool override_cd_active_level;
 	irqreturn_t (*cd_gpio_isr)(int irq, void *dev_id);
 	char *ro_label;
+	char *rs_label;
 	char cd_label[0];
 };
 
@@ -53,12 +55,14 @@ static int mmc_gpio_alloc(struct mmc_host *host)
 		 * before device_add(), i.e., between mmc_alloc_host() and
 		 * mmc_add_host()
 		 */
-		ctx = devm_kzalloc(&host->class_dev, sizeof(*ctx) + 2 * len,
+		ctx = devm_kzalloc(&host->class_dev, sizeof(*ctx) + 3 * len,
 				   GFP_KERNEL);
 		if (ctx) {
 			ctx->ro_label = ctx->cd_label + len;
+			ctx->rs_label = ctx->ro_label + len;
 			snprintf(ctx->cd_label, len, "%s cd", dev_name(host->parent));
 			snprintf(ctx->ro_label, len, "%s ro", dev_name(host->parent));
+			snprintf(ctx->rs_label, len, "%s rs", dev_name(host->parent));
 			host->slot.handler_priv = ctx;
 		}
 	}
@@ -98,6 +102,18 @@ int mmc_gpio_get_cd(struct mmc_host *host)
 }
 EXPORT_SYMBOL(mmc_gpio_get_cd);
 
+void mmc_gpio_set_rs(struct mmc_host *host, int state)
+{
+	struct mmc_gpio *ctx = host->slot.handler_priv;
+
+	if (!ctx || !ctx->rs_gpio)
+		return;
+
+	gpiod_set_value_cansleep(ctx->rs_gpio, state);
+}
+EXPORT_SYMBOL(mmc_gpio_set_rs);
+
+
 /**
  * mmc_gpio_request_ro - request a gpio for write-protection
  * @host: mmc host
@@ -138,6 +154,36 @@ int mmc_gpio_request_ro(struct mmc_host *host, unsigned int gpio)
 }
 EXPORT_SYMBOL(mmc_gpio_request_ro);
 
+int mmc_gpio_request_rs(struct mmc_host *host, unsigned int gpio, int low)
+{
+	struct mmc_gpio *ctx;
+	int ret;
+	int flags;
+
+	if (!gpio_is_valid(gpio))
+		return -EINVAL;
+
+	ret = mmc_gpio_alloc(host);
+	if (ret < 0)
+		return ret;
+
+	ctx = host->slot.handler_priv;
+	if (low)
+		flags = GPIOF_DIR_OUT | GPIOF_INIT_HIGH | GPIOF_ACTIVE_LOW;
+	else
+		flags = GPIOF_DIR_OUT | GPIOF_INIT_LOW;
+
+	ret = devm_gpio_request_one(&host->class_dev, gpio,
+				    flags, ctx->rs_label);
+	if (ret < 0)
+		return ret;
+
+	ctx->rs_gpio = gpio_to_desc(gpio);
+
+	return 0;
+}
+EXPORT_SYMBOL(mmc_gpio_request_rs);
+
 void mmc_gpiod_request_cd_irq(struct mmc_host *host)
 {
 	struct mmc_gpio *ctx = host->slot.handler_priv;
@@ -269,6 +315,28 @@ void mmc_gpio_free_ro(struct mmc_host *host)
 EXPORT_SYMBOL(mmc_gpio_free_ro);
 
 /**
+ * mmc_gpio_free_rs - free the reset gpio
+ * @host: mmc host
+ *
+ * It's provided only for cases that client drivers need to manually free
+ * up the write-protection gpio requested by mmc_gpio_request_rs().
+ */
+void mmc_gpio_free_rs(struct mmc_host *host)
+{
+	struct mmc_gpio *ctx = host->slot.handler_priv;
+	int gpio;
+
+	if (!ctx || !ctx->rs_gpio)
+		return;
+
+	gpio = desc_to_gpio(ctx->rs_gpio);
+	ctx->rs_gpio = NULL;
+
+	devm_gpio_free(&host->class_dev, gpio);
+}
+EXPORT_SYMBOL(mmc_gpio_free_rs);
+
+/**
  * mmc_gpio_free_cd - free the card-detection gpio
  * @host: mmc host
  *
diff --git a/include/linux/mmc/slot-gpio.h b/include/linux/mmc/slot-gpio.h
index a119892cebdb..630e39af2035 100644
--- a/include/linux/mmc/slot-gpio.h
+++ b/include/linux/mmc/slot-gpio.h
@@ -22,6 +22,10 @@ int mmc_gpio_request_cd(struct mmc_host *host, unsigned int gpio,
 			unsigned int debounce);
 void mmc_gpio_free_cd(struct mmc_host *host);
 
+void mmc_gpio_set_rs(struct mmc_host *host, int state);
+int mmc_gpio_request_rs(struct mmc_host *host, unsigned int gpio, int inv);
+void mmc_gpio_free_rs(struct mmc_host *host);
+
 int mmc_gpiod_request_cd(struct mmc_host *host, const char *con_id,
 			 unsigned int idx, bool override_active_level,
 			 unsigned int debounce);


