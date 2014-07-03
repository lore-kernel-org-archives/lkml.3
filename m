Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757693AbaGCUtk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 16:49:40 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:57236 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431AbaGCUti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 16:49:38 -0400
From: Marek Belisko <marek@goldelico.com>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, tony@atomide.com,
        linux@arm.linux.org.uk, balajitk@ti.com, chris@printf.net,
        ulf.hansson@linaro.org
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mmc@vger.kernel.org, hns@goldelico.com, marek@goldelico.com,
        NeilBrown <neilb@suse.de>
Subject: [PATCH 1/2] mmc: hsmmc: Add reset gpio configuration option.
Date: Thu,  3 Jul 2014 22:49:23 +0200
Message-Id: <1404420564-30245-1-git-send-email-marek@goldelico.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: NeilBrown <neilb@suse.de>

If a 'gpio_reset' is specified, then hold it low while
turning the power regulator on.
This is needed for some wi2wi wireless modules, particularly
when the regulator is held active by some other client.
The wi2wi needs to be reset if power isn't actually removed, and
the gpio can be used to do this.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 arch/arm/mach-omap2/hsmmc.c            |  7 ++++++-
 arch/arm/mach-omap2/hsmmc.h            |  3 +++
 drivers/mmc/host/omap_hsmmc.c          | 26 +++++++++++++++++++++++---
 include/linux/platform_data/mmc-omap.h |  1 +
 4 files changed, 33 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-omap2/hsmmc.c b/arch/arm/mach-omap2/hsmmc.c
index 07d4c7b..046bfdd 100644
--- a/arch/arm/mach-omap2/hsmmc.c
+++ b/arch/arm/mach-omap2/hsmmc.c
@@ -172,6 +172,10 @@ static inline void omap_hsmmc_mux(struct omap_mmc_platform_data *mmc_controller,
 		(mmc_controller->slots[0].gpio_wp < OMAP_MAX_GPIO_LINES))
 		omap_mux_init_gpio(mmc_controller->slots[0].gpio_wp,
 					OMAP_PIN_INPUT_PULLUP);
