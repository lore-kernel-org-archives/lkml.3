Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761421Ab3EAPQj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 11:16:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42115 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752938Ab3EAPQb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 11:16:31 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ulrich Drepper <drepper@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Will Deacon <will.deacon@arm.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 2/8] perf tools: Factorize event parsing to be more general
Date: Wed,  1 May 2013 17:15:40 +0200
Message-Id: <1367421346-18257-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1367421346-18257-1-git-send-email-jolsa@redhat.com>
References: <1367421346-18257-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Making the event parsing processing more general so we
can plug in strings with special processing like formula
definition.

The formula changes are coming in following patches.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ulrich Drepper <drepper@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/util/parse-events.c | 21 ++++++++++++++++++
 tools/perf/util/parse-events.h | 17 +++++++++++++++
 tools/perf/util/parse-events.y | 48 +++++++++++++++++++++++++++++++-----------
 3 files changed, 74 insertions(+), 12 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 6c8bb0f..e8e9dc8 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -1238,3 +1238,24 @@ void parse_events__free_terms(struct list_head *terms)
 
 	free(terms);
 }
+
+int parse_events_config_process(struct parse_events_evlist *data,
+				struct list_head *head)
+{
+	struct parse_events_config *cfg, *h;
+
+	list_for_each_entry_safe(cfg, h, head, list) {
+		switch (cfg->type) {
+		case PARSE_EVENTS_CONFIG_EVENTS:
+			parse_events_update_lists(cfg->events, &data->list);
+			break;
+		default:
+			break;
+		}
+
+		list_del(&cfg->list);
+		free(cfg);
+	}
+
+	return 0;
+}
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index 8a48593..98810f1 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -71,6 +71,23 @@ struct parse_events_terms {
 	struct list_head *terms;
 };
 
+enum parse_events_config_type {
+	PARSE_EVENTS_CONFIG_EVENTS,
+};
+
+struct parse_events_config {
+	enum parse_events_config_type type;
+
+	union {
+		struct list_head *events;
+		void *val;
+	};
+
+	struct list_head list;
+};
+
+int parse_events_config_process(struct parse_events_evlist *data,
+				struct list_head *head);
 int parse_events__is_hardcoded_term(struct parse_events_term *term);
 int parse_events_term__num(struct parse_events_term **_term,
 			   int type_term, char *config, u64 num);
diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-events.y
index afc44c1..bae1879 100644
--- a/tools/perf/util/parse-events.y
+++ b/tools/perf/util/parse-events.y
@@ -30,6 +30,21 @@ static inc_group_count(struct list_head *list,
 		data->nr_groups++;
 }
 
+#define CONFIG(t, v) ({						\
+	struct parse_events_config *c = zalloc(sizeof(*c));	\
+	ABORT_ON(!c);						\
+	c->type = PARSE_EVENTS_CONFIG_ ## t;			\
+	c->val = v;						\
+	c;							\
+})
+
+#define HEAD() ({					\
+	struct list_head *h = zalloc(sizeof(*h));	\
+	ABORT_ON(!h);					\
+	INIT_LIST_HEAD(h);				\
+	h;						\
+})
+
 %}
 
 %token PE_START_EVENTS PE_START_TERMS
@@ -69,6 +84,7 @@ static inc_group_count(struct list_head *list,
 %type <head> group_def
 %type <head> group
 %type <head> groups
+%type <cfg> groups_config
 
 %union
 {
@@ -76,6 +92,7 @@ static inc_group_count(struct list_head *list,
 	u64 num;
 	struct list_head *head;
 	struct parse_events_term *term;
+	struct parse_events_config *cfg;
 }
 %%
 
@@ -88,31 +105,38 @@ start_events: groups
 {
 	struct parse_events_evlist *data = _data;
 
-	parse_events_update_lists($1, &data->list);
+	ABORT_ON(parse_events_config_process(data, $1));
 }
 
 groups:
-groups ',' group
+groups ',' groups_config
 {
-	struct list_head *list  = $1;
-	struct list_head *group = $3;
+	struct list_head *head = $1;
+	struct parse_events_config *cfg = $3;
 
-	parse_events_update_lists(group, list);
-	$$ = list;
+	list_add_tail(&cfg->list, head);
+	$$ = head;
 }
 |
-groups ',' event
+groups_config
 {
-	struct list_head *list  = $1;
-	struct list_head *event = $3;
+	struct list_head *head = HEAD();
+	struct parse_events_config *cfg = $1;
 
-	parse_events_update_lists(event, list);
-	$$ = list;
+	list_add_tail(&cfg->list, head);
+	$$ = head;
 }
-|
+
+groups_config:
 group
+{
+	$$ = CONFIG(EVENTS, $1);
+}
 |
 event
+{
+	$$ = CONFIG(EVENTS, $1);
+}
 
 group:
 group_def ':' PE_MODIFIER_EVENT
-- 
1.7.11.7

