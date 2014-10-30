Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758851AbaJ3Gt1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 02:49:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38226 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757506AbaJ3GtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 02:49:23 -0400
Date: Wed, 29 Oct 2014 23:48:25 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-a293829df788ae96a174b315010d4b56a10e5114@git.kernel.org>
Cc: fweisbec@gmail.com, mingo@kernel.org, eranian@google.com, hpa@zytor.com,
        adrian.hunter@intel.com, dsahern@gmail.com, peterz@infradead.org,
        tglx@linutronix.de, namhyung@gmail.com, jolsa@redhat.com,
        acme@redhat.com, paulus@samba.org, linux-kernel@vger.kernel.org
Reply-To: adrian.hunter@intel.com, dsahern@gmail.com, hpa@zytor.com,
        tglx@linutronix.de, peterz@infradead.org, eranian@google.com,
        fweisbec@gmail.com, mingo@kernel.org, paulus@samba.org,
        acme@redhat.com, linux-kernel@vger.kernel.org, jolsa@redhat.com,
        namhyung@gmail.com
In-Reply-To: <1414417770-18602-3-git-send-email-adrian.hunter@intel.com>
References: <1414417770-18602-3-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf session:
  Add perf_session__deliver_synth_event()
Git-Commit-ID: a293829df788ae96a174b315010d4b56a10e5114
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

Commit-ID:  a293829df788ae96a174b315010d4b56a10e5114
Gitweb:     http://git.kernel.org/tip/a293829df788ae96a174b315010d4b56a10e5114
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Mon, 27 Oct 2014 15:49:23 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 29 Oct 2014 11:36:15 -0200

perf session: Add perf_session__deliver_synth_event()

Add a function to deliver synthesized events from within a session.

Intel PT decoding works by synthesizing events (primarily branch events)
that can then be consumed by existing tools.  This function will be used
to deliver those events.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1414417770-18602-3-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c | 13 +++++++++++++
 tools/perf/util/session.h |  5 +++++
 2 files changed, 18 insertions(+)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 58dd5ce..f4478ce 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -907,6 +907,19 @@ static s64 perf_session__process_user_event(struct perf_session *session,
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
+		return perf_session__process_user_event(session, event, tool, 0);
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
