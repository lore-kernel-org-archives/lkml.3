Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411AbaBWWIX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 17:08:23 -0500
Received: from ring0.de ([5.45.105.125]:59270 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752312AbaBWWIU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 17:08:20 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
From: Sebastian Reichel <sre@debian.org>
To: Sebastian Reichel <sre@ring0.de>, Marek Belisko <marek@goldelico.com>,
        Jonathan Cameron <jic23@kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-iio@vger.kernel.org,
        Sebastian Reichel <sre@debian.org>
Subject: [RFCv2 2/5] mfd: twl4030-madc: Add DT support and convert to IIO framework
Date: Sun, 23 Feb 2014 23:07:48 +0100
Message-Id: <1393193271-16717-3-git-send-email-sre@debian.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1393193271-16717-1-git-send-email-sre@debian.org>
References: <20140223220140.GA1258@earth.universe>
 <1393193271-16717-1-git-send-email-sre@debian.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This converts twl4030-madc module to use the Industrial IO ADC
framework and adds device tree support.

Signed-off-by: Sebastian Reichel <sre@debian.org>
---
 drivers/mfd/twl4030-madc.c | 121 ++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 114 insertions(+), 7 deletions(-)

diff --git a/drivers/mfd/twl4030-madc.c b/drivers/mfd/twl4030-madc.c
index 5458561..5e67c75 100644
--- a/drivers/mfd/twl4030-madc.c
+++ b/drivers/mfd/twl4030-madc.c
@@ -47,6 +47,8 @@
 #include <linux/gfp.h>
 #include <linux/err.h>
 
+#include <linux/iio/iio.h>
+
 /*
  * struct twl4030_madc_data - a container for madc info
  * @dev - pointer to device structure for madc
@@ -59,10 +61,73 @@ struct twl4030_madc_data {
 	struct device *dev;
 	struct mutex lock;	/* mutex protecting this data structure */
 	struct twl4030_madc_request requests[TWL4030_MADC_NUM_METHODS];
+	bool use_second_irq;
 	int imr;
 	int isr;
 };
 
