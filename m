Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751515AbaLCWNI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 17:13:08 -0500
Received: from mail-la0-f54.google.com ([209.85.215.54]:62896 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106AbaLCWNG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 17:13:06 -0500
MIME-Version: 1.0
In-Reply-To: <20141203220836.GC31369@lerouge>
References: <20141203181922.GA26916@redhat.com> <20141203192919.GP25340@linux.vnet.ibm.com>
 <547F6D60.5050007@amacapital.net> <20141203201947.GA4931@redhat.com>
 <CALCETrVtKcwWsN4q7kp-K7kEfQyebKfSbBQy4iAhfP0WPVZNpQ@mail.gmail.com> <20141203220836.GC31369@lerouge>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 3 Dec 2014 14:12:43 -0800
Message-ID: <CALCETrU321dBwOgeQOO9aao4D-exmFHBFSoWKJJ6yoCgufofzQ@mail.gmail.com>
Subject: Re: audit: rcu_read_lock() used illegally while idle
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Dave Jones <davej@redhat.com>, Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Richard Guy Briggs <rgb@redhat.com>, Eric Paris <eparis@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 3, 2014 at 2:08 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> On Wed, Dec 03, 2014 at 12:38:36PM -0800, Andy Lutomirski wrote:
>> On Wed, Dec 3, 2014 at 12:19 PM, Dave Jones <davej@redhat.com> wrote:
>> > On Wed, Dec 03, 2014 at 12:06:56PM -0800, Andy Lutomirski wrote:
>> >
>> >  > >> Did something in RCU change recently ?
>> >  > >
>> >  > > Not since -rc1, as far as I know, anyway.
>> >  >
>> >  > I have patches to delete this whole fscking sysret fast but not really
>> >  > fast path.  I'll resend them for 3.19.  In the mean time, can you test
>> >  > this patch by itself:
>> >  >
>> >  > https://git.kernel.org/cgit/linux/kernel/git/luto/linux.git/commit/?h=x86/entry&id=1072a16a8d4ad1b11b8062f76e3236b9771b0fb6
>> >
>> > With that applied, I no longer see the trace.
>> >
>>
>> Thanks.
>>
>> The bug is that SCHEDULE_USER in sysret_schedule is wrong.  I'd
>> suggest adding a warning to schedule_user that fires if context
>> tracking thinks we're already in the kernel.
>>
>> FWIW, I think that the rest of the SCHEDULE_USER calls may be wrong,
>> too.  In particular, the one in int_careful looks wrong as well, so I
>> don't see why my patch made a difference if I'm right.
>>
>> Frédéric, any ideas here?  As a stopgap measure, making SCHEDULE_USER
>> restore the previous state might make sense for 3.18.
>
> I don't know. It's possible that something went wrong with the recent entry_64.S
> and ptrace.c rework.
>
> Previously we expected to set context tracking to user state from syscall_trace_exit()
> and to kernel state from syscall_trace_enter(). And if anything using RCU
> was called between syscall_trace_exit() and the actual return to userspace, the code
> had to be wrapped between user_exit() *code* user_enter().
>
> So it looked like this:
>
>
>            syscall {
>                 //enter kernel
>                 syscall_trace_enter() {
>                     user_exit();
>                 }
>
>                 syscall()
>
>                 syscall_trace_enter() {

Do you mean syscall_trace_leave()?  But syscall_trace_leave isn't called here...

>                     user_enter();
>                 }
>
>                 while (test_thread_flag(TIF_EXIT_WORK)) {
>                     if (need_resched()) {
>                         schedule_user() {
>                             user_exit();
>                             schedule()
>                             user_enter();
>                         }
>                     }
>
>                     if ( need signal ) {
>                          do_notify_resume() {
>                             user_exit()
>                             handle signal and stuff
>                             user_enter()
>                          }
>                     }

... it's called hereabouts or so.

>                  }
>             }
>
> This is suboptimal but it doesn't impact the syscall fastpath
> and it's correct from cputime accounting and RCU point of views.
>
> Now maybe the recent logic rework broke the above assumptions?

The big rework was entry, not exit, so I don't see the issue.

In any case, might it make sense to add warnings to user_exit and
user_enter to ensure that they're called in the state in which they
should be called?

--Andy

-- 
Andy Lutomirski
AMA Capital Management, LLC
