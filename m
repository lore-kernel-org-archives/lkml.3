Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751360Ab3LKAZR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 19:25:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62815 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750856Ab3LKAZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 19:25:15 -0500
Date: Tue, 10 Dec 2013 19:23:30 -0500
From: Dave Jones <davej@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>
Subject: Re: process 'stuck' at exit.
Message-ID: <20131211002330.GA12924@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Oleg Nesterov <oleg@redhat.com>,
	Darren Hart <dvhart@linux.intel.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>
References: <20131210203559.GA1209@redhat.com>
 <20131210204925.GB27373@redhat.com>
 <20131210213431.GA6342@redhat.com>
 <20131210214143.GG27373@redhat.com>
 <CA+55aFwr2e5x13fA+QWjt=iJFmCcugFErdqaeeUtH4XPBExC6Q@mail.gmail.com>
 <CA+55aFxLbFWhgzg=Rn0rhUpoOjbTE3QqUSxHTsCyk8GjDUFxJg@mail.gmail.com>
 <alpine.DEB.2.02.1312102329201.28330@ionos.tec.linutronix.de>
 <CA+55aFzhCSvc4Vy7tEC2K972h+vne6Y0QSekDDZbV_ATB-9mxw@mail.gmail.com>
 <20131210230009.GF5050@redhat.com>
 <20131211000504.GA13710@home.goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131211000504.GA13710@home.goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 07:05:04PM -0500, Steven Rostedt wrote:
 > On Tue, Dec 10, 2013 at 06:00:09PM -0500, Dave Jones wrote:
 > > 
 > > The only thing I'm still unclear on, is how that pid allegedly wasn't doing
 > > a futex call as part of its run. The only thing I can think of is that
 > > the other pid that _did_ do a futex call did it on a page that was MAP_SHARED
 > > between all the other children, and this 'spin forever' thing only
 > > happens when the last process with a reference on that page exits ?
 > 
 > Which thread did not do the futex call? The one that was spinning? No, that one
 > most definitely was, at least according to the stack trace trace you posted:
 > 
 >  trinity-child27-10818 [001] 89790.703547: kernel_stack:         <stack trace>
 > => futex_requeue (ffffffff810df18a)
 > => do_futex (ffffffff810e019e)
 > => SyS_futex (ffffffff810e0de1)
 > => tracesys (ffffffff81760be4)  
 > 
 > It did a futex() system call.
 > 
 > Or are you talking about another thread?

It's the same thread. but here's what it says the last thing it did was..

(gdb) print shm->previous_syscallno[27]
$1 = 288

accept4.

Just to verify I'm looking at the right array member..

(gdb) print shm->pids[27]
$2 = 10818

Oh, hmm. Wait, I'm an idiot.
I only update ->previous when we come back from the syscall.
It's _still_ doing this syscall.  

(gdb) print shm->syscallno[27]
$4 = 202

I was distracted by seeing all the other threads exiting, so I was only looking at
what this one had already done.

ok, mystery solved. derp.

	Dave

