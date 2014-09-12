Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263AbaILDmn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 23:42:43 -0400
Received: from homie.mail.dreamhost.com ([208.97.132.208]:58924 "EHLO
	homiemail-a3.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754137AbaILDlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 23:41:50 -0400
From: Davidlohr Bueso <dave@stgolabs.net>
To: paulmck@linux.vnet.ibm.com
Cc: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        dave@stgolabs.net, Davidlohr Bueso <dbueso@suse.de>
Subject: [PATCH 4/9] locktorture: Teach about lock debugging
Date: Thu, 11 Sep 2014 20:40:19 -0700
Message-Id: <1410493224-3312-5-git-send-email-dave@stgolabs.net>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1410493224-3312-1-git-send-email-dave@stgolabs.net>
References: <1410493224-3312-1-git-send-email-dave@stgolabs.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Regular locks are very different than locks with debugging. For instance
for mutexes, debugging forces to only take the slowpaths. As such, the
locktorture module should take this into account when printing related
information -- specifically when printing user passed parameters, it seems
the right place for such info.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
---
 kernel/locking/locktorture.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/kernel/locking/locktorture.c b/kernel/locking/locktorture.c
index 414ba45..a6049fa 100644
--- a/kernel/locking/locktorture.c
+++ b/kernel/locking/locktorture.c
@@ -64,6 +64,7 @@ torture_param(int, stutter, 5, "Number of jiffies to run/halt test, 0=disable");
 torture_param(bool, verbose, true,
 	     "Enable verbose debugging printk()s");
 
+static bool debug_lock = false;
 static char *torture_type = "spin_lock";
 module_param(torture_type, charp, 0444);
 MODULE_PARM_DESC(torture_type,
@@ -349,8 +350,9 @@ lock_torture_print_module_parms(struct lock_torture_ops *cur_ops,
 				const char *tag)
 {
 	pr_alert("%s" TORTURE_FLAG
-		 "--- %s: nwriters_stress=%d stat_interval=%d verbose=%d shuffle_interval=%d stutter=%d shutdown_secs=%d onoff_interval=%d onoff_holdoff=%d\n",
-		 torture_type, tag, nrealwriters_stress, stat_interval, verbose,
+		 "--- %s%s: nwriters_stress=%d stat_interval=%d verbose=%d shuffle_interval=%d stutter=%d shutdown_secs=%d onoff_interval=%d onoff_holdoff=%d\n",
+		 torture_type, tag, debug_lock ? " [debug]": "",
+		 nrealwriters_stress, stat_interval, verbose,
 		 shuffle_interval, stutter, shutdown_secs,
 		 onoff_interval, onoff_holdoff);
 }
@@ -418,6 +420,15 @@ static int __init lock_torture_init(void)
 		nrealwriters_stress = nwriters_stress;
 	else
 		nrealwriters_stress = 2 * num_online_cpus();
+
+#ifdef CONFIG_DEBUG_MUTEXES
+	if (strncmp(torture_type, "mutex", 5) == 0)
+		debug_lock = true;
+#endif
+#ifdef CONFIG_DEBUG_SPINLOCK
+	if (strncmp(torture_type, "spin", 4) == 0)
+		debug_lock = true;
+#endif
 	lock_torture_print_module_parms(cur_ops, "Start of test");
 
 	/* Initialize the statistics so that each run gets its own numbers. */
-- 
1.8.4.5

