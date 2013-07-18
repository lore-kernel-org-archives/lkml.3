Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757450Ab3GRKgw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 06:36:52 -0400
Received: from mga09.intel.com ([134.134.136.24]:56267 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932341Ab3GRKgr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 06:36:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,692,1367996400"; 
   d="scan'208";a="347700729"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH V8 08/15] perf tools: move struct ip_event
Date: Thu, 18 Jul 2013 13:42:50 +0300
Message-Id: <1374144177-24762-9-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1374144177-24762-1-git-send-email-adrian.hunter@intel.com>
References: <1374144177-24762-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct ip_event assumes fixed positions for ip, pid
and tid.  That is no longer true with the addition of
PERF_SAMPLE_IDENTIFIER.

struct ip_event is no longer used except by hists_link.c.
Move it there.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/tests/hists_link.c | 23 +++++++++++++++++++----
 tools/perf/util/event.h       | 11 -----------
 2 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/tools/perf/tests/hists_link.c b/tools/perf/tests/hists_link.c
index 7e0ca15..cfdbfd9 100644
--- a/tools/perf/tests/hists_link.c
+++ b/tools/perf/tests/hists_link.c
@@ -195,6 +195,19 @@ static struct sample fake_samples[][5] = {
 	},
 };
 
+/* PERF_SAMPLE_IP | PERF_SAMPLE_TID | * but not PERF_SAMPLE_IDENTIFIER */
+struct ip_event {
+	struct perf_event_header header;
+	u64 ip;
+	u32 pid, tid;
+	unsigned char __more_data[];
+};
+
+union perf_ip_event {
+	struct ip_event ip;
+	union perf_event event;
+};
+
 static int add_hist_entries(struct perf_evlist *evlist, struct machine *machine)
 {
 	struct perf_evsel *evsel;
@@ -210,7 +223,7 @@ static int add_hist_entries(struct perf_evlist *evlist, struct machine *machine)
 	 */
 	list_for_each_entry(evsel, &evlist->entries, node) {
 		for (k = 0; k < ARRAY_SIZE(fake_common_samples); k++) {
-			const union perf_event event = {
+			const union perf_ip_event ip_event = {
 				.ip = {
 					.header = {
 						.misc = PERF_RECORD_MISC_USER,
@@ -219,10 +232,11 @@ static int add_hist_entries(struct perf_evlist *evlist, struct machine *machine)
 					.ip  = fake_common_samples[k].ip,
 				},
 			};
+			const union perf_event *event = &ip_event.event;
 
 			sample.pid = ip_event.ip.pid;
 			sample.ip = ip_event.ip.ip;
-			if (perf_event__preprocess_sample(&event, machine, &al,
+			if (perf_event__preprocess_sample(event, machine, &al,
 							  &sample, 0) < 0)
 				goto out;
 
@@ -236,7 +250,7 @@ static int add_hist_entries(struct perf_evlist *evlist, struct machine *machine)
 		}
 
 		for (k = 0; k < ARRAY_SIZE(fake_samples[i]); k++) {
-			const union perf_event event = {
+			const union perf_ip_event ip_event = {
 				.ip = {
 					.header = {
 						.misc = PERF_RECORD_MISC_USER,
@@ -245,10 +259,11 @@ static int add_hist_entries(struct perf_evlist *evlist, struct machine *machine)
 					.ip  = fake_samples[i][k].ip,
 				},
 			};
+			const union perf_event *event = &ip_event.event;
 
 			sample.pid = ip_event.ip.pid;
 			sample.ip = ip_event.ip.ip;
-			if (perf_event__preprocess_sample(&event, machine, &al,
+			if (perf_event__preprocess_sample(event, machine, &al,
 							  &sample, 0) < 0)
 				goto out;
 
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index e60585e..94f4503 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -8,16 +8,6 @@
 #include "map.h"
 #include "build-id.h"
 
-/*
- * PERF_SAMPLE_IP | PERF_SAMPLE_TID | *
- */
-struct ip_event {
-	struct perf_event_header header;
-	u64 ip;
-	u32 pid, tid;
-	unsigned char __more_data[];
-};
-
 struct mmap_event {
 	struct perf_event_header header;
 	u32 pid, tid;
@@ -162,7 +152,6 @@ struct tracing_data_event {
 
 union perf_event {
 	struct perf_event_header	header;
-	struct ip_event			ip;
 	struct mmap_event		mmap;
 	struct comm_event		comm;
 	struct fork_event		fork;
-- 
1.7.11.7

