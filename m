Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243Ab3BSFwj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 00:52:39 -0500
Received: from mail-qc0-f169.google.com ([209.85.216.169]:48600 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754980Ab3BSFwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 00:52:38 -0500
MIME-Version: 1.0
In-Reply-To: <201302181602.47157.arnd@arndb.de>
References: <1361198522-23789-1-git-send-email-shc_work@mail.ru>
	<201302181602.47157.arnd@arndb.de>
Date: Tue, 19 Feb 2013 13:52:37 +0800
Message-ID: <CAP1dx+xiReJO-fZFFh7wjH1+bS9xKyWAxQ3kuSgOs4VRyh_exQ@mail.gmail.com>
Subject: Re: [PATCH v3] mfd: syscon: Add non-DT support
From: Dong Aisheng <dong.aisheng@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Alexander Shiyan <shc_work@mail.ru>, linux-kernel@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 February 2013 00:02, Arnd Bergmann <arnd@arndb.de> wrote:
> On Monday 18 February 2013, Alexander Shiyan wrote:
>> diff --git a/drivers/mfd/syscon.c b/drivers/mfd/syscon.c
>> index 4a7ed5a..3c0abcb 100644
>> --- a/drivers/mfd/syscon.c
>> +++ b/drivers/mfd/syscon.c
>
> Hi Alexander,
>
>>  struct regmap *syscon_regmap_lookup_by_compatible(const char *s)
>>  {
>>       struct device_node *syscon_np;
>>       struct regmap *regmap;
>> +     struct syscon *syscon;
>> +     struct device *dev;
>>
>>       syscon_np = of_find_compatible_node(NULL, NULL, s);
>> -     if (!syscon_np)
>> +     if (syscon_np) {
>> +             regmap = syscon_node_to_regmap(syscon_np);
>> +             of_node_put(syscon_np);
>> +
>> +             return regmap;
>> +     }
>> +
>> +     /* Fallback to search by id_entry.name string */
>> +     dev = driver_find_device(&syscon_driver.driver, NULL, (void *)s,
>> +                              syscon_match_id);
>> +     if (!dev)
>>               return ERR_PTR(-ENODEV);
>>
>> -     regmap = syscon_node_to_regmap(syscon_np);
>> -     of_node_put(syscon_np);
>> +     syscon = dev_get_drvdata(dev);
>>
>> -     return regmap;
>> +     return syscon->regmap;
>>  }
>>  EXPORT_SYMBOL_GPL(syscon_regmap_lookup_by_compatible);
>
> Since you are not actually comparing the "compatible" property here,
> I would suggest adding another function here,

Yes, i also think like that.

> something like
> syscon_regmap_lookup_by_pdevname() that you can use in device
> drivers that are not DT-enabled.

IMHO i would like syscon_dev_to_regmap, then we do not need to
care in case pdevname changes.
See:
http://www.gossamer-threads.com/lists/linux/kernel/1675210#1675210
What do you think?

> I would also recommend enclosing
> that function in #ifdef CONFIG_ATAGS.
>
> Which code do you have in mind that would call this anyway?
> The changeset description does not really explain what ATAG
> boot support in syscon is good for.
>
>> +     if (IS_ENABLED(CONFIG_OF) && np) {
>> +             syscon->base = of_iomap(np, 0);
>> +             if (!syscon->base)
>> +                     return -EADDRNOTAVAIL;
>> +
>> +             res = &res_of;
>> +             ret = of_address_to_resource(np, 0, res);
>> +             if (ret) {
>> +                     iounmap(syscon->base);
>> +                     return ret;
>> +             }
>> +     } else {
>> +             res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +             if (!res)
>> +                     return -ENOENT;
>> +
>> +             if (!devm_request_mem_region(dev, res->start,
>> +                                          resource_size(res),
>> +                                          dev_name(&pdev->dev)))
>> +                     return -EBUSY;
>> +
>> +             syscon->base = ioremap(res->start, resource_size(res));
>> +             if (!syscon->base)
>> +                     return -EADDRNOTAVAIL;
>> +     }
>
> These two code paths look equivalent. Why not always use the second
> one? Also, you might want to convert this to devm_ioremap_resource()
> to simplify the code in the process.
>

These two code paths have a slight difference.
The path1 does not request the mem region, the main reason of that is we meet
some devices register ranges used as syscon maybe overlapped with
other exist drivers.
e.g imx6q.dtsi
The gpr is a few registers contained in iomuxc.
gpr: iomuxc-gpr@020e0000 {
        compatible = "fsl,imx6q-iomuxc-gpr", "syscon";
        reg = <0x020e0000 0x38>;
};

iomuxc: iomuxc@020e0000 {
        compatible = "fsl,imx6q-iomuxc";
        reg = <0x020e0000 0x4000>;
...
};

The iomuxc already has a pinctrl driver, so there are conflicts if both
request the same mem region.

So i wonder maybe we also do not need request mem region in non-dt case,
then we can only  use second code path.

Regards
Dong Aisheng
