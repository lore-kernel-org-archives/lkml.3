Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286AbbAFLiZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 06:38:25 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:33690 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754829AbbAFLiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 06:38:24 -0500
Date: Tue, 6 Jan 2015 03:40:56 -0800
From: Kent Overstreet <kmo@daterainc.com>
To: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Dave Jones <davej@codemonkey.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Chris Mason <clm@fb.com>
Subject: Re: Linux 3.19-rc3
Message-ID: <20150106114056.GB25846@kmo-pixel>
References: <CA+icZUU4ALYvEq7SkUewnZytf62R0d9x+MVPvMrR0zzFf+-f3Q@mail.gmail.com>
 <20150106094039.GI29390@twins.programming.kicks-ass.net>
 <CA+icZUUcgP=nUPCOfEJrbO9OAAPLgQd8RWO-BJe+W0wi3fWiOw@mail.gmail.com>
 <CA+icZUUThdtXkRztRxk+zEqvMwUmEQeSoR3WD3qqXW9QspBoVw@mail.gmail.com>
 <20150106100621.GL29390@twins.programming.kicks-ass.net>
 <CA+icZUVy2rG3PwKhPTQojLEH2O8FD-0myO2sN8hQV4_+r9YNQQ@mail.gmail.com>
 <20150106110112.GQ29390@twins.programming.kicks-ass.net>
 <20150106110730.GA25846@kmo-pixel>
 <CA+icZUWf=qGD2akxozWHp3VQQDPpLJuMMB-UuY+a+L-unV0QnQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+icZUWf=qGD2akxozWHp3VQQDPpLJuMMB-UuY+a+L-unV0QnQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2015 at 12:25:39PM +0100, Sedat Dilek wrote:
> On Tue, Jan 6, 2015 at 12:07 PM, Kent Overstreet <kmo@daterainc.com> wrote:
> > On Tue, Jan 06, 2015 at 12:01:12PM +0100, Peter Zijlstra wrote:
> >> On Tue, Jan 06, 2015 at 11:18:04AM +0100, Sedat Dilek wrote:
> >> > On Tue, Jan 6, 2015 at 11:06 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> >> > > On Tue, Jan 06, 2015 at 10:57:19AM +0100, Sedat Dilek wrote:
> >> > >> [   88.028739]  [<ffffffff8124433f>] aio_read_events+0x4f/0x2d0
> >> > >>
> >> > >
> >> > > Ah, that one. Chris Mason and Kent Overstreet were looking at that one.
> >> > > I'm not touching the AIO code either ;-)
> >> >
> >> > I know, I was so excited when I see nearly the same output.
> >> >
> >> > Can you tell me why people see "similiar" problems in different areas?
> >>
> >> Because the debug check is new :-) It's a pattern that should not be
> >> used but mostly works most of the times.
> >>
> >> > [  181.397024] WARNING: CPU: 0 PID: 2872 at kernel/sched/core.c:7303
> >> > __might_sleep+0xbd/0xd0()
> >> > [  181.397028] do not call blocking ops when !TASK_RUNNING; state=1
> >> > set at [<ffffffff810b83bd>] prepare_to_wait_event+0x5d/0x110
> >> >
> >> > With similiar buzzwords... namely...
> >> >
> >> > mutex_lock_nested
> >> > prepare_to_wait(_event)
> >> > __might_sleep
> >> >
> >> > I am asking myself... Where is the real root cause - in sched/core?
> >> > Fix one single place VS. fix the impact at several other places?
> >>
> >> No, the root cause is nesting sleep primitives, this is not fixable in
> >> the one place, both prepare_to_wait and mutex_lock are using
> >> task_struct::state, they have to, no way around it.
> >
> > No, it's completely possible to construct a prepare_to_wait() that doesn't
> > require messing with the task state. Had it for years.
> >
> > http://evilpiepirate.org/git/linux-bcache.git/log/?h=aio_ring_fix
> 
> I am just rebuilding a new kernel with "aio_ring_fix" included - I
> have tested this alread with loop-mq and it made the call-trace in aio
> go away.
> 
> 
> Jut curious...
> How would a patch look like a patch to fix the sched-fanotify issue
> with a conversion to "closure waitlist"?

wait_queue_head_t	-> struct closure_waitlist
DEFINE_WAIT()		-> struct closure cl; closure_init_stack(&cl)
prepare_to_wait()	-> closure_wait(&waitlist, &cl)
schedule()		-> closure_sync()
finish_wait()		-> closure_wake_up(); closure_sync()

That's the standard conversion, I haven't looked at the fanotify code before
just now but from a cursory glance it appears that all should work here. Only
annoying thing is the waitqueue here is actually part of the poll interface (if
I'm reading this correctly), so I dunno what I'd do about that.

Also FYI: closure waitlists are currently singly linked, thus there's no direct
equivalent to finish_wait(), the conversion I gave works but will lead to
spurious wakeups. I kinda figured I was going to have to switch to doubly linked
lists eventually though.