+static int twl4030_madc_read(struct iio_dev *iio_dev,
+			     const struct iio_chan_spec *chan,
+			     int *val, int *val2, long mask)
+{
+	struct twl4030_madc_data *madc = iio_priv(iio_dev);
+	struct twl4030_madc_request req;
+	int channel = chan->channel;
+	int ret;
+
+	req.method = madc->use_second_irq ? TWL4030_MADC_SW2 : TWL4030_MADC_SW1;
+
+	req.channels = BIT(channel);
+	req.active = 0;
+	req.func_cb = NULL;
+	req.raw = !(mask & IIO_CHAN_INFO_PROCESSED);
+	req.do_avg = !!(mask & IIO_CHAN_INFO_AVERAGE_RAW);
+
+	ret = twl4030_madc_conversion(&req);
+	if (ret < 0)
+		return ret;
+
+	*val = req.rbuf[channel];
+
+	return IIO_VAL_INT;
+}
+
+static const struct iio_info twl4030_madc_iio_info = {
+	.read_raw = &twl4030_madc_read,
+	.driver_module = THIS_MODULE,
+};
+
+#define TWL4030_ADC_CHANNEL(_channel, _type, _name, _mask) {	\
+	.type = _type,					\
+	.channel = _channel,				\
+	.info_mask_separate = BIT(IIO_CHAN_INFO_RAW) |  \
+			      BIT(IIO_CHAN_INFO_AVERAGE_RAW) | \
+			      _mask,			\
+	.datasheet_name = _name,			\
+	.indexed = 1,					\
+}
+
+static const struct iio_chan_spec twl4030_madc_iio_channels[] = {
+	TWL4030_ADC_CHANNEL(0, IIO_VOLTAGE, "ADCIN0", 0),
+	TWL4030_ADC_CHANNEL(1, IIO_TEMP, "ADCIN1",
+		BIT(IIO_CHAN_INFO_PROCESSED)),
+	TWL4030_ADC_CHANNEL(2, IIO_VOLTAGE, "ADCIN2", 0),
+	TWL4030_ADC_CHANNEL(3, IIO_VOLTAGE, "ADCIN3", 0),
+	TWL4030_ADC_CHANNEL(4, IIO_VOLTAGE, "ADCIN4", 0),
+	TWL4030_ADC_CHANNEL(5, IIO_VOLTAGE, "ADCIN5", 0),
+	TWL4030_ADC_CHANNEL(6, IIO_VOLTAGE, "ADCIN6", 0),
+	TWL4030_ADC_CHANNEL(7, IIO_VOLTAGE, "ADCIN7", 0),
+	TWL4030_ADC_CHANNEL(8, IIO_VOLTAGE, "ADCIN8", 0),
+	TWL4030_ADC_CHANNEL(9, IIO_VOLTAGE, "ADCIN9", 0),
+	TWL4030_ADC_CHANNEL(10, IIO_CURRENT, "ADCIN10",
+		BIT(IIO_CHAN_INFO_PROCESSED)),
+	TWL4030_ADC_CHANNEL(11, IIO_VOLTAGE, "ADCIN11", 0),
+	TWL4030_ADC_CHANNEL(12, IIO_VOLTAGE, "ADCIN12", 0),
+	TWL4030_ADC_CHANNEL(13, IIO_VOLTAGE, "ADCIN13", 0),
+	TWL4030_ADC_CHANNEL(14, IIO_VOLTAGE, "ADCIN14", 0),
+	TWL4030_ADC_CHANNEL(15, IIO_VOLTAGE, "ADCIN15", 0),
+};
+
 static struct twl4030_madc_data *twl4030_madc;
 
 struct twl4030_prescale_divider_ratios {
@@ -702,28 +767,50 @@ static int twl4030_madc_probe(struct platform_device *pdev)
 {
 	struct twl4030_madc_data *madc;
 	struct twl4030_madc_platform_data *pdata = dev_get_platdata(&pdev->dev);
+	struct device_node *np = pdev->dev.of_node;
 	int irq, ret;
 	u8 regval;
+	struct iio_dev *iio_dev = NULL;
 
-	if (!pdata) {
+	if (!pdata && !np) {
 		dev_err(&pdev->dev, "platform_data not available\n");
 		return -EINVAL;
 	}
-	madc = devm_kzalloc(&pdev->dev, sizeof(*madc), GFP_KERNEL);
-	if (!madc)
+
+	iio_dev = devm_iio_device_alloc(&pdev->dev,
+					sizeof(struct twl4030_madc_data));
+	if (!iio_dev) {
+		dev_err(&pdev->dev, "failed allocating iio device\n");
 		return -ENOMEM;
+	}
 
+	madc = iio_priv(iio_dev);
 	madc->dev = &pdev->dev;
 
+	iio_dev->name = dev_name(&pdev->dev);
+	iio_dev->dev.parent = &pdev->dev;
+	iio_dev->dev.of_node = pdev->dev.of_node;
+	iio_dev->info = &twl4030_madc_iio_info;
+	iio_dev->modes = INDIO_DIRECT_MODE;
+	iio_dev->channels = twl4030_madc_iio_channels;
+	iio_dev->num_channels = 16;
+
 	/*
 	 * Phoenix provides 2 interrupt lines. The first one is connected to
 	 * the OMAP. The other one can be connected to the other processor such
 	 * as modem. Hence two separate ISR and IMR registers.
 	 */
-	madc->imr = (pdata->irq_line == 1) ?
+	if (pdata)
+		madc->use_second_irq = pdata->irq_line != 1;
+	else
+		madc->use_second_irq = of_property_read_bool(np,
+				       "ti,system-uses-second-madc-irq");
+
+	madc->imr = (madc->use_second_irq == 1) ?
 	    TWL4030_MADC_IMR1 : TWL4030_MADC_IMR2;
-	madc->isr = (pdata->irq_line == 1) ?
+	madc->isr = (madc->use_second_irq == 1) ?
 	    TWL4030_MADC_ISR1 : TWL4030_MADC_ISR2;
+
 	ret = twl4030_madc_set_power(madc, 1);
 	if (ret < 0)
 		return ret;
@@ -768,7 +855,7 @@ static int twl4030_madc_probe(struct platform_device *pdev)
 		}
 	}
 
-	platform_set_drvdata(pdev, madc);
+	platform_set_drvdata(pdev, iio_dev);
 	mutex_init(&madc->lock);
 
 	irq = platform_get_irq(pdev, 0);
@@ -780,7 +867,15 @@ static int twl4030_madc_probe(struct platform_device *pdev)
 		goto err_i2c;
 	}
 	twl4030_madc = madc;
+
+	ret = iio_device_register(iio_dev);
+	if (ret) {
+		dev_dbg(&pdev->dev, "could not register iio device\n");
+		goto err_i2c;
+	}
+
 	return 0;
+
 err_i2c:
 	twl4030_madc_set_current_generator(madc, 0, 0);
 err_current_generator:
@@ -790,20 +885,32 @@ err_current_generator:
 
 static int twl4030_madc_remove(struct platform_device *pdev)
 {
-	struct twl4030_madc_data *madc = platform_get_drvdata(pdev);
+	struct iio_dev *iio_dev = platform_get_drvdata(pdev);
+	struct twl4030_madc_data *madc = iio_priv(iio_dev);
 
 	twl4030_madc_set_current_generator(madc, 0, 0);
 	twl4030_madc_set_power(madc, 0);
 
+	iio_device_unregister(iio_dev);
+
 	return 0;
 }
 
+#ifdef CONFIG_OF
+static const struct of_device_id twl_madc_of_match[] = {
+	{.compatible = "ti,twl4030-madc", },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, twl_madc_of_match);
+#endif
+
 static struct platform_driver twl4030_madc_driver = {
 	.probe = twl4030_madc_probe,
 	.remove = twl4030_madc_remove,
 	.driver = {
 		   .name = "twl4030_madc",
 		   .owner = THIS_MODULE,
+		   .of_match_table = of_match_ptr(twl_madc_of_match),
 		   },
 };
 
-- 
1.8.5.3

