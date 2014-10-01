Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063AbaJAOgv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 10:36:51 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:63954 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037AbaJAOgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 10:36:49 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 06/11] perf: Move cgroup init before PMU ->event_init()
Date: Wed,  1 Oct 2014 15:36:27 +0100
Message-Id: <1412174192-7010-7-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1412174192-7010-1-git-send-email-matt@console-pimps.org>
References: <1412174192-7010-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

The Intel QoS PMU needs to know whether an event is part of a cgroup
during ->event_init(), because tasks in the same cgroup share a
monitoring ID.

Move the cgroup initialisation before calling into the PMU driver.

Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 kernel/events/core.c | 28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 2d5cde7af58f..b61ca7db3197 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6872,7 +6872,7 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 		 struct perf_event *group_leader,
 		 struct perf_event *parent_event,
 		 perf_overflow_handler_t overflow_handler,
-		 void *context)
+		 void *context, bool cgroup, pid_t pid)
 {
 	struct pmu *pmu;
 	struct perf_event *event;
@@ -6965,6 +6965,12 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 	if (attr->inherit && (attr->read_format & PERF_FORMAT_GROUP))
 		goto err_ns;
 
+	if (cgroup) {
+		err = perf_cgroup_connect(pid, event, attr, group_leader);
+		if (err)
+			goto err_ns;
+	}
+
 	pmu = perf_init_event(event);
 	if (!pmu)
 		goto err_ns;
@@ -6988,6 +6994,8 @@ err_pmu:
 		event->destroy(event);
 	module_put(pmu->module);
 err_ns:
+	if (is_cgroup_event(event))
+		perf_detach_cgroup(event);
 	if (event->ns)
 		put_pid_ns(event->ns);
 	kfree(event);
@@ -7191,6 +7199,7 @@ SYSCALL_DEFINE5(perf_event_open,
 	struct fd group = {NULL, 0};
 	struct task_struct *task = NULL;
 	struct pmu *pmu;
+	bool cgroup = false;
 	int event_fd;
 	int move_group = 0;
 	int err;
@@ -7260,21 +7269,16 @@ SYSCALL_DEFINE5(perf_event_open,
 
 	get_online_cpus();
 
+	if (flags & PERF_FLAG_PID_CGROUP)
+		cgroup = true;
+
 	event = perf_event_alloc(&attr, cpu, task, group_leader, NULL,
-				 NULL, NULL);
+				 NULL, NULL, cgroup, pid);
 	if (IS_ERR(event)) {
 		err = PTR_ERR(event);
 		goto err_cpus;
 	}
 
-	if (flags & PERF_FLAG_PID_CGROUP) {
-		err = perf_cgroup_connect(pid, event, &attr, group_leader);
-		if (err) {
-			__free_event(event);
-			goto err_cpus;
-		}
-	}
-
 	if (is_sampling_event(event)) {
 		if (event->pmu->capabilities & PERF_PMU_CAP_NO_INTERRUPT) {
 			err = -ENOTSUPP;
@@ -7474,7 +7478,7 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
 	 */
 
 	event = perf_event_alloc(attr, cpu, task, NULL, NULL,
-				 overflow_handler, context);
+				 overflow_handler, context, false, -1);
 	if (IS_ERR(event)) {
 		err = PTR_ERR(event);
 		goto err;
@@ -7812,7 +7816,7 @@ inherit_event(struct perf_event *parent_event,
 					   parent_event->cpu,
 					   child,
 					   group_leader, parent_event,
-				           NULL, NULL);
+				           NULL, NULL, false, -1);
 	if (IS_ERR(child_event))
 		return child_event;
 
-- 
1.9.3

