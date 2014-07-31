Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752362AbaGaQ6u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 12:58:50 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:47826 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859AbaGaQ6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 12:58:49 -0400
Date: Thu, 31 Jul 2014 09:58:43 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: josh@joshtriplett.org
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, bobby.prani@gmail.com
Subject: Re: [PATCH v2 tip/core/rcu 0/10] RCU-tasks implementation
Message-ID: <20140731165843.GV11241@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140731003914.GA3872@linux.vnet.ibm.com>
 <20140731161902.GA12697@cloud>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140731161902.GA12697@cloud>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14073116-1542-0000-0000-000003AC4DD8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2014 at 09:19:02AM -0700, josh@joshtriplett.org wrote:
> On Wed, Jul 30, 2014 at 05:39:14PM -0700, Paul E. McKenney wrote:
> > This series provides a prototype of an RCU-tasks implementation, which has
> > been requested to assist with tramopoline removal.  This flavor of RCU
> > is task-based rather than CPU-based, and has voluntary context switch,
> > usermode execution, and the idle loops as its only quiescent states.
> > This selection of quiescent states ensures that at the end of a grace
> > period, there will no longer be any tasks depending on a trampoline that
> > was removed before the beginning of that grace period.  This works because
> > such trampolines do not contain function calls, do not contain voluntary
> > context switches, do not switch to usermode, and do not switch to idle.
> 
> I'm concerned about the amount of system overhead this introduces.
> Polling for holdout tasks seems quite excessive.  If I understand the
> intended use case correctly, the users of this will want to free
> relatively small amounts of memory; thus, waiting a while to do so seems
> fine, especially if the system isn't under any particular memory
> pressure.
> 
> Thus, rather than polling, could you simply flag the holdout
> tasks, telling the scheduler "hey, next time you don't have anything
> better to do..."?  Then don't bother with them again unless the system
> runs low on memory and asks you to free some.  (And mandate that you can
> only use this to free memory rather than for any other purpose.)

One of the many of my alternative suggestions that Steven rejected was
to simply leak the memory.  ;-)

But from what I can see, if we simply flag the holdout tasks, we
either are also holding onto the task_struct structures, re-introducing
concurrency to the list of holdout tasks, or requiring that the eventual
scan for holdout tasks scan the entire task list.  Neither of these seems
particularly appetizing to me.

The nice thing about Lai Jiangshan's suggestion is that it allows the
scan of the holdout list to be done completely unsynchronized, which
allows pauses during the scan, thus allowing the loop to check for
competing work on that CPU.  This should get almost all the effect
of indefinite delay without the indefinite delay (at least in the
common case).

Or am I missing something here?

> Also, ideally this should remain entirely optional; nothing in the core
> kernel should depend on it.

Agreed, the CONFIG_TASKS_RCU is not likely to disappear anytime soon.
I therefore do not see RCU-tasks as an obstacle to kernel tinification.
I also would also guess that you might complain if someone does try to
use if from the tinified core of the Linux kernel.  ;-)

							Thanx, Paul

