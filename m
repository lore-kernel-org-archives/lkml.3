Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372Ab3IVKSY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 06:18:24 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:50848 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753351Ab3IVKSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 06:18:21 -0400
Message-ID: <523EE004.5060301@gmail.com>
Date: Sun, 22 Sep 2013 14:18:12 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
CC: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Alessandro Rubini <rubini@unipv.it>,
        Linus Walleij <linus.walleij@linaro.org>,
        STEricsson <STEricsson_nomadik_linux@list.st.com>,
        Russell King <linux@arm.linux.org.uk>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/26] ARM: nomadik: move mtu setup to clocksource init
References: <1379526839-14798-1-git-send-email-sebastian.hesselbarth@gmail.com> <1379526839-14798-2-git-send-email-sebastian.hesselbarth@gmail.com> <523CBA5F.60901@gmail.com>
In-Reply-To: <523CBA5F.60901@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2013 11:13 PM, Sebastian Hesselbarth wrote:
> On 09/18/2013 07:53 PM, Sebastian Hesselbarth wrote:
>> MTU timer initialization is stuffed into .init_time callback, while
>> cpu8815_timer_init_of again maps addresses from the same device node.
>> Therefore, this patch moves mtu setup from to clocksource init.
>>
>> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
>> ---
>> Cc: Olof Johansson <olof@lixom.net>
>> Cc: Arnd Bergmann <arnd@arndb.de>
>> Cc: Alessandro Rubini <rubini@unipv.it>
>> Cc: Linus Walleij <linus.walleij@linaro.org>
>> Cc: STEricsson <STEricsson_nomadik_linux@list.st.com>
>> Cc: Russell King <linux@arm.linux.org.uk>
>> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: linux-arm-kernel@lists.infradead.org
>> Cc: linux-kernel@vger.kernel.org
>> ---
>>   arch/arm/mach-nomadik/cpu-8815.c  |   26 --------------------------
>>   drivers/clocksource/nomadik-mtu.c |   11 +++++++++++
>>   2 files changed, 11 insertions(+), 26 deletions(-)
>>
>> diff --git a/arch/arm/mach-nomadik/cpu-8815.c
>> b/arch/arm/mach-nomadik/cpu-8815.c
>> index 13e0df9..0fcb149 100644
>> --- a/arch/arm/mach-nomadik/cpu-8815.c
>> +++ b/arch/arm/mach-nomadik/cpu-8815.c
>> @@ -113,36 +113,10 @@ static void cpu8815_restart(enum reboot_mode
>> mode, const char *cmd)
>>       writel(1, srcbase + 0x18);
>>   }
>>
>> -/* Initial value for SRC control register: all timers use MXTAL/8
>> source */
>> -#define SRC_CR_INIT_MASK    0x00007fff
>> -#define SRC_CR_INIT_VAL        0x2aaa8000
>> -
>>   static void __init cpu8815_timer_init_of(void)
>>   {
>> -    struct device_node *mtu;
>> -    void __iomem *base;
>> -    int irq;
>> -    u32 src_cr;
>> -
>>       /* We need this to be up now */
>>       nomadik_clk_init();
>> -
>> -    mtu = of_find_node_by_path("/mtu@101e2000");
>> -    if (!mtu)
>> -        return;
>> -    base = of_iomap(mtu, 0);
>> -    if (WARN_ON(!base))
>> -        return;
>> -    irq = irq_of_parse_and_map(mtu, 0);
>> -
>> -    pr_info("Remapped MTU @ %p, irq: %d\n", base, irq);
>> -
>> -    /* Configure timer sources in "system reset controller" ctrl reg */
>> -    src_cr = readl(base);
>> -    src_cr &= SRC_CR_INIT_MASK;
>> -    src_cr |= SRC_CR_INIT_VAL;
>> -    writel(src_cr, base);
>> -
>>       clocksource_of_init();
>>   }
>
> Linus,
>
> looking at the fix you posted at [1], can I assume that the above it
> redundant and can be removed?
>
> [1] http://marc.info/?l=linux-arm-kernel&m=137910161418706&w=2

Linus,

can you please prepare a topic branch with the above patch. I can
merge that one with a stable commit id then. Also, I will rebase the
remaining nomadik patches for you to test.

Sebastian

>> diff --git a/drivers/clocksource/nomadik-mtu.c
>> b/drivers/clocksource/nomadik-mtu.c
>> index 1b74bea..b9f97ba 100644
>> --- a/drivers/clocksource/nomadik-mtu.c
>> +++ b/drivers/clocksource/nomadik-mtu.c
>> @@ -257,12 +257,17 @@ void __init nmdk_timer_init(void __iomem *base,
>> int irq)
>>       __nmdk_timer_init(base, irq, pclk0, clk0);
>>   }
>>
>> +/* Initial value for SRC control register: all timers use MXTAL/8
>> source */
>> +#define SRC_CR_INIT_MASK    0x00007fff
>> +#define SRC_CR_INIT_VAL        0x2aaa8000
>> +
>>   static void __init nmdk_timer_of_init(struct device_node *node)
>>   {
>>       struct clk *pclk;
>>       struct clk *clk;
>>       void __iomem *base;
>>       int irq;
>> +    u32 src_cr;
>>
>>       base = of_iomap(node, 0);
>>       if (!base)
>> @@ -280,6 +285,12 @@ static void __init nmdk_timer_of_init(struct
>> device_node *node)
>>       if (irq <= 0)
>>           panic("Can't parse IRQ");
>>
>> +    /* Configure timer sources in "system reset controller" ctrl reg */
>> +    src_cr = readl(base);
>> +    src_cr &= SRC_CR_INIT_MASK;
>> +    src_cr |= SRC_CR_INIT_VAL;
>> +    writel(src_cr, base);
>> +
>>       __nmdk_timer_init(base, irq, pclk, clk);
>>   }
>>   CLOCKSOURCE_OF_DECLARE(nomadik_mtu, "st,nomadik-mtu",
>>
>

