Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754332AbaDOKFS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 06:05:18 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54320 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbaDOKFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 06:05:11 -0400
Date: Tue, 15 Apr 2014 12:04:48 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org,
        Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Denys Vlasenko <vda.linux@googlemail.com>, stable@vger.kernel.org
Subject: Re: [PATCH 2/2] nohz: use delayed iowait accounting to avoid race on
 idle time stats
Message-ID: <20140415100448.GM11096@twins.programming.kicks-ass.net>
References: <53465F54.708@jp.fujitsu.com>
 <534660D2.1080505@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <534660D2.1080505@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2014 at 06:13:54PM +0900, Hidetoshi Seto wrote:
> This patch is v3 of patch set to fix an issue that idle/iowait
> of /proc/stat can go backward. Originally reported by Tetsuo and
> Fernando at last year, Mar 2013.
> 
> [BACKGROUNDS]: idle accounting on NO_HZ
> 
> If NO_HZ is enabled, cpu stops tick interrupt for itself before
> go sleep to be idle. It means that time stats of the sleeping cpu
> will not be updated in tick interrupt. Instead when cpu wakes up,
> it updates time stats by calculating idle duration time from
> timestamp at entering idle and current time as exiting idle.
> 
> OTOH, it can happen that there are some kind of observer who want
> to know how long the sleeping cpu have been idle. Imagine that
> userland runs top command or application who read /proc/stats.
> Therefore kernel provides get_cpu_{idle,iowait}_time_us() function
> for user to obtain current idle time stats of such sleeping cpu.
> This function reads time stats and timestamp at entering idle,
> and then return current idle time by adding duration calculated
> from timestamp and current time.
> 
> There are 2 problems:
> 
> [PROBLEM 1]: there is no exclusive control.
> 
> It is easy to understand that there are 2 different cpu - an
> observing cpu where running a program observing idle cpu's stat
> and an observed cpu where performing idle. It means race can
> happen if observed cpu wakes up while it is observed. Observer
> can accidentally add calculated duration time (say delta) to
> time stats which is just updated by woken cpu. Soon correct
> idle time is returned in next turn, so it will result in
> backward time. Therefore readers must be excluded by writer.
> 
> My former patch happily changes get_cpu_{idle,iowait}_time_us()
> not to update sleeping cpu's time stats from observing cpu.
> It makes time stats to be updated by woken cpu only, so there
> are only one writer now!
> 
> In summary there are races between one writer and multiple
> reader but no exclusive control on this idle time stats dataset.

This should've gone in the previous patch; as it describes what that
does.

> 
> [PROBLEM 2]: broken iowait accounting.
> 
> As historical nature, cpu's idle time was accounted as either
> idle or iowait depending on the presence of tasks blocked by
> I/O. No one complain about it for a long time. However:
> 
>   > Still trying to wrap my head around it, but conceptually
>   > get_cpu_iowait_time_us() doesn't make any kind of sense.
>   > iowait isn't per cpu since effectively tasks that aren't
>   > running aren't assigned a cpu (as Oleg already pointed out).
>   -- Peter Zijlstra
> 
> Now some kernel folks realized that accounting iowait as per-cpu
> does not make sense in SMP world. When we were in traditional
> UP era, cpu is considered to be waiting I/O if it is idle while
> nr_iowait > 0. But in these days with SMP systems, tasks easily
> migrate from a cpu where they issued an I/O to another cpu where
> they are queued after I/O completion.
> 
> Back to NO_HZ mechanism. Totally terrible thing here is that
> observer need to handle duration "delta" without knowing that
> nr_iowait of sleeping cpu can be changed easily by migration
> even if cpu is sleeping. So it can happen that:
> 
>   given:
>     idle time stats: idle=1000, iowait=100
>     stamp at idle entry: entry=50
>     nr tasks waiting io: nr_iowait=1
> 
>   observer temporary assigns delta as iowait at 1st place,
>   (but does not do update (=account delta to time stats)):
>     1st reader's query @ now = 60:
>       idle=1000
>       iowait=110 (=100+(60-50))
> 
>   then blocked tasks are migrated all:
>     nr_iowait=0
> 
>   and at last in 2nd turn observer assign delta as idle:
>     2nd reader's query @ now = 70:
>       idle=1020 (=1000+(70-50))
>       iowait=100
> 
> You will see that iowait is decreased from 110 to 100.
> 
> In summary iowait accounting has fundamental problem and needs
> to be precisely reworked. It implies that some user interfaces
> might be replaced completely. It will take long time to be
> solved, so workaround for compatibility will be appreciated.

This isn't actually true. The way the current ->nr_iowait accounting
works is that we inc/dec against the cpu the task went to sleep on. So
task migration won't actually affect nr_iowait. The only way to
decrement nr_iowait is to wake a task.

That's of course still complete crap, imagine a task going into iowait
sleep on CPU1 at t0. At t1 it wakes on CPU0, but CPU1 stays in nohz
sleep. Then at t2 CPU1 wakes and updates its sleep times.

Between t0 and t1 a reader will observe iowait on CPU1 and report iowait
+ x; x < t1 - t0. However a reader at >=t1 will observe no iowait and
report the old iowait time again but an increased idle time. Furthermore
when at t2 CPU1 wakes it will observe no iowait and account the entire
duration as idle, the iowait never happened.


