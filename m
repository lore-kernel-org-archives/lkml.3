Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860AbaJPWGT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 18:06:19 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:52371 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951AbaJPWGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 18:06:16 -0400
Date: Thu, 16 Oct 2014 15:06:11 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Caesar Wang <caesar.wang@rock-chips.com>
Cc: heiko@sntech.de, rui.zhang@intel.com, edubezval@gmail.com,
        zyf@rock-chips.com, dianders@chromium.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        cf@rock-chips.com, dbasehore@chromium.org, huangtao@rock-chips.com,
        cjf@rock-chips.com, zhengsq@rock-chips.com,
        vladimir_zapolskiy@mentor.com
Subject: Re: [PATCH v11 1/5] thermal: rockchip: add driver for thermal
Message-ID: <20141016220611.GB30009@dtor-ws>
References: <1413466301-25952-1-git-send-email-caesar.wang@rock-chips.com>
 <1413466301-25952-2-git-send-email-caesar.wang@rock-chips.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413466301-25952-2-git-send-email-caesar.wang@rock-chips.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Caesar,

On Thu, Oct 16, 2014 at 09:31:37PM +0800, Caesar Wang wrote:
> +
> +struct rockchip_tsadc_platform_data {
> +	unsigned long temp_passive;
> +	unsigned long hw_shut_temp;
> +	int reset_mode;
> +
> +	void (*irq_handle)(void __iomem *reg);
> +	void (*initialize)(int reset_mode, int chn, void __iomem *reg,
> +			   unsigned long hw_shut_temp);
> +	int (*control)(void __iomem *reg, bool on, int chn);
> +	int (*code_to_temp)(u32 code);
> +	u32 (*temp_to_code)(int temp);
> +	void (*set_alarm_temp)(int chn, void __iomem *reg,
> +			       unsigned long alarm_temp);
> +};

Any time I see platform data and pdata I think about board-specific
parameters that come either from board initialization code, device tree
or ACPI, rather than chipset specific data. Do you think we could rename
rockchip_tsadc_platform_data  to rockchip_tsadc_chip? If you agree
please fold the patch below into your next revision.

More to come...

Thanks.

-- 
Dmitry

rockchip-thermal - rename rockchip_tsadc_platform_data

Signed-off-by: Dmitry Torokhov <dtor@chromium.org>
---
 drivers/thermal/rockchip_thermal.c | 66 ++++++++++++++++++++------------------
 1 file changed, 35 insertions(+), 31 deletions(-)

diff --git a/drivers/thermal/rockchip_thermal.c b/drivers/thermal/rockchip_thermal.c
index 4ecc649..6d7472b 100644
--- a/drivers/thermal/rockchip_thermal.c
+++ b/drivers/thermal/rockchip_thermal.c
@@ -44,8 +44,24 @@ enum sensor_id {
 	SENSOR_ID_END,
 };
 
