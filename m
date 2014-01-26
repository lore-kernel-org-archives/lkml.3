Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403AbaAZVtM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 16:49:12 -0500
Received: from mail-ea0-f182.google.com ([209.85.215.182]:51160 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397AbaAZVtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 16:49:11 -0500
Message-ID: <52E582D0.9070501@gmail.com>
Date: Sun, 26 Jan 2014 22:49:04 +0100
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Manish Badarkhe <badarkhe.manish@gmail.com>
CC: "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] max8925_power: Use "IS_ENABLED(CONFIG_OF)" for DT code.
References: <1390720540-13350-1-git-send-email-badarkhe.manish@gmail.com> <52E50C24.8030305@gmail.com> <CAKDJKT5TvkgUN2Ee-2NignzxY1F54SHEiNL2i6c+hMjnLHOg5g@mail.gmail.com> <20140126214542.GC18840@core.coreip.homeip.net>
In-Reply-To: <20140126214542.GC18840@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26.01.2014 22:45, Dmitry Torokhov wrote:
> On Sun, Jan 26, 2014 at 07:31:50PM +0530, Manish Badarkhe wrote:
>> Hi Tomasz,
>>
>> Thank you for your review comments.
>>
>> On Sun, Jan 26, 2014 at 6:52 PM, Tomasz Figa <tomasz.figa@gmail.com> wrote:
>>>
>>> Hi Manish,
>>>
>>>
>>> On 26.01.2014 08:15, Manish Badarkhe wrote:
>>>>
>>>> Instead of "#if define CONFIG_OF" use "IS_ENABLED(CONFIG_OF)"
>>>> option for DT code to avoid if-deffery in code.
>>>>
>>>> Signed-off-by: Manish Badarkhe <badarkhe.manish@gmail.com>
>>>> ---
>>>> :100644 100644 b4513f2... d353fbc... M  drivers/power/max8925_power.c
>>>>    drivers/power/max8925_power.c |   14 +++++---------
>>>>    1 file changed, 5 insertions(+), 9 deletions(-)
>>>>
>>>> diff --git a/drivers/power/max8925_power.c b/drivers/power/max8925_power.c
>>>> index b4513f2..d353fbc 100644
>>>> --- a/drivers/power/max8925_power.c
>>>> +++ b/drivers/power/max8925_power.c
>>>> @@ -427,7 +427,6 @@ static int max8925_deinit_charger(struct max8925_power_info *info)
>>>>          return 0;
>>>>    }
>>>>
>>>> -#ifdef CONFIG_OF
>>>>    static struct max8925_power_pdata *
>>>>    max8925_power_dt_init(struct platform_device *pdev)
>>>>    {
>>>> @@ -468,13 +467,6 @@ max8925_power_dt_init(struct platform_device *pdev)
>>>>
>>>>          return pdata;
>>>>    }
>>>> -#else
>>>> -static struct max8925_power_pdata *
>>>> -max8925_power_dt_init(struct platform_device *pdev)
>>>> -{
>>>> -       return pdev->dev.platform_data;
>>>> -}
>>>> -#endif
>>>>
>>>>    static int max8925_power_probe(struct platform_device *pdev)
>>>>    {
>>>> @@ -483,7 +475,11 @@ static int max8925_power_probe(struct platform_device *pdev)
>>>>          struct max8925_power_info *info;
>>>>          int ret;
>>>>
>>>> -       pdata = max8925_power_dt_init(pdev);
>>>> +       if (IS_ENABLED(CONFIG_OF))
>>>> +               pdata = max8925_power_dt_init(pdev);
>>>> +       else
>>>> +               pdata = pdev->dev.platform_data;
>>>> +
>>>
>>>
>>> This does not look much better than before this patch. Instead of "if-deffery" outside function bodies you are adding "iffery" (if there is such a word) inside a function.
>>> What about adding
>>>
>>>          if (!IS_ENABLED(CONFIG_OF))
>>>                  return pdev->dev.platform_data;
>>>
>>> on top of max8925_power_dt_init() instead or maybe also renaming this function to max8925_get_pdata()?
>>
>> Okay, I will rename function "max8925_power_dt_init()" to "max8925_get_pdata()".
>> As you suggested, in the body of this function  will add a logic to
>> retrieve  data in case
>> of DT and non-DT platforms.
>
> Should we not always favor platform-supplied data regardless of
> CONFIG_OF state and fall back to DT (firmware) supplied data if platform
> data is absent? This way one can tweak kernel behavior without needing
> to change firmware.

I guess we should, but apparently this was not the original behavior 
before this patch, so I'm not sure if we should be squashing such 
semantic change with this simple refactor.

Best regards,
Tomasz
