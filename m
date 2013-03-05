Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933089Ab3CEDiW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 22:38:22 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:17645 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932133Ab3CEDiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 22:38:19 -0500
Message-ID: <513568A0.6020804@huawei.com>
Date: Tue, 5 Mar 2013 11:38:08 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Tejun Heo <tj@kernel.org>
Subject: [PATCH] perf: remove include of cgroup.h from perf_event.h
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move struct perf_cgroup_info and perf_cgroup to kernel/perf/core.c,
and then we can remove include of cgroup.h.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 include/linux/perf_event.h | 18 +-----------------
 kernel/events/core.c       | 15 +++++++++++++++
 2 files changed, 16 insertions(+), 17 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index e47ee46..8737e1c 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -21,7 +21,6 @@
  */
 
 #ifdef CONFIG_PERF_EVENTS
-# include <linux/cgroup.h>
 # include <asm/perf_event.h>
 # include <asm/local64.h>
 #endif
@@ -299,22 +298,7 @@ struct swevent_hlist {
 #define PERF_ATTACH_GROUP	0x02
 #define PERF_ATTACH_TASK	0x04
 
-#ifdef CONFIG_CGROUP_PERF
-/*
- * perf_cgroup_info keeps track of time_enabled for a cgroup.
- * This is a per-cpu dynamically allocated data structure.
- */
-struct perf_cgroup_info {
-	u64				time;
-	u64				timestamp;
-};
-
-struct perf_cgroup {
-	struct				cgroup_subsys_state css;
-	struct				perf_cgroup_info *info;	/* timing info, one per cpu */
-};
-#endif
-
+struct perf_cgroup;
 struct ring_buffer;
 
 /**
diff --git a/kernel/events/core.c b/kernel/events/core.c
index b0cd865..5976a2a 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -37,6 +37,7 @@
 #include <linux/ftrace_event.h>
 #include <linux/hw_breakpoint.h>
 #include <linux/mm_types.h>
+#include <linux/cgroup.h>
 
 #include "internal.h"
 
@@ -234,6 +235,20 @@ static void perf_ctx_unlock(struct perf_cpu_context *cpuctx,
 #ifdef CONFIG_CGROUP_PERF
 
 /*
+ * perf_cgroup_info keeps track of time_enabled for a cgroup.
+ * This is a per-cpu dynamically allocated data structure.
+ */
+struct perf_cgroup_info {
+	u64				time;
+	u64				timestamp;
+};
+
+struct perf_cgroup {
+	struct cgroup_subsys_state	css;
+	struct perf_cgroup_info		*info;
+};
+
+/*
  * Must ensure cgroup is pinned (css_get) before calling
  * this function. In other words, we cannot call this function
  * if there is no cgroup event for the current CPU context.
-- 
1.8.0.2

