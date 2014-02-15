Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238AbaBOMSh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 07:18:37 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:44900 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753118AbaBOMSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 07:18:34 -0500
Message-ID: <52FF5B3A.70806@kernel.org>
Date: Sat, 15 Feb 2014 12:19:06 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Matt Porter <mporter@linaro.org>, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <robh+dt@kernel.org>,
        =?ISO-8859-1?Q?Beno=EEt_Cousson?= <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Thierry Reding <thierry.reding@gmail.com>
CC: Linux IIO List <linux-iio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linux PWM List <linux-pwm@vger.kernel.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 2/6] iio: pulse: add TI ECAP driver
References: <1391626901-31684-1-git-send-email-mporter@linaro.org> <1391626901-31684-3-git-send-email-mporter@linaro.org>
In-Reply-To: <1391626901-31684-3-git-send-email-mporter@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/14 19:01, Matt Porter wrote:
> Adds support for capturing PWM signals using the TI ECAP peripheral.
> This driver supports triggered buffer capture of pulses on multiple
> ECAP instances. In addition, the driver supports configurable polarity
> of the signal to be captured.
>
> Signed-off-by: Matt Porter <mporter@linaro.org>
Ignoring the ABI questions - there are a few bits and bobs inline.

Sorry again that it took me so long to take a look at this.
Ouch, still far too much unread email in my inbox.
> ---
>   drivers/iio/pulse/Kconfig  |  20 ++
>   drivers/iio/pulse/Makefile |   6 +
>   drivers/iio/pulse/tiecap.c | 491 +++++++++++++++++++++++++++++++++++++++++++++
>   3 files changed, 517 insertions(+)
>   create mode 100644 drivers/iio/pulse/Kconfig
>   create mode 100644 drivers/iio/pulse/Makefile
>   create mode 100644 drivers/iio/pulse/tiecap.c
>
> diff --git a/drivers/iio/pulse/Kconfig b/drivers/iio/pulse/Kconfig
> new file mode 100644
> index 0000000..9864d4b
> --- /dev/null
> +++ b/drivers/iio/pulse/Kconfig
> @@ -0,0 +1,20 @@
> +#
> +# Pulse Capture Devices
> +#
> +# When adding new entries keep the list in alphabetical order
> +
> +menu "Pulse Capture Devices"
> +
> +config IIO_TIECAP
> +	tristate "TI ECAP Pulse Capture"
> +	depends on SOC_AM33XX
Looks like it rather more specifically depends on the pwm supplied on
that soc.  I haven't checked but a dependency on that would seem
more logical to me.  Pitty it doesn't have a generic interface, because
then we could relax the dependency and it would allow you to get a lot
more build coverage.
> +	select IIO_BUFFER
> +	select IIO_TRIGGERED_BUFFER
> +	help
> +	 If you say yes here you get support for the TI ECAP peripheral
> +	 in pulse capture mode.
> +
> +	 This driver can also be built as a module.  If so, the module
> +	 will be called tiecap
> +
> +endmenu
> diff --git a/drivers/iio/pulse/Makefile b/drivers/iio/pulse/Makefile
> new file mode 100644
> index 0000000..94d4b00
> --- /dev/null
> +++ b/drivers/iio/pulse/Makefile
> @@ -0,0 +1,6 @@
> +#
> +# Makefile for IIO PWM Capture Devices
> +#
> +
> +# When adding new entries keep the list in alphabetical order
> +obj-$(CONFIG_IIO_TIECAP)	+= tiecap.o
> diff --git a/drivers/iio/pulse/tiecap.c b/drivers/iio/pulse/tiecap.c
> new file mode 100644
> index 0000000..fd96745
> --- /dev/null
> +++ b/drivers/iio/pulse/tiecap.c
> @@ -0,0 +1,491 @@
> +/*
> + * ECAP IIO pulse capture driver
> + *
> + * Copyright (C) 2014 Linaro Limited
> + * Author: Matt Porter <mporter@linaro.org>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/err.h>
> +#include <linux/iio/buffer.h>
> +#include <linux/iio/iio.h>
> +#include <linux/iio/sysfs.h>
> +#include <linux/iio/trigger.h>
> +#include <linux/iio/trigger_consumer.h>
> +#include <linux/iio/triggered_buffer.h>
> +#include <linux/io.h>
> +#include <linux/interrupt.h>
> +#include <linux/irq.h>
> +#include <linux/module.h>
> +#include <linux/of_device.h>
> +#include <linux/platform_device.h>
> +#include <linux/pm_runtime.h>
> +
> +#include "../../pwm/pwm-tipwmss.h"
If we need functions from in there, surely it should be in
include/linux/pwm instead of burried in the driver tree?
> +
> +/* ECAP regs and bits */
Please add prefixes to all of these.  i.e. #define ECAP_CAP1
etc.

