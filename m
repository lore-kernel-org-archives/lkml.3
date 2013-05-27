Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757909Ab3E0LKD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 07:10:03 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:56107 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757802Ab3E0LJc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 07:09:32 -0400
From: Andrii Tseglytskyi <andrii.tseglytskyi@ti.com>
To: Kevin Hilman <khilman@linaro.org>, J Keerthy <j-keerthy@ti.com>
CC: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>
Subject: [PATCH v1 3/3] PM / AVS: SmartReflex: use omap_sr * for enable/disable interface
Date: Mon, 27 May 2013 14:09:24 +0300
Message-ID: <1369652964-14484-4-git-send-email-andrii.tseglytskyi@ti.com>
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

sr_enable() and sr_disable() are interface functions between
SR driver and SR class. They are typically used by Class driver
to enable/disable SmartReflex hardware module.
Now they take struct omap_sr* as input parameter.

Signed-off-by: Andrii Tseglytskyi <andrii.tseglytskyi@ti.com>
Acked-by: Nishanth Menon <nm@ti.com>
---
 arch/arm/mach-omap2/smartreflex-class3.c |    4 ++--
 drivers/power/avs/smartreflex.c          |   23 +++++++++++------------
 include/linux/power/smartreflex.h        |    4 ++--
 3 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/arch/arm/mach-omap2/smartreflex-class3.c b/arch/arm/mach-omap2/smartreflex-class3.c
index 6c26dc1..7a42e19 100644
--- a/arch/arm/mach-omap2/smartreflex-class3.c
+++ b/arch/arm/mach-omap2/smartreflex-class3.c
@@ -26,14 +26,14 @@ static int sr_class3_enable(struct omap_sr *sr)
 	}
 
 	omap_vp_enable(sr->voltdm);
-	return sr_enable(sr->voltdm, volt);
+	return sr_enable(sr, volt);
 }
 
 static int sr_class3_disable(struct omap_sr *sr, int is_volt_reset)
 {
 	sr_disable_errgen(sr);
 	omap_vp_disable(sr->voltdm);
-	sr_disable(sr->voltdm);
+	sr_disable(sr);
 	if (is_volt_reset)
 		voltdm_reset(sr->voltdm);
 
diff --git a/drivers/power/avs/smartreflex.c b/drivers/power/avs/smartreflex.c
index ef92716..af4e70b 100644
--- a/drivers/power/avs/smartreflex.c
+++ b/drivers/power/avs/smartreflex.c
@@ -546,7 +546,7 @@ int sr_configure_minmax(struct omap_sr *sr)
 
 /**
  * sr_enable() - Enables the smartreflex module.
- * @voltdm:	VDD pointer to which the SR module to be configured belongs to.
+ * @sr:		pointer to which the SR module to be configured belongs to.
  * @volt:	The voltage at which the Voltage domain associated with
  *		the smartreflex module is operating at.
  *		This is required only to program the correct Ntarget value.
@@ -555,16 +555,16 @@ int sr_configure_minmax(struct omap_sr *sr)
  * enable a smartreflex module. Returns 0 on success. Returns error
  * value if the voltage passed is wrong or if ntarget value is wrong.
  */
-int sr_enable(struct voltagedomain *voltdm, unsigned long volt)
+int sr_enable(struct omap_sr *sr, unsigned long volt)
 {
 	struct omap_volt_data *volt_data;
-	struct omap_sr *sr = _sr_lookup(voltdm);
 	struct omap_sr_nvalue_table *nvalue_row;
 	int ret;
 
-	if (IS_ERR(sr)) {
-		pr_warning("%s: omap_sr struct for voltdm not found\n",	__func__);
-		return PTR_ERR(sr);
+	if (!sr) {
+		pr_warn("%s: NULL omap_sr from %pF\n", __func__,
+			(void *)_RET_IP_);
+		return -EINVAL;
 	}
 
 	volt_data = omap_voltage_get_voltdata(sr->voltdm, volt);
@@ -606,17 +606,16 @@ int sr_enable(struct voltagedomain *voltdm, unsigned long volt)
 
 /**
  * sr_disable() - Disables the smartreflex module.
- * @voltdm:	VDD pointer to which the SR module to be configured belongs to.
+ * @sr:		pointer to which the SR module to be configured belongs to.
  *
  * This API is to be called from the smartreflex class driver to
  * disable a smartreflex module.
  */
-void sr_disable(struct voltagedomain *voltdm)
+void sr_disable(struct omap_sr *sr)
 {
-	struct omap_sr *sr = _sr_lookup(voltdm);
-
-	if (IS_ERR(sr)) {
-		pr_warning("%s: omap_sr struct for voltdm not found\n",	__func__);
+	if (!sr) {
+		pr_warn("%s: NULL omap_sr from %pF\n", __func__,
+			(void *)_RET_IP_);
 		return;
 	}
 
diff --git a/include/linux/power/smartreflex.h b/include/linux/power/smartreflex.h
index 648be77..d8b187c3 100644
--- a/include/linux/power/smartreflex.h
+++ b/include/linux/power/smartreflex.h
@@ -299,8 +299,8 @@ void omap_sr_disable_reset_volt(struct voltagedomain *voltdm);
 void omap_sr_register_pmic(struct omap_sr_pmic_data *pmic_data);
 
 /* Smartreflex driver hooks to be called from Smartreflex class driver */
-int sr_enable(struct voltagedomain *voltdm, unsigned long volt);
-void sr_disable(struct voltagedomain *voltdm);
+int sr_enable(struct omap_sr *sr, unsigned long volt);
+void sr_disable(struct omap_sr *sr);
 int sr_configure_errgen(struct omap_sr *sr);
 int sr_disable_errgen(struct omap_sr *sr);
 int sr_configure_minmax(struct omap_sr *sr);
-- 
1.7.9.5

