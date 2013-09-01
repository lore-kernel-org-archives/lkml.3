Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757496Ab3IAKiK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 06:38:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11889 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757459Ab3IAKiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 06:38:04 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 04/25] perf tools: Adding throttle event data struct support
Date: Sun,  1 Sep 2013 12:36:15 +0200
Message-Id: <1378031796-17892-5-git-send-email-jolsa@redhat.com>
In-Reply-To: <1378031796-17892-1-git-send-email-jolsa@redhat.com>
References: <1378031796-17892-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moving 'struct throttle_event' out of python code and
making it global as any other event.

There's no usage of throttling events in any perf commands
so far (besides python support), but we'll need this event
data backup for upcomming test.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: David Ahern <dsahern@gmail.com>
---
 tools/perf/util/event.h   |  7 +++++++
 tools/perf/util/python.c  |  7 -------
 tools/perf/util/session.c | 13 +++++++++++++
 3 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 93130d8..4971bfc 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -48,6 +48,12 @@ struct read_event {
 	u64 id;
 };
 
+struct throttle_event {
+	struct perf_event_header header;
+	u64 time;
+	u64 id;
+	u64 stream_id;
+};
 
 #define PERF_SAMPLE_MASK				\
 	(PERF_SAMPLE_IP | PERF_SAMPLE_TID |		\
@@ -163,6 +169,7 @@ union perf_event {
 	struct fork_event		fork;
 	struct lost_event		lost;
 	struct read_event		read;
+	struct throttle_event		throttle;
 	struct sample_event		sample;
 	struct attr_event		attr;
 	struct event_type_event		event_type;
diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index 381f4fd..aa76519 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -33,13 +33,6 @@ int eprintf(int level, const char *fmt, ...)
 # define PyVarObject_HEAD_INIT(type, size) PyObject_HEAD_INIT(type) size,
 #endif
 
-struct throttle_event {
-	struct perf_event_header header;
-	u64			 time;
-	u64			 id;
-	u64			 stream_id;
-};
-
 PyMODINIT_FUNC initperf(void);
 
 #define member_def(type, member, ptype, help) \
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 07642a7..787c234 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -376,6 +376,17 @@ static void perf_event__read_swap(union perf_event *event, bool sample_id_all)
 		swap_sample_id_all(event, &event->read + 1);
 }
 
+static void perf_event__throttle_swap(union perf_event *event,
+				      bool sample_id_all)
+{
+	event->throttle.time	  = bswap_64(event->throttle.time);
+	event->throttle.id	  = bswap_64(event->throttle.id);
+	event->throttle.stream_id = bswap_64(event->throttle.stream_id);
+
+	if (sample_id_all)
+		swap_sample_id_all(event, &event->throttle + 1);
+}
+
 static u8 revbyte(u8 b)
 {
 	int rev = (b >> 4) | ((b & 0xf) << 4);
@@ -460,6 +471,8 @@ static perf_event__swap_op perf_event__swap_ops[] = {
 	[PERF_RECORD_EXIT]		  = perf_event__task_swap,
 	[PERF_RECORD_LOST]		  = perf_event__all64_swap,
 	[PERF_RECORD_READ]		  = perf_event__read_swap,
+	[PERF_RECORD_THROTTLE]		  = perf_event__throttle_swap,
+	[PERF_RECORD_UNTHROTTLE]	  = perf_event__throttle_swap,
 	[PERF_RECORD_SAMPLE]		  = perf_event__all64_swap,
 	[PERF_RECORD_HEADER_ATTR]	  = perf_event__hdr_attr_swap,
 	[PERF_RECORD_HEADER_EVENT_TYPE]	  = perf_event__event_type_swap,
-- 
1.7.11.7

