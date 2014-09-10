Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783AbaIJR43 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 13:56:29 -0400
Received: from mga09.intel.com ([134.134.136.24]:63482 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751717AbaIJR42 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 13:56:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,500,1406617200"; 
   d="scan'208";a="600986607"
From: kan.liang@intel.com
To: acme@kernel.org, jolsa@redhat.com
Cc: linux-kernel@vger.kernel.org, ak@linux.intel.com,
        Kan Liang <kan.liang@intel.com>
Subject: [PATCH V5 3/3] perf tools: Add support to new style format of kernel PMU event
Date: Wed, 10 Sep 2014 13:55:32 -0400
Message-Id: <1410371732-1185-3-git-send-email-kan.liang@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1410371732-1185-1-git-send-email-kan.liang@intel.com>
References: <1410371732-1185-1-git-send-email-kan.liang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kan Liang <kan.liang@intel.com>

Add new rules for kernel PMU event.

Currently, the patch only want to handle the PMU event name as "a-b" and
"a".

event_pmu:
PE_KERNEL_PMU_EVENT
|
PE_PMU_EVENT_PRE '-' PE_PMU_EVENT_SUF

PE_KERNEL_PMU_EVENT token is for
cycles-ct/cycles-t/mem-loads/mem-stores.
The prefix cycles is mixed up with cpu-cycles.
loads and stores are mixed up with cache event
So they have to be hardcode in lex.

PE_PMU_EVENT_PRE and PE_PMU_EVENT_SUF tokens are for other PMU
events.
The lex looks generic identifier up in the table and return the matched
token. If there is no match, generic PE_NAME token will be return.

Using the rules, kernel PMU event could use new style format without //

so you can use

perf record -e mem-loads ...

instead of

perf record -e cpu/mem-loads/

Signed-off-by: Kan Liang <kan.liang@intel.com>
---

v5: Use ALLOC_LIST

 tools/perf/util/parse-events.l | 30 +++++++++++++++++++++++++++++-
 tools/perf/util/parse-events.y | 40 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 69 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/parse-events.l b/tools/perf/util/parse-events.l
index 3432995..ea970cf 100644
--- a/tools/perf/util/parse-events.l
+++ b/tools/perf/util/parse-events.l
@@ -51,6 +51,24 @@ static int str(yyscan_t scanner, int token)
 	return token;
 }
 
