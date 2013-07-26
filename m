Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757890Ab3GZCnN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 22:43:13 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:44105 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756859Ab3GZCnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 22:43:11 -0400
Message-ID: <51F1E15B.3050106@linux.vnet.ibm.com>
Date: Fri, 26 Jul 2013 08:09:23 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: rjw@sisk.pl, shangw@linux.vnet.ibm.com, arnd@arndb.de,
        linux-pm@vger.kernel.org, geoff@infradead.org, rostedt@goodmis.org,
        deepthi@linux.vnet.ibm.com, paul.gortmaker@windriver.com,
        paulus@samba.org, srivatsa.bhat@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, john.stultz@linaro.org, tglx@linutronix.de,
        paulmck@linux.vnet.ibm.com, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, chenhui.zhao@freescale.com
Subject: Re: [RFC PATCH 4/5] cpuidle/ppc: CPU goes tickless if there are no
 arch-specific constraints
References: <20130725090016.12500.28888.stgit@preeti.in.ibm.com> <20130725090302.12500.42998.stgit@preeti.in.ibm.com> <20130725133044.GA7400@somewhere>
In-Reply-To: <20130725133044.GA7400@somewhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072602-5140-0000-0000-000003947005
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frederic,

On 07/25/2013 07:00 PM, Frederic Weisbecker wrote:
> On Thu, Jul 25, 2013 at 02:33:02PM +0530, Preeti U Murthy wrote:
>> In the current design of timer offload framework, the broadcast cpu should
>> *not* go into tickless idle so as to avoid missed wakeups on CPUs in deep idle states.
>>
>> Since we prevent the CPUs entering deep idle states from programming the lapic of the
>> broadcast cpu for their respective next local events for reasons mentioned in
>> PATCH[3/5], the broadcast CPU checks if there are any CPUs to be woken up during
>> each of its timer interrupt programmed to its local events.
>>
>> With tickless idle, the broadcast CPU might not get a timer interrupt till after
>> many ticks which can result in missed wakeups on CPUs in deep idle states. By
>> disabling tickless idle, worst case, the tick_sched hrtimer will trigger a
>> timer interrupt every period to check for broadcast.
>>
>> However the current setup of tickless idle does not let us make the choice
>> of tickless on individual cpus. NOHZ_MODE_INACTIVE which disables tickless idle,
>> is a system wide setting. Hence resort to an arch specific call to check if a cpu
>> can go into tickless idle.
> 
> Hi Preeti,
> 
> I'm not exactly sure why you can't enter the broadcast CPU in dynticks idle mode.
> I read in the previous patch that's because in dynticks idle mode the broadcast
> CPU deactivates its lapic so it doesn't receive the IPI. But may be I misunderstood.
> Anyway that's not good for powersaving.

Let me elaborate. The CPUs in deep idle states have their lapics
deactivated. This means the next timer event which would typically have
been taken care of by a lapic firing at the appropriate moment does not
get taken care of in deep idle states, due to the lapic being switched off.

Hence such CPUs offload their next timer event to the broadcast CPU,
which should *not* enter deep idle states. The broadcast CPU has the
responsibility of waking the CPUs in deep idle states.

*The lapic of a broadcast CPU is active always*. Say CPUX, wants the
broadcast CPU to wake it up at timeX.  Since we cannot program the lapic
of a remote CPU, CPUX will need to send an IPI to the broadcast CPU,
asking it to program its lapic to fire at timeX so as to wake up CPUX.
*With multiple CPUs the overhead of sending IPI, could result in
performance bottlenecks and may not scale well.*

Hence the workaround is that the broadcast CPU on each of its timer
interrupt checks if any of the next timer event of a CPU in deep idle
state has expired, which can very well be found from dev->next_event of
that CPU. For example the timeX that has been mentioned above has
expired. If so the broadcast handler is called to send an IPI to the
idling CPU to wake it up.

*If the broadcast CPU, is in tickless idle, its timer interrupt could be
many ticks away. It could miss waking up a CPU in deep idle*, if its
wakeup is much before this timer interrupt of the broadcast CPU. But
without tickless idle, atleast at each period we are assured of a timer
interrupt. At which time broadcast handling is done as stated in the
previous paragraph and we will not miss wakeup of CPUs in deep idle states.

Yeah it is true that not allowing the broadcast CPU to enter tickless
idle is bad for power savings, but for the use case that we are aiming
at in this patch series, the current approach seems to be the best, with
minimal trade-offs in performance, power savings, scalability and no
change in the broadcast framework that exists today in the kernel.

> 
> Also when an arch wants to prevent a CPU from entering dynticks idle mode, it typically
> use arch_needs_cpu(). May be that could fit for you as well?

Oh ok thanks :) I will look into this and get back on if we can use it.

Regards
Preeti U Murthy

