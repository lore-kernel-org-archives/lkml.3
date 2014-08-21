Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333AbaHUKiY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 06:38:24 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:37089 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753820AbaHUKiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 06:38:22 -0400
MIME-Version: 1.0
In-Reply-To: <20140818154548.GA3302@leverpostej>
References: <1408373917-10002-1-git-send-email-matthias.bgg@gmail.com>
	<1408373917-10002-7-git-send-email-matthias.bgg@gmail.com>
	<20140818154548.GA3302@leverpostej>
Date: Thu, 21 Aug 2014 12:38:20 +0200
Message-ID: <CABuKBe+oVzQ9_Q__sULLQt8OvJ1Za_uA5x2aXSSQ6r8myvFqnA@mail.gmail.com>
Subject: Re: [PATCH v2 6/9] arm: mediatek: enable gpt6 on boot up to make arch
 timer working
From: Matthias Brugger <matthias.bgg@gmail.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "olof@lixom.net" <olof@lixom.net>, "arnd@arndb.de" <arnd@arndb.de>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        "thomas.petazzoni@free-electrons.com" 
	<thomas.petazzoni@free-electrons.com>,
        "swarren@nvidia.com" <swarren@nvidia.com>,
        "sebastian.hesselbarth@gmail.com" <sebastian.hesselbarth@gmail.com>,
        "stefan@agner.ch" <stefan@agner.ch>,
        "maxime.ripard@free-electrons.com" <maxime.ripard@free-electrons.com>,
        "anders.berg@lsi.com" <anders.berg@lsi.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "lee.jones@linaro.org" <lee.jones@linaro.org>,
        "heiko@sntech.de" <heiko@sntech.de>,
        "srv_yingjoe.chen@mediatek.com" <srv_yingjoe.chen@mediatek.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-08-18 17:45 GMT+02:00 Mark Rutland <mark.rutland@arm.com>:
> Hi Matthias,
>
> On Mon, Aug 18, 2014 at 03:58:34PM +0100, Matthias Brugger wrote:
>> We enable GTP6 which ungates the arch timer clock. Apart we write the
>> frequency with which the timer is running in the CNTFREQ register.
>
> We don't seem to set CNTFRQ below. Does it happen to have a consistent
> value on current versions of the bootloader?

Oh sorry, my fault. In v2 I moved the frequency to the dts, as this
will make the driver write CNTFRQ.
I forgot to update the commit message.

>
>> In the future this should be done in the bootloader.
>
> Do we know how far in the future that's likely to be?

AFAIK no one right now is working on an open source bootloader for the
mediatek devices.
So I think we won't see an open source bootloader in a reasonable time.

>
> What's the plan for this code when such a bootloader becomes available?

I think when a bootloader becomes available, this code should be
removed. I know that this will lead to a not working ARM arch timer in
devices which don't migrate to the new bootloader, but I think it's
not too critical. Apart from the ARM arch timer, the devices have the
mediatek global porpose timer (drivers/clocksource/mtk_timer.c), which
implement a clock source and a clock event timer. So the system won't
hang.

Cheers,
Matthias

>
> Thanks,
> Mark.
>
>> Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
>> ---
>>  arch/arm/mach-mediatek/mediatek.c |   26 ++++++++++++++++++++++++++
>>  1 file changed, 26 insertions(+)
>>
>> diff --git a/arch/arm/mach-mediatek/mediatek.c b/arch/arm/mach-mediatek/mediatek.c
>> index f2acf07..2989f18 100644
>> --- a/arch/arm/mach-mediatek/mediatek.c
>> +++ b/arch/arm/mach-mediatek/mediatek.c
>> @@ -16,6 +16,31 @@
>>   */
>>  #include <linux/init.h>
>>  #include <asm/mach/arch.h>
>> +#include <linux/of.h>
>> +#include <linux/clk-provider.h>
>> +#include <linux/clocksource.h>
>> +
>> +#define TIMER_CTRL_OP_FREERUN        0x30
>> +#define TIMER_CTRL_ENABLE    0x01
>> +
>> +#define GPT6_CON_MT65xx 0x10008060
>> +
>> +static void __init mediatek_timer_init(void)
>> +{
>> +     static void __iomem *gpt_base;
>> +
>> +     if (of_machine_is_compatible("mediatek,mt6589")) {
>> +             /* turn on GPT6 which ungates arch timer clocks */
>> +             gpt_base = ioremap(GPT6_CON_MT65xx, 0x04);
>> +     }
>> +
>> +     /* enabel clock and set to free-run */
>> +     if (gpt_base)
>> +             writel(TIMER_CTRL_OP_FREERUN | TIMER_CTRL_ENABLE, gpt_base);
>> +
>> +     of_clk_init(NULL);
>> +     clocksource_of_init();
>> +};
>>
>>  static const char * const mediatek_board_dt_compat[] = {
>>       "mediatek,mt6589",
>> @@ -24,4 +49,5 @@ static const char * const mediatek_board_dt_compat[] = {
>>
>>  DT_MACHINE_START(MEDIATEK_DT, "Mediatek Cortex-A7 (Device Tree)")
>>       .dt_compat      = mediatek_board_dt_compat,
>> +     .init_time      = mediatek_timer_init,
>>  MACHINE_END
>> --
>> 1.7.9.5
>>
>>



-- 
motzblog.wordpress.com
