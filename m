Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646AbaDNJ4D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 05:56:03 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:43705 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbaDNJ4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 05:56:00 -0400
Date: Mon, 14 Apr 2014 11:55:54 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <williams@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC PATCH RT] rwsem: The return of multi-reader PI rwsems
Message-ID: <20140414095554.GB731@gmail.com>
References: <20140409151922.5fa5d999@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140409151922.5fa5d999@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> A while back ago I wrote a patch that would allow for reader/writer
> locks like rwlock and rwsems to have multiple readers in PREEMPT_RT. It
> was slick and fast but unfortunately it was way too complex and ridden
> with nasty little critters which earned me my large collection of
> frozen sharks in the fridge (which are quite tasty).
> 
> The main problem with my previous solution was that I tried to be too
> clever. I worked hard on making the rw mutex still have the "fast
> path". That is, the cmpxchg that could allow a non contended grabbing
> of the lock be one instruction and be off with it. But to get that
> working required lots of tricks and black magic that was certainly
> going to fail. Thus, with the raining of sharks on my parade, the
> priority inheritance mutex with multiple owners died a slow painful
> death.
> 
> So we thought.
> 
> But over the years, a new darkness was on the horizon. Complaints about
> running highly threaded processes (did I hear Java?) were suffering
> huge performance hits on the PREEMPT_RT kernel. Whether or not the
> processes were real-time tasks, they still were horrible compared to
> running the same tasks on the mainline kernel. Note, this was being
> done on machines with many CPUs.
> 
> The culprit mostly was a single rwsem, the notorious mmap_sem that
> can be taking several times for read, and as on RT, this is just a
> single mutex, and it would serialize these accesses that would not
> happen on mainline.
> 
> I looked back at my poor dead rw multi pi reader patch and thought to
> myself. "How complex would this be if I removed the 'fast path' from
> the code". I decided to build a new tower in Mordor.
> 
> I feel that I am correct. By removing the fast path and requiring all
> accesses to the rwsem to go through the slow path (must take the
> wait_lock to do anything). The code really wasn't that bad. I also only
> focused on the rwsem and did not worry about the rwlocks as that hasn't
> been pointed out as a bottle neck yet. If it does happen to be, this
> code could easily work on rwlocks too.
> 
> I'm much more confident in this code than I was with my previous
> version of the rwlock multi-reader patch. I added a bunch of comments
> to this code to explain how things interact. The writer unlock was
> still able to use the fast path as the writers are pretty much like a
> normal mutex. Too bad that the writer unlock is not a high point of
> contention.
> 
> This patch is built on top of the two other patches that I posted
> earlier, which should not be as controversial.
> 
> If you have any benchmark on large machines I would be very happy if
> you could test this patch against the unpatched version of -rt.
> 
> Cheers,
> 
> -- Steve
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
> Index: linux-rt.git/kernel/rtmutex.c

Side note: could you please in general include diffstats with such 
patches, especially since you seem to be exporting it from a Git repo?

Newfangled patch summaries like:

 include/linux/rtmutex.h  |   29 ++
 include/linux/rwsem_rt.h |    8 
 include/linux/sched.h    |   20 +
 kernel/fork.c            |   20 +
 kernel/futex.c           |    2 
 kernel/rt.c              |   27 +
 kernel/rtmutex.c         |  645 +++++++++++++++++++++++++++++++++++++++++++++--
 kernel/rtmutex_common.h  |   19 +
 kernel/sysctl.c          |   13 
 9 files changed, 753 insertions(+), 30 deletions(-)

Really give a useful bird's eye view of forest Fangorn, before 
straying into it!

Thanks,

	Ingo
