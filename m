Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223AbaFGUgm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 16:36:42 -0400
Received: from www.linutronix.de ([62.245.132.108]:40730 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927AbaFGUgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 16:36:40 -0400
Date: Sat, 7 Jun 2014 22:36:30 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Sasha Levin <sasha.levin@oracle.com>
cc: "David S. Miller" <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: net: netlink executing RO memory
In-Reply-To: <53932AA2.4050204@oracle.com>
Message-ID: <alpine.DEB.2.10.1406072139410.3830@nanos>
References: <5390D152.30702@oracle.com> <53915571.7050801@oracle.com> <53932AA2.4050204@oracle.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 7 Jun 2014, Sasha Levin wrote:

> On 06/06/2014 01:45 AM, Sasha Levin wrote:
> > On 06/05/2014 04:21 PM, Sasha Levin wrote:
> >> Hi all,
> >>
> >> While fuzzing with trinity inside a KVM tools guest running the latest -next
> >> kernel I've stumbled on the following spew:
> >>
> >> [  306.065161] kernel tried to execute NX-protected page - exploit attempt? (uid: 0)
> >> [  306.067295] BUG: unable to handle kernel paging request at ffff880053b8fd08
> > 
> > Same issue reproduced multiple times with exactly the same trace, so I think that it
> > rules out random memory corruption.
> 
> I might have another lead of this: I caught debug objects complaining about freeing
> active objects:
> 
> [  592.020501] ODEBUG: free active (active state 1) object type: rcu_head hint:           (null)

So something in the memory which is freed is queued in rcu. state 1:
STATE_RCU_HEAD_QUEUED. But why is that rcu_head in the vmalloced skb
memory?

That's going to be a nice puzzle to find the culprit.

So one thing which might give us at least some data is the debug patch
below. With CONFIG_STACKTRACE enabled and 

# echo 1 >/sys/kernel/debug/tracing/options/stacktrace

we should get a recording of rcu_free() calls along with the
stacktrace for each. So we should be able to see which code path
actually queued the thing. Maybe that's enough of an hint, but at
least it gives us an idea which code path to instrument further.

Thanks,

	tglx
---------------------
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 962d1d5..7241235 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -698,6 +698,7 @@ EXPORT_SYMBOL_GPL(call_rcu);
 void kfree_call_rcu(struct rcu_head *head,
 		    void (*func)(struct rcu_head *rcu))
 {
+	trace_printk("head: %p func: %pS\n", head, func);
 	__call_rcu(head, func, &rcu_preempt_state, -1, 1);
 }
 EXPORT_SYMBOL_GPL(kfree_call_rcu);
@@ -1091,6 +1092,7 @@ static void rcu_preempt_check_callbacks(int cpu)
 void kfree_call_rcu(struct rcu_head *head,
 		    void (*func)(struct rcu_head *rcu))
 {
+	trace_printk("head: %p func: %pS\n", head, func);
 	__call_rcu(head, func, &rcu_sched_state, -1, 1);
 }
 EXPORT_SYMBOL_GPL(kfree_call_rcu);
diff --git a/lib/debugobjects.c b/lib/debugobjects.c
index e0731c3..7610834 100644
--- a/lib/debugobjects.c
+++ b/lib/debugobjects.c
@@ -252,8 +252,9 @@ static void debug_print_object(struct debug_obj *obj, char *msg)
 
 	if (limit < 5 && descr != descr_test) {
 		void *hint = descr->debug_hint ?
-			descr->debug_hint(obj->object) : NULL;
+			descr->debug_hint(obj->object) : obj->object;
 		limit++;
+		tracing_off();
 		WARN(1, KERN_ERR "ODEBUG: %s %s (active state %u) "
 				 "object type: %s hint: %pS\n",
 			msg, obj_states[obj->state], obj->astate,


