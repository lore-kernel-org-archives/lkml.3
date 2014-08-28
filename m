Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940AbaH1Skq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 14:40:46 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:58379 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753686AbaH1Sih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:38:37 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 14/14] rcu: Avoid misordering in nocb_leader_wait()
Date: Thu, 28 Aug 2014 11:38:17 -0700
Message-Id: <1409251097-26734-14-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1409251097-26734-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140828183754.GA25488@linux.vnet.ibm.com>
 <1409251097-26734-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14082818-3532-0000-0000-000004372521
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The NOCB follower wakeup ordering depends on the store to the tail
pointer happening before the wakeup.  However, because atomic_long_add()
does not return a value, it does not provide ordering guarantees, and
the locking in wake_up() only guarantees that the store will happen
before the unlock, which might be too late.  Even though this is only a
theoretical issue, this commit adds a smp_mb__after_atomic() after the
final atomic_long_add() to provide the needed ordering guarantee.

Reported-by: Amit Shah <amit.shah@redhat.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/tree_plugin.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 700e5b37bf26..69eb650d551c 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2306,6 +2306,7 @@ wait_again:
 		atomic_long_add(rdp->nocb_gp_count, &rdp->nocb_follower_count);
 		atomic_long_add(rdp->nocb_gp_count_lazy,
 				&rdp->nocb_follower_count_lazy);
+		smp_mb__after_atomic(); /* Store *tail before wakeup. */
 		if (rdp != my_rdp && tail == &rdp->nocb_follower_head) {
 			/*
 			 * List was empty, wake up the follower.
-- 
1.8.1.5

