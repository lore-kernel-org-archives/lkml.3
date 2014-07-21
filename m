Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754341AbaGUKGp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 06:06:45 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:62611 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754163AbaGUKGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 06:06:42 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Hartmut Knaack <knaack.h@gmx.de>
Cc: Jonathan Cameron <jic23@kernel.org>, linux-arm-kernel@lists.infradead.org,
        Chanwoo Choi <cw00.choi@samsung.com>, ch.naveen@samsung.com,
        mark.rutland@arm.com, devicetree@vger.kernel.org,
        kgene.kim@samsung.com, pawel.moll@arm.com,
        ijc+devicetree@hellion.org.uk, linux-iio@vger.kernel.org,
        t.figa@samsung.com, rdunlap@infradead.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        kyungmin.park@samsung.com, robh+dt@kernel.org, galak@codeaurora.org,
        heiko.stuebner@bq.com, Ben Dooks <ben-linux@fluff.org>
Subject: Re: [PATCH 2/2] iio: exynos-adc: add experimental touchscreen support
Date: Mon, 21 Jul 2014 12:06:27 +0200
Message-ID: <8824406.lngeuqeliB@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <53CC368E.9060506@gmx.de>
References: <1405663186-26464-1-git-send-email-cw00.choi@samsung.com> <53CBC8D6.6020509@kernel.org> <53CC368E.9060506@gmx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:v1ZkUfI6aN/W8w2OUiAaKaZs7JK4mE6KwcU16ti/944
 4SzycbQWLaVMFFm8RAyVMrQd2cSF1GT8kWCr2kR0G/VtEJh6Gf
 joanoQvOxiD9CjRERWD280Ff5Keuy9BUDmBvOlPGc2fbhfOU9M
 ljG64yAm8ISPJIDhKaH9FG1iAzqr/RNmyT5FYd+ci3ooTAPR67
 MzIRzOlEDu8JN4hxtVe5ahxeM1QkYm5XesET+pZvvGLoWPjp3y
 diP2HaZGn+F2R3cY8DJJ5yrc+ozugWRDcxRVJ97JgxIKImfOpE
 UiMArykXV+jt5gO2rk08SEWUhG6vy6IGTtHU+7BYpXaIpPeh1T
 wo76kT/m/kmj1S0Q8U2k=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 20 July 2014 23:37:18 Hartmut Knaack wrote:
