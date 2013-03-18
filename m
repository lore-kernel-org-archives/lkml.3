Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220Ab3CRPCS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 11:02:18 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:56726 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753636Ab3CRPCO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 11:02:14 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH 6/8] staging: ti-soc-thermal: split writable data from readonly data
Date: Mon, 18 Mar 2013 10:59:14 -0400
Message-ID: <1363618756-15851-7-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.7.7.1.488.ge8e1c
In-Reply-To: <1363618756-15851-1-git-send-email-eduardo.valentin@ti.com>
References: <1363618756-15851-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes the data structures of this driver so
that readonly data can reside only in the conf pointer.
Now each register has a struct to hold its configuration info,
to be used base on chip version for instance, and a
struct of values to be written, like register shadow and priv data.

Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>

diff --git a/drivers/staging/ti-soc-thermal/ti-bandgap.c b/drivers/staging/ti-soc-thermal/ti-bandgap.c
index c850e13..b74e847 100644
--- a/drivers/staging/ti-soc-thermal/ti-bandgap.c
+++ b/drivers/staging/ti-soc-thermal/ti-bandgap.c
@@ -249,7 +249,7 @@ static irqreturn_t ti_bandgap_tshut_irq_handler(int irq, void *data)
 static
 int ti_bandgap_adc_to_mcelsius(struct ti_bandgap *bgp, int adc_val, int *t)
 {
-	struct ti_bandgap_data *conf = bgp->conf;
+	const struct ti_bandgap_data *conf = bgp->conf;
 	int ret = 0;
 
 	/* look up for temperature in the table and return the temperature */
@@ -277,7 +277,7 @@ exit:
 static
 int ti_bandgap_mcelsius_to_adc(struct ti_bandgap *bgp, long temp, int *adc)
 {
-	struct ti_bandgap_data *conf = bgp->conf;
+	const struct ti_bandgap_data *conf = bgp->conf;
 	const int *conv_table = bgp->conf->conv_table;
 	int high, low, mid, ret = 0;
 
@@ -726,7 +726,7 @@ int ti_bandgap_set_sensor_data(struct ti_bandgap *bgp, int id, void *data)
 	if (ret)
 		return ret;
 
-	bgp->conf->sensors[id].data = data;
+	bgp->regval[id].data = data;
 
 	return 0;
 }
@@ -745,7 +745,7 @@ void *ti_bandgap_get_sensor_data(struct ti_bandgap *bgp, int id)
 	if (ret)
 		return ERR_PTR(ret);
 
-	return bgp->conf->sensors[id].data;
+	return bgp->regval[id].data;
 }
 
 /***   Helper functions used during device initialization   ***/
@@ -913,6 +913,14 @@ static struct ti_bandgap *ti_bandgap_build(struct platform_device *pdev)
 	if (of_id)
 		bgp->conf = of_id->data;
 
