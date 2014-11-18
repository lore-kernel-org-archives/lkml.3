Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933170AbaKROpq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:45:46 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57040 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754998AbaKROKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:10:03 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.cz>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 136/206] OOM, PM: OOM killed task shouldn't escape PM suspend
Date: Tue, 18 Nov 2014 15:08:11 +0100
Message-Id: <b76e04699452927c1881b5d364940a3381a692c8.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Hocko <mhocko@suse.cz>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 include/linux/oom.h    |  3 +++
 kernel/power/process.c | 40 +++++++++++++++++++++++++++++++++++++++-
 mm/oom_kill.c          | 17 +++++++++++++++++
 mm/page_alloc.c        |  8 ++++++++
 4 files changed, 67 insertions(+), 1 deletion(-)

diff --git a/include/linux/oom.h b/include/linux/oom.h
index da60007075b5..297cda528855 100644
--- a/include/linux/oom.h
+++ b/include/linux/oom.h
@@ -50,6 +50,9 @@ static inline bool oom_task_origin(const struct task_struct *p)
 extern unsigned long oom_badness(struct task_struct *p,
 		struct mem_cgroup *memcg, const nodemask_t *nodemask,
 		unsigned long totalpages);
+
+extern int oom_kills_count(void);
+extern void note_oom_kill(void);
 extern void oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
 			     unsigned int points, unsigned long totalpages,
 			     struct mem_cgroup *memcg, nodemask_t *nodemask,
diff --git a/kernel/power/process.c b/kernel/power/process.c
index 14f9a8d4725d..f1fe7ec110bb 100644
--- a/kernel/power/process.c
+++ b/kernel/power/process.c
@@ -107,6 +107,28 @@ static int try_to_freeze_tasks(bool user_only)
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
  * The current thread will not be frozen.  The same process that calls
@@ -117,6 +139,7 @@ static int try_to_freeze_tasks(bool user_only)
 int freeze_processes(void)
 {
 	int error;
+	int oom_kills_saved;
 
 	error = __usermodehelper_disable(UMH_FREEZING);
 	if (error)
@@ -130,12 +153,27 @@ int freeze_processes(void)
 
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
index a9b5b7ffc476..712a0f80451d 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -406,6 +406,23 @@ static void dump_header(struct task_struct *p, gfp_t gfp_mask, int order,
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
 /*
  * Must be called while holding a reference to p, which will be released upon
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 93c3651595d1..7abab3b7d140 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2250,6 +2250,14 @@ __alloc_pages_may_oom(gfp_t gfp_mask, unsigned int order,
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
2.1.3

