Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760655AbaGYOtO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 10:49:14 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:52186 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754156AbaGYOtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 10:49:12 -0400
From: Chintan Pandya <cpandya@codeaurora.org>
To: tglx@linutronix.de, john.stultz@linaro.org, peterz@infradead.org,
        mingo@redhat.com, hughd@google.com, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Chintan Pandya <cpandya@codeaurora.org>
Subject: [PATCH v2 2/2] ksm: Provide support to use deferrable timers for scanner thread
Date: Fri, 25 Jul 2014 20:18:18 +0530
Message-Id: <1406299698-6357-2-git-send-email-cpandya@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1406299698-6357-1-git-send-email-cpandya@codeaurora.org>
References: <1406299698-6357-1-git-send-email-cpandya@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KSM thread to scan pages is scheduled on definite timeout. That wakes
up CPU from idle state and hence may affect the power consumption.
Provide an optional support to use deferrable timer which suites
low-power use-cases.

Typically, on our setup we observed, 10% less power consumption with
some use-cases in which CPU goes to power collapse frequently. For
example, playing audio while typically CPU remains idle.

To enable deferrable timers,
$ echo 1 > /sys/kernel/mm/ksm/deferrable_timer

Signed-off-by: Chintan Pandya <cpandya@codeaurora.org>
---
 Changes from patch v1 to patch v2:
 - allowing only valid values to be updated as use_deferrable_timer
 - using only 'deferrable' and not 'deferred'
 - moved out schedule_timeout code for deferrable timer into timer.c

 Documentation/vm/ksm.txt |  7 +++++++
 mm/ksm.c                 | 40 ++++++++++++++++++++++++++++++++++++++--
 2 files changed, 45 insertions(+), 2 deletions(-)

diff --git a/Documentation/vm/ksm.txt b/Documentation/vm/ksm.txt
index f34a8ee..0481235 100644
--- a/Documentation/vm/ksm.txt
+++ b/Documentation/vm/ksm.txt
@@ -87,6 +87,13 @@ pages_sharing    - how many more sites are sharing them i.e. how much saved
 pages_unshared   - how many pages unique but repeatedly checked for merging
 pages_volatile   - how many pages changing too fast to be placed in a tree
 full_scans       - how many times all mergeable areas have been scanned
+deferrable_timer - whether to use deferrable timers or not
+                 e.g. "echo 1 > /sys/kernel/mm/ksm/deferrable_timer"
+                 Default: 0 (means, we are not using deferrable timers. Users
+		 might want to set deferrable_timer option if they donot want
+		 ksm thread to wakeup CPU to carryout ksm activities thus
+		 gaining on battery while compromising slightly on memory
+		 that could have been saved.)
 
 A high ratio of pages_sharing to pages_shared indicates good sharing, but
 a high ratio of pages_unshared to pages_sharing indicates wasted effort.
diff --git a/mm/ksm.c b/mm/ksm.c
index fb75902..2c5d206 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -223,6 +223,9 @@ static unsigned int ksm_thread_pages_to_scan = 100;
 /* Milliseconds ksmd should sleep between batches */
 static unsigned int ksm_thread_sleep_millisecs = 20;
 
+/* Boolean to indicate whether to use deferrable timer or not */
+static bool use_deferrable_timer;
+
 #ifdef CONFIG_NUMA
 /* Zeroed when merging across nodes is not allowed */
 static unsigned int ksm_merge_across_nodes = 1;
@@ -1705,6 +1708,11 @@ static void ksm_do_scan(unsigned int scan_npages)
 	}
 }
 
+static void process_timeout(unsigned long __data)
+{
+	wake_up_process((struct task_struct *)__data);
+}
+
 static int ksmd_should_run(void)
 {
 	return (ksm_run & KSM_RUN_MERGE) && !list_empty(&ksm_mm_head.mm_list);
@@ -1712,6 +1720,8 @@ static int ksmd_should_run(void)
 
 static int ksm_scan_thread(void *nothing)
 {
+	signed long to;
+
 	set_freezable();
 	set_user_nice(current, 5);
 
@@ -1725,8 +1735,11 @@ static int ksm_scan_thread(void *nothing)
 		try_to_freeze();
 
 		if (ksmd_should_run()) {
-			schedule_timeout_interruptible(
-				msecs_to_jiffies(ksm_thread_sleep_millisecs));
+			timeout = msecs_to_jiffies(ksm_thread_sleep_millisecs);
+			if (use_deferrable_timer)
+				schedule_timeout_deferrable_interruptible(to);
+			else
+				schedule_timeout_interruptible(to);
 		} else {
 			wait_event_freezable(ksm_thread_wait,
 				ksmd_should_run() || kthread_should_stop());
@@ -2175,6 +2188,28 @@ static ssize_t run_store(struct kobject *kobj, struct kobj_attribute *attr,
 }
 KSM_ATTR(run);
 
+static ssize_t deferrable_timer_show(struct kobject *kobj,
+				    struct kobj_attribute *attr, char *buf)
+{
+	return snprintf(buf, 8, "%d\n", use_deferrable_timer);
+}
+
+static ssize_t deferrable_timer_store(struct kobject *kobj,
+				     struct kobj_attribute *attr,
+				     const char *buf, size_t count)
+{
+	unsigned long enable;
+	int err;
+
+	err = kstrtoul(buf, 10, &enable);
+
+	if (enable == 0 || enable == 1)
+		use_deferrable_timer = enable;
+
+	return count;
+}
+KSM_ATTR(deferrable_timer);
+
 #ifdef CONFIG_NUMA
 static ssize_t merge_across_nodes_show(struct kobject *kobj,
 				struct kobj_attribute *attr, char *buf)
@@ -2287,6 +2322,7 @@ static struct attribute *ksm_attrs[] = {
 	&pages_unshared_attr.attr,
 	&pages_volatile_attr.attr,
 	&full_scans_attr.attr,
+	&deferrable_timer_attr.attr,
 #ifdef CONFIG_NUMA
 	&merge_across_nodes_attr.attr,
 #endif
-- 
Chintan Pandya

QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a
member of the Code Aurora Forum, hosted by The Linux Foundation

