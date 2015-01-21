Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019AbbAUKIl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 05:08:41 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:48899 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456AbbAUKI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 05:08:28 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 1/7] rcu: Abstract default callback-list initialization from init_callback_list()
Date: Wed, 21 Jan 2015 02:08:14 -0800
Message-Id: <1421834900-23987-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <20150121100750.GA22883@linux.vnet.ibm.com>
References: <20150121100750.GA22883@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012110-0013-0000-0000-00000816BFB6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

In preparation for early-boot posting of callbacks, this commit abstracts
initialization of the default (non-no-CB) callbacks list from the
init_callback_list() function into a new init_default_callback_list()
function.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/tree.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 254ac97d64ef..9b5ed5333c9a 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -1328,20 +1328,30 @@ void rcu_cpu_stall_reset(void)
 }
 
 /*
- * Initialize the specified rcu_data structure's callback list to empty.
+ * Initialize the specified rcu_data structure's default callback list
+ * to empty.  The default callback list is the one that is not used by
+ * no-callbacks CPUs.
  */
-static void init_callback_list(struct rcu_data *rdp)
+static void init_default_callback_list(struct rcu_data *rdp)
 {
 	int i;
 
-	if (init_nocb_callback_list(rdp))
-		return;
 	rdp->nxtlist = NULL;
 	for (i = 0; i < RCU_NEXT_SIZE; i++)
 		rdp->nxttail[i] = &rdp->nxtlist;
 }
 
 /*
+ * Initialize the specified rcu_data structure's callback list to empty.
+ */
+static void init_callback_list(struct rcu_data *rdp)
+{
+	if (init_nocb_callback_list(rdp))
+		return;
+	init_default_callback_list(rdp);
+}
+
+/*
  * Determine the value that ->completed will have at the end of the
  * next subsequent grace period.  This is used to tag callbacks so that
  * a CPU can invoke callbacks in a timely fashion even if that CPU has
-- 
1.8.1.5

