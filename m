Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758382Ab3BSIGe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 03:06:34 -0500
Received: from mail-qc0-f172.google.com ([209.85.216.172]:43039 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758010Ab3BSICr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 03:02:47 -0500
MIME-Version: 1.0
In-Reply-To: <CAP1dx+zv60Df_8brjnJuBEC=EGUE=9ZacpR74VM5zomY=-K+cw@mail.gmail.com>
References: <1361198522-23789-1-git-send-email-shc_work@mail.ru>
	<201302181602.47157.arnd@arndb.de>
	<1361257381.497560655@f376.mail.ru>
	<CAP1dx+zv60Df_8brjnJuBEC=EGUE=9ZacpR74VM5zomY=-K+cw@mail.gmail.com>
Date: Tue, 19 Feb 2013 16:02:46 +0800
Message-ID: <CAP1dx+xGxOd8E4pQrZerOwtazXG_ZEthf3YxFQmJDBQA8qFRyg@mail.gmail.com>
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

On 19 February 2013 15:55, Dong Aisheng <dong.aisheng@linaro.org> wrote:
> On 19 February 2013 15:03, Alexander Shiyan <shc_work@mail.ru> wrote:
>> Hello.
>>
>> Strange, but I not received an original answer from Arnd, have only this mail.
>>
>> ...
>>> >> diff --git a/drivers/mfd/syscon.c b/drivers/mfd/syscon.c
>>> >> index 4a7ed5a..3c0abcb 100644
>>> >> --- a/drivers/mfd/syscon.c
>>> >> +++ b/drivers/mfd/syscon.c
>>> >
>>> > Hi Alexander,
>>> >
>>> >>  struct regmap *syscon_regmap_lookup_by_compatible(const char *s)
>>> >>  {
>>> >>       struct device_node *syscon_np;
>>> >>       struct regmap *regmap;
>>> >> +     struct syscon *syscon;
>>> >> +     struct device *dev;
>>> >>
>>> >>       syscon_np = of_find_compatible_node(NULL, NULL, s);
>>> >> -     if (!syscon_np)
>>> >> +     if (syscon_np) {
>>> >> +             regmap = syscon_node_to_regmap(syscon_np);
>>> >> +             of_node_put(syscon_np);
>>> >> +
>>> >> +             return regmap;
>>> >> +     }
>>> >> +
>>> >> +     /* Fallback to search by id_entry.name string */
>>> >> +     dev = driver_find_device(&syscon_driver.driver, NULL, (void *)s,
>>> >> +                              syscon_match_id);
>>> >> +     if (!dev)
>>> >>               return ERR_PTR(-ENODEV);
>>> >>
>>> >> -     regmap = syscon_node_to_regmap(syscon_np);
>>> >> -     of_node_put(syscon_np);
>>> >> +     syscon = dev_get_drvdata(dev);
>>> >>
>>> >> -     return regmap;
>>> >> +     return syscon->regmap;
>>> >>  }
>>> >>  EXPORT_SYMBOL_GPL(syscon_regmap_lookup_by_compatible);
>>> >
>>> > Since you are not actually comparing the "compatible" property here,
>>> > I would suggest adding another function here,
>>>
>>> Yes, i also think like that.
>>
>> In this case we should provide two paths for drivers which can work as with DT
>> and without DT.
>
> Yes.
>
>> In my case we can use platform_device_id.name field with
>> "compatible" string. My way in this case is transparency for driver which is
>> using "syscon".
>>
>
> Yes, but it also brings misleading and mass.
> And i wonder even the API can cover the two type of matches, the
> caller still can't use
> the only one name for two cases since the name is different.
> So it looks to me not make too much sense to provide only one API.
>
>>>
>>> > something like
>>> > syscon_regmap_lookup_by_pdevname() that you can use in device
>>> > drivers that are not DT-enabled.
>>>
>>> IMHO i would like syscon_dev_to_regmap, then we do not need to
>>> care in case pdevname changes.
>>> See:
>>> http://www.gossamer-threads.com/lists/linux/kernel/1675210#1675210
>>> What do you think?
>>
>> For me, I still do not understand how we get syscon_dev from driver.
>>
>
> Can't via platform_data?
>

Hmm...
I think one real problem is that for those dynamically created platform device,
we can not easily get its pointer in board file.
Then we can not pass the syscon device pointer via platfrom_data...

Regards
Dong Aisheng
