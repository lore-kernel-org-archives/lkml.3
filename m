Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751403AbaLPQzT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 11:55:19 -0500
Received: from www.linutronix.de ([62.245.132.108]:50921 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbaLPQzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 11:55:18 -0500
Date: Tue, 16 Dec 2014 17:54:58 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, LKP <lkp@01.org>
Subject: Re: [nohz] 2a16fc93d2c: kernel lockup on idle injection
In-Reply-To: <20141216145653.GY3337@twins.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.11.1412161741480.17382@nanos>
References: <20141211194204.GA19083@wfg-t540p.sh.intel.com> <CAKohpokEw6f5+u8J_AoV76sOAQO=J8dGhX1eZb=QZOuE+Jhq_A@mail.gmail.com> <548E8D01.9050707@linux.vnet.ibm.com> <CAKohpo=C8Jv-+CtmDO+QJ-_=3dNwsk6_W0gtRRHmtSQ8_LgObQ@mail.gmail.com> <20141215234443.GA23297@lerouge>
 <CAKohpokOuOqvpNt4_y2tHPTM8nKLyEg=-gN4NDe1_mqpy=Vrow@mail.gmail.com> <548FFD20.1040102@linux.vnet.ibm.com> <alpine.DEB.2.11.1412161105470.17382@nanos> <alpine.DEB.2.11.1412161510000.17382@nanos> <20141216145653.GY3337@twins.programming.kicks-ass.net>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Dec 2014, Peter Zijlstra wrote:
> On Tue, Dec 16, 2014 at 03:32:28PM +0100, Thomas Gleixner wrote:
> So let me try and understand the problem with the emulated idle thing
> better (running idle from FIFO threads).
> 
> I suppose the tricky bit is what happens when the cpu was idle; in that
> case we'll end up with 1 running thread in state:
> 
>  1              0               1               valid
> 
> But need to avoid ending up in:
> 
>  1              1               1               BUG
> 
> Which should be relatively simple by never entering nohzfull when 'idle'.

Well, yes. 
 
> However with your proposed thingy, I think we'll end up in:
> 
>  1              1               1               BUG
> 
> Because we don't start another thread, so infullnohz will stay valid,
> however we'll also be 'forced' into idle (with nr_running > 0) and stop
> the tick.

Indeed.
 
> A remote wakeup might result in nr_running going from 1->2 and seeing
> infullnohz == 1, try and restart the tick, while we're idle!
> 
> Of course, we can fix that too, by clearing nohzfull when going 'idle',
> after all, nohzfull will re-establish itself automagically when the tick
> detects but the one task afterwards.
> 
> So both cases need work, neither works out of the box afaict. But I

Agreed.

> can't see one really being better than the other either -- am I missing
> obvious things again?

No, it's both butt ugly, though what really bothers me is that we
pretend to be idle without being in the idle thread. That makes a lot
of stuff really weird.

Anything which relies on is_idle_task(current), idle_cpu() and a bunch
of other things just fail to work while we pretend being "the idle"
task.

That's just wrong. That powerclamp stuff needs to put the cpu
(including the scheduler, etc.) into a well defined state.

The fake idle task is everything else than well defined state, really.

Thanks,

	tglx

   

