Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554Ab3BQCkF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 21:40:05 -0500
Received: from mail-qc0-f172.google.com ([209.85.216.172]:52528 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753745Ab3BQCkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 21:40:03 -0500
MIME-Version: 1.0
In-Reply-To: <1360252328.221651004@f364.mail.ru>
References: <1359990040-5339-1-git-send-email-shc_work@mail.ru>
	<1360226494.178606955@f137.mail.ru>
	<1360252328.221651004@f364.mail.ru>
Date: Sun, 17 Feb 2013 10:40:01 +0800
Message-ID: <CAP1dx+wNf=udD-X8=TKBqsFbvcpCAzM2pYyLmPaTHk_=tvQs2w@mail.gmail.com>
Subject: Re: Re[4]: [PATCH] mfd: syscon: Added support for using platform
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

On 7 February 2013 23:52, Alexander Shiyan <shc_work@mail.ru> wrote:
> Hello.
>
>> > ...
>> >> Thanks for the patch adding non-dt support. :-)
>> >>
>> >> On Mon, Feb 04, 2013 at 07:00:40PM +0400, Alexander Shiyan wrote:
>> >> > This patch adds support usage platform driver resources, i.e.
>> >> > possibility works without oftree support. Additionally patch
>> >> > removes CONFIG_OF dependency and adds helper for accessing
>> >> > regmap by searching device by its name.
>> > ...
>> >> > +static int syscon_match_name(struct device *dev, void *data)
>> >> > +{
>> >> > +   return !strcmp(dev_name(dev), (const char *)data);
>> >> > +}
>> >> > +
>> >> > +struct regmap *syscon_regmap_lookup_by_name(const char *name)
>> >> > +{
>> >> > +   struct syscon *syscon;
>> >> > +   struct device *dev;
>> >> > +
>> >> > +   dev = driver_find_device(&syscon_driver.driver, NULL, (void *)name,
>> >> > +                            syscon_match_name);
>> >> > +   if (!dev)
>> >> > +           return ERR_PTR(-EPROBE_DEFER);
>> >> > +
>> >> > +   syscon = dev_get_drvdata(dev);
>> >> > +
>> >> > +   return syscon->regmap;
>> >> > +}
>> >> > +
>> >>
>> >> How about syscon_dev_to_regmap(struct device *dev) as the exist dt version
>> >> syscon_node_to_regmap since it's not affected by the name change of devices?
>> >
>> > I am not completely understand what you mean. In my version which doing
>> > search regmap by name, we can call this function with desired device name,
>> > then use regmap:
>> > struct regmap *r = syscon_regmap_lookup_by_name("syscon.1");
>> >
>>
>> My concern is that this API may be used by other client drivers, if we hardcode
>> the device name in those drivers, once the device name is changed,
>> all those drivers need change too.
>> For dt case, we use device node to find regmap, so does not care about the name.
>>
>> > You suggest use "struct device" as parameter?
>>
>> A device pointer.
>>
>> > I do not know what we should
>> > use as parameter to the function in this case, since we can get "struct device"
>> > only when register this device,
>>
>> If we have a platform_device, then we have its device pointer, right?
>>
>> > i.e. in board support code, not from anywhere,
>> > for example from another driver.
>> > Fixme please.
>> >
>>
>> My understanding is that in board support code, we can have the
>> platform device instance
>> of that syscon compatible device, then we can use it as the platform
>> data parameter for those devices driver who wants to use it.
>> Then in client driver, it can call:
>> syscon_dev_to_regmap(syscon_compatible_dev)
>> to find the regmap.
>> Just like dt working way, the device node usually uses a phandle pointing to
>> the syscon compatible node which it wants to use.
>
> This is not as easy as it seems.
> All devices that will use "syscon" driver, in this case should have a platform_data
> record.

Yes, that's the same way as the dt version does.

> I think that it can create problems with using these drivers as modules.

What problems do you think?

> Alternatively, we can create additional (virtual) "compatible" text property in syscon
> private data structure and use it to find the proper device. What is your opinion?
>

Hmm, i can't see why we need that.
IMO, for non-dt, we can just use platform_device_id to match devices.

>> > ...
>> >> > +   if (IS_ENABLED(CONFIG_OF) && np) {
>> >> > +           syscon->base = of_iomap(np, 0);
>> >> > +           if (!syscon->base)
>> >> > +                   return -EADDRNOTAVAIL;
>> >> > +
>> >> > +           res = &res_of;
>> >> > +           ret = of_address_to_resource(np, 0, res);
>> >> > +           if (ret)
>> >> > +                   return ret;
>> >> > +   } else {
>> >> > +           res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> >> > +           if (!res)
>> >> > +                   return -ENXIO;
>> >> > +
>> >> > +           if (!request_mem_region(res->start, resource_size(res),
>> >> > +                                   dev_name(&pdev->dev)))
>> >> > +                   return -EBUSY;
>> >> > +
>> >> > +           syscon->base = ioremap(res->start, resource_size(res));
>> >> > +           if (!syscon->base)
>> >> > +                   return -EADDRNOTAVAIL;
>> >>
>> >> devm_request_and_ioremap?
>> >
>> > We call of_iomap for DT-version,  for removal procedure - iounmap.
>> > Will iounmap work properly with devm_-version, I'm not sure.
>>
>> You're right, i'm afraid not.
>> If that, i wonder the ioremap resource may be freed twice for driver removal.
>> So, i'm okay with your current way.
>> But one issue is that then we need take care of the resource free by ourselves
>> for probe failed cases. e.g. ioremap and request_mem_region.
>> You may need add them.
>
> Yes, thanks. I forget about it.
>
>> > May be better to completely remove ".remove" (and module_exit) feature for driver?
>> > It is loaded at startup always once compiled, and should always be in the system.
>> It supports to be a module, so it may be better to keep ".remove".
>
> As far I can see, no. Kernel symbol defined as bool, so driver cannot be compiled
> as module:
> config MFD_SYSCON
>         bool "System Controller Register R/W Based on Regmap"
>

I see.
Thanks

Regards
Dong Aisheng

> Thanks!
>
> ---
