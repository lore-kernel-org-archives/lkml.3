Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752346AbaJOKDu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 06:03:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54288 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292AbaJOKDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 06:03:48 -0400
Date: Wed, 15 Oct 2014 03:03:10 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-l9ftsl21ggw0c1g2ig87otmd@git.kernel.org>
Cc: mingo@kernel.org, adrian.hunter@intel.com, hpa@zytor.com,
        dsahern@gmail.com, fweisbec@gmail.com, linux-kernel@vger.kernel.org,
        namhyung@kernel.org, dzickus@redhat.com, tglx@linutronix.de,
        efault@gmx.de, paulus@samba.org, bp@suse.de, jolsa@redhat.com,
        eranian@google.com, jean.pihet@linaro.org, peterz@infradead.org,
        acme@redhat.com
Reply-To: bp@suse.de, tglx@linutronix.de, efault@gmx.de, paulus@samba.org,
        peterz@infradead.org, acme@redhat.com, jolsa@redhat.com,
        eranian@google.com, jean.pihet@linaro.org, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org, mingo@kernel.org, hpa@zytor.com,
        adrian.hunter@intel.com, dsahern@gmail.com, namhyung@kernel.org,
        dzickus@redhat.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools: Move events_stats struct to event.h
Git-Commit-ID: 4318bcb70ecc567dd0414d87fcd7e926ce956aab
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

Commit-ID:  4318bcb70ecc567dd0414d87fcd7e926ce956aab
Gitweb:     http://git.kernel.org/tip/4318bcb70ecc567dd0414d87fcd7e926ce956aab
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 10 Oct 2014 15:46:05 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 10 Oct 2014 15:53:07 -0300

perf tools: Move events_stats struct to event.h

This is the only bit of hist.h that session.[ch] will end up using, so
move it out of hist.h to make that abundantly clear.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-l9ftsl21ggw0c1g2ig87otmd@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/event.h | 26 ++++++++++++++++++++++++++
 tools/perf/util/hist.h  | 26 --------------------------
 2 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 7eb7107..5699e7e 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -190,6 +190,32 @@ enum perf_user_event_type { /* above any possible kernel type */
 	PERF_RECORD_HEADER_MAX
 };
 
+/*
+ * The kernel collects the number of events it couldn't send in a stretch and
+ * when possible sends this number in a PERF_RECORD_LOST event. The number of
+ * such "chunks" of lost events is stored in .nr_events[PERF_EVENT_LOST] while
+ * total_lost tells exactly how many events the kernel in fact lost, i.e. it is
+ * the sum of all struct lost_event.lost fields reported.
+ *
+ * The total_period is needed because by default auto-freq is used, so
+ * multipling nr_events[PERF_EVENT_SAMPLE] by a frequency isn't possible to get
+ * the total number of low level events, it is necessary to to sum all struct
+ * sample_event.period and stash the result in total_period.
+ */
+struct events_stats {
+	u64 total_period;
+	u64 total_non_filtered_period;
+	u64 total_lost;
+	u64 total_invalid_chains;
+	u32 nr_events[PERF_RECORD_HEADER_MAX];
+	u32 nr_non_filtered_samples;
+	u32 nr_lost_warned;
+	u32 nr_unknown_events;
+	u32 nr_invalid_chains;
+	u32 nr_unknown_id;
+	u32 nr_unprocessable_samples;
+};
+
 struct attr_event {
 	struct perf_event_header header;
 	struct perf_event_attr attr;
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 8c9c70e..04a46e3 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -23,32 +23,6 @@ enum hist_filter {
 	HIST_FILTER__HOST,
 };
 
-/*
- * The kernel collects the number of events it couldn't send in a stretch and
- * when possible sends this number in a PERF_RECORD_LOST event. The number of
- * such "chunks" of lost events is stored in .nr_events[PERF_EVENT_LOST] while
- * total_lost tells exactly how many events the kernel in fact lost, i.e. it is
- * the sum of all struct lost_event.lost fields reported.
- *
- * The total_period is needed because by default auto-freq is used, so
- * multipling nr_events[PERF_EVENT_SAMPLE] by a frequency isn't possible to get
- * the total number of low level events, it is necessary to to sum all struct
- * sample_event.period and stash the result in total_period.
- */
-struct events_stats {
-	u64 total_period;
-	u64 total_non_filtered_period;
-	u64 total_lost;
-	u64 total_invalid_chains;
-	u32 nr_events[PERF_RECORD_HEADER_MAX];
-	u32 nr_non_filtered_samples;
-	u32 nr_lost_warned;
-	u32 nr_unknown_events;
-	u32 nr_invalid_chains;
-	u32 nr_unknown_id;
-	u32 nr_unprocessable_samples;
-};
-
 enum hist_column {
 	HISTC_SYMBOL,
 	HISTC_DSO,
