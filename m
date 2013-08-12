Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757162Ab3HLQos (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 12:44:48 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:45593 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756343Ab3HLQoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 12:44:46 -0400
Date: Mon, 12 Aug 2013 09:44:36 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org, Dipankar Sarma <dipankar@in.ibm.com>
Subject: Re: [PATCH 5/8] rcu: eliminate deadlock for rcu read site
Message-ID: <20130812164436.GV29406@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1375871104-10688-1-git-send-email-laijs@cn.fujitsu.com>
 <1375871104-10688-6-git-send-email-laijs@cn.fujitsu.com>
 <20130808204020.GA31127@linux.vnet.ibm.com>
 <5204B6EF.6000905@cn.fujitsu.com>
 <20130812135544.GG27162@twins.programming.kicks-ass.net>
 <20130812151618.GR29406@linux.vnet.ibm.com>
 <20130812162126.GV3008@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130812162126.GV3008@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13081216-4834-0000-0000-00000A16F09C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 12, 2013 at 06:21:26PM +0200, Peter Zijlstra wrote:
> On Mon, Aug 12, 2013 at 08:16:18AM -0700, Paul E. McKenney wrote:
> > On Mon, Aug 12, 2013 at 03:55:44PM +0200, Peter Zijlstra wrote:
> > > On Fri, Aug 09, 2013 at 05:31:27PM +0800, Lai Jiangshan wrote:
> > > > On 08/09/2013 04:40 AM, Paul E. McKenney wrote:
> > > > > One problem here -- it may take quite some time for a set_need_resched()
> > > > > to take effect.  This is especially a problem for RCU priority boosting,
> > > > > but can also needlessly delay preemptible-RCU grace periods because
> > > > > local_irq_restore() and friends don't check the TIF_NEED_RESCHED bit.
> > > > 
> > > > 
> > > > The final effect of deboosting(rt_mutex_unlock()) is also accomplished
> > > > via set_need_resched()/set_tsk_need_resched().
> > > > set_need_resched() is enough for RCU priority boosting issue here.
> > > 
> > > But there's a huge difference between the boosting and deboosting side
> > > of things. rcu_read_unlock_special() starts the boost, the deboosting
> > > only matters if/when you reschedule. 
> > 
> > Or if there is a pre-existing runnable task whose priority is such that
> > deboosting makes it the highest-priority task.
> 
> Right, I got horribly lost in rt_mutex, but I suspect we deal with that
> case the right way. -rt people would've noticed us screwing that up ;-)
> 
> But there too, we're fully limited to how fast we can get a
> reschedule(). Deboosting sooner than we can reschedule to run the other
> task is effectively pointless. The converse is obviously not true; we
> must not be able to reschedule sooner than we can deboost ;-)

In addition, the proposed change was to defer the deboost based on
a set_need_resched(), which would provide additional opportunity for
delay -- the running task would retain its high priority until the
scheduler acted on the set_need_resched().

							Thanx, Paul

