Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933738Ab3GDNPw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 09:15:52 -0400
Received: from mga14.intel.com ([143.182.124.37]:65349 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933482Ab3GDNPt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 09:15:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,995,1363158000"; 
   d="scan'208";a="264088183"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH V4 19/21] perf tools: move struct ip_event
Date: Thu,  4 Jul 2013 16:20:38 +0300
Message-Id: <1372944040-32690-20-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1372944040-32690-1-git-send-email-adrian.hunter@intel.com>
References: <1372944040-32690-1-git-send-email-adrian.hunter@intel.com>
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
index 6fa9aa6..5bcbeb3 100644
--- a/tools/perf/tests/hists_link.c
+++ b/tools/perf/tests/hists_link.c
@@ -194,6 +194,19 @@ static struct sample fake_samples[][5] = {
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
@@ -209,7 +222,7 @@ static int add_hist_entries(struct perf_evlist *evlist, struct machine *machine)
 	 */
 	list_for_each_entry(evsel, &evlist->entries, node) {
 		for (k = 0; k < ARRAY_SIZE(fake_common_samples); k++) {
-			const union perf_event event = {
+			const union perf_ip_event ip_event = {
 				.ip = {
 					.header = {
 						.misc = PERF_RECORD_MISC_USER,
@@ -218,10 +231,11 @@ static int add_hist_entries(struct perf_evlist *evlist, struct machine *machine)
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
 
@@ -235,7 +249,7 @@ static int add_hist_entries(struct perf_evlist *evlist, struct machine *machine)
 		}
 
 		for (k = 0; k < ARRAY_SIZE(fake_samples[i]); k++) {
-			const union perf_event event = {
+			const union perf_ip_event ip_event = {
 				.ip = {
 					.header = {
 						.misc = PERF_RECORD_MISC_USER,
@@ -244,10 +258,11 @@ static int add_hist_entries(struct perf_evlist *evlist, struct machine *machine)
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
index 3aef78c..a7b2245 100644
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

