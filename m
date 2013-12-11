Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752431Ab3LKMkp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 07:40:45 -0500
Received: from mga09.intel.com ([134.134.136.24]:40653 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752363Ab3LKMkc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 07:40:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,871,1378882800"; 
   d="scan'208";a="422886332"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH v0 31/71] perf session: Add perf_session__deliver_synth_event()
Date: Wed, 11 Dec 2013 14:36:43 +0200
Message-Id: <1386765443-26966-32-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc2
In-Reply-To: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Add a function to deliver synthesized events from
within a session.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/session.c | 14 ++++++++++++++
 tools/perf/util/session.h |  5 +++++
 2 files changed, 19 insertions(+)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 3de0831..f2ac351 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1032,6 +1032,20 @@ static s64 perf_session__process_user_event(struct perf_session *session,
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
index 60a31db..64d8145 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -129,6 +129,11 @@ extern volatile int session_done;
 
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
1.8.5.1

