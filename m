Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964932Ab3BMVC4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 16:02:56 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:59851 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964902Ab3BMVCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 16:02:53 -0500
Message-ID: <511BFF77.2090202@wwwdotorg.org>
Date: Wed, 13 Feb 2013 14:02:47 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>
CC: Wolfram Sang <w.sang@pengutronix.de>, Simon Glass <sjg@chromium.org>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Yuvaraj Kumar <yuvaraj.cd@gmail.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>, u.kleine-koenig@pengutronix.de,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Girish Shivananjappa <girish.shivananjappa@linaro.org>,
        bhushan.r@samsung.com, sreekumar.c@samsung.com,
        Prashanth G <prashanth.g@samsung.com>, Olof Johansson <olof@lixom.net>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Grant Grundler <grundler@chromium.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Jean Delvare <khali@linux-fr.org>,
        Peter Korsgaard <peter.korsgaard@barco.com>,
        Stephen Warren <swarren@nvidia.com>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH v1 1/4] i2c: mux: Add i2c-arbitrator 'mux' driver
References: <1360778532-7480-1-git-send-email-dianders@chromium.org>
In-Reply-To: <1360778532-7480-1-git-send-email-dianders@chromium.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2013 11:02 AM, Doug Anderson wrote:
> The i2c-arbitrator driver implements the arbitration scheme that the
> Embedded Controller (EC) on the ARM Chromebook expects to use for bus
> multimastering.  This i2c-arbitrator driver could also be used in
> other places where standard i2c bus arbitration can't be used and two
> extra GPIOs are available for arbitration.
> 
> This driver is based on code that Simon Glass added to the i2c-s3c2410
> driver in the Chrome OS kernel 3.4 tree.  The current incarnation as a
> mux driver is as suggested by Grant Likely.  See
> <https://patchwork.kernel.org/patch/1877311/> for some history.

> diff --git a/Documentation/devicetree/bindings/i2c/i2c-arbitrator.txt b/Documentation/devicetree/bindings/i2c/i2c-arbitrator.txt

> +This mechanism is used instead of standard i2c multimaster to avoid some of the
> +subtle driver and silicon bugs that are often present with i2c multimaster.

Being really pick here, but I2C should be capitalized in free-form text.
There are a few other places where the comment applies.

> +Required properties:
> +- compatible: i2c-arbitrator

That seems pretty generic. What if there are other arbitration schemes?

> +- bus-arbitration-gpios: Two GPIOs to use with the GPIO-based bus
> +    arbitration protocol.  The first should be an output, and is used to
> +    claim the I2C bus for us (AP_CLAIM).  The second should be an input and
> +    signals that the other side wants to claim the bus (EC_CLAIM).

Is it worth using two separate properties here, so they each get a
unique name. That way, nobody has the remember which order the two GPIOs
come in.

> diff --git a/drivers/i2c/muxes/i2c-arbitrator.c b/drivers/i2c/muxes/i2c-arbitrator.c

> +enum {
> +	I2C_ARB_GPIO_AP,		/* AP claims i2c bus */
> +	I2C_ARB_GPIO_EC,		/* EC claims i2c bus */
> +
> +	I2C_ARB_GPIO_COUNT,
> +};

Oh, I see from later code that those are indices into the
bus-arbitration-gpios DT property. I thought they were states in some
state machine at first. A comment might help here, if you continue to
use one property.

> +static int i2c_arbitrator_select(struct i2c_adapter *adap, void *data, u32 chan)
> +{
> +	const struct i2c_arbitrator_data *arb = data;
> +	unsigned long stop_retry, stop_time;
> +
> +	/* Start a round of trying to claim the bus */
> +	stop_time = jiffies + usecs_to_jiffies(arb->wait_free_us) + 1;
> +	do {
> +		/* Indicate that we want to claim the bus */
> +		gpio_set_value(arb->ap_gpio, 0);

The GPIO signals appear to be active low in the code. Instead, I think
it'd make more sense to extract the polarity of the GPIO from DT, using
of_get_named_gpio_flags().

> +static int i2c_arbitrator_probe(struct platform_device *pdev)

> +	/* Request GPIOs */
> +	ret = of_get_named_gpio(np, "bus-arbitration-gpios", I2C_ARB_GPIO_AP);
> +	if (gpio_is_valid(ret)) {
> +		arb->ap_gpio = ret;
> +		ret = gpio_request_one(arb->ap_gpio, GPIOF_OUT_INIT_HIGH,
> +				       "bus-arbitration-ap");
> +	}
> +	if (WARN_ON(ret))
> +		goto ap_request_failed;

you could use devm_gpio_request_one() and save some cleanup logic.

> +	/* Arbitration parameters */
> +	if (of_property_read_u32(np, "bus-arbitration-slew-delay-us",
> +				 &arb->slew_delay_us))
> +		arb->slew_delay_us = 10;

The DT binding document says that property is required. Either the code
should error out here, or the document updated to indicate that the
properties are optional, and specify what the defaults are.

> +static int i2c_arbitrator_remove(struct platform_device *pdev)

> +	platform_set_drvdata(pdev, NULL);

You shouldn't have to do that; nothing should care what the pdata value
is while the device isn't probed anyway.

> +static int __init i2c_arbitrator_init(void)
> +{
> +	return platform_driver_register(&i2c_arbitrator_driver);
> +}
> +subsys_initcall(i2c_arbitrator_init);
> +
> +static void __exit i2c_arbitrator_exit(void)
> +{
> +	platform_driver_unregister(&i2c_arbitrator_driver);
> +}
> +module_exit(i2c_arbitrator_exit);

You should be able to replace all that with:

module_platform_driver(&i2c_arbitrator_driver);

> +MODULE_LICENSE("GPL");

The header says GPL v2 only, so "GPL v2".
