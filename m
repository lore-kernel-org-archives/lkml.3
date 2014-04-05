Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163AbaDEKIW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2014 06:08:22 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:42042 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753572AbaDEKIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2014 06:08:20 -0400
Date: Sat, 5 Apr 2014 12:08:16 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] nohz: use seqlock to avoid race on idle time stats v2
Message-ID: <20140405100813.GA16696@localhost.localdomain>
References: <5338CC86.9080602@jp.fujitsu.com>
 <5338CE0B.1050100@jp.fujitsu.com>
 <CAK1hOcMmmq=5EVLBrAd44HC+EHrnztABU48gd9BgK+LUNBJSOQ@mail.gmail.com>
 <20140404160328.GA10042@localhost.localdomain>
 <CAK1hOcMZPDhUzvJk0Q0rkkBh1tS=O+HU9ufEmX7VwnjhsSgQeA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK1hOcMZPDhUzvJk0Q0rkkBh1tS=O+HU9ufEmX7VwnjhsSgQeA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 04, 2014 at 07:02:43PM +0200, Denys Vlasenko wrote:
> On Fri, Apr 4, 2014 at 6:03 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> >> However, if we would put ourselves into admin's seat, iowait
> >> immediately starts to make sense: for admin, the system state
> >> where a lot of CPU time is genuinely idle is qualitatively different
> >> form the state where a lot of CPU time is "idle" because
> >> we are I/O bound.
> >>
> >> Admins probably wouldn't insist that iowait accounting must be
> >> very accurate. I would hazard to guess that admins would settle
> >> for the following rules:
> >
> > Iowait makes sense but not per cpu. Eventually it's a global
> > stat. Or per task.
> 
> There a lot of situations where admins want to know
> how much, on average, their CPUs are idle because
> they wait for IO.
> 
> If you are running, say, a Web cache,
> you need to know that stat in order to be able to
> conjecture "looks like I'm IO bound, perhaps caching
> some data in RAM will speed it up".

But then accounting iowait time waited until completion on the CPU
that the task wakes up should work for that.

Doesn't it?

> 
> Global stat will give such data to admin. Per-task won't -
> there can be an efficient Web cache design which uses
> many parallel tasks to hide IO latency. Thus, such
> Web cache can be nearly optimal despite its tasks,
> individually, having significant iowait counts each.

I don't see how it's an issue. Just add up the cumulated iowait among
all these tasks and you get the global iowait time.

Anyway that's not a problem, the goal is still to display that per CPU.

> 
> > I've sratched my head a lot on this. And I think we can't continue
> > with the current semantics. If we had to keep the current semantics
> > and enforce correctness at the same time, we are going to run into
> > big scalability and performance issues. This can't be done without
> > locking updates to nr_iowait() with seqlock:
> >
> > * when a task blocks on IO and goes idle, lock some per cpu iowait_seq,
> > increase nr_iowait, save curr CPU number, save time.
> >
> > * when a task io completes and it gets enqueued on another CPU: retrieve
> > old CPU, lock its iowait_seq, decrease nr_iowait, flush delta iowait .
> >
> > And all that just to maintain stats which semantics are wrong, this
> > would be pure madness.
> >
> > OTOH we must stay compatible with user ABI in /proc/stat (the one in /proc/timers_list
> > matters less).  But if we make it a per task stat, we are free to account it
> > on the CPU we want.
> >
> > So what we can do for example is to account it per task and update stats
> > on the CPU where the blocking task wakes up. This way we guarantee
> > that we only account locally, which is good for scalability.
> 
> When IO-bound task wakes on some CPU,
> how exactly do you propose to update counters -
> add total waited time of this task to this CPU's counter?

So we save, per task, the time when the task went to sleep. And when it wakes up
we just flush the pending time since that sleep time to the waking CPU:
iowait[$CPU] += NOW() - tsk->sleeptime;

> Is such counter meaningful for the admin?

