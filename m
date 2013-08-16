Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394Ab3HPB2r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 21:28:47 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:48497 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317Ab3HPB2p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 21:28:45 -0400
MIME-Version: 1.0
In-Reply-To: <20130815100719.GB25875@lee--X1>
References: <1376468930-9794-1-git-send-email-chao.xie@marvell.com>
	<1376468930-9794-4-git-send-email-chao.xie@marvell.com>
	<20130814174227.GI4046@lee--X1>
	<CADApbejPaRRX5OM5Ho8-bV2vaKLODOjhOh2Abzb8Auniwdukkw@mail.gmail.com>
	<20130815100719.GB25875@lee--X1>
Date: Fri, 16 Aug 2013 09:28:44 +0800
Message-ID: <CADApbegsSEaHhTBoy+STf2EDE3t8NR-K0GMWr1ObRPZkmPsYxQ@mail.gmail.com>
Subject: Re: [PATCH 3/4] mfd: 88pm800: add device tree support
From: Chao Xie <xiechao.mail@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Chao Xie <chao.xie@marvell.com>, sameo@linux.intel.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 15, 2013 at 6:07 PM, Lee Jones <lee.jones@linaro.org> wrote:
>> >> +Optional parent device properties:
>> >> +- marvell,88pm800-irq-write-clear: inicates whether interrupt status is cleared by write
>> >> +- marvell,88pm800-battery-detection: indicats whether need 88pm800 to support battery
>> >> +                             detection or not.
>> >
>> > Not sure what these are. This is why you need to CC the Device Tree
>> > guys.
>> >
>> It is the 88pm805's own configuration.
>> 88pm800-irq-write-clear: when irq happens, the status register is
>> write clear or read clear.
>> 88pm800-battery-detection: whether the battery is connected to chip.
>> It means that whether
>> the chip be aware of battery or not.
>
> As you are adding vendor specific bindings, you need to Cc the Device
> Tree mailing list.
>
>> >> +     if (IS_ENABLED(CONFIG_OF)) {
>> >> +             if (!pdata) {
>> >> +                     pdata = devm_kzalloc(&client->dev,
>> >> +                                          sizeof(*pdata), GFP_KERNEL);
>> >> +                     if (!pdata)
>> >> +                             return -ENOMEM;
>> >> +             }
>> >> +             ret = pm800_dt_init(node, &client->dev, pdata);
>> >> +             if (ret)
>> >> +                     return ret;
>> >> +     } else if (!pdata) {
>> >> +             return -EINVAL;
>> >> +     }
>> >
>> > Replace with:
>> >
>> >         if (!pdata) {
>> >                 if (node)
>> >                         /* <blah> populate pdata with DT </blah> */
>> >                 else
>> >                         return -EINVAL;
>> >         }
>> >
>> The orignial code will cover the following situation.
>> 1. DT enabled, and user pass pdata
>> 2. DT enabled, but user do not pass pdata
>> 3. DT disabled, user pass pdata
>> 4. DT disabled, user do not pass pdata.
>>
>> 88pm805 has a callback for config the it based on platform requirment.
>> I do not want to remove this callback now, because it includes so many
>> configurations.
>> So i allow user can pass pdata with callback if the platform needs to
>> configure the chip.
>
> Mixing DT with pdata is a bad idea. If you need to pass a call-back
> pointer, then _only_ use pdata i.e. get all of your platform specific
> information from pdata, rather than just over-writing sections of it
> with information retrieved from Device Tree.
>
> So:
>
> If pdata  - use pdata and ignore DT completely
> If !pdata:
>    If DT  - use DT
>    If !DT - return -EINVAL
>
> Out of interest, what does your call-back do?
>
Without the callback, the soc still can work.
The callback does job relates to power saving and CP's requirment.
1. LPM configure for the chip based on AP/CP's requriment.
2. 88pm800 OSC configuration
3. Some output pin configuration of 88pm800, for example reset_out_n pin

I want to abstract the callback step by step, so the first step are the patches
that enable DT first.

For the patch 0001 and 0002 are fixes, so if these two patches are all
right, can you
merge them? Then i will submit the 2 DT related patches again with cc
to device tree maillist.

Thanks.

> --
> Lee Jones
> Linaro ST-Ericsson Landing Team Lead
> Linaro.org │ Open source software for ARM SoCs
> Follow Linaro: Facebook | Twitter | Blog
