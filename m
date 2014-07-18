Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945997AbaGRTaQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 15:30:16 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:57624 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422824AbaGRTaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 15:30:11 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Chanwoo Choi <cw00.choi@samsung.com>, jic23@kernel.org,
        ch.naveen@samsung.com, mark.rutland@arm.com,
        devicetree@vger.kernel.org, kgene.kim@samsung.com, pawel.moll@arm.com,
        ijc+devicetree@hellion.org.uk, linux-iio@vger.kernel.org,
        t.figa@samsung.com, rdunlap@infradead.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        kyungmin.park@samsung.com, robh+dt@kernel.org, galak@codeaurora.org,
        heiko.stuebner@bq.com, Ben Dooks <ben-linux@fluff.org>
Subject: [PATCH 2/2] iio: exynos-adc: add experimental touchscreen support
Date: Fri, 18 Jul 2014 21:29:28 +0200
Message-ID: <5456679.XxlLIvc3Q6@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <5186890.aLtladpMgD@wuerfel>
References: <1405663186-26464-1-git-send-email-cw00.choi@samsung.com> <5186890.aLtladpMgD@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:7ZRhXk1mJxL3uiAgWvIEbLOCY71N9XHilPPPEMX9O3k
 Fx3QDPV5XSb9A/7v4FwlY6tokg3k7cWU8aGCxVAsYIoO3RanoK
 I+Ugz0OegzWcEgdfBuGdLqn5JtuU6+o4zTZof59fwtLjufSHp1
 rkIXGxLlohkbnLa5SK0Nrz//yO1mDciZ/6Fl040GTat5/pG4Mi
 JRR6k/EnZNIFUa43iCxlnVDOg0wz8m7sUlCjIMB+vDgjbiaCpj
 1n8QAbOm04JhvYDMgn0CBigUDBShUFM+s7hnExG/Txs/w/661A
 ewsXNMoi4lIAD6kRvWjWe55Mfzi37X4Pm3Kb7UB6ntkQ7M8Lyf
 Jy/VNb8mZi0CKTB7QNc4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds support for the touchscreen on Samsung s3c64xx.
The driver is completely untested but shows roughly how
it could be done, following the example of the at91 driver.

Open questions include:

- compared to the old plat-samsung/adc driver, there is
  no support for prioritizing ts over other clients, nor
  for oversampling. From my reading of the code, the
  priorities didn't actually have any effect at all, but
  the oversampling might be needed. Maybe the original
  authors have some insight.

- I simply register the input device from the adc driver
  itself, as the at91 code does. The driver also supports
  sub-nodes, but I don't understand how they are meant
  to be used, so using those might be better.

- The new exynos_read_s3c64xx_ts() function is intentionally
  very similar to the existing exynos_read_raw() functions.
  It should probably be changed, either by merging the two
  into one, or by simplifying the exynos_read_s3c64xx_ts()
  function. This depends a bit on the answers to the questions
  above.

- We probably need to add support for platform_data as well,
  I've skipped this so far.

- Is anybody able to debug this driver on real hardware?
  While it's possible that it actually works, it's more
  likely that I made a few subtle mistakes.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt b/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
index e1b74828f413..4329bf3c3326 100644
--- a/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
+++ b/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
@@ -41,6 +41,10 @@ Required properties:
 				       and compatible ADC block)
 - vdd-supply		VDD input supply.
 
+Optional properties:
+- has-touchscreen:	If present, indicates that a touchscreen is
+			connected an usable.
+
 Note: child nodes can be added for auto probing from device tree.
 
 Example: adding device info in dtsi file
diff --git a/drivers/iio/adc/exynos_adc.c b/drivers/iio/adc/exynos_adc.c
index 5f95638513d2..cf1d9f3e2492 100644
--- a/drivers/iio/adc/exynos_adc.c
+++ b/drivers/iio/adc/exynos_adc.c
@@ -34,6 +34,7 @@
 #include <linux/regulator/consumer.h>
 #include <linux/of_platform.h>
 #include <linux/err.h>
+#include <linux/input.h>
 
 #include <linux/iio/iio.h>
 #include <linux/iio/machine.h>
@@ -103,6 +104,7 @@
 
 /* Bit definitions common for ADC_V1 and ADC_V2 */
 #define ADC_CON_EN_START	(1u << 0)
