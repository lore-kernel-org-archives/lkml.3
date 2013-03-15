Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755005Ab3CONKs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 09:10:48 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:60138 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754833Ab3CONKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 09:10:45 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH 26/50] staging: omap-thermal: move conv table limits out of sensor data
Date: Fri, 15 Mar 2013 09:00:14 -0400
Message-ID: <1363352438-15935-27-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.7.7.1.488.ge8e1c
In-Reply-To: <1363352438-15935-1-git-send-email-eduardo.valentin@ti.com>
References: <1363352438-15935-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As we have one conv table per bandgap device and not per sensor,
this patch changes the data structures so that the conv table
min and max values are now part of bandgap_data and not sensor_data.

Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/staging/omap-thermal/omap-bandgap.c       |   39 +++++++++-----------
 drivers/staging/omap-thermal/omap-bandgap.h       |    8 ++--
 drivers/staging/omap-thermal/omap4-thermal-data.c |   10 +++--
 drivers/staging/omap-thermal/omap5-thermal-data.c |    8 +---
 4 files changed, 30 insertions(+), 35 deletions(-)

diff --git a/drivers/staging/omap-thermal/omap-bandgap.c b/drivers/staging/omap-thermal/omap-bandgap.c
index e49a115..963fcaf 100644
--- a/drivers/staging/omap-thermal/omap-bandgap.c
+++ b/drivers/staging/omap-thermal/omap-bandgap.c
@@ -236,7 +236,6 @@ static irqreturn_t omap_bandgap_tshut_irq_handler(int irq, void *data)
 /**
  * omap_bandgap_adc_to_mcelsius() - converts an ADC value to mCelsius scale
  * @bg_ptr: struct omap_bandgap pointer
- * @id: sensor id
  * @adc_val: value in ADC representation
  * @t: address where to write the resulting temperature in mCelsius
  *
@@ -245,35 +244,34 @@ static irqreturn_t omap_bandgap_tshut_irq_handler(int irq, void *data)
  * The conversion table is indexed by the ADC values.
  */
 static
