Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751275AbaH1NA0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 09:00:26 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:35464 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750790AbaH1NAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 09:00:24 -0400
Date: Thu, 28 Aug 2014 13:59:15 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Matti Vaittinen <matti.vaittinen@nsn.com>
Cc: "a.zummo@towertech.it" <a.zummo@towertech.it>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "jic23@kernel.org" <jic23@kernel.org>,
        "arno@natisbad.org" <arno@natisbad.org>,
        "jgunthorpe@obsidianresearch.com" <jgunthorpe@obsidianresearch.com>,
        "san@rosetechnology.dk" <san@rosetechnology.dk>,
        "hs@denx.de" <hs@denx.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        Sverdlin Alexander <alexander.sverdlin@nsn.com>
Subject: Re: [PATCH] rtc: ds1307: add trickle charger device tree binding
Message-ID: <20140828125915.GJ14650@leverpostej>
References: <20140828124237.GA29102@fi-ourus-dhcp00977.emea.nsn-net.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140828124237.GA29102@fi-ourus-dhcp00977.emea.nsn-net.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2014 at 01:42:44PM +0100, Matti Vaittinen wrote:
> Patch adding support for specifying trickle charger setup from device
> tree. Patch is based on linux-next tree.
> 
> 
> Some DS13XX devices have "trickle chargers". Introduce a device tree binding
> for specifying the setup and register values.
> 
> Signed-off-by: Matti Vaittinen <matti.vaittinen@nsn.com>
> ---
>  .../devicetree/bindings/i2c/trivial-devices.txt    |  1 -
>  .../devicetree/bindings/rtc/dallas,ds1339.txt      | 19 ++++++++++
>  drivers/rtc/rtc-ds1307.c                           | 44 ++++++++++++++++++++--
>  3 files changed, 59 insertions(+), 5 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/rtc/dallas,ds1339.txt
> 
> diff --git a/Documentation/devicetree/bindings/i2c/trivial-devices.txt b/Documentation/devicetree/bindings/i2c/trivial-devices.txt
> index 6af570e..e9206a4 100644
> --- a/Documentation/devicetree/bindings/i2c/trivial-devices.txt
> +++ b/Documentation/devicetree/bindings/i2c/trivial-devices.txt
> @@ -35,7 +35,6 @@ catalyst,24c32		i2c serial eeprom
>  cirrus,cs42l51		Cirrus Logic CS42L51 audio codec
>  dallas,ds1307		64 x 8, Serial, I2C Real-Time Clock
>  dallas,ds1338		I2C RTC with 56-Byte NV RAM
> -dallas,ds1339		I2C Serial Real-Time Clock
>  dallas,ds1340		I2C RTC with Trickle Charger
>  dallas,ds1374		I2C, 32-Bit Binary Counter Watchdog RTC with Trickle Charger and Reset Input/Output
>  dallas,ds1631		High-Precision Digital Thermometer
> diff --git a/Documentation/devicetree/bindings/rtc/dallas,ds1339.txt b/Documentation/devicetree/bindings/rtc/dallas,ds1339.txt
> new file mode 100644
> index 0000000..9faf40e
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/rtc/dallas,ds1339.txt
> @@ -0,0 +1,19 @@
> +* Dallas DS1339		I2C Serial Real-Time Clock
> +
> +Required properties:
> +- compatible: Should contain "dallas,ds1339".
> +- reg: I2C address for chip
> +
> +Optional properties:
> +- trickle_setup : Used Trickle Charger configuration,
> +        corresponding to 5 lowest bits in trickle charger register.

s/_/-/ in property names please.

What do these bits do? is there any documentation available?

Why do they need to be in the DT?

Why do we not have a higher-level description?

> +- trickle_reg   : Trickle charger register address. Defaults to 0x10 for ds1339.

Is this expected to change? Why does this need to be in the DT?

> +
> +Example:
> +	ds1339: rtc@68 {
> +		compatible = "dallas,ds1339";
> +        trickle_setup= <0x5>;
> +		reg = <0x68>;
> +	};
> +
> +
> diff --git a/drivers/rtc/rtc-ds1307.c b/drivers/rtc/rtc-ds1307.c
> index f03d5ba..f9b1244 100644
> --- a/drivers/rtc/rtc-ds1307.c
> +++ b/drivers/rtc/rtc-ds1307.c
> @@ -126,9 +126,10 @@ struct chip_desc {
>  	u16			nvram_offset;
>  	u16			nvram_size;
>  	u16			trickle_charger_reg;
> +	u8		  trickle_charger_setup;
>  };
>  
> -static const struct chip_desc chips[last_ds_type] = {
> +static struct chip_desc chips[last_ds_type] = {
>  	[ds_1307] = {
>  		.nvram_offset	= 8,
>  		.nvram_size	= 56,
> @@ -835,13 +836,37 @@ ds1307_nvram_write(struct file *filp, struct kobject *kobj,
>  
>  /*----------------------------------------------------------------------*/
>  
> +static void trickle_charger_of_init(struct chip_desc *chip,
> +			struct device_node *node)
> +{
> +	int plen = 0;
> +	const uint32_t *setup;
> +	const uint32_t *reg;
> +
> +	setup = of_get_property(node, "trickle_setup" , &plen);
> +	if (plen != 4)
> +		goto out;
> +	chip->trickle_charger_setup = (u8)*setup;

This isn't endian-clean, and the casting is unnecessary.

Use the of_property_read_u32 accessor, with a u32 temporary variable.

> +	plen = 0;
> +	reg = of_get_property(node, "trickle_reg" , &plen);
> +	if (plen == 4)
> +		chip->trickle_charger_reg = (u16)*reg;

Likewise.

Mark.
