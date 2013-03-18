Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262Ab3CRRFF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 13:05:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10559 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753651Ab3CRRFD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 13:05:03 -0400
Date: Mon, 18 Mar 2013 18:03:02 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Daniel Walker <dwalker@fifo99.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ptracing a task from core_pattern pipe
Message-ID: <20130318170302.GA21248@redhat.com>
References: <20130316011508.GA11010@fifo99.com> <20130316175845.GA6194@redhat.com> <20130317004431.GA28915@fifo99.com> <20130317143446.GB25236@redhat.com> <20130317211133.GA14189@fifo99.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130317211133.GA14189@fifo99.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17, Daniel Walker wrote:
>
> On Sun, Mar 17, 2013 at 03:34:46PM +0100, Oleg Nesterov wrote:
> >
> > It sleeps only after it dumps the core. It only sleeps to ensure we
> > do not close the write side prematurely.
>
> The dumper thread is sleeping when the corepipe_app runs .. I ran "cat
> /proc/<pid>/status" from the corepipe_app .. It shows the dumper as sleeping.

It runs whatever you see in /proc/status ;) Who do you think dumps the
core? The dumper thread itself. But see below.

> > > It can't
> > > run when corepipe_app runs. It wouldn't make sense because the core is
> > > getting saved at that point.
> >
> > At this point it doesn't run, yes. But while it dumps the core they
> > both run in parallel.
>
> Not following you here.. If it's sleeping how can it be running too ?

See above. Once again, it dumps the core _then_ sleeps waiting pipe
handler which should close the pipe.

And of course, you can see it sleeping in, say, pipe_write() if
the buffer is full and the pipe handler doesn't read the data.

> > > As I said there is a SIGKILL pending on the "dumper" thread,
> >
> > As I said, there is no SIGKILL pending on the "dumper" thread. (unless it
> > is actually killed of course).
>
> I pretty sure do_coredump()->core_wait()->zap_threads()->zap_process()
>  adds SIGKILL..

	static int zap_process(struct task_struct *start, int exit_code)
	{
		...

		do {
			task_clear_jobctl_pending(t, JOBCTL_PENDING_MASK);
------------>			if (t != current && t->mm) {
				sigaddset(&t->pending.signal, SIGKILL);
				signal_wake_up(t, 1);
				nr++;
			}
		} while_each_thread(start, t);
	}

> Assume that's not happening, why would ptrace give me -ESRCH, yet
> /proc/<pid>/status would show me ptrace attached to the thread.

And why do you think this should be explained by SIGKILL?

> > Please explain what difference this patch makes in your testing.
>
> I haven't tested with or with out it, I've just read the code and it
> seems to be the only way I'm getting ESRCH back from ptrace.. 

No,

> For instance, I ptrace attach from inside the corepipe_app then try
> PTRACE_GETREGS and you get -ESRCH .

Sure. PTRACE_GETREGS and (almost) any other request can only succeed
if the tracee is TASK_TRACED! I already told you that ptrace() doesn't
and can't work exactly because the dumper never does ptrace_stop().

> > > It can give me it's registers, and allow me access to it's memory space.
> > > That's all I want realistically ..
> >
> > ...
> >
> > > I'm trying to get the "dumpers" registers and stack out when it fails.
> >
> > Can't you read the generated core for that? And see below...
>
> I'm not sure if it would accomplish what I need. I can't save the whole core,
> and I can't get memory to save large chunks of it.

Not sure I understand this part...

> ptrace after it crashes seems like a nice solution cause I can just
> examine the process already in memory.

OK.

> > > > Now that the coredump is killable (-mm patches), _perhaps_ we can, say,
> > > > add PTRACE_EVENT_CORED_DUMPED reported after binfmt->core_dump(). Not
> > > > sure this is what you need...
> > >
> > > Not sure what this would accomplish .. I just want the processes
> > > registers and stack or access to all it's memory.
> >
> > Confused... why do you think PTRACE_EVENT_CORE_DUMPED reported after
> > binfmt->core_dump() won't allow to do this?
>
> Oh, I think I see what you mean. I would ptrace attach prior to the
> thread crashing ,

I don't understand what "prior to the thread crashing" means... the pipe
hanlder is spawned after the task has already initiated the coredump...
IOW, other threads are already killed and we are ready to actually dump
the core.

> and get an event for when it crashes ?

And get an event after coredump_app closes the pipe. Assuming that
you use PTRACE_SEIZE(PTRACE_O_CORE_DUMPED) rather that PTRACE_ATTACH.
And assuming you do this before you close the pipe, otherwise it can
exit before you do PTRACE_SEIZE.

> > Of course, this can't help to ptrace/inspect other threads, they are
> > already (well, almost) dead at this point.
>
> Ideally I would want to attach after it crashes, cause other wise I'd
> have to ptrace attach to a lot of threads (to monitor the whole system).

See above. You do not need to attach in advance.

But once again, you can't attach the sub-threads, they are already dead
when coredump_app is called. PTRACE_ATTACH will work but this can help,
a sub-thread will never report any event and PF_EXITING is already set.

Oleg.

