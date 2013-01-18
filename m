Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755848Ab3ARTy3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 14:54:29 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:44444 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755640Ab3ARTxG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 14:53:06 -0500
From: Nishanth Menon <nm@ti.com>
To: linux-pm <linux-pm@vger.kernel.org>
CC: Rafael <rjw@sisk.pl>, Kevin <khilman@deeprootsystems.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        lkml <linux-kernel@vger.kernel.org>, lo <linux-omap@vger.kernel.org>,
        Jack <jack@embed.me.uk>, Alexander <holler@ahsoftware.de>,
        Nishanth Menon <nm@ti.com>
Subject: [PATCH 4/4] PM / devfreq: exynos4_bus: honor RCU lock usage
Date: Fri, 18 Jan 2013 13:52:35 -0600
Message-ID: <1358538755-29109-5-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358538755-29109-1-git-send-email-nm@ti.com>
References: <1358538755-29109-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OPP pointers cannot be expected to be valid beyond the boundary
of rcu_read_lock and rcu_read_unlock. Unfortunately, the current
exynos4 busfreq driver does not honor the usage constraint and stores
the OPP pointer in struct busfreq_data. This could potentially
become invalid later such as: across devfreq opp change decisions,
resulting in unpredictable behavior.

To fix this, we introduce a busfreq specific busfreq_opp_info
structure which is used to handle OPP information. OPP information
is de-referenced to voltage and frequency pairs as needed into
busfreq_opp_info structure and used as needed.

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 drivers/devfreq/exynos4_bus.c |   94 +++++++++++++++++++++++++++++------------
 1 file changed, 67 insertions(+), 27 deletions(-)

