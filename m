Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758834Ab3BGOcr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 09:32:47 -0500
Received: from mail-qa0-f52.google.com ([209.85.216.52]:58974 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758635Ab3BGOcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 09:32:43 -0500
MIME-Version: 1.0
In-Reply-To: <1360226494.178606955@f137.mail.ru>
References: <1359990040-5339-1-git-send-email-shc_work@mail.ru>
	<20130207072931.GT22003@b29396-Latitude-E6410>
	<1360226494.178606955@f137.mail.ru>
Date: Thu, 7 Feb 2013 22:32:42 +0800
Message-ID: <CAP1dx+x=5zQ7dZ7sS5bEQAH=U7rj-oA97xQsHfOWuLgdY4heCQ@mail.gmail.com>
Subject: Re: Re[2]: [PATCH] mfd: syscon: Added support for using platform
 driver resources
From: Dong Aisheng <dong.aisheng@linaro.org>
To: Alexander Shiyan <shc_work@mail.ru>
Cc: Dong Aisheng <b29396@freescale.com>, linux-kernel@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexander,

On 7 February 2013 16:41, Alexander Shiyan <shc_work@mail.ru> wrote:
> Hello.
> ...
>> Thanks for the patch adding non-dt support. :-)
>>
>> On Mon, Feb 04, 2013 at 07:00:40PM +0400, Alexander Shiyan wrote:
>> > This patch adds support usage platform driver resources, i.e.
>> > possibility works without oftree support. Additionally patch
>> > removes CONFIG_OF dependency and adds helper for accessing
>> > regmap by searching device by its name.
> ...
>> > +static int syscon_match_name(struct device *dev, void *data)
>> > +{
>> > +   return !strcmp(dev_name(dev), (const char *)data);
>> > +}
>> > +
>> > +struct regmap *syscon_regmap_lookup_by_name(const char *name)
>> > +{
>> > +   struct syscon *syscon;
>> > +   struct device *dev;
>> > +
>> > +   dev = driver_find_device(&syscon_driver.driver, NULL, (void *)name,
>> > +                            syscon_match_name);
>> > +   if (!dev)
>> > +           return ERR_PTR(-EPROBE_DEFER);
>> > +
>> > +   syscon = dev_get_drvdata(dev);
>> > +
>> > +   return syscon->regmap;
>> > +}
>> > +
>>
>> How about syscon_dev_to_regmap(struct device *dev) as the exist dt version
>> syscon_node_to_regmap since it's not affected by the name change of devices?
>
> I am not completely understand what you mean. In my version which doing
> search regmap by name, we can call this function with desired device name,
> then use regmap:
> struct regmap *r = syscon_regmap_lookup_by_name("syscon.1");
>

My concern is that this API may be used by other client drivers, if we hardcode
the device name in those drivers, once the device name is changed,
all those drivers need change too.
For dt case, we use device node to find regmap, so does not care about the name.

> You suggest use "struct device" as parameter?

A device pointer.

> I do not know what we should
> use as parameter to the function in this case, since we can get "struct device"
> only when register this device,

If we have a platform_device, then we have its device pointer, right?

> i.e. in board support code, not from anywhere,
> for example from another driver.
> Fixme please.
>

My understanding is that in board support code, we can have the
platform device instance
of that syscon compatible device, then we can use it as the platform
data parameter for those devices driver who wants to use it.
Then in client driver, it can call:
syscon_dev_to_regmap(syscon_compatible_dev)
to find the regmap.
Just like dt working way, the device node usually uses a phandle pointing to
the syscon compatible node which it wants to use.

> ...
>> > +   if (IS_ENABLED(CONFIG_OF) && np) {
>> > +           syscon->base = of_iomap(np, 0);
>> > +           if (!syscon->base)
>> > +                   return -EADDRNOTAVAIL;
>> > +
>> > +           res = &res_of;
>> > +           ret = of_address_to_resource(np, 0, res);
>> > +           if (ret)
>> > +                   return ret;
>> > +   } else {
>> > +           res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> > +           if (!res)
>> > +                   return -ENXIO;
>> > +
>> > +           if (!request_mem_region(res->start, resource_size(res),
>> > +                                   dev_name(&pdev->dev)))
>> > +                   return -EBUSY;
>> > +
>> > +           syscon->base = ioremap(res->start, resource_size(res));
>> > +           if (!syscon->base)
>> > +                   return -EADDRNOTAVAIL;
>>
>> devm_request_and_ioremap?
>
> We call of_iomap for DT-version,  for removal procedure - iounmap.
> Will iounmap work properly with devm_-version, I'm not sure.

You're right, i'm afraid not.
If that, i wonder the ioremap resource may be freed twice for driver removal.
So, i'm okay with your current way.
But one issue is that then we need take care of the resource free by ourselves
for probe failed cases. e.g. ioremap and request_mem_region.
You may need add them.

> May be better to completely remove ".remove" (and module_exit) feature for driver?
> It is loaded at startup always once compiled, and should always be in the system.
>

It supports to be a module, so it may be better to keep ".remove".

Regards
Dong Aisheng
