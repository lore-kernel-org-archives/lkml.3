Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144AbaAHIsd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 03:48:33 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:48017 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755925AbaAHIqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 03:46:52 -0500
X-AuditID: 9c93017d-b7b66ae000006a2a-2e-52cd10715fe2
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Arun Sharma <asharma@fb.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: [PATCH 22/28] perf tools: Factor out fill_callchain_info()
Date: Wed,  8 Jan 2014 17:46:27 +0900
Message-Id: <1389170793-21926-23-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1389170793-21926-1-git-send-email-namhyung@kernel.org>
References: <1389170793-21926-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The fill_callchain_info() will be shared with perf top --children.

Cc: Arun Sharma <asharma@fb.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-report.c | 38 +-------------------------------------
 tools/perf/util/callchain.c | 42 ++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/callchain.h |  2 ++
 3 files changed, 45 insertions(+), 37 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 06eceab8d4af..ef9c67ff9e32 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -402,43 +402,7 @@ iter_next_cumulative_entry(struct hist_entry_iter *iter,
 	if (node == NULL)
 		return 0;
 
-	al->map = node->map;
-	al->sym = node->sym;
-	if (node->map)
-		al->addr = node->map->map_ip(node->map, node->ip);
-	else
-		al->addr = node->ip;
-
-	if (al->sym == NULL) {
-		if (iter->rep->hide_unresolved)
-			return 0;
-		if (al->map == NULL)
-			goto out;
-	}
-
-	if (al->map->groups == &al->machine->kmaps) {
-		if (machine__is_host(al->machine)) {
-			al->cpumode = PERF_RECORD_MISC_KERNEL;
-			al->level = 'k';
-		} else {
-			al->cpumode = PERF_RECORD_MISC_GUEST_KERNEL;
-			al->level = 'g';
-		}
-	} else {
-		if (machine__is_host(al->machine)) {
-			al->cpumode = PERF_RECORD_MISC_USER;
-			al->level = '.';
-		} else if (perf_guest) {
-			al->cpumode = PERF_RECORD_MISC_GUEST_USER;
-			al->level = 'u';
-		} else {
-			al->cpumode = PERF_RECORD_MISC_HYPERVISOR;
-			al->level = 'H';
-		}
-	}
-
-out:
-	return 1;
+	return fill_callchain_info(al, node, iter->rep->hide_unresolved);
 }
 
 static int
diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index 92b9010a651c..0799759a8e27 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -555,3 +555,45 @@ int hist_entry__append_callchain(struct hist_entry *he, struct perf_sample *samp
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
index 209538924cb6..bbd63dfbe112 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -155,6 +155,8 @@ int sample__resolve_callchain(struct perf_sample *sample, struct symbol **parent
 			      struct perf_evsel *evsel, struct addr_location *al,
 			      int max_stack);
 int hist_entry__append_callchain(struct hist_entry *he, struct perf_sample *sample);
+int fill_callchain_info(struct addr_location *al, struct callchain_cursor_node *node,
+			bool hide_unresolved);
 
 extern const char record_callchain_help[];
 
-- 
1.7.11.7

