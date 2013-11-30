Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296Ab3K3N7N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 08:59:13 -0500
Received: from mail-bk0-f44.google.com ([209.85.214.44]:56274 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913Ab3K3N7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 08:59:11 -0500
Date: Sat, 30 Nov 2013 14:59:07 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [GIT PULL] dynticks updates for 3.13
Message-ID: <20131130135907.GA19027@gmail.com>
References: <1384181387-30194-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384181387-30194-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Ingo,
> 
> Please pull the timers/core branch that can be found at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
> 	timers/core
> 
> It passed through 0-day testing. I'm proposing it for 3.13 just in case but I'm ok
> as well if you think it's too late and should be delayed for 3.14

Pulled into tip:timers/core, thanks Frederic!

In the future it would be nice to write a higher level description 
that I can put into the merge commit. I wrote this:

  Pull dynticks updates from Frederic Weisbecker: smaller fixes and 
  cleanups.

Btw., how does the bug here:

  92e73cf831ba posix-timers: Fix full dynticks CPUs kick on timer rescheduling

manifest itself to users? Is there any real bug, or suboptimal nohz 
behavior? (more wakeups than expected) This kind of information should 
really be in the changelog.

> 
> Thanks,
> 	Frederic
> ---
> 
> Frederic Weisbecker (5):
>       nohz: Convert a few places to use local per cpu accesses
>       context_tracking: Wrap static key check into more intuitive function name
>       context_tracking: Rename context_tracking_active() to context_tracking_cpu_is_enabled()
>       posix-timers: Spare workqueue if there is no full dynticks CPU to kick
>       posix-timers: Fix full dynticks CPUs kick on timer rescheduling
> 
> Paul Gortmaker (1):
>       trivial: fix spelling in CONTEXT_TRACKING_FORCE help text
> 
> 
>  include/linux/context_tracking.h       | 10 ++++-----
>  include/linux/context_tracking_state.h | 11 +++++++---
>  include/linux/tick.h                   |  8 ++++----
>  include/linux/vtime.h                  |  4 ++--
>  init/Kconfig                           |  2 +-
>  kernel/context_tracking.c              |  8 ++++----
>  kernel/posix-cpu-timers.c              | 21 +++++++++----------
>  kernel/softirq.c                       |  4 +---
>  kernel/time/tick-broadcast.c           |  6 +++---
>  kernel/time/tick-internal.h            |  4 ++--
>  kernel/time/tick-sched.c               | 37 ++++++++++++++--------------------
>  11 files changed, 54 insertions(+), 61 deletions(-)

Btw., I noticed one other detail:

-       tick_check_oneshot_broadcast(cpu);
-       tick_check_nohz(cpu);
+       tick_check_oneshot_broadcast();
+       tick_check_nohz();

it would be nice to name such functions that lose a 'cpu' argument 
with the this_cpu pattern, i.e.:

	- tick_check_oneshot_broadcast_this_cpu()
	- tick_check_nohz_this_cpu()

This makes it more obvious at a glance that they have 'current CPU' 
assumptions in them.

	Ingo