+struct rockchip_tsadc_chip {
+	unsigned long temp_passive;
+	unsigned long hw_shut_temp;
+	enum reset_mode reset_mode;
+
+	void (*irq_handle)(void __iomem *reg);
+	void (*initialize)(enum reset_mode reset_mode, int chn,
+			   void __iomem *reg,
+			   unsigned long hw_shut_temp);
+	int (*control)(void __iomem *reg, bool on, int chn);
+	int (*code_to_temp)(u32 code);
+	u32 (*temp_to_code)(int temp);
+	void (*set_alarm_temp)(int chn, void __iomem *reg,
+			       unsigned long alarm_temp);
+};
+
 struct rockchip_thermal_data {
-	const struct rockchip_tsadc_platform_data *pdata;
+	const struct rockchip_tsadc_chip *chip;
 	struct thermal_zone_device *tz[SENSOR_ID_END];
 	struct thermal_cooling_device *cdev;
 	void __iomem *regs;
@@ -62,21 +78,6 @@ struct rockchip_thermal_data {
 	struct clk *pclk;
 };
 
-struct rockchip_tsadc_platform_data {
-	unsigned long temp_passive;
-	unsigned long hw_shut_temp;
-	int reset_mode;
-
-	void (*irq_handle)(void __iomem *reg);
-	void (*initialize)(int reset_mode, int chn, void __iomem *reg,
-			   unsigned long hw_shut_temp);
-	int (*control)(void __iomem *reg, bool on, int chn);
-	int (*code_to_temp)(u32 code);
-	u32 (*temp_to_code)(int temp);
-	void (*set_alarm_temp)(int chn, void __iomem *reg,
-			       unsigned long alarm_temp);
-};
-
 /* TSADC V2 Sensor info define: */
 #define TSADCV2_AUTO_CON			0x04
 #define TSADCV2_INT_EN				0x08
@@ -234,7 +235,8 @@ static bool rk_tsadcv2_get_tshut_polarity_high(void __iomem *regs)
  * the channel, and you can set TSHUT output to gpio to reset the whole chip,
  * and you can set TSHUT output to cru to reset the whole chip.
  */
-static void rk_tsadcv2_initialize(int reset_mode, int chn, void __iomem *regs,
+static void rk_tsadcv2_initialize(enum reset_mode reset_mode, int chn,
+				  void __iomem *regs,
 				  unsigned long hw_shut_temp)
 {
 	u32 shutdown_value;
@@ -279,7 +281,7 @@ static void rk_tsadcv2_alarm_temp(int chn, void __iomem *regs,
 		       TSADCV2_COMP_INT(chn));
 }
 
-static const struct rockchip_tsadc_platform_data rk3288_tsadc_data = {
+static const struct rockchip_tsadc_chip rk3288_tsadc_data = {
 	.reset_mode = GPIO, /* default TSHUT via GPIO give PMIC */
 	.temp_passive = 80000,
 	.hw_shut_temp = 120000,
@@ -303,7 +305,7 @@ MODULE_DEVICE_TABLE(of, of_rockchip_thermal_match);
 static void rockchip_set_alarm_temp(struct rockchip_thermal_data *data,
 				    int alarm_temp, int chn)
 {
-	const struct rockchip_tsadc_platform_data *tsadc = data->pdata;
+	const struct rockchip_tsadc_chip *tsadc = data->chip;
 
 	data->alarm_temp = alarm_temp;
 
@@ -352,7 +354,7 @@ static void rockchip_thermal_initialize(struct rockchip_thermal_data *data)
 static void rockchip_thermal_control(struct rockchip_thermal_data *data,
 				     bool on, int chn)
 {
-	const struct rockchip_tsadc_platform_data *tsadc = data->pdata;
+	const struct rockchip_tsadc_chip *tsadc = data->chip;
 
 	if (tsadc->control)
 		tsadc->control(data->regs, on, chn);
@@ -372,7 +374,7 @@ static void rockchip_thermal_control(struct rockchip_thermal_data *data,
 static irqreturn_t rockchip_thermal_alarm_irq_thread(int irq, void *dev)
 {
 	struct rockchip_thermal_data *data = dev;
-	const struct rockchip_tsadc_platform_data *tsadc = data->pdata;
+	const struct rockchip_tsadc_chip *tsadc = data->chip;
 	int chn;
 
 	tsadc->irq_handle(data->regs);
@@ -386,7 +388,7 @@ static irqreturn_t rockchip_thermal_alarm_irq_thread(int irq, void *dev)
 static int rockchip_thermal_set_trips(void *zone, long low, long high)
 {
 	struct rockchip_thermal_data *data = zone;
-	const struct rockchip_tsadc_platform_data *tsadc = data->pdata;
+	const struct rockchip_tsadc_chip *tsadc = data->chip;
 
 	low = clamp_val(low, LONG_MIN, LONG_MAX);
 	high = clamp_val(high, LONG_MIN, LONG_MAX);
@@ -407,7 +409,7 @@ static int rockchip_thermal_set_trips(void *zone, long low, long high)
 static int rockchip_thermal_get_cpu_temp(void *zone, long *out_temp)
 {
 	struct rockchip_thermal_data *data = zone;
-	const struct rockchip_tsadc_platform_data *tsadc = data->pdata;
+	const struct rockchip_tsadc_chip *tsadc = data->chip;
 	u32 val;
 
 	/* the A/D value of the channel last conversion need some time */
@@ -423,7 +425,7 @@ static int rockchip_thermal_get_cpu_temp(void *zone, long *out_temp)
 static int rockchip_thermal_get_gpu_temp(void *zone, long *out_temp)
 {
 	struct rockchip_thermal_data *data = zone;
-	const struct rockchip_tsadc_platform_data *tsadc = data->pdata;
+	const struct rockchip_tsadc_chip *tsadc = data->chip;
 	u32 val;
 
 	/* the A/D value of the channel last conversion need some time */
@@ -444,19 +446,19 @@ static int rockchip_configure_from_dt(struct device *dev,
 
 	if (of_property_read_u32(np, "hw-shut-temp", &shut_temp)) {
 		dev_warn(dev, "Missing default shutdown temp property\n");
-		data->hw_shut_temp = data->pdata->hw_shut_temp;
+		data->hw_shut_temp = data->chip->hw_shut_temp;
 	} else {
 		data->hw_shut_temp = shut_temp;
 	}
 
 	if (of_property_read_u32(np, "tsadc-ht-reset-mode", &reset_mode)) {
 		dev_warn(dev, "Missing default reset mode property\n");
-		data->reset_mode = data->pdata->reset_mode;
+		data->reset_mode = data->chip->reset_mode;
 	} else {
 		data->reset_mode = reset_mode;
 	}
 
-	data->temp_passive = data->pdata->temp_passive;
+	data->temp_passive = data->chip->temp_passive;
 
 	return 0;
 }
@@ -464,7 +466,7 @@ static int rockchip_configure_from_dt(struct device *dev,
 static int rockchip_thermal_probe(struct platform_device *pdev)
 {
 	struct rockchip_thermal_data *data;
-	const struct rockchip_tsadc_platform_data *tsadc;
+	const struct rockchip_tsadc_chip *tsadc;
 	const struct of_device_id *match;
 
 	struct cpumask clip_cpus;
@@ -489,10 +491,12 @@ static int rockchip_thermal_probe(struct platform_device *pdev)
 	match = of_match_node(of_rockchip_thermal_match, np);
 	if (!match)
 		return -ENXIO;
-	data->pdata = (const struct rockchip_tsadc_platform_data *)match->data;
-	if (!data->pdata)
+
+	tsadc = (const struct rockchip_tsadc_chip *)match->data;
+	if (!tsadc)
 		return -EINVAL;
-	tsadc = data->pdata;
+
+	data->chip = tsadc;
 
 	data->clk = devm_clk_get(&pdev->dev, "tsadc");
 	if (IS_ERR(data->clk)) {
-- 
1.8.3.2

