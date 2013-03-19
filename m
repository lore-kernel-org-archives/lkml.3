Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757667Ab3CSUVi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 16:21:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40317 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752872Ab3CSUVg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 16:21:36 -0400
Date: Tue, 19 Mar 2013 21:19:33 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Daniel Walker <dwalker@fifo99.com>
Cc: linux-kernel@vger.kernel.org, Denys Vlasenko <dvlasenk@redhat.com>
Subject: Re: ptracing a task from core_pattern pipe
Message-ID: <20130319201933.GB18670@redhat.com>
References: <20130316011508.GA11010@fifo99.com> <20130316175845.GA6194@redhat.com> <20130317004431.GA28915@fifo99.com> <20130317143446.GB25236@redhat.com> <20130317211133.GA14189@fifo99.com> <20130318170302.GA21248@redhat.com> <20130318190943.GA16226@fifo99.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130318190943.GA16226@fifo99.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18, Daniel Walker wrote:
>
> On Mon, Mar 18, 2013 at 06:03:02PM +0100, Oleg Nesterov wrote:
> >
> > > For instance, I ptrace attach from inside the corepipe_app then try
> > > PTRACE_GETREGS and you get -ESRCH .
> >
> > Sure. PTRACE_GETREGS and (almost) any other request can only succeed
> > if the tracee is TASK_TRACED! I already told you that ptrace() doesn't
> > and can't work exactly because the dumper never does ptrace_stop().
>
> When does ptrace_stop run ?

When the tracee stops in TASK_TRACED for debugger, after that the debugger
can do ptrace(GETREGS/whatever).

> > > I'm not sure if it would accomplish what I need. I can't save the whole core,
> > > and I can't get memory to save large chunks of it.
> >
> > Not sure I understand this part...
>
> The above is regarding the situation which I'm running my corepipe_app ,
> i.e. my system doesn't have a disk to save a core file for parsing.

Can't you process the data inplace? You do not need to save it to disk.

I understand, this is probably not very convenient, but any new kernel
feature should be justified. And let me repeat, even if we add
PTRACE_EVENT_COREDUMPED you won't be able to ptrace sub-threads, so
this feature doesn't look very nice.

> > > Oh, I think I see what you mean. I would ptrace attach prior to the
> > > thread crashing ,
> >
> > I don't understand what "prior to the thread crashing" means... the pipe
> > hanlder is spawned after the task has already initiated the coredump...
> > IOW, other threads are already killed and we are ready to actually dump
> > the core.
>
> I can't attach to the thread after it's crashed,

Daniel, you can, but:

> since I get ESRCH in
> the corepipe_app for every operation,

This is another thing, and I already explained many times why this happens.

> so that suggests I'd need to attach
> prior to when it crashes.

If you can attach prior to when it crashes then I do not understand why
do you need the piped coredump at all. You can do everything you need
after the tracee reports SEGFAULT or another sig_kernel_coredump() signal.

> > And get an event after coredump_app closes the pipe. Assuming that
> > you use PTRACE_SEIZE(PTRACE_O_CORE_DUMPED) rather that PTRACE_ATTACH.
> > And assuming you do this before you close the pipe, otherwise it can
> > exit before you do PTRACE_SEIZE.
>
> So corepipe_app would PTRACE_SEIZE then close the pipe but continue running ?

Well, yes... But I am not sure I understand the question...

What this "but continue running" means? Of course corepipe_app can run
after it closes the pipe.



Daniel, I feel you misunderstand something (or perhaps it is me), but
I can't understand what exactly you do not understand, sorry ;) I will
be happy to help if you ask the more "explicit" questions.

Oleg.

