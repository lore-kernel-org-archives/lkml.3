Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951AbaHOTK7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 15:10:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:59432 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751754AbaHOTK6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 15:10:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,872,1400050800"; 
   d="scan'208";a="588727769"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 05/24] perf tools: Let a user specify a PMU event without any config terms
Date: Fri, 15 Aug 2014 22:08:40 +0300
Message-Id: <1408129739-17368-6-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1408129739-17368-1-git-send-email-adrian.hunter@intel.com>
References: <1408129739-17368-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This enables a PMU event to be specified in the form:

	pmu//

which is effectively the same as:

	pmu/config=0/

This patch is a precursor to defining
default config for a PMU.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/parse-events.c |  6 ++++++
 tools/perf/util/parse-events.y | 10 ++++++++++
 2 files changed, 16 insertions(+)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index e34c81a..e756288 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -645,6 +645,12 @@ int parse_events_add_pmu(struct list_head *list, int *idx,
 
 	memset(&attr, 0, sizeof(attr));
 
+	if (!head_config) {
+		attr.type = pmu->type;
+		evsel = __add_event(list, idx, &attr, NULL, pmu->cpus);
+		return evsel ? 0 : -ENOMEM;
+	}
+
 	if (perf_pmu__check_alias(pmu, head_config, &unit, &scale))
 		return -EINVAL;
 
diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-events.y
index 0bc87ba..55fab6a 100644
--- a/tools/perf/util/parse-events.y
+++ b/tools/perf/util/parse-events.y
@@ -210,6 +210,16 @@ PE_NAME '/' event_config '/'
 	parse_events__free_terms($3);
 	$$ = list;
 }
+|
+PE_NAME '/' '/'
+{
+	struct parse_events_evlist *data = _data;
+	struct list_head *list;
+
+	ALLOC_LIST(list);
+	ABORT_ON(parse_events_add_pmu(list, &data->idx, $1, NULL));
+	$$ = list;
+}
 
 value_sym:
 PE_VALUE_SYM_HW
-- 
1.8.3.2

