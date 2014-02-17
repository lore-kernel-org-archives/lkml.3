Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560AbaBQWW7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 17:22:59 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:51073 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753185AbaBQWNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 17:13:19 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 31/55] rcutorture: Apply ACCESS_ONCE() to racy fullstop accesses
Date: Mon, 17 Feb 2014 14:12:35 -0800
Message-Id: <1392675179-11560-31-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140217221231.GA8419@linux.vnet.ibm.com>
 <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021722-1344-0000-0000-000005D5BE1D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Because the fullstop variable can be accessed while it is being updated,
this commit avoids any resulting compiler mischief through use of
ACCESS_ONCE() for non-initialization accesses to this shared variable.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/torture.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/torture.c b/kernel/torture.c
index 317b49d8ff79..82a8735472f0 100644
--- a/kernel/torture.c
+++ b/kernel/torture.c
@@ -439,9 +439,9 @@ static int torture_shutdown_notify(struct notifier_block *unused1,
 				   unsigned long unused2, void *unused3)
 {
 	mutex_lock(&fullstop_mutex);
-	if (fullstop == FULLSTOP_DONTSTOP) {
+	if (ACCESS_ONCE(fullstop) == FULLSTOP_DONTSTOP) {
 		VERBOSE_TOROUT_STRING("Unscheduled system shutdown detected");
-		fullstop = FULLSTOP_SHUTDOWN;
+		ACCESS_ONCE(fullstop) = FULLSTOP_SHUTDOWN;
 	} else {
 		pr_warn("Concurrent rmmod and shutdown illegal!\n");
 	}
@@ -575,13 +575,13 @@ EXPORT_SYMBOL_GPL(torture_init_end);
 bool torture_cleanup(void)
 {
 	mutex_lock(&fullstop_mutex);
-	if (fullstop == FULLSTOP_SHUTDOWN) {
+	if (ACCESS_ONCE(fullstop) == FULLSTOP_SHUTDOWN) {
 		pr_warn("Concurrent rmmod and shutdown illegal!\n");
 		mutex_unlock(&fullstop_mutex);
 		schedule_timeout_uninterruptible(10);
 		return true;
 	}
-	fullstop = FULLSTOP_RMMOD;
+	ACCESS_ONCE(fullstop) = FULLSTOP_RMMOD;
 	mutex_unlock(&fullstop_mutex);
 	unregister_reboot_notifier(&torture_shutdown_nb);
 	torture_shuffle_cleanup();
@@ -605,6 +605,6 @@ EXPORT_SYMBOL_GPL(torture_must_stop);
  */
 bool torture_must_stop_irq(void)
 {
-	return fullstop != FULLSTOP_DONTSTOP;
+	return ACCESS_ONCE(fullstop) != FULLSTOP_DONTSTOP;
 }
 EXPORT_SYMBOL_GPL(torture_must_stop_irq);
-- 
1.8.1.5

