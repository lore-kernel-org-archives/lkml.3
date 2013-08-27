Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288Ab3H0IOb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 04:14:31 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:64436 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063Ab3H0IO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 04:14:26 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: linux-gpio@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Archit Taneja <archit@ti.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: Re: [PATCH v5] gpio: pcf857x: Add OF support
Date: Tue, 27 Aug 2013 10:14:21 +0200
Message-ID: <2063335.Uqxok8bYMn@flatron>
User-Agent: KMail/4.11 (Linux/3.10.9-gentoo; KDE/4.11.0; x86_64; ; )
In-Reply-To: <1377590559-14279-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1377590559-14279-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

On Tuesday 27 of August 2013 10:02:39 Laurent Pinchart wrote:
> Add DT bindings for the pcf857x-compatible chips and parse the device
> tree node in the driver.
> 
> Signed-off-by: Laurent Pinchart
> <laurent.pinchart+renesas@ideasonboard.com> ---
>  .../devicetree/bindings/gpio/gpio-pcf857x.txt      | 71
> ++++++++++++++++++++++ drivers/gpio/gpio-pcf857x.c                     
>   | 44 +++++++++++--- 2 files changed, 107 insertions(+), 8
> deletions(-)
>  create mode 100644
> Documentation/devicetree/bindings/gpio/gpio-pcf857x.txt
> 
> Changes since v4:
> 
> - Don't try to get ngpio from of_device_id data, we already get it from
>   i2c_device_id

Hmm, I'm not sure how this is supposed to work.

How does the I2C core resolve OF compatible name to particular entry in 
id_table? I believe it simply passes NULL as the second argument of 
.probe() if the device is instantiated based on OF compatible string and 
not one in the legacy ID table.

