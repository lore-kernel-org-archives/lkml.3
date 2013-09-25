Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846Ab3IYMwT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 08:52:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61823 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755781Ab3IYMvx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 08:51:53 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 20/21] perf tools: Add support to parse event on/off toggle terms
Date: Wed, 25 Sep 2013 14:50:46 +0200
Message-Id: <1380113447-17144-21-git-send-email-jolsa@redhat.com>
In-Reply-To: <1380113447-17144-1-git-send-email-jolsa@redhat.com>
References: <1380113447-17144-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding parsing support for 'on' and 'off' terms within the
event syntax. We can now specify on/off terms like:

  -e 'cycles,irq_entry/on=cycles/,irq_exit/off=cycles/'

Only string value is accepted for both terms. The name
will be used in a search for toggled event.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evsel.c        |  1 +
 tools/perf/util/evsel.h        |  3 ++
 tools/perf/util/parse-events.c | 69 +++++++++++++++++++++++++++++++++++-------
 tools/perf/util/parse-events.h |  5 ++-
 tools/perf/util/parse-events.l |  2 ++
 tools/perf/util/parse-events.y |  6 ++--
 6 files changed, 71 insertions(+), 15 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 95590fe..3ed7947 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -820,6 +820,7 @@ void perf_evsel__delete(struct perf_evsel *evsel)
 	free(evsel->group_name);
 	if (evsel->tp_format)
 		pevent_free_format(evsel->tp_format);
+	free(evsel->toggle_name);
 	free(evsel->name);
 	free(evsel);
 }
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 4a7bdc7..e70415b 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -90,6 +90,9 @@ struct perf_evsel {
 	int			sample_read;
 	struct perf_evsel	*leader;
 	char			*group_name;
+	/* toggle event config */
+	char			toggle_flag;
+	char			*toggle_name;
 };
 
 #define hists_to_evsel(h) container_of(h, struct perf_evsel, hists)
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 899c59e..4e8243f 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -267,7 +267,42 @@ const char *event_type(int type)
 	return "unknown";
 }
 
