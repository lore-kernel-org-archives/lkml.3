Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190AbaE0QQW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 12:16:22 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:60777 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648AbaE0QQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 12:16:19 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Corey Minyard <cminyard@mvista.com>
Subject: Re: [PATCH] arm: Set hardirq tracing to on when idling
Date: Tue, 27 May 2014 18:16:11 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, minyard@acm.org,
        linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1401045323-7116-1-git-send-email-minyard@acm.org> <4559339.apo3Fd10HK@wuerfel> <53849167.1000309@mvista.com>
In-Reply-To: <53849167.1000309@mvista.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201405271816.11998.arnd@arndb.de>
X-Provags-ID: V02:K0:1Aoa8fRdVcyl6jEF5Kz0XcfAsw0B915yS9bqpuMhrtr
 1D4QQQYhNVcHX8bCp7LkVyaVknjhakN73hEe9MF+WIGuCddLSc
 Am+4Kjz+KxagaYIqhvJZp1sCCWKLoMAEUYwWuCP8CI0UYo3o+O
 cOqhGgIClhVvN7byE8vvQM6TxFX2FjOvZXJ3Un1pmLFmXzmxXK
 Pu5Wu7pty0dw8p/4v041d0lIYCh/ImricHwuvOPUX7tuB7O7L/
 7PoobOhsbaG6ma7Mbz6+6dEt3jaNRblrsv9IeGTNySYZOXwTQ8
 2QzXmxJNEsGeG1LGV6G3duINx//f7cAHcBIkZghnShnVePfg1i
 IjBMUwdzcNyKbsmjDb9o=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 May 2014, Corey Minyard wrote:
> On 05/26/2014 04:26 AM, Arnd Bergmann wrote:
> > On Sunday 25 May 2014 14:15:23 minyard@acm.org wrote:
> >> From: Corey Minyard <cminyard@mvista.com>
> >>
> >> The CPU will go to idle with interrupts off, but the interrupts
> >> will wake up the idle.  This was causing very long irqsoff trace
> >> values because, basically, the whole idle time was traces with
> >> irqs off, even though they weren't really off.  Rework the idle
> >> code to turn hardirq tracing to on befor calling idle.
> >>
> >> Signed-off-by: Corey Minyard <cminyard@mvista.com>
> >> ---
> >>  arch/arm/kernel/process.c | 3 ++-
> >>  1 file changed, 2 insertions(+), 1 deletion(-)
> >>
> >> I'm not sure this is correct for all ARM boards, but it fixes the
> >> issue for the Vexpress board I have.  No more 4 second irqsoff
> >> times.
> > If this patch is correct for ARM, I wonder if it should be done
> > in architecture independent code instead. Do you see the same
> > thing on x86? If not, do you know what's different?
> 
> MIPS doesn't idle with IRQs disabled.

Looking at the mips code, I see a couple of variants of the idle function:

* r3081_wait(), r39xx_wait(), and rm7k_wait_irqoff() correctly sleep
  before enabling the IRQs

* r4k_wait first enables the IRQs and then waits, while a second
  r4k_wait_irqoff() variant does the opposite, and a comment
  explains that the first is wrong but the second may be broken
  on some implementations.

* can't tell what au1k_wait() does, but it also seems to sleep first.

> x86 calls trace_cpu_idle_rcuidle, but it doesn't re-enable interrupts at
> the end of the idle routine.  Adding those trace calls to ARM doesn't
> seem to make any difference, though.

trace_cpu_idle_rcuidle() is unrelated, I also checked that.

The comment in x86 arch_safe_halt() says "Used in the idle loop; sti
takes one instruction cycle" and the implementation is "sti; hlt",
where "sti" enables the interrupts at the same time as "hlt"
puts the cpu in low-power mode.

I don't understand what happens when ACPI is used, but I would
it also ends up calling mwait or hlt with IRQs off. Can you try
booting an x86 machine with acpi=off?

> > It seems like the right thing to do, I just don't understand
> > why nobody hit this before.
> 
> Yeah, I'm a little confused by that, too.  The RT guys use ARM
> extensively, why haven't they seen this?  Of course, if you run your RT
> tests under heavy load, you won't see this since you will never go idle.

How exactly do you see this manifest? If it's clear that the
trace comes from the idle function, maybe everybody just ignores it?

	Arnd
