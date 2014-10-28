Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871AbaJ1WAS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 18:00:18 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:43315 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754614AbaJ1V5d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 17:57:33 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 10/10] cpu: Avoid puts_pending overflow
Date: Tue, 28 Oct 2014 14:53:37 -0700
Message-Id: <1414533217-24910-10-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1414533217-24910-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20141028215140.GA23970@linux.vnet.ibm.com>
 <1414533217-24910-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102821-0033-0000-0000-000000E3EBB7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

A long string of get_online_cpus() with each followed by a
put_online_cpu() that fails to acquire cpu_hotplug.lock can result in
overflow of the cpu_hotplug.puts_pending counter.  Although this is
perhaps improbably, a system with absolutely no CPU-hotplug operations
will have an arbitrarily long time in which this overflow could occur.
This commit therefore adds overflow checks to get_online_cpus() and
try_get_online_cpus().

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/cpu.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index 90a3d017b90c..5d220234b3ca 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -86,6 +86,16 @@ static struct {
 #define cpuhp_lock_acquire()      lock_map_acquire(&cpu_hotplug.dep_map)
 #define cpuhp_lock_release()      lock_map_release(&cpu_hotplug.dep_map)
 
+static void apply_puts_pending(int max)
+{
+	int delta;
+
+	if (atomic_read(&cpu_hotplug.puts_pending) >= max) {
+		delta = atomic_xchg(&cpu_hotplug.puts_pending, 0);
+		cpu_hotplug.refcount -= delta;
+	}
+}
+
 void get_online_cpus(void)
 {
 	might_sleep();
@@ -93,6 +103,7 @@ void get_online_cpus(void)
 		return;
 	cpuhp_lock_acquire_read();
 	mutex_lock(&cpu_hotplug.lock);
+	apply_puts_pending(65536);
 	cpu_hotplug.refcount++;
 	mutex_unlock(&cpu_hotplug.lock);
 }
@@ -105,6 +116,7 @@ bool try_get_online_cpus(void)
 	if (!mutex_trylock(&cpu_hotplug.lock))
 		return false;
 	cpuhp_lock_acquire_tryread();
+	apply_puts_pending(65536);
 	cpu_hotplug.refcount++;
 	mutex_unlock(&cpu_hotplug.lock);
 	return true;
@@ -161,12 +173,7 @@ void cpu_hotplug_begin(void)
 	cpuhp_lock_acquire();
 	for (;;) {
 		mutex_lock(&cpu_hotplug.lock);
-		if (atomic_read(&cpu_hotplug.puts_pending)) {
-			int delta;
-
-			delta = atomic_xchg(&cpu_hotplug.puts_pending, 0);
-			cpu_hotplug.refcount -= delta;
-		}
+		apply_puts_pending(1);
 		if (likely(!cpu_hotplug.refcount))
 			break;
 		__set_current_state(TASK_UNINTERRUPTIBLE);
-- 
1.8.1.5

