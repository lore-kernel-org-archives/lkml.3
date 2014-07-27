Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699AbaG0VLS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 17:11:18 -0400
Received: from mout.gmx.net ([212.227.17.20]:53536 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752551AbaG0VLQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 17:11:16 -0400
Message-ID: <53D56ABD.8080808@gmx.de>
Date: Sun, 27 Jul 2014 23:10:21 +0200
From: Hartmut Knaack <knaack.h@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:29.0) Gecko/20100101 Firefox/29.0 SeaMonkey/2.26.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-iio@vger.kernel.org
CC: kgene.kim@samsung.com, pawel.moll@arm.com, t.figa@samsung.com,
        linux-kernel@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>,
        kyungmin.park@samsung.com, linux-samsung-soc@vger.kernel.org,
        Jonathan Cameron <jic23@kernel.org>, Ben Dooks <ben-linux@fluff.org>,
        galak@codeaurora.org, ch.naveen@samsung.com,
        linux-input <linux-input@vger.kernel.org>, heiko.stuebner@bq.com,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH v2] iio: exynos-adc: add experimental touchscreen support
References: <5068889.1KfVx3ksNo@wuerfel>
In-Reply-To: <5068889.1KfVx3ksNo@wuerfel>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:zNh7++Kxrohzdv48ns4Pv+NordzXHepCimgTZNfOFjsAnVpkf15
 nMVbTgS1kLSFbpf8fHr4/OtUnfRiNJ6Ko1NYcVcn3bMCUHWAF9/ryeXv6tbQrwIRInYii1B
 IWjni0YPV33BkG14J3u4CUwTE/BrsY9ipuEXBwBXtVGGdOKKLkn3L3VaMAjyW+x3uEu5Px7
 +ck+Lg1w4LYIix0vNduKw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann schrieb:
