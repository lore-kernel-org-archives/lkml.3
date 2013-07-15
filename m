Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308Ab3GOUTy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 16:19:54 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48621 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755020Ab3GOUTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 16:19:51 -0400
Date: Mon, 15 Jul 2013 22:19:45 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] sched: Add logic to handle parallel try_to_wake_up() of
 the same task
Message-ID: <20130715201945.GQ17211@twins.programming.kicks-ass.net>
References: <1517081373730349@web23d.yandex.ru>
 <20130715063150.GL17211@twins.programming.kicks-ass.net>
 <449471373897674@web23d.yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <449471373897674@web23d.yandex.ru>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 15, 2013 at 06:14:34PM +0400, Kirill Tkhai wrote:
> >>
> >>   #ifdef CONFIG_SMP
> >>  + p->state = TASK_WAKING;
> >>  + smp_wmb();
> >>  +
> >
> > This too is broken; the loop below needs to be completed first,
> > otherwise we change p->state while the task is still on the CPU and it
> > might read the wrong p->state.
> 
> This place is below (on_rq && ttwu_remote) check, so the task
> either 'dequeued and on_cpu == 0'
> or it's in the middle of schedule() on arch, which wants unlocked
> context switch.
> 
> Nobody scheduler's probes p->state between prepare_lock_switch() and
> finish_lock_switch(). Archs with unlocked ctx switch (mips and ia64)
> don't change or probe state of previous process during context_switch.

It means its after deactivate_task(), but before context_switch(). It so
happens that
context_switch()->prepare_task_switch()->trace_sched_switch() inspects
p->state.

Even if this was not the case, touching a task that is 'life' on another
CPU is very _very_ bad practise.
