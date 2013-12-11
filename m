Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751634Ab3LKXI5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 18:08:57 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:41806 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377Ab3LKXI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 18:08:56 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH v2 tip/core/rcu 1/4] rcu: Add comment on evaluate-once properties of rcu_assign_pointer().
Date: Wed, 11 Dec 2013 15:08:45 -0800
Message-Id: <1386803328-13272-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <20131211230823.GA12448@linux.vnet.ibm.com>
References: <20131211230823.GA12448@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13121123-1542-0000-0000-00000424C837
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The rcu_assign_pointer() macro, as with most cpp macros, must not evaluate
its argument more than once.  And it in fact does not.  But this might
not be obvious to the casual observer, because one of the arguments
appears no less than three times.  However, but one expansion is only
visible to sparse (__CHECKER__), and one lives inside a typeof (where
it will never be evaluated), so this is in fact safe.

This commit therefore adds a comment making this explicit.

Reported-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 39cbb889e20d..00ad28168ef0 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -911,6 +911,14 @@ static inline notrace void rcu_read_unlock_sched_notrace(void)
  * rcu_assign_pointer() is a very bad thing that results in
  * impossible-to-diagnose memory corruption.  So please be careful.
  * See the RCU_INIT_POINTER() comment header for details.
+ *
+ * Note that rcu_assign_pointer() evaluates each of its arguments only
+ * once, appearances notwithstanding.  One of the "extra" evaluations
+ * is in typeof() and the other visible only to sparse (__CHECKER__),
+ * neither of which actually execute the argument.  As with most cpp
+ * macros, this execute-arguments-only-once property is important, so
+ * please be careful when making changes to rcu_assign_pointer() and the
+ * other macros that it invokes.
  */
 #define rcu_assign_pointer(p, v) \
 	__rcu_assign_pointer((p), (v), __rcu)
-- 
1.8.1.5