> 
> Changes since v3:
> 
> - Get rid of the #ifdef CONFIG_OF in the probe function
> - Give DT node priority over platform data
> 
> Changes since v2:
> 
> - Replace mention about interrupts software configuration in DT bindings
> documentation with an explanation of the hardware configuration.
> 
> diff --git a/Documentation/devicetree/bindings/gpio/gpio-pcf857x.txt
> b/Documentation/devicetree/bindings/gpio/gpio-pcf857x.txt new file mode
> 100644
> index 0000000..d261391
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/gpio/gpio-pcf857x.txt
> @@ -0,0 +1,71 @@
> +* PCF857x-compatible I/O expanders
> +
> +The PCF857x-compatible chips have "quasi-bidirectional" I/O pins that
> can be +driven high by a pull-up current source or driven low to
> ground. This combines +the direction and output level into a single bit
> per pin, which can't be read +back. We can't actually know at
> initialization time whether a pin is configured +(a) as output and
> driving the signal low/high, or (b) as input and reporting a +low/high
> value, without knowing the last value written since the chip came out
> +of reset (if any). The only reliable solution for setting up pin
> direction is +thus to do it explicitly.
> +
> +Required Properties:
> +
> +  - compatible: should be one of the following.
> +    - "maxim,max7328": For the Maxim MAX7378
> +    - "maxim,max7329": For the Maxim MAX7329
> +    - "nxp,pca8574": For the NXP PCA8574
> +    - "nxp,pca8575": For the NXP PCA8575
> +    - "nxp,pca9670": For the NXP PCA9670
> +    - "nxp,pca9671": For the NXP PCA9671
> +    - "nxp,pca9672": For the NXP PCA9672
> +    - "nxp,pca9673": For the NXP PCA9673
> +    - "nxp,pca9674": For the NXP PCA9674
> +    - "nxp,pca9675": For the NXP PCA9675
> +    - "nxp,pcf8574": For the NXP PCF8574
> +    - "nxp,pcf8574a": For the NXP PCF8574A
> +    - "nxp,pcf8575": For the NXP PCF8575
> +    - "ti,tca9554": For the TI TCA9554
> +
> +  - reg: I2C slave address.
> +
> +  - gpio-controller: Marks the device node as a gpio controller.
> +  - #gpio-cells: Should be 2. The first cell is the GPIO number and the
> second +    cell specifies GPIO flags, as defined in
> <dt-bindings/gpio/gpio.h>. Only the +    GPIO_ACTIVE_HIGH and
> GPIO_ACTIVE_LOW flags are supported. +
> +Optional Properties:
> +
> +  - pins-initial-state: Bitmask that specifies the initial state of
> each pin. +  When a bit is set to zero, the corresponding pin will be
> initialized to the +  input (pulled-up) state. When the  bit is set to
> one, the pin will be +  initialized the the low-level output state. If
> the property is not specified +  all pins will be initialized to the
> input state.
> +
> +  The I/O expander can detect input state changes, and thus optionally
> act as +  an interrupt controller. When the expander interrupt pin is
> connected all the +  following properties must be set. For more
> information please see the +  interrupt controller device tree bindings
> documentation available at + 
> Documentation/devicetree/bindings/interrupt-controller/interrupts.txt.
> +
> +  - interrupt-controller: Identifies the node as an interrupt
> controller. +  - #interrupt-cells: Number of cells to encode an
> interrupt source, shall be 2. +  - interrupt-parent: phandle of the
> parent interrupt controller. +  - interrupts: Interrupt specifier for
> the controllers interrupt. +
> +
> +Please refer to gpio.txt in this directory for details of the common
> GPIO +bindings used by client devices.
> +
> +Example: PCF8575 I/O expander node
> +
> +	pcf8575: gpio@20 {
> +		compatible = "nxp,pcf8575";
> +		reg = <0x20>;
> +		interrupt-parent = <&irqpin2>;
> +		interrupts = <3 0>;
> +		gpio-controller;
> +		#gpio-cells = <2>;
> +		interrupt-controller;
> +		#interrupt-cells = <2>;
> +	};
> diff --git a/drivers/gpio/gpio-pcf857x.c b/drivers/gpio/gpio-pcf857x.c
> index 9e61bb0..864dd8c 100644
> --- a/drivers/gpio/gpio-pcf857x.c
> +++ b/drivers/gpio/gpio-pcf857x.c
> @@ -26,6 +26,8 @@
>  #include <linux/irqdomain.h>
>  #include <linux/kernel.h>
>  #include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_device.h>
>  #include <linux/slab.h>
>  #include <linux/spinlock.h>
>  #include <linux/workqueue.h>
> @@ -50,6 +52,27 @@ static const struct i2c_device_id pcf857x_id[] = {
>  };
>  MODULE_DEVICE_TABLE(i2c, pcf857x_id);
> 
> +#ifdef CONFIG_OF
> +static const struct of_device_id pcf857x_of_table[] = {
> +	{ .compatible = "nxp,pcf8574" },
> +	{ .compatible = "nxp,pcf8574a" },
> +	{ .compatible = "nxp,pca8574" },
> +	{ .compatible = "nxp,pca9670" },
> +	{ .compatible = "nxp,pca9672" },
> +	{ .compatible = "nxp,pca9674" },
> +	{ .compatible = "nxp,pcf8575" },
> +	{ .compatible = "nxp,pca8575" },
> +	{ .compatible = "nxp,pca9671" },
> +	{ .compatible = "nxp,pca9673" },
> +	{ .compatible = "nxp,pca9675" },
> +	{ .compatible = "maxim,max7328" },
> +	{ .compatible = "maxim,max7329" },
> +	{ .compatible = "ti,tca9554" },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(of, pcf857x_of_table);
> +#endif
> +
>  /*
>   * The pcf857x, pca857x, and pca967x chips only expose one read and one
> * write register.  Writing a "one" bit (to match the reset state) lets
> @@ -257,14 +280,18 @@ fail:
>  static int pcf857x_probe(struct i2c_client *client,
>  			 const struct i2c_device_id *id)
>  {
> -	struct pcf857x_platform_data	*pdata;
> +	struct pcf857x_platform_data	*pdata = dev_get_platdata(&client-
>dev);
> +	struct device_node		*np = client->dev.of_node;
>  	struct pcf857x			*gpio;
> +	unsigned int			n_latch = 0;
>  	int				status;
> 
> -	pdata = dev_get_platdata(&client->dev);
> -	if (!pdata) {
> +	if (IS_ENABLED(CONFIG_OF) && np)
> +		of_property_read_u32(np, "pins-initial-state", &n_latch);

I believe the convention is that platform data should be favoured, as you 
can pass it even if DT is present, using auxdata table.

So this should rather be:

	if (pdata)
		n_latch = pdata->n_latch;
	else if (IS_ENABLED(CONFIG_OF) && np)
		of_property_read_u32(np, "pins-initial-state", &n_latch);
	else
		dev_dbg(&client->dev, "no platform data\n");

> +	else if (pdata)
> +		n_latch = pdata->n_latch;
> +	else
>  		dev_dbg(&client->dev, "no platform data\n");
> -	}

Other than that, the patch looks good.

Best regards,
Tomasz

