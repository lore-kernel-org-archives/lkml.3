Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759519Ab3EWPwR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 11:52:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43646 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758360Ab3EWPwP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 11:52:15 -0400
Date: Thu, 23 May 2013 11:51:52 -0400
From: Dave Jones <davej@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, fweisbec@gmail.com
Subject: Re: WARNING: at kernel/rcutree.c:388 rcu_eqs_enter
Message-ID: <20130523155152.GD16419@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, fweisbec@gmail.com
References: <20130521173100.GA2076@redhat.com>
 <20130521235813.GA18737@redhat.com>
 <20130522095129.GA3578@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130522095129.GA3578@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 02:51:29AM -0700, Paul E. McKenney wrote:

 > trace: Allow idle-safe tracepoints to be called from irq
 > 
 > __DECLARE_TRACE_RCU() currently creates an _rcuidle() tracepoint which
 > may safely be invoked from what RCU considers to be an idle CPU.
 > However, these _rcuidle() tracepoints may -not- be invoked from the
 > handler of an irq taken from idle, because rcu_idle_enter() zeroes
 > RCU's nesting-level counter, so that the rcu_irq_exit() returning to
 > idle will trigger a WARN_ON_ONCE().
 > 
 > This commit therefore substitutes rcu_irq_enter() for rcu_idle_exit()
 > and rcu_irq_exit() for rcu_idle_enter() in order to make the _rcuidle()
 > tracepoints usable from irq handlers as well as from process context.
 > 
 > Reported-by: Dave Jones <davej@redhat.com>
 > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
 > Cc: Steven Rostedt <rostedt@goodmis.org>
 > 
 > diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
 > index 2f322c3..f8e084d 100644
 > --- a/include/linux/tracepoint.h
 > +++ b/include/linux/tracepoint.h
 > @@ -145,8 +145,8 @@ static inline void tracepoint_synchronize_unregister(void)
 >  				TP_PROTO(data_proto),			\
 >  				TP_ARGS(data_args),			\
 >  				TP_CONDITION(cond),			\
 > -				rcu_idle_exit(),			\
 > -				rcu_idle_enter());			\
 > +				rcu_irq_enter(),			\
 > +				rcu_irq_exit());			\
 >  	}
 >  #else
 >  #define __DECLARE_TRACE_RCU(name, proto, args, cond, data_proto, data_args)

This stops the "WARNING: at kernel/context_tracking.c:55 user_enter+0xb5/0xd0()"
but I still see..


[  363.399348] ===============================
[  363.400617] [ INFO: suspicious RCU usage. ]
[  363.401880] 3.10.0-rc2+ #31 Not tainted
[  363.403210] -------------------------------
[  363.403787] include/linux/rcupdate.h:771 rcu_read_lock() used illegally while idle!
[  363.403831] 
other info that might help us debug this:

[  363.403880] 
RCU used illegally from idle CPU!
rcu_scheduler_active = 1, debug_locks = 0
[  363.403942] RCU used illegally from extended quiescent state!
[  363.403976] 2 locks held by trinity-child0/27319:
[  363.404006]  #0:  (&rq->lock){-.-.-.}, at: [<ffffffff816e91bf>] __schedule+0xef/0x9c0
[  363.404076]  #1:  (rcu_read_lock){.+.+..}, at: [<ffffffff810a5605>] cpuacct_charge+0x5/0x1f0
[  363.404146] 
stack backtrace:
[  363.404176] CPU: 1 PID: 27319 Comm: trinity-child0 Not tainted 3.10.0-rc2+ #31 
[  363.405536]  0000000000000000 ffff880208ddfcf8 ffffffff816e2a5b ffff880208ddfd28
[  363.406835]  ffffffff810b5917 ffff880243362568 00000000003c3c18 ffff880243362520
[  363.408140]  0000000000000001 ffff880208ddfd60 ffffffff810a5785 ffffffff810a5605
[  363.409451] Call Trace:
[  363.410726]  [<ffffffff816e2a5b>] dump_stack+0x19/0x1b
[  363.412005]  [<ffffffff810b5917>] lockdep_rcu_suspicious+0xe7/0x120
[  363.413281]  [<ffffffff810a5785>] cpuacct_charge+0x185/0x1f0
[  363.414543]  [<ffffffff810a5605>] ? cpuacct_charge+0x5/0x1f0
[  363.415793]  [<ffffffff8109607c>] update_curr+0xec/0x250
[  363.417035]  [<ffffffff810975a8>] put_prev_task_fair+0x228/0x480
[  363.418273]  [<ffffffff816e9236>] __schedule+0x166/0x9c0
[  363.419497]  [<ffffffff816e9ee4>] preempt_schedule+0x44/0x60
[  363.420717]  [<ffffffff816e9fb0>] ? __cond_resched_softirq+0x60/0x60
[  363.421940]  [<ffffffff816ebfa4>] ? retint_careful+0x12/0x2e
[  363.423155]  [<ffffffff8110e2b3>] ftrace_ops_control_func+0x1d3/0x210
[  363.424373]  [<ffffffff816f3a40>] ftrace_call+0x5/0x2f
[  363.425577]  [<ffffffff816ebf9d>] ? retint_careful+0xb/0x2e
[  363.426784]  [<ffffffff816e9fb5>] ? schedule_user+0x5/0x70
[  363.427988]  [<ffffffff816e9fb5>] ? schedule_user+0x5/0x70
[  363.429184]  [<ffffffff816ebfa4>] ? retint_careful+0x12/0x2e

I'll try Steve's patch on top next.

	Dave

