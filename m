Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974AbaBGMlu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 07:41:50 -0500
Received: from merlin.infradead.org ([205.233.59.134]:47466 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777AbaBGMls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 07:41:48 -0500
Date: Fri, 7 Feb 2014 13:41:40 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 1/2] PPC: powernv: remove redundant cpuidle_idle_call()
Message-ID: <20140207124140.GB9987@twins.programming.kicks-ass.net>
References: <1391696188-14540-1-git-send-email-nicolas.pitre@linaro.org>
 <CAKnoXLxCAqKaniGOwegNcOarS4FpoNKDY5PxOhe6j4wdtUAkLQ@mail.gmail.com>
 <52F3BCFE.3010703@linux.vnet.ibm.com>
 <alpine.LFD.2.11.1402070105170.1906@knanqh.ubzr>
 <52F46EB3.5080403@linux.vnet.ibm.com>
 <alpine.LFD.2.11.1402071022490.1906@knanqh.ubzr>
 <52F4C666.4050308@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52F4C666.4050308@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 07, 2014 at 05:11:26PM +0530, Preeti U Murthy wrote:
> But observe the idle state "snooze" on powerpc. The power that this idle
> state saves is through the lowering of the thread priority of the CPU.
> After it lowers the thread priority, it is done. It cannot
> "wait_for_interrupts". It will exit my_idle(). It is now upto the
> generic idle loop to increase the thread priority if the need_resched
> flag is set. Only an interrupt routine can increase the thread priority.
> Else we will need to do it explicitly. And in such states which have a
> polling nature, the cpu will not receive a reschedule IPI.
> 
> That is why in the snooze_loop() we poll on need_resched. If it is set
> we up the priority of the thread using HMT_MEDIUM() and then exit the
> my_idle() loop. In case of interrupts, the priority gets automatically
> increased.

You can poll without setting TS_POLLING/TIF_POLLING_NRFLAGS just fine
and get the IPI if that is what you want.

Depending on how horribly unprovisioned the thread gets at the lowest
priority, that might actually be faster than polling and raising the
prio whenever it does get ran.
