Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951AbaJVP3t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 11:29:49 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:37043 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183AbaJVP3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 11:29:47 -0400
From: Robert Bragg <robert@sixbynine.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Rob Clark <robdclark@gmail.com>,
        Samuel Pitoiset <samuel.pitoiset@gmail.com>,
        Ben Skeggs <bskeggs@redhat.com>, Robert Bragg <robert@sixbynine.org>
Subject: [RFC PATCH 2/3] perf: Add PERF_PMU_CAP_IS_DEVICE flag
Date: Wed, 22 Oct 2014 16:28:50 +0100
Message-Id: <1413991731-20628-3-git-send-email-robert@sixbynine.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1413991731-20628-1-git-send-email-robert@sixbynine.org>
References: <1413991731-20628-1-git-send-email-robert@sixbynine.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PERF_PMU_CAP_IS_DEVICE flag provides pmu drivers a way to declare
that they only monitor device specific metrics and since they don't
monitor any cpu metrics then perf should bypass any cpu centric security
checks, as well as disallow cpu centric attributes.

Signed-off-by: Robert Bragg <robert@sixbynine.org>
---
 include/linux/perf_event.h |  1 +
 kernel/events/core.c       | 39 +++++++++++++++++++++++++++++++++------
 2 files changed, 34 insertions(+), 6 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 707617a..e1e0153 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -170,6 +170,7 @@ struct perf_event;
  * pmu::capabilities flags
  */
 #define PERF_PMU_CAP_NO_INTERRUPT		0x01
+#define PERF_PMU_CAP_IS_DEVICE			0x02
 
 /**
  * struct pmu - generic performance monitoring unit
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 9449180..3ddb157 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3131,7 +3131,8 @@ find_get_context(struct pmu *pmu, struct task_struct *task, int cpu)
 
 	if (!task) {
 		/* Must be root to operate on a CPU event: */
-		if (perf_paranoid_cpu() && !capable(CAP_SYS_ADMIN))
+		if (!(pmu->capabilities & PERF_PMU_CAP_IS_DEVICE) &&
+		    perf_paranoid_cpu() && !capable(CAP_SYS_ADMIN))
 			return ERR_PTR(-EACCES);
 
 		/*
@@ -7091,11 +7092,6 @@ SYSCALL_DEFINE5(perf_event_open,
 	if (err)
 		return err;
 
-	if (!attr.exclude_kernel) {
-		if (perf_paranoid_kernel() && !capable(CAP_SYS_ADMIN))
-			return -EACCES;
-	}
-
 	if (attr.freq) {
 		if (attr.sample_freq > sysctl_perf_event_sample_rate)
 			return -EINVAL;
@@ -7154,6 +7150,37 @@ SYSCALL_DEFINE5(perf_event_open,
 		goto err_cpus;
 	}
 
+	if (event->pmu->capabilities & PERF_PMU_CAP_IS_DEVICE) {
+
+		/* Don't allow cpu centric attributes... */
+		if (event->attr.exclude_user ||
+		    event->attr.exclude_callchain_user ||
+		    event->attr.exclude_kernel ||
+		    event->attr.exclude_callchain_kernel ||
+		    event->attr.exclude_hv ||
+		    event->attr.exclude_idle ||
+		    event->attr.exclude_host ||
+		    event->attr.exclude_guest ||
+		    event->attr.mmap ||
+		    event->attr.comm ||
+		    event->attr.task)
+			return -EINVAL;
+
+		if (attr.sample_type &
+		    (PERF_SAMPLE_IP |
+		     PERF_SAMPLE_TID |
+		     PERF_SAMPLE_ADDR |
+		     PERF_SAMPLE_CALLCHAIN |
+		     PERF_SAMPLE_CPU |
+		     PERF_SAMPLE_BRANCH_STACK |
+		     PERF_SAMPLE_REGS_USER |
+		     PERF_SAMPLE_STACK_USER))
+			return -EINVAL;
+	} else if (!attr.exclude_kernel) {
+		if (perf_paranoid_kernel() && !capable(CAP_SYS_ADMIN))
+			return -EACCES;
+	}
+
 	if (flags & PERF_FLAG_PID_CGROUP) {
 		err = perf_cgroup_connect(pid, event, &attr, group_leader);
 		if (err) {
-- 
2.1.2

