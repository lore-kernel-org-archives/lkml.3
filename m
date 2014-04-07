Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548AbaDGPGb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 11:06:31 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:58803 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755333AbaDGPFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 11:05:30 -0400
From: Jean Pihet <jean.pihet@linaro.org>
To: Borislav Petkov <bp@alien8.de>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>
Cc: Robert Richter <robert.richter@linaro.org>,
        Jean Pihet <jean.pihet@linaro.org>
Subject: [PATCH 15/16] perf tools: Add attr<num> syntax to event parser
Date: Mon,  7 Apr 2014 17:04:37 +0200
Message-Id: <1396883078-25320-16-git-send-email-jean.pihet@linaro.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1396883078-25320-1-git-send-email-jean.pihet@linaro.org>
References: <1396883078-25320-1-git-send-email-jean.pihet@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <robert.richter@linaro.org>

The event parser is limited to update only a subset of all fields in
struct perf_event_attr (config*, period, branch_type). We are not able
to set other attr fields, esp. flags.

Introducing a new syntax to set any field of the event attribute by
using an index to the u64 value to be used within struct
perf_event_attr. The new syntax attr<num> is similar to config<num>,
but <num> specifies the index to be used. E.g. attr5:24 sets bit 24 of
the flag field of attr.

The persistent event implementation is a use case of the above. In
this case sysfs provides:

 /sys/bus/event_source/devices/persistent/events/mce_record:persistent,config=106
 /sys/bus/event_source/devices/persistent/format/persistent:attr5:24

Persistent events are exposed via sysfs and need to set the persistent
flag (bit 24 of the flag field). With the sysfs entry above we are
able to define the persistent flag format and then may setup a
mce_record event with that flag set.

In general we are now flexible to describe with sysfs any event to be
setup by perf tools.

Signed-off-by: Robert Richter <robert.richter@linaro.org>
Signed-off-by: Robert Richter <rric@kernel.org>
Signed-off-by: Jean Pihet <jean.pihet@linaro.org>
---
 tools/perf/util/parse-events.l | 14 ++++++++++++++
 tools/perf/util/pmu.c          | 32 ++++++--------------------------
 tools/perf/util/pmu.h          |  9 ++-------
 tools/perf/util/pmu.l          |  1 +
 tools/perf/util/pmu.y          | 18 ++++++++++++++----
 5 files changed, 37 insertions(+), 37 deletions(-)

diff --git a/tools/perf/util/parse-events.l b/tools/perf/util/parse-events.l
index 8ef3f6c..707ce83 100644
--- a/tools/perf/util/parse-events.l
+++ b/tools/perf/util/parse-events.l
@@ -67,6 +67,19 @@ static int attr(yyscan_t scanner, u64 idx)
 	return PE_TERM_ATTR;
 }
 
+static int attr_parse(yyscan_t scanner)
+{
+	YYSTYPE *yylval = parse_events_get_lval(scanner);
+	char *text = parse_events_get_text(scanner);
+
+	errno = 0;
+	yylval->num = strtoull(text + 4, NULL, 10);
+	if (errno)
+		return PE_ERROR;
+
+	return PE_TERM_ATTR;
+}
+
 %}
 
 %x cond_mem
