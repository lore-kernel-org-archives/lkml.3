Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689Ab3CRTJv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 15:09:51 -0400
Received: from fifo99.com ([67.223.236.141]:60222 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754317Ab3CRTJt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 15:09:49 -0400
Date: Mon, 18 Mar 2013 12:09:44 -0700
From: Daniel Walker <dwalker@fifo99.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ptracing a task from core_pattern pipe
Message-ID: <20130318190943.GA16226@fifo99.com>
References: <20130316011508.GA11010@fifo99.com>
 <20130316175845.GA6194@redhat.com>
 <20130317004431.GA28915@fifo99.com>
 <20130317143446.GB25236@redhat.com>
 <20130317211133.GA14189@fifo99.com>
 <20130318170302.GA21248@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130318170302.GA21248@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 18, 2013 at 06:03:02PM +0100, Oleg Nesterov wrote:
> > Assume that's not happening, why would ptrace give me -ESRCH, yet
> > /proc/<pid>/status would show me ptrace attached to the thread.
> 
> And why do you think this should be explained by SIGKILL?

It's an assumption, if I knew before you would be getting a patch
instead of an email.

> > > Please explain what difference this patch makes in your testing.
> >
> > I haven't tested with or with out it, I've just read the code and it
> > seems to be the only way I'm getting ESRCH back from ptrace.. 
> 
> No,
> 
> > For instance, I ptrace attach from inside the corepipe_app then try
> > PTRACE_GETREGS and you get -ESRCH .
> 
> Sure. PTRACE_GETREGS and (almost) any other request can only succeed
> if the tracee is TASK_TRACED! I already told you that ptrace() doesn't
> and can't work exactly because the dumper never does ptrace_stop().

When does ptrace_stop run ?

> > > > It can give me it's registers, and allow me access to it's memory space.
> > > > That's all I want realistically ..
> > >
> > > ...
> > >
> > > > I'm trying to get the "dumpers" registers and stack out when it fails.
> > >
> > > Can't you read the generated core for that? And see below...
> >
> > I'm not sure if it would accomplish what I need. I can't save the whole core,
> > and I can't get memory to save large chunks of it.
> 
> Not sure I understand this part...

The above is regarding the situation which I'm running my corepipe_app ,
i.e. my system doesn't have a disk to save a core file for parsing.

> >
> > Oh, I think I see what you mean. I would ptrace attach prior to the
> > thread crashing ,
> 
> I don't understand what "prior to the thread crashing" means... the pipe
> hanlder is spawned after the task has already initiated the coredump...
> IOW, other threads are already killed and we are ready to actually dump
> the core.

I can't attach to the thread after it's crashed, since I get ESRCH in
the corepipe_app for every operation, so that suggests I'd need to attach
prior to when it crashes.

> > and get an event for when it crashes ?
> 
> And get an event after coredump_app closes the pipe. Assuming that
> you use PTRACE_SEIZE(PTRACE_O_CORE_DUMPED) rather that PTRACE_ATTACH.
> And assuming you do this before you close the pipe, otherwise it can
> exit before you do PTRACE_SEIZE.

So corepipe_app would PTRACE_SEIZE then close the pipe but continue running ?

> > > Of course, this can't help to ptrace/inspect other threads, they are
> > > already (well, almost) dead at this point.
> >
> > Ideally I would want to attach after it crashes, cause other wise I'd
> > have to ptrace attach to a lot of threads (to monitor the whole system).
> 
> See above. You do not need to attach in advance.
> 
> But once again, you can't attach the sub-threads, they are already dead
> when coredump_app is called. PTRACE_ATTACH will work but this can help,
> a sub-thread will never report any event and PF_EXITING is already set.

Ok ..

Daniel

