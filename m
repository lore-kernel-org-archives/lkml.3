Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758548Ab3IYBjs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 21:39:48 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:53918 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753596Ab3IYBf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 21:35:26 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 01/13] rcu: Make rcu_assign_pointer's assignment volatile and type-safe
Date: Tue, 24 Sep 2013 18:35:04 -0700
Message-Id: <1380072916-31557-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <20130925013451.GA31260@linux.vnet.ibm.com>
References: <20130925013451.GA31260@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092501-9332-0000-0000-0000018760A1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Josh Triplett <josh@joshtriplett.org>

rcu_assign_pointer needs to use ACCESS_ONCE to make the assignment to
the destination pointer volatile, to protect against compilers too
clever for their own good.

In addition, since rcu_assign_pointer force-casts the source pointer to
add the __rcu address space (overriding any existing address space), add
an explicit check that the source pointer has the __kernel address space
to start with.

This new check produces warnings like this, when attempting to assign
from a __user pointer:

test.c:25:9: warning: incorrect type in argument 2 (different address spaces)
test.c:25:9:    expected struct foo *<noident>
test.c:25:9:    got struct foo [noderef] <asn:1>*badsrc

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index f1f1bc3..5b444e0 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -506,8 +506,17 @@ static inline void rcu_preempt_sleep_check(void)
 #ifdef __CHECKER__
 #define rcu_dereference_sparse(p, space) \
 	((void)(((typeof(*p) space *)p) == p))
+/* The dummy first argument in __rcu_assign_pointer_typecheck makes the
+ * typechecked pointer the second argument, matching rcu_assign_pointer itself;
+ * this avoids confusion about argument numbers in warning messages. */
+#define __rcu_assign_pointer_check_kernel(v) \
+	do { \
+		extern void __rcu_assign_pointer_typecheck(int, typeof(*(v)) __kernel *); \
+		__rcu_assign_pointer_typecheck(0, v); \
+	} while (0)
 #else /* #ifdef __CHECKER__ */
 #define rcu_dereference_sparse(p, space)
+#define __rcu_assign_pointer_check_kernel(v) do { } while (0)
 #endif /* #else #ifdef __CHECKER__ */
 
 #define __rcu_access_pointer(p, space) \
@@ -551,7 +560,8 @@ static inline void rcu_preempt_sleep_check(void)
 #define __rcu_assign_pointer(p, v, space) \
 	do { \
 		smp_wmb(); \
-		(p) = (typeof(*v) __force space *)(v); \
+		__rcu_assign_pointer_check_kernel(v); \
+		ACCESS_ONCE(p) = (typeof(*(v)) __force space *)(v); \
 	} while (0)
 
 
-- 
1.8.1.5

