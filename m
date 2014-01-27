Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751530AbaA0Lgv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 06:36:51 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:43807 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275AbaA0Lgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 06:36:49 -0500
Date: Mon, 27 Jan 2014 11:36:27 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Anvin <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] de-asmify the x86-64 system call slowpath
Message-ID: <20140127113627.GC10323@ZenIV.linux.org.uk>
References: <CA+55aFzNxTtvNX7zqBELHs489e5mEx1sM=i=red=aQAGviXrNw@mail.gmail.com>
 <20140127102759.GY11314@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140127102759.GY11314@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 27, 2014 at 11:27:59AM +0100, Peter Zijlstra wrote:

> Obviously I don't particularly like the SAVE_REST/FIXUP_TOP_OF_STACK
> being added to the reschedule path.
> 
> Can't we do as Al suggested earlier and have 2 slowpath calls, one
> without PT_REGS and one with?
> 
> That said, yes its a nice cleanup, entry.S always hurts my brain.

BTW, there's an additional pile of obfuscation:
/* work to do on interrupt/exception return */
#define _TIF_WORK_MASK                                                  \
        (0x0000FFFF &                                                   \
         ~(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|                       \
           _TIF_SINGLESTEP|_TIF_SECCOMP|_TIF_SYSCALL_EMU))

/* work to do on any return to user space */
#define _TIF_ALLWORK_MASK                                               \
        ((0x0000FFFF & ~_TIF_SECCOMP) | _TIF_SYSCALL_TRACEPOINT |       \
        _TIF_NOHZ)

These guys are
	_TIF_NOTIFY_RESUME | _TIF_SIGPENDING | _TIF_MCE_NOTIFY |
	_TIF_USER_RETURN_NOTIFY | _TIF_UPROBE | _TIF_NEED_RESCHED | 0xe200
and
	_TIF_SYSCALL_TRACE | _TIF_NOTIFY_RESUME | _TIF_SIGPENDING |
	_TIF_NEED_RESCHED | _TIF_SINGLESTEP | _TIF_SYSCALL_EMU |
	_TIF_SYSCALL_AUDIT |  _TIF_MCE_NOTIFY | _TIF_SYSCALL_TRACEPOINT |
	_TIF_NOHZ | _TIF_USER_RETURN_NOTIFY | _TIF_UPROBE | 0xe200
resp., or
	_TIF_DO_NOTIFY_MASK | _TIF_UPROBE | _TIF_NEED_RESCHED | 0xe200
and
	_TIF_DO_NOTIFY_MASK | _TIF_WORK_SYSCALL_EXIT | _TIF_NEED_RESCHED |
	_TIF_SYSCALL_EMU | _TIF_UPROBE | 0xe200

0xe200 (aka bits 15,14,13,9) consists of the bits that are never set by
anybody, so short of really deep magic it can be discarded.  The rest
is also interesting, to put it politely.  Why is _TIF_UPROBE *not* a part
of _TIF_DO_NOTIFY_MASK, for example?  Note that do_notify_resume() checks
and clears it, but on syscall (and interrupt) exit paths we only call it
with something in _TIF_DO_NOTIFY_MASK.  If UPROBE is set, but nothing
else in that set is, we'll be looping forever, right?  There's pending
work (according to _TIF_WORK_MASK), so we won't just leave.  And we won't
be calling do_notify_resume(), so there's nothing to clear that bit.
Only it gets even nastier - on the paranoid_userspace path we call
do_notify_resume() if anything in _TIF_WORK_MASK besides NEED_RESCHED 
happens to be set.  So _there_ getting solitary UPROBE is legitimate.

_TIF_SYSCALL_EMU is also an interesting story - on the way out it
	* forces us on iret path
	* does *not* trigger trace_syscall_leave() on its own
(trace_syscall_leave() is aware of that sucker, though, with rather
confusing comment)
	* hits do_notify_resume() (for no good reason - do_notify_resume()
silently ignores it)
	* gets cleared from the workmask (i.e. %edi), so on the next
iteration through the loop it gets completely ignored.

AFAICS, all of that is pointless, since SYSCALL_EMU wants to avoid
SYSRET only if we had entered with it and in that case we would've
gone through tracesys and stayed the fsck away from SYSRET path
anyway (similar on 32bit - if we hit syscall_trace_enter(), we
do not rejoin the sysenter path).  IOW, no reason for it to be
in _TIF_ALLWORK_MASK...
