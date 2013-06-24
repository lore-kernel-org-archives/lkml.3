Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550Ab3FXGl3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 02:41:29 -0400
Received: from smtp-out-223.synserver.de ([212.40.185.223]:1101 "EHLO
	smtp-out-223.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064Ab3FXGl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 02:41:27 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 20974
Message-ID: <51C7EA23.1040707@metafoo.de>
Date: Mon, 24 Jun 2013 08:41:39 +0200
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
Subject: Re: [PATCHv2 1/3] iio: Add Nuvoton NAU7802 ADC driver
References: <1371754675-12242-1-git-send-email-alexandre.belloni@free-electrons.com> <1371754675-12242-2-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1371754675-12242-2-git-send-email-alexandre.belloni@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2013 08:57 PM, Alexandre Belloni wrote:
> The Nuvoton NAU7802 ADC is a 24-bit 2-channels I2C ADC, with adjustable
> gain and sampling rates.
> 
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> ---
>  .../bindings/iio/adc/nuvoton-nau7802.txt           |  17 +
>  drivers/iio/adc/Kconfig                            |   9 +
>  drivers/iio/adc/Makefile                           |   1 +
>  drivers/iio/adc/nau7802.c                          | 603 +++++++++++++++++++++
>  4 files changed, 630 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/iio/adc/nuvoton-nau7802.txt
>  create mode 100644 drivers/iio/adc/nau7802.c
> 
> diff --git a/Documentation/devicetree/bindings/iio/adc/nuvoton-nau7802.txt b/Documentation/devicetree/bindings/iio/adc/nuvoton-nau7802.txt
> new file mode 100644
> index 0000000..9bc4218
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/iio/adc/nuvoton-nau7802.txt
> @@ -0,0 +1,17 @@
> +* Nuvoton NAU7802 Analog to Digital Converter (ADC)use
> +
> +Required properties:
> +  - compatible: Should be "nuvoton,nau7802"
> +  - reg: Should contain the ADC I2C address
> +
> +Optional properties:
> +  - nuvoton,vldo: Reference voltage in millivolts (integer)
> +  - interrupts: IRQ line for the ADC. If not used the driver will use
> +    polling.
> +
> +Example:
> +adc2: nau7802@2a {
> +	compatible = "nuvoton,nau7802";
> +	reg = <0x2a>;
> +	nuvoton,vldo = <3000>;

We usually use the regulator framework for specifying the reference voltage.

> +};
[...]
> diff --git a/drivers/iio/adc/nau7802.c b/drivers/iio/adc/nau7802.c
> new file mode 100644
> index 0000000..e1b6981
> --- /dev/null
> +++ b/drivers/iio/adc/nau7802.c
> @@ -0,0 +1,603 @@
[...]
> +static int nau7802_set_gain(struct nau7802_state *st, int gain)
> +{
> +	u8 data;
> +	int ret;
> +
> +	mutex_lock(&st->lock);
> +	st->conversion_count = 0;
> +
> +	data = i2c_smbus_read_byte_data(st->client, NAU7802_REG_CTRL1);
> +	if (data < 0)
> +		goto nau7802_sysfs_set_gain_out;

ret will be uninitialized if the goto above is taken

> +	ret = i2c_smbus_write_byte_data(st->client, NAU7802_REG_CTRL1,
> +					(data & (~NAU7802_CTRL1_GAINS_BITS)) |
> +					gain);
> +
> +nau7802_sysfs_set_gain_out:
> +	mutex_unlock(&st->lock);
> +
> +	return ret ? ret : 0;
> +}
[...]
> +static int nau7802_read_irq(struct iio_dev *indio_dev,
> +			struct iio_chan_spec const *chan,
> +			int *val)
> +{
> +	struct nau7802_state *st = iio_priv(indio_dev);
> +	int ret;
> +
> +	INIT_COMPLETION(st->value_ok);
> +	enable_irq(st->client->irq);

Is it really necessary to enable/disable the IRQ or could you keep it
enabled all the time?

> +
> +	nau7802_sync(st);
> +
> +	/* read registers to ensure we flush everything */
> +	ret = nau7802_read_conversion(st);
> +	if (ret < 0)
> +		goto read_chan_info_failure;
> +
> +	/* Wait for a conversion to finish */
> +	ret = wait_for_completion_interruptible_timeout(&st->value_ok,
> +			msecs_to_jiffies(1000));
> +	if (ret == 0)
> +		ret = -ETIMEDOUT;
> +
> +	if (ret < 0)
> +		goto read_chan_info_failure;
> +
> +	disable_irq(st->client->irq);
> +
> +	*val = st->last_value;
> +
> +	return IIO_VAL_INT;
> +
> +read_chan_info_failure:
> +	disable_irq(st->client->irq);
> +
> +	return ret;
> +}
[...]

[...]
> +static int nau7802_probe(struct i2c_client *client,
> +			const struct i2c_device_id *id)
> +{
> +	struct iio_dev *indio_dev;
> +	struct nau7802_state *st;
> +	struct device_node *np = client->dev.of_node;
> +	int i, ret;
> +	u8 data;
> +	u32 tmp;
> +
> +	if (!client->dev.of_node) {
> +		dev_err(&client->dev, "No device tree node available.\n");
> +		return -EINVAL;
> +	}

Except for getting the vref the is no direct dependency on devicetree, if
you switch to the regulator framework for the vref this check can be removed.

[...]
> +	/* Setup the ADC channels available on the board */
> +	indio_dev->num_channels = 2;

ARRAY_SIZE(nau7802_chan_array)

> +	indio_dev->channels = nau7802_chan_array;
> +
> +	init_completion(&st->value_ok);

You need to initialize the completion before requesting the IRQ handler.

[...]
> +}
