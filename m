Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761119AbbA2Jj5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:39:57 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44852 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753637AbbA2JFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:05:47 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
        Andi Kleen <ak@linux.intel.com>,
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
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 051/176] perf session: Do not fail on processing out of order event
Date: Wed, 28 Jan 2015 15:28:01 +0100
Message-Id: <0f069ee162db50519dbd032d4a2c41960419d6c7.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@kernel.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 tools/perf/util/hist.h    | 1 +
 tools/perf/util/session.c | 5 +++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index ce8dc61ce2c3..d326fecdeb03 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -35,6 +35,7 @@ struct events_stats {
 	u32 nr_invalid_chains;
 	u32 nr_unknown_id;
 	u32 nr_unprocessable_samples;
+	u32 nr_unordered_events;
 };
 
 enum hist_column {
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 9d78c70be71e..532a6a38d330 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -681,8 +681,7 @@ int perf_session_queue_event(struct perf_session *s, union perf_event *event,
 		return -ETIME;
 
 	if (timestamp < s->ordered_samples.last_flush) {
-		printf("Warning: Timestamp below last timeslice flush\n");
-		return -EINVAL;
+		s->stats.nr_unordered_events++;
 	}
 
 	if (!list_empty(sc)) {
@@ -1168,6 +1167,8 @@ static void perf_session__warn_about_errors(const struct perf_session *session,
 			    "Do you have a KVM guest running and not using 'perf kvm'?\n",
 			    session->stats.nr_unprocessable_samples);
 	}
+	if (session->stats.nr_unordered_events != 0)
+		ui__warning("%u out of order events recorded.\n", session->stats.nr_unordered_events);
 }
 
 volatile int session_done;
-- 
2.2.2

