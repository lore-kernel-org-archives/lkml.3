Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754959Ab3JUI7a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 04:59:30 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39860 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754526Ab3JUIxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:53:18 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Ingo Molnar" <mingo@kernel.org>,
        "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.524084390@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 133/149] perf: Fix perf_cgroup_switch for sw-events
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <a.p.zijlstra@chello.nl>

commit 95cf59ea72331d0093010543b8951bb43f262cac upstream.

Jiri reported that he could trigger the WARN_ON_ONCE() in
perf_cgroup_switch() using sw-events. This is because sw-events share
a cpuctx with multiple PMUs.

Use the ->unique_pmu pointer to limit the pmu iteration to unique
cpuctx instances.

Reported-and-Tested-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-so7wi2zf3jjzrwcutm2mkz0j@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/events/core.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -360,6 +360,8 @@ void perf_cgroup_switch(struct task_stru
 
 	list_for_each_entry_rcu(pmu, &pmus, entry) {
 		cpuctx = this_cpu_ptr(pmu->pmu_cpu_context);
+		if (cpuctx->unique_pmu != pmu)
+			continue; /* ensure we process each cpuctx once */
 
 		/*
 		 * perf_cgroup_events says at least one
@@ -383,9 +385,10 @@ void perf_cgroup_switch(struct task_stru
 
 			if (mode & PERF_CGROUP_SWIN) {
 				WARN_ON_ONCE(cpuctx->cgrp);
-				/* set cgrp before ctxsw in to
-				 * allow event_filter_match() to not
-				 * have to pass task around
+				/*
+				 * set cgrp before ctxsw in to allow
+				 * event_filter_match() to not have to pass
+				 * task around
 				 */
 				cpuctx->cgrp = perf_cgroup_from_task(task);
 				cpu_ctx_sched_in(cpuctx, EVENT_ALL, task);

