Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853AbaDDQDi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 12:03:38 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:46102 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753078AbaDDQDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 12:03:36 -0400
Date: Fri, 4 Apr 2014 18:03:32 +0200
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
Message-ID: <20140404160328.GA10042@localhost.localdomain>
References: <5338CC86.9080602@jp.fujitsu.com>
 <5338CE0B.1050100@jp.fujitsu.com>
 <CAK1hOcMmmq=5EVLBrAd44HC+EHrnztABU48gd9BgK+LUNBJSOQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK1hOcMmmq=5EVLBrAd44HC+EHrnztABU48gd9BgK+LUNBJSOQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guys,

You and Hidetoshi have sent a few patches with very detailed changelogs
and it's going to be hard to synthesize. So my reviews are going to be a
bit chaotic, sorry for that in advance.

On Wed, Apr 02, 2014 at 09:35:47PM +0200, Denys Vlasenko wrote:
> On Mon, Mar 31, 2014 at 4:08 AM, Hidetoshi Seto
> <seto.hidetoshi@jp.fujitsu.com> wrote:
> > There are 2 problems:
> >
> > [PROBLEM 1]: there is no exclusive control.
> >
> > It is easy to understand that there are 2 different cpu - an
> > observing cpu where running a program observing idle cpu's stat
> > and an observed cpu where performing idle. It means race can
> > happen if observed cpu wakes up while it is observed. Observer
> > can accidentally add calculated duration time (say delta) to
> > time stats which is just updated by woken cpu. Soon correct
> > idle time is returned in next turn, so it will result in
> > backward time. Therefore readers must be excluded by writer.
> >
> > Then time stats are updated by woken cpu so there are only one
> > writer, right? No, unfortunately no. I'm not sure why are they,
> > but in some reason the function get_cpu_{idle,iowait}_time_us()
> > has ability to update sleeping cpu's time stats from observing
> > cpu. From grep of today's kernel tree, this feature is used by
> > cpufreq module. Calling this function with this feature in
> > periodically manner works like emulating tick for sleeping cpu.
> 
> Frederic's patches started by moving all updates
> to tick_nohz_stop_idle(), makign the above problem easier -
> get_cpu_{idle,iowait}_time_us() are pure readers.
> 
> The patches are here:
> 
> https://lkml.org/lkml/2013/10/19/86

Yeah definetly we should limit the update areas to local updates
from idle when possible.

The get_cpu_..time_us() should try to read with seqcount to deduce
the right delta since last update.

> 
> > [PROBLEM 2]: broken iowait accounting.
> >
> > As historical nature, cpu's idle time was accounted as either
> > idle or iowait depending on the presence of tasks blocked by
> > I/O. No one complain about it for a long time. However:
> >
> >   > Still trying to wrap my head around it, but conceptually
> >   > get_cpu_iowait_time_us() doesn't make any kind of sense.
> >   > iowait isn't per cpu since effectively tasks that aren't
> >   > running aren't assigned a cpu (as Oleg already pointed out).
> >   -- Peter Zijlstra
> >
> > Now some kernel folks realized that accounting iowait as per-cpu
> > does not make sense in SMP world. When we were in traditional
> > UP era, cpu is considered to be waiting I/O if it is idle while
> > nr_iowait > 0. But in these days with SMP systems, tasks easily
> > migrate from a cpu where they issued an I/O to another cpu where
> > they are queued after I/O completion.
> 
> However, if we would put ourselves into admin's seat, iowait
> immediately starts to make sense: for admin, the system state
> where a lot of CPU time is genuinely idle is qualitatively different
> form the state where a lot of CPU time is "idle" because
> we are I/O bound.
> 
> Admins probably wouldn't insist that iowait accounting must be
> very accurate. I would hazard to guess that admins would settle
> for the following rules:

Iowait makes sense but not per cpu. Eventually it's a global
stat. Or per task.

I've sratched my head a lot on this. And I think we can't continue
with the current semantics. If we had to keep the current semantics
and enforce correctness at the same time, we are going to run into
big scalability and performance issues. This can't be done without
locking updates to nr_iowait() with seqlock:

* when a task blocks on IO and goes idle, lock some per cpu iowait_seq,
increase nr_iowait, save curr CPU number, save time.

* when a task io completes and it gets enqueued on another CPU: retrieve
old CPU, lock its iowait_seq, decrease nr_iowait, flush delta iowait .

And all that just to maintain stats which semantics are wrong, this
would be pure madness.

OTOH we must stay compatible with user ABI in /proc/stat (the one in /proc/timers_list
matters less).  But if we make it a per task stat, we are free to account it
on the CPU we want.

So what we can do for example is to account it per task and update stats
on the CPU where the blocking task wakes up. This way we guarantee
that we only account locally, which is good for scalability.

This is going to be an ABI change on a /proc/stat field semantic.
We usually can not do that as it can break userspace. But I think
we have a reasonable exception here:

1) On a performance POV we don't have the choice.

2) It has always been a buggy stat on SMP. Given the possible fast iowait update
rate, I doubt it has ever dumped correct stats. So I guess that few user apps
have ever correctly relied on it. 

Also it decouples iowait from idle time. Running time is also accounted
as iowait. But then again, since an iowait task is not attached to any CPU,
accounting iowait time only when a specific CPU is idle doesn't make sense.

Oh and the kernel API is not a problem either. Only cpufreq use it IIRC. But
I've been told it's only for a few old intel CPUs. Now given how buggy the stat
is, I doubt it worked correctly.

Anyway, the first step will be to remove the cpufreq API use.

Thanks.
