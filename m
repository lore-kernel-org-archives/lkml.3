Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849Ab3H0CmB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 22:42:01 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:43606 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904Ab3H0CmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 22:42:00 -0400
X-AuditID: 9c930197-b7b44ae00000347f-3a-521c11f696de
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>, David Ahern <dsahern@gmail.com>
Subject: [PATCH/RFC v2] perf list: Skip unsupported events
Date: Tue, 27 Aug 2013 11:41:53 +0900
Message-Id: <1377571313-14722-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1377570984-14255-1-git-send-email-namhyung@kernel.org>
References: <1377570984-14255-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Some hardware events might not be supported on a system.  Listing
those events seems meaningless and confusing to users.  Let's skip
them.

Before:
  $ perf list cache | wc -l
  33

After:
  $ perf list cache | wc -l
  27

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
* fixed a build error

 tools/perf/util/parse-events.c | 41 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 39 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 9cba92386a82..69ea4c0cf0aa 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -15,6 +15,7 @@
 #define YY_EXTRA_TYPE int
 #include "parse-events-flex.h"
 #include "pmu.h"
+#include "thread_map.h"
 
 #define MAX_NAME_LEN 100
 
@@ -1072,6 +1073,33 @@ int is_valid_tracepoint(const char *event_string)
 	return 0;
 }
 
+static bool is_event_supported(u8 type, unsigned config)
+{
+	bool ret = true;
+	struct perf_evsel *evsel;
+	struct perf_event_attr attr = {
+		.type = type,
+		.config = config,
+		.disabled = 1,
+		.exclude_kernel = 1,
+	};
+	struct {
+		struct thread_map map;
+		int threads[1];
+	} tmap = {
+		.map.nr	 = 1,
+		.threads = { 0 },
+	};
+
+	evsel = perf_evsel__new(&attr, 0);
+	if (evsel) {
+		ret = perf_evsel__open(evsel, NULL, &tmap.map) >= 0;
+		perf_evsel__delete(evsel);
+	}
+
+	return ret;
+}
+
 static void __print_events_type(u8 type, struct event_symbol *syms,
 				unsigned max)
 {
@@ -1079,14 +1107,16 @@ static void __print_events_type(u8 type, struct event_symbol *syms,
 	unsigned i;
 
 	for (i = 0; i < max ; i++, syms++) {
+		if (!is_event_supported(type, i))
+			continue;
+
 		if (strlen(syms->alias))
 			snprintf(name, sizeof(name),  "%s OR %s",
 				 syms->symbol, syms->alias);
 		else
 			snprintf(name, sizeof(name), "%s", syms->symbol);
 
-		printf("  %-50s [%s]\n", name,
-			event_type_descriptors[type]);
+		printf("  %-50s [%s]\n", name, event_type_descriptors[type]);
 	}
 }
 
@@ -1115,6 +1145,10 @@ int print_hwcache_events(const char *event_glob, bool name_only)
 				if (event_glob != NULL && !strglobmatch(name, event_glob))
 					continue;
 
+				if (!is_event_supported(PERF_TYPE_HW_CACHE,
+							type | (op << 8) | (i << 16)))
+					continue;
+
 				if (name_only)
 					printf("%s ", name);
 				else
@@ -1144,6 +1178,9 @@ static void print_symbol_events(const char *event_glob, unsigned type,
 		      (syms->alias && strglobmatch(syms->alias, event_glob))))
 			continue;
 
+		if (!is_event_supported(type, i))
+			continue;
+
 		if (name_only) {
 			printf("%s ", syms->symbol);
 			continue;
-- 
1.7.11.7

