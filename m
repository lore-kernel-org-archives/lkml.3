Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737Ab3KAK6Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 06:58:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3271 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751334Ab3KAK6W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 06:58:22 -0400
Date: Fri, 1 Nov 2013 11:57:22 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        ak@linux.intel.com, acme@redhat.com, zheng.z.yan@intel.com,
        bp@alien8.de, maria.n.dimakopoulou@gmail.com
Subject: Re: [PATCH v4 2/4] perf stat: add event unit and scale support
Message-ID: <20131101105722.GA1088@krava.brq.redhat.com>
References: <1383231582-15856-1-git-send-email-eranian@google.com>
 <1383231582-15856-3-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383231582-15856-3-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 31, 2013 at 03:59:40PM +0100, Stephane Eranian wrote:
> This patch adds perf stat support fo rhandling event units and
> scales as exported by the kernel.
> 
> The kernel can export PMU events actual unit and scaling factor
> via sysfs:
> $ ls -1 /sys/devices/power/events/energy-*
> /sys/devices/power/events/energy-cores
> /sys/devices/power/events/energy-cores.scale
> /sys/devices/power/events/energy-cores.unit
> /sys/devices/power/events/energy-pkg
> /sys/devices/power/events/energy-pkg.scale
> /sys/devices/power/events/energy-pkg.unit
> $ cat /sys/devices/power/events/energy-cores.scale
> 2.3e-10
> $ cat cat /sys/devices/power/events/energy-cores.unit
> Joules
> 
> This patch modifies the pmu event alias code to check
> for the presence of the .unit and .scale files to load
> the corresponding values. They are then used by perf stat
> transparentely:
>

wrt our previous conversation, attached patch is what
I meant (based on your changes)

you could get rid of following functions:
  pmu_event_unit
  pmu_event_scale
  pmu_get_event_unit_scale

and have the unit/scale processing within the alias code

the name that matters is the term name which is available
in the parse_events_add_pmu as one of the terms

jirka
---
 tools/perf/util/parse-events.c | 29 ++++++++-----
 tools/perf/util/pmu.c          | 92 +++++++++++++++---------------------------
 tools/perf/util/pmu.h          |  6 +--
 3 files changed, 53 insertions(+), 74 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index be7eba8..90ae328 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -269,9 +269,10 @@ const char *event_type(int type)
 
 
 
