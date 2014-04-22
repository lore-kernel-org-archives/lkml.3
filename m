Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907AbaDVT7w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 15:59:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:56037 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757330AbaDVT6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 15:58:34 -0400
Date: Tue, 22 Apr 2014 21:45:47 +0200
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
Subject: Re: [PATCH 2/2] nohz: delayed iowait accounting for nohz idle time
 stats
Message-ID: <20140422194547.GS13658@twins.programming.kicks-ass.net>
References: <534FA04B.8080906@jp.fujitsu.com>
 <534FA1D5.7040808@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <534FA1D5.7040808@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 06:41:41PM +0900, Hidetoshi Seto wrote:
> This patch is 2/2 of v4 patch set to fix an issue that idle/iowait
> of /proc/stat can go backward. Originally reported by Tetsuo and
> Fernando at last year, Mar 2013.
> 
> (Continued from previous patch 1/2.)
> 
> [PROBLEM 2]: broken iowait accounting.
> 
>   As historical nature, cpu's idle time was accounted as either
>   idle or iowait depending on the presence of tasks blocked by
>   I/O. No one complain about it for a long time. However:
> 
>   > Still trying to wrap my head around it, but conceptually
>   > get_cpu_iowait_time_us() doesn't make any kind of sense.
>   > iowait isn't per cpu since effectively tasks that aren't
>   > running aren't assigned a cpu (as Oleg already pointed out).
>   -- Peter Zijlstra
> 
>   Now some kernel folks realized that accounting iowait as per-cpu
>   does not make sense in SMP world. When we were in traditional
>   UP era, cpu is considered to be waiting I/O if it is idle while
>   nr_iowait > 0. But in these days with SMP systems, tasks easily
>   migrate from a cpu where they issued an I/O to another cpu where
>   they are queued after I/O completion.
> 
>   Back to NO_HZ mechanism. Totally terrible thing here is that
>   observer need to handle duration "delta" without knowing that
>   nr_iowait of sleeping cpu can be changed easily by woken tasks
>   even if cpu is sleeping. So it can happen that:
> 
>     given:
>       idle time stats: idle=1000, iowait=100
>       stamp at idle entry: entry=50
>       nr tasks waiting io: nr_iowait=1
> 
>     observer temporary assigns delta as iowait at 1st place,
>     (but does not do update (=account delta to time stats)):
>       1st reader's query @ now = 60:
>         idle=1000
>         iowait=110 (=100+(60-50))
> 
>     then blocked task is queued to runqueue of other active cpu,
>     woken up from io_schedule{,_timeout}() and do atomic_dec()
>     from the remote:
>       nr_iowait=0
> 
>     and at last in 2nd turn observer assign delta as idle:
>       2nd reader's query @ now = 70:
>         idle=1020 (=1000+(70-50))
>         iowait=100
> 
>   You will see that iowait is decreased from 110 to 100.
> 
>   In summary, the original problem that iowait of /proc/stats can
>   go backward is a kind of hidden bug, while at the same time iowait
>   accounting has fundamental problem and needs to be precisely
>   reworked.
> 
> [TARGET OF THIS PATCH]:
> 
>   Complete rework for iowait accounting implies that some user
>   interfaces might be replaced completely. It will introduce new
>   counter or so, and kill per-cpu iowait counter which is known to
>   being nonsense. It will take long time to be achieved, considering
>   time to make the problem to a public knowledge, and also time for
>   interface transition. Anyway as long as linux try to be reliable OS,
>   such drastic change must be placed on mainline kernel in development
>   sooner or later.
> 
>   OTOH, drastic change like above is not acceptable for conservative
>   environment, such as stable kernels, some distributor's kernel and
>   so on, due to respect for compatibility. Still these kernel expects
>   per-cpu iowait counter works as well as it might have been.
>   Therefore for such environment, applying a simple patch to fix
>   behavior of counter will be appreciated rather than replacing an
>   over-used interface or changing an existing usage/semantics.
> 
>   This patch targets latter kernels mainly. It does not do too much,
>   but intend to fix the idle stats counters to be monotonic. I believe
>   that mainline kernel should pick up this patch too, because it
>   surely fix a hidden bug and does not intercept upcoming drastic
>   change.
> 
>   Again, in summary, this patch does not do drastic change to cope
>   with problem 2. But it just fix behavior of idle/iowait counter of
>   /proc/stats.
> 
> [WHAT THIS PATCH PROPOSED]:
> 
>   The main reason of the bug is that observers have no idea to
>   determine the delta to be idle or iowait at the first place.
> 
>   So I introduced delayed iowait accounting to allow observers to
>   assign delta based on status of observed cpu at idle entry.
> 

So the problem I have with this is that it makes CONFIG_NOHZ=[ny]
kernels behave quite differently.

Ideally NOHZ=y and NOHZ=n behave the same, my proposed solution the
other day does just that. This one OTOH seems to generate entirely
different results between those kernels.

It also doesn't really simplify the code; there's quite a bit of
complexity introduced to paper over this silly stuff.
