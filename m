Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827AbaHGTxa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 15:53:30 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:35070 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750895AbaHGTx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 15:53:29 -0400
Date: Thu, 7 Aug 2014 15:53:26 -0400
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
Message-ID: <20140807155326.18481e66@gandalf.local.home>
In-Reply-To: <20140807154907.6f59cf6e@gandalf.local.home>
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
	<20140807154907.6f59cf6e@gandalf.local.home>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Aug 2014 15:49:07 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:


> Only voluntary calls to schedule() will be a quiescent state. Preempt
> doesn't count. And no, function callbacks to not call schedule(),
> function callbacks should be treated even stricter than interrupt
> handlers. They should never call schedule() directly or even take any
> locks. Heck, they should be stricter than NMIs for that matter.
> 
> Hence, once something calls schedule() directly, we know that it is not
> on a trampoline, nor is it going to return to one.

I should also be a bit clearer here. It's not just function callbacks,
but anything that adds a trampoline that can be called from any context
(like for kprobes). The point is, these trampolines that can execute
anywhere (including in NMIs), must have strict use cases. These are not
a notifier or other generic operation that normal RCU is fine for.
These are for really specific cases that require the call_rcu_task() to
free.

call_rcu_task() should seldom be used. The only cases really are for
kprobes and function tracing, and perhaps other dynamic callers.

-- Steve
