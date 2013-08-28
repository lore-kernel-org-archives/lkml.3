Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149Ab3H1PFt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 11:05:49 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40488 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753674Ab3H1O7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 10:59:46 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 02/21] perf tools: Try to increase the file descriptor limits on EMFILE
Date: Wed, 28 Aug 2013 11:59:18 -0300
Message-Id: <1377701977-2085-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1377701977-2085-1-git-send-email-acme@infradead.org>
References: <1377701977-2085-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
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
descriptor requirements. This would need some changes in the kernel/user
interface.

But short term this patch just tries to increase the file descriptor
limit in perf itself, when it runs into a EMFILE.

It first sets it to the hard limit, and then tries to increase the hard
limit.

On Fedora systems the default seems to be soft limit 1024 and hard limit
4*1024. So even non root can support 409 or 186 CPUs respectively. root
can go far higher.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Link: http://lkml.kernel.org/r/1375670486-15480-1-git-send-email-andi@firstfloor.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evsel.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 960394e..a29c8d0 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -13,6 +13,7 @@
 #include <traceevent/event-parse.h>
 #include <linux/hw_breakpoint.h>
 #include <linux/perf_event.h>
+#include <sys/resource.h>
 #include "asm/bug.h"
 #include "evsel.h"
 #include "evlist.h"
@@ -867,6 +868,7 @@ static int __perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
 	int cpu, thread;
 	unsigned long flags = 0;
 	int pid = -1, err;
+	enum { NO_CHANGE, SET_TO_MAX, INCREASED_MAX } set_rlimit = NO_CHANGE;
 
 	if (evsel->fd == NULL &&
 	    perf_evsel__alloc_fd(evsel, cpus->nr, threads->nr) < 0)
@@ -894,6 +896,7 @@ retry_sample_id:
 
 			group_fd = get_group_fd(evsel, cpu, thread);
 
+retry_open:
 			FD(evsel, cpu, thread) = sys_perf_event_open(&evsel->attr,
 								     pid,
 								     cpus->map[cpu],
@@ -902,12 +905,37 @@ retry_sample_id:
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

