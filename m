Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539AbaLAQqw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 11:46:52 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:44972 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039AbaLAQqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 11:46:50 -0500
Date: Fri, 28 Nov 2014 07:42:10 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH 0/2] tiny_rcu: simplify tiny_rcu
Message-ID: <20141128154210.GX5050@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1417167813-11963-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417167813-11963-1-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120116-8236-0000-0000-0000075AFB09
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 28, 2014 at 05:43:31PM +0800, Lai Jiangshan wrote:
> Hi, Paul
> 
> These two patches use the special feture of the UP system:
> 	In UP, quiescent state == grace period.
> 
> For rcu_bh, rcu_process_callbacks() == a bh == QS == GP
> so we can pass rcu_bh-QS and advance GP(and callbacks) in
> rcu_process_callbacks(). After doing so, rcu_bh_qs() is useless
> since its work is handled by rcu_process_callbacks().
> 
> For rcu_sched, context-switch = QS = GP, thus we can force a
> context-switch when call_rcu_sched() is happened on idle_task.
> After doing so, rcu_idle/irq_enter/exit() are useless.
> 
> These patches remove the useless code to simplify the tiny_rcu.
> 
> We can change rcu_bh_qs() rcu_idle/irq_enter/exit() to static-inline-functions
> to reduce the binary size after these two patches accepted.
> 
> Thanks,
> Lai

These look interesting and promising!

Could you please add the change in the tiny.o size to the commit logs?

Also, one potential performance problem with this patchset is that it is
moving the RAISE_SOFTIRQ() from the scheduling-clock interrupt handler
(where it simply sets a bit in a per-CPU variable) to mainline code
(where it is often a much more expensive full wakeup of ksoftirqd).
My guess (and hope) is that this will be in the noise for most workloads,
but given that there is some chance of performance regressions, could
you please measure the performance difference on some reasonable
benchmark?  The kernbench benchmark should be just fine for this purpose.

							Thanx, Paul

> Cc: Josh Triplett <josh@joshtriplett.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> 
> Lai Jiangshan (2):
>   record rcu_bh quiescent state in RCU_SOFTIRQ
>   tiny_rcu: resched when call_rcu() on idle_task
> 
>  kernel/rcu/rcu.h         |    6 ++
>  kernel/rcu/tiny.c        |  134 ++++++++--------------------------------------
>  kernel/rcu/tiny_plugin.h |    2 +-
>  kernel/rcu/tree.c        |    6 --
>  4 files changed, 29 insertions(+), 119 deletions(-)
> 
> -- 
> 1.7.4.4
> 

