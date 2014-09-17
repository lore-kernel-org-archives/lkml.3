Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756389AbaIQSw1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 14:52:27 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:45090 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756295AbaIQSwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 14:52:23 -0400
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>, ak@linux.intel.com,
        Jiri Olsa <jolsa@redhat.com>, peterz@infradead.org, eranian@google.com,
        Paul Mackerras <paulus@samba.org>
Cc: dev@codyps.com, Michael Ellerman <michaele@au1.ibm.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>, hbabu@us.ibm.com,
        <linux-kernel@vger.kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v3 01/10] tools/perf: support parsing parameterized events
Date: Wed, 17 Sep 2014 11:51:54 -0700
Message-Id: <1410979923-7722-2-git-send-email-sukadev@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1410979923-7722-1-git-send-email-sukadev@linux.vnet.ibm.com>
References: <1410979923-7722-1-git-send-email-sukadev@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14091718-6688-0000-0000-000004E321D4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cody P Schafer <cody@linux.vnet.ibm.com>

Enable event specification like:

	pmu/event_name,param1=0x1,param2=0x4/

Assuming that

	/sys/bus/event_source/devices/pmu/events/event_name

Contains something like

	param2=foo,bar=1,param1=baz

Changelog[v6]:
	[Jiri Olsa] If the sysfs event file specifies 'param=val', make the
	usage 'hv_24x7/event,param=123/' rather than 'hv_24x7/event,val=123/'.
	[Sukadev Bhattiprolu] If verbose option is set, print help message
	if a required parameter is missing or invalid parameter is specified.


CC: Haren Myneni <hbabu@us.ibm.com>
CC: Cody P Schafer <dev@codyps.com>
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 tools/perf/util/parse-events.h |    1 +
 tools/perf/util/pmu.c          |   64 +++++++++++++++++++++++++++++++++-------
 2 files changed, 54 insertions(+), 11 deletions(-)

diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index df094b4..9d7d2d5 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -59,6 +59,7 @@ struct parse_events_term {
 	int type_val;
 	int type_term;
 	struct list_head list;
+	bool used;
 };
 
 struct parse_events_evlist {
diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index 9bf5827..8c7c4a1 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -504,30 +504,67 @@ static __u64 pmu_format_value(unsigned long *format, __u64 value)
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
+	list_for_each_entry(t, head_terms, list) {
+		if (t->type_val == PARSE_EVENTS__TERM_TYPE_NUM) {
+			if (!strcmp(t->config, term->config)) {
+				t->used = true;
+				*value = t->val.num;
+				return 0;
+			}
+		}
+	}
+
+	if (verbose)
+		printf("Required parameter '%s' not specified\n", term->config);
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
-	if (!format)
+	if (!format) {
+		if (verbose)
+			printf("Invalid event/parameter '%s'\n", term->config);
 		return -EINVAL;
+	}
 
 	switch (format->value) {
 	case PERF_PMU_FORMAT_VALUE_CONFIG:
@@ -544,11 +581,16 @@ static int pmu_config_term(struct list_head *formats,
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
 
@@ -559,7 +601,7 @@ int perf_pmu__config_terms(struct list_head *formats,
 	struct parse_events_term *term;
 
 	list_for_each_entry(term, head_terms, list)
-		if (pmu_config_term(formats, attr, term))
+		if (pmu_config_term(formats, attr, term, head_terms))
 			return -EINVAL;
 
 	return 0;
-- 
1.7.9.5

