Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758025Ab3D2Qot (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 12:44:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15752 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757248Ab3D2Qor (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 12:44:47 -0400
Date: Mon, 29 Apr 2013 18:40:38 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alan Stern <stern@rowland.harvard.edu>, Ingo Molnar <mingo@elte.hu>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        Prasad <prasad@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] ptrace: PTRACE_DETACH should do
	flush_ptrace_hw_breakpoint(child)
Message-ID: <20130429164038.GA27132@redhat.com>
References: <20130418184350.GA4407@redhat.com> <20130418184425.GA4454@redhat.com> <20130429160931.GD31230@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130429160931.GD31230@somewhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29, Frederic Weisbecker wrote:
>
> On Thu, Apr 18, 2013 at 08:44:25PM +0200, Oleg Nesterov wrote:
> > index 776ab3b..33752d9 100644
> > --- a/kernel/ptrace.c
> > +++ b/kernel/ptrace.c
> > @@ -467,6 +467,7 @@ static int ptrace_detach(struct task_struct *child, unsigned int data)
> >  	/* Architecture-specific hardware disable .. */
> >  	ptrace_disable(child);
> >  	clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
> > +	flush_ptrace_hw_breakpoint(child);
>
> So I assume the tracee is still guaranteed to be stopped at that time, right?

Yes.

This is only called by PTRACE_DETACH which requires the stopped tracee,
like all ptrace requests except PTRACE_KILL/INTERRUPT. And only one
thread (the tracer) can do this.

> But it can't be concurrently killed given the patch you did that prevented that?

No, it can't. To clarify, the tracee can't run even if killed.

And just in case... If the tracer exits and does the implicit detach,
ptrace_detach() (and thus flush_ptrace_hw_breakpoint()) is not called,
that would be wrong exactly because we can race with the tracee.

> Also it seems to be a regression since we brought the breakpoint/perf
> infrastructure.

No, I think this (minor) problem is very old... At least, when I look
at 2.6.26 code I do not see anything which coould clear db regs on
detach.

> backporting this patch prior to "ptrace: ensure arch_ptrace/ptrace_request can never race with SIGKILL"
> might be racy.

Yes, unlikely this is possible or even makes sense, the problem is
minor.



Btw. perhaps flush_ptrace_hw_breakpoint() should also clear the
virtual registers like thread.debugreg7 ? Even without this patch,
flush_ is also called exec.

Oleg.

