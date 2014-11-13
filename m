Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933AbaKMHXA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 02:23:00 -0500
Received: from mail-ob0-f176.google.com ([209.85.214.176]:51334 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923AbaKMHW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 02:22:58 -0500
MIME-Version: 1.0
In-Reply-To: <CAKohpompt7Gizq2GRVsCkoGvsZxKzBM_FWjzGaNjkdSu=aM__Q@mail.gmail.com>
References: <alpine.DEB.2.11.1411011646280.7732@gentwo.org>
	<alpine.DEB.2.11.1411012313320.5308@nanos>
	<alpine.DEB.2.11.1411061057470.5591@gentwo.org>
	<CAKohpokE8pQUwTuMbnooAd3TsTgmrQWP4RtoJdwhJ5zps+O2zA@mail.gmail.com>
	<20141110153147.GK4901@linux.vnet.ibm.com>
	<alpine.DEB.2.11.1411101226310.12918@gentwo.org>
	<20141111171526.GC3216@lerouge>
	<CAKohpok3U_8zQurs219fOmwERFrnZ0sOE-YUc7B+fKYfFLmEpg@mail.gmail.com>
	<20141112135455.GA6895@lerouge>
	<CAKohpo=U7K==YMytwcGwteTXdf1RFdxo8BoDhfR-9AriL83D8Q@mail.gmail.com>
	<20141112150651.GF21343@twins.programming.kicks-ass.net>
	<CAKohpompt7Gizq2GRVsCkoGvsZxKzBM_FWjzGaNjkdSu=aM__Q@mail.gmail.com>
Date: Thu, 13 Nov 2014 12:52:57 +0530
Message-ID: <CAKohpok3fd7OurdcUBJS1su+iaqE04tWqao0TZ4Lb0-C4hi2_Q@mail.gmail.com>
Subject: Re: Future of NOHZ full/isolation development (was Re: [NOHZ] Remove scheduler_tick_max_deferment)
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Christoph Lameter <cl@linux.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>, Tejun Heo <tj@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Mike Frysinger <vapier@gentoo.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Hakan Akkan <hakanakkan@gmail.com>,
        Max Krasnyansky <maxk@qti.qualcomm.com>,
        Hugh Dickins <hughd@google.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Kevin Hilman <khilman@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 November 2014 20:46, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 12 November 2014 20:36, Peter Zijlstra <peterz@infradead.org> wrote:
>> I don't think you need to add anything. We already have tracepoints for
>> every single interrupt (and therefore also for the hrtimer one) and we
>> have expiry tracepoints.
>
> I will crosscheck this again but as far as I remember these spurious interrupts
> aren't caught with tracers currently. Not even the irq_enter/exit ones.

So yes, we do get irq_handler_entry/exit traces for the clockevent device.

The problem here is that people miss these as there are no warnings issued
here. And so nobody tried to resolve these spurious interrupts.

This is how it looks on a ARM machine (With trace_hrtimer_spurious), though
it is relevant for all architectures which emulate ONESHOT mode over
PERIODIC mode:

          <idle>-0     [001] d.h2   719.642085: irq_handler_entry:
irq=30 name=arch_timer
          <idle>-0     [001] d.h3   719.646506: hrtimer_spurious: count:105
          <idle>-0     [001] d.h2   719.646511: irq_handler_exit:
irq=30 ret=handled
          <idle>-0     [001] d..3   719.646522: hrtimer_start:
hrtimer=ee7bb740 function=tick_sched_timer expires=719640000000
softexpires=719640000000
          <idle>-0     [001] d..3   719.646545: hrtimer_cancel: hrtimer=ee7bb740
          <idle>-0     [001] d.h2   719.647086: irq_handler_entry:
irq=30 name=arch_timer
          <idle>-0     [001] d.h3   719.651540: hrtimer_spurious: count:106
          <idle>-0     [001] d.h2   719.651545: irq_handler_exit:
irq=30 ret=handled
          <idle>-0     [001] d..3   719.651554: hrtimer_start:
hrtimer=ee7bb740 function=tick_sched_timer expires=719645000000
softexpires=719645000000
          <idle>-0     [001] d..3   719.651576: hrtimer_cancel: hrtimer=ee7bb740
          <idle>-0     [001] d.h2   719.652084: irq_handler_entry:
irq=30 name=arch_timer
          <idle>-0     [001] d.h3   719.656571: hrtimer_spurious: count:107
          <idle>-0     [001] d.h2   719.656575: irq_handler_exit:
irq=30 ret=handled
          <idle>-0     [001] d..3   719.656583: hrtimer_start:
hrtimer=ee7bb740 function=tick_sched_timer expires=719650000000
softexpires=719650000000
          <idle>-0     [001] d..3   719.656601: hrtimer_cancel: hrtimer=ee7bb740
          <idle>-0     [001] d.h2   719.657084: irq_handler_entry:
irq=30 name=arch_timer
          <idle>-0     [001] d.h3   719.661611: hrtimer_spurious: count:108
          <idle>-0     [001] d.h2   719.661616: irq_handler_exit:
irq=30 ret=handled
          <idle>-0     [001] d..3   719.661627: hrtimer_start:
hrtimer=ee7bb740 function=tick_sched_timer expires=719655000000
softexpires=719655000000
          <idle>-0     [001] d..3   719.661652: hrtimer_cancel: hrtimer=ee7bb740
          <idle>-0     [001] d.h2   719.662086: irq_handler_entry:
irq=30 name=arch_timer
          <idle>-0     [001] d.h3   719.666643: hrtimer_spurious: count:109
          <idle>-0     [001] d.h2   719.666648: irq_handler_exit:
irq=30 ret=handled
          <idle>-0     [001] d..3   719.666657: hrtimer_start:
hrtimer=ee7bb740 function=tick_sched_timer expires=719660000000
softexpires=719660000000
          <idle>-0     [001] d..3   719.666680: hrtimer_cancel: hrtimer=ee7bb740
          <idle>-0     [001] d.h2   719.667084: irq_handler_entry:
irq=30 name=arch_timer
          <idle>-0     [001] d.h3   719.671678: hrtimer_spurious: count:110
          <idle>-0     [001] d.h2   719.671682: irq_handler_exit:
irq=30 ret=handled
          <idle>-0     [001] d..3   719.671693: hrtimer_start:
hrtimer=ee7bb740 function=tick_sched_timer expires=719665000000
softexpires=719665000000
          <idle>-0     [001] d..3   719.671714: hrtimer_cancel: hrtimer=ee7bb740
          <idle>-0     [001] d.h2   719.672085: irq_handler_entry:
irq=30 name=arch_timer
          <idle>-0     [001] d.h3   719.676712: hrtimer_spurious: count:111
          <idle>-0     [001] d.h2   719.676717: irq_handler_exit:
irq=30 ret=handled
          <idle>-0     [001] d..3   719.676726: hrtimer_start:
hrtimer=ee7bb740 function=tick_sched_timer expires=719670000000
softexpires=719670000000
          <idle>-0     [001] d..3   719.676749: hrtimer_cancel: hrtimer=ee7bb740
          <idle>-0     [001] d.h2   719.677087: irq_handler_entry:
irq=30 name=arch_timer
          <idle>-0     [001] d.h3   719.681745: hrtimer_spurious: count:112
          <idle>-0     [001] d.h2   719.681750: irq_handler_exit:
irq=30 ret=handled
          <idle>-0     [001] d..3   719.681759: hrtimer_start:
hrtimer=ee7bb740 function=tick_sched_timer expires=719675000000
softexpires=719675000000
          <idle>-0     [001] d..3   719.681780: hrtimer_cancel: hrtimer=ee7bb740
          <idle>-0     [001] d.h2   719.682084: irq_handler_entry:
irq=30 name=arch_timer
          <idle>-0     [001] d.h3   719.686783: hrtimer_spurious: count:113
          <idle>-0     [001] d.h2   719.686787: irq_handler_exit:
irq=30 ret=handled
          <idle>-0     [001] d..3   719.686797: hrtimer_start:
hrtimer=ee7bb740 function=tick_sched_timer expires=719680000000
softexpires=719680000000
          <idle>-0     [001] d..3   719.686819: hrtimer_cancel: hrtimer=ee7bb740


Normally this happens on a non-spurious interrupt:

 is-cpu-isolated-1963  [000] d.h1   719.642080: irq_handler_entry:
irq=30 name=arch_timer
 is-cpu-isolated-1963  [000] d.h2   719.642086: hrtimer_cancel: hrtimer=ee7b3740
 is-cpu-isolated-1963  [000] d.h1   719.642089: hrtimer_expire_entry:
hrtimer=ee7b3740 function=tick_sched_timer now=719635008926
 is-cpu-isolated-1963  [000] d.h1   719.642095: softirq_raise: vec=1
[action=TIMER]
 is-cpu-isolated-1963  [000] d.h1   719.642099: softirq_raise: vec=9
[action=RCU]
 is-cpu-isolated-1963  [000] d.h2   719.642104: sched_stat_runtime:
comm=trace-isolation pid=1963 runtime=348042 [ns] vruntime=7804506025
[ns]
 is-cpu-isolated-1963  [000] d.h1   719.642111: hrtimer_expire_exit:
hrtimer=ee7b3740
 is-cpu-isolated-1963  [000] d.h2   719.642115: hrtimer_start:
hrtimer=ee7b3740 function=tick_sched_timer expires=719640000000
softexpires=719640000000
 is-cpu-isolated-1963  [000] d.h1   719.642121: irq_handler_exit:
irq=30 ret=handled

.. followed by softirq processing.

Another trace point with trace_hrtimer_spurious() might end up being useful :)