This is to avoid the possibility of a naming clash if these rather
short names ever turn in in one of the headers included above.

> +#define CAP1			0x08
> +#define CAP2			0x0c
> +#define ECCTL1			0x28
> +#define ECCTL1_RUN_FREE		BIT(15)
> +#define ECCTL1_CAPLDEN		BIT(8)
> +#define ECCTL1_CAP2POL		BIT(2)
> +#define ECCTL1_CTRRST1		BIT(1)
> +#define ECCTL1_CAP1POL		BIT(0)
> +#define ECCTL2			0x2a
> +#define ECCTL2_SYNCO_SEL_DIS	BIT(7)
> +#define ECCTL2_TSCTR_FREERUN	BIT(4)
> +#define ECCTL2_REARM		BIT(3)
> +#define ECCTL2_STOP_WRAP_2	BIT(1)
> +#define ECEINT			0x2c
> +#define ECFLG			0x2e
> +#define ECCLR			0x30
> +#define ECINT_CTRCMP		BIT(7)
> +#define ECINT_CTRPRD		BIT(6)
> +#define ECINT_CTROVF		BIT(5)
> +#define ECINT_CEVT4		BIT(4)
> +#define ECINT_CEVT3		BIT(3)
> +#define ECINT_CEVT2		BIT(2)
> +#define ECINT_CEVT1		BIT(1)
> +#define ECINT_ALL		(ECINT_CTRCMP |	\
> +				ECINT_CTRPRD |	\
> +				ECINT_CTROVF |	\
> +				ECINT_CEVT4 |	\
> +				ECINT_CEVT3 |	\
> +				ECINT_CEVT2 |	\
> +				ECINT_CEVT1)
> +
> +/* ECAP driver flags */
> +#define ECAP_POLARITY_HIGH	BIT(1)
> +#define ECAP_ENABLED		BIT(0)
> +
> +struct ecap_context {
> +	u32	cap1;
> +	u32	cap2;
> +	u16	ecctl1;
> +	u16	ecctl2;
> +	u16	eceint;
> +};
> +
> +struct ecap_state {
> +	unsigned long		flags;
> +	unsigned int		clk_rate;
> +	void __iomem		*regs;
> +	u32			*buf;
> +	struct ecap_context	ctx;
> +};
> +
> +#define dev_to_ecap_state(d)	iio_priv(dev_to_iio_dev(d))
> +
> +static const struct iio_chan_spec ecap_channels[] = {
> +	{
> +		.type		= IIO_PULSE,
> +		.info_mask_separate =
> +			BIT(IIO_CHAN_INFO_RAW) | BIT(IIO_CHAN_INFO_SCALE),
> +		.scan_index	= 0,
> +		.scan_type = {
> +			.sign		= 'u',
> +			.realbits	= 32,
> +			.storagebits	= 32,
> +			.endianness	= IIO_LE,
> +		},
> +	},
> +	IIO_CHAN_SOFT_TIMESTAMP(1)
> +};
> +
> +static ssize_t ecap_attr_show(struct device *dev,
> +			      struct device_attribute *attr, char *buf)
> +{
> +	struct ecap_state *state = dev_to_ecap_state(dev);
> +
> +	return sprintf(buf, "%d\n",
> +		       test_bit(ECAP_POLARITY_HIGH, &state->flags));
> +}
> +
This function needs a name indicating what attr.  There may be only one
now, but who knows in future.
> +static ssize_t ecap_attr_store(struct device *dev,
> +			       struct device_attribute *attr,
> +			       const char *buf,
> +			       size_t len)
> +{
> +	int ret;
> +	bool val;
> +	struct ecap_state *state = dev_to_ecap_state(dev);
> +
> +	if (test_bit(ECAP_ENABLED, &state->flags))
> +		return -EINVAL;
> +
Not obvious how a boolean value corresponds to a polarity. If we change to
the abi I suggested earlier, I'd have this as in_waveformX_inverted.
> +	ret = strtobool(buf, &val);
> +	if (ret)
> +		return ret;
> +
> +	if (val)
> +		set_bit(ECAP_POLARITY_HIGH, &state->flags);
> +	else
> +		clear_bit(ECAP_POLARITY_HIGH, &state->flags);
> +
> +	return len;
> +}
> +
> +static IIO_DEVICE_ATTR(pulse_polarity, S_IRUGO | S_IWUSR,
> +	ecap_attr_show, ecap_attr_store, 0);
> +
> +static struct attribute *ecap_attributes[] = {
> +	&iio_dev_attr_pulse_polarity.dev_attr.attr,
> +	NULL,
> +};
> +
> +static struct attribute_group ecap_attribute_group = {
> +	.attrs = ecap_attributes,
> +};
> +
> +static int ecap_read_raw(struct iio_dev *idev,
> +			struct iio_chan_spec const *ch, int *val,
> +			int *val2, long mask)
> +{
> +	struct ecap_state *state = iio_priv(idev);
> +
> +	switch (mask) {
> +	case IIO_CHAN_INFO_RAW:
Just don't provide the BIT(IIO_CHAN_INFO_RAW) in the info_mask_separate
and there will be no userspace interface. Thus indicating it can't be
read better than returning a 'fake' value.
> +		/*
> +		 * Always return 0 as a pulse width sample
> +		 * is only valid in a triggered condition
> +		 */
> +		*val = 0;
> +		return IIO_VAL_INT;
> +	case IIO_CHAN_INFO_SCALE:
> +		*val = 0;
> +		*val2 = NSEC_PER_SEC / state->clk_rate;
> +		return IIO_VAL_INT_PLUS_NANO;
> +	default:
> +		return -EINVAL;
> +	}
> +}
> +
> +static const struct iio_info ecap_info = {
> +	.driver_module = THIS_MODULE,
> +	.attrs = &ecap_attribute_group,
> +	.read_raw = &ecap_read_raw,
> +};
> +
> +static irqreturn_t ecap_trigger_handler(int irq, void *private)
> +{
> +	struct iio_poll_func *pf = private;
> +	struct iio_dev *idev = pf->indio_dev;
> +	struct ecap_state *state = iio_priv(idev);
> +
> +	/* Read pulse counter value */
> +	*state->buf = readl(state->regs + CAP2);
> +
To get more accurate timestamps, you could grab that in the top half handler.
See how ad7887 does it for example using the utility function
iio_pollfunc_store_time.

> +	iio_push_to_buffers_with_timestamp(idev, state->buf, iio_get_time_ns());
> +
> +	iio_trigger_notify_done(idev->trig);
> +
> +	return IRQ_HANDLED;
> +};
> +
> +
> +static const struct iio_trigger_ops iio_interrupt_trigger_ops = {
> +	.owner = THIS_MODULE,
> +};
> +
> +static irqreturn_t ecap_interrupt_handler(int irq, void *private)
> +{
> +	struct iio_dev *idev = private;
> +	struct ecap_state *state = iio_priv(idev);
> +	u16 ints;
> +
> +	iio_trigger_poll(idev->trig, 0);
> +
Do you want to clear the interrupt here, or in the try renable callback
for the trigger?  That would only be called after the data has been grabbed.


> +	/* Clear CAP2 interrupt */
> +	ints = readw(state->regs + ECFLG);
> +	if (ints & ECINT_CEVT2)
> +		writew(ECINT_CEVT2, state->regs + ECCLR);
> +	else
> +		dev_warn(&idev->dev, "unhandled interrupt flagged: %04x\n",
> +			 ints);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static int ecap_buffer_predisable(struct iio_dev *idev)
> +{
> +	struct ecap_state *state = iio_priv(idev);
> +	int ret = 0;
> +	u16 ecctl2;
> +
> +	/* Stop capture */
> +	clear_bit(ECAP_ENABLED, &state->flags);
> +	ecctl2 = readw(state->regs + ECCTL2) & ~ECCTL2_TSCTR_FREERUN;
> +	writew(ecctl2, state->regs + ECCTL2);
> +
> +	/* Disable and clear all interrupts */
> +	writew(0, state->regs + ECEINT);
> +	writew(ECINT_ALL, state->regs + ECCLR);
> +
By ordering convention this should be in reverse order of the postenable,
hence this predisable call should be first in the function.
Not sure it matters in reality but is more 'obviously' correct which
is always a good thing.

> +	ret = iio_triggered_buffer_predisable(idev);
> +
> +	pm_runtime_put_sync(idev->dev.parent);
> +
> +	return ret;
> +}
> +
> +static int ecap_buffer_postenable(struct iio_dev *idev)
> +{
> +	struct ecap_state *state = iio_priv(idev);
> +	int ret = 0;
> +	u16 ecctl1, ecctl2;
> +
> +	pm_runtime_get_sync(idev->dev.parent);
> +
> +	/* Configure pulse polarity */
> +	ecctl1 = readw(state->regs + ECCTL1);
> +	if (test_bit(ECAP_POLARITY_HIGH, &state->flags)) {
> +		/* CAP1 rising, CAP2 falling */
> +		ecctl1 |= ECCTL1_CAP2POL;
> +		ecctl1 &= ~ECCTL1_CAP1POL;
> +	} else {
> +		/* CAP1 falling, CAP2 rising */
> +		ecctl1 &= ~ECCTL1_CAP2POL;
> +		ecctl1 |= ECCTL1_CAP1POL;
> +	}
> +	writew(ecctl1, state->regs + ECCTL1);
> +
> +	/* Enable CAP2 interrupt */
> +	writew(ECINT_CEVT2, state->regs + ECEINT);
> +
> +	/* Enable capture */
> +	ecctl2 = readw(state->regs + ECCTL2);
> +	ecctl2 |= ECCTL2_TSCTR_FREERUN | ECCTL2_REARM;
> +	writew(ecctl2, state->regs + ECCTL2);
> +	set_bit(ECAP_ENABLED, &state->flags);
> +
> +	ret = iio_triggered_buffer_postenable(idev);
> +
> +	return ret;
> +}
> +
> +static const struct iio_buffer_setup_ops ecap_buffer_setup_ops = {
> +	.postenable = &ecap_buffer_postenable,
> +	.predisable = &ecap_buffer_predisable,
> +};
> +
> +static void ecap_init_hw(struct iio_dev *idev)
> +{
> +	struct ecap_state *state = iio_priv(idev);
> +
> +	clear_bit(ECAP_ENABLED, &state->flags);
> +	set_bit(ECAP_POLARITY_HIGH, &state->flags);
> +
> +	writew(ECCTL1_RUN_FREE | ECCTL1_CAPLDEN |
> +	       ECCTL1_CAP2POL | ECCTL1_CTRRST1,
> +	       state->regs + ECCTL1);
> +
> +	writew(ECCTL2_SYNCO_SEL_DIS | ECCTL2_STOP_WRAP_2,
> +	       state->regs + ECCTL2);
> +}
> +
> +static const struct of_device_id ecap_of_ids[] = {
> +	{ .compatible	= "ti,am33xx-ecap" },
> +	{ /* sentinel */ },
> +};
> +MODULE_DEVICE_TABLE(of, ecap_of_ids);
> +
> +static int ecap_probe(struct platform_device *pdev)
> +{
> +	int irq, ret;
> +	struct iio_dev *idev;
> +	struct ecap_state *state;
> +	struct resource *r;
> +	struct clk *clk;
> +	struct iio_trigger *trig;
> +	u16 status;
> +
> +	idev = devm_iio_device_alloc(&pdev->dev, sizeof(struct ecap_state));
> +	if (!idev)
> +		return -ENOMEM;
> +
> +	state = iio_priv(idev);
> +
> +	clk = devm_clk_get(&pdev->dev, "fck");
> +	if (IS_ERR(clk)) {
> +		dev_err(&pdev->dev, "failed to get clock\n");
> +		return PTR_ERR(clk);
> +	}
> +
> +	state->clk_rate = clk_get_rate(clk);
> +	if (!state->clk_rate) {
> +		dev_err(&pdev->dev, "failed to get clock rate\n");
> +		return -EINVAL;
> +	}
> +
> +	platform_set_drvdata(pdev, idev);
> +
> +	idev->dev.parent = &pdev->dev;
> +	idev->name = dev_name(&pdev->dev);
> +	idev->modes = INDIO_DIRECT_MODE;
> +	idev->info = &ecap_info;
> +	idev->channels = ecap_channels;
> +	/* One h/w capture and one s/w timestamp channel per instance */

Note that the timestamp may or may not be enabled...  Technically it's
possible to enable the timestamp and not the channel - that's just rather
odd though funnily enough it would give access to the period of the waveform
in this case...

> +	idev->num_channels = ARRAY_SIZE(ecap_channels);
> +
> +	trig = devm_iio_trigger_alloc(&pdev->dev, "%s-dev%d",
> +				      idev->name, idev->id);
> +	if (!trig)
> +		return -ENOMEM;
> +	trig->dev.parent = idev->dev.parent;
> +	iio_trigger_set_drvdata(trig, idev);
> +	trig->ops = &iio_interrupt_trigger_ops;
> +
> +	ret = iio_trigger_register(trig);
> +	if (ret) {
> +		dev_err(&pdev->dev, "failed to register trigger\n");
> +		return ret;
> +	}
> +
> +	ret = iio_triggered_buffer_setup(idev, NULL,
> +					 &ecap_trigger_handler,
> +					 &ecap_buffer_setup_ops);
> +	if (ret)
> +		return ret;
> +
> +	irq = platform_get_irq(pdev, 0);
> +	if (irq < 0) {
> +		dev_err(&pdev->dev, "no irq is specified\n");
> +		return irq;
> +	}
> +	ret = devm_request_irq(&pdev->dev, irq,
> +				&ecap_interrupt_handler,
> +				0, dev_name(&pdev->dev), idev);
> +	if (ret) {
> +		dev_err(&pdev->dev, "unable to request irq\n");
> +		goto uninit_buffer;
> +	}
> +
> +	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	state->regs = devm_ioremap_resource(&pdev->dev, r);
> +	if (IS_ERR(state->regs)) {
> +		dev_err(&pdev->dev, "unable to remap registers\n");
> +		ret = PTR_ERR(state->regs);
> +		goto uninit_buffer;
> +	};
> +
> +	ret = iio_device_register(idev);
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "unable to register device\n");
> +		goto uninit_buffer;
> +	}
> +

