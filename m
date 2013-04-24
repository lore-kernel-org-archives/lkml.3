Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757754Ab3DXHdG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 03:33:06 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:37494 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757734Ab3DXHdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 03:33:04 -0400
Date: Wed, 24 Apr 2013 09:32:59 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Chris Metcalf <cmetcalf@tilera.com>,
        Christoph Lameter <cl@linux.com>, Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@linaro.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [GIT PULL] nohz: Adaptively stop the tick, finally
Message-ID: <20130424073259.GC1780@gmail.com>
References: <1366657186-20556-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366657186-20556-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Ingo,
> 
> Please pull the latest full dynticks branch that can found at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
> 	timers/nohz
> 
> HEAD: 67826eae8c16dbf00c262be6ec15021bb42f69c4
> 
> This handles perf and CPUs that get more than one task and fix posix cpu timers
> handling.
> 
> This can finally stop the tick. It boots and doesn't crash, as far as I tested.
> 
> Now what's left:
> 
> * Kick CPUs' tick when the clock is marked unstable
> 
> * Kick CPUs when they extend the RCU grace periods too much by staying in
> the kernel for too long (we are discussing this with Paul).
> 
> * sched_class:task_tick(). There are gazillions statistics maintained there.
> It's probably mostly about local and global fairness. May be for other stuff
> too (cgroups, etc...).
> 
> * update_cpu_load_active(): again, various stats maintained there
> 
> * load balancing (see trigger_load_balance() usually called from the tick).
> 
> I hope we can handle these things progressively in the long run.
> 
> Thanks.
> 
> ---
> Frederic Weisbecker (10):
>   posix_timers: Fix pre-condition to stop the tick on full dynticks
>   perf: Kick full dynticks CPU if events rotation is needed
>   perf: New helper to prevent full dynticks CPUs from stopping tick
>   sched: Kick full dynticks CPU that have more than one task enqueued.
>   sched: New helper to prevent from stopping the tick in full dynticks
>   nohz: Re-evaluate the tick from the scheduler IPI
>   nohz: Implement full dynticks kick
>   nohz: Prepare to stop the tick on irq exit
>   nohz: Re-evaluate the tick for the new task after a context switch
>   nohz: Disable the tick when irq resume in full dynticks CPU
> 
>  include/linux/perf_event.h |    6 +++
>  include/linux/sched.h      |    6 +++
>  include/linux/tick.h       |    4 ++
>  kernel/events/core.c       |   17 +++++++-
>  kernel/posix-cpu-timers.c  |    6 +-
>  kernel/sched/core.c        |   24 +++++++++++-
>  kernel/sched/sched.h       |   11 +++++
>  kernel/softirq.c           |   19 ++++++--
>  kernel/time/tick-sched.c   |   95 ++++++++++++++++++++++++++++++++++++++-----
>  9 files changed, 167 insertions(+), 21 deletions(-)

Pulled, thanks Frederic!

One detail: 'make oldconfig' gave me:

 Timer tick handling
   1. Periodic timer ticks (constant rate, no dynticks) (HZ_PERIODIC) (NEW)
 > 2. Idle dynticks system (tickless idle) (NO_HZ_IDLE) (NEW)

I.e. CONFIG_NO_HZ_IDLE is picked by default. The default should really be 
CONFIG_HZ_PERIODIC - so that people can easily enable full dynticks but 
are not defaulted into it unknowingly.

Thanks,

	Ingo
