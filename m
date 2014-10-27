Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752310AbaJ0UQV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 16:16:21 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:40333 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbaJ0UQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 16:16:19 -0400
Message-ID: <544EA810.6090502@codeaurora.org>
Date: Mon, 27 Oct 2014 13:16:16 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Marcin Jabrzyk <m.jabrzyk@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Kukjin Kim <kgene.kim@samsung.com>,
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
References: <544907D4.1020409@samsung.com> <20141023140644.GI27405@n2100.arm.linux.org.uk> <54494BEE.9020702@codeaurora.org> <544A52B0.9050901@samsung.com>
In-Reply-To: <544A52B0.9050901@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2014 06:22 AM, Marcin Jabrzyk wrote:
>
>
> On 23/10/14 20:41, Stephen Boyd wrote:
>> On 10/23/2014 07:06 AM, Russell King - ARM Linux wrote:
>>> The CPU notifier is called via notify_cpu_starting(), which is called
>>> with interrupts disabled, and a reason code of CPU_STARTING. 
>>> Interrupts
>>> at this point /must/ remain disabled.
>>>
>>> The Exynos code then goes on to call exynos4_local_timer_setup() which
>>> tries to reverse the free_irq() in exynos4_local_timer_stop() by
>>> calling
>>> request_irq().  Calling request_irq() with interrupts off has never
>>> been
>>> permissible.
>>>
>>> So, this code is wrong today, and it was also wrong when it was
>>> written.
>>> It /couldn't/ have been tested.  It looks like this commit added this
>>> buggy code:
>>>
>>> commit ee98d27df6827b5ba4bd99cb7d5cb1239b6a1a31
>>> Author: Stephen Boyd <sboyd@codeaurora.org>
>>> Date:   Fri Feb 15 16:40:51 2013 -0800
>>>
>>>      ARM: EXYNOS4: Divorce mct from local timer API
>>>
>>>      Separate the mct local timers from the local timer API. This will
>>>      allow us to remove ARM local timer support in the near future and
>>>      gets us closer to moving this driver to drivers/clocksource.
>>>
>>>      Acked-by: Kukjin Kim <kgene.kim@samsung.com>
>>>      Acked-by: Marc Zyngier <marc.zyngier@arm.com>
>>>      Cc: Thomas Abraham <thomas.abraham@linaro.org>
>>>      Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
>>
>> I'm not so sure. It looks like in that patch I didn't change anything
>> with respect to when things are called. In fact, it looks like we were
>> calling setup_irq() there, but another patch around the same time
>> changed that to request_irq()
>>
>> commit 7114cd749a12ff9fd64a2f6f04919760f45ab183
>> Author: Chander Kashyap <chander.kashyap@linaro.org>
>> Date:   Wed Jun 19 00:29:35 2013 +0900
>>
>>      clocksource: exynos_mct: use (request/free)_irq calls for local
>> timer registration
>>
>>      Replace the (setup/remove)_irq calls for local timer
>> registration with
>>      (request/free)_irq calls. This generalizes the local timer
>> registration API.
>>      Suggested by Mark Rutland.
>>
>>      Signed-off-by: Chander Kashyap <chander.kashyap@linaro.org>
>>      Acked-by: Mark Rutland <mark.rutland@arm.com>
>>      Reviewed-by: Tomasz Figa <t.figa@samsung.com>
>>      Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
>>
>> I don't believe setup_irq() allocates anything so we should probably go
>> back to using that over request_irq() or explore requesting the irqs
>> once and then enabling/disabling instead.
>>
>
> So what would be a better way to handle this? Going back to setup_irq
> or trying to enable/disable irqs on CPU hotplug? As this touched low
> level things and it's rare case for setting/enabling irqs just after
> CPU is coming back to life again.
>

The safest thing is setup_irq(), but do you care to try this patch?
Doing the enable/disable is not as robust because request_irq() returns
with the irq enabled and then we have to disable the irq to make things
symmetric. This whole driver doesn't look like it's prepared for such a
situation where the interrupt triggers before the clockevent is
registered so this doesn't look like a problem in practice. Doing the
disable right after request is typically bad though, and may not pass
review.

----8<-----

From: Stephen Boyd <sboyd@codeaurora.org>
Subject: [PATCH] clocksource: exynos_mct: Avoid scheduling while atomic

If we call request_irq() during the CPU_STARTING notifier we'll
try to allocate an irq descriptor with GFP_KERNEL while we're
running with irqs disabled. Just request the irqs at boot time
and enable/disable them when a CPU comes up or goes down to avoid
such problems.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/clocksource/exynos_mct.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/clocksource/exynos_mct.c b/drivers/clocksource/exynos_mct.c
index 9403061a2acc..1800053b4644 100644
--- a/drivers/clocksource/exynos_mct.c
+++ b/drivers/clocksource/exynos_mct.c
@@ -467,13 +467,7 @@ static int exynos4_local_timer_setup(struct clock_event_device *evt)
 
 	if (mct_int_type == MCT_INT_SPI) {
 		evt->irq = mct_irqs[MCT_L0_IRQ + cpu];
-		if (request_irq(evt->irq, exynos4_mct_tick_isr,
-				IRQF_TIMER | IRQF_NOBALANCING,
-				evt->name, mevt)) {
-			pr_err("exynos-mct: cannot register IRQ %d\n",
-				evt->irq);
-			return -EIO;
-		}
+		enable_irq(evt->irq);
 		irq_force_affinity(mct_irqs[MCT_L0_IRQ + cpu], cpumask_of(cpu));
 	} else {
 		enable_percpu_irq(mct_irqs[MCT_L0_IRQ], 0);
@@ -488,7 +482,7 @@ static void exynos4_local_timer_stop(struct clock_event_device *evt)
 {
 	evt->set_mode(CLOCK_EVT_MODE_UNUSED, evt);
 	if (mct_int_type == MCT_INT_SPI)
-		free_irq(evt->irq, this_cpu_ptr(&percpu_mct_tick));
+		disable_irq(evt->irq);
 	else
 		disable_percpu_irq(mct_irqs[MCT_L0_IRQ]);
 }
@@ -522,8 +516,9 @@ static struct notifier_block exynos4_mct_cpu_nb = {
 
 static void __init exynos4_timer_resources(struct device_node *np, void __iomem *base)
 {
-	int err;
+	int err, cpu;
 	struct mct_clock_event_device *mevt = this_cpu_ptr(&percpu_mct_tick);
+	struct mct_clock_event_device *evt;
 	struct clk *mct_clk, *tick_clk;
 
 	tick_clk = np ? of_clk_get_by_name(np, "fin_pll") :
@@ -549,7 +544,15 @@ static void __init exynos4_timer_resources(struct device_node *np, void __iomem
 		WARN(err, "MCT: can't request IRQ %d (%d)\n",
 		     mct_irqs[MCT_L0_IRQ], err);
 	} else {
-		irq_set_affinity(mct_irqs[MCT_L0_IRQ], cpumask_of(0));
+		for_each_present_cpu(cpu) {
+			evt = per_cpu_ptr(&percpu_mct_tick, cpu);
+			if (request_irq(mct_irqs[MCT_L0_IRQ + cpu],
+					exynos4_mct_tick_isr,
+					IRQF_TIMER | IRQF_NOBALANCING,
+					"MCT", evt))
+				pr_err("exynos-mct: cannot register IRQ\n");
+			disable_irq(mct_irqs[MCT_L0_IRQ + cpu]);
+		}
 	}
 
 	err = register_cpu_notifier(&exynos4_mct_cpu_nb);

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project

