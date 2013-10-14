Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758999Ab3JNVD4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 17:03:56 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:62231 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932203Ab3JNVC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 17:02:58 -0400
From: Marek Belisko <marek@goldelico.com>
To: tony@atomide.com, linux@arm.linux.org.uk, tomi.valkeinen@ti.com,
        plagnioj@jcrosoft.com
Cc: linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        neilb@suse.de, hns@goldelico.com, Marek Belisko <marek@goldelico.com>
Subject: [PATCH 2/3] video: venc: Add new callback and handling for bypass and acbias setup.
Date: Mon, 14 Oct 2013 23:02:34 +0200
Message-Id: <1381784555-18344-3-git-send-email-marek@goldelico.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381784555-18344-1-git-send-email-marek@goldelico.com>
References: <1381784555-18344-1-git-send-email-marek@goldelico.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add new callback to set bypass and acbias. During venc enble disable those
bit are updated in devconf1 register.

Signed-off-by: Marek Belisko <marek@goldelico.com>
---
 drivers/video/omap2/dss/venc.c | 21 +++++++++++++++++++++
 include/video/omapdss.h        |  2 ++
 2 files changed, 23 insertions(+)

diff --git a/drivers/video/omap2/dss/venc.c b/drivers/video/omap2/dss/venc.c
index 5f88ac4..17bd45b 100644
--- a/drivers/video/omap2/dss/venc.c
+++ b/drivers/video/omap2/dss/venc.c
@@ -34,6 +34,7 @@
 #include <linux/platform_device.h>
 #include <linux/regulator/consumer.h>
 #include <linux/pm_runtime.h>
+#include <linux/omap-tvout.h>
 
 #include <video/omapdss.h>
 
@@ -303,6 +304,8 @@ static struct {
 	struct omap_video_timings timings;
 	enum omap_dss_venc_type type;
 	bool invert_polarity;
+	bool bypass;
+	bool acbias;
 
 	struct omap_dss_device output;
 } venc;
@@ -455,6 +458,9 @@ static int venc_power_on(struct omap_dss_device *dssdev)
 
 	venc_write_reg(VENC_OUTPUT_CONTROL, l);
 
+	/* apply bypass and acbias */
+	update_bypass_acbias(venc.bypass, venc.acbias);
+
 	dss_mgr_set_timings(mgr, &venc.timings);
 
 	r = regulator_enable(venc.vdda_dac_reg);
@@ -485,6 +491,9 @@ static void venc_power_off(struct omap_dss_device *dssdev)
 	venc_write_reg(VENC_OUTPUT_CONTROL, 0);
 	dss_set_dac_pwrdn_bgz(0);
 
+	/* clear bypass and acbias */
+	update_bypass_acbias(false, false);
+
 	dss_mgr_disable(mgr);
 
 	regulator_disable(venc.vdda_dac_reg);
@@ -629,6 +638,17 @@ static void venc_invert_vid_out_polarity(struct omap_dss_device *dssdev,
 	mutex_unlock(&venc.venc_lock);
 }
 
+static void venc_bypass_and_acbias(struct omap_dss_device *dssdev,
+		bool bypass, bool acbias)
+{
+	mutex_lock(&venc.venc_lock);
+
+	venc.bypass = bypass;
+	venc.acbias = acbias;
+
+	mutex_unlock(&venc.venc_lock);
+}
+
 static int venc_init_regulator(void)
 {
 	struct regulator *vdda_dac;
@@ -777,6 +797,7 @@ static const struct omapdss_atv_ops venc_ops = {
 
 	.set_type = venc_set_type,
 	.invert_vid_out_polarity = venc_invert_vid_out_polarity,
+	.bypass_and_acbias = venc_bypass_and_acbias,
 
 	.set_wss = venc_set_wss,
 	.get_wss = venc_get_wss,
diff --git a/include/video/omapdss.h b/include/video/omapdss.h
index 3d7c51a..54a185f 100644
--- a/include/video/omapdss.h
+++ b/include/video/omapdss.h
@@ -607,6 +607,8 @@ struct omapdss_atv_ops {
 		enum omap_dss_venc_type type);
 	void (*invert_vid_out_polarity)(struct omap_dss_device *dssdev,
 		bool invert_polarity);
+	void (*bypass_and_acbias)(struct omap_dss_device *dssdev,
+		bool bypass, bool acbias);
 
 	int (*set_wss)(struct omap_dss_device *dssdev, u32 wss);
 	u32 (*get_wss)(struct omap_dss_device *dssdev);
-- 
1.8.1.2