diff --git a/drivers/devfreq/exynos4_bus.c b/drivers/devfreq/exynos4_bus.c
index 80c745e..6d72f12 100644
--- a/drivers/devfreq/exynos4_bus.c
+++ b/drivers/devfreq/exynos4_bus.c
@@ -73,6 +73,16 @@ enum busclk_level_idx {
 #define EX4210_LV_NUM	(LV_2 + 1)
 #define EX4x12_LV_NUM	(LV_4 + 1)
 
+/**
+ * struct busfreq_opp_info - opp information for bus
+ * @rate:	Frequency in hertz
+ * @volt:	Voltage in microvolts corresponding to this OPP
+ */
+struct busfreq_opp_info {
+	unsigned long rate;
+	unsigned long volt;
+};
+
 struct busfreq_data {
 	enum exynos4_busf_type type;
 	struct device *dev;
@@ -80,7 +90,7 @@ struct busfreq_data {
 	bool disabled;
 	struct regulator *vdd_int;
 	struct regulator *vdd_mif; /* Exynos4412/4212 only */
-	struct opp *curr_opp;
+	struct busfreq_opp_info curr_oppinfo;
 	struct exynos4_ppmu dmc[2];
 
 	struct notifier_block pm_notifier;
@@ -296,13 +306,14 @@ static unsigned int exynos4x12_clkdiv_sclkip[][3] = {
 };
 
 
-static int exynos4210_set_busclk(struct busfreq_data *data, struct opp *opp)
+static int exynos4210_set_busclk(struct busfreq_data *data,
+				 struct busfreq_opp_info *oppi)
 {
 	unsigned int index;
 	unsigned int tmp;
 
 	for (index = LV_0; index < EX4210_LV_NUM; index++)
-		if (opp_get_freq(opp) == exynos4210_busclk_table[index].clk)
+		if (oppi->rate == exynos4210_busclk_table[index].clk)
 			break;
 
 	if (index == EX4210_LV_NUM)
@@ -361,13 +372,14 @@ static int exynos4210_set_busclk(struct busfreq_data *data, struct opp *opp)
 	return 0;
 }
 
-static int exynos4x12_set_busclk(struct busfreq_data *data, struct opp *opp)
+static int exynos4x12_set_busclk(struct busfreq_data *data,
+				 struct busfreq_opp_info *oppi)
 {
 	unsigned int index;
 	unsigned int tmp;
 
 	for (index = LV_0; index < EX4x12_LV_NUM; index++)
-		if (opp_get_freq(opp) == exynos4x12_mifclk_table[index].clk)
+		if (oppi->rate == exynos4x12_mifclk_table[index].clk)
 			break;
 
 	if (index == EX4x12_LV_NUM)
@@ -576,11 +588,12 @@ static int exynos4x12_get_intspec(unsigned long mifclk)
 	return -EINVAL;
 }
 
-static int exynos4_bus_setvolt(struct busfreq_data *data, struct opp *opp,
-			       struct opp *oldopp)
+static int exynos4_bus_setvolt(struct busfreq_data *data,
+			       struct busfreq_opp_info *oppi,
+			       struct busfreq_opp_info *oldoppi)
 {
 	int err = 0, tmp;
-	unsigned long volt = opp_get_voltage(opp);
+	unsigned long volt = oppi->volt;
 
 	switch (data->type) {
 	case TYPE_BUSF_EXYNOS4210:
@@ -595,11 +608,11 @@ static int exynos4_bus_setvolt(struct busfreq_data *data, struct opp *opp,
 		if (err)
 			break;
 
-		tmp = exynos4x12_get_intspec(opp_get_freq(opp));
+		tmp = exynos4x12_get_intspec(oppi->rate);
 		if (tmp < 0) {
 			err = tmp;
 			regulator_set_voltage(data->vdd_mif,
-					      opp_get_voltage(oldopp),
+					      oldoppi->volt,
 					      MAX_SAFEVOLT);
 			break;
 		}
@@ -609,7 +622,7 @@ static int exynos4_bus_setvolt(struct busfreq_data *data, struct opp *opp,
 		/*  Try to recover */
 		if (err)
 			regulator_set_voltage(data->vdd_mif,
-					      opp_get_voltage(oldopp),
+					      oldoppi->volt,
 					      MAX_SAFEVOLT);
 		break;
 	default:
@@ -626,17 +639,26 @@ static int exynos4_bus_target(struct device *dev, unsigned long *_freq,
 	struct platform_device *pdev = container_of(dev, struct platform_device,
 						    dev);
 	struct busfreq_data *data = platform_get_drvdata(pdev);
-	struct opp *opp = devfreq_recommended_opp(dev, _freq, flags);
-	unsigned long freq = opp_get_freq(opp);
-	unsigned long old_freq = opp_get_freq(data->curr_opp);
+	struct opp *opp;
+	unsigned long freq;
+	unsigned long old_freq = data->curr_oppinfo.rate;
+	struct busfreq_opp_info	new_oppinfo;
 
-	if (IS_ERR(opp))
+	rcu_read_lock();
+	opp = devfreq_recommended_opp(dev, _freq, flags);
+	if (IS_ERR(opp)) {
+		rcu_read_unlock();
 		return PTR_ERR(opp);
+	}
+	new_oppinfo.rate = opp_get_freq(opp);
+	new_oppinfo.volt = opp_get_voltage(opp);
+	rcu_read_unlock();
+	freq = new_oppinfo.rate;
 
 	if (old_freq == freq)
 		return 0;
 
-	dev_dbg(dev, "targetting %lukHz %luuV\n", freq, opp_get_voltage(opp));
+	dev_dbg(dev, "targetting %lukHz %luuV\n", freq, new_oppinfo.volt);
 
 	mutex_lock(&data->lock);
 
@@ -644,17 +666,18 @@ static int exynos4_bus_target(struct device *dev, unsigned long *_freq,
 		goto out;
 
 	if (old_freq < freq)
-		err = exynos4_bus_setvolt(data, opp, data->curr_opp);
+		err = exynos4_bus_setvolt(data, &new_oppinfo,
+					  &data->curr_oppinfo);
 	if (err)
 		goto out;
 
 	if (old_freq != freq) {
 		switch (data->type) {
 		case TYPE_BUSF_EXYNOS4210:
-			err = exynos4210_set_busclk(data, opp);
+			err = exynos4210_set_busclk(data, &new_oppinfo);
 			break;
 		case TYPE_BUSF_EXYNOS4x12:
-			err = exynos4x12_set_busclk(data, opp);
+			err = exynos4x12_set_busclk(data, &new_oppinfo);
 			break;
 		default:
 			err = -EINVAL;
@@ -664,11 +687,12 @@ static int exynos4_bus_target(struct device *dev, unsigned long *_freq,
 		goto out;
 
 	if (old_freq > freq)
-		err = exynos4_bus_setvolt(data, opp, data->curr_opp);
+		err = exynos4_bus_setvolt(data, &new_oppinfo,
+					  &data->curr_oppinfo);
 	if (err)
 		goto out;
 
-	data->curr_opp = opp;
+	data->curr_oppinfo = new_oppinfo;
 out:
 	mutex_unlock(&data->lock);
 	return err;
@@ -702,7 +726,7 @@ static int exynos4_bus_get_dev_status(struct device *dev,
 
 	exynos4_read_ppmu(data);
 	busier_dmc = exynos4_get_busier_dmc(data);
-	stat->current_frequency = opp_get_freq(data->curr_opp);
+	stat->current_frequency = data->curr_oppinfo.rate;
 
 	if (busier_dmc)
 		addr = S5P_VA_DMC1;
@@ -933,6 +957,7 @@ static int exynos4_busfreq_pm_notifier_event(struct notifier_block *this,
 	struct busfreq_data *data = container_of(this, struct busfreq_data,
 						 pm_notifier);
 	struct opp *opp;
+	struct busfreq_opp_info	new_oppinfo;
 	unsigned long maxfreq = ULONG_MAX;
 	int err = 0;
 
@@ -943,18 +968,29 @@ static int exynos4_busfreq_pm_notifier_event(struct notifier_block *this,
 
 		data->disabled = true;
 
+		rcu_read_lock();
 		opp = opp_find_freq_floor(data->dev, &maxfreq);
+		if (IS_ERR(opp)) {
+			rcu_read_unlock();
+			dev_err(data->dev, "%s: unable to find a min freq\n",
+				__func__);
+			return PTR_ERR(opp);
+		}
+		new_oppinfo.rate = opp_get_freq(opp);
+		new_oppinfo.volt = opp_get_voltage(opp);
+		rcu_read_unlock();
 
-		err = exynos4_bus_setvolt(data, opp, data->curr_opp);
+		err = exynos4_bus_setvolt(data, &new_oppinfo,
+					  &data->curr_oppinfo);
 		if (err)
 			goto unlock;
 
 		switch (data->type) {
 		case TYPE_BUSF_EXYNOS4210:
-			err = exynos4210_set_busclk(data, opp);
+			err = exynos4210_set_busclk(data, &new_oppinfo);
 			break;
 		case TYPE_BUSF_EXYNOS4x12:
-			err = exynos4x12_set_busclk(data, opp);
+			err = exynos4x12_set_busclk(data, &new_oppinfo);
 			break;
 		default:
 			err = -EINVAL;
@@ -962,7 +998,7 @@ static int exynos4_busfreq_pm_notifier_event(struct notifier_block *this,
 		if (err)
 			goto unlock;
 
-		data->curr_opp = opp;
+		data->curr_oppinfo = new_oppinfo;
 unlock:
 		mutex_unlock(&data->lock);
 		if (err)
@@ -1027,13 +1063,17 @@ static int exynos4_busfreq_probe(struct platform_device *pdev)
 		}
 	}
 
+	rcu_read_lock();
 	opp = opp_find_freq_floor(dev, &exynos4_devfreq_profile.initial_freq);
 	if (IS_ERR(opp)) {
+		rcu_read_unlock();
 		dev_err(dev, "Invalid initial frequency %lu kHz.\n",
 			exynos4_devfreq_profile.initial_freq);
 		return PTR_ERR(opp);
 	}
-	data->curr_opp = opp;
+	data->curr_oppinfo.rate = opp_get_freq(opp);
+	data->curr_oppinfo.volt = opp_get_voltage(opp);
+	rcu_read_unlock();
 
 	platform_set_drvdata(pdev, data);
 
-- 
1.7.9.5

