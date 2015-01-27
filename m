Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932494AbbA0Mnb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:43:31 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35022 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758421AbbA0MR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:17:56 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jiri Olsa <jolsa@kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Zhiqiang Zhang <zhangzhiqiang.zhang@huawei.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 034/126] perf session: Do not fail on processing out of order event
Date: Tue, 27 Jan 2015 12:15:39 +0000
Message-Id: <1422361031-19364-35-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
References: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Olsa <jolsa@kernel.org>

commit f61ff6c06dc8f32c7036013ad802c899ec590607 upstream.

Linus reported perf report command being interrupted due to processing
of 'out of order' event, with following error:

  Timestamp below last timeslice flush
  0x5733a8 [0x28]: failed to process type: 3

I could reproduce the issue and in my case it was caused by one CPU
(mmap) being behind during record and userspace mmap reader seeing the
data after other CPUs data were already stored.

This is expected under some circumstances because we need to limit the
number of events that we queue for reordering when we receive a
PERF_RECORD_FINISHED_ROUND or when we force flush due to memory
pressure.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Acked-by: Ingo Molnar <mingo@kernel.org>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matt Fleming <matt.fleming@intel.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1417016371-30249-1-git-send-email-jolsa@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
[zhangzhiqiang: backport to 3.10:
 - adjust context
 - commit f61ff6c06d struct events_stats was defined in tools/perf/util/event.h
   while 3.10 stable defined in tools/perf/util/hist.h.
 - 3.10 stable there is no pr_oe_time() which used for debug.
 - After the above adjustments, becomes same to the original patch:
   https://github.com/torvalds/linux/commit/f61ff6c06dc8f32c7036013ad802c899ec590607
]
Signed-off-by: Zhiqiang Zhang <zhangzhiqiang.zhang@huawei.com>
[ luis: backported to 3.16: used zhangzhiqiang backport to 3.10 ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 tools/perf/util/hist.h    | 1 +
 tools/perf/util/session.c | 6 ++++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 742f49a85725..c6d42fa4d3dd 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -47,6 +47,7 @@ struct events_stats {
 	u32 nr_invalid_chains;
 	u32 nr_unknown_id;
 	u32 nr_unprocessable_samples;
+	u32 nr_unordered_events;
 };
 
 enum hist_column {
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 64a186edc7be..7a4517c4510d 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -638,8 +638,7 @@ int perf_session_queue_event(struct perf_session *s, union perf_event *event,
 		return -ETIME;
 
 	if (timestamp < s->ordered_samples.last_flush) {
-		printf("Warning: Timestamp below last timeslice flush\n");
-		return -EINVAL;
+		s->stats.nr_unordered_events++;
 	}
 
 	if (!list_empty(sc)) {
@@ -1136,6 +1135,9 @@ static void perf_session__warn_about_errors(const struct perf_session *session,
 			    "Do you have a KVM guest running and not using 'perf kvm'?\n",
 			    session->stats.nr_unprocessable_samples);
 	}
+
+	if (session->stats.nr_unordered_events != 0)
+		ui__warning("%u out of order events recorded.\n", session->stats.nr_unordered_events);
 }
 
 volatile int session_done;
-- 
2.1.4

