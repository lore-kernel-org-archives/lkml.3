Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752533AbaGaQrq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 12:47:46 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:51792 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153AbaGaQro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 12:47:44 -0400
Date: Thu, 31 Jul 2014 09:47:39 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, bobby.prani@gmail.com
Subject: Re: [PATCH v2 tip/core/rcu 01/10] rcu: Add call_rcu_tasks()
Message-ID: <20140731164739.GT11241@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140731003914.GA3872@linux.vnet.ibm.com>
 <1406767182-4356-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <53D9F084.7000706@cn.fujitsu.com>
 <20140731160924.GR11241@linux.vnet.ibm.com>
 <20140731162030.GY19379@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140731162030.GY19379@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14073116-0928-0000-0000-000003CB13C5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2014 at 06:20:30PM +0200, Peter Zijlstra wrote:
> On Thu, Jul 31, 2014 at 09:09:24AM -0700, Paul E. McKenney wrote:
> > Well, that is one of the questions in the 0/10 cover letter.  If it turns
> > out to be necessary to worry about idle-task trampolines, it should be
> > possible to avoid hammering all idle CPUs in the common case.  Though maybe
> > battery-powered devices won't need RCU-tasks.
> 
> So do we really need this to be a full blown RCU implementation? Could
> we not live with something like a task_barrier() function that
> guarantees the same as this rcu_task_synchronize() or somesuch?
> 
> So for rostedt's case he could patch out all trampolines, call
> task_barrier() and then free them.
> 
> We can make task_barrier() force each cpu to resched once -- which, if
> we do that after the task's have all scheduled once, could be the empty
> set.
> 
> It also pushes the cost of this machinery into the caller of
> task_barrier() and not in some random kthread (yet another one).

The idea here is to avoid having the kthread and to avoid providing
callbacks, but to instead do the work currently done by the kthread
in a synchronous function called by the updater?

My concern with this approach is that I bet that Steven will want
to have multiple concurrent calls to remove trampolines, and if I
need to support that efficiently, I end up with more-painful counter
tricks instead of the current callbacks.

Or am I confused about what you are suggesting?

> Now, if only task_work would work for kernel threads, then we could do
> something far nicer...

OK, I'll bite...  What is task_work?  I am guessing that you are not
talking about struct ql4_task_data in drivers/scsi/qla4xxx/ql4_def.h.  ;-)

							Thanx, Paul

