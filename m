Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224AbaCMXgs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 19:36:48 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:36994 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754765AbaCMXgr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 19:36:47 -0400
Message-ID: <532240F0.1030403@ti.com>
Date: Thu, 13 Mar 2014 18:36:16 -0500
From: Joel Fernandes <joelf@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Rob Herring <robh@kernel.org>
CC: Tony Lindgren <tony@atomide.com>, Tero Kristo <t-kristo@ti.com>,
        Nishanth Menon <nm@ti.com>, Suman Anna <s-anna@ti.com>,
        Felipe Balbi <balbi@ti.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 3/5] ARM: OMAP2+: timer: Add clocksource initialization
 and powerup support
References: <1394742919-32163-1-git-send-email-joelf@ti.com>	<1394742919-32163-4-git-send-email-joelf@ti.com> <CAL_JsqJVPVybd90WUv_nCqUJMUgR+Ep3yxrX2+psNYqic-WQ1Q@mail.gmail.com>
In-Reply-To: <CAL_JsqJVPVybd90WUv_nCqUJMUgR+Ep3yxrX2+psNYqic-WQ1Q@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2014 04:52 PM, Rob Herring wrote:
> On Thu, Mar 13, 2014 at 3:35 PM, Joel Fernandes <joelf@ti.com> wrote:
>> Introduce a generic omap timer initialization function that can
>> be used by all SoCs for which support is available in the clocksource
>> driver introduced in the series.
>>
>> The function will also be responsible for calling clock initialization
>> required for everything else to work.
>>
>> Signed-off-by: Joel Fernandes <joelf@ti.com>
>> ---
>>  arch/arm/mach-omap2/common.h |    1 +
>>  arch/arm/mach-omap2/timer.c  |   28 ++++++++++++++++++++++++++++
>>  2 files changed, 29 insertions(+)
>>
>> diff --git a/arch/arm/mach-omap2/common.h b/arch/arm/mach-omap2/common.h
>> index a6aae30..e58d9a4 100644
>> --- a/arch/arm/mach-omap2/common.h
>> +++ b/arch/arm/mach-omap2/common.h
>> @@ -92,6 +92,7 @@ extern void omap3_secure_sync32k_timer_init(void);
>>  extern void omap3_gptimer_timer_init(void);
>>  extern void omap4_local_timer_init(void);
>>  extern void omap5_realtime_timer_init(void);
>> +void omap_generic_timer_init(void);
>>
>>  void omap2420_init_early(void);
>>  void omap2430_init_early(void);
>> diff --git a/arch/arm/mach-omap2/timer.c b/arch/arm/mach-omap2/timer.c
>> index 74044aa..08c73a0 100644
>> --- a/arch/arm/mach-omap2/timer.c
>> +++ b/arch/arm/mach-omap2/timer.c
>> @@ -324,6 +324,25 @@ static int __init omap_dm_timer_init_one(struct omap_dm_timer *timer,
>>         return r;
>>  }
>>
>> +int __init omap_dmtimer_powerup(struct omap_dm_timer *timer,
>> +                                       struct device_node *np) {
> 
> This function seems unrelated to the commit message.

Ok, I'll add it in the message.

> 
>> +       struct omap_hwmod *oh;
>> +       const char *oh_name = NULL;
>> +
>> +       of_property_read_string_index(np, "ti,hwmods", 0, &oh_name);
>> +       if (!oh_name)
>> +               return -ENODEV;
>> +
>> +       oh = omap_hwmod_lookup(oh_name);
>> +       if (!oh)
>> +               return -ENODEV;
>> +
>> +       omap_hwmod_setup_one(oh_name);
>> +
>> +       omap_hwmod_enable(oh);
>> +       return 0;
>> +}
>> +
>>  static void __init omap2_gp_clockevent_init(int gptimer_id,
>>                                                 const char *fck_source,
>>                                                 const char *property)
>> @@ -615,6 +634,15 @@ static OMAP_SYS_32K_TIMER_INIT(4, 1, "timer_32k_ck", "ti,timer-alwon",
>>                                2, "sys_clkin_ck", NULL);
>>  #endif
>>
>> +void omap_generic_timer_init(void)
>> +{
>> +       if (!of_have_populated_dt())
>> +               BUG_ON("Generic timer init should only be used for DT boot\n");
> 
> I thought omap2 is always DT boot now.

That's right, sorry- I'll get rid of the check.

>> +
>> +       omap_clk_init();
> 
> Can't you use CLK_OF_DECLARE and remove this? Then you can remove the
> init_time function hook completely.

There is some dev-id conn-id -> DT node mapping done. I'll let Tero comment
more on this.

Thanks,
-Joel

> 
>> +       clocksource_of_init();
>> +}
>> +
>>  #ifdef CONFIG_ARCH_OMAP4
>>  #ifdef CONFIG_HAVE_ARM_TWD
>>  static DEFINE_TWD_LOCAL_TIMER(twd_local_timer, OMAP44XX_LOCAL_TWD_BASE, 29);
>> --
>> 1.7.9.5
>>

