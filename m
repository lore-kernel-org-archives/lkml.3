Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754352Ab3AYX16 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 18:27:58 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:37602 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441Ab3AYX1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 18:27:55 -0500
Date: Fri, 25 Jan 2013 15:27:40 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: Re: [PATCH 0/7] cputime: Full dynticks task/cputime accounting v5
Message-ID: <20130125232740.GA2296@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1358429075-3430-1-git-send-email-fweisbec@gmail.com>
 <20130125174247.GQ6395@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130125174247.GQ6395@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012523-2398-0000-0000-0000106BB7ED
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Right...  Replied to the wrong email.  :-/

I queued "context_tracking: Add comments on interface and internals".

							Thanx, Paul

On Fri, Jan 25, 2013 at 09:42:47AM -0800, Paul E. McKenney wrote:
> On Thu, Jan 17, 2013 at 02:24:28PM +0100, Frederic Weisbecker wrote:
> > Hi,
> > 
> > This patchset was formerly called "Generic virtual based cputime accounting"  
> > but I changed the name to better reflect what it's all about.
> > 
> > This is	the part of the	full dynticks patchset that handles the	task and CPU
> > time accounting	without	the tick.
> > 
> > It's available at:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
> > 	vtime/generic-v5
> > 
> > There have been a lot of changes since latest full dynticks patchset:
> > 
> > - Use sched_clock() instead of jiffies for better precision. And because
> > jiffies	granularity was requiring too much dirty hacks to make it working.
> > (Thanks	Steven for the suggestion).
> > 
> > - To fully support sched_clock(), use a	per nanosec granularity	in cputime_t
> > 
> > - Fix a	deadlock with tsacct
> > 
> > - Better description of the Kconfig
> > 
> > - Don't	scale generic vtime accounting against CFS precise task	time accounting.
> > Now that we use	sched_clock() we should have precise enough statistics.
> > 
> > - Consolidate some code in the reader side
> > 
> > - Make the reader irqsafe (fix potential deadlock against writers)
> > 
> > 
> > Most of the work is done. There are just a few small things I need to care about
> > to complete the full cputime support:
> > 
> > * Also handle dynticks guest time accounting (p->gtime and p->utime). This
> > require to bring a new accessor: task_gtime() and to add guest_enter() and
> > guest_exit() on the context tracking subsystem. Then make the same treatment
> > than with utime and stime. No big deal.
> > 
> > * New tasks start their cputime accounting from schedule() on sched-in time
> > (see arch_vtime_task_switch()). But I fear that idle tasks don't fall into this
> > category. That's a small detail but I hope I can find some generic way to handle it.
> > The boot init idle task is however handled.
> > 
> > * Per nsec granularity requires that cputime_t directly maps to cputime64_t. This
> > is fine on 64 bits archs and mostly fine in 32 bits archs as well because readers
> > use seqlock to synchronize against writers. But reading struct kernel_cputstat
> > is not protected. Not sure yet how to solve that.
> > 
> > So I'll likely focus on these items on the next version. Let's hope we can make
> > it ready for the next merge window.
> 
> Queued for 3.9, thank you!
> 
> 							Thanx, Paul
> 
> > Thanks.
> > 
> > ---
> > Frederic Weisbecker (7):
> >       context_tracking: Export context state for generic vtime
> >       cputime: Librarize per nsecs resolution cputime definitions
> >       cputime: Move default nsecs_to_cputime() to jiffies based cputime file
> >       cputime: Generic on-demand virtual cputime accounting
> >       cputime: Allow dynamic switch between tick/virtual based cputime accounting
> >       cputime: Use accessors to read task cputime stats
> >       cputime: Safely read cputime of full dynticks CPUs
> > 
> > 
> >  arch/alpha/kernel/osf_sys.c                  |    6 +-
> >  arch/ia64/include/asm/cputime.h              |   92 +----------
> >  arch/ia64/include/asm/thread_info.h          |    4 +-
> >  arch/ia64/include/asm/xen/minstate.h         |    2 +-
> >  arch/ia64/kernel/asm-offsets.c               |    2 +-
> >  arch/ia64/kernel/entry.S                     |   16 +-
> >  arch/ia64/kernel/fsys.S                      |    4 +-
> >  arch/ia64/kernel/head.S                      |    4 +-
> >  arch/ia64/kernel/ivt.S                       |    8 +-
> >  arch/ia64/kernel/minstate.h                  |    2 +-
> >  arch/ia64/kernel/time.c                      |    4 +-
> >  arch/powerpc/configs/chroma_defconfig        |    2 +-
> >  arch/powerpc/configs/corenet64_smp_defconfig |    2 +-
> >  arch/powerpc/configs/pasemi_defconfig        |    2 +-
> >  arch/powerpc/include/asm/cputime.h           |    6 +-
> >  arch/powerpc/include/asm/lppaca.h            |    2 +-
> >  arch/powerpc/include/asm/ppc_asm.h           |    4 +-
> >  arch/powerpc/kernel/entry_64.S               |    4 +-
> >  arch/powerpc/kernel/time.c                   |    4 +-
> >  arch/powerpc/platforms/pseries/dtl.c         |    6 +-
> >  arch/powerpc/platforms/pseries/setup.c       |    6 +-
> >  arch/s390/kernel/vtime.c                     |    6 +-
> >  arch/x86/kernel/apm_32.c                     |   11 +-
> >  drivers/isdn/mISDN/stack.c                   |    7 +-
> >  fs/binfmt_elf.c                              |    8 +-
> >  fs/binfmt_elf_fdpic.c                        |    7 +-
> >  include/asm-generic/cputime.h                |   66 +-------
> >  include/asm-generic/cputime_jiffies.h        |   72 +++++++++
> >  include/asm-generic/cputime_nsecs.h          |  104 ++++++++++++
> >  include/linux/context_tracking.h             |   28 ++++
> >  include/linux/hardirq.h                      |    4 +-
> >  include/linux/init_task.h                    |   11 ++
> >  include/linux/kernel_stat.h                  |    2 +-
> >  include/linux/sched.h                        |   34 ++++
> >  include/linux/tsacct_kern.h                  |    3 +
> >  include/linux/vtime.h                        |   51 ++++--
> >  init/Kconfig                                 |   23 +++-
> >  kernel/acct.c                                |    6 +-
> >  kernel/context_tracking.c                    |   22 +--
> >  kernel/cpu.c                                 |    4 +-
> >  kernel/delayacct.c                           |    7 +-
> >  kernel/exit.c                                |    6 +-
> >  kernel/fork.c                                |   14 ++
> >  kernel/posix-cpu-timers.c                    |   28 +++-
> >  kernel/sched/cputime.c                       |  219 +++++++++++++++++++++++---
> >  kernel/signal.c                              |   12 +-
> >  kernel/softirq.c                             |    6 +-
> >  kernel/time/tick-sched.c                     |    5 +-
> >  kernel/tsacct.c                              |   44 ++++--
> >  49 files changed, 696 insertions(+), 296 deletions(-)
> >  create mode 100644 include/asm-generic/cputime_jiffies.h
> >  create mode 100644 include/asm-generic/cputime_nsecs.h
> > 
> > -- 
> > 1.7.5.4
> > 

