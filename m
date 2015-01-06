Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932128AbbAFLBd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 06:01:33 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:33043 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755003AbbAFLBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 06:01:31 -0500
Date: Tue, 6 Jan 2015 12:01:12 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Dave Jones <davej@codemonkey.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Kent Overstreet <kmo@daterainc.com>, Chris Mason <clm@fb.com>
Subject: Re: Linux 3.19-rc3
Message-ID: <20150106110112.GQ29390@twins.programming.kicks-ass.net>
References: <CA+icZUU4ALYvEq7SkUewnZytf62R0d9x+MVPvMrR0zzFf+-f3Q@mail.gmail.com>
 <20150106094039.GI29390@twins.programming.kicks-ass.net>
 <CA+icZUUcgP=nUPCOfEJrbO9OAAPLgQd8RWO-BJe+W0wi3fWiOw@mail.gmail.com>
 <CA+icZUUThdtXkRztRxk+zEqvMwUmEQeSoR3WD3qqXW9QspBoVw@mail.gmail.com>
 <20150106100621.GL29390@twins.programming.kicks-ass.net>
 <CA+icZUVy2rG3PwKhPTQojLEH2O8FD-0myO2sN8hQV4_+r9YNQQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+icZUVy2rG3PwKhPTQojLEH2O8FD-0myO2sN8hQV4_+r9YNQQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2015 at 11:18:04AM +0100, Sedat Dilek wrote:
> On Tue, Jan 6, 2015 at 11:06 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Tue, Jan 06, 2015 at 10:57:19AM +0100, Sedat Dilek wrote:
> >> [   88.028739]  [<ffffffff8124433f>] aio_read_events+0x4f/0x2d0
> >>
> >
> > Ah, that one. Chris Mason and Kent Overstreet were looking at that one.
> > I'm not touching the AIO code either ;-)
> 
> I know, I was so excited when I see nearly the same output.
> 
> Can you tell me why people see "similiar" problems in different areas?

Because the debug check is new :-) It's a pattern that should not be
used but mostly works most of the times.

> [  181.397024] WARNING: CPU: 0 PID: 2872 at kernel/sched/core.c:7303
> __might_sleep+0xbd/0xd0()
> [  181.397028] do not call blocking ops when !TASK_RUNNING; state=1
> set at [<ffffffff810b83bd>] prepare_to_wait_event+0x5d/0x110
> 
> With similiar buzzwords... namely...
> 
> mutex_lock_nested
> prepare_to_wait(_event)
> __might_sleep
> 
> I am asking myself... Where is the real root cause - in sched/core?
> Fix one single place VS. fix the impact at several other places?

No, the root cause is nesting sleep primitives, this is not fixable in
the one place, both prepare_to_wait and mutex_lock are using
task_struct::state, they have to, no way around it.
