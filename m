Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932589AbaLAQKk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 11:10:40 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:46072 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932538AbaLAQKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 11:10:37 -0500
Date: Mon, 1 Dec 2014 17:10:34 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Tony Luck <tony.luck@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Wu Fengguang <fengguang.wu@intel.com>, Ingo Molnar <mingo@kernel.org>,
        Rik van Riel <riel@redhat.com>
Subject: Re: [RFC PATCH 07/30] cputime: Convert kcpustat to nsecs
Message-ID: <20141201161031.GA27302@lerouge>
References: <1417199040-21044-1-git-send-email-fweisbec@gmail.com>
 <1417199040-21044-8-git-send-email-fweisbec@gmail.com>
 <20141201151402.31a6cc9a@mschwide>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141201151402.31a6cc9a@mschwide>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2014 at 03:14:02PM +0100, Martin Schwidefsky wrote:
> On Fri, 28 Nov 2014 19:23:37 +0100
> Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > Kernel cpu stats are stored in cputime_t which is an architecture
> > defined type, and hence a bit opaque and requiring accessors and mutators
> > for any operation.
> > 
> > Converting them to nsecs simplifies the code a little bit.
> 
> Quite honestly I do not see much of an improvement here, on set of
> functions (cputime_to_xxx) gets replaced by another (nsecs_to_xxx).

Well it's not just that. Irqtime accounting gets simplified (no more
temporary buffer getting flushed on tick), same goes for guest accounting.
cpufreq gets one less level of conversion. Some places also lost their cputime_t
accessors due to internal nsecs use.
Plus a few other simplifications here and there that I haven't yet finished
like VIRT_CPU_ACCOUNTING_GEN that won't need cputime_t accessors anymore.

Also once the patchset is complete, we should be able to remove a significant
part of cputime_t accessors and mutators if only archs use them for one or
two conversions (probably cputime_to_nsecs() alone would be enough). And there are
many implementations of cputime_t: jiffies, nsecs, powerpc and s390. Expect
the removal of jiffies and nsecs based cputime_t plus the largest part of powerpc
and s390 implementations.

> 
> On the contrary for s390 I see a degradation, consider a hunk like
> this:
> 
> > @@ -128,9 +128,9 @@ static inline u64 get_cpu_idle_time_jiffy(unsigned int cpu, u64 *wall)
> > 
> >  	idle_time = cur_wall_time - busy_time;
> >  	if (wall)
> > -		*wall = cputime_to_usecs(cur_wall_time);
> > +		*wall = div_u64(cur_wall_time, NSEC_PER_USEC);
> > 
> > -	return cputime_to_usecs(idle_time);
> > +	return div_u64(idle_time, NSEC_PER_USEC);
> >  }
> > 
> >  u64 get_cpu_idle_time(unsigned int cpu, u64 *wall, int io_busy)
> 
> For s390 cputime_to_usecs is a shift, with the new code we now have a division.
> Fortunately this is in a piece of code that s390 does not use..

Speaking about the degradation in s390:

s390 is really a special case. And it would be a shame if we prevent from a
real core cleanup just for this special case especially as it's fairly possible
to keep a specific treatment for s390 in order not to impact its performances
and time precision. We could simply accumulate the cputime in per-cpu values:

struct s390_cputime {
       cputime_t user, sys, softirq, hardirq, steal;
}

DEFINE_PER_CPU(struct s390_cputime, s390_cputime);

Then on irq entry/exit, just add the accumulated time to the relevant buffer
and account for real (through any account_...time() functions) only on tick
and task switch. There the costly operations (unit conversion and call to
account_...._time() functions) are deferred to a rarer yet periodic enough
event. This is what s390 does already for user/system time and kernel
boundaries.

This way we should even improve the situation compared to what we have
upstream. It's going to be faster because calling the accounting functions
can be costlier than simple per-cpu ops. And also we keep the cputime_t
granularity. For archs like s390 which have a granularity higher than nsecs,
we can have:

   u64 cputime_to_nsecs(cputime_t time, u64 *rem);

And to avoid remainder losses, we can do that from the tick:

    delta_cputime = this_cpu_read(s390_cputime.hardirq);
    delta_nsec = cputime_to_nsecs(delta_cputime, &rem);
    account_system_time(delta_nsec, HARDIRQ_OFFSET);
    this_cpu_write(s390_cputime.hardirq, rem);

Although I doubt that remainders below one nsec lost each tick matter that much.
But if it does, it's fairly possible to handle like above.
