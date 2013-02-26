Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756695Ab3BZHlr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 02:41:47 -0500
Received: from mail-we0-f179.google.com ([74.125.82.179]:49827 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768Ab3BZHlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 02:41:46 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] gpio/gpio-generic: Add OF bindings
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Cc: Rob Herring <rob.herring@calxeda.com>
In-Reply-To: <20121207231017.GC29262@obsidianresearch.com>
References: <20121207231017.GC29262@obsidianresearch.com>
Date: Tue, 26 Feb 2013 07:41:18 +0000
Message-Id: <20130226074118.BA9F83E08BF@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Dec 2012 16:10:17 -0700, Jason Gunthorpe <jgunthorpe@obsidianresearch.com> wrote:
> Allow the platform driver to bind through OF. The existing
> OF machinery for setting the resource names through OF is used to
> configure the device, so the change is minimally intrusive and
> fully featured.
> 
> Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>

Hi Jason,

Thanks for looking at this. I've wanted this feature for a while now,
but I haven't liked the bindings that I've seen so far because each
individual register is broken out into separate reg tuples. Blech. Too
much unlike existing bindings.

The root problem is that the bindings all try to match the current
basic-mmio-gpio pdata implementation which uses a separate resource
structure for each register, and the bindings have all followed that
pattern, but that runs pretty contrary to established device tree
conventions. What I'd much rather see is a single resource for the block
of registers and properties laying out the offsets to the registers and
the access width. I also think the method of access (dat, set+clr,
dirin, dirout) should be specified explicity, not implicitly by the
registers that are defined. I think the binding should also allow for
multiple register banks since several gpio devices are arranged that way.
Something like the following (rough draft, needs to be refined):

	* General purpose MMIO GPIO controller

	Required properties:
	- compatible: "mmio-gpio"
	- reg: Address of register block
	- reg-io-width: Access width in bytes (1, 2, 4 or 8)
	- #gpio-cells: Should be two.
	- gpio-controller: Marks the device node as a GPIO controller.
	- gpio-io-type: One of: "data"
	Required depending on access mode:
	- gpio-io-datain: list of offsets to data registers, one per bank
	- gpio-io-dataout: list of offsets to data out registers, one per bank
	- gpio-io-dataset: list of offsets to data set registers, one per bank
	- gpio-io-dataclr: list of offsets to data clear registers, one per bank
	Required depending on how direction is set:
	- gpio-io-dirin: list of offsets to direction in registers, one per bank
	- gpio-io-dirout: list of offsets to direction out registers, one per bank

There are two ways you can do this, adapt the current basic-mmio-gpio
driver to use a since resource region for the whole block, or create a
new driver that will work nicely with the binding I've described above.
I prefer adapting the current driver since there are only 4 actual users
of that driver in tree, and all of them are trivial.  It is easy to fix.

Also, it should be possible to move existing mmio gpio controllers over
to this new driver /without/ changing their bindings. (I'm not asking
you to do this, just thinking out loud). This can be done by adding
their compatible property to the match table and using the data field to
carry a pdata structure for that device.

g.

> ---
>  .../devicetree/bindings/gpio/gpio-generic.txt      |   28 ++++++++++++++++++++
>  drivers/gpio/gpio-generic.c                        |   18 ++++++++++++-
>  2 files changed, 45 insertions(+), 1 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/gpio/gpio-generic.txt
> 
> diff --git a/Documentation/devicetree/bindings/gpio/gpio-generic.txt b/Documentation/devicetree/bindings/gpio/gpio-generic.txt
> new file mode 100644
> index 0000000..12b4989
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/gpio/gpio-generic.txt
> @@ -0,0 +1,28 @@
> +* General purpose MMIO GPIO controller
> +
> +Required properties:
> +- compatible: "linux,basic-mmio-gpio" or "linux,basic-mmio-gpio-be",
> +  the choice determines which bit is considered GPIO #0
> +- reg and reg-names: An array of named register ranges describing the windows,
> +  in one of these combinations:
> +   * 'dat' - Single input/output data register.
> +   * 'dat', 'set' and 'clr' - 'dat' is the input and drive 1 writes high to 'set'
> +                              and drive 0 writes high to 'clr'
> +   * 'dat' and 'set' - 'dat' is the input and drive 1 write high to 'set' and
> +                       drive 0 writes low to set
> +  Additionally one of these may be specified:
> +   * dirout - Write 1 to set as output, 0 to set as input
> +   * dirin - Write 1 to set as input, 0 to set as output
> +
> +  The size of the registers should be 1, 4 or 8.
> +- #gpio-cells: Should be two.
> +- gpio-controller: Marks the device node as a GPIO controller.
> +
> +Example:
> +	gpio0: gpio@8 {
> +	        #gpio-cells = <2>;
> +		compatible = "linux,basic-mmio-gpio";
> +		gpio-controller;
> +		reg-names = "dat", "set", "dirin";
> +		reg = <0x8 4>, <0xc 4>, <0x10 4>;
> +	};
> diff --git a/drivers/gpio/gpio-generic.c b/drivers/gpio/gpio-generic.c
> index 82e2e4f..f71a917 100644
> --- a/drivers/gpio/gpio-generic.c
> +++ b/drivers/gpio/gpio-generic.c
> @@ -458,6 +458,7 @@ static int __devinit bgpio_pdev_probe(struct platform_device *pdev)
>  	int err;
>  	struct bgpio_chip *bgc;
>  	struct bgpio_pdata *pdata = dev_get_platdata(dev);
> +	const char *name;
>  
>  	r = platform_get_resource_byname(pdev, IORESOURCE_MEM, "dat");
>  	if (!r)
> @@ -485,7 +486,13 @@ static int __devinit bgpio_pdev_probe(struct platform_device *pdev)
>  	if (err)
>  		return err;
>  
> -	if (!strcmp(platform_get_device_id(pdev)->name, "basic-mmio-gpio-be"))
> +	name = platform_get_device_id(pdev)->name;
> +	if (name && !strcmp(name, "basic-mmio-gpio-be"))
> +		flags |= BGPIOF_BIG_ENDIAN;
> +
> +	if (pdev->dev.of_node &&
> +	    of_device_is_compatible(pdev->dev.of_node,
> +				    "linux,basic-mmio-gpio-be"))
>  		flags |= BGPIOF_BIG_ENDIAN;
>  
>  	bgc = devm_kzalloc(&pdev->dev, sizeof(*bgc), GFP_KERNEL);
> @@ -521,9 +528,18 @@ static const struct platform_device_id bgpio_id_table[] = {
>  };
>  MODULE_DEVICE_TABLE(platform, bgpio_id_table);
>  
> +static const struct of_device_id bgpio_ofid_table[] __devinitdata = {
> +	{.compatible = "linux,basic-mmio-gpio"},
> +	{.compatible = "linux,basic-mmio-gpio-be"},
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, bgpio_ofid_table);
> +
>  static struct platform_driver bgpio_driver = {
>  	.driver = {
>  		.name = "basic-mmio-gpio",
> +		.owner = THIS_MODULE,
> +		.of_match_table = of_match_ptr(bgpio_ofid_table),
>  	},
>  	.id_table = bgpio_id_table,
>  	.probe = bgpio_pdev_probe,
> -- 
> 1.7.5.4
> 

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
