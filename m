Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757940Ab3BGKrG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 05:47:06 -0500
Received: from service87.mimecast.com ([91.220.42.44]:36743 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757316Ab3BGKrC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 05:47:02 -0500
Date: Thu, 7 Feb 2013 10:46:56 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: "Manjunathappa, Prakash" <prakash.pm@ti.com>
Cc: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "mporter@ti.com" <mporter@ti.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "nsekhar@ti.com" <nsekhar@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "hs@denx.de" <hs@denx.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 2/3] mmc: davinci_mmc: add DT support
Message-ID: <20130207104656.GE16987@e106331-lin.cambridge.arm.com>
References: <1360223825-23929-1-git-send-email-prakash.pm@ti.com>
 <1360223825-23929-3-git-send-email-prakash.pm@ti.com>
MIME-Version: 1.0
In-Reply-To: <1360223825-23929-3-git-send-email-prakash.pm@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 07 Feb 2013 10:46:57.0388 (UTC) FILETIME=[736C1AC0:01CE0520]
X-MC-Unique: 113020710470005201
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have a couple of comments on the dt bindings and the way it's parsed.

On Thu, Feb 07, 2013 at 07:57:04AM +0000, Manjunathappa, Prakash wrote:
> Adds device tree support for davinci_mmc. Also add binding documentation.
> Tested in non-dma PIO mode and without GPIO card_detect/write_protect
> option because of dependencies on EDMA and GPIO module DT support.
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
> Since v1:
> Modified DT parse function to take default values and accomodate controller
> version in compatible field.
> 
>  .../devicetree/bindings/mmc/davinci_mmc.txt        |   30 ++++++++
>  drivers/mmc/host/davinci_mmc.c                     |   70 +++++++++++++++++++-
>  2 files changed, 99 insertions(+), 1 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/mmc/davinci_mmc.txt
> 
> diff --git a/Documentation/devicetree/bindings/mmc/davinci_mmc.txt b/Documentation/devicetree/bindings/mmc/davinci_mmc.txt
> new file mode 100644
> index 0000000..6717ab1
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mmc/davinci_mmc.txt
> @@ -0,0 +1,30 @@
> +* TI Highspeed MMC host controller for DaVinci
> +
> +The Highspeed MMC Host Controller on TI DaVinci family
> +provides an interface for MMC, SD and SDIO types of memory cards.
> +
> +This file documents the properties used by the davinci_mmc driver.
> +
> +Required properties:
> +- compatible:
> + Should be "ti,davinci-mmc-da830": for da830, da850, dm365
> + Should be "ti,davinci-mmc-dm355": for dm355, dm644x
> +
> +Optional properties:
> +- bus-width: Number of data lines, can be <4>, or <8>, default <1>
> +- max-frequency: Maximum operating clock frequency, default 25MHz.
> +- mmc-cap-mmc-highspeed: Indicates support for MMC in high speed mode
> +- mmc-cap-sd-highspeed: Indicates support for SD in high speed mode

I thought the last two were derivable from max-frequency?

https://lkml.org/lkml/2012/10/15/231

[...]

> +static struct davinci_mmc_config
> +	*mmc_parse_pdata(struct platform_device *pdev)
>  {
> +	struct device_node *np;
>  	struct davinci_mmc_config *pdata = pdev->dev.platform_data;
> +	const struct of_device_id *match =
> +		of_match_device(of_match_ptr(davinci_mmc_dt_ids), &pdev->dev);
> +	u32 data;
> +
> +	np = pdev->dev.of_node;
> +	if (!np)
> +		return pdata;
> +
> +	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
> +	if (!pdata) {
> +		dev_err(&pdev->dev, "Failed to allocate memory for struct davinci_mmc_config\n");
> +		goto nodata;
> +	}
> +
> +	if (match->data)
> +		pdata->version = (u8)((int)match->data);
> +
> +	of_property_read_u32(np, "max-frequency", &pdata->max_freq);
> +	if (!pdata->max_freq)
> +		dev_info(&pdev->dev, "'max-frequency' property not specified, defaulting to 25MHz\n");
> +
> +	if (of_get_property(np, "mmc-cap-mmc-highspeed", NULL))
> +		pdata->caps |= MMC_CAP_MMC_HIGHSPEED;
> +	if (of_get_property(np, "mmc-cap-sd-highspeed", NULL))
> +		pdata->caps |= MMC_CAP_SD_HIGHSPEED;

If these aren't derivable from max-frequency, you could use
of_property_read_bool to make this clearer.

> +
> +	of_property_read_u32(np, "bus-width", &data);
> +	switch (data) {
> +	case 0:

Judging by the binding doc, should this be 1 rather than 0?

> +	case 4:
> +	case 8:
> +		pdata->wires = data;
> +		break;
> +	default:
> +		pdata->wires = 1;
> +		dev_info(&pdev->dev, "Unsupported buswidth, defaulting to 1 bit\n");
> +	}
> +nodata:
> +	return pdata;
> +}
> +
> +static int __init davinci_mmcsd_probe(struct platform_device *pdev)
> +{
> +	struct davinci_mmc_config *pdata = NULL;
>  	struct mmc_davinci_host *host = NULL;
>  	struct mmc_host *mmc = NULL;
>  	struct resource *r, *mem = NULL;
>  	int ret = 0, irq = 0;
>  	size_t mem_size;
>  
> +	pdata = mmc_parse_pdata(pdev);
> +	if (pdata == NULL) {
> +		dev_err(&pdev->dev, "Can not get platform data\n");
> +		return -ENOENT;
> +	}
> +
>  	/* REVISIT:  when we're fully converted, fail if pdata is NULL */

This comment can presumably disappear judging by the lines above?

[...]

Thanks,
Mark.

