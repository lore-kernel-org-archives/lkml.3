Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179AbaLCWIl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 17:08:41 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:47031 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbaLCWIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 17:08:40 -0500
Date: Wed, 3 Dec 2014 23:08:37 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Dave Jones <davej@redhat.com>, Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Richard Guy Briggs <rgb@redhat.com>, Eric Paris <eparis@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: audit: rcu_read_lock() used illegally while idle
Message-ID: <20141203220836.GC31369@lerouge>
References: <20141203181922.GA26916@redhat.com>
 <20141203192919.GP25340@linux.vnet.ibm.com>
 <547F6D60.5050007@amacapital.net>
 <20141203201947.GA4931@redhat.com>
 <CALCETrVtKcwWsN4q7kp-K7kEfQyebKfSbBQy4iAhfP0WPVZNpQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALCETrVtKcwWsN4q7kp-K7kEfQyebKfSbBQy4iAhfP0WPVZNpQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2014 at 12:38:36PM -0800, Andy Lutomirski wrote:
> On Wed, Dec 3, 2014 at 12:19 PM, Dave Jones <davej@redhat.com> wrote:
> > On Wed, Dec 03, 2014 at 12:06:56PM -0800, Andy Lutomirski wrote:
> >
> >  > >> Did something in RCU change recently ?
> >  > >
> >  > > Not since -rc1, as far as I know, anyway.
> >  >
> >  > I have patches to delete this whole fscking sysret fast but not really
> >  > fast path.  I'll resend them for 3.19.  In the mean time, can you test
> >  > this patch by itself:
> >  >
> >  > https://git.kernel.org/cgit/linux/kernel/git/luto/linux.git/commit/?h=x86/entry&id=1072a16a8d4ad1b11b8062f76e3236b9771b0fb6
> >
> > With that applied, I no longer see the trace.
> >
> 
> Thanks.
> 
> The bug is that SCHEDULE_USER in sysret_schedule is wrong.  I'd
> suggest adding a warning to schedule_user that fires if context
> tracking thinks we're already in the kernel.
> 
> FWIW, I think that the rest of the SCHEDULE_USER calls may be wrong,
> too.  In particular, the one in int_careful looks wrong as well, so I
> don't see why my patch made a difference if I'm right.
> 
> Frédéric, any ideas here?  As a stopgap measure, making SCHEDULE_USER
> restore the previous state might make sense for 3.18.

I don't know. It's possible that something went wrong with the recent entry_64.S
and ptrace.c rework.

Previously we expected to set context tracking to user state from syscall_trace_exit()
and to kernel state from syscall_trace_enter(). And if anything using RCU
was called between syscall_trace_exit() and the actual return to userspace, the code
had to be wrapped between user_exit() *code* user_enter().

So it looked like this:


           syscall {
                //enter kernel
                syscall_trace_enter() {
                    user_exit();
                }

                syscall()

                syscall_trace_enter() {
                    user_enter();
                }

                while (test_thread_flag(TIF_EXIT_WORK)) {
                    if (need_resched()) {
                        schedule_user() {
                            user_exit();
                            schedule()
                            user_enter();
                        }
                    }

                    if ( need signal ) {
                         do_notify_resume() {
                            user_exit()
                            handle signal and stuff
                            user_enter()
                         }
                    }
                 }
            }

This is suboptimal but it doesn't impact the syscall fastpath
and it's correct from cputime accounting and RCU point of views.

Now maybe the recent logic rework broke the above assumptions?
