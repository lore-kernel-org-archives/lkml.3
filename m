Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759253Ab3IBU6v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 16:58:51 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48849 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758992Ab3IBU4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 16:56:50 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 06/10] perf list: Skip unsupported events
Date: Mon,  2 Sep 2013 17:56:29 -0300
Message-Id: <1378155393-7993-7-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1378155393-7993-1-git-send-email-acme@infradead.org>
References: <1378155393-7993-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Some hardware events might not be supported on a system.  Listing those
events seems meaningless and confusing to users.  Let's skip them.

Before:
  $ perf list cache | wc -l
  33

After:
  $ perf list cache | wc -l
  27

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1377571313-14722-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/parse-events.c | 41 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 39 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index b2dd077..9812531 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -15,6 +15,7 @@
 #define YY_EXTRA_TYPE int
 #include "parse-events-flex.h"
 #include "pmu.h"
+#include "thread_map.h"
 
 #define MAX_NAME_LEN 100
 
@@ -1076,6 +1077,33 @@ int is_valid_tracepoint(const char *event_string)
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
@@ -1083,14 +1111,16 @@ static void __print_events_type(u8 type, struct event_symbol *syms,
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
 
@@ -1119,6 +1149,10 @@ int print_hwcache_events(const char *event_glob, bool name_only)
 				if (event_glob != NULL && !strglobmatch(name, event_glob))
 					continue;
 
+				if (!is_event_supported(PERF_TYPE_HW_CACHE,
+							type | (op << 8) | (i << 16)))
+					continue;
+
 				if (name_only)
 					printf("%s ", name);
 				else
@@ -1148,6 +1182,9 @@ static void print_symbol_events(const char *event_glob, unsigned type,
 		      (syms->alias && strglobmatch(syms->alias, event_glob))))
 			continue;
 
+		if (!is_event_supported(type, i))
+			continue;
+
 		if (name_only) {
 			printf("%s ", syms->symbol);
 			continue;
-- 
1.8.1.4

