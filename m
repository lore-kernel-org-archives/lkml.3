Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598AbaEMTnF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 15:43:05 -0400
Received: from www.linutronix.de ([62.245.132.108]:37690 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563AbaEMTnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 15:43:01 -0400
Date: Tue, 13 May 2014 21:42:54 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: Lai Jiangshan <laijs@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Darren Hart <darren@dvhart.com>, Davidlohr Bueso <davidlohr@hp.com>,
        Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Clark Williams <williams@redhat.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Carlos ODonell <carlos@redhat.com>, Jakub Jelinek <jakub@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [patch 1/3] rtmutex: Add missing deadlock check
In-Reply-To: <20140513084815.GB2485@laptop.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.02.1405132117110.6261@ionos.tec.linutronix.de>
References: <20140512190438.314125476@linutronix.de> <20140512201700.999660035@linutronix.de> <5371B2D9.8060405@cn.fujitsu.com> <20140513084815.GB2485@laptop.programming.kicks-ass.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 May 2014, Peter Zijlstra wrote:
> 
> Now, if you and Steve get this sorted, nothing really happened except
> that Thomas got grumpy, which is entirely normal, what else would he be?
> :-)

Who is that grumpy Thomas dude, should I know him?

Lai, Steven,

before you waste lots of time on the tester, I want to look at it
whether we can simplify it or even rewrite it from scratch. I glanced
at it today and I really can't remember what kind of substances were
involved when I wrote this almost a decade ago.

The whole schedule_rt_mutex mechanism was mostly done to create
controlled lock stealing scenarios and deal with the BKL
oddities.

With Lai's simplification and the demise of BKL I'm quite sure we do
not need it anymore.

So we can just get rid of the complexity in schedule_rt_mutex() and
replace it with a simple:

    while (!td->continue)
    	  schedule();

That would also make the teardown and reset of the whole thing
manageable. Right now it's easy to create a situation where unrolling
stuff gets almost impossible except by pushing the reset button.

The state readouts can be done directly via the rtmutexes and the task
structs.

Thoughts?

Thanks,

	tglx
