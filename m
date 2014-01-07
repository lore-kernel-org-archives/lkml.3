Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183AbaAGDAV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 22:00:21 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:52535 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754992AbaAGDAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 22:00:18 -0500
X-AuditID: 9c930179-b7c89ae000006438-c1-52cb6dbf50d5
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 3/5] tools lib traceevent: Check return value of realloc()
Date: Tue,  7 Jan 2014 12:00:10 +0900
Message-Id: <1389063612-18173-4-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1389063612-18173-1-git-send-email-namhyung@kernel.org>
References: <1389063612-18173-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If realloc() fails, it'll leak the buffer.  Also increate buffer size
only if the allocation succeeded.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/traceevent/trace-seq.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/tools/lib/traceevent/trace-seq.c b/tools/lib/traceevent/trace-seq.c
index 1747aa50ecb0..b139d55a6bf9 100644
--- a/tools/lib/traceevent/trace-seq.c
+++ b/tools/lib/traceevent/trace-seq.c
@@ -80,10 +80,16 @@ void trace_seq_destroy(struct trace_seq *s)
 
 static void expand_buffer(struct trace_seq *s)
 {
-	s->buffer_size += TRACE_SEQ_BUF_SIZE;
-	s->buffer = realloc(s->buffer, s->buffer_size);
-	if (!s->buffer)
+	char *buf;
+
+	buf = realloc(s->buffer, s->buffer_size + TRACE_SEQ_BUF_SIZE);
+	if (!buf) {
 		s->state = TRACE_SEQ__MEM_ALLOC_FAILED;
+		return;
+	}
+
+	s->buffer = buf;
+	s->buffer_size += TRACE_SEQ_BUF_SIZE;
 }
 
 /**
-- 
1.7.11.7

