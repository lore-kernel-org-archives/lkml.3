Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659AbaBQWOq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 17:14:46 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:35262 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754032AbaBQWNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 17:13:22 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 54/55] rcutorture: Add a lock_busted to test the test
Date: Mon, 17 Feb 2014 14:12:58 -0800
Message-Id: <1392675179-11560-54-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140217221231.GA8419@linux.vnet.ibm.com>
 <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021722-8236-0000-0000-0000074F385E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

This commit adds a maximally broken locking primitive in which
lock acquisition and release are both no-ops.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/locking/locktorture.c | 33 ++++++++++++++++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

diff --git a/kernel/locking/locktorture.c b/kernel/locking/locktorture.c
index a18c5a44ea39..b0993d7dcdb0 100644
--- a/kernel/locking/locktorture.c
+++ b/kernel/locking/locktorture.c
@@ -112,6 +112,37 @@ static struct lock_torture_ops *cur_ops;
  * Definitions for lock torture testing.
  */
 
+static int torture_lock_busted_write_lock(void)
+{
+	return 0;  /* BUGGY, do not use in real life!!! */
+}
+
+static void torture_lock_busted_write_delay(struct torture_random_state *trsp)
+{
+	const unsigned long longdelay_us = 100;
+
+	/* We want a long delay occasionally to force massive contention.  */
+	if (!(torture_random(trsp) %
+	      (nrealwriters_stress * 2000 * longdelay_us)))
+		mdelay(longdelay_us);
+#ifdef CONFIG_PREEMPT
+	if (!(torture_random(trsp) % (nrealwriters_stress * 20000)))
+		preempt_schedule();  /* Allow test to be preempted. */
+#endif
+}
+
+static void torture_lock_busted_write_unlock(void)
+{
+	  /* BUGGY, do not use in real life!!! */
+}
+
+static struct lock_torture_ops lock_busted_ops = {
+	.writelock	= torture_lock_busted_write_lock,
+	.write_delay	= torture_lock_busted_write_delay,
+	.writeunlock	= torture_lock_busted_write_unlock,
+	.name		= "lock_busted"
+};
+
 static DEFINE_SPINLOCK(torture_spinlock);
 
 static int torture_spin_lock_write_lock(void) __acquires(torture_spinlock)
@@ -320,7 +351,7 @@ static int __init lock_torture_init(void)
 	int i;
 	int firsterr = 0;
 	static struct lock_torture_ops *torture_ops[] = {
-		&spin_lock_ops, &spin_lock_irq_ops,
+		&lock_busted_ops, &spin_lock_ops, &spin_lock_irq_ops,
 	};
 
 	torture_init_begin(torture_type, verbose, &locktorture_runnable);
-- 
1.8.1.5

