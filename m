Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757346Ab3HaISg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 04:18:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59649 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689Ab3HaIOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 04:14:46 -0400
Date: Sat, 31 Aug 2013 01:13:30 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-07940293ba7a43070cdebda952b0e6025d80a383@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, efault@gmx.de, namhyung@gmail.com,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        adrian.hunter@intel.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        efault@gmx.de, peterz@infradead.org, namhyung@kernel.org,
        namhyung@gmail.com, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <1377591794-30553-4-git-send-email-adrian.hunter@intel.com>
References: <1377591794-30553-4-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf callchain: Remove unnecessary validation
Git-Commit-ID: 07940293ba7a43070cdebda952b0e6025d80a383
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sat, 31 Aug 2013 01:13:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  07940293ba7a43070cdebda952b0e6025d80a383
Gitweb:     http://git.kernel.org/tip/07940293ba7a43070cdebda952b0e6025d80a383
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Tue, 27 Aug 2013 11:23:05 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 29 Aug 2013 15:11:29 -0300

perf callchain: Remove unnecessary validation

Now that the sample parsing correctly checks data sizes there is no
reason for it to be done again for callchains.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1377591794-30553-4-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/callchain.c |  8 --------
 tools/perf/util/callchain.h |  5 -----
 tools/perf/util/session.c   | 20 --------------------
 3 files changed, 33 deletions(-)

diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index 4fee33b..482f680 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -21,14 +21,6 @@
 
 __thread struct callchain_cursor callchain_cursor;
 
-bool ip_callchain__valid(struct ip_callchain *chain,
-			 const union perf_event *event)
-{
-	unsigned int chain_size = event->header.size;
-	chain_size -= (unsigned long)&event->ip.__more_data - (unsigned long)event;
-	return chain->nr * sizeof(u64) <= chain_size;
-}
-
 #define chain_for_each_child(child, parent)	\
 	list_for_each_entry(child, &parent->children, siblings)
 
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index 812d5a0..2b585bc 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -109,11 +109,6 @@ int callchain_append(struct callchain_root *root,
 int callchain_merge(struct callchain_cursor *cursor,
 		    struct callchain_root *dst, struct callchain_root *src);
 
-struct ip_callchain;
-union perf_event;
-
-bool ip_callchain__valid(struct ip_callchain *chain,
-			 const union perf_event *event);
 /*
  * Initialize a cursor before adding entries inside, but keep
  * the previously allocated entries as a cache.
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 57b6f38..07590c3 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -997,22 +997,6 @@ static int perf_session_deliver_event(struct perf_session *session,
 	}
 }
 
-static int perf_session__preprocess_sample(struct perf_session *session,
-					   union perf_event *event, struct perf_sample *sample)
-{
-	if (event->header.type != PERF_RECORD_SAMPLE ||
-	    !(perf_evlist__sample_type(session->evlist) & PERF_SAMPLE_CALLCHAIN))
-		return 0;
-
-	if (!ip_callchain__valid(sample->callchain, event)) {
-		pr_debug("call-chain problem with event, skipping it.\n");
-		++session->stats.nr_invalid_chains;
-		session->stats.total_invalid_chains += sample->period;
-		return -EINVAL;
-	}
-	return 0;
-}
-
 static int perf_session__process_user_event(struct perf_session *session, union perf_event *event,
 					    struct perf_tool *tool, u64 file_offset)
 {
@@ -1075,10 +1059,6 @@ static int perf_session__process_event(struct perf_session *session,
 	if (ret)
 		return ret;
 
-	/* Preprocess sample records - precheck callchains */
-	if (perf_session__preprocess_sample(session, event, &sample))
-		return 0;
-
 	if (tool->ordered_samples) {
 		ret = perf_session_queue_event(session, event, &sample,
 					       file_offset);
