Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882Ab3IYMwq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 08:52:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2217 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755743Ab3IYMvq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 08:51:46 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 18/21] perf tools: Rename term related parsing function/variable properly
Date: Wed, 25 Sep 2013 14:50:44 +0200
Message-Id: <1380113447-17144-19-git-send-email-jolsa@redhat.com>
In-Reply-To: <1380113447-17144-1-git-send-email-jolsa@redhat.com>
References: <1380113447-17144-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The config_attr_term name is more suitable for the function
as it configures perf_event_attr data using term.

Using more suitable name 'terms' for list head of terms,
instead of list 'head_config' name.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/parse-events.c | 22 +++++++++++-----------
 tools/perf/util/parse-events.h |  4 ++--
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 37b9cb7..899c59e 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -540,8 +540,8 @@ int parse_events_add_breakpoint(struct list_head *list, int *idx,
 	return add_event(list, idx, &attr, NULL);
 }
 
-static int config_term(struct perf_event_attr *attr,
-		       struct parse_events_term *term)
+static int config_attr_term(struct perf_event_attr *attr,
+			    struct parse_events_term *term)
 {
 #define CHECK_TYPE_VAL(type)					\
 do {								\
@@ -608,7 +608,7 @@ static int config_attr(struct perf_event_attr *attr,
 	struct parse_events_term *term;
 
 	list_for_each_entry(term, head, list)
-		if (config_term(attr, term) && fail)
+		if (config_attr_term(attr, term) && fail)
 			return -EINVAL;
 
 	return 0;
@@ -616,7 +616,7 @@ static int config_attr(struct perf_event_attr *attr,
 
 int parse_events_add_numeric(struct list_head *list, int *idx,
 			     u32 type, u64 config,
-			     struct list_head *head_config)
+			     struct list_head *terms)
 {
 	struct perf_event_attr attr;
 
@@ -624,15 +624,15 @@ int parse_events_add_numeric(struct list_head *list, int *idx,
 	attr.type = type;
 	attr.config = config;
 
-	if (head_config &&
-	    config_attr(&attr, head_config, 1))
+	if (terms &&
+	    config_attr(&attr, terms, 1))
 		return -EINVAL;
 
 	return add_event(list, idx, &attr, pmu_event_name(terms));
 }
 
 int parse_events_add_pmu(struct list_head *list, int *idx,
-			 char *name, struct list_head *head_config)
+			 char *name, struct list_head *terms)
 {
 	struct perf_event_attr attr;
 	struct perf_pmu *pmu;
@@ -643,19 +643,19 @@ int parse_events_add_pmu(struct list_head *list, int *idx,
 
 	memset(&attr, 0, sizeof(attr));
 
-	if (perf_pmu__check_alias(pmu, head_config))
+	if (perf_pmu__check_alias(pmu, terms))
 		return -EINVAL;
 
 	/*
 	 * Configure hardcoded terms first, no need to check
 	 * return value when called with fail == 0 ;)
 	 */
-	config_attr(&attr, head_config, 0);
+	config_attr(&attr, terms, 0);
 
-	if (perf_pmu__config(pmu, &attr, head_config))
+	if (perf_pmu__config(pmu, &attr, terms))
 		return -EINVAL;
 
-	return __add_event(list, idx, &attr, pmu_event_name(head_config),
+	return __add_event(list, idx, &attr, pmu_event_name(terms),
 			   pmu->cpus);
 }
 
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index f1cb4c4..a9db24f 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -89,13 +89,13 @@ int parse_events_add_tracepoint(struct list_head *list, int *idx,
 				char *sys, char *event);
 int parse_events_add_numeric(struct list_head *list, int *idx,
 			     u32 type, u64 config,
-			     struct list_head *head_config);
+			     struct list_head *terms);
 int parse_events_add_cache(struct list_head *list, int *idx,
 			   char *type, char *op_result1, char *op_result2);
 int parse_events_add_breakpoint(struct list_head *list, int *idx,
 				void *ptr, char *type);
 int parse_events_add_pmu(struct list_head *list, int *idx,
-			 char *pmu , struct list_head *head_config);
+			 char *pmu , struct list_head *terms);
 void parse_events__set_leader(char *name, struct list_head *list);
 void parse_events_update_lists(struct list_head *list_event,
 			       struct list_head *list_all);
-- 
1.7.11.7

