Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756294AbaGaGCq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 02:02:46 -0400
Received: from mga14.intel.com ([192.55.52.115]:50156 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756254AbaGaGCo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 02:02:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,770,1400050800"; 
   d="scan'208";a="569799799"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 06/31] perf tools: Let default config be defined for a PMU
Date: Thu, 31 Jul 2014 09:00:49 +0300
Message-Id: <1406786474-9306-7-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1406786474-9306-1-git-send-email-adrian.hunter@intel.com>
References: <1406786474-9306-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows default config terms to be provided
for a PMU. So, for example, when the Intel PT
PMU is added, it will be possible to specify:

	intel_pt//

which will be the same as:

	intel_pt/tsc=1,noretcomp=0/

meaning that the trace should contain
TSC timestamps and perform 'return
compression'.

An important consideration of this
patch is that it must be possible
to overwrite the default values.
That has meant changing the logic
so that a zero value can replace
a non-zero value.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/tests/pmu.c         |  2 +-
 tools/perf/util/parse-events.c |  7 ++++++-
 tools/perf/util/pmu.c          | 42 ++++++++++++++++++++++++++----------------
 tools/perf/util/pmu.h          |  9 ++++++++-
 4 files changed, 41 insertions(+), 19 deletions(-)

diff --git a/tools/perf/tests/pmu.c b/tools/perf/tests/pmu.c
index 12b322f..eeb68bb1 100644
--- a/tools/perf/tests/pmu.c
+++ b/tools/perf/tests/pmu.c
@@ -152,7 +152,7 @@ int test__pmu(void)
 		if (ret)
 			break;
 
-		ret = perf_pmu__config_terms(&formats, &attr, terms);
+		ret = perf_pmu__config_terms(&formats, &attr, terms, false);
 		if (ret)
 			break;
 
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 76fd04b..20d2c1e 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -642,7 +642,12 @@ int parse_events_add_pmu(struct list_head *list, int *idx,
 	if (!pmu)
 		return -EINVAL;
 
-	memset(&attr, 0, sizeof(attr));
+	if (pmu->default_config) {
+		memcpy(&attr, pmu->default_config,
+		       sizeof(struct perf_event_attr));
+	} else {
+		memset(&attr, 0, sizeof(attr));
+	}
 
 	if (!head_config) {
 		attr.type = pmu->type;
diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index 7a811eb..11ec977 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -2,6 +2,7 @@
 #include <sys/types.h>
 #include <unistd.h>
 #include <stdio.h>
+#include <stdbool.h>
 #include <dirent.h>
 #include <api/fs/fs.h>
 #include <locale.h>
@@ -387,6 +388,12 @@ static struct cpu_map *pmu_cpumask(const char *name)
 	return cpus;
 }
 
+struct perf_event_attr *__attribute__((weak))
+perf_pmu__get_default_config(struct perf_pmu *pmu __maybe_unused)
+{
+	return NULL;
+}
+
 static struct perf_pmu *pmu_lookup(const char *name)
 {
 	struct perf_pmu *pmu;
@@ -421,6 +428,9 @@ static struct perf_pmu *pmu_lookup(const char *name)
 	pmu->name = strdup(name);
 	pmu->type = type;
 	list_add_tail(&pmu->list, &pmus);
+
+	pmu->default_config = perf_pmu__get_default_config(pmu);
+
 	return pmu;
 }
 
@@ -479,28 +489,24 @@ pmu_find_format(struct list_head *formats, char *name)
 }
 
 /*
- * Returns value based on the format definition (format parameter)
+ * Sets value based on the format definition (format parameter)
  * and unformated value (value parameter).
- *
- * TODO maybe optimize a little ;)
  */
