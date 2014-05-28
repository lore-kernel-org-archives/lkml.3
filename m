Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945AbaE1A1U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 20:27:20 -0400
Received: from mail-yh0-f51.google.com ([209.85.213.51]:42993 "EHLO
	mail-yh0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753481AbaE1A1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 20:27:18 -0400
From: Cody P Schafer <dev@codyps.com>
To: LKML <linux-kernel@vger.kernel.org>,
        Linux PPC <linuxppc-dev@lists.ozlabs.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Cody P Schafer <dev@codyps.com>, David Ahern <dsahern@gmail.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 07/16] tools/perf: support parsing parameterized events
Date: Tue, 27 May 2014 17:22:02 -0700
Message-Id: <1401236684-10579-8-git-send-email-dev@codyps.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1401236684-10579-1-git-send-email-dev@codyps.com>
References: <1401236684-10579-1-git-send-email-dev@codyps.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable event specification like:

	pmu/event_name,param1=0x1,param2=0x4/

Assuming that

	/sys/bus/event_source/devices/pmu/events/event_name

Contains something like

	bar=param2,foo=1,baz=param1

CC: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Signed-off-by: Cody P Schafer <dev@codyps.com>
---
 tools/perf/util/parse-events.h |  1 +
 tools/perf/util/pmu.c          | 55 ++++++++++++++++++++++++++++++++++--------
 2 files changed, 46 insertions(+), 10 deletions(-)

diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index f1cb4c4..1147e87 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -60,6 +60,7 @@ struct parse_events_term {
 	int type_val;
 	int type_term;
 	struct list_head list;
+	bool used;
 };
 
 struct parse_events_evlist {
diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index 906ae40..db53fac 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -504,27 +504,57 @@ static __u64 pmu_format_value(unsigned long *format, __u64 value)
 }
 
 /*
+ * Term is a string term, and might be a param-term. Try to look up it's value
+ * in the remaining terms.
+ * - We have a term like "base-or-format-term=param-term",
+ * - We need to find the value supplied for "param-term" (with param-term named
+ *   in a config string) later on in the term list.
+ */
+static int pmu_resolve_param_term(struct parse_events_term *term,
+				  struct list_head *head_terms,
+				  __u64 *value)
+{
+	struct parse_events_term *t;
+
+	list_for_each_entry(t, head_terms, list)
+		if (t->type_val == PARSE_EVENTS__TERM_TYPE_NUM) {
+			if (!strcmp(t->config, term->val.str)) {
+				t->used = true;
+				*value = t->val.num;
+				return 0;
+			}
+		}
+
+	return -1;
+}
+
+/*
  * Setup one of config[12] attr members based on the
  * user input data - term parameter.
  */
 static int pmu_config_term(struct list_head *formats,
 			   struct perf_event_attr *attr,
-			   struct parse_events_term *term)
+			   struct parse_events_term *term,
+			   struct list_head *head_terms)
 {
 	struct perf_pmu_format *format;
 	__u64 *vp;
+	__u64 val;
+
+	/*
+	 * If this is a parameter we've already used for parameterized-eval,
+	 * skip it in normal eval.
+	 */
+	if (term->used)
+		return 0;
 
 	/*
-	 * Support only for hardcoded and numnerial terms.
 	 * Hardcoded terms should be already in, so nothing
 	 * to be done for them.
 	 */
 	if (parse_events__is_hardcoded_term(term))
 		return 0;
 
-	if (term->type_val != PARSE_EVENTS__TERM_TYPE_NUM)
-		return -EINVAL;
-
 	format = pmu_find_format(formats, term->config);
 	if (!format)
 		return -EINVAL;
@@ -544,11 +574,16 @@ static int pmu_config_term(struct list_head *formats,
 	}
 
 	/*
-	 * XXX If we ever decide to go with string values for
-	 * non-hardcoded terms, here's the place to translate
-	 * them into value.
+	 * Either directly use a numeric term, or try to translate string terms
+	 * using event parameters.
 	 */
-	*vp |= pmu_format_value(format->bits, term->val.num);
+	if (term->type_val == PARSE_EVENTS__TERM_TYPE_NUM)
+		val = term->val.num;
+	else
+		if (pmu_resolve_param_term(term, head_terms, &val))
+			return -EINVAL;
+
+	*vp |= pmu_format_value(format->bits, val);
 	return 0;
 }
 
@@ -559,7 +594,7 @@ int perf_pmu__config_terms(struct list_head *formats,
 	struct parse_events_term *term;
 
 	list_for_each_entry(term, head_terms, list)
-		if (pmu_config_term(formats, attr, term))
+		if (pmu_config_term(formats, attr, term, head_terms))
 			return -EINVAL;
 
 	return 0;
-- 
1.9.3

