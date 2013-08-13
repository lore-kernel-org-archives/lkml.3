Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199Ab3HMAEF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 20:04:05 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:51477 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756048Ab3HMAED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 20:04:03 -0400
Date: Tue, 13 Aug 2013 02:03:57 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Mike Galbraith <efault@gmx.de>,
        Kevin Hilman <khilman@linaro.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Alex Shi <alex.shi@intel.com>, Paul Turner <pjt@google.com>,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: Re: [GIT PULL] timers/nohz updates for 3.12
Message-ID: <20130813000355.GD27436@somewhere>
References: <1375729264-19845-1-git-send-email-fweisbec@gmail.com>
 <20130812184428.GA19785@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130812184428.GA19785@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 12, 2013 at 08:44:28PM +0200, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > Ingo,
> > 
> > Please pull the timers/nohz branch that can be found at:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
> > 	timers/nohz
> > 
> > It mostly contains fixes and full dynticks off-case optimizations. I believe that
> > distros want to enable this feature so it seems important to optimize the case
> > where the "nohz_full=" parameter is empty. ie: I'm trying to remove any performance
> > regression that comes with NO_HZ_FULL=y when the feature is not used.
> > 
> > This patchset improves the current situation a lot (off-case appears to be around 11% faster
> > with hackbench, although I guess it may vary depending on the configuration but it should be
> > significantly faster in any case) now there is still some work to do: I can still observe a
> > remaining loss of 1.6% throughput seen with hackbench compared to CONFIG_NO_HZ_FULL=n
> > 
> > Thanks,
> > 	Frederic
> > ---
> > 
> > Frederic Weisbecker (23):
> >       sched: Consolidate open coded preemptible() checks
> >       context_tracing: Fix guest accounting with native vtime
> >       vtime: Update a few comments
> >       context_tracking: Fix runtime CPU off-case
> >       nohz: Only enable context tracking on full dynticks CPUs
> >       context_tracking: Remove full dynticks' hacky dependency on wide context tracking
> >       context_tracking: Ground setup for static key use
> >       context_tracking: Optimize main APIs off case with static key
> >       context_tracking: Optimize guest APIs off case with static key
> >       context_tracking: Optimize context switch off case with static keys
> >       context_tracking: User/kernel broundary cross trace events
> >       vtime: Remove a few unneeded generic vtime state checks
> >       vtime: Fix racy cputime delta update
> >       context_tracking: Split low level state headers
> >       hardirq: Split preempt count mask definitions
> >       m68k: hardirq_count() only need preempt_mask.h
> >       vtime: Describe overriden functions in dedicated arch headers
> >       vtime: Optimize full dynticks accounting off case with static keys
> >       vtime: Always scale generic vtime accounting results
> >       vtime: Always debug check snapshot source _before_ updating it
> >       nohz: Rename a few state variables
> >       nohz: Optimize full dynticks state checks with static keys
> >       nohz: Optimize full dynticks's sched hooks with static keys
> > 
> > 
> >  arch/ia64/include/asm/Kbuild            |    1 +
> >  arch/m68k/include/asm/irqflags.h        |    2 +-
> >  arch/powerpc/include/asm/Kbuild         |    1 +
> >  arch/s390/include/asm/cputime.h         |    3 -
> >  arch/s390/include/asm/vtime.h           |    7 ++
> >  arch/s390/kernel/vtime.c                |    1 +
> >  include/linux/context_tracking.h        |  120 +++++++++++++++--------------
> >  include/linux/context_tracking_state.h  |   39 +++++++++
> >  include/linux/hardirq.h                 |  117 +----------------------------
> >  include/linux/preempt_mask.h            |  122 +++++++++++++++++++++++++++++
> >  include/linux/tick.h                    |   45 +++++++++--
> >  include/linux/vtime.h                   |   74 ++++++++++++++++--
> >  include/trace/events/context_tracking.h |   58 ++++++++++++++
> >  init/Kconfig                            |   28 +++++--
> >  kernel/context_tracking.c               |  128 ++++++++++++++++++-------------
> >  kernel/sched/core.c                     |    4 +-
> >  kernel/sched/cputime.c                  |   53 ++++---------
> >  kernel/time/Kconfig                     |    1 -
> >  kernel/time/tick-sched.c                |   56 ++++++--------
> >  19 files changed, 534 insertions(+), 326 deletions(-)
> 
> When merged to -tip it causes this build error:
> 
>  kernel/time/tick-sched.c:186:3: error: 'have_nohz_full_mask' undeclared (first use in this function)
>  kernel/time/tick-sched.c:345:2: error: 'cpu' undeclared (first use in this function)
> 
> config attached.
> 
> I did what looked like to be an obvious conflict resolution to 
> tick-sched.c (attached), please double check that too.
> 
> While at it, mind rebasing your changes to tip:timers/urgent, which has a 
> few nohz fixes pending as well?

Ok I did the rebase on top of tip:timers/urgent and handled the conflicts along.
The new branch is "timers/nohz-v2".

Tell me if anything goes wrong with it.

Thanks.
