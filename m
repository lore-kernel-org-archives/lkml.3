Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756673Ab3CQVLq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 17:11:46 -0400
Received: from fifo99.com ([67.223.236.141]:43159 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756460Ab3CQVLq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 17:11:46 -0400
Date: Sun, 17 Mar 2013 14:11:34 -0700
From: Daniel Walker <dwalker@fifo99.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ptracing a task from core_pattern pipe
Message-ID: <20130317211133.GA14189@fifo99.com>
References: <20130316011508.GA11010@fifo99.com>
 <20130316175845.GA6194@redhat.com>
 <20130317004431.GA28915@fifo99.com>
 <20130317143446.GB25236@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130317143446.GB25236@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 17, 2013 at 03:34:46PM +0100, Oleg Nesterov wrote:
> > > (Just in case, this was recently changed. After
> > >  coredump-ensure-that-sigkill-always-kills-the-dumping-thread.patch in -mm
> > >  tree the dumper doesn't run in SIGNAL_GROUP_EXIT, but probably this
> > >  doesn't matter)
> > >
> > > > However the application can't run.
> > >
> > > Which application? Both the dumper and corepipe_app can run...
> >
> > the "dumper" , assuming I know what you mean, is sleeping..
> 
> It sleeps only after it dumps the core. It only sleeps to ensure we
> do not close the write side prematurely.

The dumper thread is sleeping when the corepipe_app runs .. I ran "cat
/proc/<pid>/status" from the corepipe_app .. It shows the dumper as sleeping.

> > It can't
> > run when corepipe_app runs. It wouldn't make sense because the core is
> > getting saved at that point.
> 
> At this point it doesn't run, yes. But while it dumps the core they
> both run in parallel.

Not following you here.. If it's sleeping how can it be running too ?

> > > > This commit,
> > > >
> > > > 9899d11f654474d2d54ea52ceaa2a1f4db3abd68
> > >
> > > > seems to put a damper on ptracing the application at this point.
> > >
> > > How can this commit make any difference? It should not.
> >
> > As I said there is a SIGKILL pending on the "dumper" thread,
> 
> As I said, there is no SIGKILL pending on the "dumper" thread. (unless it
> is actually killed of course).

I pretty sure do_coredump()->core_wait()->zap_threads()->zap_process()
 adds SIGKILL.. Assume that's not happening, why would ptrace give me -ESRCH, yet
/proc/<pid>/status would show me ptrace attached to the thread.

> > and your
> > commit finds the SIGKILL pending.
> 
> Can't understand. It can find the pending SIGKILL, but only after ptrace()
> returns sucessfully and the tracee was stopped. And the dumper never stops.
> 
> Please explain what difference this patch makes in your testing.

I haven't tested with or with out it, I've just read the code and it
seems to be the only way I'm getting ESRCH back from ptrace.. 

For instance, I ptrace attach from inside the corepipe_app then try
PTRACE_GETREGS and you get -ESRCH .

> > > > So I wanted to see what you think of all this.. Can we add an exception
> > > > to this which would allow operations on a task which is dumping core,
> > >
> > > Which ptrace request you think should work at this stage? The coredumping
> > > task is dying, it can't report, say, signal or syscall. It can report
> > > nothing except PTRACE_EVENT_EXIT, but only after it closes the pipe.
> >
> > It can give me it's registers, and allow me access to it's memory space.
> > That's all I want realistically ..
> 
> ...
> 
> > I'm trying to get the "dumpers" registers and stack out when it fails.
> 
> Can't you read the generated core for that? And see below...

I'm not sure if it would accomplish what I need. I can't save the whole core,
and I can't get memory to save large chunks of it.

ptrace after it crashes seems like a nice solution cause I can just
examine the process already in memory.

> > > Now that the coredump is killable (-mm patches), _perhaps_ we can, say,
> > > add PTRACE_EVENT_CORED_DUMPED reported after binfmt->core_dump(). Not
> > > sure this is what you need...
> >
> > Not sure what this would accomplish .. I just want the processes
> > registers and stack or access to all it's memory.
> 
> Confused... why do you think PTRACE_EVENT_CORE_DUMPED reported after
> binfmt->core_dump() won't allow to do this?

Oh, I think I see what you mean. I would ptrace attach prior to the
thread crashing , and get an event for when it crashes ?

> Of course, this can't help to ptrace/inspect other threads, they are
> already (well, almost) dead at this point.

Ideally I would want to attach after it crashes, cause other wise I'd
have to ptrace attach to a lot of threads (to monitor the whole system).

Daniel
