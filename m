Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231Ab3F1Ih4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 04:37:56 -0400
Received: from mga14.intel.com ([143.182.124.37]:5632 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755036Ab3F1Ihw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 04:37:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,957,1363158000"; 
   d="scan'208";a="323821266"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH V3 06/15] perf tools: fix parse_events_terms() freeing local variable on error path
Date: Fri, 28 Jun 2013 11:43:17 +0300
Message-Id: <1372409006-8431-7-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1372409006-8431-1-git-send-email-adrian.hunter@intel.com>
References: <1372409006-8431-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The list_head is on the stack, so just free the rest of the list.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/parse-events.c | 7 ++++++-
 tools/perf/util/parse-events.h | 1 +
 tools/perf/util/pmu.c          | 2 +-
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 995fc25..d9cb055 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -1231,12 +1231,17 @@ int parse_events_term__clone(struct parse_events_term **new,
 			term->val.str, term->val.num);
 }
 
-void parse_events__free_terms(struct list_head *terms)
+void parse_events__free_terms_only(struct list_head *terms)
 {
 	struct parse_events_term *term, *h;
 
 	list_for_each_entry_safe(term, h, terms, list)
 		free(term);
+}
+
+void parse_events__free_terms(struct list_head *terms)
+{
+	parse_events__free_terms_only(terms);
 
 	free(terms);
 }
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index 8a48593..6cb6f32 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -80,6 +80,7 @@ int parse_events_term__sym_hw(struct parse_events_term **term,
 			      char *config, unsigned idx);
 int parse_events_term__clone(struct parse_events_term **new,
 			     struct parse_events_term *term);
+void parse_events__free_terms_only(struct list_head *terms);
 void parse_events__free_terms(struct list_head *terms);
 int parse_events__modifier_event(struct list_head *list, char *str, bool add);
 int parse_events__modifier_group(struct list_head *list, char *event_mod);
diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index 4c6f9c4..5dd9e37 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -194,7 +194,7 @@ static int pmu_alias_terms(struct perf_pmu_alias *alias,
 	list_for_each_entry(term, &alias->terms, list) {
 		ret = parse_events_term__clone(&clone, term);
 		if (ret) {
-			parse_events__free_terms(&list);
+			parse_events__free_terms_only(&list);
 			return ret;
 		}
 		list_add_tail(&clone->list, &list);
-- 
1.7.11.7

