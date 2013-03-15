Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755056Ab3CONNT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 09:13:19 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:42722 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754659Ab3CONNQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 09:13:16 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH 33/50] staging: omap-thermal: refactor APIs handling threshold values
Date: Fri, 15 Mar 2013 09:00:21 -0400
Message-ID: <1363352438-15935-34-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.7.7.1.488.ge8e1c
In-Reply-To: <1363352438-15935-1-git-send-email-eduardo.valentin@ti.com>
References: <1363352438-15935-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch improves the code that handles threshold values
by creating single functions that are usable for tcold and
thot. This way we won't have duplicated functionality just
because it is handling different bitfields. Now
the added functions are reused in several places where
it is needed to update any threshold.

This patch also removes macros that are used only inside
the _validate helper function.

In this patch there is also an addition of an extra function
section for Exposed APIs, used outside the omap-bandgap.c,
but inside the omap-thermal driver.

Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/staging/omap-thermal/omap-bandgap.c |  278 +++++++++++----------------
 1 files changed, 117 insertions(+), 161 deletions(-)

diff --git a/drivers/staging/omap-thermal/omap-bandgap.c b/drivers/staging/omap-thermal/omap-bandgap.c
index d001323..2a13bf0 100644
--- a/drivers/staging/omap-thermal/omap-bandgap.c
+++ b/drivers/staging/omap-thermal/omap-bandgap.c
@@ -370,145 +370,172 @@ static void omap_bandgap_unmask_interrupts(struct omap_bandgap *bg_ptr, int id,
 	omap_bandgap_writel(bg_ptr, reg_val, tsr->bgap_mask_ctrl);
 }
 
-/* Talert Thot threshold. Call it only if HAS(TALERT) is set */
 static
