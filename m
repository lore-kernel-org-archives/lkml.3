Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398Ab3AaLX2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 06:23:28 -0500
Received: from service87.mimecast.com ([91.220.42.44]:45083 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980Ab3AaLXZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 06:23:25 -0500
Date: Thu, 31 Jan 2013 11:23:03 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: "Manjunathappa, Prakash" <prakash.pm@ti.com>
Cc: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "mporter@ti.com" <mporter@ti.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "nsekhar@ti.com" <nsekhar@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "hs@denx.de" <hs@denx.de>, "ido@wizery.com" <ido@wizery.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/3] mmc: davinci_mmc: add DT support
Message-ID: <20130131112303.GA7235@e106331-lin.cambridge.arm.com>
References: <1359628387-14437-1-git-send-email-prakash.pm@ti.com>
 <1359628387-14437-3-git-send-email-prakash.pm@ti.com>
MIME-Version: 1.0
In-Reply-To: <1359628387-14437-3-git-send-email-prakash.pm@ti.com>
Thread-Topic: [PATCH 2/3] mmc: davinci_mmc: add DT support
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 31 Jan 2013 11:23:08.0177 (UTC) FILETIME=[586BF810:01CDFFA5]
X-MC-Unique: 113013111230902901
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have a few comments on the devicetree binding and the way it's parsed.

On Thu, Jan 31, 2013 at 10:33:06AM +0000, Manjunathappa, Prakash wrote:
> Adds device tree support for davinci_mmc. Also add
> binding documentation.
> Tested with non-dma PIO mode and without GPIO
> card_detect/write_protect option because of
> dependencies on EDMA and GPIO modules DT support.
> 
> Signed-off-by: Manjunathappa, Prakash <prakash.pm@ti.com>
> Cc: linux-mmc@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> Cc: davinci-linux-open-source@linux.davincidsp.com
> Cc: devicetree-discuss@lists.ozlabs.org
> Cc: cjb@laptop.org
> Cc: Sekhar Nori <nsekhar@ti.com>
> Cc: mporter@ti.com
> ---
>  .../devicetree/bindings/mmc/davinci_mmc.txt        |   23 +++++++
>  drivers/mmc/host/davinci_mmc.c                     |   69 +++++++++++++++++++-
>  2 files changed, 91 insertions(+), 1 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/mmc/davinci_mmc.txt
> 
> diff --git a/Documentation/devicetree/bindings/mmc/davinci_mmc.txt b/Documentation/devicetree/bindings/mmc/davinci_mmc.txt
> new file mode 100644
> index 0000000..144bee6
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mmc/davinci_mmc.txt
> @@ -0,0 +1,23 @@
> +* TI Highspeed MMC host controller for DaVinci
> +
> +The Highspeed MMC Host Controller on TI DaVinci family
> +provides an interface for MMC, SD and SDIO types of memory cards.
> +
> +This file documents differences between the core properties described
> +by mmc.txt and the properties used by the davinci_mmc driver.
> +
> +Required properties:
> +- compatible:
> + Should be "ti,davinci_mmc", for davinci controllers

"ti,davinci-mmc" (with '-' rather than '_') would be preferable.

> +
> +Optional properties:
> +- bus-width: Number of data lines, can be <1>, <4>, or <8>, default <1>
> +- max-frequency: maximum operating clock frequency.

You said you only described differences from mmc.txt, but this is listed in
mmc.txt.

> +- caps: Check for Host capabilities in <linux/mmc/host.h>

Is this a set of binary flags? Also, is this Linux-specific?

I really don't think this should be in the devicetree binding. Why do you need
this?

> +- version: version of controller.

This should be encoded as part of the compatible string.

> +Example:
> +	mmc1: mmc@0x4809c000 {
> +		compatible = "ti,omap4-hsmmc";
> +		reg = <0x4809c000 0x400>;
> +		bus-width = <4>;
> +	};

It would be nice if the example referred to this binding rather than another.

