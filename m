Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756013AbaJ1WOD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 18:14:03 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:58385 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755867AbaJ1WN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 18:13:57 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 9/9] rcu: Provide counterpart to rcu_dereference() for non-RCU situations
Date: Tue, 28 Oct 2014 15:10:02 -0700
Message-Id: <1414534202-27312-9-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1414534202-27312-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20141028220944.GA26114@linux.vnet.ibm.com>
 <1414534202-27312-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102822-0025-0000-0000-000000F05F67
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Although rcu_dereference() and friends can be used in situations where
object lifetimes are being managed by something other than RCU, the
resulting sparse and lockdep-RCU noise can be annoying.  This commit
therefore supplies a lockless_dereference(), which provides the
protection for dereferences without the RCU-related debugging noise.

Reported-by: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index ae6942a84a0d..423fd0478f8a 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -617,6 +617,21 @@ static inline void rcu_preempt_sleep_check(void)
 #define RCU_INITIALIZER(v) (typeof(*(v)) __force __rcu *)(v)
 
 /**
+ * lockless_dereference() - safely load a pointer for later dereference
+ * @p: The pointer to load
+ *
+ * Similar to rcu_dereference(), but for situations where the pointed-to
+ * object's lifetime is managed by something other than RCU.  That
+ * "something other" might be reference counting or simple immortality.
+ */
+#define lockless_dereference(p) \
+({ \
+	typeof(p) _________p1 = ACCESS_ONCE(p); \
+	smp_read_barrier_depends(); /* Dependency order vs. p above. */ \
+	(_________p1); \
+})
+
+/**
  * rcu_assign_pointer() - assign to RCU-protected pointer
  * @p: pointer to assign to
  * @v: value to assign (publish)
-- 
1.8.1.5