+#define ADC_DATX_PRESSED	(1u << 15)
 #define ADC_DATX_MASK		0xFFF
 
 #define EXYNOS_ADC_TIMEOUT	(msecs_to_jiffies(100))
@@ -110,16 +112,20 @@
 struct exynos_adc {
 	struct exynos_adc_data	*data;
 	struct device		*dev;
+	struct input_dev	*input;
 	void __iomem		*regs;
 	void __iomem		*enable_reg;
 	struct clk		*clk;
 	struct clk		*sclk;
 	unsigned int		irq;
+	unsigned int		tsirq;
 	struct regulator	*vdd;
 
 	struct completion	completion;
 
+	bool			read_ts;
 	u32			value;
+	u32			value2;
 	unsigned int            version;
 };
 
@@ -390,12 +396,61 @@ static int exynos_read_raw(struct iio_dev *indio_dev,
 	return ret;
 }
 
+static int exynos_read_s3c64xx_ts(struct iio_dev *indio_dev,
+				struct iio_chan_spec const *chan,
+				int *val,
+				int *val2,
+				long mask)
+{
+	struct exynos_adc *info = iio_priv(indio_dev);
+	unsigned long timeout;
+	int ret;
+
+	if (mask != IIO_CHAN_INFO_RAW)
+		return -EINVAL;
+
+	mutex_lock(&indio_dev->mlock);
+	info->read_ts = 1;
+
+	reinit_completion(&info->completion);
+
+	writel(ADC_S3C2410_TSC_PULL_UP_DISABLE | ADC_TSC_AUTOPST,
+	       ADC_V1_TSC(info->regs));
+
+	/* Select the ts channel to be used and Trigger conversion */
+	info->data->start_conv(info, 0);
+
+	timeout = wait_for_completion_timeout
+			(&info->completion, EXYNOS_ADC_TIMEOUT);
+	if (timeout == 0) {
+		dev_warn(&indio_dev->dev, "Conversion timed out! Resetting\n");
+		if (info->data->init_hw)
+			info->data->init_hw(info);
+		ret = -ETIMEDOUT;
+	} else {
+		*val = info->value;
+		*val2 = info->value2;
+		ret = IIO_VAL_INT;
+	}
+
+	info->read_ts = 0;
+	mutex_unlock(&indio_dev->mlock);
+
+	return ret;
+}
+
 static irqreturn_t exynos_adc_isr(int irq, void *dev_id)
 {
 	struct exynos_adc *info = (struct exynos_adc *)dev_id;
 
 	/* Read value */
-	info->value = readl(ADC_V1_DATX(info->regs)) & ADC_DATX_MASK;
+	if (info->read_ts) {
+		info->value = readl(ADC_V1_DATX(info->regs)) & ADC_DATX_MASK;
+		info->value2 = readl(ADC_V1_DATY(info->regs)) & ADC_DATX_MASK;
+		writel(ADC_TSC_WAIT4INT | ADC_S3C2443_TSC_UD_SEN, ADC_V1_TSC(info->regs));
+	} else {
+		info->value = readl(ADC_V1_DATX(info->regs)) & ADC_DATX_MASK;
+	}
 
 	/* clear irq */
 	if (info->data->clear_irq)
@@ -406,6 +461,46 @@ static irqreturn_t exynos_adc_isr(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
+/*
+ * Here we (ab)use a threaded interrupt handler to stay running
+ * for as long as the touchscreen remains pressed, we report
+ * a new event with the latest data and then sleep until the
+ * next timer tick. This mirrors the behavior of the old
+ * driver, with much less code.
+ */
+static irqreturn_t exynos_ts_isr(int irq, void *dev_id)
+{
+	struct exynos_adc *info = dev_id;
+	struct iio_dev *dev = dev_get_drvdata(info->dev);
+	u32 x, y;
+	bool pressed;
+	int ret;
+
+	do {
+		ret =exynos_read_s3c64xx_ts(dev, NULL, &x, &y, IIO_CHAN_INFO_RAW);
+		if (ret == -ETIMEDOUT)
+			break;
+
+		pressed = x & y & ADC_DATX_PRESSED;
+		if (!pressed)
+			break;
+
+		input_report_abs(info->input, ABS_X, x & ADC_DATX_MASK);
+		input_report_abs(info->input, ABS_Y, y & ADC_DATX_MASK);
+		input_report_key(info->input, BTN_TOUCH, 1);
+		input_sync(info->input);
+
+		msleep(1);
+	} while (1);
+
+	input_report_key(info->input, BTN_TOUCH, 0);
+	input_sync(info->input);
+
+	writel(0, ADC_V1_CLRINTPNDNUP(info->regs));
+
+	return IRQ_HANDLED;
+}
+
 static int exynos_adc_reg_access(struct iio_dev *indio_dev,
 			      unsigned reg, unsigned writeval,
 			      unsigned *readval)
@@ -457,12 +552,57 @@ static int exynos_adc_remove_devices(struct device *dev, void *c)
 	return 0;
 }
 
+static int exynos_adc_ts_init(struct exynos_adc *info)
+{
+	int ret;
+
+	info->input = input_allocate_device();
+	if (!info->input)
+		return -ENOMEM;
+
+	info->input->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
+	info->input->keybit[BIT_WORD(BTN_TOUCH)] = BIT_MASK(BTN_TOUCH);
+
+	input_set_abs_params(info->input, ABS_X, 0, 0x3FF, 0, 0);
+	input_set_abs_params(info->input, ABS_Y, 0, 0x3FF, 0, 0);
+
+	/* data from s3c2410_ts driver */
+	info->input->name = "S3C24xx TouchScreen";
+	info->input->id.bustype = BUS_HOST;
+	info->input->id.vendor = 0xDEAD;
+	info->input->id.product = 0xBEEF;
+	info->input->id.version = 0x0200;
+
+	ret = input_register_device(info->input);
+	if (ret) {
+		input_free_device(info->input);
+		goto err;
+	}
+
+	if (info->tsirq > 0)
+		ret = request_threaded_irq(info->irq, NULL, exynos_ts_isr,
+					0, "touchscreen", info);
+	if (ret < 0) {
+		dev_err(info->dev, "failed requesting touchsccreen irq, irq = %d\n",
+							info->irq);
+		goto err_input;
+	}
+
+	return 0;
+
+err_input:
+	input_unregister_device(info->input);
+err:
+	return ret;
+}
+
 static int exynos_adc_probe(struct platform_device *pdev)
 {
 	struct exynos_adc *info = NULL;
 	struct device_node *np = pdev->dev.of_node;
 	struct iio_dev *indio_dev = NULL;
 	struct resource	*mem;
+	bool has_ts;
 	int ret = -ENODEV;
 	int irq;
 
@@ -498,8 +638,14 @@ static int exynos_adc_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev, "no irq resource?\n");
 		return irq;
 	}
