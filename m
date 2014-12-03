Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751375AbaLCCKF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 21:10:05 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:39238 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975AbaLCCKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 21:10:01 -0500
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Michael Ellerman <michaele@au1.ibm.com>,
        Paul Mackerras <paulus@samba.org>
Cc: dev@codyps.com, peterz@infradead.org, hbabu@us.ibm.com,
        <linux-kernel@vger.kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v5 1/4] tools/perf: support parsing parameterized events
Date: Tue,  2 Dec 2014 18:09:35 -0800
Message-Id: <1417572578-9051-2-git-send-email-sukadev@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1417572578-9051-1-git-send-email-sukadev@linux.vnet.ibm.com>
References: <1417572578-9051-1-git-send-email-sukadev@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120302-0033-0000-0000-000002DF4400
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cody P Schafer <cody@linux.vnet.ibm.com>

Enable event specification like:

	pmu/event_name,param1=0x1,param2=0x4/

Assuming that

	/sys/bus/event_source/devices/pmu/events/event_name

Contains something like

	param2=$foo,bar=1,param1=$baz

Changelog[v4]:
	[Jiri Olsa] Merge to recent perf-core and fix a small conflict.

Changelog[v3]:
	[Jiri Olsa] If the sysfs event file specifies 'param=val', make the
	usage 'hv_24x7/event,param=123/' rather than 'hv_24x7/event,val=123/'.

CC: Haren Myneni <hbabu@us.ibm.com>
CC: Cody P Schafer <dev@codyps.com>
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>

Conflicts:
	tools/perf/util/pmu.c
---
 tools/perf/util/parse-events.h |  1 +
 tools/perf/util/pmu.c          | 65 +++++++++++++++++++++++++++++++++++-------
 2 files changed, 55 insertions(+), 11 deletions(-)

diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index db2cf78..ca226ce 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -71,6 +71,7 @@ struct parse_events_term {
 	int type_val;
 	int type_term;
 	struct list_head list;
+	bool used;
 };
 
 struct parse_events_evlist {
diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index 5c9c494..cb516dd 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -551,31 +551,68 @@ static void pmu_format_value(unsigned long *format, __u64 value, __u64 *v,
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
 			   struct parse_events_term *term,
+			   struct list_head *head_terms,
 			   bool zero)
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
@@ -592,11 +629,16 @@ static int pmu_config_term(struct list_head *formats,
 	}
 
 	/*
-	 * XXX If we ever decide to go with string values for
-	 * non-hardcoded terms, here's the place to translate
-	 * them into value.
+	 * Either directly use a numeric term, or try to translate string terms
+	 * using event parameters.
 	 */
-	pmu_format_value(format->bits, term->val.num, vp, zero);
+	if (term->type_val == PARSE_EVENTS__TERM_TYPE_NUM)
+		val = term->val.num;
+	else
+		if (pmu_resolve_param_term(term, head_terms, &val))
+			return -EINVAL;
+
+	pmu_format_value(format->bits, val, vp, zero);
 	return 0;
 }
 
@@ -607,9 +649,10 @@ int perf_pmu__config_terms(struct list_head *formats,
 {
 	struct parse_events_term *term;
 
-	list_for_each_entry(term, head_terms, list)
-		if (pmu_config_term(formats, attr, term, zero))
+	list_for_each_entry(term, head_terms, list) {
+		if (pmu_config_term(formats, attr, term, head_terms, zero))
 			return -EINVAL;
+	}
 
 	return 0;
 }
-- 
1.8.3.1

