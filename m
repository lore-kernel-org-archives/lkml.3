Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751804Ab3LKMiY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 07:38:24 -0500
Received: from mga02.intel.com ([134.134.136.20]:53419 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751686Ab3LKMiV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 07:38:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,871,1378882800"; 
   d="scan'208";a="422885106"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH v0 08/71] perf tools: Let a user specify a PMU event without any config terms
Date: Wed, 11 Dec 2013 14:36:20 +0200
Message-Id: <1386765443-26966-9-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc2
In-Reply-To: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

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
index 969cb8f..98547e0 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -644,6 +644,12 @@ int parse_events_add_pmu(struct list_head *list, int *idx,
 
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
index 4eb67ec..8fad267 100644
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
1.8.5.1

