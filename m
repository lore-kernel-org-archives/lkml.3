Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964789AbaGCRcC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 13:32:02 -0400
Received: from smtp06.smtpout.orange.fr ([80.12.242.128]:43246 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753712AbaGCRcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 13:32:00 -0400
X-ME-Helo: beldin
X-ME-Date: Thu, 03 Jul 2014 19:31:56 +0200
X-ME-IP: 90.38.42.162
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] clocksource: add device-tree support for PXA timer
References: <1403388588-11956-1-git-send-email-robert.jarzmik@free.fr>
	<1403388588-11956-2-git-send-email-robert.jarzmik@free.fr>
	<53B5470D.4070009@linaro.org>
X-URL: http://belgarath.falguerolles.org/
Date: Thu, 03 Jul 2014 19:31:52 +0200
In-Reply-To: <53B5470D.4070009@linaro.org> (Daniel Lezcano's message of "Thu,
	03 Jul 2014 14:05:33 +0200")
Message-ID: <87tx6ynybb.fsf@free.fr>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Lezcano <daniel.lezcano@linaro.org> writes:

>> -#include <mach/regs-ost.h>
>>   #include <mach/irqs.h>
>> +#include <mach/hardware.h>
>
> Now as the driver is in 'drivers', do not reference the headers files in
> mach. Moving the driver to the drivers directory implies some cleanup with the
> headers dependencies.
I don't see that very possible.
Or said another way, I don't see how the irq number, IRQ_OST0 (in mach/irqs.h)
can be guessed for non device-tree configuration.

>> +#define OSMR0		0x00	/* */
>> +#define OSMR1		0x04	/* */
>> +#define OSMR2		0x08	/* */
>> +#define OSMR3		0x0C	/* */
>> +#define OSMR4		0x80	/* */
>
> Can you please remove those unused empty comment or fill them with something
> appropriate.
Sure.

>
>> +#define OSCR		0x10	/* OS Timer Counter Register */
>> +#define OSCR4		0x40	/* OS Timer Counter Register */
>> +#define OMCR4		0xC0	/* */
>> +#define OSSR		0x14	/* OS Timer Status Register */
>> +#define OWER		0x18	/* OS Timer Watchdog Enable Register */
>> +#define OIER		0x1C	/* OS Timer Interrupt Enable Register */
>> +
>> +#define OSSR_M3		(1 << 3)	/* Match status channel 3 */
>> +#define OSSR_M2		(1 << 2)	/* Match status channel 2 */
>> +#define OSSR_M1		(1 << 1)	/* Match status channel 1 */
>> +#define OSSR_M0		(1 << 0)	/* Match status channel 0 */
>> +
>> +#define OWER_WME	(1 << 0)	/* Watchdog Match Enable */
>> +
>> +#define OIER_E3		(1 << 3)	/* Interrupt enable channel 3 */
>> +#define OIER_E2		(1 << 2)	/* Interrupt enable channel 2 */
>> +#define OIER_E1		(1 << 1)	/* Interrupt enable channel 1 */
>> +#define OIER_E0		(1 << 0)	/* Interrupt enable channel 0 */
>
> Is it possible to do some cleanups around regs-ost.h and here in order to remove
> the unused macros. Also, it seems some define will be duplicate as they are
> shared with the watchdog. Any plan to fix that ?
For the cleanup, yes, will do.

For the watchdog I don't have any plan yet. This patch's purpose is only to
bring the PXA time source to drivers/clocksource, and make it compatible with
both device-tree and non device-tree builds.

>> @@ -33,9 +60,14 @@
>>    * calls to sched_clock() which should always be the case in practice.
>>    */
>>
>> +#define timer_readl(reg) readl_relaxed(timer_base + (reg))
>> +#define timer_writel(val, reg) writel_relaxed((val), timer_base + (reg))
>> +
>> +static void __iomem *timer_base;
>> +
>>   static u64 notrace pxa_read_sched_clock(void)
>>   {
>> -	return readl_relaxed(OSCR);
>
> So here there is a change which is not explained in the changelog (timer_base
> offset).
>
> Even it is obvious for me because I am used to see this kind of code, that would
> deserve a better description in the changelog.
OK, I'll add the backward compatibility explanation with non device-tree builds,
and the necessary timer_base iomem hard encoded value. And the Janus double face
explanation of the driver (both DT and non-DT oriented).

Another question brought up by this : if I remove all 'mach/' includes, I loose
io_p2v() right ? How can I guess timer_base then ?

>> +	/* we are only interested in OS-timer0 irq */
>> +	irq = irq_of_parse_and_map(np, 0);
>> +	if (irq <= 0)
>> +		panic("%s: unable to parse OS-timer0 irq\n", np->name);
>
> Is the 'panic' desirable ? The clksrc-of is written in a way to use different
> clocks, no ?
Good question.

Maybe not, I followed the same rationale as in orion-timer, which is :
 - as this timer is the only possible timer for PXA boards, and because without
 it the kernel boot will stall (scheduling will be blocked), it's better to
 panic early that to remain stalled.

Isn't this a good approach ?

-- 
Robert
