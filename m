Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525AbaDOJNd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 05:13:33 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:48630 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbaDOJN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 05:13:28 -0400
Date: Tue, 15 Apr 2014 11:13:25 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arvind Chauhan <Arvind.Chauhan@arm.com>,
        Linaro Networking <linaro-networking@linaro.org>
Subject: Re: [PATCH 29/38] tick-sched: remove wrapper around
 __tick_nohz_task_switch()
Message-ID: <20140415091323.GK1877@localhost.localdomain>
References: <cover.1397492345.git.viresh.kumar@linaro.org>
 <b38dda39bf6cd18df5fab86f7c7cc86a6979786f.1397492345.git.viresh.kumar@linaro.org>
 <20140414232218.GE1877@localhost.localdomain>
 <CAKohpomKrQydz12mXQnQe8sw3X-OotRqLDCxQFi5goyk6D9-=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKohpomKrQydz12mXQnQe8sw3X-OotRqLDCxQFi5goyk6D9-=w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 10:15:24AM +0530, Viresh Kumar wrote:
> On 15 April 2014 04:52, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > On Mon, Apr 14, 2014 at 09:53:51PM +0530, Viresh Kumar wrote:
> >> __tick_nohz_task_switch() was called only from tick_nohz_task_switch() and there
> >> is nothing much in tick_nohz_task_switch() as well. IOW, we don't need
> >> unnecessary wrapper over __tick_nohz_task_switch() to be there. Merge all code
> >> from __tick_nohz_task_switch() into tick_nohz_task_switch() and move it to
> >> tick-sched.c.
> >>
> >> This also moves check for tick_nohz_tick_stopped() outside of irq_save()
> >> context.
> >
> > No, the wrapper is there on purpose in order to optimize the full dynticks off case in
> > the context switch path with the jump label'ed check on tick_nohz_full_enabled().
> 
> Just to clarify, you are saying that:
> 
> Wrapper was there to save an extra function call when tick_nohz_full_enabled()
> returns false, as tick_nohz_task_switch() will be inlined ?

Yeah. But not just that.

Using an inline saves a function call and reduce the offline case to a simple
condition check. But there is also the jump label that reduce the condition check
to an unconditional jump in the off case.

To summarize, here's how calling tick_nohz_task_switch() maps to final C code:

finish_task_switch()
{
       //do things before calling tick_nohz_task_switch()...
       // call tick_nohz_task_switch
       goto offcase;
       if (tick_nohz_full_enabled())
           __tick_nohz_task_switch(tsk);
offcase:
      //end of call to tick_nohz_task_switch
      //do things before calling tick_nohz_task_switch()...
}

In the offcase, the code is like above. We don't even do the check, thanks to
the jump label code we unconditionally jump to what's next in finish_task_switch()
(there is actually nothing afterward but that's for the picture).

Now if there is at least a CPU that is full dynticks on boot, it is enabled
with context_tracking_cpu_set(). Then the jump label code patches the code in
finish_task_switch() to turn the goto offcase into a nop. Then the condition is
actually verified on every call to finish_task_switch().

So it goes beyond than just saving a function call.

> 
> In this case probably we can move !can_stop_full_tick() as well to the wrapper ?

Do you mean moving all the code of __tick_nohz_task_switch() to tick_nohz_task_switch()?
I much prefer we don't do that. This is going to make can_stop_full_tick() a publicly
visible nohz internal. And it may uglify tick.h as well.
