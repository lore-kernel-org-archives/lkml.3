Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205AbaE0WVm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 18:21:42 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:53001 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544AbaE0WVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 18:21:41 -0400
Message-ID: <53850FF3.8050107@codeaurora.org>
Date: Tue, 27 May 2014 15:21:39 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Arnd Bergmann <arnd@arndb.de>, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Corey Minyard <cminyard@mvista.com>,
        Stanislav Meduna <stano@meduna.org>
Subject: Re: [PATCH v2] tracing: Don't account for cpu idle time with irqsoff
 tracers
References: <1401221284-13678-1-git-send-email-sboyd@codeaurora.org> <17051981.niWmA6MIgX@wuerfel> <20140527174847.7b405b5c@gandalf.local.home>
In-Reply-To: <20140527174847.7b405b5c@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27/14 14:48, Steven Rostedt wrote:
> On Tue, 27 May 2014 22:11:25 +0200
> Arnd Bergmann <arnd@arndb.de> wrote:
>
>> On Tuesday 27 May 2014 13:08:04 Stephen Boyd wrote:
>>> @@ -380,7 +382,7 @@ start_critical_timing(unsigned long ip, unsigned long parent_ip)
>>>  
>>>         cpu = raw_smp_processor_id();
>>>  
>>> -       if (per_cpu(tracing_cpu, cpu))
>>> +       if (per_cpu(timings_stopped, cpu) || per_cpu(tracing_cpu, cpu))
>>>                 return;
>>>  
>>>         data = per_cpu_ptr(tr->trace_buffer.data, cpu);
>>>
>> Where exactly do you see other code calling here while
>> per_cpu(timings_stopped) is set? Would it be possible to just
>> change that call site?
> Arnd brings up a good point. 

Hrm.. still not getting Arnd's mails.

> If we disable irqs off tracing completely,
> we may be missing places in the idle path that disable interrupts for
> long periods of time. We may want to move the stop down further.
>
> The way it works (IIRC), and why tracing can start again is that it can
> nest. Perhaps we need to stop it further down if we can't move it
> completely.
>

I'm not sure how much deeper it can go and I'm afraid it will become a
game of whack-a-mole. I already see two places that disable and reenable
irqs after stop_critical_timings() is called (first in rcu_idle_enter()
and second in clockevents_notify()). Should rcu_idle_enter() move to
raw_local_irq_save()? It looks like that path calls rcu_sched_qs() and
on tiny RCU that again needs the raw_ treatement. We can probably call
stop_critical_timings() after rcu_idle_enter() to fix this.

What about clockevents_notify? __raw_spin_lock_irqsave() should probably
use raw_local_irqsave().

If we go the raw route, do we even need stop/start_critical_timings()?
Can't we just use raw accessors in the idle paths
(tick_nohz_idle_{enter,exit}(), cpuidle_enter(), etc.) and get rid of
the stop/start stuff completely? I admit this patch is pretty much a big
sledge hammer that tries to make things simple, but if there is some
benefit to the raw accessors I'm willing to send patches to fix all the
call sites.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

