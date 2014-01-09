Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242AbaAIODo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 09:03:44 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:47120 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677AbaAIOB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 09:01:28 -0500
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Jiri Olsa <jolsa@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 6/8] tools lib traceevent: Check return value of realloc()
Date: Thu,  9 Jan 2014 23:00:57 +0900
Message-Id: <1389276059-8829-7-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1389276059-8829-1-git-send-email-namhyung@kernel.org>
References: <1389276059-8829-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If realloc() fails, it'll leak the buffer.  Also increate buffer size
only if the allocation succeeded.

Acked-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/traceevent/trace-seq.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/tools/lib/traceevent/trace-seq.c b/tools/lib/traceevent/trace-seq.c
index 7f24e8989401..941d35d2cf87 100644
--- a/tools/lib/traceevent/trace-seq.c
+++ b/tools/lib/traceevent/trace-seq.c
@@ -81,11 +81,16 @@ void trace_seq_destroy(struct trace_seq *s)
 
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
1.7.9.2

