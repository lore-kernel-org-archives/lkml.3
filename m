Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821Ab3IFThJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 15:37:09 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:47197 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035Ab3IFThH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 15:37:07 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH] perf session: Add option to copy events when queueing
Date: Fri,  6 Sep 2013 13:37:01 -0600
Message-Id: <1378496221-61525-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When processing events the session code has an ordered samples queue which is
used to time-sort events coming in across multiple mmaps. At a later point in
time samples on the queue are flushed up to some timestamp at which point the
event is actually processed.

When analyzing events live (ie., record/analysis path in the same command)
there is a race that leads to corrupted events and parse errors which cause
perf to terminate. The problem is that when the event is placed in the ordered
samples queue it is only a reference to the event which is really sitting in
the mmap buffer. Even though the event is queued for later processing the mmap
tail pointer is updated which indicates to the kernel that the event has been
processed. The race is flushing the event from the queue before it gets
overwritten by some other event. For commands trying to process events live
(versus just writing to a file) and processing a high rate of events this leads
to parse failures and perf terminates.

Examples hitting this problem are 'perf kvm stat live', especially with nested
VMs which generate 100,000+ traces per second, and a command processing
scheduling events with a high rate of context switching -- e.g., running
'perf bench sched pipe'.

This patch offers live commands an option to copy the event when it is placed in
the ordered samples queue.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/util/session.c |   17 ++++++++++++++---
 tools/perf/util/session.h |    1 +
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 1b185ca..71f16db 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -483,6 +483,8 @@ static void perf_session_free_sample_buffers(struct perf_session *session)
 
 		sq = list_entry(os->to_free.next, struct sample_queue, list);
 		list_del(&sq->list);
+		if (session->copy_on_queue)
+			free(sq->event);
 		free(sq);
 	}
 }
@@ -513,11 +515,15 @@ static int flush_sample_queue(struct perf_session *s,
 			break;
 
 		ret = perf_evlist__parse_sample(s->evlist, iter->event, &sample);
-		if (ret)
+		if (ret) {
 			pr_err("Can't parse sample, err = %d\n", ret);
-		else {
+			if (s->copy_on_queue)
+				free(iter->event);
+		} else {
 			ret = perf_session_deliver_event(s, iter->event, &sample, tool,
 							 iter->file_offset);
+			if (s->copy_on_queue)
+				free(iter->event);
 			if (ret)
 				return ret;
 		}
@@ -676,7 +682,12 @@ int perf_session_queue_event(struct perf_session *s, union perf_event *event,
 
 	new->timestamp = timestamp;
 	new->file_offset = file_offset;
-	new->event = event;
+
+	if (s->copy_on_queue) {
+		new->event = malloc(event->header.size);
+		memcpy(new->event, event, event->header.size);
+	} else
+		new->event = event;
 
 	__queue_event(new, s);
 
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 3aa75fb..4adfcbb 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -38,6 +38,7 @@ struct perf_session {
 	bool			fd_pipe;
 	bool			repipe;
 	struct ordered_samples	ordered_samples;
+	bool			copy_on_queue;
 	char			filename[1];
 };
 
-- 
1.7.10.1

