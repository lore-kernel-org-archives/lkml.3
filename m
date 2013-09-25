Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940Ab3IYMxc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 08:53:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54395 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755700Ab3IYMvl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 08:51:41 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 16/21] perf tools: Allow numeric event to change name via name term
Date: Wed, 25 Sep 2013 14:50:42 +0200
Message-Id: <1380113447-17144-17-git-send-email-jolsa@redhat.com>
In-Reply-To: <1380113447-17144-1-git-send-email-jolsa@redhat.com>
References: <1380113447-17144-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allowing numeric event to change name via name term,
so it's possible to change following event name:

  $ ./perf stat  -e 'cycles:k,cycles/name=cycles_irq/k' kill
  usage: kill [ -s signal | -p ] [ -a ] pid ...
         kill -l [ signal ]

   Performance counter stats for 'kill':

             958,972 cycles:k                  #    0.000 GHz
             958,972 cycles_irq                #    0.000 GHz

         0.001047556 seconds time elapsed

It'll be useful for aliasing/distinguishing events for
on/off toggling terms.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/parse-events.c | 37 ++++++++++++++++++++-----------------
 1 file changed, 20 insertions(+), 17 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 9812531..1957849 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -583,6 +583,25 @@ do {								\
 #undef CHECK_TYPE_VAL
 }
 
+static int parse_events__is_name_term(struct parse_events_term *term)
+{
+	return term->type_term == PARSE_EVENTS__TERM_TYPE_NAME;
+}
+
+static char *pmu_event_name(struct list_head *head_terms)
+{
+	struct parse_events_term *term;
+
+	if (!head_terms)
+		return NULL;
+
+	list_for_each_entry(term, head_terms, list)
+		if (parse_events__is_name_term(term))
+			return term->val.str;
+
+	return NULL;
+}
+
 static int config_attr(struct perf_event_attr *attr,
 		       struct list_head *head, int fail)
 {
@@ -609,23 +628,7 @@ int parse_events_add_numeric(struct list_head *list, int *idx,
 	    config_attr(&attr, head_config, 1))
 		return -EINVAL;
 
-	return add_event(list, idx, &attr, NULL);
-}
-
-static int parse_events__is_name_term(struct parse_events_term *term)
-{
-	return term->type_term == PARSE_EVENTS__TERM_TYPE_NAME;
-}
-
-static char *pmu_event_name(struct list_head *head_terms)
-{
-	struct parse_events_term *term;
-
-	list_for_each_entry(term, head_terms, list)
-		if (parse_events__is_name_term(term))
-			return term->val.str;
-
-	return NULL;
+	return add_event(list, idx, &attr, pmu_event_name(terms));
 }
 
 int parse_events_add_pmu(struct list_head *list, int *idx,
-- 
1.7.11.7

