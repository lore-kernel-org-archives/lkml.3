Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619Ab3CONEA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 09:04:00 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:59804 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754481Ab3COND6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 09:03:58 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH 07/50] staging: omap-thermal: introduce RMW_BITS macro
Date: Fri, 15 Mar 2013 08:59:55 -0400
Message-ID: <1363352438-15935-8-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.7.7.1.488.ge8e1c
In-Reply-To: <1363352438-15935-1-git-send-email-eduardo.valentin@ti.com>
References: <1363352438-15935-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduce a macro to read, update, write bitfields.
It will be specific to bandgap data structures.

Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/staging/omap-thermal/omap-bandgap.c |  178 +++++++--------------------
 1 files changed, 46 insertions(+), 132 deletions(-)

diff --git a/drivers/staging/omap-thermal/omap-bandgap.c b/drivers/staging/omap-thermal/omap-bandgap.c
index 9f2d7cc..1c1b905 100644
--- a/drivers/staging/omap-thermal/omap-bandgap.c
+++ b/drivers/staging/omap-thermal/omap-bandgap.c
@@ -52,25 +52,29 @@ static void omap_bandgap_writel(struct omap_bandgap *bg_ptr, u32 val, u32 reg)
 	writel(val, bg_ptr->base + reg);
 }
 
+/* update bits, value will be shifted */
+#define RMW_BITS(bg_ptr, id, reg, mask, val)			\
+do {								\
+	struct temp_sensor_registers *t;			\
+	u32 r;							\
+								\
+	t = bg_ptr->conf->sensors[(id)].registers;		\
+	r = omap_bandgap_readl(bg_ptr, t->reg);			\
+	r &= ~t->mask;						\
+	r |= (val) << __ffs(t->mask);				\
+	omap_bandgap_writel(bg_ptr, r, t->reg);			\
+} while (0)
+
 static int omap_bandgap_power(struct omap_bandgap *bg_ptr, bool on)
 {
-	struct temp_sensor_registers *tsr;
 	int i;
-	u32 ctrl;
 
 	if (!OMAP_BANDGAP_HAS(bg_ptr, POWER_SWITCH))
 		return 0;
 
-	for (i = 0; i < bg_ptr->conf->sensor_count; i++) {
-		tsr = bg_ptr->conf->sensors[i].registers;
-		ctrl = omap_bandgap_readl(bg_ptr, tsr->temp_sensor_ctrl);
-		ctrl &= ~tsr->bgap_tempsoff_mask;
+	for (i = 0; i < bg_ptr->conf->sensor_count; i++)
 		/* active on 0 */
-		ctrl |= !on << __ffs(tsr->bgap_tempsoff_mask);
-
-		/* write BGAP_TEMPSOFF should be reset to 0 */
-		omap_bandgap_writel(bg_ptr, ctrl, tsr->temp_sensor_ctrl);
-	}
+		RMW_BITS(bg_ptr, i, temp_sensor_ctrl, bgap_tempsoff_mask, !on);
 
 	return 0;
 }
