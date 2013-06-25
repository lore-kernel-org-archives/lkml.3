Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098Ab3FYViG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 17:38:06 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:47415 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694Ab3FYViB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 17:38:01 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC nohz_full 4/8] nohz_full: Add per-CPU idle-state tracking for NMIs
Date: Tue, 25 Jun 2013 14:37:47 -0700
Message-Id: <1372196271-20393-4-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1372196271-20393-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130625213721.GA19452@linux.vnet.ibm.com>
 <1372196271-20393-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062521-5518-0000-0000-00000FDE7A52
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

It turns out that we can reuse RCU's ->dynticks counter to identify
CPUs that are non-idle due to NMIs from idle, in combination with the
new full-system idle ->dynticks_idle counter.  The reason this works
can be seen from the following table:

                         ->dynticks    ->dynticks_idle           union

NMI from idle:             non-idle               idle        non-idle
NMI from user:             non-idle           non-idle        non-idle
NMI from non-idle kernel:  non-idle           non-idle        non-idle
idle:                          idle               idle            idle
user:                          idle           non-idle        non-idle
non-idle kernel:           non-idle           non-idle        non-idle

Note that the final "union" column gets us what we need:  A non-idle
indication in all cases except when the CPU really is in the idle loop.
(But what about interrupt handlers?  They are treated the same as
non-idle kernel.)

Therefore, if both ->dynticks and ->dynticks_idle say that the corresponding
CPU is idle (in other words, both have odd values), then the CPU really
is idle.

The only additional thing that this commit needs to supply is the time
that the last NMI either started or ended for the corresponding CPU.
This is used to determine whether or not this CPU has been idle long
enough to justify updating the global full-system idle state.

Final caveat:  This approach assumes that NMI handlers do not access
system time, an assumption that the existing dyntick-idle code also
makes.  To see this, suppose that the system has been idle for an
extended period of time, so that the clock values are obsolete, and
that an NMI arrives.  The NMI handler has no safe way to update the
clock values, and thus must do without.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/rcutree.c        | 7 +++++--
 kernel/rcutree.h        | 1 +
 kernel/rcutree_plugin.h | 9 +++++++++
 3 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index c814ce1..02b879a 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -607,6 +607,7 @@ void rcu_nmi_enter(void)
 	    (atomic_read(&rdtp->dynticks) & 0x1))
 		return;
 	rdtp->dynticks_nmi_nesting++;
+	rcu_sysidle_nmi_jiffies(rdtp);
 	smp_mb__before_atomic_inc();  /* Force delay from prior write. */
 	atomic_inc(&rdtp->dynticks);
 	/* CPUs seeing atomic_inc() must see later RCU read-side crit sects */
@@ -625,8 +626,10 @@ void rcu_nmi_exit(void)
 {
 	struct rcu_dynticks *rdtp = &__get_cpu_var(rcu_dynticks);
 
-	if (rdtp->dynticks_nmi_nesting == 0 ||
-	    --rdtp->dynticks_nmi_nesting != 0)
+	if (rdtp->dynticks_nmi_nesting == 0)
+		return;
+	rcu_sysidle_nmi_jiffies(rdtp);
+	if (--rdtp->dynticks_nmi_nesting != 0)
 		return;
 	/* CPUs seeing atomic_inc() must see prior RCU read-side crit sects */
 	smp_mb__before_atomic_inc();  /* See above. */
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index a56d1f1..11d7144 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -557,6 +557,7 @@ static void rcu_kick_nohz_cpu(int cpu);
 static bool init_nocb_callback_list(struct rcu_data *rdp);
 static void rcu_sysidle_enter(struct rcu_dynticks *rdtp, int irq);
 static void rcu_sysidle_exit(struct rcu_dynticks *rdtp, int irq);
+static void rcu_sysidle_nmi_jiffies(struct rcu_dynticks *rdtp);
 static void rcu_sysidle_init_percpu_data(struct rcu_dynticks *rdtp);
 
 #endif /* #ifndef RCU_TREE_NONCORE */
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index b704979..a00d5c9 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -2450,6 +2450,11 @@ static void rcu_sysidle_exit(struct rcu_dynticks *rdtp, int irq)
 	WARN_ON_ONCE(!(atomic_read(&rdtp->dynticks_idle) & 0x1));
 }
 
+static inline void rcu_sysidle_nmi_jiffies(struct rcu_dynticks *rdtp)
+{
+	rdtp->dynticks_nmi_jiffies = jiffies;
+}
+
 /*
  * Initialize dynticks sysidle state for CPUs coming online.
  */
@@ -2468,6 +2473,10 @@ static void rcu_sysidle_exit(struct rcu_dynticks *rdtp, int irq)
 {
 }
 
+static inline void rcu_sysidle_nmi_jiffies(struct rcu_dynticks *rdtp)
+{
+}
+
 static void rcu_sysidle_init_percpu_data(struct rcu_dynticks *rdtp)
 {
 }
-- 
1.8.1.5

