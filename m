Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009Ab3CONLc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 09:11:32 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:50477 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754661Ab3CONLa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 09:11:30 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH 28/50] staging: omap-thermal: rename add_hyst to omap_bandgap_add_hyst
Date: Fri, 15 Mar 2013 09:00:16 -0400
Message-ID: <1363352438-15935-29-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.7.7.1.488.ge8e1c
In-Reply-To: <1363352438-15935-1-git-send-email-eduardo.valentin@ti.com>
References: <1363352438-15935-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch improves the add_hyst function by:
. Renaming it to omap_bandgap_add_hyst
. Moving it to the ADC conversion functions section
. Changing its signature to follow the driver standard

Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/staging/omap-thermal/omap-bandgap.c |   42 ++++++++++++++++----------
 1 files changed, 26 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/omap-thermal/omap-bandgap.c b/drivers/staging/omap-thermal/omap-bandgap.c
index 39bfe8d..7b10d18 100644
--- a/drivers/staging/omap-thermal/omap-bandgap.c
+++ b/drivers/staging/omap-thermal/omap-bandgap.c
@@ -303,6 +303,28 @@ exit:
 	return ret;
 }
 
+static
+int omap_bandgap_add_hyst(struct omap_bandgap *bg_ptr, int adc_val,
+			  int hyst_val, u32 *sum)
+{
+	int temp, ret;
+
+	/*
+	 * Need to add in the mcelsius domain, so we have a temperature
+	 * the conv_table range
+	 */
+	ret = omap_bandgap_adc_to_mcelsius(bg_ptr, adc_val, &temp);
+	if (ret < 0)
+		goto exit;
+
+	temp += hyst_val;
+
+	ret = omap_bandgap_mcelsius_to_adc(bg_ptr, temp, sum);
+
+exit:
+	return ret;
+}
+
 /* Talert masks. Call it only if HAS(TALERT) is set */
 static int temp_sensor_unmask_interrupts(struct omap_bandgap *bg_ptr, int id,
 					 u32 t_hot, u32 t_cold)
@@ -330,20 +352,6 @@ static int temp_sensor_unmask_interrupts(struct omap_bandgap *bg_ptr, int id,
 	return 0;
 }
 
-static
-int add_hyst(int adc_val, int hyst_val, struct omap_bandgap *bg_ptr, u32 *sum)
-{
-	int temp, ret;
-
-	ret = omap_bandgap_adc_to_mcelsius(bg_ptr, adc_val, &temp);
-	if (ret < 0)
-		return ret;
-
-	temp += hyst_val;
-
-	return omap_bandgap_mcelsius_to_adc(bg_ptr, temp, sum);
-}
-
 /* Talert Thot threshold. Call it only if HAS(TALERT) is set */
 static
 int temp_sensor_configure_thot(struct omap_bandgap *bg_ptr, int id, int t_hot)
@@ -361,7 +369,8 @@ int temp_sensor_configure_thot(struct omap_bandgap *bg_ptr, int id, int t_hot)
 	    __ffs(tsr->threshold_tcold_mask);
 	if (t_hot <= cold) {
 		/* change the t_cold to t_hot - 5000 millidegrees */
-		err |= add_hyst(t_hot, -ts_data->hyst_val, bg_ptr, &cold);
+		err |= omap_bandgap_add_hyst(bg_ptr, t_hot,
+					     -ts_data->hyst_val, &cold);
 		/* write the new t_cold value */
 		reg_val = thresh_val & (~tsr->threshold_tcold_mask);
 		reg_val |= cold << __ffs(tsr->threshold_tcold_mask);
@@ -399,7 +408,8 @@ int temp_sensor_configure_tcold(struct omap_bandgap *bg_ptr, int id,
 
 	if (t_cold >= hot) {
 		/* change the t_hot to t_cold + 5000 millidegrees */
-		err |= add_hyst(t_cold, ts_data->hyst_val, bg_ptr, &hot);
+		err |= omap_bandgap_add_hyst(bg_ptr, t_cold,
+					     ts_data->hyst_val, &hot);
 		/* write the new t_hot value */
 		reg_val = thresh_val & (~tsr->threshold_thot_mask);
 		reg_val |= hot << __ffs(tsr->threshold_thot_mask);
-- 
1.7.7.1.488.ge8e1c

