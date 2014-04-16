Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417AbaDPUP5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 16:15:57 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:55956 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbaDPUPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 16:15:54 -0400
MIME-Version: 1.0
In-Reply-To: <5342A3F5.606@topic.nl>
References: <1395991817-3503-1-git-send-email-mike.looijmans@topic.nl>
	<10471336.Pb8zVvW3Hp@wuerfel>
	<53429AD4.7030508@topic.nl>
	<4902841.krZFXFDZqb@wuerfel>
	<5342A3F5.606@topic.nl>
Date: Wed, 16 Apr 2014 13:15:53 -0700
X-Google-Sender-Auth: X75ru3wynCJKYdLlgvypB-4jizQ
Message-ID: <CAL1qeaET+cy19EtB_TbtQ40Lb9r9hrO4H5vjG5YmCTpYoOmcog@mail.gmail.com>
Subject: Re: [PATCH] sdhci: Forward EPROBE_DEFER on vmmc and vqmmc regulators
From: Andrew Bresticker <abrestic@chromium.org>
To: Mike Looijmans <mike.looijmans@topic.nl>
Cc: Arnd Bergmann <arnd@arndb.de>, Ben Dooks <ben.dooks@codethink.co.uk>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        cjb@laptop.org, gdjakov@mm-sol.com,
        "broonie@kernel.org" <broonie@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On Mon, Apr 7, 2014 at 6:11 AM, Mike Looijmans <mike.looijmans@topic.nl> wrote:
> On 04/07/2014 02:51 PM, Arnd Bergmann wrote:
>>
>> On Monday 07 April 2014 14:32:20 Mike Looijmans wrote:
>>>
>>> On 04/07/2014 02:25 PM, Arnd Bergmann wrote:
>>>
>>> Judging from the kernel output, regulator_get_optional returns -ENODEV if
>>> the
>>> supply wasn't found.
>>>
>>> Maybe the API is confusing (or wrong?) here.
>>>
>>> If you change the code as per your suggestion, the SD will not work
>>> unless you
>>> explicitly assign supplies. And judging from what I've seen so far, I am
>>> the
>>> first to have ever attached a power supply to this controller...
>>
>>
>> It's certainly not very "optional" if it returns an error here.
>>
>> You could try to special-case the "-ENODEV" return here, but I think it
>> would be better to change the regulator interface to be less confusing.
>>
>
> Judging from the code:
> http://lxr.free-electrons.com/source/drivers/regulator/core.c#L1476
>
> The behaviour is supposed to be something like "regulator_get_optional" will
> return an error if the supply wasn't found, but "regulator_get" will create
> a dummy supply for you instead of returning an error code.
>
> So "regulator_get_optional" means: "I handle my own problems, just gimme the
> bad news". But "regulator_get" appears to imply: "I will shoot the
> messenger, so do whatever you can to get me something to say 'enable' to".
>
> In this case, the IS_NULL part is wrong indeed, it will never return NULL.

Not true.  If !CONFIG_REGULATOR, regulator_get() and co. will return
NULL.  Normally it is ok to ignore this case, but the sdhci driver
will call regulator_is_supported_voltage() on vqmmc to determine
whether 1.8V signalling is supported.  With !CONFIG_REGULATOR,
regulator_is_supported_voltage() will always return false, causing the
sdhci driver to disable all UHS modes.  So we still need to handle the
NULL (!CONFIG_REGULATOR) case.  One possibility is to guard the
voltage check with #ifdef CONFIG_REGULATOR, as is done later with
vmmc.

BTW, I was working on a similar patch at:
https://patchwork.kernel.org/patch/3988271/.

Thanks,
Andrew

>
> I still think it's unrelated to my patch and should be submitted separately.
>
>
> Mike.
>
>
> Met vriendelijke groet / kind regards,
>
> Mike Looijmans
>
> TOPIC Embedded Systems
> Eindhovenseweg 32-C, NL-5683 KH Best
> Postbus 440, NL-5680 AK Best
> Telefoon: (+31) (0) 499 33 69 79
> Telefax:  (+31) (0) 499 33 69 70
> E-mail: mike.looijmans@topic.nl
> Website: www.topic.nl
>
> Please consider the environment before printing this e-mail
>
> Visit us at the Hannover Messe 7 - 11 April 2014 - Hall 002/D10 (Dutch
> Pavillion)
> http://www.hannovermesse.de/exhibitor/topic-embedded-products/V229623
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
