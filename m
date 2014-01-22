Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736AbaAVIgI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 03:36:08 -0500
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:48908 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbaAVIgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 03:36:03 -0500
Message-ID: <52DF81B0.7020700@linux.vnet.ibm.com>
Date: Wed, 22 Jan 2014 14:00:40 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Paul Mackerras <paulus@samba.org>
CC: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Tejun Heo <tj@kernel.org>, Michel Lespinasse <walken@google.com>,
        ego@linux.vnet.ibm.com,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        Thomas Gleixner <tglx@linutronix.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: Deadlock between cpu_hotplug_begin and cpu_add_remove_lock
References: <20140122055239.GA29418@iris.ozlabs.ibm.com>
In-Reply-To: <20140122055239.GA29418@iris.ozlabs.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14012208-4790-0000-0000-00000C5921AA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On 01/22/2014 11:22 AM, Paul Mackerras wrote:
> This arises out of a report from a tester that offlining a CPU never
> finished on a system they were testing.  This was on a POWER8 running
> a 3.10.x kernel, but the issue is still present in mainline AFAICS.
> 
> What I found when I looked at the system was this:
> 
> * There was a ppc64_cpu process stuck inside cpu_hotplug_begin(),
>   called from _cpu_down(), from cpu_down().  This process was holding
>   the cpu_add_remove_lock mutex, since cpu_down() calls
>   cpu_maps_update_begin() before calling _cpu_down().  It was stuck
>   there because cpu_hotplug.refcount == 1.
> 
> * There was a mdadm process trying to acquire the cpu_add_remove_lock
>   mutex inside register_cpu_notifier(), called from
>   raid5_alloc_percpu() in drivers/md/raid5.c.  That process had
>   previously called get_online_cpus, which is why cpu_hotplug.refcount
>   was 1.
> 
> Result: deadlock.
> 
> Thus it seems that the following code is not safe:
> 
> 	get_online_cpus();
> 	register_cpu_notifier(&...);
> 	put_online_cpus();
>

Yes, this is a known problem, and I had proposed an elaborate solution
some time ago: https://lkml.org/lkml/2012/3/1/39
But that won't work for all cases, so that solution is a no-go.

If we forget the CPU_POST_DEAD stage for a moment, we can just replace the
calls to cpu_maps_update_begin/done() with get/put_online_cpus() in both
register_cpu_notifier() as well as unregister_cpu_notifier(). After all,
the callback registration code needs to synchronize only with the actual
hotplug operations, and not the update of cpu-maps. So they don't really
need to acquire the cpu_add_remove_lock.

However, CPU_POST_DEAD notifications run with the hotplug lock dropped.
So we can't simply replace cpu_add_remove_lock with hotplug lock in the
registration routines, because notifier invocations and notifier registration
needs to be synchronized.

Hmm...
 
> There are a few different places that do that sort of thing; besides
> drivers/md/raid5.c, there are instances in arch/x86/kernel/cpu,
> arch/x86/oprofile, drivers/cpufreq/acpi-cpufreq.c,
> drivers/oprofile/nmi_timer_int.c and kernel/trace/ring_buffer.c.
> 
> My question is this: is it reasonable to call register_cpu_notifier
> inside a get/put_online_cpus block?

Ideally, we would want that to work. Because there is no other race-free
way of registering a notifier.

>  If so, the deadlock needs to be
> fixed; if not, the callers need to be fixed, and the restriction
> should be documented.

Fixing the callers is a last resort. I'm thinking of ways to fix the
deadlock itself, and allow the callers to call register_cpu_notifier
within a get/put_online_cpus() block...

Regards,
Srivatsa S. Bhat


