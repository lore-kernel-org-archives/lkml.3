Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029Ab3BLGV5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 01:21:57 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:38106 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222Ab3BLGVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 01:21:55 -0500
Message-ID: <5119DF6E.9080501@ti.com>
Date: Tue, 12 Feb 2013 11:51:34 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Manjunathappa, Prakash" <prakash.pm@ti.com>
CC: <linux-mmc@vger.kernel.org>, <grant.likely@secretlab.ca>,
        <rob.herring@calxeda.com>, <rob@landley.net>, <linux@arm.linux.org.uk>,
        <hs@denx.de>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <cjb@laptop.org>, <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-kernel@vger.kernel.org>, <mporter@ti.com>
Subject: Re: [PATCH v2 2/3] mmc: davinci_mmc: add DT support
References: <1360223825-23929-1-git-send-email-prakash.pm@ti.com> <1360223825-23929-3-git-send-email-prakash.pm@ti.com>
In-Reply-To: <1360223825-23929-3-git-send-email-prakash.pm@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/7/2013 1:27 PM, Manjunathappa, Prakash wrote:
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
> +
> +Example:
> +	mmc0: mmc@1c40000 {
> +		compatible = "ti,davinci-mmc-da830",
> +		reg = <0x40000 0x1000>;
> +		interrupts = <16>;
> +		status = "okay";
> +		bus-width = <4>;
> +		max-frequency = <50000000>;
> +		mmc-cap-sd-highspeed;
> +		mmc-cap-mmc-highspeed;
> +	};
> +
> diff --git a/drivers/mmc/host/davinci_mmc.c b/drivers/mmc/host/davinci_mmc.c
> index 27123f8..3f90316 100644
> --- a/drivers/mmc/host/davinci_mmc.c
> +++ b/drivers/mmc/host/davinci_mmc.c
> @@ -34,6 +34,8 @@
>  #include <linux/dma-mapping.h>
>  #include <linux/edma.h>
>  #include <linux/mmc/mmc.h>
> +#include <linux/of.h>
> +#include <linux/of_device.h>
>  
>  #include <linux/platform_data/mmc-davinci.h>
>  
> @@ -1157,15 +1159,80 @@ static void __init init_mmcsd_host(struct mmc_davinci_host *host)
>  	mmc_davinci_reset_ctrl(host, 0);
>  }
>  
> -static int __init davinci_mmcsd_probe(struct platform_device *pdev)
> +static const struct of_device_id davinci_mmc_dt_ids[] = {
> +	{
> +		.compatible = "ti,davinci-mmc-dm355",
> +		.data = (void *)MMC_CTLR_VERSION_1,
> +	},
> +	{
> +		.compatible = "ti,davinci-mmc-da830",
> +		.data = (void *)MMC_CTLR_VERSION_2,
> +	},
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, davinci_mmc_dt_ids);

If you are doing this why not also kill passing IP version through
platform data using a platform_device_id table? Look at what Afzal did
for drivers/rtc/rtc-omap.c

Thanks,
Sekhar
