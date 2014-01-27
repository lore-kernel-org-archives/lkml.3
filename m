Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009AbaA0W3l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 17:29:41 -0500
Received: from mail1.unitn.it ([193.205.206.20]:55442 "EHLO mail1.unitn.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753413AbaA0W3j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 17:29:39 -0500
Date: Mon, 27 Jan 2014 23:29:22 +0100
From: Luca Abeni <luca.abeni@unitn.it>
To: Steven Rostedt <rostedt@goodmis.org>
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
Message-ID: <20140127232922.667593ca@luca-1225C>
In-Reply-To: <20140127120938.3a8d40fb@gandalf.local.home>
References: <1390821615-23247-1-git-send-email-juri.lelli@gmail.com>
	<20140127103556.02d82e02@gandalf.local.home>
	<20140127175607.1f99491c@luca-1225C>
	<20140127120938.3a8d40fb@gandalf.local.home>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

On Mon, 27 Jan 2014 12:09:38 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:
[...]
> > > Lets take a case where deadline == period. It seems that the above
> > > would be true any time there was any delay to starting the task
> > > or the task was interrupted by another SCHED_DEADLINE task.
> > Not sure about this... Notice that above only applies when a task
> > wakes up (moving from a "sleeping" state to a "ready to run"
> > state). Not when an already ready task is scheduled.
> > Or did I misunderstand your comment?
> 
> No no, you understood, I missed that this only happens on wakeup. But
> then I have to ask, what happens if the task blocks on a mutex? Would
> that cause this check to happen then?
Well, in theory, this check has to be performed every time the task
wakes up from any kind of sleeping (mutex, or anything else).
I think this is what happens in practice with the current
implementation, but maybe I am missing something in the implementation
details.

> It may be nice to add some comments about exactly when this check is
> performed.
Well, maybe "wake-up" is not the right term according to the
terminology used in the Linux kernel... The check should be performed
every time the task changes its state from sleeping (TASK_INTERRUPTIBLE
or TASK_UNINTERRUPTIBLE, I think) to "ready to execute" (TASK_RUNNING,
I think) and enters the ready queue (well, RB tree :). If someone can
suggest a more appropriate wording, I'll fix the document accordingly.


> > > For example, lets say we have two SD tasks. One that has 50ms
> > > runtime and a 100ms period. The other has a 1ms runtime and a
> > > 10ms period.
> > > 
> > > The above two should work perfectly fine together. The 10ms period
> > > task will constantly schedule in on the 100ms task.
> > > 
> > > When the 100ms task runs, it could easily be delayed by 1ms due
> > > to the 10ms task. Then lets look at the above equation
> > See above: the check for the 100ms task is only performed when the
> > task unblocks (at the beginning of its period), not when it's
> > scheduled (after the 10ms taks).
> > 
> > This check is designed to take care of the following situation:
> > - consider a task with runtime 10ms and period equal to deadline
> > equal to 100ms
> > - assume the task wakes up at time t, and is assigned "remaining
> >   runtime" 10ms and "scheduling deadline" t+100ms
> > - assume the task blocks after executing for 2ms. The "remaining
> >   runtime" is now 8ms
> > - can the task use "remaining runtime" 8ms and "scheduling deadline"
> >   t+100ms when it wakes up again?
> >   Answer: if it wakes up before t+20ms, it can. Otherwise, it
> > cannot, because it would consume a fraction of CPU time larger than
> > 10%, causing missed deadlines in other tasks.
> 
> Ah, you answered my question here. The check happens every time the
> task blocks as well. I still need to read the papers, and even more
> importantly, start running more tests with tracing on to review what
> exactly happens in the implementation.
If you read the original CBS paper, you'll see that it does not talk
about "wake-up" and "sleep", because it always considers a wake-up as a
job arrival, and a task blocking as a job end. This is because the
original paper only considers a simplified task model, without
"self-suspending jobs".
In SCHED_DEADLINE, things are not so simple, because it has to consider
real situations with real tasks not using the simplified original
real-time task model...

> > > > + SCHED_DEADLINE can be used to schedule real-time tasks
> > > > guaranteeing that
> > > > + the jobs' deadlines of a task are respected. In order to do
> > > > this, a task
> > > > + must be scheduled by setting:
> > > > +
> > > > +  - runtime >= WCET
> > > > +  - deadline = D
> > > > +  - period <= P
> > > > +
> > > > + IOW, if runtime >= WCET and if period is >= P, then the
> > > > scheduling deadlines
> > > > + and the absolute deadlines (d_j) coincide, so a proper
> > > > admission control
> > > > + allows to respect the jobs' absolute deadlines for this task
> > > > (this is what is
> > > > + called "hard schedulability property" and is an extension of
> > > > Lemma 1 of [2]).
> > > 
> > > I wonder if we should state the obvious (which is never obvious).
> > > That is the user must also have the following.
> > > 
> > >   runtime < deadline <= period
> > > 
> > > Although it is fine for deadline = period, runtime should be less
> > > than deadline, otherwise the task will take over the system.
> > I think if "runtime < deadline <= period" is not respected, then the
> > admission control will fail... But yes, repeating it here can be
> > useful. If needed I'll add it to the document.
> 
> Yeah, it's one of those things that you should know, but I can see
> users screwing it up ;-)
Ok...
What about presenting this as an example of the admission test failing?
Something like: 'notice that if "runtime" > "deadine" the admission
test will surely fail.'
(BTW, I am not sure if the "deadline <= period" condition is really
needed... Maybe not respecting it does not make too much sense, but I
think it is not strictly needed for schedulability purposes).



			Thanks,
				Luca
