Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932175AbbAWSr5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 13:47:57 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:33749 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756363AbbAWSp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 13:45:59 -0500
From: Matt Fleming <matt@codeblueprint.co.uk>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kanaka Juvva <kanaka.d.juvva@intel.com>,
        Vikas Shivappa <vikas.shivappa@linux.intel.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 3/9] perf: Move cgroup init before PMU ->event_init()
Date: Fri, 23 Jan 2015 18:45:42 +0000
Message-Id: <1422038748-21397-4-git-send-email-matt@codeblueprint.co.uk>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1422038748-21397-1-git-send-email-matt@codeblueprint.co.uk>
References: <1422038748-21397-1-git-send-email-matt@codeblueprint.co.uk>
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
index 56efd5142f3e..bc7c2f42c7cb 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6934,7 +6934,7 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 		 struct perf_event *group_leader,
 		 struct perf_event *parent_event,
 		 perf_overflow_handler_t overflow_handler,
-		 void *context)
+		 void *context, int cgroup_fd)
 {
 	struct pmu *pmu;
 	struct perf_event *event;
@@ -7027,6 +7027,12 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 	if (attr->inherit && (attr->read_format & PERF_FORMAT_GROUP))
 		goto err_ns;
 
+	if (cgroup_fd != -1) {
+		err = perf_cgroup_connect(cgroup_fd, event, attr, group_leader);
+		if (err)
+			goto err_ns;
+	}
+
 	pmu = perf_init_event(event);
 	if (!pmu)
 		goto err_ns;
@@ -7050,6 +7056,8 @@ err_pmu:
 		event->destroy(event);
 	module_put(pmu->module);
 err_ns:
+	if (is_cgroup_event(event))
+		perf_detach_cgroup(event);
 	if (event->ns)
 		put_pid_ns(event->ns);
 	kfree(event);
@@ -7259,6 +7267,7 @@ SYSCALL_DEFINE5(perf_event_open,
 	int move_group = 0;
 	int err;
 	int f_flags = O_RDWR;
+	int cgroup_fd = -1;
 
 	/* for future expandability... */
 	if (flags & ~PERF_FLAG_ALL)
@@ -7324,21 +7333,16 @@ SYSCALL_DEFINE5(perf_event_open,
 
 	get_online_cpus();
 
+	if (flags & PERF_FLAG_PID_CGROUP)
+		cgroup_fd = pid;
+
 	event = perf_event_alloc(&attr, cpu, task, group_leader, NULL,
-				 NULL, NULL);
+				 NULL, NULL, cgroup_fd);
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
@@ -7538,7 +7542,7 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
 	 */
 
 	event = perf_event_alloc(attr, cpu, task, NULL, NULL,
-				 overflow_handler, context);
+				 overflow_handler, context, -1);
 	if (IS_ERR(event)) {
 		err = PTR_ERR(event);
 		goto err;
@@ -7864,7 +7868,7 @@ inherit_event(struct perf_event *parent_event,
 					   parent_event->cpu,
 					   child,
 					   group_leader, parent_event,
-				           NULL, NULL);
+				           NULL, NULL, -1);
 	if (IS_ERR(child_event))
 		return child_event;
 
-- 
1.9.3

