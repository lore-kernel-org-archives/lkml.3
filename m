Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934082AbbA1EUl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:20:41 -0500
Received: from mail.kernel.org ([198.145.29.136]:39261 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934010AbbA1EUf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:20:35 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.cz>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 073/177] OOM, PM: OOM killed task shouldn't escape PM suspend
Date: Wed, 28 Jan 2015 12:08:32 +0800
Message-Id: <1422418236-12852-145-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Hocko <mhocko@suse.cz>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit 5695be142e203167e3cb515ef86a88424f3524eb upstream.

PM freezer relies on having all tasks frozen by the time devices are
getting frozen so that no task will touch them while they are getting
frozen. But OOM killer is allowed to kill an already frozen task in
order to handle OOM situtation. In order to protect from late wake ups
OOM killer is disabled after all tasks are frozen. This, however, still
keeps a window open when a killed task didn't manage to die by the time
freeze_processes finishes.

Reduce the race window by checking all tasks after OOM killer has been
disabled. This is still not race free completely unfortunately because
oom_killer_disable cannot stop an already ongoing OOM killer so a task
might still wake up from the fridge and get killed without
freeze_processes noticing. Full synchronization of OOM and freezer is,
however, too heavy weight for this highly unlikely case.

Introduce and check oom_kills counter which gets incremented early when
the allocator enters __alloc_pages_may_oom path and only check all the
tasks if the counter changes during the freezing attempt. The counter
is updated so early to reduce the race window since allocator checked
oom_killer_disabled which is set by PM-freezing code. A false positive
will push the PM-freezer into a slow path but that is not a big deal.

Changes since v1
- push the re-check loop out of freeze_processes into
  check_frozen_processes and invert the condition to make the code more
  readable as per Rafael

Fixes: f660daac474c6f (oom: thaw threads if oom killed thread is frozen before deferring)
Signed-off-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 include/linux/oom.h    |  4 ++++
 kernel/power/process.c | 40 +++++++++++++++++++++++++++++++++++++++-
 mm/oom_kill.c          | 17 +++++++++++++++++
 mm/page_alloc.c        |  8 ++++++++
 4 files changed, 68 insertions(+), 1 deletion(-)

diff --git a/include/linux/oom.h b/include/linux/oom.h
index 3d76475..d6ed7b0 100644
--- a/include/linux/oom.h
+++ b/include/linux/oom.h
@@ -45,6 +45,10 @@ extern int test_set_oom_score_adj(int new_val);
 
 extern unsigned int oom_badness(struct task_struct *p, struct mem_cgroup *memcg,
 			const nodemask_t *nodemask, unsigned long totalpages);
+
+extern int oom_kills_count(void);
+extern void note_oom_kill(void);
+
 extern int try_set_zonelist_oom(struct zonelist *zonelist, gfp_t gfp_flags);
 extern void clear_zonelist_oom(struct zonelist *zonelist, gfp_t gfp_flags);
 
diff --git a/kernel/power/process.c b/kernel/power/process.c
index f27d0c8..286ff57 100644
--- a/kernel/power/process.c
+++ b/kernel/power/process.c
@@ -114,6 +114,28 @@ static int try_to_freeze_tasks(bool user_only)
 	return todo ? -EBUSY : 0;
 }
 
+/*
+ * Returns true if all freezable tasks (except for current) are frozen already
+ */
+static bool check_frozen_processes(void)
+{
+	struct task_struct *g, *p;
+	bool ret = true;
+
+	read_lock(&tasklist_lock);
+	for_each_process_thread(g, p) {
+		if (p != current && !freezer_should_skip(p) &&
+		    !frozen(p)) {
+			ret = false;
+			goto done;
+		}
+	}
+done:
+	read_unlock(&tasklist_lock);
+
+	return ret;
+}
+
 /**
  * freeze_processes - Signal user space processes to enter the refrigerator.
  *
@@ -122,6 +144,7 @@ static int try_to_freeze_tasks(bool user_only)
 int freeze_processes(void)
 {
 	int error;
+	int oom_kills_saved;
 
 	error = __usermodehelper_disable(UMH_FREEZING);
 	if (error)
@@ -132,12 +155,27 @@ int freeze_processes(void)
 
 	printk("Freezing user space processes ... ");
 	pm_freezing = true;
+	oom_kills_saved = oom_kills_count();
 	error = try_to_freeze_tasks(true);
 	if (!error) {
-		printk("done.");
 		__usermodehelper_set_disable_depth(UMH_DISABLED);
 		oom_killer_disable();
+
+		/*
+		 * There might have been an OOM kill while we were
+		 * freezing tasks and the killed task might be still
+		 * on the way out so we have to double check for race.
+		 */
+		if (oom_kills_count() != oom_kills_saved &&
+				!check_frozen_processes()) {
+			__usermodehelper_set_disable_depth(UMH_ENABLED);
+			printk("OOM in progress.");
+			error = -EBUSY;
+			goto done;
+		}
+		printk("done.");
 	}
+done:
 	printk("\n");
 	BUG_ON(in_atomic());
 
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 597ecac..cb1f046 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -435,6 +435,23 @@ static void dump_header(struct task_struct *p, gfp_t gfp_mask, int order,
 		dump_tasks(memcg, nodemask);
 }
 
+/*
+ * Number of OOM killer invocations (including memcg OOM killer).
+ * Primarily used by PM freezer to check for potential races with
+ * OOM killed frozen task.
+ */
+static atomic_t oom_kills = ATOMIC_INIT(0);
+
+int oom_kills_count(void)
+{
+	return atomic_read(&oom_kills);
+}
+
+void note_oom_kill(void)
+{
+	atomic_inc(&oom_kills);
+}
+
 #define K(x) ((x) << (PAGE_SHIFT-10))
 static void oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
 			     unsigned int points, unsigned long totalpages,
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index ff0b099..2891a90 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1982,6 +1982,14 @@ __alloc_pages_may_oom(gfp_t gfp_mask, unsigned int order,
 	}
 
 	/*
+	 * PM-freezer should be notified that there might be an OOM killer on
+	 * its way to kill and wake somebody up. This is too early and we might
+	 * end up not killing anything but false positives are acceptable.
+	 * See freeze_processes.
+	 */
+	note_oom_kill();
+
+	/*
 	 * Go through the zonelist yet one more time, keep very high watermark
 	 * here, this is only to catch a parallel oom killing, we must fail if
 	 * we're still under heavy pressure.
-- 
1.9.1

