Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209AbaILDmI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 23:42:08 -0400
Received: from homie.mail.dreamhost.com ([208.97.132.208]:58924 "EHLO
	homiemail-a3.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754150AbaILDlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 23:41:50 -0400
From: Davidlohr Bueso <dave@stgolabs.net>
To: paulmck@linux.vnet.ibm.com
Cc: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        dave@stgolabs.net, Davidlohr Bueso <dbueso@suse.de>
Subject: [PATCH 6/9] torture: Address race in module cleanup
Date: Thu, 11 Sep 2014 20:40:21 -0700
Message-Id: <1410493224-3312-7-git-send-email-dave@stgolabs.net>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1410493224-3312-1-git-send-email-dave@stgolabs.net>
References: <1410493224-3312-1-git-send-email-dave@stgolabs.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When performing module cleanups by calling torture_cleanup() the
'torture_type' string in nullified However, callers are not necessarily
done, and might still need to reference the variable. This impacts
both rcutorture and locktorture, causing printing things like:

[   94.226618] (null)-torture: Stopping lock_torture_writer task
[   94.226624] (null)-torture: Stopping lock_torture_stats task

Thus delay this operation until the very end of the cleanup process.
The consequence (which shouldn't matter for this kid of program) is,
of course, that we delay the window between rmmod and modprobing,
for instance in module_torture_begin().

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
---
 include/linux/torture.h      |  3 ++-
 kernel/locking/locktorture.c |  3 ++-
 kernel/rcu/rcutorture.c      |  3 ++-
 kernel/torture.c             | 16 +++++++++++++---
 4 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/include/linux/torture.h b/include/linux/torture.h
index 5ca58fc..301b628 100644
--- a/include/linux/torture.h
+++ b/include/linux/torture.h
@@ -77,7 +77,8 @@ int torture_stutter_init(int s);
 /* Initialization and cleanup. */
 bool torture_init_begin(char *ttype, bool v, int *runnable);
 void torture_init_end(void);
-bool torture_cleanup(void);
+bool torture_cleanup_begin(void);
+void torture_cleanup_end(void);
 bool torture_must_stop(void);
 bool torture_must_stop_irq(void);
 void torture_kthread_stopping(char *title);
diff --git a/kernel/locking/locktorture.c b/kernel/locking/locktorture.c
index de703a7..988267c 100644
--- a/kernel/locking/locktorture.c
+++ b/kernel/locking/locktorture.c
@@ -361,7 +361,7 @@ static void lock_torture_cleanup(void)
 {
 	int i;
 
-	if (torture_cleanup())
+	if (torture_cleanup_begin())
 		return;
 
 	if (writer_tasks) {
@@ -384,6 +384,7 @@ static void lock_torture_cleanup(void)
 	else
 		lock_torture_print_module_parms(cur_ops,
 						"End of test: SUCCESS");
+	torture_cleanup_end();
 }
 
 static int __init lock_torture_init(void)
diff --git a/kernel/rcu/rcutorture.c b/kernel/rcu/rcutorture.c
index 948a769..57a2792 100644
--- a/kernel/rcu/rcutorture.c
+++ b/kernel/rcu/rcutorture.c
@@ -1418,7 +1418,7 @@ rcu_torture_cleanup(void)
 	int i;
 
 	rcutorture_record_test_transition();
-	if (torture_cleanup()) {
+	if (torture_cleanup_begin()) {
 		if (cur_ops->cb_barrier != NULL)
 			cur_ops->cb_barrier();
 		return;
@@ -1468,6 +1468,7 @@ rcu_torture_cleanup(void)
 					       "End of test: RCU_HOTPLUG");
 	else
 		rcu_torture_print_module_parms(cur_ops, "End of test: SUCCESS");
+	torture_cleanup_end();
 }
 
 #ifdef CONFIG_DEBUG_OBJECTS_RCU_HEAD
diff --git a/kernel/torture.c b/kernel/torture.c
index d600af2..07a5c3d 100644
--- a/kernel/torture.c
+++ b/kernel/torture.c
@@ -635,8 +635,13 @@ EXPORT_SYMBOL_GPL(torture_init_end);
  *
  * This must be called before the caller starts shutting down its own
  * kthreads.
+ *
+ * Both torture_cleanup_begin() and torture_cleanup_end() must be paired,
+ * in order to correctly perform the cleanup. They are separated because
+ * threads can still need to reference the torture_type type, thus nullify
+ * only after completing all other relevant calls.
  */
-bool torture_cleanup(void)
+bool torture_cleanup_begin(void)
 {
 	mutex_lock(&fullstop_mutex);
 	if (ACCESS_ONCE(fullstop) == FULLSTOP_SHUTDOWN) {
@@ -651,12 +656,17 @@ bool torture_cleanup(void)
 	torture_shuffle_cleanup();
 	torture_stutter_cleanup();
 	torture_onoff_cleanup();
+	return false;
+}
+EXPORT_SYMBOL_GPL(torture_cleanup_begin);
+
+void torture_cleanup_end(void)
+{
 	mutex_lock(&fullstop_mutex);
 	torture_type = NULL;
 	mutex_unlock(&fullstop_mutex);
-	return false;
 }
-EXPORT_SYMBOL_GPL(torture_cleanup);
+EXPORT_SYMBOL_GPL(torture_cleanup_end);
 
 /*
  * Is it time for the current torture test to stop?
-- 
1.8.4.5

