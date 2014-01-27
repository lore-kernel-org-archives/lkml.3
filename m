Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360AbaA0AYT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 19:24:19 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:43321 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121AbaA0AYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 19:24:18 -0500
Date: Mon, 27 Jan 2014 00:22:55 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Anvin <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] de-asmify the x86-64 system call slowpath
Message-ID: <20140127002255.GA10323@ZenIV.linux.org.uk>
References: <CA+55aFzNxTtvNX7zqBELHs489e5mEx1sM=i=red=aQAGviXrNw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzNxTtvNX7zqBELHs489e5mEx1sM=i=red=aQAGviXrNw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 26, 2014 at 02:28:15PM -0800, Linus Torvalds wrote:
> The x86-64 (and 32-bit, for that matter) system call slowpaths are all
> in C, but the *selection* of which slow-path to take is a mixture of
> complicated assembler ("sysret_check -> sysret_careful ->
> sysret_signal ->sysret_audit -> int_check_syscall_exit_work" etc), and
> oddly named and placed C code ("schedule_user" vs
> "__audit_syscall_exit" vs "do_notify_resume").
> 
> This attached patch tries to take the "do_notify_resume()" approach,
> and renaming it to something sane ("syscall_exit_slowpath") and call
> out to *all* the different slow cases from that one place, instead of
> having some cases hardcoded in asm, and some in C. And instead of
> hardcoding which cases result in a "iretq" and which cases result in a
> faster sysret case, it's now simply a return value from that
> syscall_exit_slowpath() function, so it's very natural and easy to say
> "taking a signal will force us to do the slow iretq case, but we can
> do the task exit work and still do the sysret".
> 
> I've marked this as an RFC, because I didn't bother trying to clean up
> the 32-bit code similarly (no test-cases, and trust me, if you get
> this wrong, it will fail spectacularly but in very subtle and
> hard-to-debug ways), and I also didn't bother with the slow cases in
> the "iretq" path, so that path still has the odd asm cases and calls
> the old (now legacy) do_notify_resume() path.

Umm...  Can't uprobe_notify_resume() modify regs as well?  While we
are at it, when we start using the same thing on 32bit kernels, we'll
need to watch out for execve() - the reason why start_thread() sets
TIF_NOTIFY_RESUME is to force us away from sysexit path.  IIRC, vm86
is another thing to watch out for (same reasons).
