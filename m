Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964905AbaLKPNp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 10:13:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45183 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964876AbaLKPNm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 10:13:42 -0500
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jeremie Galarneau <jgalar@efficios.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 7/8] perf data: Enable stream flush within processing
Date: Thu, 11 Dec 2014 16:12:28 +0100
Message-Id: <1418310749-22267-8-git-send-email-jolsa@kernel.org>
In-Reply-To: <1418310749-22267-1-git-send-email-jolsa@kernel.org>
References: <1418310749-22267-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For big data files the size of data allocated for stream
instance could get really high. It's needed to flush the
data out of the stream once in a while.

Unfortunately there's no size indication in the stream
object, so we govern the flush based on the number of
stored events. Current flush limit is set ot 100000
events.

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jeremie Galarneau <jgalar@efficios.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Tom Zanussi <tzanussi@gmail.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/util/data-convert-bt.c | 26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/data-convert-bt.c b/tools/perf/util/data-convert-bt.c
index 4bb769e081a8..3d73e51ee10d 100644
--- a/tools/perf/util/data-convert-bt.c
+++ b/tools/perf/util/data-convert-bt.c
@@ -43,6 +43,7 @@ struct evsel_priv {
 struct ctf_stream {
 	struct bt_ctf_stream *stream;
 	int cpu;
+	u32 count;
 };
 
 struct ctf_writer {
@@ -392,7 +393,10 @@ static int ctf_stream__flush(struct ctf_stream *cs)
 		if (err)
 			pr_err("CTF stream %d flush failed\n", cs->cpu);
 
-		pr("Flush stream for cpu %d\n", cs->cpu);
+		pr("Flush stream for cpu %d (%u samples)\n",
+		   cs->cpu, cs->count);
+
+		cs->count = 0;
 	}
 
 	return err;
@@ -490,6 +494,19 @@ static int get_sample_cpu(struct ctf_writer *cw, struct perf_sample *sample,
 	return cpu;
 }
 
+#define STREAM_FLUSH_COUNT 100000
+
+/*
+ * Currently we have no other way to determine the
+ * time for the stream flush other than keep track
+ * of the number of events and check it against
+ * threshold.
+ */
+static bool is_flush_needed(struct ctf_stream *cs)
+{
+	return cs->count >= STREAM_FLUSH_COUNT;
+}
+
 static int process_sample_event(struct perf_tool *tool,
 				union perf_event *_event __maybe_unused,
 				struct perf_sample *sample,
@@ -535,8 +552,13 @@ static int process_sample_event(struct perf_tool *tool,
 	}
 
 	cs = ctf_stream(cw, get_sample_cpu(cw, sample, evsel));
-	if (cs)
+	if (cs) {
+		if (is_flush_needed(cs))
+			ctf_stream__flush(cs);
+
+		cs->count++;
 		bt_ctf_stream_append_event(cs->stream, event);
+	}
 
 	bt_ctf_event_put(event);
 	return cs ? 0 : -1;
-- 
1.9.3

