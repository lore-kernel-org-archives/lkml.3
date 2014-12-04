Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856AbaLDAOF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 19:14:05 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:47037 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768AbaLDAN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 19:13:58 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Jacob Shin <jacob.w.shin@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, xiakaixu <xiakaixu@huawei.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 2/4] perf tools: allow user to specify hardware breakpoint bp_len
Date: Thu,  4 Dec 2014 01:13:43 +0100
Message-Id: <1417652025-2305-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417652025-2305-1-git-send-email-fweisbec@gmail.com>
References: <1417652025-2305-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jacob Shin <jacob.w.shin@gmail.com>

Currently bp_len is given a default value of 4. Allow user to override it:

  $ perf stat -e mem:0x1000/8
                            ^
                            bp_len

If no value is given, it will default to 4 as it did before.

Signed-off-by: Jacob Shin <jacob.w.shin@gmail.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: xiakaixu <xiakaixu@huawei.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 tools/perf/Documentation/perf-record.txt |  7 +++++--
 tools/perf/util/parse-events.c           | 21 +++++++++++----------
 tools/perf/util/parse-events.h           |  2 +-
 tools/perf/util/parse-events.l           |  1 +
 tools/perf/util/parse-events.y           | 26 ++++++++++++++++++++++++--
 5 files changed, 42 insertions(+), 15 deletions(-)

diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index af9a54e..81a20f2 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -33,12 +33,15 @@ OPTIONS
         - a raw PMU event (eventsel+umask) in the form of rNNN where NNN is a
 	  hexadecimal event descriptor.
 
-        - a hardware breakpoint event in the form of '\mem:addr[:access]'
+        - a hardware breakpoint event in the form of '\mem:addr[/len][:access]'
           where addr is the address in memory you want to break in.
           Access is the memory access type (read, write, execute) it can
-          be passed as follows: '\mem:addr[:[r][w][x]]'.
+          be passed as follows: '\mem:addr[:[r][w][x]]'. len is the range,
+          number of bytes from specified addr, which the breakpoint will cover.
           If you want to profile read-write accesses in 0x1000, just set
           'mem:0x1000:rw'.
+          If you want to profile write accesses in [0x1000~1008), just set
+          'mem:0x1000/8:w'.
 
 --filter=<filter>::
         Event filter.
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index c659a3c..efa1ff4 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -526,7 +526,7 @@ do {					\
 }
 
 int parse_events_add_breakpoint(struct list_head *list, int *idx,
-				void *ptr, char *type)
+				void *ptr, char *type, u64 len)
 {
 	struct perf_event_attr attr;
 
@@ -536,14 +536,15 @@ int parse_events_add_breakpoint(struct list_head *list, int *idx,
 	if (parse_breakpoint_type(type, &attr))
 		return -EINVAL;
 
-	/*
-	 * We should find a nice way to override the access length
-	 * Provide some defaults for now
-	 */
-	if (attr.bp_type == HW_BREAKPOINT_X)
-		attr.bp_len = sizeof(long);
-	else
-		attr.bp_len = HW_BREAKPOINT_LEN_4;
+	/* Provide some defaults if len is not specified */
+	if (!len) {
+		if (attr.bp_type == HW_BREAKPOINT_X)
+			len = sizeof(long);
+		else
+			len = HW_BREAKPOINT_LEN_4;
+	}
+
+	attr.bp_len = len;
 
 	attr.type = PERF_TYPE_BREAKPOINT;
 	attr.sample_period = 1;
@@ -1364,7 +1365,7 @@ void print_events(const char *event_glob, bool name_only)
 		printf("\n");
 
 		printf("  %-50s [%s]\n",
-		       "mem:<addr>[:access]",
+		       "mem:<addr>[/len][:access]",
 			event_type_descriptors[PERF_TYPE_BREAKPOINT]);
 		printf("\n");
 	}
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index db2cf78..a19fbeb 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -104,7 +104,7 @@ int parse_events_add_numeric(struct list_head *list, int *idx,
 int parse_events_add_cache(struct list_head *list, int *idx,
 			   char *type, char *op_result1, char *op_result2);
 int parse_events_add_breakpoint(struct list_head *list, int *idx,
-				void *ptr, char *type);
+				void *ptr, char *type, u64 len);
 int parse_events_add_pmu(struct list_head *list, int *idx,
 			 char *pmu , struct list_head *head_config);
 enum perf_pmu_event_symbol_type
diff --git a/tools/perf/util/parse-events.l b/tools/perf/util/parse-events.l
index 906630b..94eacb6 100644
--- a/tools/perf/util/parse-events.l
+++ b/tools/perf/util/parse-events.l
@@ -159,6 +159,7 @@ branch_type		{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_BRANCH_SAMPLE_TYPE
 <mem>{
 {modifier_bp}		{ return str(yyscanner, PE_MODIFIER_BP); }
 :			{ return ':'; }
+"/"			{ return '/'; }
 {num_dec}		{ return value(yyscanner, 10); }
 {num_hex}		{ return value(yyscanner, 16); }
 	/*
diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-events.y
index 93c4c9f..72def07 100644
--- a/tools/perf/util/parse-events.y
+++ b/tools/perf/util/parse-events.y
@@ -326,6 +326,28 @@ PE_NAME_CACHE_TYPE
 }
 
 event_legacy_mem:
+PE_PREFIX_MEM PE_VALUE '/' PE_VALUE ':' PE_MODIFIER_BP sep_dc
+{
+	struct parse_events_evlist *data = _data;
+	struct list_head *list;
+
+	ALLOC_LIST(list);
+	ABORT_ON(parse_events_add_breakpoint(list, &data->idx,
+					     (void *) $2, $6, $4));
+	$$ = list;
+}
+|
+PE_PREFIX_MEM PE_VALUE '/' PE_VALUE sep_dc
+{
+	struct parse_events_evlist *data = _data;
+	struct list_head *list;
+
+	ALLOC_LIST(list);
+	ABORT_ON(parse_events_add_breakpoint(list, &data->idx,
+					     (void *) $2, NULL, $4));
+	$$ = list;
+}
+|
 PE_PREFIX_MEM PE_VALUE ':' PE_MODIFIER_BP sep_dc
 {
 	struct parse_events_evlist *data = _data;
@@ -333,7 +355,7 @@ PE_PREFIX_MEM PE_VALUE ':' PE_MODIFIER_BP sep_dc
 
 	ALLOC_LIST(list);
 	ABORT_ON(parse_events_add_breakpoint(list, &data->idx,
-					     (void *) $2, $4));
+					     (void *) $2, $4, 0));
 	$$ = list;
 }
 |
@@ -344,7 +366,7 @@ PE_PREFIX_MEM PE_VALUE sep_dc
 
 	ALLOC_LIST(list);
 	ABORT_ON(parse_events_add_breakpoint(list, &data->idx,
-					     (void *) $2, NULL));
+					     (void *) $2, NULL, 0));
 	$$ = list;
 }
 
-- 
2.1.3

