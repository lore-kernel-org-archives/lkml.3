Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500AbaLDAjK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 19:39:10 -0500
Received: from mail-la0-f51.google.com ([209.85.215.51]:51331 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334AbaLDAjI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 19:39:08 -0500
MIME-Version: 1.0
In-Reply-To: <20141204003024.GA17665@redhat.com>
References: <20141203220836.GC31369@lerouge> <c6a6c2246188d25b9997848bbf39d5363c7a3da9.1417648389.git.luto@amacapital.net>
 <20141203235835.GE31369@lerouge> <CALCETrXbEheevmNKsuEd0NEpCrDz06W5z_OphMOUHqT7qNUTyA@mail.gmail.com>
 <20141204003024.GA17665@redhat.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 3 Dec 2014 16:38:46 -0800
Message-ID: <CALCETrXSsTa76QGg+MHDAkrr9gJPSqm2zKrcTbU5SV31mWDVuQ@mail.gmail.com>
Subject: Re: [PATCH] context_tracking: Restore previous state in schedule_user
To: Dave Jones <davej@redhat.com>, Andy Lutomirski <luto@amacapital.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Richard Guy Briggs <rgb@redhat.com>, Eric Paris <eparis@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 3, 2014 at 4:30 PM, Dave Jones <davej@redhat.com> wrote:
> On Wed, Dec 03, 2014 at 04:04:31PM -0800, Andy Lutomirski wrote:
>  > On Wed, Dec 3, 2014 at 3:58 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
>  > > On Wed, Dec 03, 2014 at 03:18:41PM -0800, Andy Lutomirski wrote:
>  > >> It appears that some SCHEDULE_USER (asm for schedule_user) callers
>  > >> in arch/x86/kernel/entry_64.S are called from RCU kernel context,
>  > >> and schedule_user will return in RCU user context.  This causes RCU
>  > >> warnings and possible failures.
>  > >>
>  > >> This is intended to be a minimal fix suitable for 3.18.
>  > >>
>  > >> Reported-by: Dave Jones <davej@redhat.com>
>  > >> Cc: Oleg Nesterov <oleg@redhat.com>
>  > >> Cc: Frédéric Weisbecker <fweisbec@gmail.com>
>  > >> Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
>  > >> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
>  > >
>  > > Ah, we sent it about at the same time :-)
>  > >
>  > > Might be too late for 3.18 though because it's not a regression.
>
> Wait, so how come that trace didn't start showing up until recently ?

Looking at the code, it's because int_careful has the same bug, but
syscall_trace_leave does:

    /*
     * We may come here right after calling schedule_user()
     * or do_notify_resume(), in which case we can be in RCU
     * user mode.
     */
    user_exit();

which means that this issue was anticipated when that comment was written.

Prior to the 3.18 seccomp changes and the _TIF_WORK typo fix, it would
have been difficult to hit sysret_audit when context tracking was on
(you could do it once on the way out from a syscall that enabled
context tracking).  So this is 3.18 regression.

The sysret_audit code is still totally screwed up AFAICT.  At the very
least, the whole mess rather strongly suggests that, if both context
tracking and audit are on, then __audit_syscall_exit is called *twice*
on each syscall.  __audit_syscall_exit seems to be idempotent, so
maybe no one has noticed that little glitch.

I'll ask the x86 people to include my sysret_audit removal for 3.19,
since I think that this schedule_user change is a better last-minute
fix than removing a whole chunk of asm.

--Andy

>
>         Dave
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