> Jonathan Cameron schrieb:
> > On 18/07/14 20:29, Arnd Bergmann wrote:
> >> - I simply register the input device from the adc driver
> >>    itself, as the at91 code does. The driver also supports
> >>    sub-nodes, but I don't understand how they are meant
> >>    to be used, so using those might be better.
> > So, the alternative you are (I think) referring to is to use
> > the buffered in kernel client interface.  That way a separate
> > touch screen driver can use the output channels provided by IIO
> > in much the same way you might use a regulator or similar.
> > Note that whilst this is similar to the simple polled interface
> > used for things like the iio_hwmon driver, the data flow is
> > quite different (clearly the polled interfce would be
> > inappropriate here).
> >
> > Whilst we've discussed it in the past for touch screen drivers
> > like this, usually the hardware isn't generic enough to be
> > of any real use if not being used as a touch screen.  As such
> > it's often simpler to just have the support directly in the
> > driver (as you've observed the at91 driver does this).

Ok, I see. That's exactly the information I was looking for.

> >
> > Whilst the interface has been there a while, it's not really had
> > all that much use.  The original target was the simpler case
> > of 3D accelerometer where we have a generic iio to input
> > bridge driver. Time constraints meant that I haven't yet actually
> > formally submitted the input side of this. Whilst there are lots
> > of other things that can use this interface, right now nothing
> > actually does so.

Ok.

> >> - The new exynos_read_s3c64xx_ts() function is intentionally
> >>    very similar to the existing exynos_read_raw() functions.
> >>    It should probably be changed, either by merging the two
> >>    into one, or by simplifying the exynos_read_s3c64xx_ts()
> >>    function. This depends a bit on the answers to the questions
> >>    above.
> > I'd be tempted to not bother keeping them that similar.  It's
> > not a generic IIO channel so simplify it where possible.

Ok.

> >> index 5f95638513d2..cf1d9f3e2492 100644
> >> --- a/drivers/iio/adc/exynos_adc.c
> >> +++ b/drivers/iio/adc/exynos_adc.c
> >> @@ -34,6 +34,7 @@
> >>   #include <linux/regulator/consumer.h>
> >>   #include <linux/of_platform.h>
> >>   #include <linux/err.h>
> >> +#include <linux/input.h>
> > Might want to make the input side optional at compile time...
> > I supose the existing parts are unlikely to be used much in headless
> > devices, but you never know.  Maybe we just leave this until someone
> > shouts they want to be able to avoid compiling it in.

I expected the input stuff to just be left out by the compiler
if CONFIG_INPUT is not set. I'll try it out and change it if necessary.

> >>   	struct completion	completion;
> >>
> >> +	bool			read_ts;
> >>   	u32			value;
> >> +	u32			value2;
> > As I state further down, I'd rather keep a little
> > clear of the naming used in IIO for bits that aren't
> > going through IIO (less confusing!). Maybe just
> > have
> > 	u32 x, y;

Ok.


> >>   	unsigned int            version;
> >>   };
> >>
> >> @@ -390,12 +396,61 @@ static int exynos_read_raw(struct iio_dev *indio_dev,
> >>   	return ret;
> >>   }
> >>
> >> +static int exynos_read_s3c64xx_ts(struct iio_dev *indio_dev,
> >> +				struct iio_chan_spec const *chan,
> >> +				int *val,
> >> +				int *val2,
> >> +				long mask)
> >> +{
> >> +	struct exynos_adc *info = iio_priv(indio_dev);
> >> +	unsigned long timeout;
> >> +	int ret;
> >> +
> >> +	if (mask != IIO_CHAN_INFO_RAW)
> >> +		return -EINVAL;
> >> +
> >> +	mutex_lock(&indio_dev->mlock);
> >> +	info->read_ts = 1;
> Since info->read_ts is of type bool, use true/false.

Ok

> >> +
> >> +	reinit_completion(&info->completion);
> >> +
> >> +	writel(ADC_S3C2410_TSC_PULL_UP_DISABLE | ADC_TSC_AUTOPST,
> >> +	       ADC_V1_TSC(info->regs));
> >> +
> >> +	/* Select the ts channel to be used and Trigger conversion */
> >> +	info->data->start_conv(info, 0);
> > 0 is a rather magic value.  A define perhaps?

I'm not entirely sure about why we pass 0 here, it's either channel zero
being used for touchscreen, or the channel number being ignore after
we write to the TSC register above. I copied it from the original driver,
but it might be helpful if someone with access to the specs could comment
here.

I'll add a macro for now.

> >> +
> >> +	timeout = wait_for_completion_timeout
> >> +			(&info->completion, EXYNOS_ADC_TIMEOUT);
> >> +	if (timeout == 0) {
> >> +		dev_warn(&indio_dev->dev, "Conversion timed out! Resetting\n");
> >> +		if (info->data->init_hw)
> >> +			info->data->init_hw(info);
> >> +		ret = -ETIMEDOUT;
> >> +	} else {
> >> +		*val = info->value;
> >> +		*val2 = info->value2;
> > This is definitely abuse as those two values are not intended for
> > different values.  If you want to do this please use different naming
> > and don't try to fiddle it into the IIO read raw framework.
> > As you've suggested above, better to simplify this code and drop the
> > bits cloned from the other handler.

Ok, adding ts_x and ts_y members.

> >> +		ret = IIO_VAL_INT;
> >> +	}
> >> +
> >> +	info->read_ts = 0;
> >> +	mutex_unlock(&indio_dev->mlock);
> >> +
> >> +	return ret;
> >> +}
> >> +
> >>   static irqreturn_t exynos_adc_isr(int irq, void *dev_id)
> >>   {
> >>   	struct exynos_adc *info = (struct exynos_adc *)dev_id;
> >>
> >>   	/* Read value */
> >> -	info->value = readl(ADC_V1_DATX(info->regs)) & ADC_DATX_MASK;
> >> +	if (info->read_ts) {
> >> +		info->value = readl(ADC_V1_DATX(info->regs)) & ADC_DATX_MASK;
> >> +		info->value2 = readl(ADC_V1_DATY(info->regs)) & ADC_DATX_MASK;
> > ADC_DATY_MASK would be more obviously correct.

Agreed. I thought about it, but then kept it as it was in the original
driver. Will change now.

> >> +		writel(ADC_TSC_WAIT4INT | ADC_S3C2443_TSC_UD_SEN, ADC_V1_TSC(info->regs));
> > Perhaps the above is cryptic enough to warrant a comment?

This is also taken directly from the old driver, I have no idea what
it really does...

> >> +	/* data from s3c2410_ts driver */
> >> +	info->input->name = "S3C24xx TouchScreen";
> >> +	info->input->id.bustype = BUS_HOST;
> >> +	info->input->id.vendor = 0xDEAD;
> >> +	info->input->id.product = 0xBEEF;
> >> +	info->input->id.version = 0x0200;
> >> +
> >> +	ret = input_register_device(info->input);
> >> +	if (ret) {
> >> +		input_free_device(info->input);
> >> +		goto err;
> Just return ret, without goto (and get rid of label err).

ok

> >> +	}
> >> +
> >> +	if (info->tsirq > 0)
> >> +		ret = request_threaded_irq(info->irq, NULL, exynos_ts_isr,
> >> +					0, "touchscreen", info);
> > info->tsirq
> > (that had me really confused for a moment ;)
> > Also, perhaps a more specific name.  touchscreen_updown or similar as the
> > main interrupt is also used during touchscreen operation.
> >> +	if (ret < 0) {
> >> +		dev_err(info->dev, "failed requesting touchsccreen irq, irq = %d\n",
> >> +							info->irq);
> >> +		goto err_input;
> >> +	}
> >> +
> >> +	return 0;
> >> +
> Probably better to get rid of the labels and move the code up, as it is only used once.

Ok. I try not to mix goto and early return, so I've removed all the labels
here.

> >>   static int exynos_adc_probe(struct platform_device *pdev)
> >>   {
> >>   	struct exynos_adc *info = NULL;
> >>   	struct device_node *np = pdev->dev.of_node;
> >>   	struct iio_dev *indio_dev = NULL;
> >>   	struct resource	*mem;
> >> +	bool has_ts;
> >>   	int ret = -ENODEV;
> >>   	int irq;
> >>
> >> @@ -498,8 +638,14 @@ static int exynos_adc_probe(struct platform_device *pdev)
> >>   		dev_err(&pdev->dev, "no irq resource?\n");
> >>   		return irq;
> >>   	}
> >> -
> >>   	info->irq = irq;
> >> +
> >> +	irq = platform_get_irq(pdev, 1);
> >> +	if (irq == -EPROBE_DEFER)
> >> +		return irq;
> What about other possible error codes?

We handle them later, in the request_threaded_irq call. In particular,
if the touchscreen is not used because either the "has-touchscreen" flag
is not set or because the input layer is not available, failing to get
the irq line should not be treated as an error.

Checking -EPROBE_DEFER however makes sense, so we get out of the probe function
early and don't have to undo and later retry everything.

Thanks everybody for the review!

	Arnd
