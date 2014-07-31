Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251AbaGaVLe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 17:11:34 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:33514 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375AbaGaVLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 17:11:32 -0400
Date: Thu, 31 Jul 2014 14:11:26 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: josh@joshtriplett.org
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, bobby.prani@gmail.com
Subject: Re: [PATCH v2 tip/core/rcu 0/10] RCU-tasks implementation
Message-ID: <20140731211126.GE11241@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140731003914.GA3872@linux.vnet.ibm.com>
 <20140731161902.GA12697@cloud>
 <20140731165843.GV11241@linux.vnet.ibm.com>
 <20140731172024.GF12697@cloud>
 <20140731183816.GA11241@linux.vnet.ibm.com>
 <20140731205817.GB13837@cloud>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140731205817.GB13837@cloud>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14073121-6688-0000-0000-000003B0020D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2014 at 01:58:17PM -0700, josh@joshtriplett.org wrote:
> On Thu, Jul 31, 2014 at 11:38:16AM -0700, Paul E. McKenney wrote:
> > On Thu, Jul 31, 2014 at 10:20:24AM -0700, josh@joshtriplett.org wrote:
> > > On Thu, Jul 31, 2014 at 09:58:43AM -0700, Paul E. McKenney wrote:
> > > > On Thu, Jul 31, 2014 at 09:19:02AM -0700, josh@joshtriplett.org wrote:
> > > > > On Wed, Jul 30, 2014 at 05:39:14PM -0700, Paul E. McKenney wrote:
> > > > > > This series provides a prototype of an RCU-tasks implementation, which has
> > > > > > been requested to assist with tramopoline removal.  This flavor of RCU
> > > > > > is task-based rather than CPU-based, and has voluntary context switch,
> > > > > > usermode execution, and the idle loops as its only quiescent states.
> > > > > > This selection of quiescent states ensures that at the end of a grace
> > > > > > period, there will no longer be any tasks depending on a trampoline that
> > > > > > was removed before the beginning of that grace period.  This works because
> > > > > > such trampolines do not contain function calls, do not contain voluntary
> > > > > > context switches, do not switch to usermode, and do not switch to idle.
> > > > > 
> > > > > I'm concerned about the amount of system overhead this introduces.
> > > > > Polling for holdout tasks seems quite excessive.  If I understand the
> > > > > intended use case correctly, the users of this will want to free
> > > > > relatively small amounts of memory; thus, waiting a while to do so seems
> > > > > fine, especially if the system isn't under any particular memory
> > > > > pressure.
> > > > > 
> > > > > Thus, rather than polling, could you simply flag the holdout
> > > > > tasks, telling the scheduler "hey, next time you don't have anything
> > > > > better to do..."?  Then don't bother with them again unless the system
> > > > > runs low on memory and asks you to free some.  (And mandate that you can
> > > > > only use this to free memory rather than for any other purpose.)
> > > > 
> > > > One of the many of my alternative suggestions that Steven rejected was
> > > > to simply leak the memory.  ;-)
> > > > 
> > > > But from what I can see, if we simply flag the holdout tasks, we
> > > > either are also holding onto the task_struct structures, re-introducing
> > > > concurrency to the list of holdout tasks, or requiring that the eventual
> > > > scan for holdout tasks scan the entire task list.  Neither of these seems
> > > > particularly appetizing to me.
> > > > 
> > > > The nice thing about Lai Jiangshan's suggestion is that it allows the
> > > > scan of the holdout list to be done completely unsynchronized, which
> > > > allows pauses during the scan, thus allowing the loop to check for
> > > > competing work on that CPU.  This should get almost all the effect
> > > > of indefinite delay without the indefinite delay (at least in the
> > > > common case).
> > > > 
> > > > Or am I missing something here?
> > > 
> > > If you only allow a single outstanding set of callbacks at a time, you
> > > could have a single flag stored in the task, combined with a count
> > > stored with the set of callbacks.  Each time one of the holdout tasks
> > > comes up, clear the flag and decrement the count.  If and only if you
> > > get asked to free up memory, start poking the scheduler to bring up
> > > those tasks.  When the count hits 0, free the memory.
> > > 
> > > The set of trampolines won't change often, and presumably only changes
> > > in response to user-driven requests to trace or stop tracing things.
> > > So, if you have to wait for the existing set of callbacks to go away
> > > before adding more, that seems fine.  And you could then ditch polling
> > > entirely.
> > 
> > If I understand what you are suggesting, this requires hooks in the
> > scheduler.  I used to have hooks in the scheduler, but I dropped them in
> > favor of polling the voluntary context-switch count in response to Peter
> > Zijlstra's concerns about adding overhead to the scheduler's fastpaths.
> > 
> > Therefore, although the flags are sometimes cleared externally from the
> > scheduling-clock interrupt (for usermode execution), it is quite possible
> > that a given task might never have its flag cleared asynchronously.
> > 
> > Another approach might be to poll more slowly or to make the polling
> > evict itself if it detects that this CPU has something else to do.
> > Would either or both of these help?
> 
> As discussed at lunch today, another option would be to drop the thread
> and handle cleanup synchronously from the caller in the tracing code, or
> fire off a kthread *on request* to handle it asynchronously.  That would
> avoid paying the startup and overhead on a system that has tracing in
> the kernel but never uses it, as will likely occur with distro kernels.

Good points!

As discussed, I am more inclined towards the second approach than
towards the first, but let me get v3 tested and posted and then see how
things look.

							Thanx, Paul

