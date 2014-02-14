Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129AbaBNMdM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 07:33:12 -0500
Received: from relay.parallels.com ([195.214.232.42]:57673 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932AbaBNMdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 07:33:10 -0500
Message-ID: <1392381205.5384.39.camel@tkhai>
Subject: Re: [PATCH] sched/core: Create new task with twice disabled
 preemption
From: Kirill Tkhai <ktkhai@parallels.com>
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Kirill Tkhai <tkhai@yandex.ru>, Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Date: Fri, 14 Feb 2014 16:33:25 +0400
In-Reply-To: <20140214122152.GD10590@arm.com>
References: <1392306716.5384.3.camel@tkhai>
	 <20140213160013.GE6835@laptop.programming.kicks-ass.net>
	 <52FD01A6.8060404@yandex.ru> <20140214105255.GA10596@arm.com>
	 <1392376569.5384.25.camel@tkhai> <20140214122152.GD10590@arm.com>
Organization: Parallels
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.30.26.172]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

В Птн, 14/02/2014 в 12:21 +0000, Catalin Marinas пишет:
> On Fri, Feb 14, 2014 at 11:16:09AM +0000, Kirill Tkhai wrote:
> > В Птн, 14/02/2014 в 10:52 +0000, Catalin Marinas пишет:
> > > On Thu, Feb 13, 2014 at 09:32:22PM +0400, Kirill Tkhai wrote:
> > > > Look at ARM64's finish_arch_post_lock_switch(). It looks a task
> > > > must to not be preempted between switch_mm() and this function.
> > > > But in case of new task this is possible.
> > > 
> > > We had a thread about this at the end of last year:
> > > 
> > > https://lkml.org/lkml/2013/11/15/82
> > >
> > > There is indeed a problem on arm64, something like this (and I think
> > > s390 also needs a fix):
> > > 
> > > 1. switch_mm() via check_and_switch_context() defers the actual mm
> > >    switch by setting TIF_SWITCH_MM
> > > 2. the context switch is considered 'done' by the kernel before
> > >    finish_arch_post_lock_switch() and therefore we can be preempted to a
> > >    new thread before finish_arch_post_lock_switch()
> > > 3. The new thread has the same mm as the preempted thread but we
> > >    actually missed the mm switching in finish_arch_post_lock_switch()
> > >    because TIF_SWITCH_MM is per thread rather than mm
> > > 
> > > > This is the problem I tried to solve. I don't know arm64, and I can't
> > > > say how it is serious.
> > > 
> > > Have you managed to reproduce this? I don't say it doesn't exist, but I
> > > want to make sure that any patch actually fixes it.
> > 
> > No, I have not tried. I found this place while analysing scheduler code.
> > But it seems with the RT technics suggested previous message it's quite
> > possible.
> 
> Now I think I confused myself. Looking through the __schedule() code,
> context_switch() and therefore finish_arch_post_lock_switch() are called
> with preemption disabled. So the scenario above cannot exist since the
> current thread cannot be preempted between switch_mm() and
> finish_arch_post_lock_switch(). Do I miss anything?

Everything is right, the only case, which we have to worry, is
schedule_tail()

> Now I get your point about schedule_tail() which calls
> finish_task_switch() with a preempt count of 0. I'll get back to your
> original patch.
> 
> Thanks.
> 

Kirill

