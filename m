Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742Ab3EMDEk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 23:04:40 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:50778 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203Ab3EMDEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 23:04:38 -0400
X-AuditID: 9c93017d-b7b62ae000004f69-1a-519054b14c52
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 2/2] perf top: Fix percent output when no samples collected
Date: Mon, 13 May 2013 11:49:18 +0900
Message-Id: <1368413358-11685-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1368413358-11685-1-git-send-email-namhyung@kernel.org>
References: <1368413358-11685-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

If there's no sample, kernel and exact percent output at the header
looked like "-nan%".

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/top.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/top.c b/tools/perf/util/top.c
index 54d37a4753c5..f857b51b6bde 100644
--- a/tools/perf/util/top.c
+++ b/tools/perf/util/top.c
@@ -23,20 +23,31 @@
 
 size_t perf_top__header_snprintf(struct perf_top *top, char *bf, size_t size)
 {
-	float samples_per_sec = top->samples / top->delay_secs;
-	float ksamples_per_sec = top->kernel_samples / top->delay_secs;
-	float esamples_percent = (100.0 * top->exact_samples) / top->samples;
+	float samples_per_sec;
+	float ksamples_per_sec;
+	float esamples_percent;
 	struct perf_record_opts *opts = &top->record_opts;
 	struct perf_target *target = &opts->target;
 	size_t ret = 0;
 
+	if (top->samples) {
+		samples_per_sec = top->samples / top->delay_secs;
+		ksamples_per_sec = top->kernel_samples / top->delay_secs;
+		esamples_percent = (100.0 * top->exact_samples) / top->samples;
+	} else {
+		samples_per_sec = ksamples_per_sec = esamples_percent = 0.0;
+	}
+
 	if (!perf_guest) {
+		float ksamples_percent = 0.0;
+
+		if (samples_per_sec)
+			ksamples_percent = (100.0 * ksamples_per_sec) /
+							samples_per_sec;
 		ret = SNPRINTF(bf, size,
 			       "   PerfTop:%8.0f irqs/sec  kernel:%4.1f%%"
 			       "  exact: %4.1f%% [", samples_per_sec,
-			       100.0 - (100.0 * ((samples_per_sec - ksamples_per_sec) /
-					samples_per_sec)),
-				esamples_percent);
+			       ksamples_percent, esamples_percent);
 	} else {
 		float us_samples_per_sec = top->us_samples / top->delay_secs;
 		float guest_kernel_samples_per_sec = top->guest_kernel_samples / top->delay_secs;
-- 
1.7.11.7