@@ -127,6 +140,7 @@ modifier_bp	[rwx]{1,3}
 }
 
 <cond_config>{
+attr[0-9]*		{ return attr_parse(yyscanner); }
 config			{ return attr(yyscanner, PERF_ATTR_IDX(config)); }
 config1			{ return attr(yyscanner, PERF_ATTR_IDX(config1)); }
 config2			{ return attr(yyscanner, PERF_ATTR_IDX(config2)); }
diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index 00a7dcb..d36d750 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -21,8 +21,8 @@ struct perf_pmu_alias {
 };
 
 struct perf_pmu_format {
-	char *name;
-	int value;
+	char	*name;
+	u64	idx;
 	DECLARE_BITMAP(bits, PERF_PMU_FORMAT_BITS);
 	struct list_head list;
 };
@@ -512,7 +512,6 @@ static int pmu_config_term(struct list_head *formats,
 			   struct parse_events_term *term)
 {
 	struct perf_pmu_format *format;
-	__u64 *vp;
 
 	/*
 	 * Support only for hardcoded and numnerial terms.
@@ -529,27 +528,8 @@ static int pmu_config_term(struct list_head *formats,
 	if (!format)
 		return -EINVAL;
 
-	switch (format->value) {
-	case PERF_PMU_FORMAT_VALUE_CONFIG:
-		vp = &attr->config;
-		break;
-	case PERF_PMU_FORMAT_VALUE_CONFIG1:
-		vp = &attr->config1;
-		break;
-	case PERF_PMU_FORMAT_VALUE_CONFIG2:
-		vp = &attr->config2;
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	/*
-	 * XXX If we ever decide to go with string values for
-	 * non-hardcoded terms, here's the place to translate
-	 * them into value.
-	 */
-	*vp |= pmu_format_value(format->bits, term->val.num);
-	return 0;
+	return parse_events__set_attr(attr, format->idx,
+				pmu_format_value(format->bits, term->val.num));
 }
 
 int perf_pmu__config_terms(struct list_head *formats,
@@ -678,7 +658,7 @@ int perf_pmu__check_alias(struct perf_pmu *pmu, struct list_head *head_terms,
 }
 
 int perf_pmu__new_format(struct list_head *list, char *name,
-			 int config, unsigned long *bits)
+			__u64 idx, unsigned long *bits)
 {
 	struct perf_pmu_format *format;
 
@@ -687,7 +667,7 @@ int perf_pmu__new_format(struct list_head *list, char *name,
 		return -ENOMEM;
 
 	format->name = strdup(name);
-	format->value = config;
+	format->idx = idx;
 	memcpy(format->bits, bits, sizeof(format->bits));
 
 	list_add_tail(&format->list, list);
diff --git a/tools/perf/util/pmu.h b/tools/perf/util/pmu.h
index 8b64125..10269f7 100644
--- a/tools/perf/util/pmu.h
+++ b/tools/perf/util/pmu.h
@@ -4,12 +4,7 @@
 #include <linux/bitops.h>
 #include <linux/perf_event.h>
 #include <stdbool.h>
-
-enum {
-	PERF_PMU_FORMAT_VALUE_CONFIG,
-	PERF_PMU_FORMAT_VALUE_CONFIG1,
-	PERF_PMU_FORMAT_VALUE_CONFIG2,
-};
+#include "parse-events.h"
 
 #define PERF_PMU_FORMAT_BITS 64
 
@@ -36,7 +31,7 @@ int perf_pmu_wrap(void);
 void perf_pmu_error(struct list_head *list, char *name, char const *msg);
 
 int perf_pmu__new_format(struct list_head *list, char *name,
-			 int config, unsigned long *bits);
+			__u64 idx, unsigned long *bits);
 void perf_pmu__set_format(unsigned long *bits, long from, long to);
 int perf_pmu__format_parse(char *dir, struct list_head *head);
 
diff --git a/tools/perf/util/pmu.l b/tools/perf/util/pmu.l
index a15d9fb..9d5aa62 100644
--- a/tools/perf/util/pmu.l
+++ b/tools/perf/util/pmu.l
@@ -26,6 +26,7 @@ num_dec         [0-9]+
 %%
 
 {num_dec}	{ return value(10); }
+attr		{ return PP_ATTR; }
 config		{ return PP_CONFIG; }
 config1		{ return PP_CONFIG1; }
 config2		{ return PP_CONFIG2; }
diff --git a/tools/perf/util/pmu.y b/tools/perf/util/pmu.y
index bfd7e85..fb86df8 100644
--- a/tools/perf/util/pmu.y
+++ b/tools/perf/util/pmu.y
@@ -20,7 +20,7 @@ do { \
 
 %}
 
-%token PP_CONFIG PP_CONFIG1 PP_CONFIG2
+%token PP_ATTR PP_CONFIG PP_CONFIG1 PP_CONFIG2
 %token PP_VALUE PP_ERROR
 %type <num> PP_VALUE
 %type <bits> bit_term
@@ -40,24 +40,34 @@ format format_term
 format_term
 
 format_term:
+PP_ATTR ':' bits
+{
+	ABORT_ON(perf_pmu__new_format(format, name, 0, $3));
+}
+|
+PP_ATTR PP_VALUE ':' bits
+{
+	ABORT_ON(perf_pmu__new_format(format, name, $2, $4));
+}
+|
 PP_CONFIG ':' bits
 {
 	ABORT_ON(perf_pmu__new_format(format, name,
-				      PERF_PMU_FORMAT_VALUE_CONFIG,
+				      PERF_ATTR_IDX(config),
 				      $3));
 }
 |
 PP_CONFIG1 ':' bits
 {
 	ABORT_ON(perf_pmu__new_format(format, name,
-				      PERF_PMU_FORMAT_VALUE_CONFIG1,
+				      PERF_ATTR_IDX(config1),
 				      $3));
 }
 |
 PP_CONFIG2 ':' bits
 {
 	ABORT_ON(perf_pmu__new_format(format, name,
-				      PERF_PMU_FORMAT_VALUE_CONFIG2,
+				      PERF_ATTR_IDX(config2),
 				      $3));
 }
 
-- 
1.7.11.7

