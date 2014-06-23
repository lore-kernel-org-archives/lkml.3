Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753661AbaFWSJy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 14:09:54 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:58288 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470AbaFWSJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 14:09:52 -0400
Date: Mon, 23 Jun 2014 11:09:45 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        fweisbec@gmail.com, oleg@redhat.com, ak@linux.intel.com, cl@gentwo.org,
        umgwanakikbuti@gmail.com
Subject: Re: [PATCH tip/core/rcu] Reduce overhead of cond_resched() checks
 for RCU
Message-ID: <20140623180945.GL4603@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140621025958.GA7185@linux.vnet.ibm.com>
 <53A85BF9.7030006@intel.com>
 <53A8611F.1000804@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53A8611F.1000804@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14062318-1542-0000-0000-000002C5D305
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2014 at 10:17:19AM -0700, Dave Hansen wrote:
> On 06/23/2014 09:55 AM, Dave Hansen wrote:
> > This still has a regression.  Commit 1ed70de (from Paul's git tree),
> > gets a result of 52231880.  If I back up two commits to v3.16-rc1 and
> > revert ac1bea85 (the original culprit) the result goes back up to 57308512.
> > 
> > So something is still going on here.
> > 
> > I'll go back and compare the grace period ages to see if I can tell what
> > is going on.
> 
> RCU_TRACE interferes with the benchmark a little bit, and it lowers the
> delta that the regression causes.  So, evaluate this cautiously.

RCU_TRACE does increase overhead somewhat, so I would expect somewhat
less difference with it enabled.  Though I am a bit surprised that the
overhead of its counters is measurable.  Or is something going on?

> According to rcu_sched/rcugp, the average "age" is:
> 
> v3.16-rc1, with ac1bea85 reverted:	10.7
> v3.16-rc1, plus e552592e:		 6.1
> 
> Paul, have you been keeping an eye on rcugp?  Even if I run my system
> with only 10 threads, I still see this basic pattern where the average
> "age" is lower when I see lower performance.  It seems to be a
> reasonable proxy that could be used instead of waiting on me to re-run
> tests.

I do print out GPs/sec when running rcutorture, and they do vary somewhat,
but mostly with different Kconfig parameter settings.  Plus rcutorture
ramps up and down, so the GPs/sec is less than what you might see in a
system running an unvarying workload.  That said, increasing grace-period
latency is not always good for performance, in fact, I usually get beaten
up for grace periods completing too quickly rather than too slowly.
This current issue is one of the rare exceptions, perhaps even the
only exception.

So let's see...  The open1 benchmark sits in a loop doing open()
and close(), and probably spends most of its time in the kernel.
It doesn't do much context switching.  I am guessing that you don't
have CONFIG_NO_HZ_FULL=y, or the boot/sysfs parameter would not have
much effect because then the first quiescent-state-forcing attempt would
likely finish the grace period.

So, given that short grace periods help other workloads (I have the
scars to prove it), and given that the patch fixes some real problems,
and given that the large number for rcutree.jiffies_till_sched_qs got
us within 3%, shouldn't we consider this issue closed?

							Thanx, Paul

