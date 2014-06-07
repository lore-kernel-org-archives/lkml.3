Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266AbaFGUku (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 16:40:50 -0400
Received: from www.linutronix.de ([62.245.132.108]:40745 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753204AbaFGUks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 16:40:48 -0400
Date: Sat, 7 Jun 2014 22:40:43 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Sasha Levin <sasha.levin@oracle.com>
cc: "David S. Miller" <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: net: netlink executing RO memory
In-Reply-To: <alpine.DEB.2.10.1406072139410.3830@nanos>
Message-ID: <alpine.DEB.2.10.1406072239580.3830@nanos>
References: <5390D152.30702@oracle.com> <53915571.7050801@oracle.com> <53932AA2.4050204@oracle.com> <alpine.DEB.2.10.1406072139410.3830@nanos>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 7 Jun 2014, Thomas Gleixner wrote:
> On Sat, 7 Jun 2014, Sasha Levin wrote:
> So one thing which might give us at least some data is the debug patch
> below. With CONFIG_STACKTRACE enabled and 
> 
> # echo 1 >/sys/kernel/debug/tracing/options/stacktrace
> 
> we should get a recording of rcu_free() calls along with the
> stacktrace for each. So we should be able to see which code path
> actually queued the thing. Maybe that's enough of an hint, but at
> least it gives us an idea which code path to instrument further.

This one is better..

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
index e0731c3..fd5cafd 100644
--- a/lib/debugobjects.c
+++ b/lib/debugobjects.c
@@ -693,6 +693,9 @@ repeat:
 
 			switch (obj->state) {
 			case ODEBUG_STATE_ACTIVE:
+				trace_printk("free %p obj %p\n", address,
+					     obj->object);
+				tracing_off();
 				debug_print_object(obj, "free");
 				descr = obj->descr;
 				state = obj->state;
 
