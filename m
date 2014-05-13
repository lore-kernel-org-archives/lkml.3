Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846AbaEMUUx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 16:20:53 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:26765 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752884AbaEMUUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 16:20:44 -0400
Date: Tue, 13 May 2014 16:20:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Darren Hart <darren@dvhart.com>, Davidlohr Bueso <davidlohr@hp.com>,
        Ingo Molnar <mingo@kernel.org>, Clark Williams <williams@redhat.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Carlos ODonell <carlos@redhat.com>, Jakub Jelinek <jakub@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [patch 1/3] rtmutex: Add missing deadlock check
Message-ID: <20140513162041.3405b668@gandalf.local.home>
In-Reply-To: <alpine.DEB.2.02.1405132117110.6261@ionos.tec.linutronix.de>
References: <20140512190438.314125476@linutronix.de>
	<20140512201700.999660035@linutronix.de>
	<5371B2D9.8060405@cn.fujitsu.com>
	<20140513084815.GB2485@laptop.programming.kicks-ass.net>
	<alpine.DEB.2.02.1405132117110.6261@ionos.tec.linutronix.de>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 May 2014 21:42:54 +0200 (CEST)
Thomas Gleixner <tglx@linutronix.de> wrote:

> On Tue, 13 May 2014, Peter Zijlstra wrote:
> > 
> > Now, if you and Steve get this sorted, nothing really happened except
> > that Thomas got grumpy, which is entirely normal, what else would he be?
> > :-)
> 
> Who is that grumpy Thomas dude, should I know him?
> 
> Lai, Steven,
> 
> before you waste lots of time on the tester, I want to look at it
> whether we can simplify it or even rewrite it from scratch. I glanced
> at it today and I really can't remember what kind of substances were
> involved when I wrote this almost a decade ago.

Thank God. /me removes the ton of trace_printk()s in the code as well
as all the trace_marker.write("%s" %(line)) from the test to figure out
what was going on.

> 
> The whole schedule_rt_mutex mechanism was mostly done to create
> controlled lock stealing scenarios and deal with the BKL
> oddities.
> 
> With Lai's simplification and the demise of BKL I'm quite sure we do
> not need it anymore.
> 
> So we can just get rid of the complexity in schedule_rt_mutex() and
> replace it with a simple:
> 
>     while (!td->continue)
>     	  schedule();
> 
> That would also make the teardown and reset of the whole thing
> manageable. Right now it's easy to create a situation where unrolling
> stuff gets almost impossible except by pushing the reset button.
> 
> The state readouts can be done directly via the rtmutexes and the task
> structs.
> 
> Thoughts?
> 

What about having a module that creates a bunch of threads and forces
all the scenarios that we want to test? Wouldn't it be easier to do
than to have a userspace interface to dictate commands to the kernel?

-- Steve
