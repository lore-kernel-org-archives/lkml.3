Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751766AbaHVTt7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 15:49:59 -0400
Received: from mga11.intel.com ([192.55.52.93]:18434 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751137AbaHVTth (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 15:49:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="375896487"
From: kan.liang@intel.com
To: acme@kernel.org, jolsa@redhat.com
Cc: linux-kernel@vger.kernel.org, ak@linux.intel.com,
        Kan Liang <kan.liang@intel.com>
Subject: [PATCH 2/3] perf tools: parse the pmu event prefix and surfix
Date: Fri, 22 Aug 2014 15:42:28 -0400
Message-Id: <1408736549-4630-2-git-send-email-kan.liang@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1408736549-4630-1-git-send-email-kan.liang@intel.com>
References: <1408736549-4630-1-git-send-email-kan.liang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kan Liang <kan.liang@intel.com>

There are two types of event formats for PMU events. E.g. el-abort OR
cpu/el-abort/. However, the lexer mistakenly recognizes the simple style
format as two events.

The newly introduced function uses bsearch to search the name in known
pmu event list. It can tell the lexer that the name is a PE_NAME or a
PMU event name prefix or a PMU event name suffix. All these information
will be used for accurately parsing kernel PMU events.

The implementation is also extensible. For supporting more PMU events,
we only need to simply add the name in the array.

Signed-off-by: Kan Liang <kan.liang@intel.com>
---
 tools/perf/util/parse-events.c | 34 ++++++++++++++++++++++++++++++++++
 tools/perf/util/parse-events.h | 12 ++++++++++++
 2 files changed, 46 insertions(+)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 7a0aa75..6354648 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -666,6 +666,40 @@ int parse_events_add_pmu(struct list_head *list, int *idx,
 	return evsel ? 0 : -ENOMEM;
 }
 
+/* The contents of the pmu_events should be in ascending sorted by symbol*/
+static struct pmu_event_symbol pmu_events[] = {
+	{ "abort", false},
+	{ "capacity", false},
+	{ "commit", false},
+	{ "conflict", false},
+	{ "el", true},
+	{ "start", false},
+	{ "tx", true},
+};
+
+static int
+comp_pmu(const void *p1, const void *p2)
+{
+	struct pmu_event_symbol *pmu1 = (struct pmu_event_symbol *) p1;
+	struct pmu_event_symbol *pmu2 = (struct pmu_event_symbol *) p2;
+
+	return strcmp(pmu1->symbol, pmu2->symbol);
+}
+
+int parse_events_pmu_check(const char *name)
+{
+	struct pmu_event_symbol p, *r;
+
+	p.symbol = name;
+	r = bsearch(&p, pmu_events, ARRAY_SIZE(pmu_events),
+		sizeof(struct pmu_event_symbol), comp_pmu);
+	if (r == NULL)
+		return NONE_PMU_EVENT_FIX;
+
+	return r->is_prefix ?
+			PMU_EVENT_PREFIX : PMU_EVENT_SUFFIX;
+}
+
 int parse_events__modifier_group(struct list_head *list,
 				 char *event_mod)
 {
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index df094b4..946249e 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -36,6 +36,17 @@ extern int parse_filter(const struct option *opt, const char *str, int unset);
 #define EVENTS_HELP_MAX (128*1024)
 
 enum {
+	NONE_PMU_EVENT_FIX,
+	PMU_EVENT_PREFIX,
+	PMU_EVENT_SUFFIX,
+};
+
+struct pmu_event_symbol {
+	const char	*symbol;
+	bool		is_prefix;	/* the prefix of the pmu event */
+};
+
+enum {
 	PARSE_EVENTS__TERM_TYPE_NUM,
 	PARSE_EVENTS__TERM_TYPE_STR,
 };
@@ -95,6 +106,7 @@ int parse_events_add_breakpoint(struct list_head *list, int *idx,
 				void *ptr, char *type);
 int parse_events_add_pmu(struct list_head *list, int *idx,
 			 char *pmu , struct list_head *head_config);
+int parse_events_pmu_check(const char *name);
 void parse_events__set_leader(char *name, struct list_head *list);
 void parse_events_update_lists(struct list_head *list_event,
 			       struct list_head *list_all);
-- 
1.8.3.2

