Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756289AbaCNXCh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 19:02:37 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:34304 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756175AbaCNXCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 19:02:35 -0400
Date: Fri, 14 Mar 2014 16:02:31 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] [RFC] perf: Fix a race between ring_buffer_detach() and
 ring_buffer_wakeup()
Message-ID: <20140314230231.GM21124@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1394199526-6400-1-git-send-email-alexander.shishkin@linux.intel.com>
 <20140313195816.GJ21124@linux.vnet.ibm.com>
 <20140314095033.GP27965@twins.programming.kicks-ass.net>
 <20140314204736.GG21124@linux.vnet.ibm.com>
 <20140314224317.GQ30956@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140314224317.GQ30956@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14031423-3532-0000-0000-000000528319
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2014 at 11:43:17PM +0100, Peter Zijlstra wrote:
> On Fri, Mar 14, 2014 at 01:47:37PM -0700, Paul E. McKenney wrote:
> > This general idea can be made to work, but it will need some
> > internal-to-RCU help.  One vulnerability of the patch below is the
> > following sequence of steps:
> > 
> > 1.	RCU has just finished a grace period, and is doing the
> > 	end-of-grace-period accounting.
> > 
> > 2.	The code below invokes rcu_batches_completed().  Let's assume
> > 	the result returned is 42.
> > 
> > 3.	RCU completes the end-of-grace-period accounting, and increments
> > 	rcu_sched_state.completed.
> > 
> > 4.	The code below checks ->rcu_batches against the result from
> > 	another invocation of rcu_batches_completed() and sees that
> > 	the 43 is not equal to 42, so skips the synchronize_rcu().
> > 
> > Except that a grace period has not actually completed.  Boom!!!
> > 
> > The problem is that rcu_batches_completed() is only intended to give
> > progress information on RCU.
> 
> Ah, I thought I was missing something when I was looking through the rcu
> code in a hurry :-)

Well, given that I sometimes miss things when looking through RCU code
carefuly, I guess I cannot give you too much trouble about it.

> I knew there'd be some subtlety between completed and gpnum and such :-)

Some of which I have learned about one RCU bug at a time.  ;-)

> > What I can do is give you a pair of functions, one to take a snapshot of
> > the current grace-period state (returning an unsigned long) and another
> > to evaluate a previous snapshot, invoking synchronize_rcu() if there has
> > not been a full grace period in the meantime.
> > 
> > The most straightforward approach would invoke acquiring the global
> > rcu_state ->lock on each call, which I am guessing just might be
> > considered to be excessive overhead.  ;-)  I should be able to decrease
> > the overhead to a memory barrier on each call, and perhaps even down
> > to an smp_load_acquire().  Accessing the RCU state probably costs you
> > a cache miss both times.
> > 
> > Thoughts?
> 
> Sounds fine, the attach isn't a hotpath, so even the locked version
> should be fine, but I won't keep you from making it all fancy and such
> :-)

Fair enough, let me see what I can come up with.

							Thanx, Paul