-int temp_sensor_configure_thot(struct omap_bandgap *bg_ptr, int id, int t_hot)
+int omap_bandgap_update_alert_threshold(struct omap_bandgap *bg_ptr, int id,
+					int val, bool hot)
 {
 	struct temp_sensor_data *ts_data = bg_ptr->conf->sensors[id].ts_data;
 	struct temp_sensor_registers *tsr;
-	u32 thresh_val, reg_val;
-	int cold, err = 0;
+	u32 thresh_val, reg_val, t_hot, t_cold;
+	int err = 0;
 
 	tsr = bg_ptr->conf->sensors[id].registers;
 
-	/* obtain the T cold value */
+	/* obtain the current value */
 	thresh_val = omap_bandgap_readl(bg_ptr, tsr->bgap_threshold);
-	cold = (thresh_val & tsr->threshold_tcold_mask) >>
-	    __ffs(tsr->threshold_tcold_mask);
-	if (t_hot <= cold) {
-		/* change the t_cold to t_hot - 5000 millidegrees */
-		err |= omap_bandgap_add_hyst(bg_ptr, t_hot,
-					     -ts_data->hyst_val, &cold);
-		/* write the new t_cold value */
-		reg_val = thresh_val & (~tsr->threshold_tcold_mask);
-		reg_val |= cold << __ffs(tsr->threshold_tcold_mask);
-		omap_bandgap_writel(bg_ptr, reg_val, tsr->bgap_threshold);
-		thresh_val = reg_val;
+	t_cold = (thresh_val & tsr->threshold_tcold_mask) >>
+		__ffs(tsr->threshold_tcold_mask);
+	t_hot = (thresh_val & tsr->threshold_thot_mask) >>
+		__ffs(tsr->threshold_thot_mask);
+	if (hot)
+		t_hot = val;
+	else
+		t_cold = val;
+
+	if (t_cold < t_hot) {
+		if (hot)
+			err = omap_bandgap_add_hyst(bg_ptr, t_hot,
+						    -ts_data->hyst_val,
+						    &t_cold);
+		else
+			err = omap_bandgap_add_hyst(bg_ptr, t_cold,
+						    ts_data->hyst_val,
+						    &t_hot);
 	}
 
-	/* write the new t_hot value */
+	/* write the new threshold values */
 	reg_val = thresh_val & ~tsr->threshold_thot_mask;
 	reg_val |= (t_hot << __ffs(tsr->threshold_thot_mask));
+	reg_val |= thresh_val & ~tsr->threshold_tcold_mask;
+	reg_val |= (t_cold << __ffs(tsr->threshold_tcold_mask));
 	omap_bandgap_writel(bg_ptr, reg_val, tsr->bgap_threshold);
+
 	if (err) {
 		dev_err(bg_ptr->dev, "failed to reprogram thot threshold\n");
-		return -EIO;
+		err = -EIO;
+		goto exit;
 	}
 
-	omap_bandgap_unmask_interrupts(bg_ptr, id, t_hot, cold);
-
-	return 0;
+	omap_bandgap_unmask_interrupts(bg_ptr, id, t_hot, t_cold);
+exit:
+	return err;
 }
 
-/* Talert Tcold threshold. Call it only if HAS(TALERT) is set */
-static
-int temp_sensor_configure_tcold(struct omap_bandgap *bg_ptr, int id,
-				int t_cold)
+static inline int omap_bandgap_validate(struct omap_bandgap *bg_ptr, int id)
 {
-	struct temp_sensor_data *ts_data = bg_ptr->conf->sensors[id].ts_data;
-	struct temp_sensor_registers *tsr;
-	u32 thresh_val, reg_val;
-	int hot, err = 0;
+	int ret = 0;
 
-	tsr = bg_ptr->conf->sensors[id].registers;
-	/* obtain the T cold value */
-	thresh_val = omap_bandgap_readl(bg_ptr, tsr->bgap_threshold);
-	hot = (thresh_val & tsr->threshold_thot_mask) >>
-	    __ffs(tsr->threshold_thot_mask);
-
-	if (t_cold >= hot) {
-		/* change the t_hot to t_cold + 5000 millidegrees */
-		err |= omap_bandgap_add_hyst(bg_ptr, t_cold,
-					     ts_data->hyst_val, &hot);
-		/* write the new t_hot value */
-		reg_val = thresh_val & (~tsr->threshold_thot_mask);
-		reg_val |= hot << __ffs(tsr->threshold_thot_mask);
-		omap_bandgap_writel(bg_ptr, reg_val, tsr->bgap_threshold);
-		thresh_val = reg_val;
+	if (IS_ERR_OR_NULL(bg_ptr)) {
+		pr_err("%s: invalid bandgap pointer\n", __func__);
+		ret = -EINVAL;
+		goto exit;
 	}
 
-	/* write the new t_cold value */
-	reg_val = thresh_val & ~tsr->threshold_tcold_mask;
-	reg_val |= (t_cold << __ffs(tsr->threshold_tcold_mask));
-	omap_bandgap_writel(bg_ptr, reg_val, tsr->bgap_threshold);
-	if (err) {
-		dev_err(bg_ptr->dev, "failed to reprogram tcold threshold\n");
-		return -EIO;
+	if ((id < 0) || (id >= bg_ptr->conf->sensor_count)) {
+		dev_err(bg_ptr->dev, "%s: sensor id out of range (%d)\n",
+			__func__, id);
+		ret = -ERANGE;
 	}
 
-	omap_bandgap_unmask_interrupts(bg_ptr, id, hot, t_cold);
-
-	return 0;
+exit:
+	return ret;
 }
 
-#define bandgap_is_valid(b)						\
-			(!IS_ERR_OR_NULL(b))
-#define bandgap_is_valid_sensor_id(b, i)				\
-			((i) >= 0 && (i) < (b)->conf->sensor_count)
-static inline int omap_bandgap_validate(struct omap_bandgap *bg_ptr, int id)
+int _omap_bandgap_write_threshold(struct omap_bandgap *bg_ptr, int id, int val,
+				  bool hot)
 {
-	if (!bandgap_is_valid(bg_ptr)) {
-		pr_err("%s: invalid bandgap pointer\n", __func__);
-		return -EINVAL;
+	struct temp_sensor_data *ts_data;
+	struct temp_sensor_registers *tsr;
+	u32 adc_val;
+	int ret;
+
+	ret = omap_bandgap_validate(bg_ptr, id);
+	if (ret)
+		goto exit;
+
+	if (!OMAP_BANDGAP_HAS(bg_ptr, TALERT)) {
+		ret = -ENOTSUPP;
+		goto exit;
 	}
 
-	if (!bandgap_is_valid_sensor_id(bg_ptr, id)) {
-		dev_err(bg_ptr->dev, "%s: sensor id out of range (%d)\n",
-			__func__, id);
-		return -ERANGE;
+	ts_data = bg_ptr->conf->sensors[id].ts_data;
+	tsr = bg_ptr->conf->sensors[id].registers;
+	if (hot) {
+		if (val < ts_data->min_temp + ts_data->hyst_val)
+			ret = -EINVAL;
+	} else {
+		if (val > ts_data->max_temp + ts_data->hyst_val)
+			ret = -EINVAL;
 	}
 
-	return 0;
+	if (ret)
+		goto exit;
+
+	ret = omap_bandgap_mcelsius_to_adc(bg_ptr, val, &adc_val);
+	if (ret < 0)
+		goto exit;
+
+	mutex_lock(&bg_ptr->bg_mutex);
+	omap_bandgap_update_alert_threshold(bg_ptr, id, adc_val, hot);
+	mutex_unlock(&bg_ptr->bg_mutex);
+
+exit:
+	return ret;
 }
 
-/* Exposed APIs */
-/**
- * omap_bandgap_read_thot() - reads sensor current thot
- * @bg_ptr - pointer to bandgap instance
- * @id - sensor id
- * @thot - resulting current thot value
- *
- * returns 0 on success or the proper error code
- */
-int omap_bandgap_read_thot(struct omap_bandgap *bg_ptr, int id,
-			   int *thot)
+int _omap_bandgap_read_threshold(struct omap_bandgap *bg_ptr, int id,
+				 int *val, bool hot)
 {
 	struct temp_sensor_registers *tsr;
-	u32 temp;
-	int ret;
+	u32 temp, mask;
+	int ret = 0;
 
 	ret = omap_bandgap_validate(bg_ptr, id);
 	if (ret)
-		return ret;
+		goto exit;
 
-	if (!OMAP_BANDGAP_HAS(bg_ptr, TALERT))
-		return -ENOTSUPP;
+	if (!OMAP_BANDGAP_HAS(bg_ptr, TALERT)) {
+		ret = -ENOTSUPP;
+		goto exit;
+	}
 
 	tsr = bg_ptr->conf->sensors[id].registers;
+	if (hot)
+		mask = tsr->threshold_thot_mask;
+	else
+		mask = tsr->threshold_tcold_mask;
+
 	temp = omap_bandgap_readl(bg_ptr, tsr->bgap_threshold);
-	temp = (temp & tsr->threshold_thot_mask) >>
-		__ffs(tsr->threshold_thot_mask);
+	temp = (temp & mask) >> __ffs(mask);
 	ret |= omap_bandgap_adc_to_mcelsius(bg_ptr, temp, &temp);
 	if (ret) {
 		dev_err(bg_ptr->dev, "failed to read thot\n");
-		return -EIO;
+		ret = -EIO;
+		goto exit;
 	}
 
-	*thot = temp;
+	*val = temp;
 
+exit:
 	return 0;
 }
 
+/***   Exposed APIs   ***/
+
+/**
+ * omap_bandgap_read_thot() - reads sensor current thot
+ * @bg_ptr - pointer to bandgap instance
+ * @id - sensor id
+ * @thot - resulting current thot value
+ *
+ * returns 0 on success or the proper error code
+ */
+int omap_bandgap_read_thot(struct omap_bandgap *bg_ptr, int id,
+			   int *thot)
+{
+	return _omap_bandgap_read_threshold(bg_ptr, id, thot, true);
+}
+
 /**
  * omap_bandgap_write_thot() - sets sensor current thot
  * @bg_ptr - pointer to bandgap instance
@@ -519,32 +546,7 @@ int omap_bandgap_read_thot(struct omap_bandgap *bg_ptr, int id,
  */
 int omap_bandgap_write_thot(struct omap_bandgap *bg_ptr, int id, int val)
 {
-	struct temp_sensor_data *ts_data;
-	struct temp_sensor_registers *tsr;
-	u32 t_hot;
-	int ret;
-
-	ret = omap_bandgap_validate(bg_ptr, id);
-	if (ret)
-		return ret;
-
-	if (!OMAP_BANDGAP_HAS(bg_ptr, TALERT))
-		return -ENOTSUPP;
-
-	ts_data = bg_ptr->conf->sensors[id].ts_data;
-	tsr = bg_ptr->conf->sensors[id].registers;
-
-	if (val < ts_data->min_temp + ts_data->hyst_val)
-		return -EINVAL;
-	ret = omap_bandgap_mcelsius_to_adc(bg_ptr, val, &t_hot);
-	if (ret < 0)
-		return ret;
-
-	mutex_lock(&bg_ptr->bg_mutex);
-	temp_sensor_configure_thot(bg_ptr, id, t_hot);
-	mutex_unlock(&bg_ptr->bg_mutex);
-
-	return 0;
+	return _omap_bandgap_write_threshold(bg_ptr, id, val, true);
 }
 
 /**
@@ -558,28 +560,7 @@ int omap_bandgap_write_thot(struct omap_bandgap *bg_ptr, int id, int val)
 int omap_bandgap_read_tcold(struct omap_bandgap *bg_ptr, int id,
 			    int *tcold)
 {
-	struct temp_sensor_registers *tsr;
-	u32 temp;
-	int ret;
-
-	ret = omap_bandgap_validate(bg_ptr, id);
-	if (ret)
-		return ret;
-
-	if (!OMAP_BANDGAP_HAS(bg_ptr, TALERT))
-		return -ENOTSUPP;
-
-	tsr = bg_ptr->conf->sensors[id].registers;
-	temp = omap_bandgap_readl(bg_ptr, tsr->bgap_threshold);
-	temp = (temp & tsr->threshold_tcold_mask)
-	    >> __ffs(tsr->threshold_tcold_mask);
-	ret |= omap_bandgap_adc_to_mcelsius(bg_ptr, temp, &temp);
-	if (ret)
-		return -EIO;
-
-	*tcold = temp;
-
-	return 0;
+	return _omap_bandgap_read_threshold(bg_ptr, id, tcold, false);
 }
 
 /**
@@ -592,32 +573,7 @@ int omap_bandgap_read_tcold(struct omap_bandgap *bg_ptr, int id,
  */
 int omap_bandgap_write_tcold(struct omap_bandgap *bg_ptr, int id, int val)
 {
-	struct temp_sensor_data *ts_data;
-	struct temp_sensor_registers *tsr;
-	u32 t_cold;
-	int ret;
-
-	ret = omap_bandgap_validate(bg_ptr, id);
-	if (ret)
-		return ret;
-
-	if (!OMAP_BANDGAP_HAS(bg_ptr, TALERT))
-		return -ENOTSUPP;
-
-	ts_data = bg_ptr->conf->sensors[id].ts_data;
-	tsr = bg_ptr->conf->sensors[id].registers;
-	if (val > ts_data->max_temp + ts_data->hyst_val)
-		return -EINVAL;
-
-	ret = omap_bandgap_mcelsius_to_adc(bg_ptr, val, &t_cold);
-	if (ret < 0)
-		return ret;
-
-	mutex_lock(&bg_ptr->bg_mutex);
-	temp_sensor_configure_tcold(bg_ptr, id, t_cold);
-	mutex_unlock(&bg_ptr->bg_mutex);
-
-	return 0;
+	return _omap_bandgap_write_threshold(bg_ptr, id, val, false);
 }
 
 /**
-- 
1.7.7.1.488.ge8e1c

