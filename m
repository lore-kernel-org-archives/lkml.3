Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049AbaAOUdj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 15:33:39 -0500
Received: from merlin.infradead.org ([205.233.59.134]:48477 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527AbaAOUdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 15:33:36 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 05/13] tools lib traceevent: Check return value of realloc()
Date: Wed, 15 Jan 2014 17:33:03 -0300
Message-Id: <1389817991-8145-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1389817991-8145-1-git-send-email-acme@infradead.org>
References: <1389817991-8145-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

If realloc() fails, it'll leak the buffer.  Also increate buffer size
only if the allocation succeeded.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Reviewed-by: Jiri Olsa <jolsa@redhat.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1389750340-15965-3-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/trace-seq.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/tools/lib/traceevent/trace-seq.c b/tools/lib/traceevent/trace-seq.c
index f7112138e6af..e454a2c66cac 100644
--- a/tools/lib/traceevent/trace-seq.c
+++ b/tools/lib/traceevent/trace-seq.c
@@ -91,11 +91,16 @@ void trace_seq_destroy(struct trace_seq *s)
 
 static void expand_buffer(struct trace_seq *s)
 {
-	s->buffer_size += TRACE_SEQ_BUF_SIZE;
-	s->buffer = realloc(s->buffer, s->buffer_size);
-	if (WARN_ONCE(!s->buffer,
-		      "Can't allocate trace_seq buffer memory"))
+	char *buf;
+
+	buf = realloc(s->buffer, s->buffer_size + TRACE_SEQ_BUF_SIZE);
+	if (WARN_ONCE(!buf, "Can't allocate trace_seq buffer memory")) {
 		s->state = TRACE_SEQ__MEM_ALLOC_FAILED;
+		return;
+	}
+
+	s->buffer = buf;
+	s->buffer_size += TRACE_SEQ_BUF_SIZE;
 }
 
 /**
-- 
1.8.1.4