> diff --git a/drivers/mmc/host/davinci_mmc.c b/drivers/mmc/host/davinci_mmc.c
> index 382b79d..ce6730d 100644
> --- a/drivers/mmc/host/davinci_mmc.c
> +++ b/drivers/mmc/host/davinci_mmc.c
> @@ -34,6 +34,7 @@
>  #include <linux/dma-mapping.h>
>  #include <linux/edma.h>
>  #include <linux/mmc/mmc.h>
> +#include <linux/of.h>
>  
>  #include <linux/platform_data/mmc-davinci.h>
>  
> @@ -1156,16 +1157,75 @@ static void __init init_mmcsd_host(struct mmc_davinci_host *host)
>  
>  	mmc_davinci_reset_ctrl(host, 0);
>  }
> +#ifdef CONFIG_OF
> +static struct davinci_mmc_config
> +	*mmc_of_get_pdata(struct platform_device *pdev)
> +{
> +	struct device_node *np;
> +	struct davinci_mmc_config *pdata = NULL;
> +	u32 data;
> +	int ret;
> +
> +	pdata = pdev->dev.platform_data;
> +	if (!pdata) {
> +		pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
> +		if (!pdata) {
> +			dev_err(&pdev->dev, "Failed to allocate memory for struct davinci_mmc_config\n");
> +			goto nodata;
> +		}
> +	}

Why do you need to conditionally allocate this? This only seems to be called
once.

> +
> +	np = pdev->dev.of_node;
> +	if (!np)
> +		goto nodata;

Why not just return immediately here? You do nothing special at nodata.

> +
> +	ret = of_property_read_u32(np, "bus-width", &data);
> +	if (ret)
> +		dev_info(&pdev->dev, "wires not specified, defaulting to 4 bit mode\n");
> +	pdata->wires = data;

That dev_info doesn't seem to match up with what the next line is doing (data
might not have been initialised). Also, unless I've misunderstood, it doesn't
match up with the default of 1 mentioned in the binding doc.

> +
> +	ret = of_property_read_u32(np, "max-frequency", &data);
> +	if (ret)
> +		dev_info(&pdev->dev, "max-frequency not specified, defaulting to 25MHz\n");
> +	pdata->max_freq = data;

Again, the dev_info doesn't match up with the line below it. I notice
the default's not one specified in the binding. Is this frequency chosen
from the hardware docs, or is it an arbitrary choice. If not arbitrary,
it might be worth specifying in the binding.


> +
> +	ret = of_property_read_u32(np, "caps", &data);
> +	if (ret)
> +		dev_info(&pdev->dev, "card capability not specified\n");
> +	pdata->caps = data;

Again, you may be using garbage data.

> +
> +	ret = of_property_read_u32(np, "version", &data);
> +	if (ret)
> +		dev_err(&pdev->dev, "version not specified\n");
> +	pdata->version = data;

And again, though I'd prefer to see this property go entirely.

> +
> +nodata:
> +	return pdata;
> +}
> +
> +#else
> +static struct davinci_mmc_config
> +	*mmc_of_get_pdata(struct platform_device *pdev)
> +{
> +	return pdev->dev.platform_data;
> +}
> +#endif

This is poorly named if it's required for !CONFIG_OF.

Why not change this to something like mmc_parse_pdata, returning an
error code. For !CONFIG_OF, it can simply return 0, which should be less
surprising for anyone else reading this code.

>  
>  static int __init davinci_mmcsd_probe(struct platform_device *pdev)
>  {
> -	struct davinci_mmc_config *pdata = pdev->dev.platform_data;
> +	struct davinci_mmc_config *pdata = NULL;
>  	struct mmc_davinci_host *host = NULL;
>  	struct mmc_host *mmc = NULL;
>  	struct resource *r, *mem = NULL;
>  	int ret = 0, irq = 0;
>  	size_t mem_size;
>  
> +	pdata = mmc_of_get_pdata(pdev);
> +	if (pdata == NULL) {
> +		dev_err(&pdev->dev, "Can not get platform data\n");
> +		return -ENOENT;
> +	}
> +
>  	/* REVISIT:  when we're fully converted, fail if pdata is NULL */
>  
>  	ret = -ENODEV;
> @@ -1403,11 +1463,18 @@ static const struct dev_pm_ops davinci_mmcsd_pm = {
>  #define davinci_mmcsd_pm_ops NULL
>  #endif
>  
> +static const struct of_device_id davinci_mmc_of_match[] = {
> +	{.compatible = "ti,davinci_mmc", },
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, davinci_mmc_of_match);

For supporting multiple versions, you could either use some auxdata
here, or check each one in davince_mmcsd_probe.

> +
>  static struct platform_driver davinci_mmcsd_driver = {
>  	.driver		= {
>  		.name	= "davinci_mmc",
>  		.owner	= THIS_MODULE,
>  		.pm	= davinci_mmcsd_pm_ops,
> +		.of_match_table = of_match_ptr(davinci_mmc_of_match),
>  	},
>  	.remove		= __exit_p(davinci_mmcsd_remove),
>  };

Where does davinci_mmcsd_probe get called from, and how is the
of_match_table used? Should it not be set as .probe on the driver?

Thanks,
Mark.


