Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783AbaGaGIb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 02:08:31 -0400
Received: from mga14.intel.com ([192.55.52.115]:1809 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752271AbaGaGC6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 02:02:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,770,1400050800"; 
   d="scan'208";a="569799918"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 12/31] perf session: Add perf_session__deliver_synth_event()
Date: Thu, 31 Jul 2014 09:00:55 +0300
Message-Id: <1406786474-9306-13-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1406786474-9306-1-git-send-email-adrian.hunter@intel.com>
References: <1406786474-9306-1-git-send-email-adrian.hunter@intel.com>
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
index 724e749..c831c04 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1063,6 +1063,20 @@ static s64 perf_session__process_user_event(struct perf_session *session,
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
+	return perf_session_deliver_event(session, event, sample, tool, 0);
+}
+
 static void event_swap(union perf_event *event, bool sample_id_all)
 {
 	perf_event__swap_op swap;
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 39327ca..86f1bb4 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -130,6 +130,11 @@ extern volatile int session_done;
 
 #define session_done()	(*(volatile int *)(&session_done))
 
+int perf_session__deliver_synth_event(struct perf_session *session,
+				      union perf_event *event,
+				      struct perf_sample *sample,
+				      struct perf_tool *tool);
+
 int perf_event__process_id_index(struct perf_tool *tool,
 				 union perf_event *event,
 				 struct perf_session *session);
-- 
1.8.3.2

