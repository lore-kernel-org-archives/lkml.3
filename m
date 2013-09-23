Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641Ab3IWLIq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 07:08:46 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:38545 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753159Ab3IWLIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 07:08:44 -0400
Date: Mon, 23 Sep 2013 12:08:39 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Cc: "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "rob@landley.net" <rob@landley.net>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "t.figa@samsung.com" <t.figa@samsung.com>
Subject: Re: [PATCH] MTD: Onenand: Add device tree support for samsung
 onenand
Message-ID: <20130923110839.GB16069@e106331-lin.cambridge.arm.com>
References: <1379925388-25051-1-git-send-email-m.krawczuk@partner.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379925388-25051-1-git-send-email-m.krawczuk@partner.samsung.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 23, 2013 at 09:36:28AM +0100, Mateusz Krawczuk wrote:
> This patch add clk and device tree nodes for samsung onenand driver.
> 
> Signed-off-by: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  .../devicetree/bindings/mtd/samsung-onenand.txt    | 40 ++++++++++++++++++++++
>  drivers/mtd/onenand/samsung.c                      | 37 +++++++++++++++++++-
>  2 files changed, 76 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/devicetree/bindings/mtd/samsung-onenand.txt
> 
> diff --git a/Documentation/devicetree/bindings/mtd/samsung-onenand.txt b/Documentation/devicetree/bindings/mtd/samsung-onenand.txt
> new file mode 100644
> index 0000000..cc46160
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mtd/samsung-onenand.txt
> @@ -0,0 +1,40 @@
> +Device tree bindings for Samsung Onenand
> +
> +Required properties:
> +  - compatible: value should be either of the following.
> +      (a) "samsung, s3c6400-onenand", for onenand compatible with s3c6400 onenand.
> +      (b) "samsung, s3c6410-onenand", for onenand compatible with s3c6410 onenand.
> +      (c) "samsung, s5pc100-onenand", for onenand compatible with s5pc100 onenand.
> +      (d) "samsung, s5pc110-onenand", for s5pc100-like onenand used
> +	   on s5pc110 which supports DMA.

These compatible strings shouldn't have spaces.

What are the differences between these, beyond "s5pc110-onenand"
supporting DMA and the others not supporting DMA?

Can we describe these more generically, or do they differ all over the
place in register offsets and so on?

> +
> +Required properties:
> +
> + - reg:					The CS line the peripheral
> +					is connected to

That's not a fantastic description.

As a start, how about something like:

 - reg: the offset and length of the control registers.

> + - interrupt-parent, interrupts		Width of the ONENAND device
> + - 					connected to the Samsung SoC
> +					in bytes. Must be 1 or 2.

Huh? This makes no sense.

Was this was hacked up from the gpmc-onenand binding?

> +
> +Optional properties:
> +
> + - dma-channel:		DMA Channel index

Is this channel internal to the onenand device? If so, why does it need
to be described in this way?

Is this an unnecessary carry-over from the gpmc-onenand binding?

