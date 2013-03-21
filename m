Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177Ab3CUUmF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 16:42:05 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:47785 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746Ab3CUUmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 16:42:03 -0400
MIME-Version: 1.0
In-Reply-To: <0000013d8e8d24fd-d2931c45-2722-46d1-8b47-2ef11e21096d-000000@email.amazonses.com>
References: <CAFTL4hybMf+9GjjyKRSEEp0x+wT7OwpKShE5sR_JqW24DGfKOw@mail.gmail.com>
	<1363636794.15703.32@driftwood>
	<CAFTL4hz=VKCchgvKcSHbctZcRyjCSmCbLu6OhLz0zEcYA20zOQ@mail.gmail.com>
	<20130318222548.GG3656@linux.vnet.ibm.com>
	<1363822338.6345.33.camel@gandalf.local.home>
	<20130320235545.GL3637@linux.vnet.ibm.com>
	<0000013d8db514e4-bf492080-82c9-412a-90b8-54ddc1463e4b-000000@email.amazonses.com>
	<20130321171518.GW3637@linux.vnet.ibm.com>
	<0000013d8e3f58ce-0f6ea95f-780a-49c1-a633-5aa0cf3e5040-000000@email.amazonses.com>
	<20130321185821.GF3637@linux.vnet.ibm.com>
	<0000013d8e8d24fd-d2931c45-2722-46d1-8b47-2ef11e21096d-000000@email.amazonses.com>
Date: Thu, 21 Mar 2013 21:42:00 +0100
Message-ID: <CAFTL4hywucK7_d2V-wYkhagu0+izYz_MTFNJEHEsaTvoZBXwMg@mail.gmail.com>
Subject: Re: [PATCH] nohz1: Documentation
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>, Rob Landley <rob@landley.net>,
        linux-kernel@vger.kernel.org, josh@joshtriplett.org,
        zhong@linux.vnet.ibm.com, khilman@linaro.org, geoff@infradead.org,
        tglx@linutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/21 Christoph Lameter <cl@linux.com>:
> On Thu, 21 Mar 2013, Paul E. McKenney wrote:
>> So, again, removing scheduling-clock interrupts in more situations is
>> a good future enhancement.
>
> The point here is that the check for a single runnable process is wrong
> because it accounts for tasks in all scheduling classes.
>
> It would be better to check if there is only one runnable task in the
> highest scheduling class. That would work and defer the SCHED_OTHER kernel
> threads for the SCHED_FIFO thread.

It sounds that simple but it's more complicated. It requires some more
hooks on the scheduler, namely in the sched_switch/dequeue path so
that when the last task of a class goes to sleep, we check what else
is running and whether we need to restart the tick or not depending on
the class of the next task and how many tasks are there.

This will probably need to go in sched_class::dequeue_task(). There is
some careful and subtle attention to put on that.

Of course we want to improve that in the long run. But for now we have
a KISS solution that works. And like Steve said, the patchset is
complicated enough. Move baby steps forward to ease the upstream
integration.

> I am wondering how you actually can get NOHZ to work right? There is
> always a kernel thread that is scheduled in a couple of ticks.
>
> I guess what will happens with this patchset is:
>
> 1. SCHED_FIFO thread begins to run. There is only a single runnable task
> so adaptive tick mode is enabled.
>
> 2. After 2 seconds or so some or other thing needs to run (keventd thread
> needs to run vm statistics f.e.). It becomes runnable. nr_running > 1.
> Adaptive tick mode is disabled? Occurs on my system. Or is there some
> other trick to avoid kernel threads becoming runnable?
>
> 3. Now there are 2 runnable processes. The SCHED_FIFO thread continues to
> run with the tick. The kernel thread is also runnable but will not be
> given cpu time since the SCHED_FIFO thread has priority?
>
> So the SCHED_FIFO thread enjoys 2 seconds of no tick time and then ticks
> occur uselessly from there on?
>
>
> I have not been able to consistently get the tick switched off with
> the nohz patchset. How do others use nohz? Is it only usable for short
> periods of less than 2 seconds?

Sure, for now just don't use SCHED_FIFO and you will have a much more
extended dynticks coverage.
