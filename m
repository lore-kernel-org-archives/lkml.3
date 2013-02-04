Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486Ab3BDOGY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 09:06:24 -0500
Received: from service87.mimecast.com ([91.220.42.44]:50730 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754143Ab3BDOGW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 09:06:22 -0500
Date: Mon, 4 Feb 2013 14:06:16 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: "Manjunathappa, Prakash" <prakash.pm@ti.com>
Cc: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "Porter, Matt" <mporter@ti.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "hs@denx.de" <hs@denx.de>, "ido@wizery.com" <ido@wizery.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/3] mmc: davinci_mmc: add DT support
Message-ID: <20130204140616.GB28464@e106331-lin.cambridge.arm.com>
References: <1359628387-14437-1-git-send-email-prakash.pm@ti.com>
 <1359628387-14437-3-git-send-email-prakash.pm@ti.com>
 <20130131112303.GA7235@e106331-lin.cambridge.arm.com>
 <A73F36158E33644199EB82C5EC81C7BC3EA46049@DBDE01.ent.ti.com>
MIME-Version: 1.0
In-Reply-To: <A73F36158E33644199EB82C5EC81C7BC3EA46049@DBDE01.ent.ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 04 Feb 2013 14:06:18.0001 (UTC) FILETIME=[CD439010:01CE02E0]
X-MC-Unique: 113020414062001801
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Feb 04, 2013 at 01:28:14PM +0000, Manjunathappa, Prakash wrote:
> Hi Mark,
> 
> On Thu, Jan 31, 2013 at 16:53:03, Mark Rutland wrote:
> > Hello,
> >
> > I have a few comments on the devicetree binding and the way it's parsed.
> >
> 
> Thanks for review.
> 
> > On Thu, Jan 31, 2013 at 10:33:06AM +0000, Manjunathappa, Prakash wrote:

[...]

> > > +- caps: Check for Host capabilities in <linux/mmc/host.h>
> >
> > Is this a set of binary flags? Also, is this Linux-specific?
> >
> > I really don't think this should be in the devicetree binding. Why do you need
> > this?
> >
> 
> I was using this to specify the below controller capabilities:
> MMC_CAP_MMC_HIGHSPEED and MMC_CAP_SD_HIGHSPEED,
> Found from discussion[1] that this can be derived from max-frequency,
> That is above capabilities are supported when max-frequency >= 50MHz.
> 
> [1] https://lkml.org/lkml/2012/10/15/231

Great!

[...]

