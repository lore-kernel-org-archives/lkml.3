Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959AbaBQVgN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 16:36:13 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:57905 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbaBQVgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 16:36:08 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 06/12] rcu: Define rcu_assign_pointer() in terms of smp_store_release()
Date: Mon, 17 Feb 2014 13:35:53 -0800
Message-Id: <1392672959-6386-6-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1392672959-6386-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140217213533.GA5387@linux.vnet.ibm.com>
 <1392672959-6386-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021721-7164-0000-0000-000006267592
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The new smp_store_release() function provides better guarantees than did
rcu_assign_pointer(), and potentially less overhead on some architectures.
The guarantee that smp_store_release() provides that rcu_assign_pointer()
does that is obscure, but its lack could cause considerable confusion.
This guarantee is illustrated by the following code fragment:

	struct foo {
		int a;
		int b;
		int c;
		struct foo *next;
	};
	struct foo foo1;
	struct foo foo2;
	struct foo __rcu *foop;

	...

	foo2.a = 1;
	foo2.b = 2;
	BUG_ON(foo2.c);
	rcu_assign_pointer(foop, &foo);

	...

	fp = rcu_dereference(foop);
	fp.c = 3;

The current rcu_assign_pointer() semantics permit the BUG_ON() to
trigger because rcu_assign_pointer()'s smp_wmb() is not guaranteed to
order prior reads against later writes.  This commit therefore upgrades
rcu_assign_pointer() from smp_wmb() to smp_store_release() to avoid this
counter-intuitive outcome.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 278a9da69ec4..32decf1a9c6c 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -44,6 +44,7 @@
 #include <linux/debugobjects.h>
 #include <linux/bug.h>
 #include <linux/compiler.h>
+#include <asm/barrier.h>
 
 #ifdef CONFIG_RCU_TORTURE_TEST
 extern int rcutorture_runnable; /* for sysctl */
@@ -580,12 +581,7 @@ static inline void rcu_preempt_sleep_check(void)
  * please be careful when making changes to rcu_assign_pointer() and the
  * other macros that it invokes.
  */
-#define rcu_assign_pointer(p, v) \
-	do { \
-		smp_wmb(); \
-		ACCESS_ONCE(p) = RCU_INITIALIZER(v); \
-	} while (0)
-
+#define rcu_assign_pointer(p, v) smp_store_release(&p, RCU_INITIALIZER(v))
 
 /**
  * rcu_access_pointer() - fetch RCU pointer with no dereferencing
-- 
1.8.1.5

