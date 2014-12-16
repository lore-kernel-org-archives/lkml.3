Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751194AbaLPO5M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 09:57:12 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:58481 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbaLPO5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 09:57:10 -0500
Date: Tue, 16 Dec 2014 15:56:53 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, LKP <lkp@01.org>
Subject: Re: [nohz] 2a16fc93d2c: kernel lockup on idle injection
Message-ID: <20141216145653.GY3337@twins.programming.kicks-ass.net>
References: <20141211194204.GA19083@wfg-t540p.sh.intel.com>
 <CAKohpokEw6f5+u8J_AoV76sOAQO=J8dGhX1eZb=QZOuE+Jhq_A@mail.gmail.com>
 <548E8D01.9050707@linux.vnet.ibm.com>
 <CAKohpo=C8Jv-+CtmDO+QJ-_=3dNwsk6_W0gtRRHmtSQ8_LgObQ@mail.gmail.com>
 <20141215234443.GA23297@lerouge>
 <CAKohpokOuOqvpNt4_y2tHPTM8nKLyEg=-gN4NDe1_mqpy=Vrow@mail.gmail.com>
 <548FFD20.1040102@linux.vnet.ibm.com>
 <alpine.DEB.2.11.1412161105470.17382@nanos>
 <alpine.DEB.2.11.1412161510000.17382@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1412161510000.17382@nanos>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2014 at 03:32:28PM +0100, Thomas Gleixner wrote:
> @@ -4997,6 +5025,8 @@ pick_next_task_fair(struct rq *rq, struct task_struct *prev)
>  	struct task_struct *p;
>  	int new_tasks;
>  
> +	if (class_fair_disabled())
> +		goto idle;

We don't want to do new idle balancing here I think, just return NULL.

>  again:
>  #ifdef CONFIG_FAIR_GROUP_SCHED
>  	if (!cfs_rq->nr_running)
> 
> The static key is enabled once the powerclamp mess starts. So nobody
> else than powerclamp users are affected by this and rightfully so.
> 
> Not pretty, but better than a gazillion workarounds all over the place
> to make "pretending I'm idle" actually work. This is basically the
> same mechanism as we have with the RT throttler, where a RT hog will
> be put onto hold for some time. We just put all sched other tasks on
> hold while still allowing RT tasks and everything else to work.
> 
> Thoughts?

Other than hating it on sight right? ;-)

So let me try and understand the problem with the emulated idle thing
better (running idle from FIFO threads).

Suppose we are in nohz_full:

 ts->inidle     ts->infullnohz  ts->tick_stopped

  0              1               1               valid

Then the powerclamp fake idle thread comes in, this increase nr_running
and will result in leaving infullnohz and will re-start the
tick_stopped.

 0              0               0               valid

Then we 'start' the idle loop, and end up in:

 1              0               1               valid

No problem there, right? And it looks to be the same in reverse.


I suppose the tricky bit is what happens when the cpu was idle; in that
case we'll end up with 1 running thread in state:

 1              0               1               valid

But need to avoid ending up in:

 1              1               1               BUG

Which should be relatively simple by never entering nohzfull when 'idle'.



However with your proposed thingy, I think we'll end up in:

 1              1               1               BUG

Because we don't start another thread, so infullnohz will stay valid,
however we'll also be 'forced' into idle (with nr_running > 0) and stop
the tick.

A remote wakeup might result in nr_running going from 1->2 and seeing
infullnohz == 1, try and restart the tick, while we're idle!

Of course, we can fix that too, by clearing nohzfull when going 'idle',
after all, nohzfull will re-establish itself automagically when the tick
detects but the one task afterwards.


So both cases need work, neither works out of the box afaict. But I
can't see one really being better than the other either -- am I missing
obvious things again?