+static int pmu_str_check(yyscan_t scanner)
+{
+	YYSTYPE *yylval = parse_events_get_lval(scanner);
+	char *text = parse_events_get_text(scanner);
+
+	yylval->str = strdup(text);
+	switch (perf_pmu__parse_check(text)) {
+		case KERNEL_PMU_EVENT_PREFIX:
+			return PE_PMU_EVENT_PRE;
+		case KERNEL_PMU_EVENT_SUFFIX:
+			return PE_PMU_EVENT_SUF;
+		case KERNEL_PMU_EVENT:
+			return PE_KERNEL_PMU_EVENT;
+		default:
+			return PE_NAME;
+	}
+}
+
 static int sym(yyscan_t scanner, int type, int config)
 {
 	YYSTYPE *yylval = parse_events_get_lval(scanner);
@@ -178,6 +196,16 @@ alignment-faults				{ return sym(yyscanner, PERF_TYPE_SOFTWARE, PERF_COUNT_SW_AL
 emulation-faults				{ return sym(yyscanner, PERF_TYPE_SOFTWARE, PERF_COUNT_SW_EMULATION_FAULTS); }
 dummy						{ return sym(yyscanner, PERF_TYPE_SOFTWARE, PERF_COUNT_SW_DUMMY); }
 
+	/*
+	 * We have to handle the kernel PMU event cycles-ct/cycles-t/mem-loads/mem-stores separately.
+	 * Because the prefix cycles is mixed up with cpu-cycles.
+	 * loads and stores are mixed up with cache event
+	 */
+cycles-ct					{ return str(yyscanner, PE_KERNEL_PMU_EVENT); }
+cycles-t					{ return str(yyscanner, PE_KERNEL_PMU_EVENT); }
+mem-loads					{ return str(yyscanner, PE_KERNEL_PMU_EVENT); }
+mem-stores					{ return str(yyscanner, PE_KERNEL_PMU_EVENT); }
+
 L1-dcache|l1-d|l1d|L1-data		|
 L1-icache|l1-i|l1i|L1-instruction	|
 LLC|L2					|
@@ -199,7 +227,7 @@ r{num_raw_hex}		{ return raw(yyscanner); }
 {num_hex}		{ return value(yyscanner, 16); }
 
 {modifier_event}	{ return str(yyscanner, PE_MODIFIER_EVENT); }
-{name}			{ return str(yyscanner, PE_NAME); }
+{name}			{ return pmu_str_check(yyscanner); }
 "/"			{ BEGIN(config); return '/'; }
 -			{ return '-'; }
 ,			{ BEGIN(event); return ','; }
diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-events.y
index 55fab6a..3f26c03 100644
--- a/tools/perf/util/parse-events.y
+++ b/tools/perf/util/parse-events.y
@@ -47,6 +47,7 @@ static inc_group_count(struct list_head *list,
 %token PE_NAME_CACHE_TYPE PE_NAME_CACHE_OP_RESULT
 %token PE_PREFIX_MEM PE_PREFIX_RAW PE_PREFIX_GROUP
 %token PE_ERROR
+%token PE_PMU_EVENT_PRE PE_PMU_EVENT_SUF PE_KERNEL_PMU_EVENT
 %type <num> PE_VALUE
 %type <num> PE_VALUE_SYM_HW
 %type <num> PE_VALUE_SYM_SW
@@ -58,6 +59,7 @@ static inc_group_count(struct list_head *list,
 %type <str> PE_MODIFIER_EVENT
 %type <str> PE_MODIFIER_BP
 %type <str> PE_EVENT_NAME
+%type <str> PE_PMU_EVENT_PRE PE_PMU_EVENT_SUF PE_KERNEL_PMU_EVENT
 %type <num> value_sym
 %type <head> event_config
 %type <term> event_term
@@ -220,6 +222,44 @@ PE_NAME '/' '/'
 	ABORT_ON(parse_events_add_pmu(list, &data->idx, $1, NULL));
 	$$ = list;
 }
+|
+PE_KERNEL_PMU_EVENT
+{
+	struct parse_events_evlist *data = _data;
+	struct list_head *head;
+	struct parse_events_term *term;
+	struct list_head *list;
+
+	ALLOC_LIST(head);
+	ABORT_ON(parse_events_term__num(&term, PARSE_EVENTS__TERM_TYPE_USER,
+					$1, 1));
+	list_add_tail(&term->list, head);
+
+	ALLOC_LIST(list);
+	ABORT_ON(parse_events_add_pmu(list, &data->idx, "cpu", head));
+	parse_events__free_terms(head);
+	$$ = list;
+}
+|
+PE_PMU_EVENT_PRE '-' PE_PMU_EVENT_SUF
+{
+	struct parse_events_evlist *data = _data;
+	struct list_head *head;
+	struct parse_events_term *term;
+	struct list_head *list;
+	char pmu_name[128];
+	snprintf(&pmu_name, 128, "%s-%s", $1, $3);
+
+	ALLOC_LIST(head);
+	ABORT_ON(parse_events_term__num(&term, PARSE_EVENTS__TERM_TYPE_USER,
+					&pmu_name, 1));
+	list_add_tail(&term->list, head);
+
+	ALLOC_LIST(list);
+	ABORT_ON(parse_events_add_pmu(list, &data->idx, "cpu", head));
+	parse_events__free_terms(head);
+	$$ = list;
+}
 
 value_sym:
 PE_VALUE_SYM_HW
-- 
1.8.3.2

