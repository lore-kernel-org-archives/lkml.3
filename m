Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423149Ab3FUOWs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 10:22:48 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:34374 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161432Ab3FUOWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 10:22:03 -0400
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, acme@redhat.com,
        jolsa@redhat.com, namhyung.kim@lge.com
Subject: [PATCH 6/8] perf tools: add infrastructure to handle PERF_SAMPLE_PHYS_ADDR
Date: Fri, 21 Jun 2013 16:20:46 +0200
Message-Id: <1371824448-7306-7-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1371824448-7306-1-git-send-email-eranian@google.com>
References: <1371824448-7306-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide infratstructure to request and dump samples with
PERF_SAMPLE_PHYS_ADDR sample type, i.e., physical address
sampling. This is useful for memory access sampling support.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 tools/perf/perf.h         |  1 +
 tools/perf/util/event.h   |  1 +
 tools/perf/util/evsel.c   | 16 +++++++++++++++-
 tools/perf/util/session.c |  6 ++++++
 4 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 32bd102..17f2c11 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -218,6 +218,7 @@ struct perf_record_opts {
 	bool	     pipe_output;
 	bool	     raw_samples;
 	bool	     sample_address;
+	bool	     sample_phys_address;
 	bool	     sample_weight;
 	bool	     sample_time;
 	bool	     period;
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 1813895..373f0eb 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -85,6 +85,7 @@ struct perf_sample {
 	u32 pid, tid;
 	u64 time;
 	u64 addr;
+	u64 paddr;
 	u64 id;
 	u64 stream_id;
 	u64 period;
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 63b6f8c..15e0cca 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -524,7 +524,11 @@ void perf_evsel__config(struct perf_evsel *evsel,
 		perf_evsel__set_sample_bit(evsel, ADDR);
 		attr->mmap_data = track;
 	}
-
+	if (opts->sample_phys_address) {
+		perf_evsel__set_sample_bit(evsel, PHYS_ADDR);
+		attr->mmap_data = track;
+	}
+	
 	if (opts->call_graph) {
 		perf_evsel__set_sample_bit(evsel, CALLCHAIN);
 
@@ -1186,6 +1190,11 @@ int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
 		array++;
 	}
 
+	data->paddr = 0;
+	if (type & PERF_SAMPLE_PHYS_ADDR) {
+		data->paddr = *array;
+		array++;
+	}
 	return 0;
 }
 
@@ -1262,6 +1271,11 @@ int perf_event__synthesize_sample(union perf_event *event, u64 type,
 		array++;
 	}
 
+	if (type & PERF_SAMPLE_PHYS_ADDR) {
+		*array = sample->paddr;
+		array++;
+	}
+
 	return 0;
 }
 
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index cf1fe01..fa9bf46 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -804,6 +804,12 @@ static void dump_sample(struct perf_evsel *evsel, union perf_event *event,
 
 	if (sample_type & PERF_SAMPLE_DATA_SRC)
 		printf(" . data_src: 0x%"PRIx64"\n", sample->data_src);
+
+	if (sample_type & PERF_SAMPLE_ADDR)
+		printf(" . addr: 0x%"PRIx64"\n", sample->addr);
+
+	if (sample_type & PERF_SAMPLE_PHYS_ADDR)
+		printf(" . phys_addr: 0x%"PRIx64"\n", sample->paddr);
 }
 
 static struct machine *
-- 
1.8.1.2

