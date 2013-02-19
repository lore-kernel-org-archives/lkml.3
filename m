Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758043Ab3BSICi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 03:02:38 -0500
Received: from mail-qa0-f52.google.com ([209.85.216.52]:58729 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755035Ab3BSICg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 03:02:36 -0500
MIME-Version: 1.0
In-Reply-To: <1361257381.497560655@f376.mail.ru>
References: <1361198522-23789-1-git-send-email-shc_work@mail.ru>
	<201302181602.47157.arnd@arndb.de>
	<1361257381.497560655@f376.mail.ru>
Date: Tue, 19 Feb 2013 15:55:02 +0800
Message-ID: <CAP1dx+zv60Df_8brjnJuBEC=EGUE=9ZacpR74VM5zomY=-K+cw@mail.gmail.com>
Subject: Re: Re[2]: [PATCH v3] mfd: syscon: Add non-DT support
From: Dong Aisheng <dong.aisheng@linaro.org>
To: Alexander Shiyan <shc_work@mail.ru>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 February 2013 15:03, Alexander Shiyan <shc_work@mail.ru> wrote:
> Hello.
>
> Strange, but I not received an original answer from Arnd, have only this mail.
>
> ...
>> >> diff --git a/drivers/mfd/syscon.c b/drivers/mfd/syscon.c
>> >> index 4a7ed5a..3c0abcb 100644
>> >> --- a/drivers/mfd/syscon.c
>> >> +++ b/drivers/mfd/syscon.c
>> >
>> > Hi Alexander,
>> >
>> >>  struct regmap *syscon_regmap_lookup_by_compatible(const char *s)
>> >>  {
>> >>       struct device_node *syscon_np;
>> >>       struct regmap *regmap;
>> >> +     struct syscon *syscon;
>> >> +     struct device *dev;
>> >>
>> >>       syscon_np = of_find_compatible_node(NULL, NULL, s);
>> >> -     if (!syscon_np)
>> >> +     if (syscon_np) {
>> >> +             regmap = syscon_node_to_regmap(syscon_np);
>> >> +             of_node_put(syscon_np);
>> >> +
>> >> +             return regmap;
>> >> +     }
>> >> +
>> >> +     /* Fallback to search by id_entry.name string */
>> >> +     dev = driver_find_device(&syscon_driver.driver, NULL, (void *)s,
>> >> +                              syscon_match_id);
>> >> +     if (!dev)
>> >>               return ERR_PTR(-ENODEV);
>> >>
>> >> -     regmap = syscon_node_to_regmap(syscon_np);
>> >> -     of_node_put(syscon_np);
>> >> +     syscon = dev_get_drvdata(dev);
>> >>
>> >> -     return regmap;
>> >> +     return syscon->regmap;
>> >>  }
>> >>  EXPORT_SYMBOL_GPL(syscon_regmap_lookup_by_compatible);
>> >
>> > Since you are not actually comparing the "compatible" property here,
>> > I would suggest adding another function here,
>>
>> Yes, i also think like that.
>
> In this case we should provide two paths for drivers which can work as with DT
> and without DT.

Yes.

> In my case we can use platform_device_id.name field with
> "compatible" string. My way in this case is transparency for driver which is
> using "syscon".
>

Yes, but it also brings misleading and mass.
And i wonder even the API can cover the two type of matches, the
caller still can't use
the only one name for two cases since the name is different.
So it looks to me not make too much sense to provide only one API.

>>
>> > something like
>> > syscon_regmap_lookup_by_pdevname() that you can use in device
>> > drivers that are not DT-enabled.
>>
>> IMHO i would like syscon_dev_to_regmap, then we do not need to
>> care in case pdevname changes.
>> See:
>> http://www.gossamer-threads.com/lists/linux/kernel/1675210#1675210
>> What do you think?
>
> For me, I still do not understand how we get syscon_dev from driver.
>

Can't via platform_data?

>> > I would also recommend enclosing
>> > that function in #ifdef CONFIG_ATAGS.
>> >
>> > Which code do you have in mind that would call this anyway?
>> > The changeset description does not really explain what ATAG
>> > boot support in syscon is good for.
>> >
>> >> +     if (IS_ENABLED(CONFIG_OF) && np) {
>> >> +             syscon->base = of_iomap(np, 0);
>> >> +             if (!syscon->base)
>> >> +                     return -EADDRNOTAVAIL;
>> >> +
>> >> +             res = &res_of;
>> >> +             ret = of_address_to_resource(np, 0, res);
>> >> +             if (ret) {
>> >> +                     iounmap(syscon->base);
>> >> +                     return ret;
>> >> +             }
>> >> +     } else {
>> >> +             res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> >> +             if (!res)
>> >> +                     return -ENOENT;
>> >> +
>> >> +             if (!devm_request_mem_region(dev, res->start,
>> >> +                                          resource_size(res),
>> >> +                                          dev_name(&pdev->dev)))
>> >> +                     return -EBUSY;
>> >> +
>> >> +             syscon->base = ioremap(res->start, resource_size(res));
>> >> +             if (!syscon->base)
>> >> +                     return -EADDRNOTAVAIL;
>> >> +     }
>> >
>> > These two code paths look equivalent. Why not always use the second
>> > one? Also, you might want to convert this to devm_ioremap_resource()
>> > to simplify the code in the process.
>> >
>>
>> These two code paths have a slight difference.
>> The path1 does not request the mem region, the main reason of that is we meet
>> some devices register ranges used as syscon maybe overlapped with
>> other exist drivers.
>> e.g imx6q.dtsi
>> The gpr is a few registers contained in iomuxc.
>> gpr: iomuxc-gpr@020e0000 {
>>         compatible = "fsl,imx6q-iomuxc-gpr", "syscon";
>>         reg = <0x020e0000 0x38>;
>> };
>>
>> iomuxc: iomuxc@020e0000 {
>>         compatible = "fsl,imx6q-iomuxc";
>>         reg = <0x020e0000 0x4000>;
>> ...
>> };
>>
>> The iomuxc already has a pinctrl driver, so there are conflicts if both
>> request the same mem region.
>>
>> So i wonder maybe we also do not need request mem region in non-dt case,
>> then we can only  use second code path.
>
> So, you suggest completely remove CONFIG_OF-dependent code from "probe"?
> I am not a guru in DT, is it will work correct?
>

I think yes.
The core will create resource for the populated devices.
See: of_platform_populate

Regards
Dong Aisheng
