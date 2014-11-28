Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751388AbaK1V27 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 16:28:59 -0500
Received: from mail.kernel.org ([198.145.19.201]:58324 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751162AbaK1V25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 16:28:57 -0500
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
        Andi Kleen <ak@linux.intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/1] perf session: Do not fail on processing out of order event
Date: Fri, 28 Nov 2014 18:28:43 -0300
Message-Id: <1417210123-19500-2-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1417210123-19500-1-git-send-email-acme@kernel.org>
References: <1417210123-19500-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@kernel.org>

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
---
 tools/perf/util/event.h   |  1 +
 tools/perf/util/session.c | 11 +++++------
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 5699e7e2a790..50a7b115698c 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -214,6 +214,7 @@ struct events_stats {
 	u32 nr_invalid_chains;
 	u32 nr_unknown_id;
 	u32 nr_unprocessable_samples;
+	u32 nr_unordered_events;
 };
 
 struct attr_event {
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 6702ac28754b..80dbba095f30 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -521,15 +521,11 @@ int perf_session_queue_event(struct perf_session *s, union perf_event *event,
 		return -ETIME;
 
 	if (timestamp < oe->last_flush) {
-		WARN_ONCE(1, "Timestamp below last timeslice flush\n");
-
-		pr_oe_time(timestamp,      "out of order event");
+		pr_oe_time(timestamp,      "out of order event\n");
 		pr_oe_time(oe->last_flush, "last flush, last_flush_type %d\n",
 			   oe->last_flush_type);
 
-		/* We could get out of order messages after forced flush. */
-		if (oe->last_flush_type != OE_FLUSH__HALF)
-			return -EINVAL;
+		s->stats.nr_unordered_events++;
 	}
 
 	new = ordered_events__new(oe, timestamp, event);
@@ -1057,6 +1053,9 @@ static void perf_session__warn_about_errors(const struct perf_session *session,
 			    "Do you have a KVM guest running and not using 'perf kvm'?\n",
 			    session->stats.nr_unprocessable_samples);
 	}
+
+	if (session->stats.nr_unordered_events != 0)
+		ui__warning("%u out of order events recorded.\n", session->stats.nr_unordered_events);
 }
 
 volatile int session_done;
-- 
1.9.3

