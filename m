Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322AbaHGTtU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 15:49:20 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:15145 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755100AbaHGTtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 15:49:17 -0400
Date: Thu, 7 Aug 2014 15:49:07 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        bobby.prani@gmail.com
Subject: Re: [PATCH v3 tip/core/rcu 3/9] rcu: Add synchronous grace-period
 waiting for RCU-tasks
Message-ID: <20140807154907.6f59cf6e@gandalf.local.home>
In-Reply-To: <20140807184635.GI3588@twins.programming.kicks-ass.net>
References: <20140805205711.7a52076c@gandalf.local.home>
	<20140806012139.GY8101@linux.vnet.ibm.com>
	<20140806084708.GR9918@twins.programming.kicks-ass.net>
	<20140806120958.GZ8101@linux.vnet.ibm.com>
	<20140806163035.GG19379@twins.programming.kicks-ass.net>
	<20140806224518.GA8101@linux.vnet.ibm.com>
	<20140807084544.GJ19379@twins.programming.kicks-ass.net>
	<20140807150031.GB5821@linux.vnet.ibm.com>
	<20140807152600.GW9918@twins.programming.kicks-ass.net>
	<20140807172753.GG3588@twins.programming.kicks-ass.net>
	<20140807184635.GI3588@twins.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Aug 2014 20:46:35 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> On Thu, Aug 07, 2014 at 07:27:53PM +0200, Peter Zijlstra wrote:
> > Right, Steve (and Paul) please explain _why_ this is an 'RCU' at all?
> > _Why_ do we have call_rcu_task(), and why is it entwined in the 'normal'
> > RCU stuff? We've got SRCU -- which btw started out simple, without
> > call_srcu() -- and that lives entirely independent. And SRCU is far more
> > an actual RCU than this thing is, its got read side primitives and
> > everything.
> > 
> > Also, I cannot think of any other use besides trampolines for this
> > thing, but that might be my limited imagination.
> 
> Also, trampolines can end up in the return frames, right? So how can you
> be sure when to wipe them? Passing through schedule() isn't enough for
> that.

Not sure what you mean.

> 
> Userspace is, but kernel threads typically don't ever end up there.

Only voluntary calls to schedule() will be a quiescent state. Preempt
doesn't count. And no, function callbacks to not call schedule(),
function callbacks should be treated even stricter than interrupt
handlers. They should never call schedule() directly or even take any
locks. Heck, they should be stricter than NMIs for that matter.

Hence, once something calls schedule() directly, we know that it is not
on a trampoline, nor is it going to return to one.

-- Steve
