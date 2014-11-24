Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751677AbaKXCZf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 21:25:35 -0500
Received: from mail-qa0-f51.google.com ([209.85.216.51]:62809 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbaKXCZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 21:25:33 -0500
MIME-Version: 1.0
In-Reply-To: <CAOesGMjkreCUv1YSRYmaJfz0+9qcOU2=9qvKEjLqmxMAajqoRw@mail.gmail.com>
References: <1412753937-29343-1-git-send-email-sonnyrao@chromium.org>
 <20141120161013.GB5447@e104818-lin.cambridge.arm.com> <CAD=FV=UmTErYnnVMeXCZzHX_kNzM6LHkxXMwRvnxahNQpuqguw@mail.gmail.com>
 <20141120165849.GF5447@e104818-lin.cambridge.arm.com> <CAOesGMjkreCUv1YSRYmaJfz0+9qcOU2=9qvKEjLqmxMAajqoRw@mail.gmail.com>
From: Sonny Rao <sonnyrao@chromium.org>
Date: Sun, 23 Nov 2014 18:25:12 -0800
X-Google-Sender-Auth: JdDZ708wUK78Rg1pNAbjw4bxiZg
Message-ID: <CAPz6YkWdny1=tXKaa7zq6etH4HaRmShU0zG-MV6Jk33LgCSc_A@mail.gmail.com>
Subject: Re: [PATCH v4] clocksource: arch_timer: Fix code to use physical
 timers when requested
To: Olof Johansson <olof@lixom.net>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Doug Anderson <dianders@chromium.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Sudeep Holla <Sudeep.Holla@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 12:58 PM, Olof Johansson <olof@lixom.net> wrote:
> On Thu, Nov 20, 2014 at 8:58 AM, Catalin Marinas
> <catalin.marinas@arm.com> wrote:
>> Doug,
>>
>> On Thu, Nov 20, 2014 at 04:24:09PM +0000, Doug Anderson wrote:
>>> On Thu, Nov 20, 2014 at 8:10 AM, Catalin Marinas
>>> <catalin.marinas@arm.com> wrote:
>>> > On Wed, Oct 08, 2014 at 08:38:57AM +0100, Sonny Rao wrote:
>>> >> This is a bug fix for using physical arch timers when
>>> >> the arch_timer_use_virtual boolean is false.  It restores the
>>> >> arch_counter_get_cntpct() function after removal in
>>> >>
>>> >> 0d651e4e "clocksource: arch_timer: use virtual counters"
>>> >>
>>> >> We need this on certain ARMv7 systems which are architected like this:
>>> >>
>>> >> * The firmware doesn't know and doesn't care about hypervisor mode and
>>> >>   we don't want to add the complexity of hypervisor there.
>>> >>
>>> >> * The firmware isn't involved in SMP bringup or resume.
>>> >>
>>> >> * The ARCH timer come up with an uninitialized offset between the
>>> >>   virtual and physical counters.  Each core gets a different random
>>> >>   offset.
>>> >>
>>> >> * The device boots in "Secure SVC" mode.
>>> >>
>>> >> * Nothing has touched the reset value of CNTHCTL.PL1PCEN or
>>> >>   CNTHCTL.PL1PCTEN (both default to 1 at reset)
>>> >>
>>> >> One example of such as system is RK3288 where it is much simpler to
>>> >> use the physical counter since there's nobody managing the offset and
>>> >> each time a core goes down and comes back up it will get reinitialized
>>> >> to some other random value.
>>> >>
>>> >> Fixes: 0d651e4e65e9 ("clocksource: arch_timer: use virtual counters")
>>> >> Cc: stable@vger.kernel.org
>>> >> Signed-off-by: Sonny Rao <sonnyrao@chromium.org>
>>> >> Acked-by: Olof Johansson <olof@lixom.net>
>>> > [...]
>>> >> --- a/arch/arm64/include/asm/arch_timer.h
>>> >> +++ b/arch/arm64/include/asm/arch_timer.h
>>> >> @@ -135,6 +135,16 @@ static inline void arch_timer_evtstrm_enable(int divider)
>>> >>  #endif
>>> >>  }
>>> >>
>>> >> +static inline u64 arch_counter_get_cntpct(void)
>>> >> +{
>>> >> +     u64 cval;
>>> >> +
>>> >> +     isb();
>>> >> +     asm volatile("mrs %0, cntpct_el0" : "=r" (cval));
>>> >> +
>>> >> +     return cval;
>>> >> +}
>>> >
>>> > Sorry but I have to NAK the arm64 changes here. If the firmware is
>>> > broken and does not initialise CNTVOFF properly, please fix it (at least
>>> > on ARMv8 hardware). Also, on arm64 the vdso gettimeofday()
>>> > implementation relies on using the virtual counter, so correct
>>> > initialisation of CNTVOFF is essential.
>>>
>>> Sonny's patch here just makes it so that we honor the global variable.
>>> My patch at <https://patchwork.kernel.org/patch/5051881/> is the one
>>> that allows the global variable to be set.  You can see in that patch
>>> that it's impossible for the variable to be set on ARM64.
>>
>> It just gives people ideas ;), thinking they only need to remove
>> IS_ENABLED(CONFIG_ARM) in your patch and get this working on arm64.
>>
>>> In previous discussions it was agreed that on ARM64 psci (or something
>>> similar) was a requirement anyway and that gave us a way to get the
>>> firmware involved again if we ever need to bring down a processor and
>>> bring it back up in the kernel.  PSCI is not a requirement for ARM32.
>>> There are systems that don't get the firmware involved when a
>>> processor loses state (like if it is powered off and powered on again,
>>> maybe for suspend/resume) and there was pushback against the kernel
>>> itself transitioning into monitor mode to init CNTVOFF in these cases.
>>> People agreed a month ago that these two patches were a reasonable
>>> approach for ARM32.
>>
>> I'm not complaining about about arm32 here, just the arm64
>> implementation. If you want to avoid #ifdefs in the arch timer driver,
>> what about, for arm64, defining something like:
>>
>> static inline u64 arch_counter_get_cntpct(void)
>> {
>>         /*
>>          * AArch64 kernel and user space mandate the use of CNTVCT.
>>          */
>>         BUG();
>>         return 0;
>> }
>
> Seems like a reasonable approach to me.

Ok, I will re-spin this one, sorry for the delay.

>
>
> -Olof
