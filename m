Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932316Ab3CQOgv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 10:36:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49594 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932318Ab3CQOgo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 10:36:44 -0400
Date: Sun, 17 Mar 2013 15:34:46 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Daniel Walker <dwalker@fifo99.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ptracing a task from core_pattern pipe
Message-ID: <20130317143446.GB25236@redhat.com>
References: <20130316011508.GA11010@fifo99.com> <20130316175845.GA6194@redhat.com> <20130317004431.GA28915@fifo99.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130317004431.GA28915@fifo99.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16, Daniel Walker wrote:
>
> On Sat, Mar 16, 2013 at 06:58:45PM +0100, Oleg Nesterov wrote:
> > On 03/15, Daniel Walker wrote:
> > >
> > > I was writing an application to ptrace a process which is dumping core
> > > from inside the pipe application for core_pattern.
> >
> > This was never possible. And never will, I think.
> >
> > > So for example you make core pattern equal to something like
> > > "|/bin/corepipe_app" then the kernel runs that app prior to actually
> > > killing the process that failed.
> >
> > No, the dumper "kills" itself (but see below) and the starts
> > /bin/corepipe_app.
>
>
> Not sure what you mean by "dumper" .. The thread that has failed (i.e.
> the thread which has seg faulted)

Yes, and this is the thread which spawns corepipe_app and dumps the core.

> is sleeping until the corepipe_app
> returns.

Yes, but it dumps the core first. And to clarify, it sleeps until
corepipe_app closes the pipe.

> > > Before the pipe application runs it puts SIGKILL on the pending signal
> > > list for the failed application.
> >
> > if "it" means the dumper thread then "almost true". It kills other threads
> > but not itself.
> >
>
> "it" is in the kernel prior to spawning the corepipe_app , but I think
> it's the context of the thread which failed.. The SIGKILL is done in

Can't understand... Yes it kills other threads before it starts the
corepipe_app. To clarify, "kills" means it sends SIGKILL to other threads
and wait until they all park in exit_mm().

> > (Just in case, this was recently changed. After
> >  coredump-ensure-that-sigkill-always-kills-the-dumping-thread.patch in -mm
> >  tree the dumper doesn't run in SIGNAL_GROUP_EXIT, but probably this
> >  doesn't matter)
> >
> > > However the application can't run.
> >
> > Which application? Both the dumper and corepipe_app can run...
>
> the "dumper" , assuming I know what you mean, is sleeping..

It sleeps only after it dumps the core. It only sleeps to ensure we
do not close the write side prematurely.

> It can't
> run when corepipe_app runs. It wouldn't make sense because the core is
> getting saved at that point.

At this point it doesn't run, yes. But while it dumps the core they
both run in parallel.

> > > This commit,
> > >
> > > 9899d11f654474d2d54ea52ceaa2a1f4db3abd68
> >
> > > seems to put a damper on ptracing the application at this point.
> >
> > How can this commit make any difference? It should not.
>
> As I said there is a SIGKILL pending on the "dumper" thread,

As I said, there is no SIGKILL pending on the "dumper" thread. (unless it
is actually killed of course).

> and your
> commit finds the SIGKILL pending.

Can't understand. It can find the pending SIGKILL, but only after ptrace()
returns sucessfully and the tracee was stopped. And the dumper never stops.

Please explain what difference this patch makes in your testing.

> > > So I wanted to see what you think of all this.. Can we add an exception
> > > to this which would allow operations on a task which is dumping core,
> >
> > Which ptrace request you think should work at this stage? The coredumping
> > task is dying, it can't report, say, signal or syscall. It can report
> > nothing except PTRACE_EVENT_EXIT, but only after it closes the pipe.
>
> It can give me it's registers, and allow me access to it's memory space.
> That's all I want realistically ..

...

> I'm trying to get the "dumpers" registers and stack out when it fails.

Can't you read the generated core for that? And see below...

> > Now that the coredump is killable (-mm patches), _perhaps_ we can, say,
> > add PTRACE_EVENT_CORED_DUMPED reported after binfmt->core_dump(). Not
> > sure this is what you need...
>
> Not sure what this would accomplish .. I just want the processes
> registers and stack or access to all it's memory.

Confused... why do you think PTRACE_EVENT_CORE_DUMPED reported after
binfmt->core_dump() won't allow to do this?

Of course, this can't help to ptrace/inspect other threads, they are
already (well, almost) dead at this point.

Oleg.

