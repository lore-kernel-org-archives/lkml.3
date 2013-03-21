Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933081Ab3CUMwx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 08:52:53 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:36046 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756438Ab3CUMws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 08:52:48 -0400
Message-ID: <514B029D.1010409@gmail.com>
Date: Thu, 21 Mar 2013 07:52:45 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Simon Horman <horms@verge.net.au>,
        John Stultz <john.stultz@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] ARM: convert arm/arm64 arch timer to use CLKSRC_OF init
References: <1363818875-15978-1-git-send-email-robherring2@gmail.com> <20130321110646.GE15279@e106331-lin.cambridge.arm.com>
In-Reply-To: <20130321110646.GE15279@e106331-lin.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2013 06:06 AM, Mark Rutland wrote:
> Hi Rob,
> 
> (adding Marc to Cc as he may have comments).
> 
> On Wed, Mar 20, 2013 at 10:34:35PM +0000, Rob Herring wrote:
>> From: Rob Herring <rob.herring@calxeda.com>
>>
>> This converts arm and arm64 to use CLKSRC_OF DT based initialization for
>> the arch timer. A new function arch_timer_arch_init is added to allow for
>> arch specific setup.
>>
>> This has a side effect of enabling sched_clock on omap5 and exynos5. There
>> should not be any reason not to use the arch timers for sched_clock.
> 
> Nice! I was just about to post a (slightly updated) version of Thomas Abraham's
> arch_timer clocksource_of_init patch, but this seems much more comprehensive.
> 
> I have some other arch_timer patches which may clash, but they could be rebased
> atop of this.

[snip]

>> @@ -446,10 +446,7 @@ static void __init v2m_dt_timer_init(void)
>>                                 irq_of_parse_and_map(node, 0));
>>         }
>>
>> -       arch_timer_of_register();
>> -
>> -       if (arch_timer_sched_clock_init() != 0)
>> -               versatile_sched_clock_init(vexpress_get_24mhz_clock_base(),
>> +       versatile_sched_clock_init(vexpress_get_24mhz_clock_base(),
>>                                 24000000);
>>  }
>>
> 
> On TC2 this series leads to using the vexpress 24MHz clock as the sched clock
> in preference to the architected timer:
> 
>   Architected local timer running at 24.00MHz (virt).
>   Switching to timer-based delay loop
>   Registered arch_counter_get_cntvct+0x0/0x14 as sched_clock source
>   sched_clock: 32 bits at 24MHz, resolution 41ns, wraps every 178956ms
>   Registered versatile_read_sched_clock+0x0/0x28 as sched_clock source
> 
> As they both have the same frequency, neither overrides the other, and
> whichever gets registered last is used as the sched_clock. As accesses to the
> architected timer are going to have a much lower overhead, this isn't very nice
> (and it could be better to use it even if it had a lower frequency).
> 
> We could move the versatile_sched_clock_init call before the
> clocksource_of_init, but that doesn't feel like an ideal solution. We may have
> similar problems elsewhere.

The intention was that a 64-bit counter is preferred. This should fix 
that. It would be nice if we could describe access overhead to make a decision. 
For now, I think 32 vs. 64 bit is sufficient.

diff --git a/arch/arm/kernel/sched_clock.c b/arch/arm/kernel/sched_clock.c
index 1708357..aa18e45 100644
--- a/arch/arm/kernel/sched_clock.c
+++ b/arch/arm/kernel/sched_clock.c
@@ -115,7 +115,7 @@ void __init setup_sched_clock(u32 (*read)(void), int bits, unsigned long rate)
 	u64 res, wrap;
 	char r_unit;
 
-	if (cd.rate > rate)
+	if (cd.rate > rate || read_sched_clock_64)
 		return;
 
 	BUG_ON(bits > 32);
@@ -168,7 +168,7 @@ void __init setup_sched_clock(u32 (*read)(void), int bits, unsigned long rate)
 
 void __init setup_sched_clock_64(u64 (*read)(void), unsigned long rate)
 {
-	if (cd.rate > rate)
+	if (read_sched_clock_64 && (cd.rate > rate))
 		return;
 
 	WARN_ON(!irqs_disabled());


>> diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
>> index d7ad425..afb70aa 100644
>> --- a/drivers/clocksource/arm_arch_timer.c
>> +++ b/drivers/clocksource/arm_arch_timer.c
>> @@ -337,24 +337,11 @@ out:
>>         return err;
>>  }
>>
>> -static const struct of_device_id arch_timer_of_match[] __initconst = {
>> -       { .compatible   = "arm,armv7-timer",    },
>> -       { .compatible   = "arm,armv8-timer",    },
>> -       {},
>> -};
>> -
>> -int __init arch_timer_init(void)
>> +static void __init arch_timer_init(struct device_node *np)
>>  {
>> -       struct device_node *np;
>>         u32 freq;
>>         int i;
>>
> 
> If we the following here:
> 
> 	if (arch_timer_get_rate()) {
> 		pr_warn("arch_timer: multiple nodes in dt, skipping\n");
> 		return;
> 	}
> 
> We may save ourselves a whole world of pain with dts which (erroneously) have
> multiple timer nodes (though these are now disappearing). Otherwise we could
> have a memory leak and multiple instances of the cpu0 timer registered, which
> could lead to all sorts of weirdness. The existing code side-steps this issue
> by only grabbing the first node, so this would keep things consistent.
> 

Okay, I'll add.

Rob

