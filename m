Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539Ab3HVOoj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 10:44:39 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:63893 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411Ab3HVOoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 10:44:34 -0400
From: Robert Richter <rric@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Jiri Olsa <jolsa@redhat.com>,
        linux-kernel@vger.kernel.org,
        Robert Richter <robert.richter@linaro.org>,
        Robert Richter <rric@kernel.org>
Subject: [PATCH resent 2/4] perf tools: Modify event parser to update event attribute by index
Date: Thu, 22 Aug 2013 16:44:03 +0200
Message-Id: <1377182645-12922-3-git-send-email-rric@kernel.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1377182645-12922-1-git-send-email-rric@kernel.org>
References: <1377182645-12922-1-git-send-email-rric@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <robert.richter@linaro.org>

In a later patch we want to introduce a syntax that allows updating
attribute fields by an index pointing to a certain u64 entry of struct
perf_event_attr. We need this to expose any event via sysfs that is
available in the system where especially flag fields need to be set.

Reworking the event parser to use an attribute index. This is done by
introducing type PARSE_EVENTS__TERM_TYPE_ATTR for all numeric values
to be added to the event attribute fields. We use an index to specify
the corresponding u64 attr value.

Signed-off-by: Robert Richter <robert.richter@linaro.org>
Signed-off-by: Robert Richter <rric@kernel.org>
---
 tools/perf/tests/parse-events.c | 12 ++++++---
 tools/perf/util/parse-events.c  | 59 +++++++++++++++++++----------------------
 tools/perf/util/parse-events.h  | 12 ++++-----
 tools/perf/util/parse-events.l  | 18 ++++++-------
 tools/perf/util/parse-events.y  | 24 ++++++++++-------
 5 files changed, 65 insertions(+), 60 deletions(-)

diff --git a/tools/perf/tests/parse-events.c b/tools/perf/tests/parse-events.c
index 48114d1..0f6a4a7 100644
--- a/tools/perf/tests/parse-events.c
+++ b/tools/perf/tests/parse-events.c
@@ -464,7 +464,9 @@ static int test__checkterms_simple(struct list_head *terms)
 	/* config=10 */
 	term = list_entry(terms->next, struct parse_events_term, list);
 	TEST_ASSERT_VAL("wrong type term",
-			term->type_term == PARSE_EVENTS__TERM_TYPE_CONFIG);
+			term->type_term == PARSE_EVENTS__TERM_TYPE_ATTR);
+	TEST_ASSERT_VAL("wrong type idx",
+			term->idx == 1);
 	TEST_ASSERT_VAL("wrong type val",
 			term->type_val == PARSE_EVENTS__TERM_TYPE_NUM);
 	TEST_ASSERT_VAL("wrong val", term->val.num == 10);
@@ -473,7 +475,9 @@ static int test__checkterms_simple(struct list_head *terms)
 	/* config1 */
 	term = list_entry(term->list.next, struct parse_events_term, list);
 	TEST_ASSERT_VAL("wrong type term",
-			term->type_term == PARSE_EVENTS__TERM_TYPE_CONFIG1);
+			term->type_term == PARSE_EVENTS__TERM_TYPE_ATTR);
+	TEST_ASSERT_VAL("wrong type idx",
+			term->idx == 7);
 	TEST_ASSERT_VAL("wrong type val",
 			term->type_val == PARSE_EVENTS__TERM_TYPE_NUM);
 	TEST_ASSERT_VAL("wrong val", term->val.num == 1);
@@ -482,7 +486,9 @@ static int test__checkterms_simple(struct list_head *terms)
 	/* config2=3 */
 	term = list_entry(term->list.next, struct parse_events_term, list);
 	TEST_ASSERT_VAL("wrong type term",
-			term->type_term == PARSE_EVENTS__TERM_TYPE_CONFIG2);
+			term->type_term == PARSE_EVENTS__TERM_TYPE_ATTR);
+	TEST_ASSERT_VAL("wrong type idx",
+			term->idx == 8);
 	TEST_ASSERT_VAL("wrong type val",
 			term->type_val == PARSE_EVENTS__TERM_TYPE_NUM);
 	TEST_ASSERT_VAL("wrong val", term->val.num == 3);
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 9cba923..0d10a0a 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -535,6 +535,19 @@ int parse_events_add_breakpoint(struct list_head *list, int *idx,
 	return add_event(list, idx, &attr, NULL);
 }
 
