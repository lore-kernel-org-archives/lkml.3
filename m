Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645Ab3BHGZp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 01:25:45 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:59340 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752843Ab3BHGZm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 01:25:42 -0500
From: "Manjunathappa, Prakash" <prakash.pm@ti.com>
To: Mark Rutland <mark.rutland@arm.com>
CC: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "Porter, Matt" <mporter@ti.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "hs@denx.de" <hs@denx.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH v2 2/3] mmc: davinci_mmc: add DT support
Thread-Topic: [PATCH v2 2/3] mmc: davinci_mmc: add DT support
Thread-Index: AQHOBQiaR4i2K3bQekeNtxNjukEnzZht2qAAgABeknA=
Date: Fri, 8 Feb 2013 06:25:09 +0000
Message-ID: <A73F36158E33644199EB82C5EC81C7BC3EA465FE@DBDE01.ent.ti.com>
References: <1360223825-23929-1-git-send-email-prakash.pm@ti.com>
 <1360223825-23929-3-git-send-email-prakash.pm@ti.com>
 <20130207104656.GE16987@e106331-lin.cambridge.arm.com>
In-Reply-To: <20130207104656.GE16987@e106331-lin.cambridge.arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.162.25]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Thu, Feb 07, 2013 at 16:16:56, Mark Rutland wrote:
> Hello,
> 
> I have a couple of comments on the dt bindings and the way it's parsed.
> 

Thanks for your review comments.

> On Thu, Feb 07, 2013 at 07:57:04AM +0000, Manjunathappa, Prakash wrote:
> > Adds device tree support for davinci_mmc. Also add binding documentation.
> > Tested in non-dma PIO mode and without GPIO card_detect/write_protect
> > option because of dependencies on EDMA and GPIO module DT support.
> > 
> > Signed-off-by: Manjunathappa, Prakash <prakash.pm@ti.com>
> > Cc: linux-mmc@vger.kernel.org
> > Cc: linux-arm-kernel@lists.infradead.org
> > Cc: linux-kernel@vger.kernel.org
> > Cc: davinci-linux-open-source@linux.davincidsp.com
> > Cc: devicetree-discuss@lists.ozlabs.org
> > Cc: cjb@laptop.org
> > Cc: Sekhar Nori <nsekhar@ti.com>
> > Cc: mporter@ti.com
> > ---
> > Since v1:
> > Modified DT parse function to take default values and accomodate controller
> > version in compatible field.
> > 
> >  .../devicetree/bindings/mmc/davinci_mmc.txt        |   30 ++++++++
> >  drivers/mmc/host/davinci_mmc.c                     |   70 +++++++++++++++++++-
> >  2 files changed, 99 insertions(+), 1 deletions(-)
> >  create mode 100644 Documentation/devicetree/bindings/mmc/davinci_mmc.txt
> > 
> > diff --git a/Documentation/devicetree/bindings/mmc/davinci_mmc.txt b/Documentation/devicetree/bindings/mmc/davinci_mmc.txt
> > new file mode 100644
> > index 0000000..6717ab1
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/mmc/davinci_mmc.txt
> > @@ -0,0 +1,30 @@
> > +* TI Highspeed MMC host controller for DaVinci
> > +
> > +The Highspeed MMC Host Controller on TI DaVinci family
> > +provides an interface for MMC, SD and SDIO types of memory cards.
> > +
> > +This file documents the properties used by the davinci_mmc driver.
> > +
> > +Required properties:
> > +- compatible:
> > + Should be "ti,davinci-mmc-da830": for da830, da850, dm365
> > + Should be "ti,davinci-mmc-dm355": for dm355, dm644x
> > +
> > +Optional properties:
> > +- bus-width: Number of data lines, can be <4>, or <8>, default <1>
> > +- max-frequency: Maximum operating clock frequency, default 25MHz.
> > +- mmc-cap-mmc-highspeed: Indicates support for MMC in high speed mode
> > +- mmc-cap-sd-highspeed: Indicates support for SD in high speed mode
> 
> I thought the last two were derivable from max-frequency?
> 

