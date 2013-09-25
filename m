Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902Ab3IYMwr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 08:52:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38634 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755668Ab3IYMvn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 08:51:43 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 17/21] perf tools: Add event_config_optional parsing rule
Date: Wed, 25 Sep 2013 14:50:43 +0200
Message-Id: <1380113447-17144-18-git-send-email-jolsa@redhat.com>
In-Reply-To: <1380113447-17144-1-git-send-email-jolsa@redhat.com>
References: <1380113447-17144-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding 'event_config_optional' parsing rule to omit
duplication code in event_legacy_symbol for /config/no config/
processing.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/parse-events.c |  3 +++
 tools/perf/util/parse-events.y | 34 ++++++++++++++++++----------------
 2 files changed, 21 insertions(+), 16 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 1957849..37b9cb7 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -1328,6 +1328,9 @@ void parse_events__free_terms(struct list_head *terms)
 {
 	struct parse_events_term *term, *h;
 
+	if (!terms)
+		return;
+
 	list_for_each_entry_safe(term, h, terms, list)
 		free(term);
 }
diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-events.y
index 4eb67ec..1497a70 100644
--- a/tools/perf/util/parse-events.y
+++ b/tools/perf/util/parse-events.y
@@ -59,6 +59,7 @@ static inc_group_count(struct list_head *list,
 %type <str> PE_MODIFIER_BP
 %type <str> PE_EVENT_NAME
 %type <num> value_sym
+%type <head> event_config_optional
 %type <head> event_config
 %type <term> event_term
 %type <head> event_pmu
@@ -199,6 +200,17 @@ event_def: event_pmu |
 	   event_legacy_numeric sep_dc |
 	   event_legacy_raw sep_dc
 
+event_config_optional:
+'/' event_config '/'
+{
+	$$ = $2;
+}
+|
+sep_slash_dc
+{
+	$$ = NULL;
+}
+
 event_pmu:
 PE_NAME '/' event_config '/'
 {
@@ -208,6 +220,7 @@ PE_NAME '/' event_config '/'
 	ALLOC_LIST(list);
 	ABORT_ON(parse_events_add_pmu(list, &data->idx, $1, $3));
 	parse_events__free_terms($3);
+	free($3);
 	$$ = list;
 }
 
@@ -217,30 +230,19 @@ PE_VALUE_SYM_HW
 PE_VALUE_SYM_SW
 
 event_legacy_symbol:
-value_sym '/' event_config '/'
-{
-	struct parse_events_evlist *data = _data;
-	struct list_head *list;
-	int type = $1 >> 16;
-	int config = $1 & 255;
-
-	ALLOC_LIST(list);
-	ABORT_ON(parse_events_add_numeric(list, &data->idx,
-					  type, config, $3));
-	parse_events__free_terms($3);
-	$$ = list;
-}
-|
-value_sym sep_slash_dc
+value_sym event_config_optional
 {
 	struct parse_events_evlist *data = _data;
 	struct list_head *list;
+	struct list_head *terms = $2;
 	int type = $1 >> 16;
 	int config = $1 & 255;
 
 	ALLOC_LIST(list);
 	ABORT_ON(parse_events_add_numeric(list, &data->idx,
-					  type, config, NULL));
+					  type, config, terms));
+	parse_events__free_terms(terms);
+	free(terms);
 	$$ = list;
 }
 
-- 
1.7.11.7

