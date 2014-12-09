Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755729AbaLIKRA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 05:17:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52308 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753503AbaLIKQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 05:16:58 -0500
Date: Tue, 9 Dec 2014 02:16:12 -0800
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-f61ff6c06dc8f32c7036013ad802c899ec590607@git.kernel.org>
Cc: acme@redhat.com, jolsa@kernel.org, linux-kernel@vger.kernel.org,
        dsahern@gmail.com, eranian@google.com, tglx@linutronix.de,
        mingo@kernel.org, matt.fleming@intel.com, paulus@samba.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, hpa@zytor.com,
        ak@linux.intel.com, cjashfor@linux.vnet.ibm.com, namhyung@kernel.org,
        fweisbec@gmail.com
Reply-To: hpa@zytor.com, torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        fweisbec@gmail.com, ak@linux.intel.com, namhyung@kernel.org,
        cjashfor@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        jolsa@kernel.org, acme@redhat.com, mingo@kernel.org, paulus@samba.org,
        matt.fleming@intel.com, dsahern@gmail.com, tglx@linutronix.de,
        eranian@google.com
In-Reply-To: <1417016371-30249-1-git-send-email-jolsa@kernel.org>
References: <1417016371-30249-1-git-send-email-jolsa@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf session:
  Do not fail on processing out of order event
Git-Commit-ID: f61ff6c06dc8f32c7036013ad802c899ec590607
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

Commit-ID:  f61ff6c06dc8f32c7036013ad802c899ec590607
Gitweb:     http://git.kernel.org/tip/f61ff6c06dc8f32c7036013ad802c899ec590607
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Wed, 26 Nov 2014 16:39:31 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 28 Nov 2014 18:19:37 -0300

perf session: Do not fail on processing out of order event

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
index 5699e7e..50a7b11 100644
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
index 6702ac2..80dbba0 100644
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
