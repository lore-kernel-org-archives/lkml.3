Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751863Ab3LJVj3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 16:39:29 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:30737 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751280Ab3LJVj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 16:39:28 -0500
Date: Tue, 10 Dec 2013 16:39:25 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Darren Hart <dvhart@linux.intel.com>, Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: process 'stuck' at exit.
Message-ID: <20131210163925.6f5ecad1@gandalf.local.home>
In-Reply-To: <alpine.DEB.2.02.1312102227200.28330@ionos.tec.linutronix.de>
References: <20131210154724.GA30020@redhat.com>
	<CA+55aFxgFAfcQKDoDhmJcCRb5pfxumxJ9OmpUhhNzs+CY_Yqqw@mail.gmail.com>
	<alpine.DEB.2.02.1312102001090.28330@ionos.tec.linutronix.de>
	<CA+55aFzLnheC6W+Db=-MVr6aR5UzP-c1Q1yk_aN-9gxSjUpANw@mail.gmail.com>
	<20131210202752.GA27373@redhat.com>
	<alpine.DEB.2.02.1312102133400.28330@ionos.tec.linutronix.de>
	<20131210205523.GC27373@redhat.com>
	<1386710734.3685.85.camel@dvhart-mobl4.amr.corp.intel.com>
	<alpine.DEB.2.02.1312102227200.28330@ionos.tec.linutronix.de>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Dec 2013 22:28:01 +0100 (CET)
Thomas Gleixner <tglx@linutronix.de> wrote:

> On Tue, 10 Dec 2013, Darren Hart wrote:
> > On Tue, 2013-12-10 at 15:55 -0500, Dave Jones wrote:
> > > On Tue, Dec 10, 2013 at 09:34:24PM +0100, Thomas Gleixner wrote:
> > >  
> > >  > >  > PS: Oleg - the whole thread is on lkml. Ping me if you need more context.
> > >  > > 
> > >  > > btw, I've left the machine in that state, and will for as long as necesary
> > >  > > in case someone has any ideas for further tracing experiments.
> > >  > 
> > >  > Can you gather a trace with the function tracer? That will tell us
> > >  > what the thing is actually doing.
> > > 
> > > Feed me command lines, and I'll see what I can do.
> > > 
> > > 	Dave
> > > 
> > 
> > So let's see if we can determine the call chain inside futex_requeue, if
> > there is one. We want to see if we are calling the following functions:
> > 
> > futex.c: free_pi_state
> > futex.c: get_futex_value_locked
> > futex.c: futex_proxy_trylock_atomic
> > futex.c: lookup_pi_state
> > futex.c: fault_in_user_writeable
> > 
> > I'm hoping we can make use of ftrace here?
> > 
> > Consider:
> > 
> > $ trace-cmd record -P <PID> -p function -l '*futex*'

Note the above just picks functions that have "futex" in its name, and
will not include all the functions you listed above.

> > 
> > And to try outside of futex:
> > 
> > $ trace-cmd record -P <PID> -p function
> > 
> > Then ^C after a few seconds. The trace will be in trace.dat
> 
> We definitely want the latter. The futex code gets compiled into some
> badly traceable mess.

Yeah, lets use all functions. If its in a loop, we should see exactly
what is happening, with full function tracing.

You may be able to simplify it to just:

	trace-cmd record -p function sleep 10

and then read the trace. Nasty loopers usually dominate these types of
traces so no need to filter on them in the recording.

-- Steve
