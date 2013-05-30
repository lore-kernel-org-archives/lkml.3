Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934814Ab3E3QCg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 12:02:36 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50852 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934451Ab3E3QCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 12:02:08 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 19/66] perf top: Fix percent output when no samples collected
Date: Thu, 30 May 2013 19:00:52 +0300
Message-Id: <1369929699-8724-20-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1369929699-8724-1-git-send-email-acme@infradead.org>
References: <1369929699-8724-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

If there's no sample, kernel and exact percent output at the header
looked like "-nan%".

Tested-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1368497347-9628-3-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/top.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/top.c b/tools/perf/util/top.c
index 54d37a4..f857b51 100644
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
1.8.1.4

