Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751346Ab3HSLKn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 07:10:43 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57189 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333Ab3HSLKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 07:10:42 -0400
Date: Mon, 19 Aug 2013 13:10:26 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH 2/4] nohz: Synchronize sleep time stats with seqlock
Message-ID: <20130819111026.GE24092@twins.programming.kicks-ass.net>
References: <1376667753-29014-1-git-send-email-fweisbec@gmail.com>
 <1376667753-29014-3-git-send-email-fweisbec@gmail.com>
 <20130816160201.GA31682@redhat.com>
 <20130816162056.GE24210@somewhere>
 <20130816162654.GA453@redhat.com>
 <20130816164626.GH24210@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130816164626.GH24210@somewhere>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 16, 2013 at 06:46:28PM +0200, Frederic Weisbecker wrote:

Option A:

> Should we flush that iowait to the src CPU? But then it means we must handle
> concurrent updates to iowait_sleeptime, idle_sleeptime from the migration
> code and from idle enter / exit.
> 
> So I fear we need a seqlock.

Option B:

> Or we can live with that and still account the whole idle time slept until
> tick_nohz_stop_idle() to iowait if we called tick_nohz_start_idle() with nr_iowait > 0.
> All we need is just a new field in ts-> that records on which state we entered
> idle.
> 
> What do you think?

I think option B is unworkable. Afaict it could basically caused
unlimited iowait time. Suppose we have a load-balancer that tries it
bestestest to sort-left (ie. run a task on the lowest 'free' cpu
possible) -- the power aware folks are pondering such schemes.

Now suppose we have a small burst of activity and the rightmost cpu gets
to run something that goes to sleep on iowait.

We'd accrue iowait on that cpu until it wakes up, which could be days
from now if the load stays low enough, even though the task got to run
almost instantly on another cpu.

So no, if we need per-cpu iowait time we have to do A.

Since we already have atomics in the io_schedule*() paths, please
replace those with (seq)locks. Also see if you can place the entire
iowait accounting thing in a separate cacheline.

That said, I'm still not sure if iowait time counts as both idle and
iowait or only iowait.
