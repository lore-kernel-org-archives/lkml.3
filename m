Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934960Ab3DHLT1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 07:19:27 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:40378 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934783Ab3DHLT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 07:19:26 -0400
Date: Mon, 8 Apr 2013 13:19:19 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@linaro.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Michal Marek <mmarek@suse.cz>
Subject: Re: [RFC GIT PULL] nohz: Kconfig layout improvements
Message-ID: <20130408111919.GB1225@gmail.com>
References: <1364993190-13784-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364993190-13784-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Ingo,
> 
> This set addresses your review concerning the Kconfig layout.
> Please note two things here that derive from what we agreed
> on due to technical limitations:
> 
> * Now the full dynticks Kconfig is not hidden anymore behind its
> high level dependencies. (ie: passive dependencies are now active).
> There is an exception though with CONFIG_VIRT_CPU_ACCOUNTING_GEN
> (Full dynticks cputime accounting) that is part of a choice menu
> like PREEMPT_*. It seems such kconfig layout prevent from doing a remote
> select on its choices. So it stays a passive dependency for now, until
> Kconfig/Kbuild supports that (Cc'ing Michel Marek) or somebody shows
> me what I did wrong ;)
> 
> * Ideally we want to reuse CONFIG_NO_HZ as a Kconfig that consolidate
> the common code between CONFIG_NO_HZ_IDLE and CONFIG_NO_HZ_EXTENDED.
> But we also want CONFIG_NO_HZ from old config files to map to CONFIG_NO_HZ_IDLE.
> Both at the same time is not possible or we have a Kconfig circular
> dependency. So I introduced a new CONFIG_NO_HZ_COMMON for common nohz code
> and CONFIG_NO_HZ stays for backward compatibility by enabling CONFIG_NO_HZ_IDLE
> by default.
> 
> If you're ok, please pull from:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
> 	timers/nohz-v2
> 
> Thanks.
> 
> ---
> Frederic Weisbecker (4):
>   nohz: Unhide full dynticks feature from its dependencies
>   nohz: Rename CONFIG_NO_HZ to CONFIG_NO_HZ_COMMON
>   nohz: Pack nohz Kconfig option in a menu of choices
>   nohz: Print final full dynticks CPUs range on boot
> 
>  Documentation/RCU/stallwarn.txt         |    2 +-
>  Documentation/cpu-freq/governors.txt    |    4 +-
>  arch/um/include/shared/common-offsets.h |    4 +-
>  arch/um/os-Linux/time.c                 |    2 +-
>  include/linux/sched.h                   |    8 ++--
>  include/linux/tick.h                    |    8 ++--
>  init/Kconfig                            |    2 +-
>  kernel/hrtimer.c                        |    4 +-
>  kernel/sched/core.c                     |   18 +++++-----
>  kernel/sched/fair.c                     |   10 +++---
>  kernel/sched/sched.h                    |    4 +-
>  kernel/softirq.c                        |    2 +-
>  kernel/time/Kconfig                     |   54 ++++++++++++++++++++++++------
>  kernel/time/tick-sched.c                |   22 +++++++++---
>  kernel/timer.c                          |    4 +-
>  15 files changed, 95 insertions(+), 53 deletions(-)

I pulled it into tip:timers/nohz and will push it out if it passes testing because 
I like the improvements - but there's still a few things missing I think.

Firstly, I performed this "how are users exposed to this new feature" test:

   git checkout v3.9-rc6
   make defconfig
   git checkout tip/master
   make oldconfig

the x86 (64-bit) defconfig has NO_HZ enabled. When I did the 'make oldconfig', I 
was given:

  *
  * Timers subsystem
  *
  Timer tick handling
  > 1. Periodic timer ticks (constant rate, no dynticks) (PERIODIC_HZ) (NEW)
    2. Idle dynticks system (tickless idle) (NO_HZ_IDLE) (NEW)
  choice[1-2]: 

[ Firstly, while at it: that should be 'Timer subsystem' or 'Timers'. ]

