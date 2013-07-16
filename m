Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933787Ab3GPWsK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 18:48:10 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:26042 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933246Ab3GPWsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 18:48:08 -0400
Message-ID: <1374014881.2332.21.camel@j-VirtualBox>
Subject: Re: [RFC] sched: Limit idle_balance() when it is being used too
 frequently
From: Jason Low <jason.low2@hp.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
        Paul Turner <pjt@google.com>, Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, aswin@hp.com, scott.norton@hp.com,
        chegu_vinod@hp.com
Date: Tue, 16 Jul 2013 15:48:01 -0700
In-Reply-To: <20130716202015.GX17211@twins.programming.kicks-ass.net>
References: <1374002463.3944.11.camel@j-VirtualBox>
	 <20130716202015.GX17211@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-16 at 22:20 +0200, Peter Zijlstra wrote:
> On Tue, Jul 16, 2013 at 12:21:03PM -0700, Jason Low wrote:
> > When running benchmarks on an 8 socket 80 core machine with a 3.10 kernel,
> > there can be a lot of contention in idle_balance() and related functions.
> > On many AIM7 workloads in which CPUs go idle very often and idle balance
> > gets called a lot, it is actually lowering performance.
> > 
> > Since idle balance often helps performance (when it is not overused), I
> > looked into trying to avoid attempting idle balance only when it is
> > occurring too frequently.
> > 
> > This RFC patch attempts to keep track of the approximate "average" time between
> > idle balance attempts per CPU. Each time the idle_balance() function is
> > invoked, it will compute the duration since the last idle_balance() for
> > the current CPU. The avg time between idle balance attempts is then updated
> > using a very similar method as how rq->avg_idle is computed. 
> > 
> > Once the average time between idle balance attempts drops below a certain
> > value (which in this patch is sysctl_sched_idle_balance_limit), idle_balance
> > for that CPU will be skipped. The average time between idle balances will
> > continue to be updated, even if it ends up getting skipped. The
> > initial/maximum average is set a lot higher though to make sure that the
> > avg doesn't fall below the threshold until the sample size is large and to
> > prevent the avg from being overestimated.
> 
> One of the things I've been talking about for a while now is how I'd
> like to use the idle guestimator used for cpuidle for newidle balance.
> 
> Basically based on the estimated idle time limit how far/wide you'll
> search for tasks to run.
> 
> You can remove the sysctl and auto-tune by measuring how long it takes
> on avg to do a newidle balance.

Hi Peter,

When you say how long it takes on avg to do a newidle balance, are you
referring to the avg time it takes for each call to CPU_NEWLY_IDLE
load_balance() to complete, or the avg time it takes for newidle balance
attempts within a domain to eventually successfully pull/move a task(s)?

Thanks,
Jason

