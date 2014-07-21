Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671AbaGUK0q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 06:26:46 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:60452 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754410AbaGUK0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 06:26:44 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jonathan Cameron <jic23@kernel.org>, linux-arm-kernel@lists.infradead.org,
        Chanwoo Choi <cw00.choi@samsung.com>, ch.naveen@samsung.com,
        mark.rutland@arm.com, devicetree@vger.kernel.org,
        kgene.kim@samsung.com, pawel.moll@arm.com,
        ijc+devicetree@hellion.org.uk, linux-iio@vger.kernel.org,
        t.figa@samsung.com, rdunlap@infradead.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        kyungmin.park@samsung.com, robh+dt@kernel.org, galak@codeaurora.org,
        heiko.stuebner@bq.com, Ben Dooks <ben-linux@fluff.org>,
        linux-input <linux-input@vger.kernel.org>
Subject: Re: [PATCH 2/2] iio: exynos-adc: add experimental touchscreen support
Date: Mon, 21 Jul 2014 12:26:24 +0200
Message-ID: <6295669.xsr4x9Lmj1@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <5158672.dMAnnUQc7Z@wuerfel>
References: <1405663186-26464-1-git-send-email-cw00.choi@samsung.com> <20140720202842.GB18347@core.coreip.homeip.net> <5158672.dMAnnUQc7Z@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:uX6SVjxHrUcyaO2+705GyCCKN/ubEni5Shyee3/pbhm
 ekf0Ez6J7cxqW5sH4PwFS0eLZ628xBteb/Lh9y/JBeFYVlK/KD
 v1+wjdictE0U2Vmib+RTIKYHEw8CEVvfECFXw3afZaxK0kJKOd
 maj8JqpVfXc2Q2rJCRvHQ/ob/4H4qFLwohJ9jtHEemxc/0qWZY
 +R3LIExr5MN61VC7GKrpweisntOcIU9m9VRfcpf/6wXjWNG/KB
 Z+I5uPZUxYmZJUXEN/e6xRrqnHwJofmJS56hdWvdsPd8qTPEjD
 JJuq0g2JuovzqiqWru4r0Q3S8Y9H5jlLl2iF4N75zKfKAQwg8d
 O0qcBh4R3OmAriotoSFY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 July 2014 12:23:58 Arnd Bergmann wrote:
> 
> Thanks a lot for the review! I'll send out the new version after some build testing.

Here are the changes I did to the adc driver based on the review comments.
I'll start a new thread for the updated version that includes the changes.

diff --git a/drivers/iio/adc/exynos_adc.c b/drivers/iio/adc/exynos_adc.c
index 3d2caea05977..823d7ebc7f52 100644
--- a/drivers/iio/adc/exynos_adc.c
+++ b/drivers/iio/adc/exynos_adc.c
@@ -67,6 +67,9 @@
 
 #define ADC_S3C2410_CON_SELMUX(x) (((x)&0x7)<<3)
 
+/* touch screen always uses channel 0 */
+#define ADC_S3C2410_MUX_TS	0
+
 /* ADCTSC Register Bits */
 #define ADC_S3C2443_TSC_UD_SEN		(1u << 8)
 #define ADC_S3C2410_TSC_YM_SEN		(1u << 7)
@@ -106,6 +109,7 @@
 #define ADC_CON_EN_START	(1u << 0)
 #define ADC_DATX_PRESSED	(1u << 15)
 #define ADC_DATX_MASK		0xFFF
+#define ADC_DATY_MASK		0xFFF
 
 #define EXYNOS_ADC_TIMEOUT	(msecs_to_jiffies(100))
 
