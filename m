Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207Ab3GGUnN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jul 2013 16:43:13 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:56759 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753142Ab3GGUnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jul 2013 16:43:12 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH] perf: free list on error path parsing events
Date: Sun,  7 Jul 2013 14:43:04 -0600
Message-Id: <1373229784-6078-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

5f48cb6 moved list memory allocations into parse-events.y. That memory
needs to be freed on a parse failure.

Reported-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/parse-events.y |   41 ++++++++++++++++++++++++----------------
 1 file changed, 25 insertions(+), 16 deletions(-)

diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-events.y
index 4eb67ec..85d0999 100644
--- a/tools/perf/util/parse-events.y
+++ b/tools/perf/util/parse-events.y
@@ -22,6 +22,14 @@ do { \
 		YYABORT; \
 } while (0)
 
+#define ABORT_ON_FREE(val, p) \
+do { \
+	if (val) { \
+		free(p); \
+		YYABORT; \
+	} \
+} while (0)
+
 #define ALLOC_LIST(list) \
 do { \
 	list = malloc(sizeof(*list)); \
@@ -206,7 +214,7 @@ PE_NAME '/' event_config '/'
 	struct list_head *list;
 
 	ALLOC_LIST(list);
-	ABORT_ON(parse_events_add_pmu(list, &data->idx, $1, $3));
+	ABORT_ON_FREE(parse_events_add_pmu(list, &data->idx, $1, $3), list);
 	parse_events__free_terms($3);
 	$$ = list;
 }
@@ -225,8 +233,8 @@ value_sym '/' event_config '/'
 	int config = $1 & 255;
 
 	ALLOC_LIST(list);
-	ABORT_ON(parse_events_add_numeric(list, &data->idx,
-					  type, config, $3));
+	ABORT_ON_FREE(parse_events_add_numeric(list, &data->idx,
+					  type, config, $3), list);
 	parse_events__free_terms($3);
 	$$ = list;
 }
@@ -239,8 +247,8 @@ value_sym sep_slash_dc
 	int config = $1 & 255;
 
 	ALLOC_LIST(list);
-	ABORT_ON(parse_events_add_numeric(list, &data->idx,
-					  type, config, NULL));
+	ABORT_ON_FREE(parse_events_add_numeric(list, &data->idx,
+					  type, config, NULL), list);
 	$$ = list;
 }
 
@@ -251,7 +259,7 @@ PE_NAME_CACHE_TYPE '-' PE_NAME_CACHE_OP_RESULT '-' PE_NAME_CACHE_OP_RESULT
 	struct list_head *list;
 
 	ALLOC_LIST(list);
-	ABORT_ON(parse_events_add_cache(list, &data->idx, $1, $3, $5));
+	ABORT_ON_FREE(parse_events_add_cache(list, &data->idx, $1, $3, $5), list);
 	$$ = list;
 }
 |
@@ -261,7 +269,7 @@ PE_NAME_CACHE_TYPE '-' PE_NAME_CACHE_OP_RESULT
 	struct list_head *list;
 
 	ALLOC_LIST(list);
-	ABORT_ON(parse_events_add_cache(list, &data->idx, $1, $3, NULL));
+	ABORT_ON_FREE(parse_events_add_cache(list, &data->idx, $1, $3, NULL), list);
 	$$ = list;
 }
 |
@@ -271,7 +279,7 @@ PE_NAME_CACHE_TYPE
 	struct list_head *list;
 
 	ALLOC_LIST(list);
-	ABORT_ON(parse_events_add_cache(list, &data->idx, $1, NULL, NULL));
+	ABORT_ON_FREE(parse_events_add_cache(list, &data->idx, $1, NULL, NULL), list);
 	$$ = list;
 }
 
@@ -282,8 +290,8 @@ PE_PREFIX_MEM PE_VALUE ':' PE_MODIFIER_BP sep_dc
 	struct list_head *list;
 
 	ALLOC_LIST(list);
-	ABORT_ON(parse_events_add_breakpoint(list, &data->idx,
-					     (void *) $2, $4));
+	ABORT_ON_FREE(parse_events_add_breakpoint(list, &data->idx,
+					     (void *) $2, $4), list);
 	$$ = list;
 }
 |
@@ -293,8 +301,8 @@ PE_PREFIX_MEM PE_VALUE sep_dc
 	struct list_head *list;
 
 	ALLOC_LIST(list);
-	ABORT_ON(parse_events_add_breakpoint(list, &data->idx,
-					     (void *) $2, NULL));
+	ABORT_ON_FREE(parse_events_add_breakpoint(list, &data->idx,
+					     (void *) $2, NULL), list);
 	$$ = list;
 }
 
@@ -305,7 +313,7 @@ PE_NAME ':' PE_NAME
 	struct list_head *list;
 
 	ALLOC_LIST(list);
-	ABORT_ON(parse_events_add_tracepoint(list, &data->idx, $1, $3));
+	ABORT_ON_FREE(parse_events_add_tracepoint(list, &data->idx, $1, $3), list);
 	$$ = list;
 }
 
@@ -316,7 +324,8 @@ PE_VALUE ':' PE_VALUE
 	struct list_head *list;
 
 	ALLOC_LIST(list);
-	ABORT_ON(parse_events_add_numeric(list, &data->idx, (u32)$1, $3, NULL));
+	ABORT_ON_FREE(parse_events_add_numeric(list, &data->idx,
+					(u32)$1, $3, NULL), list);
 	$$ = list;
 }
 
@@ -327,8 +336,8 @@ PE_RAW
 	struct list_head *list;
 
 	ALLOC_LIST(list);
-	ABORT_ON(parse_events_add_numeric(list, &data->idx,
-					  PERF_TYPE_RAW, $1, NULL));
+	ABORT_ON_FREE(parse_events_add_numeric(list, &data->idx,
+					  PERF_TYPE_RAW, $1, NULL), list);
 	$$ = list;
 }
 
-- 
1.7.10.1

