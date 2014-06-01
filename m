Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757969AbaFANiy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 09:38:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12242 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757366AbaFANb4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 09:31:56 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 06/27] perf tools: Update cpumode for each cumulative entry
Date: Sun,  1 Jun 2014 15:31:17 +0200
Message-Id: <1401629498-8726-7-git-send-email-jolsa@kernel.org>
In-Reply-To: <1401629498-8726-1-git-send-email-jolsa@kernel.org>
References: <1401629498-8726-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

The cpumode and level in struct addr_localtion was set for a sample
and but updated as cumulative callchains were added.  This led to have
non-matching symbol and cpumode in the output.

Update it accordingly based on the fact whether the map is a part of
the kernel or not.  This is a reverse of what thread__find_addr_map()
does.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Tested-by: Arun Sharma <asharma@fb.com>
Tested-by: Rodrigo Campos <rodrigo@sdfg.com.ar>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/r/1401335910-16832-7-git-send-email-namhyung@kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/util/callchain.c | 42 ++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/callchain.h |  2 ++
 tools/perf/util/hist.c      | 13 ++-----------
 3 files changed, 46 insertions(+), 11 deletions(-)

diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index 2af69c4..48b6d3f 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -630,3 +630,45 @@ int hist_entry__append_callchain(struct hist_entry *he, struct perf_sample *samp
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
index bde2b0c..24a53d5 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -162,6 +162,8 @@ int sample__resolve_callchain(struct perf_sample *sample, struct symbol **parent
 			      struct perf_evsel *evsel, struct addr_location *al,
 			      int max_stack);
 int hist_entry__append_callchain(struct hist_entry *he, struct perf_sample *sample);
+int fill_callchain_info(struct addr_location *al, struct callchain_cursor_node *node,
+			bool hide_unresolved);
 
 extern const char record_callchain_help[];
 int parse_callchain_report_opt(const char *arg);
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 6079b5a..37c28fc 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -743,18 +743,9 @@ iter_next_cumulative_entry(struct hist_entry_iter *iter,
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
1.8.3.1

