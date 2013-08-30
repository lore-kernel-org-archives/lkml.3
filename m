Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757056Ab3H3S7U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 14:59:20 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45600 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756855Ab3H3S7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 14:59:16 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 03/15] perf callchain: Remove unnecessary validation
Date: Fri, 30 Aug 2013 15:58:46 -0300
Message-Id: <1377889138-8793-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1377889138-8793-1-git-send-email-acme@infradead.org>
References: <1377889138-8793-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

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
-- 
1.8.1.4

