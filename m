Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961AbaLAR1t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 12:27:49 -0500
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:55187 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390AbaLAR1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 12:27:46 -0500
Date: Mon, 1 Dec 2014 18:27:38 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Tony Luck <tony.luck@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Oleg Nesterov <oleg@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Wu Fengguang <fengguang.wu@intel.com>, Ingo Molnar <mingo@kernel.org>,
        Rik van Riel <riel@redhat.com>
Subject: Re: [RFC PATCH 07/30] cputime: Convert kcpustat to nsecs
Message-ID: <20141201182738.2b344a18@mschwide>
In-Reply-To: <alpine.DEB.2.11.1412011801250.3961@nanos>
References: <1417199040-21044-1-git-send-email-fweisbec@gmail.com>
	<1417199040-21044-8-git-send-email-fweisbec@gmail.com>
	<20141201151402.31a6cc9a@mschwide>
	<20141201161031.GA27302@lerouge>
	<20141201174842.648dfe06@mschwide>
	<alpine.DEB.2.11.1412011801250.3961@nanos>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120117-0021-0000-0000-000001FA6F27
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Dec 2014 18:15:36 +0100 (CET)
Thomas Gleixner <tglx@linutronix.de> wrote:

> On Mon, 1 Dec 2014, Martin Schwidefsky wrote:
> > On Mon, 1 Dec 2014 17:10:34 +0100
> > Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > 
> > > Speaking about the degradation in s390:
> > > 
> > > s390 is really a special case. And it would be a shame if we prevent from a
> > > real core cleanup just for this special case especially as it's fairly possible
> > > to keep a specific treatment for s390 in order not to impact its performances
> > > and time precision. We could simply accumulate the cputime in per-cpu values:
> > > 
> > > struct s390_cputime {
> > >        cputime_t user, sys, softirq, hardirq, steal;
> > > }
> > > 
> > > DEFINE_PER_CPU(struct s390_cputime, s390_cputime);
> > > 
> > > Then on irq entry/exit, just add the accumulated time to the relevant buffer
> > > and account for real (through any account_...time() functions) only on tick
> > > and task switch. There the costly operations (unit conversion and call to
> > > account_...._time() functions) are deferred to a rarer yet periodic enough
> > > event. This is what s390 does already for user/system time and kernel
> > > boundaries.
> > > 
> > > This way we should even improve the situation compared to what we have
> > > upstream. It's going to be faster because calling the accounting functions
> > > can be costlier than simple per-cpu ops. And also we keep the cputime_t
> > > granularity. For archs like s390 which have a granularity higher than nsecs,
> > > we can have:
> > > 
> > >    u64 cputime_to_nsecs(cputime_t time, u64 *rem);
> > > 
> > > And to avoid remainder losses, we can do that from the tick:
> > > 
> > >     delta_cputime = this_cpu_read(s390_cputime.hardirq);
> > >     delta_nsec = cputime_to_nsecs(delta_cputime, &rem);
> > >     account_system_time(delta_nsec, HARDIRQ_OFFSET);
> > >     this_cpu_write(s390_cputime.hardirq, rem);
> > > 
> > > Although I doubt that remainders below one nsec lost each tick matter that much.
> > > But if it does, it's fairly possible to handle like above.
> >  
> > To make that work we would have to move some of the logic from account_system_time
> > to the architecture code. The decision if a system time delta is guest time,
> > irq time, softirq time or simply system time is currently done in 
> > kernel/sched/cputime.c.
> > 
> > As the conversion + the accounting is delayed to a regular tick we would have
> > to split the accounting code into decision functions which bucket a system time
> > delta should go to and introduce new function to account to the different buckets.
> > 
> > Instead of a single account_system_time we would have account_guest_time,
> > account_system_time, account_system_time_irq and account_system_time_softirq.
> > 
> > In principle not a bad idea, that would make the interrupt path for s390 faster
> > as we would not have to call account_system_time, only the decision function
> > which could be an inline function.
> 
> Why make this s390 specific?
> 
> We can decouple the accounting from the time accumulation for all
> architectures.
> 
> struct cputime_record {
>        u64 user, sys, softirq, hardirq, steal;
> };
> 
> DEFINE_PER_CPU(struct cputime_record, cputime_record);
> 
> Now let account_xxx_time() just work on that per cpu data
> structures. That would just accumulate the deltas based on whatever
> the architecture uses as a cputime source with whatever resolution it
> provides.
> 
> Then we collect that accumulated results for the various buckets on a
> regular base and convert them to nano seconds. This is not even
> required to be at the tick, it could be done by some async worker and
> on idle enter/exit.

And leave the decision making in kernel/sched/cputime.c. Yes, that is good.
This would make the arch and the account_xxx_time() function care about
cputime_t and all other common code would use nano-seconds. With the added
benefit that I do not have to change the low level code too much ;-)

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