Well, you get the iowait time accounting.

> 
> > This is going to be an ABI change on a /proc/stat field semantic.
> > We usually can not do that as it can break userspace. But I think
> > we have a reasonable exception here:
> >
> > 1) On a performance POV we don't have the choice.
> >
> > 2) It has always been a buggy stat on SMP. Given the possible fast iowait update
> > rate, I doubt it has ever dumped correct stats. So I guess that few user apps
> > have ever correctly relied on it.
> 
> In busybox project, the following tools use iowait counter:
> 
> top,mpstat: in order to show "%iowait"
> 
> nmeter: to show "waiting for disk" part of CPU bar.
> Example:
> $ nmeter '%t %70c'
> 18:57:33 SUU...................................................................
> 18:57:34 SUUUUUUUUUUI..........................................................
> 18:57:35 SUUUII................................................................
> 18:57:36 SUUU..................................................................
> 18:57:37 SSUDDD................................................................
>   (^^^^^^ IO-intensive task starts)
> 18:57:38 SSSSSSUDDDDDDDDDDDDIi.................................................
> 18:57:39 SSSSSSSSUDDDDDDDDDi...................................................
> 18:57:40 SSSSSUUDDDDDDDDDDDDi..................................................
> 18:57:41 SSSSSUUUUUDDDDDDDDDDDDi...............................................
> 18:57:42 SSSSSUDDDDDDDDDDDDDIi.................................................
> 18:57:43 SSSUUDDDDDDDi.........................................................
>   (^^^^^^ IO-intensive task ends)
> 18:57:44 SUUUI.................................................................
> 18:57:45 SUUU..................................................................
> 18:57:46 UU....................................................................
> 18:57:47 U.....................................................................
> 
> This doesn't look bogus to me.
> It does give me information I need to know.

Hmm, but the iowait and idle stats are so racy that I would personally not trust such a
report.

Races are just too likely and potentially high frequency cumulated bugs. Imagine this simple one:

Imagine io task A sleeps on CPU 0. Then it wakes up elsewhere, runs for a while,
sleeps but not on IO for, say 1 minute.
During this time CPU 0 still sleeps.
Task A does short IO again and wakes up on CPU 0.
Cpu 0 just accounted more than 1 minute of iowait spuriously.

But I also realize that userspace code like this must rely on the fact that idle
time and iowait time are mutually exclusive. So perhaps we can't break the ABI
as easily as I thought.

Also the !NO_HZ behaviour still has the old semantics.

Haha, this interface is such well designed nightmare :-(

> 
> > Also it decouples iowait from idle time. Running time is also accounted
> > as iowait.
> 
> The time when CPUs are busy while there is IO-wait
> are usually not a sign of badly tuned software/system.
> 
> Only when CPUs are idle and there is IO-wait is.
>
> That's how it looks from userspace.

That's actually an artificial view that we made for userspace
because its implementation was convenient on !CONFIG_NO_HZ time.

In fact when I look at the history:

* Introduction of the buggy accounting 0224cf4c5ee0d7faec83956b8e21f7d89e3df3bd
* Use it for /proc/stat 7386cdbf2f57ea8cff3c9fde93f206e58b9fe13f

We tried to mimic the way we account iowait time in !CONFIG_NO_HZ
configurations where it's easy to distinguish idle/iowait time and to account
the iowait time per blocking CPU source using the periodic tick. Because it's
always there anyway. So we can tick on the blocking CPU source and poll on the
number of tasks that blocked there for the last time until they are
woken up somewhere else. Updates on iowait stats are then always local.

So we did it that way because it was handy to do so. Somehow the implementation
ease influenced the view.

Now with CONFIG_NO_HZ this artificial view doesn't scale anymore.
If we want to mimic the !CONFIG_NO_HZ  behaviour and do it correctly, we must
use remote updates instead of local updates helped by polling tick.

Thought?
