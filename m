Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116AbbARURO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 15:17:14 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:32780 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbbARURN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 15:17:13 -0500
Date: Sun, 18 Jan 2015 21:17:10 +0100
From: Pavel Machek <pavel@ucw.cz>
To: edubezval@gmail.com, rui.zhang@intel.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-omap@vger.kernel.org
Subject: [PATCHv2] cleanup ti-soc-thermal
Message-ID: <20150118201710.GA27800@amd>
References: <20150103111904.GA11545@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150103111904.GA11545@amd>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify code by removing goto's where they point to simple return.

Avoid confusing |= on error values.

Correct whitespace.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

---

Please apply,
								Pavel

diff --git a/drivers/thermal/ti-soc-thermal/ti-bandgap.c b/drivers/thermal/ti-soc-thermal/ti-bandgap.c
index 634b6ce..2fde78c 100644
--- a/drivers/thermal/ti-soc-thermal/ti-bandgap.c
+++ b/drivers/thermal/ti-soc-thermal/ti-bandgap.c
@@ -103,19 +105,15 @@ do {								\
  */
 static int ti_bandgap_power(struct ti_bandgap *bgp, bool on)
 {
-	int i, ret = 0;
+	int i;
 
-	if (!TI_BANDGAP_HAS(bgp, POWER_SWITCH)) {
-		ret = -ENOTSUPP;
-		goto exit;
-	}
+	if (!TI_BANDGAP_HAS(bgp, POWER_SWITCH))
+		return -ENOTSUPP;
 
 	for (i = 0; i < bgp->conf->sensor_count; i++)
 		/* active on 0 */
 		RMW_BITS(bgp, i, temp_sensor_ctrl, bgap_tempsoff_mask, !on);
-
-exit:
-	return ret;
+	return 0;
 }
 
 /**
@@ -263,18 +261,13 @@ static
 int ti_bandgap_adc_to_mcelsius(struct ti_bandgap *bgp, int adc_val, int *t)
 {
 	const struct ti_bandgap_data *conf = bgp->conf;
-	int ret = 0;
 
 	/* look up for temperature in the table and return the temperature */
-	if (adc_val < conf->adc_start_val || adc_val > conf->adc_end_val) {
-		ret = -ERANGE;
-		goto exit;
-	}
+	if (adc_val < conf->adc_start_val || adc_val > conf->adc_end_val)
+		return -ERANGE;
 
 	*t = bgp->conf->conv_table[adc_val - conf->adc_start_val];
-
-exit:
-	return ret;
+	return 0;
 }
 
 /**
@@ -295,16 +288,14 @@ int ti_bandgap_mcelsius_to_adc(struct ti_bandgap *bgp, long temp, int *adc)
 {
 	const struct ti_bandgap_data *conf = bgp->conf;
 	const int *conv_table = bgp->conf->conv_table;
-	int high, low, mid, ret = 0;
+	int high, low, mid;
 
 	low = 0;
 	high = conf->adc_end_val - conf->adc_start_val;
 	mid = (high + low) / 2;
 
-	if (temp < conv_table[low] || temp > conv_table[high]) {
-		ret = -ERANGE;
-		goto exit;
-	}
+	if (temp < conv_table[low] || temp > conv_table[high])
+		return -ERANGE;
 
 	while (low < high) {
 		if (temp < conv_table[mid])
@@ -315,9 +306,7 @@ int ti_bandgap_mcelsius_to_adc(struct ti_bandgap *bgp, long temp, int *adc)
 	}
 
 	*adc = conf->adc_start_val + low;
-
-exit:
-	return ret;
+	return 0;
 }
 
 /**
@@ -343,13 +332,11 @@ int ti_bandgap_add_hyst(struct ti_bandgap *bgp, int adc_val, int hyst_val,
 	 */
 	ret = ti_bandgap_adc_to_mcelsius(bgp, adc_val, &temp);
 	if (ret < 0)
-		goto exit;
+		return ret;
 
 	temp += hyst_val;
 
 	ret = ti_bandgap_mcelsius_to_adc(bgp, temp, sum);
-
-exit:
 	return ret;
 }
 
