Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521Ab3LQXbK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 18:31:10 -0500
Received: from mail-lb0-f173.google.com ([209.85.217.173]:37309 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813Ab3LQXbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 18:31:08 -0500
MIME-Version: 1.0
In-Reply-To: <2184496.xEujhTLELy@avalon>
References: <20131127074122.18314.48522.sendpatchset@w520>
	<2184496.xEujhTLELy@avalon>
Date: Wed, 18 Dec 2013 08:31:06 +0900
Message-ID: <CANqRtoTuev8Z0ZgNwWdvuPbLPdfkT2S6MmKYokA15KPVV_ZiQg@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: sh-pfc: Initial r7s72100 support
From: Magnus Damm <magnus.damm@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        SH-Linux <linux-sh@vger.kernel.org>,
        "Simon Horman [Horms]" <horms@verge.net.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

Here are some replies to your comments, my apologies for the delay.

On Wed, Nov 27, 2013 at 7:54 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Magnus,
>
> Thank you for the patch.
>
> On Wednesday 27 November 2013 16:41:22 Magnus Damm wrote:
>> From: Magnus Damm <damm@opensource.se>
>>
>> Add r7s72100 PINCTRL support via sh-pfc. At this point this code
>> provides enough support to allow use together with the gpio-rz
>> driver. Incremental per-device patches will in the future be
>> submitted on top of this base patch to allow PINCTRL enablement
>> for each individual device.
>>
>> Signed-off-by: Magnus Damm <damm@opensource.se>
>> ---
>>
>>  drivers/pinctrl/sh-pfc/Kconfig        |    5
>>  drivers/pinctrl/sh-pfc/Makefile       |    1
>>  drivers/pinctrl/sh-pfc/core.c         |    9 +
>>  drivers/pinctrl/sh-pfc/core.h         |    1
>>  drivers/pinctrl/sh-pfc/pfc-r7s72100.c |  166 ++++++++++++++++++++++++++++++
>>  5 files changed, 182 insertions(+)
>
> [snip]
>
>> --- /dev/null
>> +++ work/drivers/pinctrl/sh-pfc/pfc-r7s72100.c        2013-11-27
> 15:20:28.000000000
>> +0900 @@ -0,0 +1,166 @@
>
> [snip]
>
>> +#define RZ_PORT_PIN(bank, pin) (((bank) * 16) + (pin))
>
> Could you move this below closer to the location where it will be used, right
> after the pinmux_pins array ?

Yes, I did in V2. I still prefer to have it in the GPIO header so it
can be shared between PFC and GPIO.

>> +#define PORT_P_1(bank, pin, fn, sfx) fn(bank, pin, P_##bank##_##pin, sfx)
>
> I'm tempted to call the pins GP_ instead of P_ to be able to reuse the
> existing macros. On the other hand I suppose the datasheet uses P, not GP.
> What's your opinion on that ?

The data sheet is using P so I prefer to stick to that. Also,
regarding code sharing, I think it makes sense to move the 16-bit
register support to a shared location when more than one SoC will use
it. For now this SoC is the only user so we may as well keep it here
for now.

>> +     PINMUX_FUNCTION_BEGIN,
>> +     P_ALL(PMC_0), P_ALL(PMC_1),
>> +     P_ALL(PFC_0), P_ALL(PFC_1),
>> +     P_ALL(PFCE_0), P_ALL(PFCE_1),
>> +     P_ALL(PFCAE_0), P_ALL(PFCAE_1),
>> +     P_ALL(PIBC_0), P_ALL(PIBC_1),
>> +     P_ALL(PBDC_0), P_ALL(PBDC_1),
>> +     P_ALL(PIPC_0), P_ALL(PIPC_1),
>> +     PINMUX_FUNCTION_END,
>
> Only the PMC_1 and PFC* registers seem to be used in your later patches. What
> are the other registers for ? Shouldn't they be omitted if unused ?

Um, all registers expect PIPC were used in this version unless I'm
mistaken. I started using PIPC to V2 but that turned out to cause
issues with the I2C pin functions.

>> +#define _P_ALL(n) CPU_ALL_PORT(n, unused)
>> +
>> +#define _P_GPIO(bank, _pin, _name, sfx)                                      \
>> +     [(bank * 16) + _pin] = {                                        \
>> +             .pin = (bank * 16) + _pin,                              \
>> +             .name = __stringify(_name),                             \
>> +             .enum_id = _name##_DATA,                                \
>> +     }
>
> What about renaming _GP_GPIO to _GP_GPIO32 in sh_pfc.h, and move this macro to
> that header, calling it _GP_GPIO16 ?

Done as a separate patch in the V2 patch series.

Thanks,

/ magnus
