Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757792Ab3IYBuc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 21:50:32 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:46627 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755613Ab3IYBu0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 21:50:26 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 3/6] rcu: Throttle invoke_rcu_core() invocations due to non-lazy callbacks
Date: Tue, 24 Sep 2013 18:50:13 -0700
Message-Id: <1380073816-32381-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1380073816-32381-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130925014954.GA32109@linux.vnet.ibm.com>
 <1380073816-32381-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092501-0320-0000-0000-0000011DABF4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

If a non-lazy callback arrives on a CPU that has previously gone idle
with no non-lazy callbacks, invoke_rcu_core() forces the RCU core to
run.  However, it does not update the conditions, which could result
in several closely spaced invocations of the RCU core, which in turn
could result in an excessively high context-switch rate and resulting
high overhead.

This commit therefore updates the ->all_lazy and ->nonlazy_posted_snap
fields to prevent closely spaced invocations.

Reported-by: Tibor Billes <tbilles@gmx.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Tested-by: Tibor Billes <tbilles@gmx.com>
---
 kernel/rcutree_plugin.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index d81e385..2c15d7c 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -1745,6 +1745,8 @@ static void rcu_prepare_for_idle(int cpu)
 	 */
 	if (rdtp->all_lazy &&
 	    rdtp->nonlazy_posted != rdtp->nonlazy_posted_snap) {
+		rdtp->all_lazy = false;
+		rdtp->nonlazy_posted_snap = rdtp->nonlazy_posted;
 		invoke_rcu_core();
 		return;
 	}
-- 
1.8.1.5