-int omap_bandgap_adc_to_mcelsius(struct omap_bandgap *bg_ptr, int id,
+int omap_bandgap_adc_to_mcelsius(struct omap_bandgap *bg_ptr,
 				 int adc_val, int *t)
 {
-	struct temp_sensor_data *ts_data = bg_ptr->conf->sensors[id].ts_data;
+	struct omap_bandgap_data *conf = bg_ptr->conf;
 	int ret = 0;
 
 	/* look up for temperature in the table and return the temperature */
-	if (adc_val < ts_data->adc_start_val ||
-	    adc_val > ts_data->adc_end_val) {
+	if (adc_val < conf->adc_start_val || adc_val > conf->adc_end_val) {
 		ret = -ERANGE;
 		goto exit;
 	}
 
-	*t = bg_ptr->conf->conv_table[adc_val - ts_data->adc_start_val];
+	*t = bg_ptr->conf->conv_table[adc_val - conf->adc_start_val];
 
 exit:
 	return ret;
 }
 
 static
-int omap_bandgap_mcelsius_to_adc(struct omap_bandgap *bg_ptr, int i, long temp,
+int omap_bandgap_mcelsius_to_adc(struct omap_bandgap *bg_ptr, long temp,
 				 int *adc)
 {
-	struct temp_sensor_data *ts_data = bg_ptr->conf->sensors[i].ts_data;
+	struct omap_bandgap_data *conf = bg_ptr->conf;
 	const int *conv_table = bg_ptr->conf->conv_table;
 	int high, low, mid, ret = 0;
 
 	low = 0;
-	high = ts_data->adc_end_val - ts_data->adc_start_val;
+	high = conf->adc_end_val - conf->adc_start_val;
 	mid = (high + low) / 2;
 
 	if (temp < conv_table[low] || temp > conv_table[high]) {
@@ -289,7 +287,7 @@ int omap_bandgap_mcelsius_to_adc(struct omap_bandgap *bg_ptr, int i, long temp,
 		mid = (low + high) / 2;
 	}
 
-	*adc = ts_data->adc_start_val + low;
+	*adc = conf->adc_start_val + low;
 
 exit:
 	return ret;
@@ -323,18 +321,17 @@ static int temp_sensor_unmask_interrupts(struct omap_bandgap *bg_ptr, int id,
 }
 
 static
-int add_hyst(int adc_val, int hyst_val, struct omap_bandgap *bg_ptr, int i,
-	     u32 *sum)
+int add_hyst(int adc_val, int hyst_val, struct omap_bandgap *bg_ptr, u32 *sum)
 {
 	int temp, ret;
 
-	ret = omap_bandgap_adc_to_mcelsius(bg_ptr, i, adc_val, &temp);
+	ret = omap_bandgap_adc_to_mcelsius(bg_ptr, adc_val, &temp);
 	if (ret < 0)
 		return ret;
 
 	temp += hyst_val;
 
-	return omap_bandgap_mcelsius_to_adc(bg_ptr, i, temp, sum);
+	return omap_bandgap_mcelsius_to_adc(bg_ptr, temp, sum);
 }
 
 /* Talert Thot threshold. Call it only if HAS(TALERT) is set */
@@ -354,7 +351,7 @@ int temp_sensor_configure_thot(struct omap_bandgap *bg_ptr, int id, int t_hot)
 	    __ffs(tsr->threshold_tcold_mask);
 	if (t_hot <= cold) {
 		/* change the t_cold to t_hot - 5000 millidegrees */
-		err |= add_hyst(t_hot, -ts_data->hyst_val, bg_ptr, id, &cold);
+		err |= add_hyst(t_hot, -ts_data->hyst_val, bg_ptr, &cold);
 		/* write the new t_cold value */
 		reg_val = thresh_val & (~tsr->threshold_tcold_mask);
 		reg_val |= cold << __ffs(tsr->threshold_tcold_mask);
@@ -392,7 +389,7 @@ int temp_sensor_configure_tcold(struct omap_bandgap *bg_ptr, int id,
 
 	if (t_cold >= hot) {
 		/* change the t_hot to t_cold + 5000 millidegrees */
-		err |= add_hyst(t_cold, ts_data->hyst_val, bg_ptr, id, &hot);
+		err |= add_hyst(t_cold, ts_data->hyst_val, bg_ptr, &hot);
 		/* write the new t_hot value */
 		reg_val = thresh_val & (~tsr->threshold_thot_mask);
 		reg_val |= hot << __ffs(tsr->threshold_thot_mask);
@@ -459,7 +456,7 @@ int omap_bandgap_read_thot(struct omap_bandgap *bg_ptr, int id,
 	temp = omap_bandgap_readl(bg_ptr, tsr->bgap_threshold);
 	temp = (temp & tsr->threshold_thot_mask) >>
 		__ffs(tsr->threshold_thot_mask);
-	ret |= omap_bandgap_adc_to_mcelsius(bg_ptr, id, temp, &temp);
+	ret |= omap_bandgap_adc_to_mcelsius(bg_ptr, temp, &temp);
 	if (ret) {
 		dev_err(bg_ptr->dev, "failed to read thot\n");
 		return -EIO;
@@ -497,7 +494,7 @@ int omap_bandgap_write_thot(struct omap_bandgap *bg_ptr, int id, int val)
 
 	if (val < ts_data->min_temp + ts_data->hyst_val)
 		return -EINVAL;
-	ret = omap_bandgap_mcelsius_to_adc(bg_ptr, id, val, &t_hot);
+	ret = omap_bandgap_mcelsius_to_adc(bg_ptr, val, &t_hot);
 	if (ret < 0)
 		return ret;
 
@@ -534,7 +531,7 @@ int omap_bandgap_read_tcold(struct omap_bandgap *bg_ptr, int id,
 	temp = omap_bandgap_readl(bg_ptr, tsr->bgap_threshold);
 	temp = (temp & tsr->threshold_tcold_mask)
 	    >> __ffs(tsr->threshold_tcold_mask);
-	ret |= omap_bandgap_adc_to_mcelsius(bg_ptr, id, temp, &temp);
+	ret |= omap_bandgap_adc_to_mcelsius(bg_ptr, temp, &temp);
 	if (ret)
 		return -EIO;
 
@@ -570,7 +567,7 @@ int omap_bandgap_write_tcold(struct omap_bandgap *bg_ptr, int id, int val)
 	if (val > ts_data->max_temp + ts_data->hyst_val)
 		return -EINVAL;
 
-	ret = omap_bandgap_mcelsius_to_adc(bg_ptr, id, val, &t_cold);
+	ret = omap_bandgap_mcelsius_to_adc(bg_ptr, val, &t_cold);
 	if (ret < 0)
 		return ret;
 
@@ -661,7 +658,7 @@ int omap_bandgap_read_temperature(struct omap_bandgap *bg_ptr, int id,
 	temp = omap_bandgap_read_temp(bg_ptr, id);
 	mutex_unlock(&bg_ptr->bg_mutex);
 
-	ret |= omap_bandgap_adc_to_mcelsius(bg_ptr, id, temp, &temp);
+	ret |= omap_bandgap_adc_to_mcelsius(bg_ptr, temp, &temp);
 	if (ret)
 		return -EIO;
 
diff --git a/drivers/staging/omap-thermal/omap-bandgap.h b/drivers/staging/omap-thermal/omap-bandgap.h
index 28d9104..edcc965 100644
--- a/drivers/staging/omap-thermal/omap-bandgap.h
+++ b/drivers/staging/omap-thermal/omap-bandgap.h
@@ -166,8 +166,6 @@ struct temp_sensor_registers {
  * @max_temp: sensor maximum temperature
  * @min_temp: sensor minimum temperature
  * @hyst_val: temperature hysteresis considered while converting ADC values
- * @adc_start_val: ADC conversion table starting value
- * @adc_end_val: ADC conversion table ending value
  * @update_int1: update interval
  * @update_int2: update interval
  *
@@ -185,8 +183,6 @@ struct temp_sensor_data {
 	int     max_temp;
 	int     min_temp;
 	int     hyst_val;
-	u32     adc_start_val;
-	u32     adc_end_val;
 	u32     update_int1; /* not used */
 	u32     update_int2; /* not used */
 };
@@ -325,6 +321,8 @@ struct omap_temp_sensor {
  * struct omap_bandgap_data - omap bandgap data configuration structure
  * @features: a bitwise flag set to describe the device features
  * @conv_table: Pointer to ADC to temperature conversion table
+ * @adc_start_val: ADC conversion table starting value
+ * @adc_end_val: ADC conversion table ending value
  * @fclock_name: clock name of the functional clock
  * @div_ck_name: clock name of the clock divisor
  * @sensor_count: count of temperature sensor within this bandgap device
@@ -342,6 +340,8 @@ struct omap_temp_sensor {
 struct omap_bandgap_data {
 	unsigned int			features;
 	const int			*conv_table;
+	u32				adc_start_val;
+	u32				adc_end_val;
 	char				*fclock_name;
 	char				*div_ck_name;
 	int				sensor_count;
diff --git a/drivers/staging/omap-thermal/omap4-thermal-data.c b/drivers/staging/omap-thermal/omap4-thermal-data.c
index 7ec5570..88ed014 100644
--- a/drivers/staging/omap-thermal/omap4-thermal-data.c
+++ b/drivers/staging/omap-thermal/omap4-thermal-data.c
@@ -45,8 +45,6 @@ static struct temp_sensor_data omap4430_mpu_temp_sensor_data = {
 	.max_temp = OMAP4430_MAX_TEMP,
 	.min_temp = OMAP4430_MIN_TEMP,
 	.hyst_val = OMAP4430_HYST_VAL,
-	.adc_start_val = OMAP4430_ADC_START_VALUE,
-	.adc_end_val = OMAP4430_ADC_END_VALUE,
 };
 
 /*
@@ -75,6 +73,8 @@ const struct omap_bandgap_data omap4430_data = {
 	.fclock_name = "bandgap_fclk",
 	.div_ck_name = "bandgap_fclk",
 	.conv_table = omap4430_adc_to_temp,
+	.adc_start_val = OMAP4430_ADC_START_VALUE,
+	.adc_end_val = OMAP4430_ADC_END_VALUE,
 	.expose_sensor = omap_thermal_expose_sensor,
 	.remove_sensor = omap_thermal_remove_sensor,
 	.sensors = {
@@ -142,8 +142,6 @@ static struct temp_sensor_data omap4460_mpu_temp_sensor_data = {
 	.max_temp = OMAP4460_MAX_TEMP,
 	.min_temp = OMAP4460_MIN_TEMP,
 	.hyst_val = OMAP4460_HYST_VAL,
-	.adc_start_val = OMAP4460_ADC_START_VALUE,
-	.adc_end_val = OMAP4460_ADC_END_VALUE,
 	.update_int1 = 1000,
 	.update_int2 = 2000,
 };
@@ -214,6 +212,8 @@ const struct omap_bandgap_data omap4460_data = {
 	.fclock_name = "bandgap_ts_fclk",
 	.div_ck_name = "div_ts_ck",
 	.conv_table = omap4460_adc_to_temp,
+	.adc_start_val = OMAP4460_ADC_START_VALUE,
+	.adc_end_val = OMAP4460_ADC_END_VALUE,
 	.expose_sensor = omap_thermal_expose_sensor,
 	.remove_sensor = omap_thermal_remove_sensor,
 	.sensors = {
@@ -244,6 +244,8 @@ const struct omap_bandgap_data omap4470_data = {
 	.fclock_name = "bandgap_ts_fclk",
 	.div_ck_name = "div_ts_ck",
 	.conv_table = omap4460_adc_to_temp,
+	.adc_start_val = OMAP4460_ADC_START_VALUE,
+	.adc_end_val = OMAP4460_ADC_END_VALUE,
 	.expose_sensor = omap_thermal_expose_sensor,
 	.remove_sensor = omap_thermal_remove_sensor,
 	.sensors = {
diff --git a/drivers/staging/omap-thermal/omap5-thermal-data.c b/drivers/staging/omap-thermal/omap5-thermal-data.c
index 3d10704..a48c286 100644
--- a/drivers/staging/omap-thermal/omap5-thermal-data.c
+++ b/drivers/staging/omap-thermal/omap5-thermal-data.c
@@ -171,8 +171,6 @@ static struct temp_sensor_data omap5430_mpu_temp_sensor_data = {
 	.max_temp = OMAP5430_MPU_MAX_TEMP,
 	.min_temp = OMAP5430_MPU_MIN_TEMP,
 	.hyst_val = OMAP5430_MPU_HYST_VAL,
-	.adc_start_val = OMAP5430_ADC_START_VALUE,
-	.adc_end_val = OMAP5430_ADC_END_VALUE,
 	.update_int1 = 1000,
 	.update_int2 = 2000,
 };
@@ -188,8 +186,6 @@ static struct temp_sensor_data omap5430_gpu_temp_sensor_data = {
 	.max_temp = OMAP5430_GPU_MAX_TEMP,
 	.min_temp = OMAP5430_GPU_MIN_TEMP,
 	.hyst_val = OMAP5430_GPU_HYST_VAL,
-	.adc_start_val = OMAP5430_ADC_START_VALUE,
-	.adc_end_val = OMAP5430_ADC_END_VALUE,
 	.update_int1 = 1000,
 	.update_int2 = 2000,
 };
@@ -205,8 +201,6 @@ static struct temp_sensor_data omap5430_core_temp_sensor_data = {
 	.max_temp = OMAP5430_CORE_MAX_TEMP,
 	.min_temp = OMAP5430_CORE_MIN_TEMP,
 	.hyst_val = OMAP5430_CORE_HYST_VAL,
-	.adc_start_val = OMAP5430_ADC_START_VALUE,
-	.adc_end_val = OMAP5430_ADC_END_VALUE,
 	.update_int1 = 1000,
 	.update_int2 = 2000,
 };
@@ -325,6 +319,8 @@ const struct omap_bandgap_data omap5430_data = {
 	.fclock_name = "l3instr_ts_gclk_div",
 	.div_ck_name = "l3instr_ts_gclk_div",
 	.conv_table = omap5430_adc_to_temp,
+	.adc_start_val = OMAP5430_ADC_START_VALUE,
+	.adc_end_val = OMAP5430_ADC_END_VALUE,
 	.expose_sensor = omap_thermal_expose_sensor,
 	.remove_sensor = omap_thermal_remove_sensor,
 	.sensors = {
-- 
1.7.7.1.488.ge8e1c

