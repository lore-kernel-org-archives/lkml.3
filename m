Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157Ab3KWBX1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 20:23:27 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:34688 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755807Ab3KWBXZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 20:23:25 -0500
Message-ID: <52900361.9000805@ti.com>
Date: Fri, 22 Nov 2013 19:22:41 -0600
From: Joel Fernandes <joelf@ti.com>
Reply-To: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
CC: linux-omap <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <jgchunter@gmail.com>, <rnayak@ti.com>, Felipe Balbi <balbi@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        <benoit.cousson@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 5/8] ARM: OMAP2+: timer: Introduce OF-friendly clocksource/clockevent
 system timers
References: <529000EA.7090001@ti.com>
In-Reply-To: <529000EA.7090001@ti.com>
X-Forwarded-Message-Id: <529000EA.7090001@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, resending due to an MUA issue.

Adding Thomas to the thread since discussion is about clocksource, and Mark
Rutland as discussion is related to timers and DT, thanks.

On 11/22/2013 02:01 PM, Rob Herring wrote:
> On Fri, Nov 22, 2013 at 10:42 AM, Joel Fernandes <joelf@ti.com> wrote:
>> On 11/22/2013 09:58 AM, Rob Herring wrote:
>>> On Thu, Nov 21, 2013 at 7:56 PM, Joel Fernandes <joelf@ti.com> wrote:
>>>> This work is a migration effort of OMAP system timers to the
>>>> clocksource/clockevent framework. Consider this as a first-pass in this effort.
>>>> There are few cleanups that need to be done first. The HWMOD code is
>>>> intertwined with the timer code. HWMOD code cleanups in the future will
>>>> hopefully make most of this code go away, so till then we separate out the
>>>> power/clocks portion of the code from the actual timer bits.  This will
>>>> facilitate near-future work of adapting the system timer as a clocksource.
>>>>
>>>> New functions for OF-only boot are introduced, and we can soon delete the old
>>>> versions once we migrate all platforms. Currently only AM335x is migrated and
>>>> testedA new omap_generic_timer_init function is introduced for DT platforms.
>>>> Code required earlier for non-DT platforms such as setup of timer IDs and timer
>>>> parent clock is not required.  parent clocks are automatically setup by the mux
>>>> clock driver through DT so they no longer need to be hardcoded.
>>>>
>>>> The init code will try to pick the best timer for clocksource and clockevent
>>>> however bindings are added to force a particular timer as clocksource or
>>>> clockevent through DT.
>>>>
>>>> Signed-off-by: Joel Fernandes <joelf@ti.com>
>>>> ---
>>>>  .../devicetree/bindings/arm/omap/timer.txt         |  12 ++
>>>>  arch/arm/mach-omap2/common.h                       |   1 +
>>>>  arch/arm/mach-omap2/timer.c                        | 235 +++++++++++++++++++++
>>>>  3 files changed, 248 insertions(+)
>>>>
>>>> diff --git a/Documentation/devicetree/bindings/arm/omap/timer.txt b/Documentation/devicetree/bindings/arm/omap/timer.txt
>>>> index d02e27c..6cf7a75 100644
>>>> --- a/Documentation/devicetree/bindings/arm/omap/timer.txt
>>>> +++ b/Documentation/devicetree/bindings/arm/omap/timer.txt
>>>> @@ -32,6 +32,18 @@ Optional properties:
>>>>  - ti,timer-secure:     Indicates the timer is reserved on a secure OMAP device
>>>>                         and therefore cannot be used by the kernel.
>>>>
>>>> +- ti,timer-clockevent,
>>>> +  ti,timer-clocksource These properties force the system timer code to choose
>>>> +                       the particular timer as a clockevent or clocksource.
>>>> +                       If these properties are not specified, the timer code
>>>> +                       picks up a "ti,timer-alwon" as the clocksource and a
>>>> +                       timer containing one of the following properties as
>>>> +                       the clockevent in the following order:
>>>> +                               ti,timer-alwon
>>>> +                               ti,timer-dsp
>>>> +                               ti,timer-pwm
>>>> +                               ti,timer-secure
>>>
>>> These properties were added specifically for the reason of avoiding
>>> linux specific properties like these. When is this not sufficient?
>>
>> Some platforms cannot use certain timers as clockevents and clocksource, to keep
>> this code functionally equivalent and working, I added these properties so that
>> its possible to select specific timers as clockevents/sources as was being done
>> in the non-DT case. I'm open to suggestions for doing this in a better way for DT.
> 
> There has to be a defined reason why a given timer cannot be used. You
> are not explaining what that reason is. Define a property or set of
> properties that describe the h/w feature or quirk.

