Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731AbaJWKr1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 06:47:27 -0400
Received: from mga02.intel.com ([134.134.136.20]:19432 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753934AbaJWKrF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 06:47:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,774,1406617200"; 
   d="scan'208";a="594445898"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 03/16] perf session: Add perf_session__deliver_synth_event()
Date: Thu, 23 Oct 2014 13:45:11 +0300
Message-Id: <1414061124-26830-4-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414061124-26830-1-git-send-email-adrian.hunter@intel.com>
References: <1414061124-26830-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a function to deliver synthesized events from
within a session.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/session.c | 14 ++++++++++++++
 tools/perf/util/session.h |  5 +++++
 2 files changed, 19 insertions(+)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index d70e37d..09635d1 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -907,6 +907,20 @@ static s64 perf_session__process_user_event(struct perf_session *session,
 	}
 }
 
+int perf_session__deliver_synth_event(struct perf_session *session,
+				      union perf_event *event,
+				      struct perf_sample *sample,
+				      struct perf_tool *tool)
+{
+	events_stats__inc(&session->stats, event->header.type);
+
+	if (event->header.type >= PERF_RECORD_USER_TYPE_START)
+		return perf_session__process_user_event(session, event, tool,
+							0);
+
+	return perf_session__deliver_event(session, event, sample, tool, 0);
+}
+
 static void event_swap(union perf_event *event, bool sample_id_all)
 {
 	perf_event__swap_op swap;
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index d8521ac..dc26ebf 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -127,6 +127,11 @@ extern volatile int session_done;
 
 #define session_done()	ACCESS_ONCE(session_done)
 
+int perf_session__deliver_synth_event(struct perf_session *session,
+				      union perf_event *event,
+				      struct perf_sample *sample,
+				      struct perf_tool *tool);
+
 int perf_event__process_id_index(struct perf_tool *tool,
 				 union perf_event *event,
 				 struct perf_session *session);
-- 
1.9.1

