Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759909Ab3BZW5k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 17:57:40 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:50987 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758842Ab3BZW5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 17:57:38 -0500
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH 10/15] staging: omap-thermal: introduze FREEZE_BIT feature
Date: Tue, 26 Feb 2013 18:53:33 -0400
Message-ID: <1361919218-9788-11-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.7.7.1.488.ge8e1c
In-Reply-To: <1361919218-9788-1-git-send-email-eduardo.valentin@ti.com>
References: <1361919218-9788-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For ES2.0 devices, it is not guaranteed that current DTEMP
or DTEMP0 from the history buffer are going to contain
correct values, due to desynchronization between BG clk
and OCP clk.

For this reason, this patch changes the driver to first:
a. consider a feature flag, FREEZE_BIT, in order to check
it is possible to freeze the history buffer or not.
b. whenever reading the temperature, it will fetch from
DTEMP1 instead of DTEMP or DTEMP0.

This WA is applicable only for OMAP5430 ES2.0.

Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/staging/omap-thermal/omap-bandgap.c  |   60 +++++++++++++++++++-------
 drivers/staging/omap-thermal/omap-bandgap.h  |    1 +
 drivers/staging/omap-thermal/omap5-thermal.c |    1 +
 3 files changed, 46 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/omap-thermal/omap-bandgap.c b/drivers/staging/omap-thermal/omap-bandgap.c
index 80384ed..82ad5db 100644
--- a/drivers/staging/omap-thermal/omap-bandgap.c
+++ b/drivers/staging/omap-thermal/omap-bandgap.c
@@ -75,12 +75,44 @@ static int omap_bandgap_power(struct omap_bandgap *bg_ptr, bool on)
 	return 0;
 }
 
+static u32 omap_bandgap_read_temp(struct omap_bandgap *bg_ptr, int id)
+{
+	struct temp_sensor_registers *tsr;
+	u32 temp, ctrl, reg;
+
+	tsr = bg_ptr->conf->sensors[id].registers;
+	reg = tsr->temp_sensor_ctrl;
+
+	if (OMAP_BANDGAP_HAS(bg_ptr, FREEZE_BIT)) {
+		ctrl = omap_bandgap_readl(bg_ptr, tsr->bgap_mask_ctrl);
+		ctrl |= tsr->mask_freeze_mask;
+		omap_bandgap_writel(bg_ptr, ctrl, tsr->bgap_mask_ctrl);
+		/*
+		 * In case we cannot read from cur_dtemp / dtemp_0,
+		 * then we read from the last valid temp read
+		 */
+		reg = tsr->ctrl_dtemp_1;
+	}
+
+	/* read temperature */
+	temp = omap_bandgap_readl(bg_ptr, reg);
+	temp &= tsr->bgap_dtemp_mask;
+
+	if (OMAP_BANDGAP_HAS(bg_ptr, FREEZE_BIT)) {
+		ctrl = omap_bandgap_readl(bg_ptr, tsr->bgap_mask_ctrl);
+		ctrl &= ~tsr->mask_freeze_mask;
+		omap_bandgap_writel(bg_ptr, ctrl, tsr->bgap_mask_ctrl);
+	}
+
+	return temp;
+}
+
 /* This is the Talert handler. Call it only if HAS(TALERT) is set */
 static irqreturn_t talert_irq_handler(int irq, void *data)
 {
 	struct omap_bandgap *bg_ptr = data;
 	struct temp_sensor_registers *tsr;
-	u32 t_hot = 0, t_cold = 0, temp, ctrl;
+	u32 t_hot = 0, t_cold = 0, ctrl;
 	int i;
 
 	bg_ptr = data;
@@ -118,10 +150,6 @@ static irqreturn_t talert_irq_handler(int irq, void *data)
 			__func__, bg_ptr->conf->sensors[i].domain,
 			t_hot, t_cold);
 
-		/* read temperature */
-		temp = omap_bandgap_readl(bg_ptr, tsr->temp_sensor_ctrl);
-		temp &= tsr->bgap_dtemp_mask;
-
 		/* report temperature to whom may concern */
 		if (bg_ptr->conf->report_temperature)
 			bg_ptr->conf->report_temperature(bg_ptr, i);
