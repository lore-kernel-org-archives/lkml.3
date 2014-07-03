Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376AbaGCN7Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 09:59:24 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:38882 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751937AbaGCN7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 09:59:23 -0400
Date: Thu, 3 Jul 2014 09:59:22 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        =?UTF-8?B?RnLDqWTDqXJpYw==?= Weisbecker <fweisbec@gmail.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linaro Networking <linaro-networking@linaro.org>,
        Kevin Hilman <khilman@linaro.org>
Subject: Re: [Query/tick] Are we enqueing 'tick-sched' hrtimers in past ?
Message-ID: <20140703095922.14c70ab1@gandalf.local.home>
In-Reply-To: <CAKohpomvG-jEhMow=g5-nOAW7aBGBAfMjwRocOMU3rMfK9VTgA@mail.gmail.com>
References: <CAKohpomvG-jEhMow=g5-nOAW7aBGBAfMjwRocOMU3rMfK9VTgA@mail.gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Jul 2014 18:59:31 +0530
Viresh Kumar <viresh.kumar@linaro.org> wrote:

> Hi Thomas et al,
> 
> I was analyzing few traces with 'trace-cmd' and realized that timings
> weren't matching properly. For example consider this trace:
> 
> 1            cat-1867  [000] d.h1   149.750891: hrtimer_expire_entry:
> hrtimer=ee7b3740 function=tick_sched_timer now=149740008694
> 2            cat-1867  [000] d.h1   149.750900: softirq_raise: vec=1
> [action=TIMER]
> 3            cat-1867  [000] d.h1   149.750905: softirq_raise: vec=9
> [action=RCU]
> 4            cat-1867  [000] d.h2   149.750910: sched_stat_runtime:
> comm=cat pid=1867 runtime=1463250 [ns] vruntime=4777557704 [ns]
> 5            cat-1867  [000] d.h1   149.750914: softirq_raise: vec=7
> [action=SCHED]
> 6            cat-1867  [000] d.h1   149.750919: hrtimer_expire_exit:
> hrtimer=ee7b3740
> 7            cat-1867  [000] d.h2   149.750922: hrtimer_start:
> hrtimer=ee7b3740 function=tick_sched_timer expires=149745000000
> softexpires=149745000000
> 
> Line 1: now=149.740008694 and trace-time: 149.750891. diff 10ms (consistently)
> Line 7: trace-time: 149.750922 and expires: 149.745000000, diff 5ms
> 
> 
> So, either there is a mismatch of trace-times and required to be
> fixed? (@Steven)

Unless you changed clocks, the default timing of the trace is done by
trace_clock_local() which basically just calls sched_clock(). Not much
to be fixed there.

I would be interested in seeing another hrtimer_expire_entry to see if
that is off by anything else other than 10ms. As that event is the only
one shown to show what hrtimer thinks "now" is.

Also, I'm not really seeing what is wrong with the above. The
expire_entry means the timer is being triggered and it raised the
softirq. The hrtimer_start is a new setting to go off at 149.745. Since
you noticed that the trace time stamp is 10ms ahead, that would state
that the hrtimer would go off around trace timestamp 149.755.


The trace timer stamp uses a different clock than hrtimers does. Do not
confuse them as the same clock. The best you can do is reference
that "now" value to get the difference between the two and use that as a
reference for what the time stamp of the trace should be when the
hrtimer goes off again.

-- Steve
