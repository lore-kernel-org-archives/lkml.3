Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340AbaE0Su7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 14:50:59 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:57672 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbaE0Su5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 14:50:57 -0400
Message-ID: <5384DE8F.7080102@mvista.com>
Date: Tue, 27 May 2014 13:50:55 -0500
From: Corey Minyard <cminyard@mvista.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-arm-kernel@lists.infradead.org, minyard@acm.org,
        linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm: Set hardirq tracing to on when idling
References: <1401045323-7116-1-git-send-email-minyard@acm.org> <4559339.apo3Fd10HK@wuerfel> <53849167.1000309@mvista.com> <201405271816.11998.arnd@arndb.de>
In-Reply-To: <201405271816.11998.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27/2014 11:16 AM, Arnd Bergmann wrote:
> On Tuesday 27 May 2014, Corey Minyard wrote:
>> On 05/26/2014 04:26 AM, Arnd Bergmann wrote:
>>> On Sunday 25 May 2014 14:15:23 minyard@acm.org wrote:
>>>> From: Corey Minyard <cminyard@mvista.com>
>>>>
>>>> The CPU will go to idle with interrupts off, but the interrupts
>>>> will wake up the idle.  This was causing very long irqsoff trace
>>>> values because, basically, the whole idle time was traces with
>>>> irqs off, even though they weren't really off.  Rework the idle
>>>> code to turn hardirq tracing to on befor calling idle.
>>>>
>>>> Signed-off-by: Corey Minyard <cminyard@mvista.com>
>>>> ---
>>>>  arch/arm/kernel/process.c | 3 ++-
>>>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>>>
>>>> I'm not sure this is correct for all ARM boards, but it fixes the
>>>> issue for the Vexpress board I have.  No more 4 second irqsoff
>>>> times.
>>> If this patch is correct for ARM, I wonder if it should be done
>>> in architecture independent code instead. Do you see the same
>>> thing on x86? If not, do you know what's different?
>> MIPS doesn't idle with IRQs disabled.
> Looking at the mips code, I see a couple of variants of the idle function:
>
> * r3081_wait(), r39xx_wait(), and rm7k_wait_irqoff() correctly sleep
>   before enabling the IRQs
>
> * r4k_wait first enables the IRQs and then waits, while a second
>   r4k_wait_irqoff() variant does the opposite, and a comment
>   explains that the first is wrong but the second may be broken
>   on some implementations.
>
> * can't tell what au1k_wait() does, but it also seems to sleep first.

Yes, it seems so.  The system I have uses the r4k variant that has to
enable interrupts first.  That would seem to me to lead to other issues,
but neither my testers nor I have seen any problems.  All the RT
scheduling tests we have come back clean on MIPS.

>
>> x86 calls trace_cpu_idle_rcuidle, but it doesn't re-enable interrupts at
>> the end of the idle routine.  Adding those trace calls to ARM doesn't
>> seem to make any difference, though.
> trace_cpu_idle_rcuidle() is unrelated, I also checked that.
>
> The comment in x86 arch_safe_halt() says "Used in the idle loop; sti
> takes one instruction cycle" and the implementation is "sti; hlt",
> where "sti" enables the interrupts at the same time as "hlt"
> puts the cpu in low-power mode.
>
> I don't understand what happens when ACPI is used, but I would
> it also ends up calling mwait or hlt with IRQs off. Can you try
> booting an x86 machine with acpi=off?

I can't get my system to boot with acpi=off.  It crashes setting up the
IOAPIC.  This is current 3.10 stable with the RT patch applied.

But I obviously don't see the issue on x86 with acpi on.

>>> It seems like the right thing to do, I just don't understand
>>> why nobody hit this before.
>> Yeah, I'm a little confused by that, too.  The RT guys use ARM
>> extensively, why haven't they seen this?  Of course, if you run your RT
>> tests under heavy load, you won't see this since you will never go idle.
> How exactly do you see this manifest? If it's clear that the
> trace comes from the idle function, maybe everybody just ignores it?

It is clear that the trace comes from the idle function, but it will
quickly mask any other real irqsoff problem.

-corey
