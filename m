Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932074Ab3EaLgI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 07:36:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56733 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755470Ab3EaLgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 07:36:04 -0400
Date: Fri, 31 May 2013 04:35:46 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-6f29097f45f6c375f2f6a76c589577575c7feb52@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1368497347-9628-3-git-send-email-namhyung@kernel.org>
References: <1368497347-9628-3-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf top:
  Fix percent output when no samples collected
Git-Commit-ID: 6f29097f45f6c375f2f6a76c589577575c7feb52
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6f29097f45f6c375f2f6a76c589577575c7feb52
Gitweb:     http://git.kernel.org/tip/6f29097f45f6c375f2f6a76c589577575c7feb52
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Tue, 14 May 2013 11:09:00 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 28 May 2013 16:23:59 +0300

perf top: Fix percent output when no samples collected

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
