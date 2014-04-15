Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208AbaDOJxk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 05:53:40 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:47252 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbaDOJxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 05:53:37 -0400
MIME-Version: 1.0
In-Reply-To: <20140415091323.GK1877@localhost.localdomain>
References: <cover.1397492345.git.viresh.kumar@linaro.org>
	<b38dda39bf6cd18df5fab86f7c7cc86a6979786f.1397492345.git.viresh.kumar@linaro.org>
	<20140414232218.GE1877@localhost.localdomain>
	<CAKohpomKrQydz12mXQnQe8sw3X-OotRqLDCxQFi5goyk6D9-=w@mail.gmail.com>
	<20140415091323.GK1877@localhost.localdomain>
Date: Tue, 15 Apr 2014 15:23:37 +0530
Message-ID: <CAKohpokVAbD=ym9c6UpRjbWnmzMbTwukgMo1_h+VOeRyPXxZKQ@mail.gmail.com>
Subject: Re: [PATCH 29/38] tick-sched: remove wrapper around __tick_nohz_task_switch()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arvind Chauhan <Arvind.Chauhan@arm.com>,
        Linaro Networking <linaro-networking@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 April 2014 14:43, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> Yeah. But not just that.
>
> Using an inline saves a function call and reduce the offline case to a simple
> condition check. But there is also the jump label that reduce the condition check
> to an unconditional jump in the off case.
>
> To summarize, here's how calling tick_nohz_task_switch() maps to final C code:
>
> finish_task_switch()
> {
>        //do things before calling tick_nohz_task_switch()...
>        // call tick_nohz_task_switch
>        goto offcase;
>        if (tick_nohz_full_enabled())
>            __tick_nohz_task_switch(tsk);
> offcase:
>       //end of call to tick_nohz_task_switch
>       //do things before calling tick_nohz_task_switch()...
> }
>
> In the offcase, the code is like above. We don't even do the check, thanks to
> the jump label code we unconditionally jump to what's next in finish_task_switch()
> (there is actually nothing afterward but that's for the picture).
>
> Now if there is at least a CPU that is full dynticks on boot, it is enabled
> with context_tracking_cpu_set(). Then the jump label code patches the code in
> finish_task_switch() to turn the goto offcase into a nop. Then the condition is
> actually verified on every call to finish_task_switch().
>
> So it goes beyond than just saving a function call.

Sorry, but my poor mind still couldn't understand what you are trying to
tell me :(

So lets clarify things one by one :)

- What do you mean by offcase? CONFIG_NO_HZ_FULL not configured
into the kernel or it is configured but none of the CPUs is running in that
mode?

- Also what does it correspond to in code: goto offcase; ? There is no labels
or goto statements in code that I can see.. This is how the code looks to me.

> finish_task_switch()
> {
>        //do things before calling tick_nohz_task_switch()...
>        // call tick_nohz_task_switch
>        if (tick_nohz_full_enabled())
>            __tick_nohz_task_switch(tsk);
> }

__tick_nohz_task_switch() may or maynot be available at all depending
on CONFIG_NO_HZ_FULL is enabled into the kernel or not. But that
was the case with tick_nohz_task_switch() as well in my patch. So
shouldn't make a difference..

Again, sorry for not understanding what you are trying to explain here.
I want to understand this once and for all and probably add a comment
here as well :)

--
viresh