+int parse_events__set_attr(struct perf_event_attr *__attr, u64 idx, u64 val)
+{
+	__u64 *attr = (__u64 *)__attr;
+
+	if (idx * sizeof(*attr) >= sizeof(*__attr))
+		return -EINVAL;
+
+	attr += idx;
+	*attr |= val;
+
+	return 0;
+}
+
 static int config_term(struct perf_event_attr *attr,
 		       struct parse_events_term *term)
 {
@@ -545,36 +558,17 @@ do {								\
 } while (0)
 
 	switch (term->type_term) {
-	case PARSE_EVENTS__TERM_TYPE_CONFIG:
+	case PARSE_EVENTS__TERM_TYPE_ATTR:
 		CHECK_TYPE_VAL(NUM);
-		attr->config = term->val.num;
-		break;
-	case PARSE_EVENTS__TERM_TYPE_CONFIG1:
-		CHECK_TYPE_VAL(NUM);
-		attr->config1 = term->val.num;
-		break;
-	case PARSE_EVENTS__TERM_TYPE_CONFIG2:
-		CHECK_TYPE_VAL(NUM);
-		attr->config2 = term->val.num;
-		break;
-	case PARSE_EVENTS__TERM_TYPE_SAMPLE_PERIOD:
-		CHECK_TYPE_VAL(NUM);
-		attr->sample_period = term->val.num;
-		break;
-	case PARSE_EVENTS__TERM_TYPE_BRANCH_SAMPLE_TYPE:
-		/*
-		 * TODO uncomment when the field is available
-		 * attr->branch_sample_type = term->val.num;
-		 */
-		break;
+		return parse_events__set_attr(attr, term->idx, term->val.num);
 	case PARSE_EVENTS__TERM_TYPE_NAME:
 		CHECK_TYPE_VAL(STR);
-		break;
+		return 0;
 	default:
-		return -EINVAL;
+		break;
 	}
 
-	return 0;
+	return -EINVAL;
 #undef CHECK_TYPE_VAL
 }
 
@@ -1212,7 +1206,7 @@ int parse_events__is_hardcoded_term(struct parse_events_term *term)
 
 static int new_term(struct parse_events_term **_term, int type_val,
 		    int type_term, char *config,
-		    char *str, u64 num)
+		    char *str, u64 num, u64 idx)
 {
 	struct parse_events_term *term;
 
@@ -1223,7 +1217,8 @@ static int new_term(struct parse_events_term **_term, int type_val,
 	INIT_LIST_HEAD(&term->list);
 	term->type_val  = type_val;
 	term->type_term = type_term;
-	term->config = config;
+	term->config	= config;
+	term->idx	= idx;
 
 	switch (type_val) {
 	case PARSE_EVENTS__TERM_TYPE_NUM:
@@ -1242,17 +1237,17 @@ static int new_term(struct parse_events_term **_term, int type_val,
 }
 
 int parse_events_term__num(struct parse_events_term **term,
-			   int type_term, char *config, u64 num)
+			   int type_term, char *config, u64 num, u64 idx)
 {
 	return new_term(term, PARSE_EVENTS__TERM_TYPE_NUM, type_term,
-			config, NULL, num);
+			config, NULL, num, idx);
 }
 
 int parse_events_term__str(struct parse_events_term **term,
 			   int type_term, char *config, char *str)
 {
 	return new_term(term, PARSE_EVENTS__TERM_TYPE_STR, type_term,
-			config, str, 0);
+			config, str, 0, 0);
 }
 
 int parse_events_term__sym_hw(struct parse_events_term **term,
@@ -1266,18 +1261,18 @@ int parse_events_term__sym_hw(struct parse_events_term **term,
 	if (config)
 		return new_term(term, PARSE_EVENTS__TERM_TYPE_STR,
 				PARSE_EVENTS__TERM_TYPE_USER, config,
-				(char *) sym->symbol, 0);
+				(char *) sym->symbol, 0, 0);
 	else
 		return new_term(term, PARSE_EVENTS__TERM_TYPE_STR,
 				PARSE_EVENTS__TERM_TYPE_USER,
-				(char *) "event", (char *) sym->symbol, 0);
+				(char *) "event", (char *) sym->symbol, 0, 0);
 }
 
 int parse_events_term__clone(struct parse_events_term **new,
 			     struct parse_events_term *term)
 {
 	return new_term(new, term->type_val, term->type_term, term->config,
-			term->val.str, term->val.num);
+			term->val.str, term->val.num, term->idx);
 }
 
 void parse_events__free_terms(struct list_head *terms)
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index f1cb4c4..61bbe88 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -35,6 +35,8 @@ extern int parse_events_terms(struct list_head *terms, const char *str);
 extern int parse_filter(const struct option *opt, const char *str, int unset);
 
 #define EVENTS_HELP_MAX (128*1024)
