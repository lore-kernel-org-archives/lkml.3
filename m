Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711AbaJXNXE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 09:23:04 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:29040 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756494AbaJXNXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 09:23:00 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-c0-544a52b1e8b0
Message-id: <544A52B0.9050901@samsung.com>
Date: Fri, 24 Oct 2014 15:22:56 +0200
From: Marcin Jabrzyk <m.jabrzyk@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
MIME-version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Kukjin Kim <kgene.kim@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        linux-samsung-soc@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org,
        Mark Rutland <Mark.Rutland@arm.com>,
        Chander Kashyap <chander.kashyap@linaro.org>
Subject: Re: =?windows-1252?Q?PROBLEM=3A=A0BUG__appearing_when_tr?=
 =?windows-1252?Q?ying_to_allocate_interrupt_on_Exynos_MCT_?=
 =?windows-1252?Q?after_CPU_hotplug?=
References: <544907D4.1020409@samsung.com>
 <20141023140644.GI27405@n2100.arm.linux.org.uk>
 <54494BEE.9020702@codeaurora.org>
In-reply-to: <54494BEE.9020702@codeaurora.org>
Content-type: text/plain; charset=windows-1252; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMLMWRmVeSWpSXmKPExsVy+t/xy7obg7xCDLq7zSw2zljPavFw/U0W
	i3mfZS16F1xlszjb9IbdYtPja6wWl3fNYbOYcX4fk8Xty7wWS69fZLL4caabxWLzpqnMDjwe
	a+atYfRoae5h87jc18vkcefaHjaPd+fOsXtsXlLv0bdlFaPH501yARxRXDYpqTmZZalF+nYJ
	XBm9R+MLlipWbP10hK2B8YZUFyMnh4SAicS9j7sZIWwxiQv31rN1MXJxCAksZZT437SNHcL5
	yCjx7283O0gVr4CWRO+1NywgNouAqsSPVYuB4hwcbAI6EudXa4CERQUiJK6smcMIUS4o8WPy
	PbByEYEYiXlrLoGNYRboZ5bY/CsIZL6wwEpGidPvHjFBLGtglOh//AOsm1NAT2LXliOsEB22
	Egver2OBsOUlNq95yzyBUWAWkiWzkJTNQlK2gJF5FaNoamlyQXFSeq6RXnFibnFpXrpecn7u
	JkZIxHzdwbj0mNUhRgEORiUe3h9bPEOEWBPLiitzDzFKcDArifD6+3uFCPGmJFZWpRblxxeV
	5qQWH2Jk4uCUamDc+nCGwJ7Cip1/MusXbXeZqevTstkhcH//jMOpj1q2r7Z4MqEg7KWrn4/P
	KecG209euhdmMiy2+Du/i1NO4cWlFT8aInI2mR1Z2bLlveqseS+YM6UDFjOfuunQdEB2E8P8
	m5m+WqnHHGxe+62OLNjtxj+57suL1GkteRXBbCFed11WtrBIN5oqsRRnJBpqMRcVJwIAzSC1
	tXYCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 23/10/14 20:41, Stephen Boyd wrote:
> On 10/23/2014 07:06 AM, Russell King - ARM Linux wrote:
>> On Thu, Oct 23, 2014 at 03:51:16PM +0200, Marcin Jabrzyk wrote:
>>> [1.] One line summary of the problem: "BUG: sleeping function called from
>>> invalid context at mm/slub.c:1250" after CPU hotplug
>> I'm really not surprised.
>>
>>> When SoC have MCT_INT_SPI interrupt it is being allocated after hotplugging
>>> of the CPU, secondary_start_kernel() is sending CPU boot notifications which
>>> are send when preemption and interrupts are disabled. Exynos_mct
>>> notification handler tries to set up and allocate IRQ for SPI type interrupt
>>> for started CPU and then BUG appears.
>>> There might be similar problem on qcom-timer I think just after looking on
>>> the code.
>
> There's no problem for qcom-timer because there are only PPIs on SMP
> platforms.
>

Ok, so it's only a problem on Exynos platform for now.
>> The CPU notifier is called via notify_cpu_starting(), which is called
>> with interrupts disabled, and a reason code of CPU_STARTING.  Interrupts
>> at this point /must/ remain disabled.
>>
>> The Exynos code then goes on to call exynos4_local_timer_setup() which
>> tries to reverse the free_irq() in exynos4_local_timer_stop() by calling
>> request_irq().  Calling request_irq() with interrupts off has never been
>> permissible.
>>
>> So, this code is wrong today, and it was also wrong when it was written.
>> It /couldn't/ have been tested.  It looks like this commit added this
>> buggy code:
>>
>> commit ee98d27df6827b5ba4bd99cb7d5cb1239b6a1a31
>> Author: Stephen Boyd <sboyd@codeaurora.org>
>> Date:   Fri Feb 15 16:40:51 2013 -0800
>>
>>      ARM: EXYNOS4: Divorce mct from local timer API
>>
>>      Separate the mct local timers from the local timer API. This will
>>      allow us to remove ARM local timer support in the near future and
>>      gets us closer to moving this driver to drivers/clocksource.
>>
>>      Acked-by: Kukjin Kim <kgene.kim@samsung.com>
>>      Acked-by: Marc Zyngier <marc.zyngier@arm.com>
>>      Cc: Thomas Abraham <thomas.abraham@linaro.org>
>>      Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
>
> I'm not so sure. It looks like in that patch I didn't change anything
> with respect to when things are called. In fact, it looks like we were
> calling setup_irq() there, but another patch around the same time
> changed that to request_irq()
>
> commit 7114cd749a12ff9fd64a2f6f04919760f45ab183
> Author: Chander Kashyap <chander.kashyap@linaro.org>
> Date:   Wed Jun 19 00:29:35 2013 +0900
>
>      clocksource: exynos_mct: use (request/free)_irq calls for local timer registration
>
>      Replace the (setup/remove)_irq calls for local timer registration with
>      (request/free)_irq calls. This generalizes the local timer registration API.
>      Suggested by Mark Rutland.
>
>      Signed-off-by: Chander Kashyap <chander.kashyap@linaro.org>
>      Acked-by: Mark Rutland <mark.rutland@arm.com>
>      Reviewed-by: Tomasz Figa <t.figa@samsung.com>
>      Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
>
> I don't believe setup_irq() allocates anything so we should probably go
> back to using that over request_irq() or explore requesting the irqs
> once and then enabling/disabling instead.
>

So what would be a better way to handle this? Going back to setup_irq or 
trying to enable/disable irqs on CPU hotplug? As this touched low level 
things and it's rare case for setting/enabling irqs just after CPU is 
coming back to life again.

>> A good question would be: why doesn't this happen at boot time when CPU1
>> is first brought up?  The conditions here are no different from hotplugging
>> CPU1 back in.  Do you see a similar warning on boot too?
>>

No the boot looks clean and there is not any sign of that problem.
>
> Probably because such checks are completely avoided until the system
> state is switched to SYSTEM_RUNNING (see the first if statement in
> __might_sleep()). It would be nice if we could remove that.
>

That's most probably the reason of no warnings on boot process.

Best regards,
--
Marcin Jabrzyk
Samsung R&D Institute Poland
Samsung Electronics
