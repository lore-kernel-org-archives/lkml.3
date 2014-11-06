Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751448AbaKFMXq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 07:23:46 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:36440 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbaKFMXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 07:23:40 -0500
From: Matt Fleming <matt@console-pimps.org>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kanaka Juvva <kanaka.d.juvva@intel.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH v3 05/11] perf: Move cgroup init before PMU ->event_init()
Date: Thu,  6 Nov 2014 12:23:16 +0000
Message-Id: <1415276602-10337-6-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1415276602-10337-1-git-send-email-matt@console-pimps.org>
References: <1415276602-10337-1-git-send-email-matt@console-pimps.org>
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
Changes in v3:

 - Only use 'int cgroup_fd' to pass cgroup file descriptor instead of
   'bool cgroup, pid_t cgroup_fd'

 kernel/events/core.c | 28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index a2ea4a52dbbf..540d995322dd 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6884,7 +6884,7 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 		 struct perf_event *group_leader,
 		 struct perf_event *parent_event,
 		 perf_overflow_handler_t overflow_handler,
-		 void *context)
+		 void *context, int cgroup_fd)
 {
 	struct pmu *pmu;
 	struct perf_event *event;
@@ -6977,6 +6977,12 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
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
@@ -7000,6 +7006,8 @@ err_pmu:
 		event->destroy(event);
 	module_put(pmu->module);
 err_ns:
+	if (is_cgroup_event(event))
+		perf_detach_cgroup(event);
 	if (event->ns)
 		put_pid_ns(event->ns);
 	kfree(event);
@@ -7207,6 +7215,7 @@ SYSCALL_DEFINE5(perf_event_open,
 	int move_group = 0;
 	int err;
 	int f_flags = O_RDWR;
+	int cgroup_fd = -1;
 
 	/* for future expandability... */
 	if (flags & ~PERF_FLAG_ALL)
@@ -7272,21 +7281,16 @@ SYSCALL_DEFINE5(perf_event_open,
 
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
@@ -7486,7 +7490,7 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
 	 */
 
 	event = perf_event_alloc(attr, cpu, task, NULL, NULL,
-				 overflow_handler, context);
+				 overflow_handler, context, -1);
 	if (IS_ERR(event)) {
 		err = PTR_ERR(event);
 		goto err;
@@ -7812,7 +7816,7 @@ inherit_event(struct perf_event *parent_event,
 					   parent_event->cpu,
 					   child,
 					   group_leader, parent_event,
-				           NULL, NULL);
+				           NULL, NULL, -1);
 	if (IS_ERR(child_event))
 		return child_event;
 
-- 
1.9.3