Reason? There are HW bugs that prevent a timer from being used. See [1]. And
there may be other reasons, I haven't written this code but I know that there
are other HW bugs that made authors pick a specific timer such as board issues
or accuracy.

This is nothing new, just that I'm trying to find a way to do it from DT.

You can see the ifdef'ry below in mach-omap2/timer.c. All I'm trying to do is
make it simpler and cleaner by adding these properties to DT so that we can
delete this code entirely.


#ifdef CONFIG_ARCH_OMAP2
OMAP_SYS_32K_TIMER_INIT(2, 1, "timer_32k_ck", "ti,timer-alwon",
                        2, "timer_sys_ck", NULL);
#endif /* CONFIG_ARCH_OMAP2 */

#if defined(CONFIG_ARCH_OMAP3) || defined(CONFIG_SOC_AM43XX)
OMAP_SYS_32K_TIMER_INIT(3, 1, "timer_32k_ck", "ti,timer-alwon",
                        2, "timer_sys_ck", NULL);
OMAP_SYS_32K_TIMER_INIT(3_secure, 12, "secure_32k_fck", "ti,timer-secure",
                        2, "timer_sys_ck", NULL);
#endif /* CONFIG_ARCH_OMAP3 */

etc...

>>>
>>> And I agree with the comment to use OF_CLKSRC.
>>>
>>
>> There are difficulties I mentioned in a previous post [1] stating why it may not
>> be possible to use OF_CLKSRC macros, and still keep the code functionally
>> equivalent to when it was non-DT.
> 
> Sorry, I don't buy it.
> 

Ofcourse even I want to use OF_CLOCKSOURCE macros for registering DT
clocksources, but re-iterating, the selection of timer is not a simple match of
compatible property as you may see in my patch. Some platforms need specific
timer as clocksource, all timers have same "compatible" flag. How would you
differentiate? Refer to ifdef's above to see how timer IDs change across
platforms in the non-DT code that's being converted.

I think clocksource_of_init has been written such that any timer having a
matching compatible can be enumerated.

I can change the compatible to something unique in the DT like:

timer1:timer@... {
  compatible = "ti,dmtimer-clocksource"
  ....
}

 and that may make clocksource work. But then such a similar approach to
clockevent is not possible. What I observed in other platforms is a *single* DT
node represents both clocksource and clockevent.

For example, in zevio-timer:
drivers/clocksource/zevio-timer.c

does this:
CLOCKSOURCE_OF_DECLARE(zevio_timer, "lsi,zevio-timer", zevio_timer_add);

In the body of zevio_timer_add(struct device_node *node), they do this:
        timer->base = of_iomap(node, 0);
        timer->timer1 = timer->base + IO_TIMER1; // USED AS CLOCKSOURCE
        timer->timer2 = timer->base + IO_TIMER2; // USED AS CLOCKEVENT

What's happening here is a single device node (DT node) represents both
clockevent and source. But for OMAP, we use different timers for clockevent and
clocksource. They are physically 2 different timer DT nodes. How do we register
something like this with the CLOCKSOURCE_OF_DECLARE macro?

Looking forward to your suggestions.

thanks,

-Joel

