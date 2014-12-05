Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751921AbaLEQnY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 11:43:24 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48658 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751450AbaLEQlz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 11:41:55 -0500
From: Michal Hocko <mhocko@suse.cz>
To: <linux-mm@kvack.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        "\\\"Rafael J. Wysocki\\\"" <rjw@rjwysocki.net>,
        David Rientjes <rientjes@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Oleg Nesterov <oleg@redhat.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH -v2 3/5] PM: convert printk to pr_* equivalent
Date: Fri,  5 Dec 2014 17:41:45 +0100
Message-Id: <1417797707-31699-4-git-send-email-mhocko@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417797707-31699-1-git-send-email-mhocko@suse.cz>
References: <20141110163055.GC18373@dhcp22.suse.cz>
 <1417797707-31699-1-git-send-email-mhocko@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While touching this area let's convert printk to pr_*. This also makes
the printing of continuation lines done properly.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 kernel/power/process.c | 29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/kernel/power/process.c b/kernel/power/process.c
index 5a6ec8678b9a..3ac45f192e9f 100644
--- a/kernel/power/process.c
+++ b/kernel/power/process.c
@@ -84,8 +84,8 @@ static int try_to_freeze_tasks(bool user_only)
 	elapsed_msecs = elapsed_msecs64;
 
 	if (todo) {
-		printk("\n");
-		printk(KERN_ERR "Freezing of tasks %s after %d.%03d seconds "
+		pr_cont("\n");
+		pr_err("Freezing of tasks %s after %d.%03d seconds "
 		       "(%d tasks refusing to freeze, wq_busy=%d):\n",
 		       wakeup ? "aborted" : "failed",
 		       elapsed_msecs / 1000, elapsed_msecs % 1000,
@@ -101,7 +101,7 @@ static int try_to_freeze_tasks(bool user_only)
 			read_unlock(&tasklist_lock);
 		}
 	} else {
-		printk("(elapsed %d.%03d seconds) ", elapsed_msecs / 1000,
+		pr_cont("(elapsed %d.%03d seconds) ", elapsed_msecs / 1000,
 			elapsed_msecs % 1000);
 	}
 
@@ -155,7 +155,7 @@ int freeze_processes(void)
 		atomic_inc(&system_freezing_cnt);
 
 	pm_wakeup_clear();
-	printk("Freezing user space processes ... ");
+	pr_info("Freezing user space processes ... ");
 	pm_freezing = true;
 	oom_kills_saved = oom_kills_count();
 	error = try_to_freeze_tasks(true);
@@ -171,13 +171,13 @@ int freeze_processes(void)
 		if (oom_kills_count() != oom_kills_saved &&
 		    !check_frozen_processes()) {
 			__usermodehelper_set_disable_depth(UMH_ENABLED);
-			printk("OOM in progress.");
+			pr_cont("OOM in progress.");
 			error = -EBUSY;
 		} else {
-			printk("done.");
+			pr_cont("done.");
 		}
 	}
-	printk("\n");
+	pr_cont("\n");
 	BUG_ON(in_atomic());
 
 	if (error)
@@ -197,13 +197,14 @@ int freeze_kernel_threads(void)
 {
 	int error;
 
-	printk("Freezing remaining freezable tasks ... ");
+	pr_info("Freezing remaining freezable tasks ... ");
+
 	pm_nosig_freezing = true;
 	error = try_to_freeze_tasks(false);
 	if (!error)
-		printk("done.");
+		pr_cont("done.");
 
-	printk("\n");
+	pr_cont("\n");
 	BUG_ON(in_atomic());
 
 	if (error)
@@ -224,7 +225,7 @@ void thaw_processes(void)
 
 	oom_killer_enable();
 
-	printk("Restarting tasks ... ");
+	pr_info("Restarting tasks ... ");
 
 	__usermodehelper_set_disable_depth(UMH_FREEZING);
 	thaw_workqueues();
@@ -243,7 +244,7 @@ void thaw_processes(void)
 	usermodehelper_enable();
 
 	schedule();
-	printk("done.\n");
+	pr_cont("done.\n");
 	trace_suspend_resume(TPS("thaw_processes"), 0, false);
 }
 
@@ -252,7 +253,7 @@ void thaw_kernel_threads(void)
 	struct task_struct *g, *p;
 
 	pm_nosig_freezing = false;
-	printk("Restarting kernel threads ... ");
+	pr_info("Restarting kernel threads ... ");
 
 	thaw_workqueues();
 
@@ -264,5 +265,5 @@ void thaw_kernel_threads(void)
 	read_unlock(&tasklist_lock);
 
 	schedule();
-	printk("done.\n");
+	pr_cont("done.\n");
 }
-- 
2.1.3

