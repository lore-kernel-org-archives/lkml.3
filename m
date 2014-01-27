Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082AbaA0RJp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 12:09:45 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:32158 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753539AbaA0RJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 12:09:42 -0500
Date: Mon, 27 Jan 2014 12:09:38 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Luca Abeni <luca.abeni@unitn.it>
Cc: Juri Lelli <juri.lelli@gmail.com>, peterz@infradead.org,
        tglx@linutronix.de, mingo@redhat.com, oleg@redhat.com,
        fweisbec@gmail.com, darren@dvhart.com, johan.eker@ericsson.com,
        p.faure@akatech.ch, linux-kernel@vger.kernel.org,
        claudio@evidence.eu.com, michael@amarulasolutions.com,
        fchecconi@gmail.com, tommaso.cucinotta@sssup.it,
        nicola.manica@disi.unitn.it, dhaval.giani@gmail.com, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, raistlin@linux.it, insop.song@gmail.com,
        liming.wang@windriver.com, jkacur@redhat.com,
        harald.gustafsson@ericsson.com, vincent.guittot@linaro.org,
        bruce.ashfield@windriver.com, linux-doc@vger.kernel.org,
        rob@landley.net
Subject: Re: [PATCH] sched/deadline: Add sched_dl documentation
Message-ID: <20140127120938.3a8d40fb@gandalf.local.home>
In-Reply-To: <20140127175607.1f99491c@luca-1225C>
References: <1390821615-23247-1-git-send-email-juri.lelli@gmail.com>
	<20140127103556.02d82e02@gandalf.local.home>
	<20140127175607.1f99491c@luca-1225C>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Jan 2014 17:56:07 +0100
Luca Abeni <luca.abeni@unitn.it> wrote:
 
> > > +
> > > +    then, if the scheduling deadline is smaller than the current
> > > time, or
> > > +    this condition is verified, the scheduling deadline and the
> > > +    current budget are re-initialised as
> > > +
> > > +         scheduling deadline = current time + deadline
> > > +         current runtime = runtime
> > > +
> > > +    otherwise, the scheduling deadline and the current runtime are
> > > +    left unchanged;
> > 
> > I've been trying to wrap my head around this a bit. I started writing
> > an email about this when I first examined the patches and never sent
> > it out :-p
> > 
> > Lets take a case where deadline == period. It seems that the above
> > would be true any time there was any delay to starting the task or the
> > task was interrupted by another SCHED_DEADLINE task.
> Not sure about this... Notice that above only applies when a task wakes
> up (moving from a "sleeping" state to a "ready to run" state). Not when
> an already ready task is scheduled.
> Or did I misunderstand your comment?

No no, you understood, I missed that this only happens on wakeup. But
then I have to ask, what happens if the task blocks on a mutex? Would
that cause this check to happen then? It may be nice to add some
comments about exactly when this check is performed.

> 
> 
> > For example, lets say we have two SD tasks. One that has 50ms runtime
> > and a 100ms period. The other has a 1ms runtime and a 10ms period.
> > 
> > The above two should work perfectly fine together. The 10ms period
> > task will constantly schedule in on the 100ms task.
> > 
> > When the 100ms task runs, it could easily be delayed by 1ms due to the
> > 10ms task. Then lets look at the above equation
> See above: the check for the 100ms task is only performed when the task
> unblocks (at the beginning of its period), not when it's scheduled
> (after the 10ms taks).
> 
> This check is designed to take care of the following situation:
> - consider a task with runtime 10ms and period equal to deadline equal
>   to 100ms
> - assume the task wakes up at time t, and is assigned "remaining
>   runtime" 10ms and "scheduling deadline" t+100ms
> - assume the task blocks after executing for 2ms. The "remaining
>   runtime" is now 8ms
> - can the task use "remaining runtime" 8ms and "scheduling deadline"
>   t+100ms when it wakes up again?
>   Answer: if it wakes up before t+20ms, it can. Otherwise, it cannot,
>   because it would consume a fraction of CPU time larger than 10%,
>   causing missed deadlines in other tasks.

Ah, you answered my question here. The check happens every time the
task blocks as well. I still need to read the papers, and even more
importantly, start running more tests with tracing on to review what
exactly happens in the implementation.

> 
> [...]
> > > + SCHED_DEADLINE can be used to schedule real-time tasks
> > > guaranteeing that
> > > + the jobs' deadlines of a task are respected. In order to do this,
> > > a task
> > > + must be scheduled by setting:
> > > +
> > > +  - runtime >= WCET
> > > +  - deadline = D
> > > +  - period <= P
> > > +
> > > + IOW, if runtime >= WCET and if period is >= P, then the
> > > scheduling deadlines
> > > + and the absolute deadlines (d_j) coincide, so a proper admission
> > > control
> > > + allows to respect the jobs' absolute deadlines for this task
> > > (this is what is
> > > + called "hard schedulability property" and is an extension of
> > > Lemma 1 of [2]).
> > 
> > I wonder if we should state the obvious (which is never obvious). That
> > is the user must also have the following.
> > 
> >   runtime < deadline <= period
> > 
> > Although it is fine for deadline = period, runtime should be less than
> > deadline, otherwise the task will take over the system.
> I think if "runtime < deadline <= period" is not respected, then the
> admission control will fail... But yes, repeating it here can be
> useful. If needed I'll add it to the document.

Yeah, it's one of those things that you should know, but I can see
users screwing it up ;-)

-- Steve