Yes, but I see below comment that it doesnot support MMC/SD.
arch/arm/mach-davinci/devices.c: davinci_setup_mmc
	   "
         * FIXME dm6441 (no MMC/SD), dm357 (one), and dm335 (two) are
         * not handled right here ...
         */"
I was wondering how do we support such platforms, so I thought it is necessary
to have these. But I see that on da850-evm even on skipping above flags EVM is able
to detect card, does it mean there is no way to specify "no SD/MMC" capability?
I will remove these and decide highspeed capability based on max-frequency.

> https://lkml.org/lkml/2012/10/15/231
> 
> [...]
> 
> > +static struct davinci_mmc_config
> > +	*mmc_parse_pdata(struct platform_device *pdev)
> >  {
> > +	struct device_node *np;
> >  	struct davinci_mmc_config *pdata = pdev->dev.platform_data;
> > +	const struct of_device_id *match =
> > +		of_match_device(of_match_ptr(davinci_mmc_dt_ids), &pdev->dev);
> > +	u32 data;
> > +
> > +	np = pdev->dev.of_node;
> > +	if (!np)
> > +		return pdata;
> > +
> > +	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
> > +	if (!pdata) {
> > +		dev_err(&pdev->dev, "Failed to allocate memory for struct davinci_mmc_config\n");
> > +		goto nodata;
> > +	}
> > +
> > +	if (match->data)
> > +		pdata->version = (u8)((int)match->data);
> > +
> > +	of_property_read_u32(np, "max-frequency", &pdata->max_freq);
> > +	if (!pdata->max_freq)
> > +		dev_info(&pdev->dev, "'max-frequency' property not specified, defaulting to 25MHz\n");
> > +
> > +	if (of_get_property(np, "mmc-cap-mmc-highspeed", NULL))
> > +		pdata->caps |= MMC_CAP_MMC_HIGHSPEED;
> > +	if (of_get_property(np, "mmc-cap-sd-highspeed", NULL))
> > +		pdata->caps |= MMC_CAP_SD_HIGHSPEED;
> 
> If these aren't derivable from max-frequency, you could use
> of_property_read_bool to make this clearer.
> 

Correct, I will decide these based on max-frequency.

> > +
> > +	of_property_read_u32(np, "bus-width", &data);
> > +	switch (data) {
> > +	case 0:
> 
> Judging by the binding doc, should this be 1 rather than 0?
> 

By default driver comes up in 4 bit mode when bus-width is not specified.
Bus-width is set to 1 bit for invalid bus-widths. Below are the cases
when bus-width 0 or 4, bus-width is set to 4bit mode
When bus-width is 8, bus-width is set to 8 bit mode

I thought that if somebody specifies bus-width as 2, 3, 5, 6, 7..., then
it should be defaulted to 1 bit mode, so I specified it as 1 bit in binding doc.
But I feel that a person who is editing dts file will not make such a mistake.
I will change binding document to default as 4 bit mode.

> > +	case 4:
> > +	case 8:
> > +		pdata->wires = data;
> > +		break;
> > +	default:
> > +		pdata->wires = 1;
> > +		dev_info(&pdev->dev, "Unsupported buswidth, defaulting to 1 bit\n");
> > +	}
> > +nodata:
> > +	return pdata;
> > +}
> > +
> > +static int __init davinci_mmcsd_probe(struct platform_device *pdev)
> > +{
> > +	struct davinci_mmc_config *pdata = NULL;
> >  	struct mmc_davinci_host *host = NULL;
> >  	struct mmc_host *mmc = NULL;
> >  	struct resource *r, *mem = NULL;
> >  	int ret = 0, irq = 0;
> >  	size_t mem_size;
> >  
> > +	pdata = mmc_parse_pdata(pdev);
> > +	if (pdata == NULL) {
> > +		dev_err(&pdev->dev, "Can not get platform data\n");
> > +		return -ENOENT;
> > +	}
> > +
> >  	/* REVISIT:  when we're fully converted, fail if pdata is NULL */
> 
> This comment can presumably disappear judging by the lines above?
> 

Agreed. I will remove it.

Thanks,
Prakash

