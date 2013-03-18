Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753627Ab3CRSNS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 14:13:18 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:33941 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894Ab3CRSNQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 14:13:16 -0400
Date: Mon, 18 Mar 2013 13:13:10 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH] nohz1: Documentation
To: paulmck@linux.vnet.ibm.com
Cc: fweisbec@gmail.com, linux-kernel@vger.kernel.org, josh@joshtriplett.org,
        rostedt@goodmis.org, zhong@linux.vnet.ibm.com, khilman@linaro.org,
        geoff@infradead.org, tglx@linutronix.de
References: <20130318162942.GA9359@linux.vnet.ibm.com>
In-Reply-To: <20130318162942.GA9359@linux.vnet.ibm.com> (from
	paulmck@linux.vnet.ibm.com on Mon Mar 18 11:29:42 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1363630390.15703.31@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/2013 11:29:42 AM, Paul E. McKenney wrote:
> First attempt at documentation for adaptive ticks.
> 
> Thoughts?
> 
> 							Thanx, Paul

It's really long and repetitive? And really seems like it's kconfig
help text?

   The CONFIG_NO_HZ=y and CONFIG_NO_HZ_FULL=y options cause the kernel
   to (respectively) avoid sending scheduling-clock interrupts to idle
   processors, or to processors with only a single single runnable task.
   You can disable this at boot time with kernel parameter "nohz=off".

   This reduces power consumption by allowing processors to suspend more
   deeply for longer periods, and can also improve some computationally
   intensive workloads. The downside is coming out of a deeper sleep can
   reduce realtime response to wakeup events.

   This is split into two config options because the second isn't quite
   finished and won't reliably deliver posix timer interrupts, perf
   events, or do as well on CPU load balancing. The  
CONFIG_RCU_FAST_NO_HZ
   option enables a workaround to force tick delivery every 4 jiffies to
   handle RCU events. See the CONFIG_RCU_NOCB_CPU option for a different
   workaround.

> +1.	It increases the number of instructions executed on the path
> +	to and from the idle loop.

This detail didn't get mentioned in my summary.

> +5.	The LB_BIAS scheduler feature is disabled by adaptive ticks.

I have no idea what that one is, my summary didn't mention it.

> +Another approach is to offload RCU callback processing to "rcuo"  
> kthreads
> +using the CONFIG_RCU_NOCB_CPU=y.  The specific CPUs to offload may be
> +selected via several methods:
> +
> +1.	The "rcu_nocbs=" kernel boot parameter, which takes a  
> comma-separated
> +	list of CPUs and CPU ranges, for example, "1,3-5" selects CPUs  
> 1,
> +	3, 4, and 5.
> +
> +2.	The RCU_NOCB_CPU_ZERO=y Kconfig option, which causes CPU 0 to
> +	be offloaded.  This is the build-time equivalent of  
> "rcu_nocbs=0".
> +
> +3.	The RCU_NOCB_CPU_ALL=y Kconfig option, which causes all CPUs
> +	to be offloaded.  On a 16-CPU system, this is equivalent to
> +	"rcu_nocbs=0-15".
> +
> +The offloaded CPUs never have RCU callbacks queued, and therefore RCU
> +never prevents offloaded CPUs from entering either dyntick-idle mode  
> or
> +adaptive-tick mode.  That said, note that it is up to userspace to
> +pin the "rcuo" kthreads to specific CPUs if desired.  Otherwise, the
> +scheduler will decide where to run them, which might or might not be
> +where you want them to run.

Ok, this whole chunk was just confusing and I glossed it. Why on earth  
do
you offer three wildly different ways to do the same thing? (You have  
config
options to set defaults?) I _think_ the gloss is just:

   RCU_NOCB_CPU_ALL=y moves each processor's RCU callback handling into
   its own kernel thread, which the user can pin to specific CPUs if
   desired. If you only want to move specific processors' RCU handling
   to threads, list those processors on the kernel command line ala
   "rcu_nocbs=1,3-5".

But that's a guess.

> +o	Additional configuration is required to deal with other sources
> +	of OS jitter, including interrupts and system-utility tasks
> +	and processes.
> +
> +o	Some sources of OS jitter can currently be eliminated only by
> +	constraining the workload.  For example, the only way to  
> eliminate
> +	OS jitter due to global TLB shootdowns is to avoid the unmapping
> +	operations (such as kernel module unload operations) that result
> +	in these shootdowns.  For another example, page faults and TLB
> +	misses can be reduced (and in some cases eliminated) by using
> +	huge pages and by constraining the amount of memory used by the
> +	application.

If you want to write a doc on reducing system jitter, go for it. This is
a topic transition near the end of a document.

> +o	At least one CPU must keep the scheduling-clock interrupt going
> +	in order to support accurate timekeeping.

How? You never said how to tell a processor _not_ to suppress interrupts
when CONFIG_THE_OTHER_HALF_OF_NOHZ is enabled.

I take it the problem is the value in the sysenter page won't get  
updated,
so gettimeofday() will see a stale value until the CPU hog stops
suppressing interrupts? I thought the first half of NOHZ had a way of
dealing with that many moons ago? (Did sysenter cause a regression?)

Rob