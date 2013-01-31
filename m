Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629Ab3AaVcO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 16:32:14 -0500
Received: from sema.semaphore.gr ([78.46.194.137]:35141 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751582Ab3AaVcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 16:32:12 -0500
Message-ID: <510AE2D6.6010101@semaphore.gr>
Date: Thu, 31 Jan 2013 23:32:06 +0200
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        David Rientjes <rientjes@google.com>
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] drivers: android: Restructure code in lowmemorykiller
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch restructures code for better readability and easier
maintenance.

Also introduces lowmemorykiller.h header file.

Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
---
 drivers/staging/android/lowmemorykiller.c | 162 ++++++++++++++++++------------
 drivers/staging/android/lowmemorykiller.h |  42 ++++++++
 2 files changed, 139 insertions(+), 65 deletions(-)
 create mode 100644 drivers/staging/android/lowmemorykiller.h

diff --git a/drivers/staging/android/lowmemorykiller.c b/drivers/staging/android/lowmemorykiller.c
index 3b91b0f..ade8584 100644
--- a/drivers/staging/android/lowmemorykiller.c
+++ b/drivers/staging/android/lowmemorykiller.c
@@ -38,50 +38,44 @@
 #include <linux/rcupdate.h>
 #include <linux/profile.h>
 #include <linux/notifier.h>
+#include "lowmemorykiller.h"
 
