Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932546Ab3JNUXL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:23:11 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39014 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757704Ab3JNUDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:03:06 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Andi Kleen <ak@linux.intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 088/161] perf tools: Adding throttle event data struct support
Date: Mon, 14 Oct 2013 17:01:17 -0300
Message-Id: <1381780950-25642-89-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Moving 'struct throttle_event' out of python code and making it global
as any other event.

There's no usage of throttling events in any perf commands so far
(besides python support), but we'll need this event data backup for
upcoming test.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1378031796-17892-5-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/event.h   |  7 +++++++
 tools/perf/util/python.c  |  7 -------
 tools/perf/util/session.c | 13 +++++++++++++
 3 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 17d9e167a7b9..9b7d4d333111 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -61,6 +61,12 @@ struct read_event {
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
@@ -178,6 +184,7 @@ union perf_event {
 	struct fork_event		fork;
 	struct lost_event		lost;
 	struct read_event		read;
+	struct throttle_event		throttle;
 	struct sample_event		sample;
 	struct attr_event		attr;
 	struct event_type_event		event_type;
diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index a24ce0a6a941..06efd027b1db 100644
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
index b97f468af955..d1e449534b33 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -397,6 +397,17 @@ static void perf_event__read_swap(union perf_event *event, bool sample_id_all)
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
@@ -482,6 +493,8 @@ static perf_event__swap_op perf_event__swap_ops[] = {
 	[PERF_RECORD_EXIT]		  = perf_event__task_swap,
 	[PERF_RECORD_LOST]		  = perf_event__all64_swap,
 	[PERF_RECORD_READ]		  = perf_event__read_swap,
+	[PERF_RECORD_THROTTLE]		  = perf_event__throttle_swap,
+	[PERF_RECORD_UNTHROTTLE]	  = perf_event__throttle_swap,
 	[PERF_RECORD_SAMPLE]		  = perf_event__all64_swap,
 	[PERF_RECORD_HEADER_ATTR]	  = perf_event__hdr_attr_swap,
 	[PERF_RECORD_HEADER_EVENT_TYPE]	  = perf_event__event_type_swap,
-- 
1.8.1.4

