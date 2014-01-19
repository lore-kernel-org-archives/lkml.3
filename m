Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752393AbaASP3I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 10:29:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3811 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752174AbaASP3F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 10:29:05 -0500
Date: Sun, 19 Jan 2014 16:29:22 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Sergio Durigan Junior <sergiodj@redhat.com>
Cc: Pedro Alves <palves@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Roland McGrath <roland@hack.frob.com>,
        Denys Vlasenko <dvlasenk@redhat.com>, Tom Tromey <tromey@redhat.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>, Tejun Heo <tj@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC/PATCH] Implement new PTRACE_EVENT_SYSCALL_{ENTER,EXIT}
Message-ID: <20140119152922.GA13689@redhat.com>
References: <m3wqic205t.fsf@redhat.com> <20140107153036.GA4749@redhat.com> <52CEEF1F.90803@redhat.com> <20140110135802.GA26953@redhat.com> <m3sisk4rfq.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m3sisk4rfq.fsf@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19, Sergio Durigan Junior wrote:
>
> On Friday, January 10 2014, Oleg Nesterov wrote:
>
> > So suppose that gdb does ptrace(PTRACE_SINGLESTEP) and the tracee
> > executes the "syscall" insn. What it should report?
> [...]
> > But what should syscall-exit do? Should it still report SIGSEGV as
> > it currently does, or should it report _SYSCALL_EXIT instead (if
> > PTRACE_O_SYSCALL_EXIT of course), or should it report both?
>
> Both only if _SYSCALL_EXIT is set.  Otherwise, stick to the current
> behavior, I guess.

OK, both. In which order? Probably _EXIT first. But this looks a bit
strange. Suppose that the tracee reports _EXIT, then debugger does
ptrace(PTRACE_CONT), should the tracee report SIGTRAP?

SIGTRAP before _EXIT looks a bit strange too... Single-step trap should
be reported after insn, but we are still in syscall.

So perhaps _EXIT should win and do not report the step?

> Isn't it what my current patch does, by the way?

I forgot how this patch looks so I can be easily wrong, but iirc no.
Note that tracehook_report_syscall_exit() doesn't even call
ptrace_report_syscall() if step == T.

Btw, if you send v2, please CC Michael Kerrisk <mtk.manpages@gmail.com>.

Oleg.