More importantly, the new Kconfig behavior is still not quite right for two 
reasons:

1)

the default is not set to NO_HZ_IDLE. The oldconfig .config had 
CONFIG_NO_HZ set - this should be grandfathered over into the new config's 
default choice. That can probably be done by still keeping CONFIG_NO_HZ as 
a migration helper entry.

2)

there's still no extended idle tick option offered - due to it not meeting 
the CONFIG_VIRT_CPU_ACCOUNTING_GEN dependency.

Even if I read the Kconfig rules and figure out the dependency, I have to 
perform _two_ steps to get extended ticks:

I had to manually find CONFIG_VIRT_CPU_ACCOUNTING_GEN in the .config and 
delete it, so that I'm given the choice on the next 'make oldconfig'.

Then NO_HZ_EXTENDED was set to disabled in the .config silently, because 
NO_HZ_IDLE was already set. So I had to delete that and re-configure it 
again.

Highly inconvenient.

-----------------------

Once the dependencies are right I like it how then we get offered the 3 variants:

 *
 * Timers subsystem
 *
 Timer tick handling
 > 1. Periodic timer ticks (constant rate, no dynticks) (PERIODIC_HZ) (NEW)
   2. Idle dynticks system (tickless idle) (NO_HZ_IDLE) (NEW)
   3. Full dynticks system (tickless single task) (NO_HZ_EXTENDED) (NEW)

and I think that is how it should always look like, for standard .config's, pretty 
much regardless of how other things are configured - as long as the architecture 
supports extended dynticks.

So I'd suggest the following changes to fix the remaining usability problems:

 - .config compatibility fix: the default selection should pick up existing 
   CONFIG_NO_HZ settings, for a kernel release cycle, so that people whole just go 
   through 'make oldconfig' and rely on the defaults don't lose CONFIG_NO_HZ_IDLE.

   This can probably be done by adding a CONFIG_NO_HZ Kconfig entry, and
   documenting it as a migration helper. This can then be removed in v3.11. The 
   multiple choices entry can then use CONFIG_NO_HZ to set its default offering to
   CONFIG_NO_HZ_IDLE or CONFIG_PERIODIC_HZ?

 - CONFIG_VIRT_CPU_ACCOUNTING_GEN should be selected as well. (Maybe even the RCU
   model.)

 - Nit: the 'depends on SMP' part looks a bit weird. Is that a quirk?

 - Plus a minor help text nit: I'd not call it 'tickless single task' - but 
   'tickless'. When there are multiple tasks on a CPU then it's natural that 
   there's a scheduler tick arbitrating between them - this can be mentioned in 
   the help text, but otherwise should not distract from the 'full dynticks' 
   notion.

   It's not even always about a single task: when there's multiple SCHED_FIFO 
   tasks running, then the scheduler tick is expected to be off, even if there are 
   2 or more SCHED_FIFO tasks on that runqueue, right?

 - Could we rename NO_HZ_EXTENDED to NO_HZ_FULL? :-) I think it's important to 
   stress that in this mode the kernel does whatever it can to keep the tick off:


     CONFIG_HZ_PERIODIC          # (no dynticks,      periodic ticks)
     CONFIG_NO_HZ_IDLE           # (partial dynticks, tick is off in idle only)
     CONFIG_NO_HZ_FULL           # (full dynticks,    tick is off whenever possible)

   while 'extended' is too vague, it really does not tell us anything about how 
   it's meant to be 'extended'.

   ( And I'd also suggest renaming CONFIG_PERIODIC_HZ -> CONFIG_HZ_PERIODIC, to be
     consistent with the NO_HZ_IDLE, NO_HZ_FULL Polish notation naming pattern. )

I'm so nitpicky because the Kconfig logic of major kernel features has the 
potential to cause quite a bit of user and tester confusion, so we have to try to 
do our utmost best to structure it in the most logical and approachable fashion.

Thanks,

	Ingo
