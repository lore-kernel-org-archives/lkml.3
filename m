Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756092Ab3GKNKi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 09:10:38 -0400
Received: from mga11.intel.com ([192.55.52.93]:10789 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755885Ab3GKNIE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 09:08:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,1043,1363158000"; 
   d="scan'208";a="368612992"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH V5 06/12] perf tools: remove unnecessary callchain validation
Date: Thu, 11 Jul 2013 16:12:15 +0300
Message-Id: <1373548341-24119-7-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1373548341-24119-1-git-send-email-adrian.hunter@intel.com>
References: <1373548341-24119-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the sample parsing correctly checks data sizes
there is no reason for it to be done again for callchains.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/callchain.c |  8 --------
 tools/perf/util/callchain.h |  5 -----
 tools/perf/util/session.c   | 20 --------------------
 3 files changed, 33 deletions(-)

diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index 42b6a63..024162a 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -20,14 +20,6 @@
 
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
index 3ee9f67..988c1aa 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -103,11 +103,6 @@ int callchain_append(struct callchain_root *root,
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
index aaa7d36..a0e427b 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -898,22 +898,6 @@ static int perf_session_deliver_event(struct perf_session *session,
 	}
 }
 
-static int perf_session__preprocess_sample(struct perf_session *session,
-					   union perf_event *event, struct perf_sample *sample)
-{
-	if (event->header.type != PERF_RECORD_SAMPLE ||
-	    !sample->callchain)
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
@@ -978,10 +962,6 @@ static int perf_session__process_event(struct perf_session *session,
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
1.7.11.7

