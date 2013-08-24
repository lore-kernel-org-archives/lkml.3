Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603Ab3HXAmK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 20:42:10 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:45192 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753990Ab3HXAmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 20:42:07 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH v2 3/3] gpio: pcf857x: Add OF support
Date: Sat, 24 Aug 2013 02:41:59 +0200
Message-ID: <5465986.lNHQvRvp7j@flatron>
User-Agent: KMail/4.11 (Linux/3.10.9-gentoo; KDE/4.11.0; x86_64; ; )
In-Reply-To: <1376953494-9684-4-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1376953494-9684-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <1376953494-9684-4-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

On Tuesday 20 of August 2013 01:04:54 Laurent Pinchart wrote:
> Add DT bindings for the pcf857x-compatible chips and parse the device
> tree node in the driver.
> 
> Signed-off-by: Laurent Pinchart
> <laurent.pinchart+renesas@ideasonboard.com> ---
>  .../devicetree/bindings/gpio/gpio-pcf857x.txt      | 71
> ++++++++++++++++++++++ drivers/gpio/gpio-pcf857x.c                     
>   | 57 ++++++++++++++--- 2 files changed, 119 insertions(+), 9
> deletions(-)
>  create mode 100644
> Documentation/devicetree/bindings/gpio/gpio-pcf857x.txt
> 
> diff --git a/Documentation/devicetree/bindings/gpio/gpio-pcf857x.txt
> b/Documentation/devicetree/bindings/gpio/gpio-pcf857x.txt new file mode
> 100644
> index 0000000..df94462
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

Hmm, do you actually need to know whether those pins are outputs or inputs 
before they get used for first time? I believe any driver using GPIO will 
call gpio_direction_{in,out}put() before it starts using the pin, which 
will initialize the pin to a known state.

What I'd suggest is making the driver handle this by having a bit mask 
that marks states of pins as defined and flagging all pins as undefined by 
default. Then any call to gpio_direction_output() or _input() would mark 
it as defined and direction of the pin could be stored in internal driver 
structures.

> +  The I/O expander can detect input state changes, and thus optionally
> act as +  an interrupt controller. When interrupts support is desired

I don't like this statement. Device tree should represent what the device 
allows you to do, not what you want the device to do.

My opinion on this is that if the chip supports interrupts then it should 
always be an interrupt-controller (unless its interrupt pin is not wired 
on the board, but this still conforms to what I wrote above).

> all the following +  properties must be set. For more information
> please see the interrupt +  controller device tree bindings
> documentation available at
> + 
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
> index 070e81f..50a90f1 100644
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
> +	{ .compatible = "nxp,pcf8574", .data = (void *)8 },
> +	{ .compatible = "nxp,pcf8574a", .data = (void *)8 },
> +	{ .compatible = "nxp,pca8574", .data = (void *)8 },
> +	{ .compatible = "nxp,pca9670", .data = (void *)8 },
> +	{ .compatible = "nxp,pca9672", .data = (void *)8 },
> +	{ .compatible = "nxp,pca9674", .data = (void *)8 },
> +	{ .compatible = "nxp,pcf8575", .data = (void *)16 },
> +	{ .compatible = "nxp,pca8575", .data = (void *)16 },
> +	{ .compatible = "nxp,pca9671", .data = (void *)16 },
> +	{ .compatible = "nxp,pca9673", .data = (void *)16 },
> +	{ .compatible = "nxp,pca9675", .data = (void *)16 },
> +	{ .compatible = "maxim,max7328", .data = (void *)8 },
> +	{ .compatible = "maxim,max7329", .data = (void *)8 },
> +	{ .compatible = "ti,tca9554", .data = (void *)8 },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(of, pcf857x_of_table);
> +#endif
> +
>  /*
>   * The pcf857x, pca857x, and pca967x chips only expose one read and one
> * write register.  Writing a "one" bit (to match the reset state) lets
> @@ -257,14 +280,29 @@ fail:
>  static int pcf857x_probe(struct i2c_client *client,
>  			 const struct i2c_device_id *id)
>  {
> -	struct pcf857x_platform_data	*pdata;
> +	struct pcf857x_platform_data	*pdata = client-
>dev.platform_data;
> +	struct device_node		*np = client->dev.of_node;
>  	struct pcf857x			*gpio;
> +	unsigned int			n_latch = 0;
> +	unsigned int			ngpio;
>  	int				status;
> 
> -	pdata = client->dev.platform_data;
> -	if (!pdata) {
> +#ifdef CONFIG_OF
> +	if (np) {

Wouldn't if (IS_ENABLED(CONFIG_OF) && np) be sufficient here, without the 
#ifdef? You would have to move the match table out of the #ifdef in this 
case, though...

Best regards,
Tomasz

> +		const struct of_device_id *of_id;
> +
> +		of_id = of_match_device(pcf857x_of_table, &client->dev);
> +		ngpio = (unsigned int)of_id->data;
> +	} else
> +#endif
> +		ngpio = id->driver_data;
> +