-static int __add_event(struct list_head *list, int *idx,
-		       struct perf_event_attr *attr,
-		       char *name, struct cpu_map *cpus)
+static struct perf_evsel *
+__add_event(struct list_head *list, int *idx,
+	    struct perf_event_attr *attr,
+	    char *name, struct cpu_map *cpus)
 {
 	struct perf_evsel *evsel;
 
@@ -279,19 +280,19 @@ static int __add_event(struct list_head *list, int *idx,
 
 	evsel = perf_evsel__new(attr, (*idx)++);
 	if (!evsel)
-		return -ENOMEM;
+		return NULL;
 
 	evsel->cpus = cpus;
 	if (name)
 		evsel->name = strdup(name);
 	list_add_tail(&evsel->node, list);
-	return 0;
+	return evsel;
 }
 
 static int add_event(struct list_head *list, int *idx,
 		     struct perf_event_attr *attr, char *name)
 {
-	return __add_event(list, idx, attr, name, NULL);
+	return __add_event(list, idx, attr, name, NULL) ? 0 : -ENOMEM;
 }
 
 static int parse_aliases(char *str, const char *names[][PERF_EVSEL__MAX_ALIASES], int size)
@@ -633,6 +634,9 @@ int parse_events_add_pmu(struct list_head *list, int *idx,
 {
 	struct perf_event_attr attr;
 	struct perf_pmu *pmu;
+	struct perf_evsel *evsel;
+	char *unit;
+	double scale;
 
 	pmu = perf_pmu__find(name);
 	if (!pmu)
@@ -640,7 +644,7 @@ int parse_events_add_pmu(struct list_head *list, int *idx,
 
 	memset(&attr, 0, sizeof(attr));
 
-	if (perf_pmu__check_alias(pmu, head_config))
+	if (perf_pmu__check_alias(pmu, head_config, &unit, &scale))
 		return -EINVAL;
 
 	/*
@@ -652,8 +656,14 @@ int parse_events_add_pmu(struct list_head *list, int *idx,
 	if (perf_pmu__config(pmu, &attr, head_config))
 		return -EINVAL;
 
-	return __add_event(list, idx, &attr, pmu_event_name(head_config),
-			   pmu->cpus);
+	evsel = __add_event(list, idx, &attr, pmu_event_name(head_config),
+			    pmu->cpus);
+	if (evsel) {
+		evsel->unit = unit;
+		evsel->scale = scale;
+	}
+
+	return evsel ? 0 : -ENOMEM;
 }
 
 int parse_events__modifier_group(struct list_head *list,
@@ -838,7 +848,6 @@ int parse_events_name(struct list_head *list, char *name)
 	list_for_each_entry(evsel, list, node) {
 		if (!evsel->name)
 			evsel->name = strdup(name);
-		pmu_get_event_unit_scale(evsel);
 	}
 
 	return 0;
diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index e18ef87..df68d43 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -620,16 +620,42 @@ static struct perf_pmu_alias *pmu_find_alias(struct perf_pmu *pmu,
 	return NULL;
 }
 
+
+static int check_unit_scale(struct perf_pmu_alias *alias,
+			    char **unit, double *scale)
+{
+	/*
+	 * Only one term in event definition can
+	 * define unit and scale, fail if there's
+	 * more than one.
+	 */
+	if ((*unit && alias->unit) ||
+	    (*scale && alias->scale))
+		return -EINVAL;
+
+	if (alias->unit)
+		*unit = alias->unit;
+
+	if (alias->scale)
+		*scale = alias->scale;
+
+	return 0;
+}
+
 /*
  * Find alias in the terms list and replace it with the terms
  * defined for the alias
  */
-int perf_pmu__check_alias(struct perf_pmu *pmu, struct list_head *head_terms)
+int perf_pmu__check_alias(struct perf_pmu *pmu, struct list_head *head_terms,
+			  char **unit, double *scale)
 {
 	struct parse_events_term *term, *h;
 	struct perf_pmu_alias *alias;
 	int ret;
 
+	*unit   = NULL;
+	*scale  = 0;
+
 	list_for_each_entry_safe(term, h, head_terms, list) {
 		alias = pmu_find_alias(pmu, term);
 		if (!alias)
@@ -637,6 +663,11 @@ int perf_pmu__check_alias(struct perf_pmu *pmu, struct list_head *head_terms)
 		ret = pmu_alias_terms(alias, &term->list);
 		if (ret)
 			return ret;
+
+		ret = check_unit_scale(alias, unit, scale);
+		if (ret)
+			return ret;
+
 		list_del(&term->list);
 		free(term);
 	}
@@ -760,62 +791,3 @@ bool pmu_have_event(const char *pname, const char *name)
 	}
 	return false;
 }
-
-static const char *pmu_event_unit(struct perf_pmu *pmu, const char *name)
-{
-	struct perf_pmu_alias *alias;
-	char buf[1024];
-	char *fname;
-	const char *unit = "?";
-
-	if (!name)
-		return unit;
-
-	list_for_each_entry(alias, &pmu->aliases, list) {
-		fname = format_alias(buf, sizeof(buf), pmu, alias);
-		if (!strcmp(fname, name)) {
-			unit = alias->unit;
-			break;
-		}
-	}
-	return unit;
-}
-
-static double pmu_event_scale(struct perf_pmu *pmu, const char *name)
-{
-	struct perf_pmu_alias *alias;
-	char buf[1024];
-	char *fname;
-	double scale = 1.0;
-
-	if (!name)
-		return 1.0;
-
-	list_for_each_entry(alias, &pmu->aliases, list) {
-		fname = format_alias(buf, sizeof(buf), pmu, alias);
-		if (!strcmp(fname, name)) {
-			scale = alias->scale;
-			break;
-		}
-	}
-	return scale;
-}
-
-int pmu_get_event_unit_scale(struct perf_evsel *evsel)
-{
-	__u32 type = evsel->attr.type;
-	struct perf_pmu *pmu;
-
-	if (!evsel->name)
-		return -1;
-
-	list_for_each_entry(pmu, &pmus, list) {
-		if (pmu->type == type)
-			goto found;
-	}
-	return -1;
-found:
-	evsel->unit  = pmu_event_unit(pmu, evsel->name);
-	evsel->scale = pmu_event_scale(pmu, evsel->name);
-	return 0;
-}
diff --git a/tools/perf/util/pmu.h b/tools/perf/util/pmu.h
index 6bf23b2..9183380 100644
--- a/tools/perf/util/pmu.h
+++ b/tools/perf/util/pmu.h
@@ -4,7 +4,6 @@
 #include <linux/bitops.h>
 #include <linux/perf_event.h>
 #include <stdbool.h>
-#include "util/evsel.h"
 
 enum {
 	PERF_PMU_FORMAT_VALUE_CONFIG,
@@ -29,7 +28,8 @@ int perf_pmu__config(struct perf_pmu *pmu, struct perf_event_attr *attr,
 int perf_pmu__config_terms(struct list_head *formats,
 			   struct perf_event_attr *attr,
 			   struct list_head *head_terms);
-int perf_pmu__check_alias(struct perf_pmu *pmu, struct list_head *head_terms);
+int perf_pmu__check_alias(struct perf_pmu *pmu, struct list_head *head_terms,
+			  char **unit, double *scale);
 struct list_head *perf_pmu__alias(struct perf_pmu *pmu,
 				  struct list_head *head_terms);
 int perf_pmu_wrap(void);
@@ -46,6 +46,4 @@ void print_pmu_events(const char *event_glob, bool name_only);
 bool pmu_have_event(const char *pname, const char *name);
 
 int perf_pmu__test(void);
-
-int pmu_get_event_unit_scale(struct perf_evsel *evsel);
 #endif /* __PMU_H */
-- 
1.7.11.7