-static uint32_t lowmem_debug_level = 2;
-static short lowmem_adj[6] = {
+static short lowmem_adj[LOWMEM_ARRAY_SIZE] = {
 	0,
 	1,
 	6,
 	12,
 };
-static int lowmem_adj_size = 4;
-static int lowmem_minfree[6] = {
+static int lowmem_minfree[LOWMEM_ARRAY_SIZE] = {
 	3 * 512,	/* 6MB */
 	2 * 1024,	/* 8MB */
 	4 * 1024,	/* 16MB */
 	16 * 1024,	/* 64MB */
 };
-static int lowmem_minfree_size = 4;
 
-static unsigned long lowmem_deathpending_timeout;
+static int lowmem_adj_size	= DEF_LOWMEM_SIZE;
+static int lowmem_minfree_size	= DEF_LOWMEM_SIZE;
+static uint32_t lowmem_debug_level = DEF_DEBUG_LEVEL;
 
-#define lowmem_print(level, x...)			\
-	do {						\
-		if (lowmem_debug_level >= (level))	\
-			printk(x);			\
-	} while (0)
+static unsigned long lowmem_deathpending_timeout;
+static short min_score_adj;
+static struct selected_struct selected;
 
-static int lowmem_shrink(struct shrinker *s, struct shrink_control *sc)
+static void set_min_score_adj(struct shrink_control *sc)
 {
-	struct task_struct *tsk;
-	struct task_struct *selected = NULL;
-	int rem = 0;
-	int tasksize;
 	int i;
-	short min_score_adj = OOM_SCORE_ADJ_MAX + 1;
-	int selected_tasksize = 0;
-	short selected_oom_score_adj;
 	int array_size = ARRAY_SIZE(lowmem_adj);
 	int other_free = global_page_state(NR_FREE_PAGES);
 	int other_file = global_page_state(NR_FILE_PAGES) -
 						global_page_state(NR_SHMEM);
 
+	min_score_adj = OOM_SCORE_ADJ_MAX + 1;
+
 	if (lowmem_adj_size < array_size)
 		array_size = lowmem_adj_size;
 	if (lowmem_minfree_size < array_size)
 		array_size = lowmem_minfree_size;
+
 	for (i = 0; i < array_size; i++) {
 		if (other_free < lowmem_minfree[i] &&
 		    other_file < lowmem_minfree[i]) {
@@ -89,10 +83,82 @@ static int lowmem_shrink(struct shrinker *s, struct shrink_control *sc)
 			break;
 		}
 	}
+
 	if (sc->nr_to_scan > 0)
 		lowmem_print(3, "lowmem_shrink %lu, %x, ofree %d %d, ma %hd\n",
 				sc->nr_to_scan, sc->gfp_mask, other_free,
 				other_file, min_score_adj);
+	return;
+}
+
+static enum lowmem_scan_t scan_process(struct task_struct *tsk)
+{
+	struct task_struct *p;
+	short oom_score_adj;
+	int tasksize;
+
+	if (tsk->flags & PF_KTHREAD)
+		return LMK_SCAN_CONTINUE;
+
+	p = find_lock_task_mm(tsk);
+	if (!p)
+		return LMK_SCAN_CONTINUE;
+
+	if (test_tsk_thread_flag(p, TIF_MEMDIE) &&
+	    time_before_eq(jiffies, lowmem_deathpending_timeout)) {
+		task_unlock(p);
+		rcu_read_unlock();
+		return LMK_SCAN_ABORT;
+	}
+
+	oom_score_adj = p->signal->oom_score_adj;
+	if (oom_score_adj < min_score_adj) {
+		task_unlock(p);
+		return LMK_SCAN_CONTINUE;
+	}
+
+	tasksize = get_mm_rss(p->mm);
+	task_unlock(p);
+	if (tasksize <= 0)
+		return LMK_SCAN_CONTINUE;
+
+	if (selected.task) {
+		if (oom_score_adj < selected.oom_score_adj)
+			return LMK_SCAN_CONTINUE;
+
+		if (oom_score_adj == selected.oom_score_adj &&
+		    tasksize <= selected.tasksize)
+			return LMK_SCAN_CONTINUE;
+	}
+
+	selected.task = p;
+	selected.tasksize = tasksize;
+	selected.oom_score_adj = oom_score_adj;
+	lowmem_print(2, "select %d (%s), adj %hd, size %d, to kill\n",
+		      p->pid, p->comm, oom_score_adj, tasksize);
+
+	return LMK_SCAN_OK;
+}
+
+static inline void kill_selected(void)
+{
+	lowmem_print(1, "send sigkill to %d (%s), adj %hd, size %d\n",
+		      selected.task->pid, selected.task->comm,
+		      selected.oom_score_adj, selected.tasksize);
+
+	lowmem_deathpending_timeout = jiffies + HZ;
+
+	send_sig(SIGKILL, selected.task, 0);
+	set_tsk_thread_flag(selected.task, TIF_MEMDIE);
+}
+
+static int lowmem_shrink(struct shrinker *s, struct shrink_control *sc)
+{
+	struct task_struct *tsk;
+	int rem = 0;
+
+	set_min_score_adj(sc);
+
 	rem = global_page_state(NR_ACTIVE_ANON) +
 		global_page_state(NR_ACTIVE_FILE) +
 		global_page_state(NR_INACTIVE_ANON) +
@@ -102,60 +168,27 @@ static int lowmem_shrink(struct shrinker *s, struct shrink_control *sc)
 			     sc->nr_to_scan, sc->gfp_mask, rem);
 		return rem;
 	}
-	selected_oom_score_adj = min_score_adj;
 
-	rcu_read_lock();
-	for_each_process(tsk) {
-		struct task_struct *p;
-		short oom_score_adj;
+	selected.task = NULL;
+	selected.tasksize = 0;
+	selected.oom_score_adj = min_score_adj;
 
-		if (tsk->flags & PF_KTHREAD)
-			continue;
-
-		p = find_lock_task_mm(tsk);
-		if (!p)
-			continue;
+	rcu_read_lock();
 
-		if (test_tsk_thread_flag(p, TIF_MEMDIE) &&
-		    time_before_eq(jiffies, lowmem_deathpending_timeout)) {
-			task_unlock(p);
-			rcu_read_unlock();
+	for_each_process(tsk) {
+		if (scan_process(tsk) == LMK_SCAN_ABORT)
 			return 0;
-		}
-		oom_score_adj = p->signal->oom_score_adj;
-		if (oom_score_adj < min_score_adj) {
-			task_unlock(p);
-			continue;
-		}
-		tasksize = get_mm_rss(p->mm);
-		task_unlock(p);
-		if (tasksize <= 0)
-			continue;
-		if (selected) {
-			if (oom_score_adj < selected_oom_score_adj)
-				continue;
-			if (oom_score_adj == selected_oom_score_adj &&
-			    tasksize <= selected_tasksize)
-				continue;
-		}
-		selected = p;
-		selected_tasksize = tasksize;
-		selected_oom_score_adj = oom_score_adj;
-		lowmem_print(2, "select %d (%s), adj %hd, size %d, to kill\n",
-			     p->pid, p->comm, oom_score_adj, tasksize);
 	}
-	if (selected) {
-		lowmem_print(1, "send sigkill to %d (%s), adj %hd, size %d\n",
-			     selected->pid, selected->comm,
-			     selected_oom_score_adj, selected_tasksize);
-		lowmem_deathpending_timeout = jiffies + HZ;
-		send_sig(SIGKILL, selected, 0);
-		set_tsk_thread_flag(selected, TIF_MEMDIE);
-		rem -= selected_tasksize;
+
+	if (selected.task) {
+		kill_selected();
+		rem -= selected.tasksize;
 	}
+
 	lowmem_print(4, "lowmem_shrink %lu, %x, return %d\n",
 		     sc->nr_to_scan, sc->gfp_mask, rem);
 	rcu_read_unlock();
+
 	return rem;
 }
 
@@ -186,4 +219,3 @@ module_init(lowmem_init);
 module_exit(lowmem_exit);
 
 MODULE_LICENSE("GPL");
-
diff --git a/drivers/staging/android/lowmemorykiller.h b/drivers/staging/android/lowmemorykiller.h
new file mode 100644
index 0000000..923ccf7
--- /dev/null
+++ b/drivers/staging/android/lowmemorykiller.h
@@ -0,0 +1,42 @@
+/* include/linux/lowmemorykiller.h
+ *
+ * Copyright (C) 2008 Google, Inc.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef _LINUX_LOWMEMORYKILLER_H
+#define _LINUX_LOWMEMORYKILLER_H
+
+#define DEF_DEBUG_LEVEL		(2)
+#define DEF_LOWMEM_SIZE		(4)
+#define LOWMEM_ARRAY_SIZE	(6)
+
+#define lowmem_print(level, x...)			\
+	do {						\
+		if (lowmem_debug_level >= (level))	\
+			printk(x);			\
+	} while (0)
+
+enum lowmem_scan_t {
+	LMK_SCAN_OK,
+	LMK_SCAN_CONTINUE,
+	LMK_SCAN_ABORT,
+};
+
+/* Selected task struct */
+struct selected_struct {
+	struct	task_struct *task;
+	int	tasksize;
+	short	oom_score_adj;
+};
+
+#endif /* _LINUX_LOWMEMORYKILLER_H */
-- 
1.8.1