-
 	info->irq = irq;
+
+	irq = platform_get_irq(pdev, 1);
+	if (irq == -EPROBE_DEFER)
+		return irq; 
+
+	info->tsirq = irq;
+
 	info->dev = &pdev->dev;
 
 	init_completion(&info->completion);
@@ -565,6 +711,12 @@ static int exynos_adc_probe(struct platform_device *pdev)
 	if (info->data->init_hw)
 		info->data->init_hw(info);
 
+	has_ts = of_property_read_bool(pdev->dev.of_node, "has-touchscreen");
+	if (has_ts)
+		ret = exynos_adc_ts_init(info);
+	if (ret)
+		goto err_iio;
+
 	ret = of_platform_populate(np, exynos_adc_match, NULL, &indio_dev->dev);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "failed adding child nodes\n");
@@ -576,6 +728,11 @@ static int exynos_adc_probe(struct platform_device *pdev)
 err_of_populate:
 	device_for_each_child(&indio_dev->dev, NULL,
 				exynos_adc_remove_devices);
+	if (has_ts) {
+		input_unregister_device(info->input);
+		free_irq(info->tsirq, info);
+	}
+err_iio:
 	iio_device_unregister(indio_dev);
 err_irq:
 	free_irq(info->irq, info);
@@ -595,9 +752,12 @@ static int exynos_adc_remove(struct platform_device *pdev)
 	struct iio_dev *indio_dev = platform_get_drvdata(pdev);
 	struct exynos_adc *info = iio_priv(indio_dev);
 
+	input_free_device(info->input);	
 	device_for_each_child(&indio_dev->dev, NULL,
 				exynos_adc_remove_devices);
 	iio_device_unregister(indio_dev);
+	if (info->tsirq > 0)
+		free_irq(info->tsirq, info);
 	free_irq(info->irq, info);
 	if (info->data->exit_hw)
 		info->data->exit_hw(info);