+static int config_evsel_term(struct perf_evsel *evsel,
+			     struct parse_events_term *term)
+{
+	if (evsel->toggle_name)
+		return -EINVAL;
 
+	switch (term->type_term) {
+	case PARSE_EVENTS__TERM_TYPE_TOGGLE_ON:
+		evsel->toggle_flag = PERF_FLAG_TOGGLE_ON;
+		break;
+	case PARSE_EVENTS__TERM_TYPE_TOGGLE_OFF:
+		evsel->toggle_flag = PERF_FLAG_TOGGLE_OFF;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	evsel->toggle_name = strdup(term->val.str);
+	return 0;
+}
+
+static int config_evsel(struct perf_evsel *evsel,
+			struct list_head *head)
+{
+	struct parse_events_term *term;
+
+	list_for_each_entry(term, head, list) {
+		int ret;
+
+		ret = config_evsel_term(evsel, term);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
 
 static int __add_event(struct list_head *list, int *idx,
 		       struct perf_event_attr *attr,
@@ -374,7 +409,8 @@ int parse_events_add_cache(struct list_head *list, int *idx,
 }
 
 static int add_tracepoint(struct list_head *list, int *idx,
-			  char *sys_name, char *evt_name)
+			  char *sys_name, char *evt_name,
+			  struct list_head *terms)
 {
 	struct perf_evsel *evsel;
 
@@ -382,13 +418,20 @@ static int add_tracepoint(struct list_head *list, int *idx,
 	if (!evsel)
 		return -ENOMEM;
 
+	if (terms && config_evsel(evsel, terms)) {
+		perf_evsel__delete(evsel);
+		free(list);
+		return -EINVAL;
+	}
+
 	list_add_tail(&evsel->node, list);
 
 	return 0;
 }
 
 static int add_tracepoint_multi_event(struct list_head *list, int *idx,
-				      char *sys_name, char *evt_name)
+				      char *sys_name, char *evt_name,
+				      struct list_head *terms)
 {
 	char evt_path[MAXPATHLEN];
 	struct dirent *evt_ent;
@@ -412,7 +455,8 @@ static int add_tracepoint_multi_event(struct list_head *list, int *idx,
 		if (!strglobmatch(evt_ent->d_name, evt_name))
 			continue;
 
-		ret = add_tracepoint(list, idx, sys_name, evt_ent->d_name);
+		ret = add_tracepoint(list, idx, sys_name,
+				     evt_ent->d_name, terms);
 	}
 
 	closedir(evt_dir);
@@ -420,15 +464,17 @@ static int add_tracepoint_multi_event(struct list_head *list, int *idx,
 }
 
 static int add_tracepoint_event(struct list_head *list, int *idx,
-				char *sys_name, char *evt_name)
+				char *sys_name, char *evt_name,
+				struct list_head *terms)
 {
 	return strpbrk(evt_name, "*?") ?
-	       add_tracepoint_multi_event(list, idx, sys_name, evt_name) :
-	       add_tracepoint(list, idx, sys_name, evt_name);
+	       add_tracepoint_multi_event(list, idx, sys_name, evt_name, terms) :
+	       add_tracepoint(list, idx, sys_name, evt_name, terms);
 }
 
 static int add_tracepoint_multi_sys(struct list_head *list, int *idx,
-				    char *sys_name, char *evt_name)
+				    char *sys_name, char *evt_name,
+				    struct list_head *terms)
 {
 	struct dirent *events_ent;
 	DIR *events_dir;
@@ -452,7 +498,7 @@ static int add_tracepoint_multi_sys(struct list_head *list, int *idx,
 			continue;
 
 		ret = add_tracepoint_event(list, idx, events_ent->d_name,
-					   evt_name);
+					   evt_name, terms);
 	}
 
 	closedir(events_dir);
@@ -460,7 +506,8 @@ static int add_tracepoint_multi_sys(struct list_head *list, int *idx,
 }
 
 int parse_events_add_tracepoint(struct list_head *list, int *idx,
-				char *sys, char *event)
+				char *sys, char *event,
+				struct list_head *terms)
 {
 	int ret;
 
@@ -469,9 +516,9 @@ int parse_events_add_tracepoint(struct list_head *list, int *idx,
 		return ret;
 
 	if (strpbrk(sys, "*?"))
-		return add_tracepoint_multi_sys(list, idx, sys, event);
+		return add_tracepoint_multi_sys(list, idx, sys, event, terms);
 	else
-		return add_tracepoint_event(list, idx, sys, event);
+		return add_tracepoint_event(list, idx, sys, event, terms);
 }
 
 static int
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index a9db24f..8bd5995 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -49,6 +49,8 @@ enum {
 	PARSE_EVENTS__TERM_TYPE_NAME,
 	PARSE_EVENTS__TERM_TYPE_SAMPLE_PERIOD,
 	PARSE_EVENTS__TERM_TYPE_BRANCH_SAMPLE_TYPE,
+	PARSE_EVENTS__TERM_TYPE_TOGGLE_ON,
+	PARSE_EVENTS__TERM_TYPE_TOGGLE_OFF,
 };
 
 struct parse_events_term {
@@ -86,7 +88,8 @@ int parse_events__modifier_event(struct list_head *list, char *str, bool add);
 int parse_events__modifier_group(struct list_head *list, char *event_mod);
 int parse_events_name(struct list_head *list, char *name);
 int parse_events_add_tracepoint(struct list_head *list, int *idx,
-				char *sys, char *event);
+				char *sys, char *event,
+				struct list_head *terms);
 int parse_events_add_numeric(struct list_head *list, int *idx,
 			     u32 type, u64 config,
 			     struct list_head *terms);
diff --git a/tools/perf/util/parse-events.l b/tools/perf/util/parse-events.l
index 560ca86..afcc0d0 100644
--- a/tools/perf/util/parse-events.l
+++ b/tools/perf/util/parse-events.l
@@ -171,6 +171,8 @@ config2			{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_CONFIG2); }
 name			{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_NAME); }
 period			{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_SAMPLE_PERIOD); }
 branch_type		{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_BRANCH_SAMPLE_TYPE); }
+on			{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_TOGGLE_ON); }
+off			{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_TOGGLE_OFF); }
 ,			{ return ','; }
 "/"			{ BEGIN(INITIAL); return '/'; }
 {name_minus}		{ return str(yyscanner, PE_NAME); }
diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-events.y
index ca93b72..7692562 100644
--- a/tools/perf/util/parse-events.y
+++ b/tools/perf/util/parse-events.y
@@ -200,7 +200,7 @@ event_def: event_pmu |
 	   event_legacy_symbol |
 	   event_legacy_cache sep_dc |
 	   event_legacy_mem |
-	   event_legacy_tracepoint sep_dc |
+	   event_legacy_tracepoint |
 	   event_legacy_numeric sep_dc |
 	   event_legacy_raw sep_dc
 
@@ -305,13 +305,13 @@ PE_PREFIX_MEM PE_VALUE sep_dc
 }
 
 event_legacy_tracepoint:
-PE_NAME ':' PE_NAME
+PE_NAME ':' PE_NAME event_config_optional
 {
 	struct parse_events_evlist *data = _data;
 	struct list_head *list;
 
 	ALLOC_LIST(list);
-	ABORT_ON(parse_events_add_tracepoint(list, &data->idx, $1, $3));
+	ABORT_ON(parse_events_add_tracepoint(list, &data->idx, $1, $3, $4));
 	$$ = list;
 }
 
-- 
1.7.11.7