@@ -190,11 +218,11 @@ static int temp_sensor_unmask_interrupts(struct omap_bandgap *bg_ptr, int id,
 	u32 temp, reg_val;
 
 	/* Read the current on die temperature */
-	tsr = bg_ptr->conf->sensors[id].registers;
-	temp = omap_bandgap_readl(bg_ptr, tsr->temp_sensor_ctrl);
-	temp &= tsr->bgap_dtemp_mask;
+	temp = omap_bandgap_read_temp(bg_ptr, id);
 
+	tsr = bg_ptr->conf->sensors[id].registers;
 	reg_val = omap_bandgap_readl(bg_ptr, tsr->bgap_mask_ctrl);
+
 	if (temp < t_hot)
 		reg_val |= tsr->mask_hot_mask;
 	else
@@ -625,8 +653,9 @@ int omap_bandgap_read_temperature(struct omap_bandgap *bg_ptr, int id,
 		return ret;
 
 	tsr = bg_ptr->conf->sensors[id].registers;
-	temp = omap_bandgap_readl(bg_ptr, tsr->temp_sensor_ctrl);
-	temp &= tsr->bgap_dtemp_mask;
+	mutex_lock(&bg_ptr->bg_mutex);
+	temp = omap_bandgap_read_temp(bg_ptr, id);
+	mutex_unlock(&bg_ptr->bg_mutex);
 
 	ret |= adc_to_temp_conversion(bg_ptr, id, temp, &temp);
 	if (ret)
@@ -694,12 +723,11 @@ omap_bandgap_force_single_read(struct omap_bandgap *bg_ptr, int id)
 	temp |= 1 << __ffs(tsr->bgap_soc_mask);
 	omap_bandgap_writel(bg_ptr, temp, tsr->temp_sensor_ctrl);
 	/* Wait until DTEMP is updated */
-	temp = omap_bandgap_readl(bg_ptr, tsr->temp_sensor_ctrl);
-	temp &= (tsr->bgap_dtemp_mask);
-	while ((temp == 0) && --counter) {
-		temp = omap_bandgap_readl(bg_ptr, tsr->temp_sensor_ctrl);
-		temp &= (tsr->bgap_dtemp_mask);
-	}
+	temp = omap_bandgap_read_temp(bg_ptr, id);
+
+	while ((temp == 0) && --counter)
+		temp = omap_bandgap_read_temp(bg_ptr, id);
+
 	/* Start of Conversion = 0 */
 	temp = omap_bandgap_readl(bg_ptr, tsr->temp_sensor_ctrl);
 	temp &= ~(1 << __ffs(tsr->bgap_soc_mask));
diff --git a/drivers/staging/omap-thermal/omap-bandgap.h b/drivers/staging/omap-thermal/omap-bandgap.h
index ef5503d..59c9ba2 100644
--- a/drivers/staging/omap-thermal/omap-bandgap.h
+++ b/drivers/staging/omap-thermal/omap-bandgap.h
@@ -442,6 +442,7 @@ struct omap_bandgap_data {
 #define OMAP_BANDGAP_FEATURE_COUNTER		(1 << 4)
 #define OMAP_BANDGAP_FEATURE_POWER_SWITCH	(1 << 5)
 #define OMAP_BANDGAP_FEATURE_CLK_CTRL		(1 << 6)
+#define OMAP_BANDGAP_FEATURE_FREEZE_BIT		(1 << 7)
 #define OMAP_BANDGAP_HAS(b, f)			\
 			((b)->conf->features & OMAP_BANDGAP_FEATURE_ ## f)
 	unsigned int			features;
diff --git a/drivers/staging/omap-thermal/omap5-thermal.c b/drivers/staging/omap-thermal/omap5-thermal.c
index c2bfc65..b20db0c 100644
--- a/drivers/staging/omap-thermal/omap5-thermal.c
+++ b/drivers/staging/omap-thermal/omap5-thermal.c
@@ -319,6 +319,7 @@ omap5430_adc_to_temp[
 /* TODO : Need to update the slope/constant for ES2.0 silicon */
 const struct omap_bandgap_data omap5430_data = {
 	.features = OMAP_BANDGAP_FEATURE_TSHUT_CONFIG |
+			OMAP_BANDGAP_FEATURE_FREEZE_BIT |
 			OMAP_BANDGAP_FEATURE_TALERT,
 	.fclock_name = "l3instr_ts_gclk_div",
 	.div_ck_name = "l3instr_ts_gclk_div",
-- 
1.7.7.1.488.ge8e1c

