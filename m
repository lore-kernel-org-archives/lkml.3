Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556AbaLDB3q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 20:29:46 -0500
Received: from mail-lb0-f173.google.com ([209.85.217.173]:63310 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477AbaLDB3n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 20:29:43 -0500
MIME-Version: 1.0
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 3 Dec 2014 17:29:21 -0800
Message-ID: <CALCETrULjLf=WHn9TfRyFH+hac7FYKUWmfDm4_aZ3mP4jEpU3w@mail.gmail.com>
Subject: 3.18 nohz + audit regression (Re: [PATCH] context_tracking: Restore
 previous state in schedule_user)
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Richard Guy Briggs <rgb@redhat.com>, Eric Paris <eparis@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 3, 2014 at 5:13 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> On Wed, Dec 03, 2014 at 04:38:46PM -0800, Andy Lutomirski wrote:
>> On Wed, Dec 3, 2014 at 4:30 PM, Dave Jones <davej@redhat.com> wrote:
>> > On Wed, Dec 03, 2014 at 04:04:31PM -0800, Andy Lutomirski wrote:
>> >  > On Wed, Dec 3, 2014 at 3:58 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
>> >  > > On Wed, Dec 03, 2014 at 03:18:41PM -0800, Andy Lutomirski wrote:
>> >  > >> It appears that some SCHEDULE_USER (asm for schedule_user) callers
>> >  > >> in arch/x86/kernel/entry_64.S are called from RCU kernel context,
>> >  > >> and schedule_user will return in RCU user context.  This causes RCU
>> >  > >> warnings and possible failures.
>> >  > >>
>> >  > >> This is intended to be a minimal fix suitable for 3.18.
>> >  > >>
>> >  > >> Reported-by: Dave Jones <davej@redhat.com>
>> >  > >> Cc: Oleg Nesterov <oleg@redhat.com>
>> >  > >> Cc: Frédéric Weisbecker <fweisbec@gmail.com>
>> >  > >> Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
>> >  > >> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
>> >  > >
>> >  > > Ah, we sent it about at the same time :-)
>> >  > >
>> >  > > Might be too late for 3.18 though because it's not a regression.
>> >
>> > Wait, so how come that trace didn't start showing up until recently ?
>>
>> Looking at the code, it's because int_careful has the same bug, but
>> syscall_trace_leave does:
>>
>>     /*
>>      * We may come here right after calling schedule_user()
>>      * or do_notify_resume(), in which case we can be in RCU
>>      * user mode.
>>      */
>>     user_exit();
>>
>> which means that this issue was anticipated when that comment was written.
>
> Indeed, in fact it was expected to work as long as the code that follows the
> syscall is limited to schedule_user(), syscall_trace_leave() and do_notify_resume().
> But if anything else is called and uses RCU, this doesn't work anymore.
>
> So user_enter() and user_exit() have been designed to be re-entrant on purpose.
>
>>
>> Prior to the 3.18 seccomp changes and the _TIF_WORK typo fix, it would
>> have been difficult to hit sysret_audit when context tracking was on
>> (you could do it once on the way out from a syscall that enabled
>> context tracking).  So this is 3.18 regression.
>
> I see now.
>
> So the real problem is not on schedule_user(). It's rather that __audit_syscall_exit()
> should we wrapped inside user_exit()/user_enter() or exception_foo(). The latter
> is safer in a sensitive patch. That would be the real and simple regression fix.
> Tweaking schedule_user() is more risky.
>
> Then, if you like, we can rethink the whole later, define syscall_trace_leave()
> as the only place that calls user_enter() and all the other syscall exit functions
> (schedule_user(), do_notify_resume(), __audit_syscall_exit()) can just call
> exception_enter() - exception_exit() if they can be called after syscall_trace_leave().
> Then finally we can make user_enter and user_exit non-reentrant after careful audit
> of how other archs use it (sounds scary though).
>
> Or better yet: if you rework the syscall exit slow path, lets call user_enter() at the
> very end of the syscall.

So, to summarize the choices for 3.18:

1. Revert everything that caused this.  Probably a bad idea -- that
will be quite invasive, and it will no longer revert cleanly, and the
changes themselves were all correct as far as we know.

2. Add a giant hack to phase 1 tracing: if _TIF_WORK, then force phase
2.  That would (I think) restore the 3.17 status quo.  Yuck.

3. My asm deletion patch
(https://git.kernel.org/cgit/linux/kernel/git/luto/linux.git/commit/?h=x86/entry&id=1072a16a8d4ad1b11b8062f76e3236b9771b0fb6).
By itself, that will cause a huge performance hit to syscall auditing
users.

4. This patch.

5. Do something specific to fix __audit_syscall_exit.  That seems a
bit silly to be, since we'll want to revert it as soon as we fix the
larger problem.

I think I prefer choice 4, but 2 and 5 seem okay, too.  Or, if we're
okay with the temporary performance hit (Eric, rgb?) and someone wants
to review it (tglx? hpa? Oleg?) *and* confirm that its parent looks
reasonable in principle for 3.19, we could go with #3.

FWIW, choice 2 might be as simple as commenting out:

        work &= ~_TIF_NOHZ;

in syscall_trace_enter_phase1 and adding a comment that it's a
workaround pending some 3.19 fixes.  However, *it does not fix the
bug* -- it just makes it as hard to trigger as it was in 3.17 as
opposed to being really easy to trigger as in 3.18-rc7.

In the long run, I think that we need to fix SCHEDULE_USER *and* do
something like #3, since sysret_audit appears to have more issues than
just this.

--Andy

>
>>
>> The sysret_audit code is still totally screwed up AFAICT.  At the very
>> least, the whole mess rather strongly suggests that, if both context
>> tracking and audit are on, then __audit_syscall_exit is called *twice*
>> on each syscall.  __audit_syscall_exit seems to be idempotent, so
>> maybe no one has noticed that little glitch.
>>
>> I'll ask the x86 people to include my sysret_audit removal for 3.19,
>> since I think that this schedule_user change is a better last-minute
>> fix than removing a whole chunk of asm.
>>
>> --Andy
>>
>> >
>> >         Dave
>> >
>>
>>
>>
>> --
>> Andy Lutomirski
>> AMA Capital Management, LLC



-- 
Andy Lutomirski
AMA Capital Management, LLC
