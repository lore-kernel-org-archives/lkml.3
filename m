Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757521Ab3JNVvZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 17:51:25 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:39463 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757175Ab3JNVvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 17:51:23 -0400
Date: Mon, 14 Oct 2013 23:51:20 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Knut Petersen <Knut_Petersen@t-online.de>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Greg KH <greg@kroah.com>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [BUG 3.12.rc4] Oops: unable to handle kernel paging request
 during shutdown
Message-ID: <20131014215117.GE13538@localhost.localdomain>
References: <525BD08C.2080101@t-online.de>
 <CA+55aFwN++wO=rTFaH7m6YYQX+Fv3qDt6Hxs7UnPUJpFsrwSkA@mail.gmail.com>
 <20131014212830.GD5790@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131014212830.GD5790@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 14, 2013 at 02:28:30PM -0700, Paul E. McKenney wrote:
> On Mon, Oct 14, 2013 at 10:53:03AM -0700, Linus Torvalds wrote:
> > Hmm. No obvious ideas come to mind, but I'm adding more people to the cc.
> > 
> > Clearly the wait_event_interruptible_timeout() in the RCU grace-period
> > thread causes this, but I'm not seeing why shutdown would trigger it.
> > 
> > The code disassembles to
> > 
> >    0: 85 db                 test   %ebx,%ebx
> >    2: 79 0c                 jns    0x10
> >    4: 81 e6 ff 00 00 00     and    $0xff,%esi
> >    a: 8d 44 f0 30           lea    0x30(%eax,%esi,8),%eax
> >    e: eb 0a                 jmp    0x1a
> >   10: c1 e9 1a             shr    $0x1a,%ecx
> >   13: 8d 84 c8 30 0e 00 00 lea    0xe30(%eax,%ecx,8),%eax
> >   1a: 8b 48 04             mov    0x4(%eax),%ecx
> >   1d: 89 50 04             mov    %edx,0x4(%eax)
> >   20: 89 02                 mov    %eax,(%edx)
> >   22: 89 4a 04             mov    %ecx,0x4(%edx)
> >   25:* 89 11                 mov    %edx,(%ecx) <-- trapping instruction
> >   27: 5b                   pop    %ebx
> >   28: 5e                   pop    %esi
> >   29: 5d                   pop    %ebp
> >   2a: c3                   ret
> > 
> > so the oops is in the final
> > 
> >         list_add_tail(&timer->entry, vec);
> > 
> > where "%ecx" is "vec->prev" (f8c551f4). That looks like it might be a
> > perfectly valid pointer, but clearly it isn't (it's about 115M off the
> > top of virtual memory, I think that might be in the vmalloc area).
> > 
> > So I'm *guessing* that something did a vfree() on some data structure
> > that contained active timers - and then later on the RCU thread ended
> > up being the next thing that tried to add a timer after the
> > now-non-existing one.
> > 
> > And your other oopses do seem to have a similar pattern, even if their
> > actual oops is elsewhere. They oops in run_timer_softirq, also taking
> > a page fault in the 0xf9...... range, so it might well be a vmalloc
> > address there too.
> > 
> > But I sure as hell can't start to guess what that would be.
> > 
> > I'm wondering it CONFIG_DEBUG_OBJECTS (and then
> > CONFIG_DEBUG_OBJECTS_FREE=y and CONFIG_DEBUG_OBJECTS_TIMERS=y) might
> > help catch this...
> 
> I would also like to nominate CONFIG_DEBUG_OBJECTS_RCU_HEAD=y, which
> checks for invoking call_rcu() twice in a row on the same rcu_head.
> 
> Any chance of a look at the .config file?

Yeah it would be nice to get the .config.

Looks like the problem happens on timer softirq during timers callback execution.
The two previous reports from Knut seem to be about the same.

I've been thinking that CONFIG_DEBUG_LIST could help. Unfortunately it's good
to spot list APIs misuse but, if Linus is right, the problem may be that the list
belongs to an object that has been freed, and I believe that won't detect such a thing.

Still it would be nice to try it, in case we are missing some list misuse.

Also knut, do you have a serial line?

If so may be looking at the timer events may help. Could you try to enable the following
timer events?

      echo 1 > /sys/kernel/debug/tracing/events/timer/timer_cancel
      echo 1 > /sys/kernel/debug/tracing/events/timer/timer_expire_entry
      echo 1 > /sys/kernel/debug/tracing/events/timer/timer_expire_exit
      echo 1 > /sys/kernel/debug/tracing/events/timer/timer_init
      echo 1 > /sys/kernel/debug/tracing/events/timer/timer_start

And also enable ftrace_dump_on_oops:

      sysctl kernel.ftrace_dump_on_oops=1

We may have some interesting clues about who manipulated the timer list last before
the oops happened.

Thanks!
