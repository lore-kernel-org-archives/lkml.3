Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157Ab3AYWgZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 17:36:25 -0500
Received: from mga02.intel.com ([134.134.136.20]:32870 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753116Ab3AYWdZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 17:33:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,541,1355126400"; 
   d="scan'208";a="252629025"
From: Andi Kleen <andi@firstfloor.org>
To: mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        akpm@linux-foundation.org, acme@redhat.com, eranian@google.com,
        jolsa@redhat.com, namhyung@kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 09/18] perf, tools: Add support for record transaction flags v3
Date: Fri, 25 Jan 2013 14:33:03 -0800
Message-Id: <1359153192-13409-10-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1359153192-13409-1-git-send-email-andi@firstfloor.org>
References: <1359153192-13409-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add the glue in the user tools to record transaction flags with
--transaction (-T was already taken) and dump them.

Followon patches will use them.

v2: Fix manpage
v3: Move transaction to the end
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/Documentation/perf-record.txt |    4 +++-
 tools/perf/builtin-record.c              |    2 ++
 tools/perf/perf.h                        |    1 +
 tools/perf/util/event.h                  |    1 +
 tools/perf/util/evsel.c                  |    9 +++++++++
 tools/perf/util/session.c                |    3 +++
 6 files changed, 19 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index 6f3405e..c73dd25 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -185,12 +185,14 @@ is enabled for all the sampling events. The sampled branch type is the same for
 The various filters must be specified as a comma separated list: --branch-filter any_ret,u,k
 Note that this feature may not be available on all processors.
 
--W::
 --weight::
 Enable weightened sampling. An additional weight is recorded per sample and can be
 displayed with the weight and local_weight sort keys.  This currently works for TSX
 abort events and some memory events in precise mode on modern Intel CPUs.
 
+--transaction::
+Record transaction flags for transaction related events.
+
 SEE ALSO
 --------
 linkperf:perf-stat[1], linkperf:perf-list[1]
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 653a7b7..5aa0e25 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -953,6 +953,8 @@ const struct option record_options[] = {
 		     parse_branch_stack),
 	OPT_BOOLEAN('W', "weight", &record.opts.sample_weight,
 		    "sample by weight (on special events only)"),
+	OPT_BOOLEAN(0, "transaction", &record.opts.sample_transaction,
+		    "sample transaction flags (special events only)"),
 	OPT_END()
 };
 
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index d888563..5671d31 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -244,6 +244,7 @@ struct perf_record_opts {
 	u64	     default_interval;
 	u64	     user_interval;
 	u16	     stack_dump_size;
+	bool	     sample_transaction;
 };
 
 #endif
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index a97fbbe..84b070d 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -89,6 +89,7 @@ struct perf_sample {
 	u64 stream_id;
 	u64 period;
 	u64 weight;
+	u64 transaction;
 	u32 cpu;
 	u32 raw_size;
 	void *raw_data;
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 42e1e34..1fc510c 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -541,6 +541,9 @@ void perf_evsel__config(struct perf_evsel *evsel,
 	if (opts->sample_weight)
 		attr->sample_type	|= PERF_SAMPLE_WEIGHT;
 
+	if (opts->sample_transaction)
+		attr->sample_type	|= PERF_SAMPLE_TRANSACTION;
+
 	attr->mmap = track;
 	attr->comm = track;
 
@@ -1116,6 +1119,12 @@ int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
 		array++;
 	}
 
+	data->transaction = 0;
+	if (type & PERF_SAMPLE_TRANSACTION) {
+		data->transaction = *array;
+		array++;
+	}
+
 	return 0;
 }
 
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 12ffceb..860e6a4 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -803,6 +803,9 @@ static void dump_sample(struct perf_evsel *evsel, union perf_event *event,
 
 	if (sample_type & PERF_SAMPLE_WEIGHT)
 		printf("... weight: %" PRIu64 "\n", sample->weight);
+
+	if (sample_type & PERF_SAMPLE_TRANSACTION)
+		printf("... transaction: %" PRIx64 "\n", sample->transaction);
 }
 
 static struct machine *
-- 
1.7.7.6

