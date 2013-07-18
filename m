Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934550Ab3GRWm6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 18:42:58 -0400
Received: from mga09.intel.com ([134.134.136.24]:7826 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933531Ab3GRWmm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 18:42:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,697,1367996400"; 
   d="scan'208";a="372821146"
From: Andi Kleen <andi@firstfloor.org>
To: acme@infradead.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] perf, tools: Increase the file descriptor limits
Date: Thu, 18 Jul 2013 15:42:39 -0700
Message-Id: <1374187359-14138-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

perf stat -a needs 10 open file descriptors per logical CPU
perf stat -a -dddd needs 20 open fds for each.

This implies that stat -a doesn't work on any system with the default
ulimit -n 1024 which has more than ~100 CPUs and stat -a -dddd doesn't
work on anything with more than 46 CPUs.

Longer term there needs to be probably some way to lower the file
descriptor requirements. This would need some changes in the
kernel/user interface.

But short term this patch just tries to increase the file
descriptor limit in perf itself, when it runs into a EMFILE.

It first sets it to the hard limit, and then tries to increase
the hard limit.

On Fedora systems the default seems to be soft limit 1024
and hard limit 4*1024. So even non root can support 409
or 186 CPUs respectively. root can go far higher.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/util/evsel.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 07b1a3a..155fdaa 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -20,6 +20,7 @@
 #include "target.h"
 #include <linux/hw_breakpoint.h>
 #include <linux/perf_event.h>
+#include <sys/resource.h>
 #include "perf_regs.h"
 
 static struct {
@@ -823,6 +824,7 @@ static int __perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
 	int cpu, thread;
 	unsigned long flags = 0;
 	int pid = -1, err;
+	enum { NO_CHANGE, SET_TO_MAX, INCREASED_MAX } set_rlimit = NO_CHANGE;
 
 	if (evsel->fd == NULL &&
 	    perf_evsel__alloc_fd(evsel, cpus->nr, threads->nr) < 0)
@@ -850,6 +852,7 @@ retry_sample_id:
 
 			group_fd = get_group_fd(evsel, cpu, thread);
 
+retry_open:
 			FD(evsel, cpu, thread) = sys_perf_event_open(&evsel->attr,
 								     pid,
 								     cpus->map[cpu],
@@ -858,12 +861,37 @@ retry_sample_id:
 				err = -errno;
 				goto try_fallback;
 			}
+			set_rlimit = NO_CHANGE;
 		}
 	}
 
 	return 0;
 
 try_fallback:
+	/*
+	 * perf stat needs between 5 and 22 fds per CPU. When we run out
+	 * of them try to increase the limits.
+	 */
+	if (err == -EMFILE && set_rlimit < INCREASED_MAX) {
+		struct rlimit l;
+		int old_errno = errno;
+
+		if (getrlimit(RLIMIT_NOFILE, &l) == 0) {
+			if (set_rlimit == NO_CHANGE)
+				l.rlim_cur = l.rlim_max;
+			else {
+				l.rlim_cur = l.rlim_max + 1000;
+				l.rlim_max = l.rlim_cur;
+			}
+			if (setrlimit(RLIMIT_NOFILE, &l) == 0) {
+				set_rlimit++;
+				errno = old_errno;
+				goto retry_open;
+			}
+		}
+		errno = old_errno;
+	}
+
 	if (err != -EINVAL || cpu > 0 || thread > 0)
 		goto out_close;
 
-- 
1.8.1.4