> +
> +For inline partiton table parsing (optional):
> +
> + - #address-cells: should be set to 1
> + - #size-cells: should be set to 1
> +
> +Example for an s5pv210 board:
> +
> +		onenand@b0000000 {
> +			compatible = "samsung,s5pc110-onenand";
> +			reg = <0xb0000000 0x20000>, <0xb0600000 0x2000>;

You only described on reg region above.

Do you expect two, or any arbitrary number of regions?

What does each represent?

> +			interrupt-parent = <&vic1>;
> +			interrupts = <31>;
> +			#address-cells = <1>;
> +			#size-cells = <1>;
> +			clocks = <&clocks NANDXL>;
> +			clock-names = "gate";

The clocks weren't described in the binding. They should be.

> +			status = "okay";
> +		};
> diff --git a/drivers/mtd/onenand/samsung.c b/drivers/mtd/onenand/samsung.c
> index df7400d..5a2cc4b 100644
> --- a/drivers/mtd/onenand/samsung.c
> +++ b/drivers/mtd/onenand/samsung.c
> @@ -14,6 +14,7 @@
>   *	S5PC110: use DMA
>   */
>  
> +#include <linux/clk.h>
>  #include <linux/module.h>
>  #include <linux/platform_device.h>
>  #include <linux/sched.h>
> @@ -24,6 +25,7 @@
>  #include <linux/dma-mapping.h>
>  #include <linux/interrupt.h>
>  #include <linux/io.h>
> +#include <linux/of.h>
>  
>  #include <asm/mach/flash.h>
>  
> @@ -133,6 +135,7 @@ enum soc_type {
>  struct s3c_onenand {
>  	struct mtd_info	*mtd;
>  	struct platform_device	*pdev;
> +	struct clk *gate;
>  	enum soc_type	type;
>  	void __iomem	*base;
>  	struct resource *base_res;
> @@ -859,6 +862,19 @@ static void s3c_onenand_setup(struct mtd_info *mtd)
>  	this->write_bufferram = onenand_write_bufferram;
>  }
>  
> +static const struct of_device_id onenand_s3c_dt_match[] = {
> +	{ .compatible = "samsung,s3c6400-onenand",
> +		.data = (void *)TYPE_S3C6400 },
> +	{ .compatible = "samsung,s3c6410-onenand",
> +		.data = (void *)TYPE_S3C6410 },
> +	{ .compatible = "samsung,s5pc100-onenand",
> +		.data = (void *)TYPE_S5PC100 },
> +	{ .compatible = "samsung,s5pc110-onenand",
> +		.data = (void *)TYPE_S5PC110 },
> +	{},
> +};

What are the differences between these?

Cheers,
Mark.

> +MODULE_DEVICE_TABLE(of, onenand_s3c_dt_match);
> +
>  static int s3c_onenand_probe(struct platform_device *pdev)
>  {
>  	struct onenand_platform_data *pdata;
> @@ -883,12 +899,26 @@ static int s3c_onenand_probe(struct platform_device *pdev)
>  		goto onenand_fail;
>  	}
>  
> +	onenand->gate = clk_get(&pdev->dev, "gate");
> +	if (IS_ERR(onenand->gate))
> +		return PTR_ERR(onenand->gate);
> +	clk_prepare_enable(onenand->gate);
> +
>  	this = (struct onenand_chip *) &mtd[1];
>  	mtd->priv = this;
>  	mtd->dev.parent = &pdev->dev;
>  	mtd->owner = THIS_MODULE;
>  	onenand->pdev = pdev;
> -	onenand->type = platform_get_device_id(pdev)->driver_data;
> +
> +	if (pdev->dev.of_node) {
> +		const struct of_device_id *match;
> +
> +		match = of_match_node(onenand_s3c_dt_match, pdev->dev.of_node);
> +		onenand->type = (enum soc_type)match->data;
> +	} else {
> +		onenand->type = platform_get_device_id(pdev)->driver_data;
> +	}
> +
>  
>  	s3c_onenand_setup(mtd);
>  
> @@ -1077,6 +1107,10 @@ static int s3c_onenand_remove(struct platform_device *pdev)
>  	kfree(onenand->page_buf);
>  	kfree(onenand);
>  	kfree(mtd);
> +
> +	clk_disable_unprepare(onenand->gate);
> +	clk_put(onenand->gate);
> +
>  	return 0;
>  }
>  
> @@ -1125,6 +1159,7 @@ MODULE_DEVICE_TABLE(platform, s3c_onenand_driver_ids);
>  static struct platform_driver s3c_onenand_driver = {
>  	.driver         = {
>  		.name	= "samsung-onenand",
> +		.of_match_table = of_match_ptr(onenand_s3c_dt_match),
>  		.pm	= &s3c_pm_ops,
>  	},
>  	.id_table	= s3c_onenand_driver_ids,
> -- 
> 1.8.1.2
> 
> 