@@ -468,22 +455,18 @@ exit:
  */
 static inline int ti_bandgap_validate(struct ti_bandgap *bgp, int id)
 {
-	int ret = 0;
-
 	if (!bgp || IS_ERR(bgp)) {
 		pr_err("%s: invalid bandgap pointer\n", __func__);
-		ret = -EINVAL;
-		goto exit;
+		return -EINVAL;
 	}
 
 	if ((id < 0) || (id >= bgp->conf->sensor_count)) {
 		dev_err(bgp->dev, "%s: sensor id out of range (%d)\n",
 			__func__, id);
-		ret = -ERANGE;
+		return -ERANGE;
 	}
 
-exit:
-	return ret;
+	return 0;
 }
 
 /**
@@ -511,12 +494,10 @@ static int _ti_bandgap_write_threshold(struct ti_bandgap *bgp, int id, int val,
 
 	ret = ti_bandgap_validate(bgp, id);
 	if (ret)
-		goto exit;
+		return ret;
 
-	if (!TI_BANDGAP_HAS(bgp, TALERT)) {
-		ret = -ENOTSUPP;
-		goto exit;
-	}
+	if (!TI_BANDGAP_HAS(bgp, TALERT))
+		return -ENOTSUPP;
 
 	ts_data = bgp->conf->sensors[id].ts_data;
 	tsr = bgp->conf->sensors[id].registers;
@@ -529,17 +510,15 @@ static int _ti_bandgap_write_threshold(struct ti_bandgap *bgp, int id, int val,
 	}
 
 	if (ret)
-		goto exit;
+		return ret;
 
 	ret = ti_bandgap_mcelsius_to_adc(bgp, val, &adc_val);
 	if (ret < 0)
-		goto exit;
+		return ret;
 
 	spin_lock(&bgp->lock);
 	ret = ti_bandgap_update_alert_threshold(bgp, id, adc_val, hot);
 	spin_unlock(&bgp->lock);
-
-exit:
 	return ret;
 }
 
@@ -582,7 +561,7 @@ static int _ti_bandgap_read_threshold(struct ti_bandgap *bgp, int id,
 
 	temp = ti_bandgap_readl(bgp, tsr->bgap_threshold);
 	temp = (temp & mask) >> __ffs(mask);
-	ret |= ti_bandgap_adc_to_mcelsius(bgp, temp, &temp);
+	ret = ti_bandgap_adc_to_mcelsius(bgp, temp, &temp);
 	if (ret) {
 		dev_err(bgp->dev, "failed to read thot\n");
 		ret = -EIO;
@@ -852,6 +831,6 @@ int ti_bandgap_read_temperature(struct ti_bandgap *bgp, int id,
 	spin_unlock(&bgp->lock);
 
-	ret |= ti_bandgap_adc_to_mcelsius(bgp, temp, &temp);
+	ret = ti_bandgap_adc_to_mcelsius(bgp, temp, &temp);
 	if (ret)
 		return -EIO;
 
@@ -1220,11 +1222,10 @@ int ti_bandgap_probe(struct platform_device *pdev)
 		goto free_irqs;
 	}
 
-	bgp->div_clk = clk_get(NULL,  bgp->conf->div_ck_name);
+	bgp->div_clk = clk_get(NULL, bgp->conf->div_ck_name);
 	ret = IS_ERR(bgp->div_clk);
 	if (ret) {
-		dev_err(&pdev->dev,
-			"failed to request div_ts_ck clock ref\n");
+		dev_err(&pdev->dev, "failed to request div_ts_ck clock ref\n");
 		ret = PTR_ERR(bgp->div_clk);
 		goto free_irqs;
 	}
index 5fd0386..33b2c01 100644
--- a/drivers/thermal/ti-soc-thermal/ti-thermal-common.c
+++ b/drivers/thermal/ti-soc-thermal/ti-thermal-common.c
@@ -76,7 +76,7 @@ static inline int ti_thermal_hotspot_temperature(int t, int s, int c)
 }
 
 /* thermal zone ops */
-/* Get temperature callback function for thermal zone*/
+/* Get temperature callback function for thermal zone */
 static inline int __ti_thermal_get_temp(void *devdata, long *temp)
 {
 	struct thermal_zone_device *pcb_tz = NULL;


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