+	/* register shadow for context save and restore */
+	bgp->regval = devm_kzalloc(&pdev->dev, sizeof(*bgp->regval) *
+				   bgp->conf->sensor_count, GFP_KERNEL);
+	if (!bgp) {
+		dev_err(&pdev->dev, "Unable to allocate mem for driver ref\n");
+		return ERR_PTR(-ENOMEM);
+	}
+
 	i = 0;
 	do {
 		void __iomem *chunk;
@@ -1149,7 +1157,7 @@ static int ti_bandgap_save_ctxt(struct ti_bandgap *bgp)
 		struct temp_sensor_registers *tsr;
 		struct temp_sensor_regval *rval;
 
-		rval = &bgp->conf->sensors[i].regval;
+		rval = &bgp->regval[i];
 		tsr = bgp->conf->sensors[i].registers;
 
 		if (TI_BANDGAP_HAS(bgp, MODE_CONFIG))
@@ -1182,7 +1190,7 @@ static int ti_bandgap_restore_ctxt(struct ti_bandgap *bgp)
 		struct temp_sensor_regval *rval;
 		u32 val = 0;
 
-		rval = &bgp->conf->sensors[i].regval;
+		rval = &bgp->regval[i];
 		tsr = bgp->conf->sensors[i].registers;
 
 		if (TI_BANDGAP_HAS(bgp, COUNTER))
diff --git a/drivers/staging/ti-soc-thermal/ti-bandgap.h b/drivers/staging/ti-soc-thermal/ti-bandgap.h
index 00d7596..66bbd07 100644
--- a/drivers/staging/ti-soc-thermal/ti-bandgap.h
+++ b/drivers/staging/ti-soc-thermal/ti-bandgap.h
@@ -30,6 +30,13 @@
 /**
  * DOC: bandgap driver data structure
  * ==================================
+ *
+ *   +----------+----------------+
+ *   | struct temp_sensor_regval |
+ *   +---------------------------+
+ *              * (Array of)
+ *              |
+ *              |
  *   +-------------------+   +-----------------+
  *   | struct ti_bandgap |-->| struct device * |
  *   +--------+----------+   +-----------------+
@@ -44,14 +51,14 @@
  *              * (Array of)
  * +------------+------------------------------------------------------+
  * | +----------+--------------+   +-------------------------+         |
- * | | struct ti_temp_sensor |-->| struct temp_sensor_data |         |
+ * | | struct ti_temp_sensor   |-->| struct temp_sensor_data |         |
  * | +-------------------------+   +------------+------------+         |
  * |            |                                                      |
- * |            +--------------------------+                           |
- * |            V                          V                           |
- * | +----------+- --------------+  +----+-------------------------+   |
- * | | struct temp_sensor_regval |  | struct temp_sensor_registers |   |
- * | +---------------------------+  +------------------------------+   |
+ * |            +                                                      |
+ * |            V                                                      |
+ * | +----------+-------------------+                                  |
+ * | | struct temp_sensor_registers |                                  |
+ * | +------------------------------+                                  |
  * |                                                                   |
  * +-------------------------------------------------------------------+
  *
@@ -190,10 +197,32 @@ struct temp_sensor_data {
 struct ti_bandgap_data;
 
 /**
+ * struct temp_sensor_regval - temperature sensor register values and priv data
+ * @bg_mode_ctrl: temp sensor control register value
+ * @bg_ctrl: bandgap ctrl register value
+ * @bg_counter: bandgap counter value
+ * @bg_threshold: bandgap threshold register value
+ * @tshut_threshold: bandgap tshut register value
+ * @data: private data
+ *
+ * Data structure to save and restore bandgap register set context. Only
+ * required registers are shadowed, when needed.
+ */
+struct temp_sensor_regval {
+	u32			bg_mode_ctrl;
+	u32			bg_ctrl;
+	u32			bg_counter;
+	u32			bg_threshold;
+	u32			tshut_threshold;
+	void			*data;
+};
+
+/**
  * struct ti_bandgap - bandgap device structure
  * @dev: struct device pointer
  * @base: io memory base address
  * @conf: struct with bandgap configuration set (# sensors, conv_table, etc)
+ * @regval: temperature sensor register values
  * @fclock: pointer to functional clock of temperature sensor
  * @div_clk: pointer to divider clock of temperature sensor fclk
  * @bg_mutex: mutex for ti_bandgap structure
@@ -208,7 +237,8 @@ struct ti_bandgap_data;
 struct ti_bandgap {
 	struct device			*dev;
 	void __iomem			*base;
-	struct ti_bandgap_data	*conf;
+	const struct ti_bandgap_data	*conf;
+	struct temp_sensor_regval	*regval;
 	struct clk			*fclock;
 	struct clk			*div_clk;
 	spinlock_t			lock; /* shields this struct */
@@ -218,29 +248,9 @@ struct ti_bandgap {
 };
 
 /**
- * struct temp_sensor_regval - temperature sensor register values
- * @bg_mode_ctrl: temp sensor control register value
- * @bg_ctrl: bandgap ctrl register value
- * @bg_counter: bandgap counter value
- * @bg_threshold: bandgap threshold register value
- * @tshut_threshold: bandgap tshut register value
- *
- * Data structure to save and restore bandgap register set context. Only
- * required registers are shadowed, when needed.
- */
-struct temp_sensor_regval {
-	u32			bg_mode_ctrl;
-	u32			bg_ctrl;
-	u32			bg_counter;
-	u32			bg_threshold;
-	u32			tshut_threshold;
-};
-
-/**
  * struct ti_temp_sensor - bandgap temperature sensor configuration data
  * @ts_data: pointer to struct with thresholds, limits of temperature sensor
  * @registers: pointer to the list of register offsets and bitfields
- * @regval: temperature sensor register values
  * @domain: the name of the domain where the sensor is located
  * @slope: sensor gradient slope info for hotspot extrapolation equation
  * @const: sensor gradient const info for hotspot extrapolation equation
@@ -248,7 +258,6 @@ struct temp_sensor_regval {
  *             with no external influence
  * @constant_pcb: sensor gradient const info for hotspot extrapolation equation
  *             with no external influence
- * @data: private data
  * @register_cooling: function to describe how this sensor is going to be cooled
  * @unregister_cooling: function to release cooling data
  *
@@ -261,14 +270,12 @@ struct temp_sensor_regval {
 struct ti_temp_sensor {
 	struct temp_sensor_data		*ts_data;
 	struct temp_sensor_registers	*registers;
-	struct temp_sensor_regval	regval;
 	char				*domain;
 	/* for hotspot extrapolation */
 	const int			slope;
 	const int			constant;
 	const int			slope_pcb;
 	const int			constant_pcb;
-	void				*data;
 	int (*register_cooling)(struct ti_bandgap *bg_ptr, int id);
 	int (*unregister_cooling)(struct ti_bandgap *bg_ptr, int id);
 };
diff --git a/drivers/staging/ti-soc-thermal/ti-thermal-common.c b/drivers/staging/ti-soc-thermal/ti-thermal-common.c
index fb50e7e..231c549 100644
--- a/drivers/staging/ti-soc-thermal/ti-thermal-common.c
+++ b/drivers/staging/ti-soc-thermal/ti-thermal-common.c
@@ -79,7 +79,7 @@ static inline int ti_thermal_get_temp(struct thermal_zone_device *thermal,
 {
 	struct ti_thermal_data *data = thermal->devdata;
 	struct ti_bandgap *bgp;
-	struct ti_temp_sensor *s;
+	const struct ti_temp_sensor *s;
 	int ret, tmp, pcb_temp, slope, constant;
 
 	if (!data)
-- 
1.7.7.1.488.ge8e1c

