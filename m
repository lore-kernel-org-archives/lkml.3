Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759648Ab3ICHQU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 03:16:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36031 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759612Ab3ICHQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 03:16:12 -0400
Date: Tue, 3 Sep 2013 00:15:50 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-b41f1cec91c37eeea6fdb15effbfa24ea0a5536b@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1377571313-14722-1-git-send-email-namhyung@kernel.org>
References: <1377571313-14722-1-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf list: Skip unsupported events
Git-Commit-ID: b41f1cec91c37eeea6fdb15effbfa24ea0a5536b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 03 Sep 2013 00:15:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b41f1cec91c37eeea6fdb15effbfa24ea0a5536b
Gitweb:     http://git.kernel.org/tip/b41f1cec91c37eeea6fdb15effbfa24ea0a5536b
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Tue, 27 Aug 2013 11:41:53 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 2 Sep 2013 14:58:21 -0300

perf list: Skip unsupported events

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