> This adds support for the touchscreen on Samsung s3c64xx.
> The driver is completely untested but shows roughly how
> it could be done, following the example of the at91 driver.
>
> Open questions include:
>
> - compared to the old plat-samsung/adc driver, there is
>   no support for prioritizing ts over other clients, nor
>   for oversampling. From my reading of the code, the
>   priorities didn't actually have any effect at all, but
>   the oversampling might be needed. Maybe the original
>   authors have some insight.
>
> - We probably need to add support for platform_data as well,
>   I've skipped this so far.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> This should address all previous comments, and I've also added
> a write to ADC_V1_DLY() as the old driver does.
Just two minor issues inline.
>
> diff --git a/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt b/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
> index cad81b666a67..ba30836c73cb 100644
> --- a/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
> +++ b/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
> @@ -43,6 +43,10 @@ Required properties:
>  				       and compatible ADC block)
>  - vdd-supply		VDD input supply.
>  
> +Optional properties:
> +- has-touchscreen:	If present, indicates that a touchscreen is
> +			connected an usable.
Typo: and
> +
>  Note: child nodes can be added for auto probing from device tree.
>  
>  Example: adding device info in dtsi file
> diff --git a/drivers/iio/adc/exynos_adc.c b/drivers/iio/adc/exynos_adc.c
> index 420c5cda09c3..3b684a117b9c 100644
> --- a/drivers/iio/adc/exynos_adc.c
> +++ b/drivers/iio/adc/exynos_adc.c
> @@ -34,6 +34,7 @@
>  #include <linux/regulator/consumer.h>
>  #include <linux/of_platform.h>
>  #include <linux/err.h>
> +#include <linux/input.h>
>  
>  #include <linux/iio/iio.h>
>  #include <linux/iio/machine.h>
> @@ -66,6 +67,9 @@
>  
>  #define ADC_S3C2410_CON_SELMUX(x) (((x)&0x7)<<3)
>  
> +/* touch screen always uses channel 0 */
> +#define ADC_S3C2410_MUX_TS	0
> +
>  /* ADCTSC Register Bits */
>  #define ADC_S3C2443_TSC_UD_SEN		(1u << 8)
>  #define ADC_S3C2410_TSC_YM_SEN		(1u << 7)
> @@ -103,24 +107,32 @@
>  
>  /* Bit definitions common for ADC_V1 and ADC_V2 */
>  #define ADC_CON_EN_START	(1u << 0)
> +#define ADC_DATX_PRESSED	(1u << 15)
>  #define ADC_DATX_MASK		0xFFF
> +#define ADC_DATY_MASK		0xFFF
>  
>  #define EXYNOS_ADC_TIMEOUT	(msecs_to_jiffies(100))
>  
>  struct exynos_adc {
>  	struct exynos_adc_data	*data;
>  	struct device		*dev;
> +	struct input_dev	*input;
>  	void __iomem		*regs;
>  	void __iomem		*enable_reg;
>  	struct clk		*clk;
>  	struct clk		*sclk;
>  	unsigned int		irq;
> +	unsigned int		tsirq;
>  	struct regulator	*vdd;
>  
>  	struct completion	completion;
>  
>  	u32			value;
>  	unsigned int            version;
> +
> +	bool			read_ts;
> +	u32			ts_x;
> +	u32			ts_y;
>  };
>  
>  struct exynos_adc_data {
> @@ -205,6 +217,9 @@ static void exynos_adc_v1_init_hw(struct exynos_adc *info)
>  	/* Enable 12-bit ADC resolution */
>  	con1 |= ADC_V1_CON_RES;
>  	writel(con1, ADC_V1_CON(info->regs));
> +
> +	/* set default touchscreen delay */
Any information about how many µs/ms it is actually set with this value?
> +	writel(10000, ADC_V1_DLY(info->regs));
>  }
>  
>  static void exynos_adc_v1_exit_hw(struct exynos_adc *info)
> @@ -390,12 +405,54 @@ static int exynos_read_raw(struct iio_dev *indio_dev,
>  	return ret;
>  }
>  
> +static int exynos_read_s3c64xx_ts(struct iio_dev *indio_dev, int *x, int *y)
> +{
> +	struct exynos_adc *info = iio_priv(indio_dev);
> +	unsigned long timeout;
> +	int ret;
> +
> +	mutex_lock(&indio_dev->mlock);
> +	info->read_ts = true;
> +
> +	reinit_completion(&info->completion);
> +
> +	writel(ADC_S3C2410_TSC_PULL_UP_DISABLE | ADC_TSC_AUTOPST,
> +	       ADC_V1_TSC(info->regs));
> +
> +	/* Select the ts channel to be used and Trigger conversion */
> +	info->data->start_conv(info, ADC_S3C2410_MUX_TS);
> +
> +	timeout = wait_for_completion_timeout
> +			(&info->completion, EXYNOS_ADC_TIMEOUT);
> +	if (timeout == 0) {
> +		dev_warn(&indio_dev->dev, "Conversion timed out! Resetting\n");
> +		if (info->data->init_hw)
> +			info->data->init_hw(info);
> +		ret = -ETIMEDOUT;
> +	} else {
> +		*x = info->ts_x;
> +		*y = info->ts_y;
> +		ret = 0;
> +	}
> +
> +	info->read_ts = false;
> +	mutex_unlock(&indio_dev->mlock);
> +
> +	return ret;
> +}
> +
>  static irqreturn_t exynos_adc_isr(int irq, void *dev_id)
>  {
>  	struct exynos_adc *info = (struct exynos_adc *)dev_id;
>  
>  	/* Read value */
> -	info->value = readl(ADC_V1_DATX(info->regs)) & ADC_DATX_MASK;
> +	if (info->read_ts) {
> +		info->ts_x = readl(ADC_V1_DATX(info->regs));
> +		info->ts_y = readl(ADC_V1_DATY(info->regs));
> +		writel(ADC_TSC_WAIT4INT | ADC_S3C2443_TSC_UD_SEN, ADC_V1_TSC(info->regs));
> +	} else {
> +		info->value = readl(ADC_V1_DATX(info->regs)) & ADC_DATX_MASK;
> +	}
>  
>  	/* clear irq */
>  	if (info->data->clear_irq)
> @@ -406,6 +463,46 @@ static irqreturn_t exynos_adc_isr(int irq, void *dev_id)
>  	return IRQ_HANDLED;
>  }
>  
> +/*
> + * Here we (ab)use a threaded interrupt handler to stay running
> + * for as long as the touchscreen remains pressed, we report
> + * a new event with the latest data and then sleep until the
> + * next timer tick. This mirrors the behavior of the old
> + * driver, with much less code.
> + */
> +static irqreturn_t exynos_ts_isr(int irq, void *dev_id)
> +{
> +	struct exynos_adc *info = dev_id;
> +	struct iio_dev *dev = dev_get_drvdata(info->dev);
> +	u32 x, y;
> +	bool pressed;
> +	int ret;
> +
> +	while (info->input->users) {
> +		ret = exynos_read_s3c64xx_ts(dev, &x, &y);
> +		if (ret == -ETIMEDOUT)
> +			break;
> +
> +		pressed = x & y & ADC_DATX_PRESSED;
> +		if (!pressed) {
> +			input_report_key(info->input, BTN_TOUCH, 0);
> +			input_sync(info->input);
> +			break;
> +		}
> +
> +		input_report_abs(info->input, ABS_X, x & ADC_DATX_MASK);
> +		input_report_abs(info->input, ABS_Y, y & ADC_DATY_MASK);
> +		input_report_key(info->input, BTN_TOUCH, 1);
> +		input_sync(info->input);
> +
> +		msleep(1);
> +	};
> +
> +	writel(0, ADC_V1_CLRINTPNDNUP(info->regs));
> +
> +	return IRQ_HANDLED;
> +}
> +
>  static int exynos_adc_reg_access(struct iio_dev *indio_dev,
>  			      unsigned reg, unsigned writeval,
>  			      unsigned *readval)
> @@ -457,12 +554,66 @@ static int exynos_adc_remove_devices(struct device *dev, void *c)
>  	return 0;
>  }
>  
> +static int exynos_adc_ts_open(struct input_dev *dev)
> +{
> +	struct exynos_adc *info = input_get_drvdata(dev);
> +
> +	enable_irq(info->tsirq);
> +
> +	return 0;
> +}
> +
> +static void exynos_adc_ts_close(struct input_dev *dev)
> +{
> +	struct exynos_adc *info = input_get_drvdata(dev);
> +
> +	disable_irq(info->tsirq);
> +}
> +
> +static int exynos_adc_ts_init(struct exynos_adc *info)
> +{
> +	int ret;
> +
> +	if (info->tsirq <= 0)
> +		return -ENODEV;
> +
> +	info->input = input_allocate_device();
> +	if (!info->input)
> +		return -ENOMEM;
> +
> +	info->input->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
> +	info->input->keybit[BIT_WORD(BTN_TOUCH)] = BIT_MASK(BTN_TOUCH);
> +
> +	input_set_abs_params(info->input, ABS_X, 0, 0x3FF, 0, 0);
> +	input_set_abs_params(info->input, ABS_Y, 0, 0x3FF, 0, 0);
> +
> +	info->input->name = "S3C24xx TouchScreen";
> +	info->input->id.bustype = BUS_HOST;
> +	info->input->open = exynos_adc_ts_open;
> +	info->input->close = exynos_adc_ts_close;
> +	
> +	input_set_drvdata(info->input, info);
> +
> +	ret = input_register_device(info->input);
> +	if (ret)
> +		input_free_device(info->input);
> +
> +	disable_irq(info->tsirq);
> +	ret = request_threaded_irq(info->tsirq, NULL, exynos_ts_isr,
> +				   0, "touchscreen", info);
> +	if (ret)
> +		input_unregister_device(info->input);
> +
> +	return ret;
> +}
> +
>  static int exynos_adc_probe(struct platform_device *pdev)
>  {
>  	struct exynos_adc *info = NULL;
>  	struct device_node *np = pdev->dev.of_node;
>  	struct iio_dev *indio_dev = NULL;
>  	struct resource	*mem;
> +	bool has_ts = false;
>  	int ret = -ENODEV;
>  	int irq;
>  
> @@ -498,8 +649,14 @@ static int exynos_adc_probe(struct platform_device *pdev)
>  		dev_err(&pdev->dev, "no irq resource?\n");
>  		return irq;
>  	}
> -
>  	info->irq = irq;
> +
> +	irq = platform_get_irq(pdev, 1);
> +	if (irq == -EPROBE_DEFER)
> +		return irq; 
> +
> +	info->tsirq = irq;
> +
>  	info->dev = &pdev->dev;
>  
>  	init_completion(&info->completion);
> @@ -565,6 +722,15 @@ static int exynos_adc_probe(struct platform_device *pdev)
>  	if (info->data->init_hw)
>  		info->data->init_hw(info);
>  
> +	/* leave out any TS related code if unreachable */
> +	if (IS_BUILTIN(CONFIG_INPUT) ||
> +	    (IS_MODULE(CONFIG_INPUT) && config_enabled(MODULE)))
> +		has_ts = of_property_read_bool(pdev->dev.of_node, "has-touchscreen");
> +	if (has_ts)
> +		ret = exynos_adc_ts_init(info);
> +	if (ret)
> +		goto err_iio;
> +
>  	ret = of_platform_populate(np, exynos_adc_match, NULL, &indio_dev->dev);
>  	if (ret < 0) {
>  		dev_err(&pdev->dev, "failed adding child nodes\n");
> @@ -576,6 +742,11 @@ static int exynos_adc_probe(struct platform_device *pdev)
>  err_of_populate:
>  	device_for_each_child(&indio_dev->dev, NULL,
>  				exynos_adc_remove_devices);
> +	if (has_ts) {
> +		input_unregister_device(info->input);
> +		free_irq(info->tsirq, info);
> +	}
> +err_iio:
>  	iio_device_unregister(indio_dev);
>  err_irq:
>  	free_irq(info->irq, info);
> @@ -595,6 +766,11 @@ static int exynos_adc_remove(struct platform_device *pdev)
>  	struct iio_dev *indio_dev = platform_get_drvdata(pdev);
>  	struct exynos_adc *info = iio_priv(indio_dev);
>  
> +	if (IS_BUILTIN(CONFIG_INPUT) ||
> +	    (IS_MODULE(CONFIG_INPUT) && config_enabled(MODULE))) {
> +		free_irq(info->tsirq, info);
> +		input_unregister_device(info->input);
> +	}
>  	device_for_each_child(&indio_dev->dev, NULL,
>  				exynos_adc_remove_devices);
>  	iio_device_unregister(indio_dev);
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