@@ -78,15 +82,13 @@ static int omap_bandgap_power(struct omap_bandgap *bg_ptr, bool on)
 static u32 omap_bandgap_read_temp(struct omap_bandgap *bg_ptr, int id)
 {
 	struct temp_sensor_registers *tsr;
-	u32 temp, ctrl, reg;
+	u32 temp, reg;
 
 	tsr = bg_ptr->conf->sensors[id].registers;
 	reg = tsr->temp_sensor_ctrl;
 
 	if (OMAP_BANDGAP_HAS(bg_ptr, FREEZE_BIT)) {
-		ctrl = omap_bandgap_readl(bg_ptr, tsr->bgap_mask_ctrl);
-		ctrl |= tsr->mask_freeze_mask;
-		omap_bandgap_writel(bg_ptr, ctrl, tsr->bgap_mask_ctrl);
+		RMW_BITS(bg_ptr, id, bgap_mask_ctrl, mask_freeze_mask, 1);
 		/*
 		 * In case we cannot read from cur_dtemp / dtemp_0,
 		 * then we read from the last valid temp read
@@ -98,11 +100,8 @@ static u32 omap_bandgap_read_temp(struct omap_bandgap *bg_ptr, int id)
 	temp = omap_bandgap_readl(bg_ptr, reg);
 	temp &= tsr->bgap_dtemp_mask;
 
-	if (OMAP_BANDGAP_HAS(bg_ptr, FREEZE_BIT)) {
-		ctrl = omap_bandgap_readl(bg_ptr, tsr->bgap_mask_ctrl);
-		ctrl &= ~tsr->mask_freeze_mask;
-		omap_bandgap_writel(bg_ptr, ctrl, tsr->bgap_mask_ctrl);
-	}
+	if (OMAP_BANDGAP_HAS(bg_ptr, FREEZE_BIT))
+		RMW_BITS(bg_ptr, id, bgap_mask_ctrl, mask_freeze_mask, 0);
 
 	return temp;
 }
@@ -290,37 +289,6 @@ int temp_sensor_configure_thot(struct omap_bandgap *bg_ptr, int id, int t_hot)
 	return temp_sensor_unmask_interrupts(bg_ptr, id, t_hot, cold);
 }
 
-/* Talert Thot and Tcold thresholds. Call it only if HAS(TALERT) is set */
-static
-int temp_sensor_init_talert_thresholds(struct omap_bandgap *bg_ptr, int id,
-				       int t_hot, int t_cold)
-{
-	struct temp_sensor_registers *tsr;
-	u32 reg_val, thresh_val;
-
-	tsr = bg_ptr->conf->sensors[id].registers;
-	thresh_val = omap_bandgap_readl(bg_ptr, tsr->bgap_threshold);
-
-	/* write the new t_cold value */
-	reg_val = thresh_val & ~tsr->threshold_tcold_mask;
-	reg_val |= (t_cold << __ffs(tsr->threshold_tcold_mask));
-	omap_bandgap_writel(bg_ptr, reg_val, tsr->bgap_threshold);
-
-	thresh_val = omap_bandgap_readl(bg_ptr, tsr->bgap_threshold);
-
-	/* write the new t_hot value */
-	reg_val = thresh_val & ~tsr->threshold_thot_mask;
-	reg_val |= (t_hot << __ffs(tsr->threshold_thot_mask));
-	omap_bandgap_writel(bg_ptr, reg_val, tsr->bgap_threshold);
-
-	reg_val = omap_bandgap_readl(bg_ptr, tsr->bgap_mask_ctrl);
-	reg_val |= tsr->mask_hot_mask;
-	reg_val |= tsr->mask_cold_mask;
-	omap_bandgap_writel(bg_ptr, reg_val, tsr->bgap_mask_ctrl);
-
-	return 0;
-}
-
 /* Talert Tcold threshold. Call it only if HAS(TALERT) is set */
 static
 int temp_sensor_configure_tcold(struct omap_bandgap *bg_ptr, int id,
@@ -359,54 +327,6 @@ int temp_sensor_configure_tcold(struct omap_bandgap *bg_ptr, int id,
 	return temp_sensor_unmask_interrupts(bg_ptr, id, hot, t_cold);
 }
 
-/* This is Tshut Thot config. Call it only if HAS(TSHUT_CONFIG) is set */
-static int temp_sensor_configure_tshut_hot(struct omap_bandgap *bg_ptr,
-					   int id, int tshut_hot)
-{
-	struct temp_sensor_registers *tsr;
-	u32 reg_val;
-
-	tsr = bg_ptr->conf->sensors[id].registers;
-	reg_val = omap_bandgap_readl(bg_ptr, tsr->tshut_threshold);
-	reg_val &= ~tsr->tshut_hot_mask;
-	reg_val |= tshut_hot << __ffs(tsr->tshut_hot_mask);
-	omap_bandgap_writel(bg_ptr, reg_val, tsr->tshut_threshold);
-
-	return 0;
-}
-
-/* This is Tshut Tcold config. Call it only if HAS(TSHUT_CONFIG) is set */
-static int temp_sensor_configure_tshut_cold(struct omap_bandgap *bg_ptr,
-					    int id, int tshut_cold)
-{
-	struct temp_sensor_registers *tsr;
-	u32 reg_val;
-
-	tsr = bg_ptr->conf->sensors[id].registers;
-	reg_val = omap_bandgap_readl(bg_ptr, tsr->tshut_threshold);
-	reg_val &= ~tsr->tshut_cold_mask;
-	reg_val |= tshut_cold << __ffs(tsr->tshut_cold_mask);
-	omap_bandgap_writel(bg_ptr, reg_val, tsr->tshut_threshold);
-
-	return 0;
-}
-
-/* This is counter config. Call it only if HAS(COUNTER) is set */
-static int configure_temp_sensor_counter(struct omap_bandgap *bg_ptr, int id,
-					 u32 counter)
-{
-	struct temp_sensor_registers *tsr;
-	u32 val;
-
-	tsr = bg_ptr->conf->sensors[id].registers;
-	val = omap_bandgap_readl(bg_ptr, tsr->bgap_counter);
-	val &= ~tsr->counter_mask;
-	val |= counter << __ffs(tsr->counter_mask);
-	omap_bandgap_writel(bg_ptr, val, tsr->bgap_counter);
-
-	return 0;
-}
-
 #define bandgap_is_valid(b)						\
 			(!IS_ERR_OR_NULL(b))
 #define bandgap_is_valid_sensor_id(b, i)				\
@@ -628,7 +548,7 @@ int omap_bandgap_write_update_interval(struct omap_bandgap *bg_ptr,
 
 	interval = interval * bg_ptr->clk_rate / 1000;
 	mutex_lock(&bg_ptr->bg_mutex);
-	configure_temp_sensor_counter(bg_ptr, id, interval);
+	RMW_BITS(bg_ptr, id, bgap_counter, counter_mask, interval);
 	mutex_unlock(&bg_ptr->bg_mutex);
 
 	return 0;
@@ -645,7 +565,6 @@ int omap_bandgap_write_update_interval(struct omap_bandgap *bg_ptr,
 int omap_bandgap_read_temperature(struct omap_bandgap *bg_ptr, int id,
 				  int *temperature)
 {
-	struct temp_sensor_registers *tsr;
 	u32 temp;
 	int ret;
 
@@ -653,7 +572,6 @@ int omap_bandgap_read_temperature(struct omap_bandgap *bg_ptr, int id,
 	if (ret)
 		return ret;
 
-	tsr = bg_ptr->conf->sensors[id].registers;
 	mutex_lock(&bg_ptr->bg_mutex);
 	temp = omap_bandgap_read_temp(bg_ptr, id);
 	mutex_unlock(&bg_ptr->bg_mutex);
@@ -708,31 +626,23 @@ void *omap_bandgap_get_sensor_data(struct omap_bandgap *bg_ptr, int id)
 static int
 omap_bandgap_force_single_read(struct omap_bandgap *bg_ptr, int id)
 {
-	struct temp_sensor_registers *tsr;
 	u32 temp = 0, counter = 1000;
 
-	tsr = bg_ptr->conf->sensors[id].registers;
 	/* Select single conversion mode */
-	if (OMAP_BANDGAP_HAS(bg_ptr, MODE_CONFIG)) {
-		temp = omap_bandgap_readl(bg_ptr, tsr->bgap_mode_ctrl);
-		temp &= ~(1 << __ffs(tsr->mode_ctrl_mask));
-		omap_bandgap_writel(bg_ptr, temp, tsr->bgap_mode_ctrl);
-	}
+	if (OMAP_BANDGAP_HAS(bg_ptr, MODE_CONFIG))
+		RMW_BITS(bg_ptr, id, bgap_mode_ctrl, mode_ctrl_mask, 0);
 
 	/* Start of Conversion = 1 */
-	temp = omap_bandgap_readl(bg_ptr, tsr->temp_sensor_ctrl);
-	temp |= 1 << __ffs(tsr->bgap_soc_mask);
-	omap_bandgap_writel(bg_ptr, temp, tsr->temp_sensor_ctrl);
+	RMW_BITS(bg_ptr, id, temp_sensor_ctrl, bgap_soc_mask, 1);
 	/* Wait until DTEMP is updated */
 	temp = omap_bandgap_read_temp(bg_ptr, id);
 
 	while ((temp == 0) && --counter)
 		temp = omap_bandgap_read_temp(bg_ptr, id);
+	/* REVISIT: Check correct condition for end of conversion */
 
 	/* Start of Conversion = 0 */
-	temp = omap_bandgap_readl(bg_ptr, tsr->temp_sensor_ctrl);
-	temp &= ~(1 << __ffs(tsr->bgap_soc_mask));
-	omap_bandgap_writel(bg_ptr, temp, tsr->temp_sensor_ctrl);
+	RMW_BITS(bg_ptr, id, temp_sensor_ctrl, bgap_soc_mask, 0);
 
 	return 0;
 }
@@ -745,17 +655,12 @@ omap_bandgap_force_single_read(struct omap_bandgap *bg_ptr, int id)
  */
 static int enable_continuous_mode(struct omap_bandgap *bg_ptr)
 {
-	struct temp_sensor_registers *tsr;
 	int i;
-	u32 val;
 
 	for (i = 0; i < bg_ptr->conf->sensor_count; i++) {
 		/* Perform a single read just before enabling continuous */
 		omap_bandgap_force_single_read(bg_ptr, i);
-		tsr = bg_ptr->conf->sensors[i].registers;
-		val = omap_bandgap_readl(bg_ptr, tsr->bgap_mode_ctrl);
-		val |= 1 << __ffs(tsr->mode_ctrl_mask);
-		omap_bandgap_writel(bg_ptr, val, tsr->bgap_mode_ctrl);
+		RMW_BITS(bg_ptr, i, bgap_mode_ctrl, mode_ctrl_mask, 1);
 	}
 
 	return 0;
@@ -955,22 +860,31 @@ int omap_bandgap_probe(struct platform_device *pdev)
 	/* Set default counter to 1 for now */
 	if (OMAP_BANDGAP_HAS(bg_ptr, COUNTER))
 		for (i = 0; i < bg_ptr->conf->sensor_count; i++)
-			configure_temp_sensor_counter(bg_ptr, i, 1);
+			RMW_BITS(bg_ptr, i, bgap_counter, counter_mask, 1);
 
+	/* Set default thresholds for alert and shutdown */
 	for (i = 0; i < bg_ptr->conf->sensor_count; i++) {
 		struct temp_sensor_data *ts_data;
 
 		ts_data = bg_ptr->conf->sensors[i].ts_data;
 
-		if (OMAP_BANDGAP_HAS(bg_ptr, TALERT))
-			temp_sensor_init_talert_thresholds(bg_ptr, i,
-							   ts_data->t_hot,
-							   ts_data->t_cold);
+		if (OMAP_BANDGAP_HAS(bg_ptr, TALERT)) {
+			/* Set initial Talert thresholds */
+			RMW_BITS(bg_ptr, i, bgap_threshold,
+				 threshold_tcold_mask, ts_data->t_cold);
+			RMW_BITS(bg_ptr, i, bgap_threshold,
+				 threshold_thot_mask, ts_data->t_hot);
+			/* Enable the alert events */
+			RMW_BITS(bg_ptr, i, bgap_mask_ctrl, mask_hot_mask, 1);
+			RMW_BITS(bg_ptr, i, bgap_mask_ctrl, mask_cold_mask, 1);
+		}
+
 		if (OMAP_BANDGAP_HAS(bg_ptr, TSHUT_CONFIG)) {
-			temp_sensor_configure_tshut_hot(bg_ptr, i,
-							ts_data->tshut_hot);
-			temp_sensor_configure_tshut_cold(bg_ptr, i,
-							 ts_data->tshut_cold);
+			/* Set initial Tshut thresholds */
+			RMW_BITS(bg_ptr, i, tshut_threshold,
+				 tshut_hot_mask, ts_data->tshut_hot);
+			RMW_BITS(bg_ptr, i, tshut_threshold,
+				 tshut_cold_mask, ts_data->tshut_cold);
 		}
 	}
 
@@ -980,8 +894,8 @@ int omap_bandgap_probe(struct platform_device *pdev)
 	/* Set .250 seconds time as default counter */
 	if (OMAP_BANDGAP_HAS(bg_ptr, COUNTER))
 		for (i = 0; i < bg_ptr->conf->sensor_count; i++)
-			configure_temp_sensor_counter(bg_ptr, i,
-						      bg_ptr->clk_rate / 4);
+			RMW_BITS(bg_ptr, i, bgap_counter, counter_mask,
+				 bg_ptr->clk_rate / 4);
 
 	/* Every thing is good? Then expose the sensors */
 	for (i = 0; i < bg_ptr->conf->sensor_count; i++) {
-- 
1.7.7.1.488.ge8e1c

