Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757911Ab3JOFZy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:25:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33108 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589Ab3JOFZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:25:48 -0400
Date: Mon, 14 Oct 2013 22:25:21 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-dd96c46b5c765a779d8c35cc7d1df7515b4c7baf@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        ak@linux.intel.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, ak@linux.intel.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1378031796-17892-5-git-send-email-jolsa@redhat.com>
References: <1378031796-17892-5-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Adding throttle event data struct support
Git-Commit-ID: dd96c46b5c765a779d8c35cc7d1df7515b4c7baf
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:25:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dd96c46b5c765a779d8c35cc7d1df7515b4c7baf
Gitweb:     http://git.kernel.org/tip/dd96c46b5c765a779d8c35cc7d1df7515b4c7baf
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Sun, 1 Sep 2013 12:36:15 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 9 Oct 2013 11:39:18 -0300

perf tools: Adding throttle event data struct support

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
index 17d9e16..9b7d4d3 100644
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
index a24ce0a..06efd02 100644
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
index b97f468..d1e4495 100644
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
