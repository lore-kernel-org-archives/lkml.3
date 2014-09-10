Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751507AbaIJNUk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 09:20:40 -0400
Received: from mail-qg0-f44.google.com ([209.85.192.44]:59738 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215AbaIJNUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 09:20:38 -0400
MIME-Version: 1.0
In-Reply-To: <54100E16.1030804@collabora.com>
References: <1410271329-26637-1-git-send-email-tomeu.vizoso@collabora.com>
 <1410271497-27148-1-git-send-email-tomeu.vizoso@collabora.com>
 <20140909191205.19023.61366@quantum> <20140909192503.19023.33476@quantum> <54100E16.1030804@collabora.com>
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Date: Wed, 10 Sep 2014 15:20:16 +0200
X-Google-Sender-Auth: fVRmJzeFWzhyrXJjOTMfBpjvT7o
Message-ID: <CAAObsKCrTongcYET7aBPHkkUCuoHeCgQKEDa-CqfJzZt5hwpxA@mail.gmail.com>
Subject: Re: [PATCH v10 2/9] clk: Move all drivers to use internal API
To: Mike Turquette <mturquette@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Shawn Guo <shawn.guo@freescale.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 September 2014 10:38, Tomeu Vizoso <tomeu.vizoso@collabora.com> wrote:
> On 09/09/2014 09:25 PM, Mike Turquette wrote:
>> Quoting Mike Turquette (2014-09-09 12:12:05)
>>> Quoting Tomeu Vizoso (2014-09-09 07:04:57)
>>>> In preparation to change the public API to return a per-user clk structure,
>>>> remove any usage of this public API from the clock implementations.
>>>>
>>>> The reason for having this in a separate commit from the one that introduces
>>>> the implementation of the new functions is to separate the changes generated
>>>> with Coccinelle from the rest, and keep the patches' size reasonable.
>>>>
>>>> Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
>>>> Tested-by: Boris Brezillon <boris.brezillon@free-electrons.com>
>>>> Tested-by: Heiko Stuebner <heiko@sntech.de>
>>>> Acked-by: Boris Brezillon <boris.brezillon@free-electrons.com>
>>>>
>>>> ---
>>>>
>>>> v10: * Add a few more files to be converted
>>>>      * Re-generate the patch on top of the latest changes
>>>
>>> Hi Tomeu,
>>>
>>> Generating this on top of linux-next is a no-go. I can't apply it to my
>>> tree. The best thing is to generate it on top of -rc4, and that is what
>>> I will merge.
>>>
>>> Running the script against linux-next is still very useful and lets us
>>> patch up the stuff that is not going through the clk tree. E.g. the LPSS
>>> driver is already in mainline, so just running the semantic patch
>>> against -rc4 is sufficient for it. However a patch like Shawn's "ARM:
>>> imx: add an exclusive gate clock type" came in through the i.MX tree and
>>> we'll need to patch it after the fact.
>>>
>>> The best way to do that is for me to host a branch with just your
>>> changes in it that everyone can pull in as a dependency with the same
>>> commit ids.
>>>
>>> <snip>
>>>
>>>> diff --git a/drivers/acpi/acpi_lpss.c b/drivers/acpi/acpi_lpss.c
>>>> index bcbdbd2..f4c6ccf 100644
>>>> --- a/drivers/acpi/acpi_lpss.c
>>>> +++ b/drivers/acpi/acpi_lpss.c
>>>> @@ -11,7 +11,6 @@
>>>>   */
>>>>
>>>>  #include <linux/acpi.h>
>>>> -#include <linux/clk.h>
>>>>  #include <linux/clkdev.h>
>>>>  #include <linux/clk-provider.h>
>>>>  #include <linux/err.h>
>>>> @@ -78,7 +77,7 @@ struct lpss_private_data {
>>>>         void __iomem *mmio_base;
>>>>         resource_size_t mmio_size;
>>>>         unsigned int fixed_clk_rate;
>>>> -       struct clk *clk;
>>>> +       struct clk_core *clk;
>>>>         const struct lpss_device_desc *dev_desc;
>>>>         u32 prv_reg_ctx[LPSS_PRV_REG_COUNT];
>>>>  };
>>>> @@ -229,7 +228,7 @@ static int register_device_clock(struct acpi_device *adev,
>>>>  {
>>>>         const struct lpss_device_desc *dev_desc = pdata->dev_desc;
>>>>         const char *devname = dev_name(&adev->dev);
>>>> -       struct clk *clk = ERR_PTR(-ENODEV);
>>>> +       struct clk_core *clk = ERR_PTR(-ENODEV);
>>>>         struct lpss_clk_data *clk_data;
>>>>         const char *parent, *clk_name;
>>>>         void __iomem *prv_base;
>>>
>>> I think the following hunk is missing from your change:
>>>
>>> --- a/drivers/acpi/acpi_lpss.c
>>> +++ b/drivers/acpi/acpi_lpss.c
>>> @@ -57,7 +57,7 @@ ACPI_MODULE_NAME("acpi_lpss");
>>>  struct lpss_shared_clock {
>>>         const char *name;
>>>         unsigned long rate;
>>> -       struct clk *clk;
>>> +       struct clk_core *clk;
>>>  };
>>
>> Looks like this hunk is missing as well:
>>
>> diff --git a/include/linux/platform_data/clk-lpss.h b/include/linux/platform_data/clk-lpss.h
>> index 2390199..3c3237c 100644
>> --- a/include/linux/platform_data/clk-lpss.h
>> +++ b/include/linux/platform_data/clk-lpss.h
>> @@ -15,7 +15,7 @@
>>
>>  struct lpss_clk_data {
>>         const char *name;
>> -       struct clk *clk;
>> +       struct clk_core *clk;
>>  };
>>
>>
>>
>> Without that change the following code will explode:
>>
>>
>> static int register_device_clock(struct acpi_device *adev,
>>                                  struct lpss_private_data *pdata)
>> {
>>         const struct lpss_device_desc *dev_desc = pdata->dev_desc;
>>         struct lpss_shared_clock *shared_clock = dev_desc->shared_clock;
>>         const char *devname = dev_name(&adev->dev);
>>         struct clk_core *clk = ERR_PTR(-ENODEV);
>>         struct lpss_clk_data *clk_data;
>>         const char *parent, *clk_name;
>>         void __iomem *prv_base;
>>
>>         if (!lpss_clk_dev)
>>                 lpt_register_clock_device();
>>
>>         clk_data = platform_get_drvdata(lpss_clk_dev);
>>         if (!clk_data)
>>                 return -ENODEV;
>>
>>         if (dev_desc->clkdev_name) {
>>                 clk_register_clkdev(clk_data->clk, dev_desc->clkdev_name,
>>                                     devname);
>>                 return 0;
>>         }
>>
>>
>>
>> I'm starting to get nervous about this Coccinelle script... Seems like a
>> lot of things are slipping through.
>
> I understand your concern. The Coccinelle part of it is very simple, and
> so far I haven't seen any problem caused by it. The step that is manual
> and that thus is prone to errors is listing the files that need to be
> transformed (clock_impl.txt).
>
> What I do to check that there aren't more files that need to be added is
> to grep for all files that contain "clk_ops" or include
> "clk-provider.h", diff it with the existing clock_impl.txt and visually
> inspect each of the new files to see if they are indeed clock
> implementations or helpers for them.
>
> The most problematic part of the process are the headers that define
> structs that are shared between clock implementations (and sometimes
> between both clock drivers and consumers), as is this case. So far I
> have only been able to find out what headers need modification by
> building and fixing the warnings. And as you have seen, I haven't been
> able to test builds as extensively as it would have been ideal.
>
> Was hoping that Intel's 0day build farm would help finding those, but
> there seems to be some problem with it and I'm not getting any reports.
> Have just asked Fengguang about it.

Just an update on this. Fengguang manually enqueued a build of my v10
branch a few hours ago, and I'm currently running a series of build
tests locally on my v11 branch, which is rebased on top of 3.17rc4:

http://cgit.collabora.com/git/user/tomeu/linux.git/log/?h=clk-refactoring-11

Regards,

Tomeu

> In the meantime I'm going to make my build script smarter and only spend
> time checking bisectability after I'm sure that the head builds fine in
> a fair set of defconfigs for all arches.
>
> Cheers,
>
> Tomeu
>
>> Regards,
>> Mike
>>
>>>
>>>
>>> Otherwise register_device_clock will blow up because we are assigning a
>>> struct clk * to a struct clk_core *.
>>>
>>> Do you mind testing with ARCH=x86_64 and allmodconfig? That will help
>>> catch issues like this.
>>>
>>> Regards,
>>> Mike
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