+#define PERF_ATTR_IDX(MEMBER) \
+	(offsetof(struct perf_event_attr, MEMBER) / sizeof(__u64))
 
 enum {
 	PARSE_EVENTS__TERM_TYPE_NUM,
@@ -43,12 +45,8 @@ enum {
 
 enum {
 	PARSE_EVENTS__TERM_TYPE_USER,
-	PARSE_EVENTS__TERM_TYPE_CONFIG,
-	PARSE_EVENTS__TERM_TYPE_CONFIG1,
-	PARSE_EVENTS__TERM_TYPE_CONFIG2,
+	PARSE_EVENTS__TERM_TYPE_ATTR,
 	PARSE_EVENTS__TERM_TYPE_NAME,
-	PARSE_EVENTS__TERM_TYPE_SAMPLE_PERIOD,
-	PARSE_EVENTS__TERM_TYPE_BRANCH_SAMPLE_TYPE,
 };
 
 struct parse_events_term {
@@ -59,6 +57,7 @@ struct parse_events_term {
 	} val;
 	int type_val;
 	int type_term;
+	u64 idx;
 	struct list_head list;
 };
 
@@ -74,7 +73,7 @@ struct parse_events_terms {
 
 int parse_events__is_hardcoded_term(struct parse_events_term *term);
 int parse_events_term__num(struct parse_events_term **_term,
-			   int type_term, char *config, u64 num);
+			   int type_term, char *config, u64 num, u64 idx);
 int parse_events_term__str(struct parse_events_term **_term,
 			   int type_term, char *config, char *str);
 int parse_events_term__sym_hw(struct parse_events_term **term,
@@ -97,6 +96,7 @@ int parse_events_add_breakpoint(struct list_head *list, int *idx,
 int parse_events_add_pmu(struct list_head *list, int *idx,
 			 char *pmu , struct list_head *head_config);
 void parse_events__set_leader(char *name, struct list_head *list);
+int parse_events__set_attr(struct perf_event_attr *__attr, u64 idx, u64 val);
 void parse_events_update_lists(struct list_head *list_event,
 			       struct list_head *list_all);
 void parse_events_error(void *data, void *scanner, char const *msg);
diff --git a/tools/perf/util/parse-events.l b/tools/perf/util/parse-events.l
index 435b4e5..a2f2f90 100644
--- a/tools/perf/util/parse-events.l
+++ b/tools/perf/util/parse-events.l
@@ -59,12 +59,12 @@ static int sym(yyscan_t scanner, int type, int config)
 	return type == PERF_TYPE_HARDWARE ? PE_VALUE_SYM_HW : PE_VALUE_SYM_SW;
 }
 
-static int term(yyscan_t scanner, int type)
+static int attr(yyscan_t scanner, u64 idx)
 {
 	YYSTYPE *yylval = parse_events_get_lval(scanner);
 
-	yylval->num = type;
-	return PE_TERM;
+	yylval->num = idx;
+	return PE_TERM_ATTR;
 }
 
 %}
@@ -162,12 +162,12 @@ refs|Reference|ops|access		|
 misses|miss				{ return str(yyscanner, PE_NAME_CACHE_OP_RESULT); }
 
 <cond_config>{
-config			{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_CONFIG); }
-config1			{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_CONFIG1); }
-config2			{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_CONFIG2); }
-name			{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_NAME); }
-period			{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_SAMPLE_PERIOD); }
-branch_type		{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_BRANCH_SAMPLE_TYPE); }
+config			{ return attr(yyscanner, PERF_ATTR_IDX(config)); }
+config1			{ return attr(yyscanner, PERF_ATTR_IDX(config1)); }
+config2			{ return attr(yyscanner, PERF_ATTR_IDX(config2)); }
+period			{ return attr(yyscanner, PERF_ATTR_IDX(sample_period)); }
+branch_type		{ return attr(yyscanner, PERF_ATTR_IDX(branch_sample_type)); }
+name			{ return PE_TERM_NAME; }
 ,			{ return ','; }
 "/"			{ BEGIN(INITIAL); return '/'; }
 {name_minus}		{ return str(yyscanner, PE_NAME); }
diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-events.y
index 4eb67ec..2bd285e 100644
--- a/tools/perf/util/parse-events.y
+++ b/tools/perf/util/parse-events.y
@@ -40,7 +40,8 @@ static inc_group_count(struct list_head *list,
 %}
 
 %token PE_START_EVENTS PE_START_TERMS
-%token PE_VALUE PE_VALUE_SYM_HW PE_VALUE_SYM_SW PE_RAW PE_TERM
+%token PE_VALUE PE_VALUE_SYM_HW PE_VALUE_SYM_SW PE_RAW
+%token PE_TERM_NAME PE_TERM_ATTR
 %token PE_EVENT_NAME
 %token PE_NAME
 %token PE_MODIFIER_EVENT PE_MODIFIER_BP
@@ -51,7 +52,7 @@ static inc_group_count(struct list_head *list,
 %type <num> PE_VALUE_SYM_HW
 %type <num> PE_VALUE_SYM_SW
 %type <num> PE_RAW
-%type <num> PE_TERM
+%type <num> PE_TERM_ATTR
 %type <str> PE_NAME
 %type <str> PE_NAME_CACHE_TYPE
 %type <str> PE_NAME_CACHE_OP_RESULT
@@ -375,7 +376,7 @@ PE_NAME '=' PE_VALUE
 	struct parse_events_term *term;
 
 	ABORT_ON(parse_events_term__num(&term, PARSE_EVENTS__TERM_TYPE_USER,
-					$1, $3));
+					$1, $3, 0));
 	$$ = term;
 }
 |
@@ -393,7 +394,7 @@ PE_NAME
 	struct parse_events_term *term;
 
 	ABORT_ON(parse_events_term__num(&term, PARSE_EVENTS__TERM_TYPE_USER,
-					$1, 1));
+					$1, 1, 0));
 	$$ = term;
 }
 |
@@ -406,27 +407,30 @@ PE_VALUE_SYM_HW
 	$$ = term;
 }
 |
-PE_TERM '=' PE_NAME
+PE_TERM_NAME '=' PE_NAME
 {
 	struct parse_events_term *term;
 
-	ABORT_ON(parse_events_term__str(&term, (int)$1, NULL, $3));
+	ABORT_ON(parse_events_term__str(&term, PARSE_EVENTS__TERM_TYPE_NAME,
+					NULL, $3));
 	$$ = term;
 }
 |
-PE_TERM '=' PE_VALUE
+PE_TERM_ATTR '=' PE_VALUE
 {
 	struct parse_events_term *term;
 
-	ABORT_ON(parse_events_term__num(&term, (int)$1, NULL, $3));
+	ABORT_ON(parse_events_term__num(&term, PARSE_EVENTS__TERM_TYPE_ATTR,
+					NULL, $3, $1));
 	$$ = term;
 }
 |
-PE_TERM
+PE_TERM_ATTR
 {
 	struct parse_events_term *term;
 
-	ABORT_ON(parse_events_term__num(&term, (int)$1, NULL, 1));
+	ABORT_ON(parse_events_term__num(&term, PARSE_EVENTS__TERM_TYPE_ATTR,
+					NULL, 1, $1));
 	$$ = term;
 }
 
-- 
1.8.3.2