@@ -123,10 +127,12 @@ struct exynos_adc {
 
 	struct completion	completion;
 
-	bool			read_ts;
 	u32			value;
-	u32			value2;
 	unsigned int            version;
+
+	bool			read_ts;
+	u32			ts_x;
+	u32			ts_y;
 };
 
 struct exynos_adc_data {
@@ -396,21 +402,14 @@ static int exynos_read_raw(struct iio_dev *indio_dev,
 	return ret;
 }
 
-static int exynos_read_s3c64xx_ts(struct iio_dev *indio_dev,
-				struct iio_chan_spec const *chan,
-				int *val,
-				int *val2,
-				long mask)
+static int exynos_read_s3c64xx_ts(struct iio_dev *indio_dev, int *x, int *y)
 {
 	struct exynos_adc *info = iio_priv(indio_dev);
 	unsigned long timeout;
 	int ret;
 
-	if (mask != IIO_CHAN_INFO_RAW)
-		return -EINVAL;
-
 	mutex_lock(&indio_dev->mlock);
-	info->read_ts = 1;
+	info->read_ts = true;
 
 	reinit_completion(&info->completion);
 
@@ -418,7 +417,7 @@ static int exynos_read_s3c64xx_ts(struct iio_dev *indio_dev,
 	       ADC_V1_TSC(info->regs));
 
 	/* Select the ts channel to be used and Trigger conversion */
-	info->data->start_conv(info, 0);
+	info->data->start_conv(info, ADC_S3C2410_MUX_TS);
 
 	timeout = wait_for_completion_timeout
 			(&info->completion, EXYNOS_ADC_TIMEOUT);
@@ -428,12 +427,12 @@ static int exynos_read_s3c64xx_ts(struct iio_dev *indio_dev,
 			info->data->init_hw(info);
 		ret = -ETIMEDOUT;
 	} else {
-		*val = info->value;
-		*val2 = info->value2;
-		ret = IIO_VAL_INT;
+		*x = info->ts_x;
+		*y = info->ts_y;
+		ret = 0;
 	}
 
-	info->read_ts = 0;
+	info->read_ts = false;
 	mutex_unlock(&indio_dev->mlock);
 
 	return ret;
@@ -445,8 +444,8 @@ static irqreturn_t exynos_adc_isr(int irq, void *dev_id)
 
 	/* Read value */
 	if (info->read_ts) {
-		info->value = readl(ADC_V1_DATX(info->regs)) & ADC_DATX_MASK;
-		info->value2 = readl(ADC_V1_DATY(info->regs)) & ADC_DATX_MASK;
+		info->ts_x = readl(ADC_V1_DATX(info->regs));
+		info->ts_y = readl(ADC_V1_DATY(info->regs));
 		writel(ADC_TSC_WAIT4INT | ADC_S3C2443_TSC_UD_SEN, ADC_V1_TSC(info->regs));
 	} else {
 		info->value = readl(ADC_V1_DATX(info->regs)) & ADC_DATX_MASK;
@@ -477,7 +476,7 @@ static irqreturn_t exynos_ts_isr(int irq, void *dev_id)
 	int ret;
 
 	do {
-		ret =exynos_read_s3c64xx_ts(dev, NULL, &x, &y, IIO_CHAN_INFO_RAW);
+		ret = exynos_read_s3c64xx_ts(dev, &x, &y);
 		if (ret == -ETIMEDOUT)
 			break;
 
@@ -486,11 +485,15 @@ static irqreturn_t exynos_ts_isr(int irq, void *dev_id)
 			break;
 
 		input_report_abs(info->input, ABS_X, x & ADC_DATX_MASK);
-		input_report_abs(info->input, ABS_Y, y & ADC_DATX_MASK);
+		input_report_abs(info->input, ABS_Y, y & ADC_DATY_MASK);
 		input_report_key(info->input, BTN_TOUCH, 1);
 		input_sync(info->input);
 
 		msleep(1);
+
+		/* device may have been closed while touched */
+		if (!info->input->users)
+			return IRQ_HANDLED;
 	} while (1);
 
 	input_report_key(info->input, BTN_TOUCH, 0);
@@ -552,10 +555,28 @@ static int exynos_adc_remove_devices(struct device *dev, void *c)
 	return 0;
 }
 
+static int exynos_adc_ts_open(struct input_dev *dev)
+{
+	struct exynos_adc *info = input_get_drvdata(dev);
+
+	return request_threaded_irq(info->tsirq, NULL, exynos_ts_isr,
+				    0, "touchscreen", info);
+}
+
+static void exynos_adc_ts_close(struct input_dev *dev)
+{
+	struct exynos_adc *info = input_get_drvdata(dev);
+
+	free_irq(info->tsirq, info);
+}
+
 static int exynos_adc_ts_init(struct exynos_adc *info)
 {
 	int ret;
 
+	if (info->tsirq <= 0)
+		return -ENODEV;
+
 	info->input = input_allocate_device();
 	if (!info->input)
 		return -ENOMEM;
@@ -566,33 +587,17 @@ static int exynos_adc_ts_init(struct exynos_adc *info)
 	input_set_abs_params(info->input, ABS_X, 0, 0x3FF, 0, 0);
 	input_set_abs_params(info->input, ABS_Y, 0, 0x3FF, 0, 0);
 
-	/* data from s3c2410_ts driver */
 	info->input->name = "S3C24xx TouchScreen";
 	info->input->id.bustype = BUS_HOST;
-	info->input->id.vendor = 0xDEAD;
-	info->input->id.product = 0xBEEF;
-	info->input->id.version = 0x0200;
+	info->input->open = exynos_adc_ts_open;
+	info->input->close = exynos_adc_ts_close;
+	
+	input_set_drvdata(info->input, info);
 
 	ret = input_register_device(info->input);
-	if (ret) {
+	if (ret)
 		input_free_device(info->input);
-		goto err;
-	}
-
-	if (info->tsirq > 0)
-		ret = request_threaded_irq(info->irq, NULL, exynos_ts_isr,
-					0, "touchscreen", info);
-	if (ret < 0) {
-		dev_err(info->dev, "failed requesting touchsccreen irq, irq = %d\n",
-							info->irq);
-		goto err_input;
-	}
-
-	return 0;
 
-err_input:
-	input_unregister_device(info->input);
-err:
 	return ret;
 }
 
@@ -602,7 +607,7 @@ static int exynos_adc_probe(struct platform_device *pdev)
 	struct device_node *np = pdev->dev.of_node;
 	struct iio_dev *indio_dev = NULL;
 	struct resource	*mem;
-	bool has_ts;
+	bool has_ts = false;
 	int ret = -ENODEV;
 	int irq;
 
@@ -711,7 +716,10 @@ static int exynos_adc_probe(struct platform_device *pdev)
 	if (info->data->init_hw)
 		info->data->init_hw(info);
 
-	has_ts = of_property_read_bool(pdev->dev.of_node, "has-touchscreen");
+	/* leave out any TS related code if unreachable */
+	if (IS_BUILTIN(CONFIG_INPUT) ||
+	    (IS_MODULE(CONFIG_INPUT) && config_enabled(MODULE)))
+		has_ts = of_property_read_bool(pdev->dev.of_node, "has-touchscreen");
 	if (has_ts)
 		ret = exynos_adc_ts_init(info);
 	if (ret)
@@ -752,7 +760,7 @@ static int exynos_adc_remove(struct platform_device *pdev)
 	struct iio_dev *indio_dev = platform_get_drvdata(pdev);
 	struct exynos_adc *info = iio_priv(indio_dev);
 
-	input_free_device(info->input);	
+	input_unregister_device(info->input);	
 	device_for_each_child(&indio_dev->dev, NULL,
 				exynos_adc_remove_devices);
 	iio_device_unregister(indio_dev);

