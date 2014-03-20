Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803AbaCTFm5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 01:42:57 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:61615 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428AbaCTFgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 01:36:52 -0400
X-AuditID: 9c93017e-b7b10ae000000e66-f9-532a7e71174b
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, Arun Sharma <asharma@fb.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: [PATCH 05/21] perf tools: Update cpumode for each cumulative entry
Date: Thu, 20 Mar 2014 14:36:30 +0900
Message-Id: <1395293806-25847-6-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1395293806-25847-1-git-send-email-namhyung@kernel.org>
References: <1395293806-25847-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cpumode and level in struct addr_localtion was set for a sample
and but updated as cumulative callchains were added.  This led to have
non-matching symbol and cpumode in the output.

Update it accordingly based on the fact whether the map is a part of
the kernel or not.  This is a reverse of what thread__find_addr_map()
does.

Tested-by: Arun Sharma <asharma@fb.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/callchain.c | 42 ++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/callchain.h |  2 ++
 tools/perf/util/hist.c      | 13 ++-----------
 3 files changed, 46 insertions(+), 11 deletions(-)

diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index 35b12a06bc39..c1d4ccd755ed 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -552,3 +552,45 @@ int hist_entry__append_callchain(struct hist_entry *he, struct perf_sample *samp
 		return 0;
 	return callchain_append(he->callchain, &callchain_cursor, sample->period);
 }
+
+int fill_callchain_info(struct addr_location *al, struct callchain_cursor_node *node,
+			bool hide_unresolved)
+{
+	al->map = node->map;
+	al->sym = node->sym;
+	if (node->map)
+		al->addr = node->map->map_ip(node->map, node->ip);
+	else
+		al->addr = node->ip;
+
+	if (al->sym == NULL) {
+		if (hide_unresolved)
+			return 0;
+		if (al->map == NULL)
+			goto out;
+	}
+
+	if (al->map->groups == &al->machine->kmaps) {
+		if (machine__is_host(al->machine)) {
+			al->cpumode = PERF_RECORD_MISC_KERNEL;
+			al->level = 'k';
+		} else {
+			al->cpumode = PERF_RECORD_MISC_GUEST_KERNEL;
+			al->level = 'g';
+		}
+	} else {
+		if (machine__is_host(al->machine)) {
+			al->cpumode = PERF_RECORD_MISC_USER;
+			al->level = '.';
+		} else if (perf_guest) {
+			al->cpumode = PERF_RECORD_MISC_GUEST_USER;
+			al->level = 'u';
+		} else {
+			al->cpumode = PERF_RECORD_MISC_HYPERVISOR;
+			al->level = 'H';
+		}
+	}
+
+out:
+	return 1;
+}
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index 8ad97e9b119f..66faae21370d 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -155,6 +155,8 @@ int sample__resolve_callchain(struct perf_sample *sample, struct symbol **parent
 			      struct perf_evsel *evsel, struct addr_location *al,
 			      int max_stack);
 int hist_entry__append_callchain(struct hist_entry *he, struct perf_sample *sample);
+int fill_callchain_info(struct addr_location *al, struct callchain_cursor_node *node,
+			bool hide_unresolved);
 
 extern const char record_callchain_help[];
 #endif	/* __PERF_CALLCHAIN_H */
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index c00114f9272c..5ebdc346bffb 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -747,18 +747,9 @@ iter_next_cumulative_entry(struct hist_entry_iter *iter,
 	if (node == NULL)
 		return 0;
 
-	al->map = node->map;
-	al->sym = node->sym;
-	if (node->map)
-		al->addr = node->map->map_ip(node->map, node->ip);
-	else
-		al->addr = node->ip;
-
-	if (iter->hide_unresolved && al->sym == NULL)
-		return 0;
-
 	callchain_cursor_advance(&callchain_cursor);
-	return 1;
+
+	return fill_callchain_info(al, node, iter->hide_unresolved);
 }
 
 static int
-- 
1.7.11.7

