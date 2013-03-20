Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846Ab3CTOTa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 10:19:30 -0400
Received: from mail-ia0-f169.google.com ([209.85.210.169]:34716 "EHLO
	mail-ia0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239Ab3CTOT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 10:19:29 -0400
MIME-Version: 1.0
In-Reply-To: <CAFRkauA3_wOMvn05q4nRBA7_S2UnkUs6T1ma8H91o_uFQ-9zxg@mail.gmail.com>
References: <1363779113-8776-1-git-send-email-richard.genoud@gmail.com> <CAFRkauA3_wOMvn05q4nRBA7_S2UnkUs6T1ma8H91o_uFQ-9zxg@mail.gmail.com>
From: Richard Genoud <richard.genoud@gmail.com>
Date: Wed, 20 Mar 2013 15:19:08 +0100
Message-ID: <CACQ1gAhTdaRJUWss_gyvDQd14aJsqoVOGY9LWUPBReNQ9VMgSA@mail.gmail.com>
Subject: Re: [PATCH] BUG: pinmux: release only taken pins on error
To: Axel Lin <axel.lin@ingics.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@nvidia.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/20 Axel Lin <axel.lin@ingics.com>:
> 2013/3/20 Richard Genoud <richard.genoud@gmail.com>:
>> commit e38d457de7be63e6ced1ea254aa51466deb1fef0
>> pinctrl: pinmux: Release all taken pins in pinmux_enable_setting
>>
>> Introduced a bug in the release pin mechanism.
>> All the pins (taken or not) where released.
>> For instance, if a i2c function has already taken pins 5 and 6.
>> And the pins of function PHY are requested (pins 3 4 5 6 7).
>> The pins 3 and 4 will be taken, pin 5 is already taken, so the function
>> fails.
>> And we have pins 3 and 4 release, which is ok. But also pins 5 and 6 !.
>> And also pin 7 (which will have its mux_usecount to -1...)
>>
>> This patch reset the original behaviour.
>>
>> Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
>> ---
>>  drivers/pinctrl/pinmux.c |    2 ++
>>  1 files changed, 2 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
>> index 1a00658..917e830 100644
>> --- a/drivers/pinctrl/pinmux.c
>> +++ b/drivers/pinctrl/pinmux.c
>> @@ -409,6 +409,8 @@ int pinmux_enable_setting(struct pinctrl_setting const *setting)
>>                         dev_err(pctldev->dev,
>>                                 "could not request pin %d on device %s\n",
>>                                 pins[i], pinctrl_dev_get_name(pctldev));
>> +                       /* On error release *only* taken pins */
>> +                       num_pins = i - 1; /* this pin just failed */
> This seems pointless, in the goto err_pin_request path, the code does
> not use num_pins variable at all.
>
>>                         goto err_pin_request;
>
> see the code in err_pin_request,
> it actually does "while (--i>-0", so it won't call pin_free for the
> just failed pin.
>
> err_pin_request:
>         /* On error release all taken pins */
>         while (--i >= 0)
>                 pin_free(pctldev, pins[i], NULL);
>
>         return ret;

arrrrgg !
it's only Wednesday, and I'm already doing such mistakes !
sorry for that...
This patch can be tossed away with no regret.

The other 2 patches are better I guess