+	if (gpio_is_valid(mmc_controller->slots[0].gpio_reset) &&
+		(mmc_controller->slots[0].gpio_reset < OMAP_MAX_GPIO_LINES))
+		omap_mux_init_gpio(mmc_controller->slots[0].gpio_reset,
+					OMAP_PIN_OUTPUT);
 	if (cpu_is_omap34xx()) {
 		if (controller_nr == 0) {
 			omap_mux_init_signal("sdmmc1_clk",
@@ -270,6 +274,7 @@ static int __init omap_hsmmc_pdata_init(struct omap2_hsmmc_info *c,
 
 	mmc->slots[0].switch_pin = c->gpio_cd;
 	mmc->slots[0].gpio_wp = c->gpio_wp;
+	mmc->slots[0].gpio_reset = c->gpio_reset;
 
 	mmc->slots[0].remux = c->remux;
 	mmc->slots[0].init_card = c->init_card;
@@ -389,7 +394,7 @@ void omap_hsmmc_late_init(struct omap2_hsmmc_info *c)
 			continue;
 
 		mmc_pdata->slots[0].switch_pin = c->gpio_cd;
-		mmc_pdata->slots[0].gpio_wp = c->gpio_wp;
+		mmc_pdata->slots[0].gpio_reset = c->gpio_reset;
 
 		res = omap_device_register(pdev);
 		if (res)
diff --git a/arch/arm/mach-omap2/hsmmc.h b/arch/arm/mach-omap2/hsmmc.h
index 7f2e790..16b2ac5 100644
--- a/arch/arm/mach-omap2/hsmmc.h
+++ b/arch/arm/mach-omap2/hsmmc.h
@@ -24,6 +24,9 @@ struct omap2_hsmmc_info {
 	bool	deferred;	/* mmc needs a deferred probe */
 	int	gpio_cd;	/* or -EINVAL */
 	int	gpio_wp;	/* or -EINVAL */
+	int	gpio_reset;	/* or -EINVAL - reset is held low during
+				 * power-on
+				 */
 	char	*name;		/* or NULL for default */
 	struct platform_device *pdev;	/* mmc controller instance */
 	int	ocr_mask;	/* temporary HACK */
diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index 9656726..4a264fc 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -300,6 +300,8 @@ static int omap_hsmmc_set_power(struct device *dev, int slot, int power_on,
 	if (!host->vcc)
 		return 0;
 
+	if (gpio_is_valid(mmc_slot(host).gpio_reset))
+		gpio_set_value_cansleep(mmc_slot(host).gpio_reset, 0);
 	if (mmc_slot(host).before_set_reg)
 		mmc_slot(host).before_set_reg(dev, slot, power_on, vdd);
 
@@ -365,6 +367,8 @@ static int omap_hsmmc_set_power(struct device *dev, int slot, int power_on,
 
 	if (mmc_slot(host).after_set_reg)
 		mmc_slot(host).after_set_reg(dev, slot, power_on, vdd);
+	if (gpio_is_valid(mmc_slot(host).gpio_reset))
+		gpio_set_value_cansleep(mmc_slot(host).gpio_reset, 1);
 
 error_set_power:
 	return ret;
@@ -481,10 +485,22 @@ static int omap_hsmmc_gpio_init(struct omap_mmc_platform_data *pdata)
 	} else
 		pdata->slots[0].gpio_wp = -EINVAL;
 
-	return 0;
+	if (gpio_is_valid(pdata->slots[0].gpio_reset)) {
+		ret = gpio_request(pdata->slots[0].gpio_reset, "mmc_reset");
+		if (ret)
+			goto err_free_wp;
+		ret = gpio_direction_output(pdata->slots[0].gpio_reset, 1);
+		if (ret)
+			goto err_free_reset;
+	} else
+		pdata->slots[0].gpio_reset = -EINVAL;
 
+	return 0;
+err_free_reset:
+	gpio_free(pdata->slots[0].gpio_reset);
 err_free_wp:
-	gpio_free(pdata->slots[0].gpio_wp);
+	if (gpio_is_valid(pdata->slots[0].gpio_wp))
+		gpio_free(pdata->slots[0].gpio_wp);
 err_free_cd:
 	if (gpio_is_valid(pdata->slots[0].switch_pin))
 err_free_sp:
@@ -494,6 +510,8 @@ err_free_sp:
 
 static void omap_hsmmc_gpio_free(struct omap_mmc_platform_data *pdata)
 {
+	if (gpio_is_valid(pdata->slots[0].gpio_reset))
+		gpio_free(pdata->slots[0].gpio_reset);
 	if (gpio_is_valid(pdata->slots[0].gpio_wp))
 		gpio_free(pdata->slots[0].gpio_wp);
 	if (gpio_is_valid(pdata->slots[0].switch_pin))
@@ -1952,10 +1970,11 @@ static struct omap_mmc_platform_data *of_get_hsmmc_pdata(struct device *dev)
 	struct omap_mmc_platform_data *pdata;
 	struct device_node *np = dev->of_node;
 	u32 bus_width, max_freq;
-	int cd_gpio, wp_gpio;
+	int cd_gpio, wp_gpio, reset_gpio;
 
 	cd_gpio = of_get_named_gpio(np, "cd-gpios", 0);
 	wp_gpio = of_get_named_gpio(np, "wp-gpios", 0);
+	reset_gpio = of_get_named_gpio(np, "reset-gpios", 0);
 	if (cd_gpio == -EPROBE_DEFER || wp_gpio == -EPROBE_DEFER)
 		return ERR_PTR(-EPROBE_DEFER);
 
@@ -1970,6 +1989,7 @@ static struct omap_mmc_platform_data *of_get_hsmmc_pdata(struct device *dev)
 	pdata->nr_slots = 1;
 	pdata->slots[0].switch_pin = cd_gpio;
 	pdata->slots[0].gpio_wp = wp_gpio;
+	pdata->slots[0].gpio_reset = reset_gpio;
 
 	if (of_find_property(np, "ti,non-removable", NULL)) {
 		pdata->slots[0].nonremovable = true;
diff --git a/include/linux/platform_data/mmc-omap.h b/include/linux/platform_data/mmc-omap.h
index 51e70cf..8f3ee4a 100644
--- a/include/linux/platform_data/mmc-omap.h
+++ b/include/linux/platform_data/mmc-omap.h
@@ -116,6 +116,7 @@ struct omap_mmc_platform_data {
 
 		int switch_pin;			/* gpio (card detect) */
 		int gpio_wp;			/* gpio (write protect) */
+		int gpio_reset;			/* gpio (reset) */
 
 		int (*set_bus_mode)(struct device *dev, int slot, int bus_mode);
 		int (*set_power)(struct device *dev, int slot,
-- 
1.9.1

