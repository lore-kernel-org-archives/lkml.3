Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759265Ab3DZIwN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 04:52:13 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:38006 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753930Ab3DZIwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 04:52:10 -0400
MIME-Version: 1.0
In-Reply-To: <20130426004835.GA20070@verge.net.au>
References: <1366910944-3033663-1-git-send-email-arnd@arndb.de>
	<1366910944-3033663-4-git-send-email-arnd@arndb.de>
	<20130426004835.GA20070@verge.net.au>
Date: Fri, 26 Apr 2013 10:52:08 +0200
Message-ID: <CABYn4sxjpp3yPkjDM9XhX6fyT-g_OoCjcnD1u=5oyb+Y6y=Nmw@mail.gmail.com>
Subject: Re: [PATCH 03/21] ARM: shmobile: don't call irqchip_init unconditionally
From: Bastian Hecht <hechtb@gmail.com>
To: Simon Horman <horms@verge.net.au>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org, Bastian Hecht <hechtb+renesas@gmail.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Simon and Arnd,

2013/4/26 Simon Horman <horms@verge.net.au>:
> On Thu, Apr 25, 2013 at 07:28:46PM +0200, Arnd Bergmann wrote:
>> The irqchip_init function is only available when building
>> with CONFIG_OF enabled, which causes this build failure for
>> bonito_defconfig:
>>
>> arch/arm/mach-shmobile/built-in.o: In function `r8a7740_init_irq_of':
>> :(.init.text+0x580): undefined reference to `irqchip_init'
>>
>> This makes both the OF and the ATAGS portion of the driver
>> conditional, which avoids the build error and also results
>> in smaller object code if not both are enabled, without the
>> need for an #ifdef.
>>
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>> Cc: Bastian Hecht <hechtb+renesas@gmail.com>
>> Cc: Simon Horman <horms+renesas@verge.net.au>
>> Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
>> ---
>>  arch/arm/mach-shmobile/intc-r8a7740.c | 13 +++++++++++--
>>  1 file changed, 11 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/arm/mach-shmobile/intc-r8a7740.c b/arch/arm/mach-shmobile/intc-r8a7740.c
>> index 8871f77..5dc57f1 100644
>> --- a/arch/arm/mach-shmobile/intc-r8a7740.c
>> +++ b/arch/arm/mach-shmobile/intc-r8a7740.c
>> @@ -53,14 +53,23 @@ static void __init r8a7740_init_irq_common(void)
>>
>>  void __init r8a7740_init_irq_of(void)
>>  {
>> +     if (!IS_ENABLED(CONFIG_OF))
>> +             return;
>> +
>
> In other parts of the shmobile I believe that such code is
> guarded by #ifdef CONFIG_OF and I believe not guarding this code in
> some way was an oversight.

Yes, sorry, I haven't thought about the dependency of irqchip_init and
CONFIG_OF.

> The above change seems fine to me.
>
>>       irqchip_init();
>>       r8a7740_init_irq_common();
>>  }
>>
>>  void __init r8a7740_init_irq(void)
>>  {
>> -     void __iomem *gic_dist_base = ioremap_nocache(0xc2800000, 0x1000);
>> -     void __iomem *gic_cpu_base = ioremap_nocache(0xc2000000, 0x1000);
>> +     void __iomem *gic_dist_base;
>> +     void __iomem *gic_cpu_base;
>> +
>> +     if (!IS_ENABLED(CONFIG_ATAGS))
>> +             return;
>> +
>> +     gic_dist_base = ioremap_nocache(0xc2800000, 0x1000);
>> +     gic_cpu_base = ioremap_nocache(0xc2000000, 0x1000);
>>
>>       /* initialize the Generic Interrupt Controller PL390 r0p0 */
>>       gic_init(0, 29, gic_dist_base, gic_cpu_base);
>
> This one seems broken as the armadillo800eva board currently uses
> it to initialise GIC even if CONFIG_ATAGS is not defined.
>
> I did test the above change on the armadillo800eva board
> with the above change and CONFIG_ATAGS disabled, the result was
> a boot failure. With the change reverted booting seems fine.

CONFIG_ATAGS and CONFIG_ARM_APPENDED_DTB are two ways to pass the
device tree information, right?
So we run into trouble when we use the later but disable the first.
Is there a reason why you wanted to avoid using two times just "if
(!IS_ENABLED(CONFIG_OF))", Arnd?

Thanks,

 Bastian