Unless I missed something scan_bytes won't contain the correct size until
the channels have been enabled from userspace.

There would be nothing to stop you allocating 'enough' space here. But then
if you do that, you might as well do it directly in the state structure
rather than with this separate allocation.

> +	state->buf = devm_kzalloc(&idev->dev, idev->scan_bytes, GFP_KERNEL);
> +	if (!state->buf) {
> +		ret = -ENOMEM;
> +		goto uninit_buffer;
> +	}
> +
> +	pm_runtime_enable(&pdev->dev);
> +	pm_runtime_get_sync(&pdev->dev);
> +
Does this initialize capture?
> +	status = pwmss_submodule_state_change(pdev->dev.parent,
> +			PWMSS_ECAPCLK_EN);
> +	if (!(status & PWMSS_ECAPCLK_EN_ACK)) {
> +		dev_err(&pdev->dev, "failed to enable PWMSS config space clock\n");
> +		ret = -EINVAL;
> +		goto pwmss_clk_failure;
> +	}
> +
> +	ecap_init_hw(idev);
> +
> +	pm_runtime_put_sync(&pdev->dev);
> +
> +	return 0;
> +
> +pwmss_clk_failure:
> +	pm_runtime_put_sync(&pdev->dev);
> +	pm_runtime_disable(&pdev->dev);
> +	iio_device_unregister(idev);
> +
> +uninit_buffer:
> +	iio_triggered_buffer_cleanup(idev);
> +
> +	return ret;
> +}
> +
> +static int ecap_remove(struct platform_device *pdev)
> +{
> +	struct iio_dev *idev = platform_get_drvdata(pdev);
> +
> +	pm_runtime_get_sync(&pdev->dev);
> +
> +	pwmss_submodule_state_change(pdev->dev.parent, PWMSS_ECAPCLK_STOP_REQ);
> +
> +	pm_runtime_put_sync(&pdev->dev);
> +	pm_runtime_disable(&pdev->dev);
> +
> +	iio_device_unregister(idev);

I'd normally expect the device unregister to be the first element of remove
(and the last of probe) given it is responsible for providing the user
space interfaces.  Can you explain why this doesn't make sense here?

> +	iio_triggered_buffer_cleanup(idev);
> +
> +	return 0;
> +}
> +
> +#ifdef CONFIG_PM_SLEEP
> +static int ecap_suspend(struct device *dev)
> +{
> +	struct ecap_state *state = dev_to_ecap_state(dev);
> +
> +	pm_runtime_get_sync(dev);
> +	state->ctx.cap1 = readl(state->regs + CAP1);
> +	state->ctx.cap2 = readl(state->regs + CAP2);
> +	state->ctx.eceint = readw(state->regs + ECEINT);
> +	state->ctx.ecctl1 = readw(state->regs + ECCTL1);
> +	state->ctx.ecctl2 = readw(state->regs + ECCTL2);
> +	pm_runtime_put_sync(dev);
> +
> +	/* If capture was active, disable ECAP */
> +	if (test_bit(ECAP_ENABLED, &state->flags))
> +		pm_runtime_put_sync(dev);
> +
> +	return 0;
> +}
> +
> +static int ecap_resume(struct device *dev)
> +{
> +	struct ecap_state *state = dev_to_ecap_state(dev);
> +
> +	/* If capture was active, enable ECAP */
> +	if (test_bit(ECAP_ENABLED, &state->flags))
> +		pm_runtime_get_sync(dev);
> +
> +	pm_runtime_get_sync(dev);
> +	writel(state->ctx.cap1, state->regs + CAP1);
> +	writel(state->ctx.cap2, state->regs + CAP2);
> +	writew(state->ctx.eceint, state->regs + ECEINT);
> +	writew(state->ctx.ecctl1, state->regs + ECCTL1);
> +	writew(state->ctx.ecctl2, state->regs + ECCTL2);
> +	pm_runtime_put_sync(dev);
> +
> +	return 0;
> +}
> +#endif
> +
> +static SIMPLE_DEV_PM_OPS(ecap_pm_ops, ecap_suspend, ecap_resume);
> +
> +static struct platform_driver ecap_iio_driver = {
> +	.driver = {
> +		.name		= "ecap",
> +		.owner		= THIS_MODULE,
> +		.of_match_table = of_match_ptr(ecap_of_ids),
> +		.pm		= &ecap_pm_ops,
> +	},
> +	.probe = ecap_probe,
> +	.remove = ecap_remove,
> +};
> +
> +module_platform_driver(ecap_iio_driver);
> +
> +MODULE_DESCRIPTION("ECAP IIO pulse capture driver");
> +MODULE_AUTHOR("Matt Porter <mporter@linaro.org>");
> +MODULE_LICENSE("GPL");
>

