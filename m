Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932564Ab3DTQui (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Apr 2013 12:50:38 -0400
Received: from smtp-out-082.synserver.de ([212.40.185.82]:1214 "EHLO
	smtp-out-081.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932539Ab3DTQuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Apr 2013 12:50:37 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 10107
Message-ID: <5172C724.4070605@metafoo.de>
Date: Sat, 20 Apr 2013 18:49:40 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: Shawn Guo <shawn.guo@linaro.org>, Grant Likely <grant.likely@secretlab.ca>,
        jimwall@q.com, brian@crystalfontz.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org,
        Jonathan Cameron <jic23@cam.ac.uk>, Rob Landley <rob@landley.net>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH 1/3] iio: Add Nuvoton NAU7802 ADC driver
References: <1366299536-18353-1-git-send-email-alexandre.belloni@free-electrons.com> <1366299536-18353-2-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1366299536-18353-2-git-send-email-alexandre.belloni@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Some comments on top of what Jonathan said.

On 04/18/2013 05:38 PM, Alexandre Belloni wrote:
[...]
> diff --git a/drivers/iio/adc/nau7802.c b/drivers/iio/adc/nau7802.c
> new file mode 100644
> index 0000000..0148fd8
> --- /dev/null
> +++ b/drivers/iio/adc/nau7802.c
> @@ -0,0 +1,644 @@
[...]

> +static int nau7802_read_raw(struct iio_dev *idev,
> +			    struct iio_chan_spec const *chan,
> +			    int *val, int *val2, long mask)
> +{
> +	struct nau7802_state *st = iio_priv(idev);
> +	u8 data;
> +	int ret;
> +
> +	switch (mask) {
> +
[...]
> +	case IIO_CHAN_INFO_SCALE:
> +		ret = nau7802_i2c_read(st, NAU7802_REG_CTRL1, &data);
> +		if (ret < 0)
> +			return ret;
> +
> +		*val = 0;
> +		*val2 = (((u64)st->vref_mv) * 1000000000ULL) >>
> +			(chan->scan_type.realbits +
> +			 (data & NAU7802_CTRL1_GAINS_BITS));

If you use IIO_VAL_FRACTIONAL_LOG2 this becomes much more readable.

		*val = st->vref_mv;
		*val2 = chan->scan_type.realbits +
				(data & NAU7802_CTRL1_GAINS_BITS);


> +		return IIO_VAL_INT_PLUS_MICRO;
> +	default:
> +		break;
> +	}
> +	return -EINVAL;
> +}
[...]

> +static int nau7802_probe(struct i2c_client *client,
> +			const struct i2c_device_id *id)
> +{
> +	struct iio_dev *idev;
> +	struct nau7802_state *st;
> +	struct device_node *np = client->dev.of_node;
> +	int ret;
> +	u8 data;
> +	u32 tmp;
> +
> +	if (!client->dev.of_node) {
> +		dev_err(&client->dev, "No device tree node available.\n");
> +		return -EINVAL;
> +	}
> +
> +	/*
> +	 * If we have some interrupts declared, use them, if not, fall back
> +	 * on polling.
> +	 */
> +	if (of_find_property(np, "interrupts", NULL)) {
> +		if (client->irq <= 0) {
> +			client->irq = irq_of_parse_and_map(np, 0);
> +			if (client->irq <= 0)
> +				return -EPROBE_DEFER;
> +		}
> +	} else
> +		client->irq = 0;

This looks like something that could go into the of_i2c.c code.

> +
> +	idev = iio_device_alloc(sizeof(struct nau7802_state));
> +	if (idev == NULL)
> +		return -ENOMEM;
> +
> +	st = iio_priv(idev);
> +
> +	i2c_set_clientdata(client, idev);
> +
> +	idev->dev.parent = &client->dev;
> +	idev->name = dev_name(&client->dev);
> +	idev->modes = INDIO_DIRECT_MODE;
> +	idev->info = &nau7802_info;
> +
> +	st->client = client;
> +
> +	/* Reset the device */
> +	nau7802_i2c_write(st, NAU7802_REG_PUCTRL, NAU7802_PUCTRL_RR_BIT);
> +
> +	/* Enter normal operation mode */
> +	nau7802_i2c_write(st, NAU7802_REG_PUCTRL, NAU7802_PUCTRL_PUD_BIT);
> +
> +	/*
> +	 * After about 200 usecs, the device should be ready and then
> +	 * the Power Up bit will be set to 1. If not, wait for it.
> +	 */
> +	do {
> +		udelay(200);
> +		ret = nau7802_i2c_read(st, NAU7802_REG_PUCTRL, &data);
> +		if (ret)
> +			return -ENODEV;
> +	} while (!(data & NAU7802_PUCTRL_PUR_BIT));
> +
> +	of_property_read_u32(np, "nuvoton,vldo", &tmp);
> +	st->vref_mv = tmp;

We've standardized on using the regulator framework for providing voltages.
You should use it here as well.

> +
> +	data = NAU7802_PUCTRL_PUD_BIT | NAU7802_PUCTRL_PUA_BIT |
> +		NAU7802_PUCTRL_CS_BIT;
> +	if (tmp >= 2400)
> +		data |= NAU7802_PUCTRL_AVDDS_BIT;
> +
> +	nau7802_i2c_write(st, NAU7802_REG_PUCTRL, data);
> +	nau7802_i2c_write(st, NAU7802_REG_ADC_CTRL, 0x30);
> +
> +	if (tmp >= 2400) {
> +		data = NAU7802_CTRL1_VLDO((4500 - tmp) / 300);
> +		nau7802_i2c_write(st, NAU7802_REG_CTRL1, data);
> +	}
> +
> +	st->min_conversions = 6;
> +
> +	/*
> +	 * The ADC fires continuously and we can't do anything about
> +	 * it. So we need to have the IRQ disabled by default, and we
> +	 * will enable them back when we will need them..
> +	 */
> +	if (client->irq) {
> +		irq_set_status_flags(client->irq, IRQ_NOAUTOEN);

No driver should be messing with a IRQs flags. Basically if you need irq.h
for your device driver its probably wrong. The proper solution is to
introduce a IRQF_NOAUTOEN.

> +		ret = request_threaded_irq(client->irq,
> +				NULL,
> +				nau7802_eoc_trigger,
> +				IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
> +				client->dev.driver->name,
> +				idev);
> +		if (ret) {
> +			/*
> +			 * What may happen here is that our IRQ controller is
> +			 * not able to get level interrupt but this is required
> +			 * by this ADC as when going over 40 sample per second,
> +			 * the interrupt line may stay high between conversions.
> +			 * So, we continue no matter what but we switch to
> +			 * polling mode.
> +			 */
> +			dev_info(&client->dev,
> +				"Failed to allocate IRQ, using polling mode\n");
> +			client->irq = 0;
> +			/*
> +			 * We are polling, use the fastest sample rate by
> +			 * default
> +			 */
> +			st->sample_rate = 0x7;
> +			nau7802_i2c_write(st, NAU7802_REG_CTRL2,
> +					NAU7802_CTRL2_CRS(st->sample_rate));
> +		}
> +	}
> +
> +	/* Setup the ADC channels available on the board */
> +	ret = nau7802_channel_init(idev);
> +	if (ret < 0) {
> +		dev_err(&client->dev, "Couldn't initialize the channels.\n");
> +		goto error_channel_init;
> +	}
> +
> +	init_completion(&st->value_ok);
> +	mutex_init(&st->lock);
> +	mutex_init(&st->data_lock);
> +
> +	ret = iio_device_register(idev);
> +	if (ret < 0) {
> +		dev_err(&client->dev, "Couldn't register the device.\n");
> +		goto error_device_register;
> +	}
> +
> +	return 0;
> +
> +error_device_register:
> +	mutex_destroy(&st->lock);
> +error_channel_init:
> +	if (client->irq)
> +		free_irq(client->irq, idev);
> +	iio_device_free(idev);
> +	return ret;
> +}
[...]
