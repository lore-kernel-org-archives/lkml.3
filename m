Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965566Ab3FTNqP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 09:46:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51410 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965461Ab3FTNqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 09:46:14 -0400
Date: Thu, 20 Jun 2013 15:41:57 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jan Kratochvil <jan.kratochvil@redhat.com>,
        "Dmitry V. Levin" <ldv@altlinux.org>
Subject: Re: [PATCH] ptrace: make PTRACE_DETACH work on non-stopped tracees.
Message-ID: <20130620134157.GA32253@redhat.com>
References: <1371654936-31742-1-git-send-email-dvlasenk@redhat.com> <20130619163234.GA12029@redhat.com> <51C23C7E.8000400@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51C23C7E.8000400@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20, Denys Vlasenko wrote:
>
> On 06/19/2013 06:32 PM, Oleg Nesterov wrote:
> > On 06/19, Denys Vlasenko wrote:
> >>
> >> This is a user-visible behavior change.
> >> Do we really have to introduce a separate
> >> PTRACE_NOT_STUPID_DETACH? I hope not.
> >
> > Oh, I think yes.
> >
> >> @@ -1062,7 +1060,8 @@ SYSCALL_DEFINE4(ptrace, long, request, long, pid, unsigned long, addr,
> >>  	}
> >>
> >>  	ret = ptrace_check_attach(child, request == PTRACE_KILL ||
> >> -				  request == PTRACE_INTERRUPT);
> >> +				  request == PTRACE_INTERRUPT ||
> >> +				  request == PTRACE_DETACH);
> >
> > There doesn't look right.
> >
> > For example ptrace_disable(). See the comment set_task_blockstep().
>
> I see the comment. I think it implies that TF-induced debug
> interrupt may happen on the running task after it is detached,
> which will result in SIGTRAP being sent to it.

No. The comment means that set/clear of TIF_BLOCKSTEP is not safe unless
the tracee can't run. If we race with __switch_to() we can set the wrong
debugctlmsr.

> If so, do we have the same problem if tracer exits
> and implicit detach is performed?

No. If the tracer exits it doesn't do the "cleanups" like ptrace_disable().
That is why this potentially leaves the tracee in the inconsistent state.

Oleg.