-static __u64 pmu_format_value(unsigned long *format, __u64 value)
+static void pmu_format_value(unsigned long *format, __u64 value, __u64 *v,
+			     bool zero)
 {
 	unsigned long fbit, vbit;
-	__u64 v = 0;
 
 	for (fbit = 0, vbit = 0; fbit < PERF_PMU_FORMAT_BITS; fbit++) {
 
 		if (!test_bit(fbit, format))
 			continue;
 
-		if (!(value & (1llu << vbit++)))
-			continue;
-
-		v |= (1llu << fbit);
+		if (value & (1llu << vbit++))
+			*v |= (1llu << fbit);
+		else if (zero)
+			*v &= ~(1llu << fbit);
 	}
-
-	return v;
 }
 
 /*
@@ -509,7 +515,8 @@ static __u64 pmu_format_value(unsigned long *format, __u64 value)
  */
 static int pmu_config_term(struct list_head *formats,
 			   struct perf_event_attr *attr,
-			   struct parse_events_term *term)
+			   struct parse_events_term *term,
+			   bool zero)
 {
 	struct perf_pmu_format *format;
 	__u64 *vp;
@@ -548,18 +555,19 @@ static int pmu_config_term(struct list_head *formats,
 	 * non-hardcoded terms, here's the place to translate
 	 * them into value.
 	 */
-	*vp |= pmu_format_value(format->bits, term->val.num);
+	pmu_format_value(format->bits, term->val.num, vp, zero);
 	return 0;
 }
 
 int perf_pmu__config_terms(struct list_head *formats,
 			   struct perf_event_attr *attr,
-			   struct list_head *head_terms)
+			   struct list_head *head_terms,
+			   bool zero)
 {
 	struct parse_events_term *term;
 
 	list_for_each_entry(term, head_terms, list)
-		if (pmu_config_term(formats, attr, term))
+		if (pmu_config_term(formats, attr, term, zero))
 			return -EINVAL;
 
 	return 0;
@@ -573,8 +581,10 @@ int perf_pmu__config_terms(struct list_head *formats,
 int perf_pmu__config(struct perf_pmu *pmu, struct perf_event_attr *attr,
 		     struct list_head *head_terms)
 {
+	bool zero = !!pmu->default_config;
+
 	attr->type = pmu->type;
-	return perf_pmu__config_terms(&pmu->format, attr, head_terms);
+	return perf_pmu__config_terms(&pmu->format, attr, head_terms, zero);
 }
 
 static struct perf_pmu_alias *pmu_find_alias(struct perf_pmu *pmu,
diff --git a/tools/perf/util/pmu.h b/tools/perf/util/pmu.h
index c14a543..281d5b1 100644
--- a/tools/perf/util/pmu.h
+++ b/tools/perf/util/pmu.h
@@ -13,9 +13,12 @@ enum {
 
 #define PERF_PMU_FORMAT_BITS 64
 
+struct perf_event_attr;
+
 struct perf_pmu {
 	char *name;
 	__u32 type;
+	struct perf_event_attr *default_config;
 	struct cpu_map *cpus;
 	struct list_head format;
 	struct list_head aliases;
@@ -27,7 +30,8 @@ int perf_pmu__config(struct perf_pmu *pmu, struct perf_event_attr *attr,
 		     struct list_head *head_terms);
 int perf_pmu__config_terms(struct list_head *formats,
 			   struct perf_event_attr *attr,
-			   struct list_head *head_terms);
+			   struct list_head *head_terms,
+			   bool zero);
 int perf_pmu__check_alias(struct perf_pmu *pmu, struct list_head *head_terms,
 			  const char **unit, double *scale);
 struct list_head *perf_pmu__alias(struct perf_pmu *pmu,
@@ -46,4 +50,7 @@ void print_pmu_events(const char *event_glob, bool name_only);
 bool pmu_have_event(const char *pname, const char *name);
 
 int perf_pmu__test(void);
+
+struct perf_event_attr *perf_pmu__get_default_config(struct perf_pmu *pmu);
+
 #endif /* __PMU_H */
-- 
1.8.3.2

