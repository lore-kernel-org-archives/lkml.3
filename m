Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380AbaLMR7R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2014 12:59:17 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:39365 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbaLMR7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2014 12:59:16 -0500
MIME-Version: 1.0
In-Reply-To: <548A9D27.1000504@samsung.com>
References: <1418285264-21763-1-git-send-email-pankaj.dubey@samsung.com>
 <1418285264-21763-2-git-send-email-pankaj.dubey@samsung.com>
 <CAL_JsqKaf+w_D-xLCUizuTmxwT7uUHExA=qMpawQ+00G7uMcBg@mail.gmail.com> <548A9D27.1000504@samsung.com>
From: Rob Herring <robherring2@gmail.com>
Date: Sat, 13 Dec 2014 11:58:54 -0600
Message-ID: <CAL_JsqKA491FC44LRQQaKA3-3XKisJ2kRJCD9E5xQww=JV6+bg@mail.gmail.com>
Subject: Re: [PATCH v5 1/2] soc: samsung: add exynos chipid driver support
To: Pankaj Dubey <pankaj.dubey@samsung.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Arnd Bergmann <arnd@arndb.de>, Thomas Abraham <thomas.ab@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2014 at 1:45 AM, Pankaj Dubey <pankaj.dubey@samsung.com> wrote:
> Hi Rob,
>
> On Thursday 11 December 2014 11:00 PM, Rob Herring wrote:
>>
>> On Thu, Dec 11, 2014 at 2:07 AM, Pankaj Dubey <pankaj.dubey@samsung.com>
>> wrote:
>>>
>>> Exynos SoCs have Chipid, for identification of product IDs
>>> and SoC revisions. This patch intendes to provide initialization
>>> code for all these functionalites.

[...]

>>> +static void __iomem *exynos_chipid_base;
>>> +
>>> +struct exynos_chipid_info exynos_soc_info;
>>> +EXPORT_SYMBOL(exynos_soc_info);
>>
>>
>> The soc_device already has similar data.Why is this needed? Is it
>> temporary for compatibility?
>
>
> struct soc_device_attribute can hold these two (product_id, and revision)
> but they are defined as char * in soc_device_atttribute, and I feel it's
> more specific for exposing via sysfs.

But what is exposed generically for sysfs should also be exposed
internally in the kernel generically.

> Also existing code in mach-exynos compares them via product_id/revision
> macros, so I can say to keep compatibility.

Perhaps you will have to change the users. Otherwise, I don't see the
point in moving this code as is. If there are a lot of users, then
having both old and new interface and moving them over one by one
would be okay. However, if this is widely used that is a problem in
itself.

>> For early use?
>
>
> Yes, partially correct. These parameters will be required in during early
> boot, from mach-exynos/platsmp.c, by that time probe of chipid would not
> have happened. But usage of this is not limited to early users, even
> mach-exynos/pm.c will use this later any point of time.
> Since there are early users I added "exynos_chipid_early_init" which will be
> called via mach-exynos.c at very early stage [1].
>
> [1]: https://lkml.org/lkml/2014/12/11/47
>
>
>> If for early use, then it
>> should not be exported.
>
>
> Other reason to make and expose this structure was we can see that other
> fields of chipid bank (other than product_id and revision, which is not part
> of this patch as of now) can be used by other driver such as ASV (which is
> not yet part of mainline but is there for every exynos SoC).
>
> I do not exported this in my PATCH v4 [2] of this, and instead provided
> exposed functions to directly access product_id and revision, but sometime
> in future when we will need other fields of chipid bank, we will end-up
> adding new exported function for each new field, so decided to expose this
> structure itself.

More on this below.


>>> +void __init exynos_chipid_early_init(struct device *dev)
>>> +{
>>> +       struct device_node *np;
>>> +       const struct of_device_id *match;
>>> +
>>> +       if (exynos_chipid_base)
>>> +               return;
>>> +
>>> +       if (!dev)
>>> +               np = of_find_matching_node_and_match(NULL,
>>> +                       of_exynos_chipid_ids, &match);
>>> +       else
>>> +               np = dev->of_node;
>>> +
>>> +       if (!np)
>>> +               panic("%s, failed to find chipid node\n", __func__);
>>
>>
>> Do you really want to halt booting here?
>
>
> Since some critical configuration are done in platsmp.c based on product_id
> and revision, I don't see any point moving ahead without it.
> Even if we allow to continue here it will crash or lead to system
> malfunction later during system boot for existing SoC support.
>
> Your console may not be up to
>>
>> see the panic anyway.
>
>
> I feel this we can still see via earlyprintk.

You can, yes. So when you don't boot getting no messages, you then
have to recompile to enable earlyprintk for exynos, load a new kernel,
and change your command line. That's not very good from a support
point of view. It would be better to boot while failing to boot
secondary cpus than not boot printing nothing. It is much better to
provide the warnings rather than have to debug why you are not
booting.

>>> +struct exynos_chipid_info {
>>> +       u32 product_id;
>>> +       u32 revision;
>>> +};
>>
>>
>> Exposing this struct kernel wide in an SOC specific way concerns me. I
>> would not like to see this done on every SOC family. That would become
>> a mess.
>>
>
> As of today chip-id can live up by exposing two APIs for getting product_id
> and revision, but in future when we need to access other fields we may end
> up adding new exported functions/extern functions. We had a discussion about
> it in Patch V4 [3].

Yes, but every SOC has an id and revision, so we should expose them in
a common way. For other fields, the mechanism to retrieve them should
probably be common, but the data could be custom.

Rob

>
> [3]: https://lkml.org/lkml/2014/12/10/748
