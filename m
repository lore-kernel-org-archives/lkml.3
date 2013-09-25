Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755799Ab3IYMvy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 08:51:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3245 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755772Ab3IYMvu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 08:51:50 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 19/21] perf tools: Carry term string value for symbols events
Date: Wed, 25 Sep 2013 14:50:45 +0200
Message-Id: <1380113447-17144-20-git-send-email-jolsa@redhat.com>
In-Reply-To: <1380113447-17144-1-git-send-email-jolsa@redhat.com>
References: <1380113447-17144-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently only the number interpretation of the event is
carried for 'value_sym' related events.

We need to have also string symbol representation for toggle
on/off term interface to match the proper event name.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/parse-events.l |  4 +++-
 tools/perf/util/parse-events.y | 28 ++++++++++++++++++++--------
 2 files changed, 23 insertions(+), 9 deletions(-)

diff --git a/tools/perf/util/parse-events.l b/tools/perf/util/parse-events.l
index 91346b7..560ca86 100644
--- a/tools/perf/util/parse-events.l
+++ b/tools/perf/util/parse-events.l
@@ -54,8 +54,10 @@ static int str(yyscan_t scanner, int token)
 static int sym(yyscan_t scanner, int type, int config)
 {
 	YYSTYPE *yylval = parse_events_get_lval(scanner);
+	char *text = parse_events_get_text(scanner);
 
-	yylval->num = (type << 16) + config;
+	yylval->sym.num = (type << 16) + config;
+	yylval->sym.str = strdup(text);
 	return type == PERF_TYPE_HARDWARE ? PE_VALUE_SYM_HW : PE_VALUE_SYM_SW;
 }
 
diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-events.y
index 1497a70..ca93b72 100644
--- a/tools/perf/util/parse-events.y
+++ b/tools/perf/util/parse-events.y
@@ -48,8 +48,8 @@ static inc_group_count(struct list_head *list,
 %token PE_PREFIX_MEM PE_PREFIX_RAW PE_PREFIX_GROUP
 %token PE_ERROR
 %type <num> PE_VALUE
-%type <num> PE_VALUE_SYM_HW
-%type <num> PE_VALUE_SYM_SW
+%type <sym> PE_VALUE_SYM_HW
+%type <sym> PE_VALUE_SYM_SW
 %type <num> PE_RAW
 %type <num> PE_TERM
 %type <str> PE_NAME
@@ -58,7 +58,7 @@ static inc_group_count(struct list_head *list,
 %type <str> PE_MODIFIER_EVENT
 %type <str> PE_MODIFIER_BP
 %type <str> PE_EVENT_NAME
-%type <num> value_sym
+%type <sym> value_sym
 %type <head> event_config_optional
 %type <head> event_config
 %type <term> event_term
@@ -80,8 +80,12 @@ static inc_group_count(struct list_head *list,
 
 %union
 {
-	char *str;
+	struct {
+		u64 num;
+		char *str;
+	} sym;
 	u64 num;
+	char *str;
 	struct list_head *head;
 	struct parse_events_term *term;
 }
@@ -235,8 +239,8 @@ value_sym event_config_optional
 	struct parse_events_evlist *data = _data;
 	struct list_head *list;
 	struct list_head *terms = $2;
-	int type = $1 >> 16;
-	int config = $1 & 255;
+	int type = $1.num >> 16;
+	int config = $1.num & 255;
 
 	ALLOC_LIST(list);
 	ABORT_ON(parse_events_add_numeric(list, &data->idx,
@@ -384,7 +388,7 @@ PE_NAME '=' PE_VALUE
 PE_NAME '=' PE_VALUE_SYM_HW
 {
 	struct parse_events_term *term;
-	int config = $3 & 255;
+	int config = $3.num & 255;
 
 	ABORT_ON(parse_events_term__sym_hw(&term, $1, config));
 	$$ = term;
@@ -402,7 +406,7 @@ PE_NAME
 PE_VALUE_SYM_HW
 {
 	struct parse_events_term *term;
-	int config = $1 & 255;
+	int config = $1.num & 255;
 
 	ABORT_ON(parse_events_term__sym_hw(&term, NULL, config));
 	$$ = term;
@@ -416,6 +420,14 @@ PE_TERM '=' PE_NAME
 	$$ = term;
 }
 |
+PE_TERM '=' value_sym
+{
+	struct parse_events__term *term;
+
+	ABORT_ON(parse_events_term__str(&term, (int)$1, NULL, $3.str));
+	$$ = term;
+}
+|
 PE_TERM '=' PE_VALUE
 {
 	struct parse_events_term *term;
-- 
1.7.11.7

