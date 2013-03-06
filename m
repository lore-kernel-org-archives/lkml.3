Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758544Ab3CFOo6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 09:44:58 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44371 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757218Ab3CFOo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 09:44:56 -0500
Date: Wed, 6 Mar 2013 06:43:39 -0800
From: tip-bot for Li Zefan <tipbot@zytor.com>
Message-ID: <tip-877c685607925238e302cd3aa38788dca6c1b226@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, tj@kernel.org,
        tglx@linutronix.de, lizefan@huawei.com
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org, tj@kernel.org,
        tglx@linutronix.de, lizefan@huawei.com
In-Reply-To: <513568A0.6020804@huawei.com>
References: <513568A0.6020804@huawei.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf:
  Remove include of cgroup.h from perf_event.h
Git-Commit-ID: 877c685607925238e302cd3aa38788dca6c1b226
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 06 Mar 2013 06:43:44 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  877c685607925238e302cd3aa38788dca6c1b226
Gitweb:     http://git.kernel.org/tip/877c685607925238e302cd3aa38788dca6c1b226
Author:     Li Zefan <lizefan@huawei.com>
AuthorDate: Tue, 5 Mar 2013 11:38:08 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 6 Mar 2013 11:32:56 +0100

perf: Remove include of cgroup.h from perf_event.h

Move struct perf_cgroup_info and perf_cgroup to
kernel/perf/core.c, and then we can remove include of cgroup.h.

Signed-off-by: Li Zefan <lizefan@huawei.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tejun Heo <tj@kernel.org>
Link: http://lkml.kernel.org/r/513568A0.6020804@huawei.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
