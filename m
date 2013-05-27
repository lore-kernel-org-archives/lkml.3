Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757864Ab3E0LJd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 07:09:33 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:56105 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757791Ab3E0LJa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 07:09:30 -0400
From: Andrii Tseglytskyi <andrii.tseglytskyi@ti.com>
To: Kevin Hilman <khilman@linaro.org>, J Keerthy <j-keerthy@ti.com>
CC: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>
Subject: [PATCH v1 2/3] PM / AVS: SmartReflex: use omap_sr * for minmax interfaces
Date: Mon, 27 May 2013 14:09:23 +0300
Message-ID: <1369652964-14484-3-git-send-email-andrii.tseglytskyi@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1369652964-14484-1-git-send-email-andrii.tseglytskyi@ti.com>
References: <1369652964-14484-1-git-send-email-andrii.tseglytskyi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SmartReflex driver interface is natively divided to two parts:

- external SmartReflex interface
- interface between SmartReflex driver and SmartReflex Class

Functions which belong to AVS class interface can use
struct omap_sr* instead of struct voltatedomain*, to provide a
direct connection between SR driver and SR class. This allows
us to optimize and not do additional lookups where none is
required.

sr_configure_minmax() is interface function between SR driver
and SR class. It is typically used by Class driver to
configure MINMAXAVG module inside SmartReflex module.
Now it takes struct omap_sr* as input parameter.

Signed-off-by: Andrii Tseglytskyi <andrii.tseglytskyi@ti.com>
Acked-by: Nishanth Menon <nm@ti.com>
---
 drivers/power/avs/smartreflex.c   |   14 +++++++-------
 include/linux/power/smartreflex.h |    2 +-
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/power/avs/smartreflex.c b/drivers/power/avs/smartreflex.c
index 155a050..ef92716 100644
--- a/drivers/power/avs/smartreflex.c
+++ b/drivers/power/avs/smartreflex.c
@@ -459,9 +459,9 @@ int sr_disable_errgen(struct omap_sr *sr)
 }
 
 /**
- * sr_configure_minmax() - Configures the smrtreflex to perform AVS using the
+ * sr_configure_minmax() - Configures the SmartReflex to perform AVS using the
  *			 minmaxavg module.
- * @voltdm:	VDD pointer to which the SR module to be configured belongs to.
+ * @sr:			SR module to be configured.
  *
  * This API is to be called from the smartreflex class driver to
  * configure the minmaxavg module inside the smartreflex module.
@@ -470,16 +470,16 @@ int sr_disable_errgen(struct omap_sr *sr)
  * SR CLASS 2 can choose between ERROR module and MINMAXAVG
  * module. Returns 0 on success and error value in case of failure.
  */
-int sr_configure_minmax(struct voltagedomain *voltdm)
+int sr_configure_minmax(struct omap_sr *sr)
 {
 	u32 sr_config, sr_avgwt;
 	u32 senp_en = 0, senn_en = 0;
 	u8 senp_shift, senn_shift;
-	struct omap_sr *sr = _sr_lookup(voltdm);
 
-	if (IS_ERR(sr)) {
-		pr_warning("%s: omap_sr struct for voltdm not found\n",	__func__);
-		return PTR_ERR(sr);
+	if (!sr) {
+		pr_warn("%s: NULL omap_sr from %pF\n", __func__,
+			(void *)_RET_IP_);
+		return -EINVAL;
 	}
 
 	if (!sr->clk_length)
diff --git a/include/linux/power/smartreflex.h b/include/linux/power/smartreflex.h
index 9c3b9ad..648be77 100644
--- a/include/linux/power/smartreflex.h
+++ b/include/linux/power/smartreflex.h
@@ -303,7 +303,7 @@ int sr_enable(struct voltagedomain *voltdm, unsigned long volt);
 void sr_disable(struct voltagedomain *voltdm);
 int sr_configure_errgen(struct omap_sr *sr);
 int sr_disable_errgen(struct omap_sr *sr);
-int sr_configure_minmax(struct voltagedomain *voltdm);
+int sr_configure_minmax(struct omap_sr *sr);
 
 /* API to register the smartreflex class driver with the smartreflex driver */
 int sr_register_class(struct omap_sr_class_data *class_data);
-- 
1.7.9.5

