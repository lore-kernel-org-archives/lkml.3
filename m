Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936756Ab3DICYU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 22:24:20 -0400
Received: from mail-qe0-f50.google.com ([209.85.128.50]:35742 "EHLO
	mail-qe0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936603Ab3DICXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 22:23:46 -0400
From: Tejun Heo <tj@kernel.org>
To: mingo@redhat.com
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, acme@ghostprotocols.net,
        eranian@google.com, namhyung.kim@lge.com, lizefan@huawei.com,
        mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com,
        cgroups@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/3] perf: make perf_event cgroup hierarchical
Date: Mon,  8 Apr 2013 19:23:33 -0700
Message-Id: <1365474213-13354-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1365474213-13354-1-git-send-email-tj@kernel.org>
References: <1365474213-13354-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf_event is one of a couple remaining cgroup controllers with broken
hierarchy support.  Converting it to support hierarchy is almost
trivial.  The only thing necessary is to consider a task belonging to
a descendant cgroup as a match.  IOW, if the cgroup of the currently
executing task (@cpuctx->cgrp) equals or is a descendant of the
event's cgroup (@event->cgrp), then the event should be enabled.

Implement hierarchy support and remove .broken_hierarchy tag along
with the incorrect comment on what needs to be done for hierarchy
support.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Stephane Eranian <eranian@google.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
---
 kernel/events/core.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index b0cd865..310ec19 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -251,7 +251,22 @@ perf_cgroup_match(struct perf_event *event)
 	struct perf_event_context *ctx = event->ctx;
 	struct perf_cpu_context *cpuctx = __get_cpu_context(ctx);
 
-	return !event->cgrp || event->cgrp == cpuctx->cgrp;
+	/* @event doesn't care about cgroup */
+	if (!event->cgrp)
+		return true;
+
+	/* wants specific cgroup scope but @cpuctx isn't associated with any */
+	if (!cpuctx->cgrp)
+		return false;
+
+	/*
+	 * Cgroup scoping is recursive.  An event enabled for a cgroup is
+	 * also enabled for all its descendant cgroups.  If @cpuctx's
+	 * cgroup is a descendant of @event's (the test covers identity
+	 * case), it's a match.
+	 */
+	return cgroup_is_descendant(cpuctx->cgrp->css.cgroup,
+				    event->cgrp->css.cgroup);
 }
 
 static inline bool perf_tryget_cgroup(struct perf_event *event)
@@ -7509,12 +7524,5 @@ struct cgroup_subsys perf_subsys = {
 	.css_free	= perf_cgroup_css_free,
 	.exit		= perf_cgroup_exit,
 	.attach		= perf_cgroup_attach,
-
-	/*
-	 * perf_event cgroup doesn't handle nesting correctly.
-	 * ctx->nr_cgroups adjustments should be propagated through the
-	 * cgroup hierarchy.  Fix it and remove the following.
-	 */
-	.broken_hierarchy = true,
 };
 #endif /* CONFIG_CGROUP_PERF */
-- 
1.8.1.4

