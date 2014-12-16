Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751006AbaLPOUj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 09:20:39 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:52624 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbaLPOUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 09:20:37 -0500
Date: Tue, 16 Dec 2014 15:20:33 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, LKP <lkp@01.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [nohz] 2a16fc93d2c: kernel lockup on idle injection
Message-ID: <20141216142029.GA27375@lerouge>
References: <20141211194204.GA19083@wfg-t540p.sh.intel.com>
 <CAKohpokEw6f5+u8J_AoV76sOAQO=J8dGhX1eZb=QZOuE+Jhq_A@mail.gmail.com>
 <548E8D01.9050707@linux.vnet.ibm.com>
 <CAKohpo=C8Jv-+CtmDO+QJ-_=3dNwsk6_W0gtRRHmtSQ8_LgObQ@mail.gmail.com>
 <20141215234443.GA23297@lerouge>
 <CAKohpokOuOqvpNt4_y2tHPTM8nKLyEg=-gN4NDe1_mqpy=Vrow@mail.gmail.com>
 <548FFD20.1040102@linux.vnet.ibm.com>
 <alpine.DEB.2.11.1412161105470.17382@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1412161105470.17382@nanos>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2014 at 01:49:03PM +0100, Thomas Gleixner wrote:
> And that's where the whole problem starts. The nohz full stuff is
> trying to evaluate everything dynamically which is just insane.
> 
> So we want to have functions which do:
> 
>    tick_nohz_full_enter()
>      ts->infullnohz = true;
>      if (stop_possible)
>      	stop_tick(ts);
> 
>    tick_nohz_full_exit()
>      ts->infullnohz = false;
>      if (ts->tick_stopped)
>      	start_tick(ts);
> 
> Plus irq_exit would become:     
> 
> irq_exit
> 	if (ts->inidle)
> 	   tick_nohz_update_sched_tick();
> 
> 	else if (ts->infullnohz)
> 	   tick_nohz_full_update_sched_tick();

So I can do that indeed. But then it's going to break the jump label that's
off in 99.99% of the case.

Now I can wrap that into parallel functions:

irq_exit
	if (tick_nohz_idle())
	   tick_nohz_update_sched_tick();

	else if (tick_nohz_full())
	   tick_nohz_full_update_sched_tick();

Just to be sure I understand you well. By ts->infullnohz, you mean the fact
that a CPU _wants_ to be in full nohz, not whether it _can_ right? Whether
the CPU wants to be in full nohz is decided in boottime with nohz_full= parameter.
Whether it can is dynamically checked on top of scheduler, perf, posix cpu timers, etc...

But I agree with you on the design. First check which nohz flavour we are
under, second call the appropriate function. That's what it actually does but
it's badly buried in functions, I'm going to fix that.

> 
> You need to keep track of the fact that the cpu entered fullnohz and
> work from there. Whether the tick is stopped or not does not matter at
> all because that is a seperate decision like in the nohz idle case.
> 
> Everything else is voodoo programming.
> 
> Now the powerclamp mess is a different story.
> 
> Calling tick_nohz_idle_enter()/exit() from outside the idle task is
> just broken. Period.
> 
> Trying to work around that madness in the core code is just fiddling
> with the symptoms and ignoring the root cause. And the root cause is
> simply that powerclamp calls tick_nohz_idle_enter()/exit().
> 
> So there are two things to solve:
> 
>    1) Remove the powerclamp stupidity
> 
>    2) Fix the whole nohz full mess with proper state tracking.
> 
> If you folks insist on curing the symptoms and ignoring the root
> causes I'm going to mark NOHZ_FULL broken and NOHZ depend on
> POWERCLAMP=n.
> 
> The commit in question, does not really cause a regression, it merily
> unearths the utter broken crap which existed before in both NOHZ FULL
> and powerclamp and just ever worked by chance.

Agreed.

Thanks.
