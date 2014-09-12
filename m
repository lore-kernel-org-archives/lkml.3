Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237AbaILDmK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 23:42:10 -0400
Received: from homie.mail.dreamhost.com ([208.97.132.208]:58924 "EHLO
	homiemail-a3.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754120AbaILDlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 23:41:50 -0400
From: Davidlohr Bueso <dave@stgolabs.net>
To: paulmck@linux.vnet.ibm.com
Cc: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        dave@stgolabs.net, Davidlohr Bueso <dbueso@suse.de>
Subject: [PATCH 5/9] locktorture: Make statistics generic
Date: Thu, 11 Sep 2014 20:40:20 -0700
Message-Id: <1410493224-3312-6-git-send-email-dave@stgolabs.net>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1410493224-3312-1-git-send-email-dave@stgolabs.net>
References: <1410493224-3312-1-git-send-email-dave@stgolabs.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The statistics structure can serve well for both reader and writer
locks, thus simply rename some fields that mention 'write' and leave
the declaration of lwsa.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
---
 kernel/locking/locktorture.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/kernel/locking/locktorture.c b/kernel/locking/locktorture.c
index a6049fa..de703a7 100644
--- a/kernel/locking/locktorture.c
+++ b/kernel/locking/locktorture.c
@@ -78,11 +78,11 @@ static struct task_struct **writer_tasks;
 static int nrealwriters_stress;
 static bool lock_is_write_held;
 
-struct lock_writer_stress_stats {
-	long n_write_lock_fail;
-	long n_write_lock_acquired;
+struct lock_stress_stats {
+	long n_lock_fail;
+	long n_lock_acquired;
 };
-static struct lock_writer_stress_stats *lwsa;
+static struct lock_stress_stats *lwsa; /* writer statistics */
 
 #if defined(MODULE)
 #define LOCKTORTURE_RUNNABLE_INIT 1
@@ -250,7 +250,7 @@ static struct lock_torture_ops mutex_lock_ops = {
  */
 static int lock_torture_writer(void *arg)
 {
-	struct lock_writer_stress_stats *lwsp = arg;
+	struct lock_stress_stats *lwsp = arg;
 	static DEFINE_TORTURE_RANDOM(rand);
 
 	VERBOSE_TOROUT_STRING("lock_torture_writer task started");
@@ -261,9 +261,9 @@ static int lock_torture_writer(void *arg)
 			schedule_timeout_uninterruptible(1);
 		cur_ops->writelock();
 		if (WARN_ON_ONCE(lock_is_write_held))
-			lwsp->n_write_lock_fail++;
+			lwsp->n_lock_fail++;
 		lock_is_write_held = 1;
-		lwsp->n_write_lock_acquired++;
+		lwsp->n_lock_acquired++;
 		cur_ops->write_delay(&rand);
 		lock_is_write_held = 0;
 		cur_ops->writeunlock();
@@ -281,17 +281,17 @@ static void lock_torture_printk(char *page)
 	bool fail = 0;
 	int i;
 	long max = 0;
-	long min = lwsa[0].n_write_lock_acquired;
+	long min = lwsa[0].n_lock_acquired;
 	long long sum = 0;
 
 	for (i = 0; i < nrealwriters_stress; i++) {
-		if (lwsa[i].n_write_lock_fail)
+		if (lwsa[i].n_lock_fail)
 			fail = true;
-		sum += lwsa[i].n_write_lock_acquired;
-		if (max < lwsa[i].n_write_lock_fail)
-			max = lwsa[i].n_write_lock_fail;
-		if (min > lwsa[i].n_write_lock_fail)
-			min = lwsa[i].n_write_lock_fail;
+		sum += lwsa[i].n_lock_acquired;
+		if (max < lwsa[i].n_lock_fail)
+			max = lwsa[i].n_lock_fail;
+		if (min > lwsa[i].n_lock_fail)
+			min = lwsa[i].n_lock_fail;
 	}
 	page += sprintf(page, "%s%s ", torture_type, TORTURE_FLAG);
 	page += sprintf(page,
@@ -441,8 +441,8 @@ static int __init lock_torture_init(void)
 		goto unwind;
 	}
 	for (i = 0; i < nrealwriters_stress; i++) {
-		lwsa[i].n_write_lock_fail = 0;
-		lwsa[i].n_write_lock_acquired = 0;
+		lwsa[i].n_lock_fail = 0;
+		lwsa[i].n_lock_acquired = 0;
 	}
 
 	/* Start up the kthreads. */
-- 
1.8.4.5

