Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751369AbaJPFXH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 01:23:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33485 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766AbaJPFXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 01:23:04 -0400
Date: Wed, 15 Oct 2014 22:22:52 -0700
From: tip-bot for Kan Liang <tipbot@zytor.com>
Message-ID: <tip-ba32a4511c65e41958384d2f7a046a6ec6e151e5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, jolsa@redhat.com,
        acme@redhat.com, mingo@kernel.org, ak@linux.intel.com,
        kan.liang@intel.com, tglx@linutronix.de
Reply-To: ak@linux.intel.com, tglx@linutronix.de, kan.liang@intel.com,
        mingo@kernel.org, acme@redhat.com, hpa@zytor.com, jolsa@redhat.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <1412694532-23391-4-git-send-email-kan.liang@intel.com>
References: <1412694532-23391-4-git-send-email-kan.liang@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools:
  Add support to new style format of kernel PMU event
Git-Commit-ID: ba32a4511c65e41958384d2f7a046a6ec6e151e5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ba32a4511c65e41958384d2f7a046a6ec6e151e5
Gitweb:     http://git.kernel.org/tip/ba32a4511c65e41958384d2f7a046a6ec6e151e5
Author:     Kan Liang <kan.liang@intel.com>
AuthorDate: Tue, 7 Oct 2014 11:08:51 -0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 15 Oct 2014 16:05:45 -0300

perf tools: Add support to new style format of kernel PMU event

Add new rules for kernel PMU event.

Currently, the patch only want to handle the PMU event name as "a-b" and
"a".

event_pmu:
PE_KERNEL_PMU_EVENT sep_dc
|
PE_PMU_EVENT_PRE '-' PE_PMU_EVENT_SUF sep_dc

PE_KERNEL_PMU_EVENT token is for
cycles-ct/cycles-t/mem-loads/mem-stores.

The prefix cycles is mixed up with cpu-cycles.  loads and stores are
mixed up with cache event So they have to be hardcode in lex.

PE_PMU_EVENT_PRE and PE_PMU_EVENT_SUF tokens are for other PMU events.

The lex looks generic identifier up in the table and return the matched
token. If there is no match, generic PE_NAME token will be return.

Using the rules, kernel PMU event could use new style format without //

so you can use:

  perf record -e mem-loads ...

instead of:

  perf record -e cpu/mem-loads/

Signed-off-by: Kan Liang <kan.liang@intel.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/r/1412694532-23391-4-git-send-email-kan.liang@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/parse-events.l | 30 +++++++++++++++++++++++++++++-
 tools/perf/util/parse-events.y | 40 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 69 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/parse-events.l b/tools/perf/util/parse-events.l
index 3432995..906630b 100644
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
+		case PMU_EVENT_SYMBOL_PREFIX:
+			return PE_PMU_EVENT_PRE;
+		case PMU_EVENT_SYMBOL_SUFFIX:
+			return PE_PMU_EVENT_SUF;
+		case PMU_EVENT_SYMBOL:
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
index 55fab6a..93c4c9f 100644
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
+PE_KERNEL_PMU_EVENT sep_dc
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
+PE_PMU_EVENT_PRE '-' PE_PMU_EVENT_SUF sep_dc
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