> > > @@ -1156,16 +1157,75 @@ static void __init init_mmcsd_host(struct mmc_davinci_host *host)
> > >
> > >     mmc_davinci_reset_ctrl(host, 0);
> > >  }
> > > +#ifdef CONFIG_OF
> > > +static struct davinci_mmc_config
> > > +   *mmc_of_get_pdata(struct platform_device *pdev)
> > > +{
> > > +   struct device_node *np;
> > > +   struct davinci_mmc_config *pdata = NULL;
> > > +   u32 data;
> > > +   int ret;
> > > +
> > > +   pdata = pdev->dev.platform_data;
> > > +   if (!pdata) {
> > > +           pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
> > > +           if (!pdata) {
> > > +                   dev_err(&pdev->dev, "Failed to allocate memory for struct davinci_mmc_config\n");
> > > +                   goto nodata;
> > > +           }
> > > +   }
> >
> > Why do you need to conditionally allocate this? This only seems to be called
> > once.
> >
> 
> This is common function for DT and non-DT kernel(will be removing #ifdef CONFIG_OF),
> So above check is necessary for to allocate pdata for DT kernel.

Ah. Am I right in thinking if you moved the check for pdev->dev.of_node above
the pdata allocation, it wouldn't have to be done conditionally?

> 
> > > +
> > > +   np = pdev->dev.of_node;
> > > +   if (!np)
> > > +           goto nodata;
> >
> > Why not just return immediately here? You do nothing special at nodata.
> >
> 
> Following convention to not have more than 1 return from function and have
> Common exit point. May not be necessary now since we have devm_* calls now.
> Can I still prefer to keep this goto?

It just looks a little odd to me. I have no strong feelings here.

[...]

> > > +
> > > +   ret = of_property_read_u32(np, "version", &data);
> > > +   if (ret)
> > > +           dev_err(&pdev->dev, "version not specified\n");
> > > +   pdata->version = data;
> >
> > And again, though I'd prefer to see this property go entirely.
> >
> 
> Yes this is going to go away.

Great!

> 
> > > +
> > > +nodata:
> > > +   return pdata;
> > > +}
> > > +
> > > +#else
> > > +static struct davinci_mmc_config
> > > +   *mmc_of_get_pdata(struct platform_device *pdev)
> > > +{
> > > +   return pdev->dev.platform_data;
> > > +}
> > > +#endif
> >
> > This is poorly named if it's required for !CONFIG_OF.
> >
> > Why not change this to something like mmc_parse_pdata, returning an
> > error code. For !CONFIG_OF, it can simply return 0, which should be less
> > surprising for anyone else reading this code.
> >
> 
> I will remove #ifdef CONFIG_OF conditional compilation and consideration
> your suggestion to name function as mmc_parse_pdata.

Sounds good.

> 
> > >
> > >  static int __init davinci_mmcsd_probe(struct platform_device *pdev)
> > >  {
> > > -   struct davinci_mmc_config *pdata = pdev->dev.platform_data;
> > > +   struct davinci_mmc_config *pdata = NULL;
> > >     struct mmc_davinci_host *host = NULL;
> > >     struct mmc_host *mmc = NULL;
> > >     struct resource *r, *mem = NULL;
> > >     int ret = 0, irq = 0;
> > >     size_t mem_size;
> > >
> > > +   pdata = mmc_of_get_pdata(pdev);
> > > +   if (pdata == NULL) {
> > > +           dev_err(&pdev->dev, "Can not get platform data\n");
> > > +           return -ENOENT;
> > > +   }
> > > +
> > >     /* REVISIT:  when we're fully converted, fail if pdata is NULL */
> > >
> > >     ret = -ENODEV;
> > > @@ -1403,11 +1463,18 @@ static const struct dev_pm_ops davinci_mmcsd_pm = {
> > >  #define davinci_mmcsd_pm_ops NULL
> > >  #endif
> > >
> > > +static const struct of_device_id davinci_mmc_of_match[] = {
> > > +   {.compatible = "ti,davinci_mmc", },
> > > +   {},
> > > +};
> > > +MODULE_DEVICE_TABLE(of, davinci_mmc_of_match);
> >
> > For supporting multiple versions, you could either use some auxdata
> > here, or check each one in davince_mmcsd_probe.
> >
> 
> I will consider keeping auxdata via compatible field.
> 
> > > +
> > >  static struct platform_driver davinci_mmcsd_driver = {
> > >     .driver         = {
> > >             .name   = "davinci_mmc",
> > >             .owner  = THIS_MODULE,
> > >             .pm     = davinci_mmcsd_pm_ops,
> > > +           .of_match_table = of_match_ptr(davinci_mmc_of_match),
> > >     },
> > >     .remove         = __exit_p(davinci_mmcsd_remove),
> > >  };
> >
> > Where does davinci_mmcsd_probe get called from, and how is the
> > of_match_table used? Should it not be set as .probe on the driver?
> >
> 
> Driver probe is registered in module_init.

Ah, I'd missed the module_init when scanning through the code.

I couldn't figure out how davinci_mmcsd_probe got called for elements matched
by the match table. I see platform_driver_probe temporarily sets the .probe on
the driver, so that makes sense now.

> And are you suggesting me to use module_platform_driver? If yes can it not
> be taken separately as it is unrelated to DT support I am adding.

No, I'd just managed to miss that which got called via module_init. It should
be fine as-is.

Thanks,
Mark.

