Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761288Ab3LIPaT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 10:30:19 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:48537 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755811Ab3LIPaQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 10:30:16 -0500
Message-ID: <52A5E135.2020500@linux.vnet.ibm.com>
Date: Mon, 09 Dec 2013 20:56:45 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Alex Shi <alex.shi@linaro.org>
CC: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "len.brown@intel.com" <len.brown@intel.com>
Subject: Re: questions of cpuidle
References: <52A5C846.30308@linaro.org>
In-Reply-To: <52A5C846.30308@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13120915-5806-0000-0000-0000239ED8F0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex,

On 12/09/2013 07:10 PM, Alex Shi wrote:
> 
> Sorry for a idiot of cpuidle.
> 
> I just find few cpu set TIMER_STOP on cpuidle, like omap4 and big.Little
> driver. Does that mean other ARM cpu or x86 cpu can get the timer
> interrupt in cpuidle?

There could be. Its only in some architectures and certain processors in
them that in a deep idle state(note that this happens only in a *deep*
idle state, *not* every idle state), the local timers stop as a side
effect and hence the CPUs can't get timer interrupts.

> 
> If the timer stopped during cpuidle, does that means at least one cpu
> cann't get into deep c-state since system need a cpu to wake up other
> deep c-state cpu? Or sth I missed?

Every CPU can get into a deep idle state since its possible to wake them
up using external interrupts. These CPUs do not necessarily need an IPI
to wake them up, any external interrupt will do. But for convenience,
instead of waking them all up using some external timer, we wake up only
one CPU or a few CPUs using an external timer and these CPUs inturn send
IPIs to the other CPUs in deep idle state since IPIs are a more
convenient way of sending interrupts to CPUs.

That is precisely the use of the broadcast timer. *Every* CPU can go
into deep idle state since they can be woken up by any external
interrupt, In case of architectures where there is an external clock
device, this external timer interrupt wakes up one CPU and it sends IPIs
to the other CPUs.

> 
> If the cpu stopped the interrupt during deep c-state and without
> monitor/mwait support, which kind of ipi can wake the cpu? I mean like a
> x86 cpu, APIC stopped in c3 mode, but actually ipi send via apic bus. So
> I don't know which ipi work?
> 

As far as my understanding goes, an external interrupt sent via the apic
bus wakes up a core in deep idle state first, meaning powers on the core
and hence the local apic. It does not yet acknowledge the interrupt,
meaning it cannot invoke the interrupt handler immediately.
   After the core goes through some initialization steps after wakeup,
it will be in a position to acknowledge the external interrupt and
service it accordingly.

Ideally the interrupt handler of this external interrupt should be that
of the local timer itself since it was meant to act on the behalf of the
local timer interrupt.

Thanks

Regards
Preeti U Murthy

