Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932284AbaIQV3E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 17:29:04 -0400
Received: from mail.kernel.org ([198.145.19.201]:57987 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932127AbaIQVZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 17:25:04 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 07/20] perf tools: Let a user specify a PMU event without any config terms
Date: Wed, 17 Sep 2014 18:24:10 -0300
Message-Id: <1410989063-14207-8-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1410989063-14207-1-git-send-email-acme@kernel.org>
References: <1410989063-14207-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

This enables a PMU event to be specified in the form:

	pmu//

which is effectively the same as:

	pmu/config=0/

This patch is a precursor to defining default config for a PMU.

Further explanation extracted from lkml thread:

Imagine that the 'tsc' term did not exist.

Intel PT trace data would not contain TSC packets, and the decoder would
not know how to decode them.

Then imagine that a new version of the hardware adds 'tsc'.

It is such a useful feature that we want it by default, but older
versions of the tools don't know how to decode it, so the kernel cannot
turn it on by default.

It is similar to why the kernel does not select perf_event_attr.mmap2 by
default.

The kernel doesn't know whether the tool supports it.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1408129739-17368-6-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/parse-events.c |  6 ++++++
 tools/perf/util/parse-events.y | 10 ++++++++++
 2 files changed, 16 insertions(+)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index e34c81a0bcf3..e75628813968 100644
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
index 0bc87ba46bf3..55fab6ad609a 100644
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
1.9.3

