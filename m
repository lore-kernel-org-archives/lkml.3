Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757991Ab3CII1N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 03:27:13 -0500
Received: from mail-ee0-f44.google.com ([74.125.83.44]:58343 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754891Ab3CII0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 03:26:55 -0500
Date: Sat, 9 Mar 2013 09:26:50 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kevin Hilman <khilman@linaro.org>,
        Mats Liljegren <mats.liljegren@enea.com>
Subject: Re: [ANNOUNCE] 3.9-rc1-nohz1
Message-ID: <20130309082650.GA9944@gmail.com>
References: <1362790259-7837-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362790259-7837-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Hi,
> 
> Several fixes there. And this version should have much lesser spurious warnings. 
> Your testing and reviews is very appreciated.
> 
> The 5 first patches of the series are pending on a pull request for -tip (3.10 
> material).
> 
> I'm now considering how I should upstream the rest of the series. All the pieces 
> that got merged until now were sort of easy because the various chunks were pretty 
> self contained and independant (full dynticks cputime accounting, printk, RCU user 
> mode, dynticks API generalization, etc...).
> 
> Now what remains in this series is hard to cut into individual parts. Everything 
> depends on defining an interface with kernel parameter to partition the full 
> dynticks CPUs set.
> 
> I think we really need to start using a branch in -tip and move incrementally from 
> there with the following steps:
> 
> 	1) Set the kernel parameters and config option
> 	2) Handle timers wakeup, timekeeping, posix cpu timers, perf, sched etc...
> 	   on top of kernel parameter based CPU partition
> 	3) Once we know _everything_ is handled, bring the final dynticks infrastructure
> 	4) Upstream
> 
> This will make everything much easier for everyone: easier piecewise reviews and 
> easier for other people to contribute.
> 
> Because you don't want me to spam you with ~40 commits for 2 more years, right?
> 
> Thanks.
> 
> This version can be found at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
> 	3.9-rc1-nohz1
> 
> ---
> Changes since 3.8-rc6-nohz4:
> 
> * Rebase against 3.9-rc1
> 
> * Fixed a few races with exception and preemption handling [1-3/29]
> 
> * Dropped commit "sched: Remove broken check for skip clock update"
> that was buggy (thanks Steve for pointing that)
> 
> * Ignore noisy stale rq clock detection on boot and other situations
> with rq->skip_clock_update [27/29]
> 
> * Dropped commit "sched: Update clock of nohz busiest rq before balancing"
> that became useless (thanks Li Zhong)
> 
> * Don't issue a self IPI on timer enqueue if the CPU didn't stop its
> tick [9/29]
> 
> * Rename a bit the Kconfig menu after discussion with Borislav [6/29]
> 
> * Handle broken full_nohz mask in kernel parameters (thanks Borislav) [6/29]
> 
> ---
> TODO list hasn't changed much:
> 
> - Posix CPU timers
> - Perf events
> - sched_class::task_tick()
> - various other scheduler details
> - ...

We could certainly start tip:sched/dynticks (or tip:timers/dynticks) to accelerate 
the upstream merging of it. Nobody expressed deep concerns with the approach, so 
what is left is some more hard work.

Two quick requests:

 - Mind adding a Documentation/... file with a high level description,
   rough design, open problems, etc.?

 - Please outline how the current TODO entries affect upstream
   mergability. Does it reduce the 'full'-ness of this dynticks mode?
   Outright buggy behavior? Other trade-offs?

Thanks,

	Ingo
