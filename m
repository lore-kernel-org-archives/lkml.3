Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751781Ab3LJVNL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 16:13:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61181 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750840Ab3LJVNJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 16:13:09 -0500
Date: Tue, 10 Dec 2013 16:12:20 -0500
From: Dave Jones <davej@redhat.com>
To: Darren Hart <dvhart@linux.intel.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>
Subject: Re: process 'stuck' at exit.
Message-ID: <20131210211220.GE27373@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Darren Hart <dvhart@linux.intel.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>
References: <20131210154724.GA30020@redhat.com>
 <CA+55aFxgFAfcQKDoDhmJcCRb5pfxumxJ9OmpUhhNzs+CY_Yqqw@mail.gmail.com>
 <alpine.DEB.2.02.1312102001090.28330@ionos.tec.linutronix.de>
 <CA+55aFzLnheC6W+Db=-MVr6aR5UzP-c1Q1yk_aN-9gxSjUpANw@mail.gmail.com>
 <20131210203559.GA1209@redhat.com>
 <20131210204925.GB27373@redhat.com>
 <1386709583.3685.78.camel@dvhart-mobl4.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386709583.3685.78.camel@dvhart-mobl4.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 01:06:23PM -0800, Darren Hart wrote:
 > On Tue, 2013-12-10 at 15:49 -0500, Dave Jones wrote:
 > > On Tue, Dec 10, 2013 at 09:35:59PM +0100, Oleg Nesterov wrote:
 > >  > Dave, I must have missed something, help.
 > >  > 
 > >  > I am looking at the first message and I can't understand who stuck
 > >  > "at exit".
 > >  > 
 > >  > The trace shows that the task with pid=10818 called sys_futex() ?
 > >  >
 > >  > Perhaps "exit" means the userspace paths?
 > > 
 > > pid 1131 is wait()'ing for 10818 to exit
 > > 
 > > pid 1130 is periodically sending SIGKILL to 10818 because it's gotten
 > > tired of waiting. 10818 is ignoring these because it's stuck in a loop
 > > somewhere in the kernel.
 > > 
 > > I tried attaching to 10818 with gdb, and it just hangs.
 > > (possibly because its weird stack situation [see 1st post])
 > > 
 > > by inspecting the shared mapping that all processes have (by gdb'ing 1130)
 > > I can see that 10818 did all its full run without incident, and the
 > > "exit child" flag in the fuzzer had been in set.
 > > 
 > > The last 'random syscall' the fuzzer did was to sys_accept4, so the futex call
 > > must come from somewhere in libc maybe ?
 > 
 > If that is the case, then Linus' requeue_pi path is highly unlikely as
 > FUTEX_CMP_REQUEUE_PI is not used by glibc (yet). That gives me hope as
 > that way there be dragons. Knowing exactly what syscall was made would
 > be very useful, but I don't know if that information is even available
 > anymore.

So that last syscall _that_ 'stuck' thread did was accept4, but I found
another pid that had done a futex call just before it exited.
(see other mail)

What I don't understand is how the running child has futex as part of
its stack trace, when the internal log that trinity keeps has on record
for that particular pid having called it.

	Dave

