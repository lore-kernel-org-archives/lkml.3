Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232AbbATQCN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 11:02:13 -0500
Received: from mail.kmu-office.ch ([178.209.48.109]:44964 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235AbbATQCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 11:02:10 -0500
From: Stefan Agner <stefan@agner.ch>
To: jic23@kernel.org
Cc: shawn.guo@linaro.org, B38611@freescale.com, maitysanchayan@gmail.com,
        linux-iio@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, stefan@agner.ch
Subject: [PATCH 2/3] iio: adc: vf610: implement configurable conversion modes
Date: Tue, 20 Jan 2015 17:02:02 +0100
Message-Id: <1421769723-28677-3-git-send-email-stefan@agner.ch>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1421769723-28677-1-git-send-email-stefan@agner.ch>
References: <1421769723-28677-1-git-send-email-stefan@agner.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support configureable conversion mode through sysfs. So far, the
mode used was low-power, which is enabled by default now. Beside
that, the modes normal and high-speed are selectable as well.

Use the new device tree property which specifies the maximum ADC
conversion clock frequencies. Depending on the mode used, the
available resulting conversion frequency are calcaulated
dynamically.

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
 drivers/iio/adc/vf610_adc.c | 92 ++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 86 insertions(+), 6 deletions(-)

diff --git a/drivers/iio/adc/vf610_adc.c b/drivers/iio/adc/vf610_adc.c
index e63b8e7..fd41d91c 100644
--- a/drivers/iio/adc/vf610_adc.c
+++ b/drivers/iio/adc/vf610_adc.c
@@ -118,15 +118,21 @@ enum average_sel {
 	VF610_ADC_SAMPLE_32,
 };
 
+enum conversion_mode_sel {
+	VF610_ADC_CONV_NORMAL,
+	VF610_ADC_CONV_HIGH_SPEED,
+	VF610_ADC_CONV_LOW_POWER,
+};
+
 struct vf610_adc_feature {
 	enum clk_sel	clk_sel;
 	enum vol_ref	vol_ref;
+	enum conversion_mode_sel conv_mode;
 
 	int	clk_div;
 	int     sample_rate;
 	int	res_mode;
 
-	bool	lpm;
 	bool	calibration;
 	bool	ovwren;
 };
@@ -139,6 +145,8 @@ struct vf610_adc {
 	u32 vref_uv;
 	u32 value;
 	struct regulator *vref;
+
+	u32 max_adck_rate[3];
 	struct vf610_adc_feature adc_feature;
 
 	u32 sample_freq_avail[5];
@@ -146,6 +154,8 @@ struct vf610_adc {
 	struct completion completion;
 };
 
+static const char * const vf610_conv_modes[] = { "normal", "high-speed",
+						 "low-power" };
 static const u32 vf610_hw_avgs[] = { 1, 4, 8, 16, 32 };
 
 #define VF610_ADC_CHAN(_idx, _chan_type) {			\
@@ -186,8 +196,20 @@ static const struct iio_chan_spec vf610_adc_iio_channels[] = {
 
 static inline void vf610_adc_calculate_rates(struct vf610_adc *info)
 {
+	struct vf610_adc_feature *adc_feature = &info->adc_feature;
 	unsigned long adck_rate, ipg_rate = clk_get_rate(info->clk);
-	int i;
+	int divisor, i;
+
+	adck_rate = info->max_adck_rate[adc_feature->conv_mode];
+
+	if (adck_rate) {
+		/* calculate clk divider which is within specification */
+		divisor = ipg_rate / adck_rate;
+		adc_feature->clk_div = 1 << fls(divisor + 1);
+	} else {
+		/* fall-back value using a safe divisor */
+		adc_feature->clk_div = 8;
+	}
 
 	/*
 	 * Calculate ADC sample frequencies
@@ -219,10 +241,8 @@ static inline void vf610_adc_cfg_init(struct vf610_adc *info)
 
 	adc_feature->res_mode = 12;
 	adc_feature->sample_rate = 1;
-	adc_feature->lpm = true;
 
-	/* Use a save ADCK which is below 20MHz on all devices */
-	adc_feature->clk_div = 8;
+	adc_feature->conv_mode = VF610_ADC_CONV_LOW_POWER;
 
 	vf610_adc_calculate_rates(info);
 }
@@ -307,10 +327,12 @@ static void vf610_adc_cfg_set(struct vf610_adc *info)
 	cfg_data = readl(info->regs + VF610_REG_ADC_CFG);
 
 	cfg_data &= ~VF610_ADC_ADLPC_EN;
-	if (adc_feature->lpm)
+	if (adc_feature->conv_mode == VF610_ADC_CONV_LOW_POWER)
 		cfg_data |= VF610_ADC_ADLPC_EN;
 
 	cfg_data &= ~VF610_ADC_ADHSC_EN;
+	if (adc_feature->conv_mode == VF610_ADC_CONV_HIGH_SPEED)
+		cfg_data |= VF610_ADC_ADHSC_EN;
 
 	writel(cfg_data, info->regs + VF610_REG_ADC_CFG);
 }
@@ -466,10 +488,65 @@ static ssize_t vf610_show_samp_freq_avail(struct device *dev,
 	return len;
 }
 
+static ssize_t vf610_read_mode(struct device *dev,
+		struct device_attribute *attr,
+		char *buf)
+{
+	struct iio_dev *indio_dev = dev_to_iio_dev(dev);
+	struct vf610_adc *info = iio_priv(indio_dev);
+
+	return sprintf(buf, "%s\n",
+			vf610_conv_modes[info->adc_feature.conv_mode]);
+}
+
+
+static ssize_t vf610_write_mode(struct device *dev,
+		struct device_attribute *attr,
+		const char *buf,
+		size_t len)
+{
+	struct iio_dev *indio_dev = dev_to_iio_dev(dev);
+	struct vf610_adc *info = iio_priv(indio_dev);
+	int i, mode = -EINVAL;
+
+	mutex_lock(&indio_dev->mlock);
+	if (iio_buffer_enabled(indio_dev)) {
+		mutex_unlock(&indio_dev->mlock);
+		return -EBUSY;
+	}
+	mutex_unlock(&indio_dev->mlock);
+
+	for (i = 0; i < ARRAY_SIZE(vf610_conv_modes); i++) {
+		if (!strcmp(vf610_conv_modes[i], buf)) {
+			mode = i;
+			break;
+		}
+	}
+
+	if (mode < 0)
+		return mode;
+
+	mutex_lock(&indio_dev->mlock);
+	info->adc_feature.conv_mode = mode;
+	vf610_adc_calculate_rates(info);
+	vf610_adc_hw_init(info);
+	mutex_unlock(&indio_dev->mlock);
+
+	return len;
+}
+
 static IIO_DEV_ATTR_SAMP_FREQ_AVAIL(vf610_show_samp_freq_avail);
 
+static IIO_CONST_ATTR_NAMED(conversion_mode_available,
+	conversion_mode_available, "normal high-speed low-power");
+
+IIO_DEVICE_ATTR(conversion_mode, S_IWUSR | S_IRUGO, vf610_read_mode,
+	vf610_write_mode, 0);
+
 static struct attribute *vf610_attributes[] = {
 	&iio_dev_attr_sampling_frequency_available.dev_attr.attr,
+	&iio_const_attr_conversion_mode_available.dev_attr.attr,
+	&iio_dev_attr_conversion_mode.dev_attr.attr,
 	NULL
 };
 
@@ -654,6 +731,9 @@ static int vf610_adc_probe(struct platform_device *pdev)
 
 	info->vref_uv = regulator_get_voltage(info->vref);
 
+	of_property_read_u32_array(pdev->dev.of_node, "fsl,adck-max-frequency",
+			info->max_adck_rate, 3);
+
 	platform_set_drvdata(pdev, indio_dev);
 
 	init_completion(&info->completion);
-- 
2.2.2

