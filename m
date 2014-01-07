Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932135AbaAGDAU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 22:00:20 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:42663 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757121AbaAGDAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 22:00:18 -0500
X-AuditID: 9c930179-b7c89ae000006438-bb-52cb6dbeb4de
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 2/5] tools lib traceevent: Add state member to struct trace_seq
Date: Tue,  7 Jan 2014 12:00:09 +0900
Message-Id: <1389063612-18173-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1389063612-18173-1-git-send-email-namhyung@kernel.org>
References: <1389063612-18173-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The trace_seq->state is for tracking errors during the use of
trace_seq APIs and getting rid of die() in it.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/traceevent/event-parse.h |  7 +++++++
 tools/lib/traceevent/trace-seq.c   | 42 ++++++++++++++++++++++++++++++++++----
 2 files changed, 45 insertions(+), 4 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index cf5db9013f2c..3c890cb28db7 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -58,6 +58,12 @@ struct pevent_record {
 #endif
 };
 
+enum trace_seq_fail {
+	TRACE_SEQ__GOOD,
+	TRACE_SEQ__BUFFER_POISONED,
+	TRACE_SEQ__MEM_ALLOC_FAILED,
+};
+
 /*
  * Trace sequences are used to allow a function to call several other functions
  * to create a string of data to use (up to a max of PAGE_SIZE).
@@ -68,6 +74,7 @@ struct trace_seq {
 	unsigned int		buffer_size;
 	unsigned int		len;
 	unsigned int		readpos;
+	enum trace_seq_fail	state;
 };
 
 void trace_seq_init(struct trace_seq *s);
diff --git a/tools/lib/traceevent/trace-seq.c b/tools/lib/traceevent/trace-seq.c
index d7f2e68bc5b9..1747aa50ecb0 100644
--- a/tools/lib/traceevent/trace-seq.c
+++ b/tools/lib/traceevent/trace-seq.c
@@ -32,8 +32,9 @@
 #define TRACE_SEQ_POISON	((void *)0xdeadbeef)
 #define TRACE_SEQ_CHECK(s)						\
 do {									\
-	if ((s)->buffer == TRACE_SEQ_POISON)			\
-		die("Usage of trace_seq after it was destroyed");	\
+	if (WARN_ONCE((s)->buffer == TRACE_SEQ_POISON,			\
+		      "Usage of trace_seq after it was destroyed"))	\
+		(s)->state = TRACE_SEQ__BUFFER_POISONED;		\
 } while (0)
 
 /**
@@ -46,6 +47,7 @@ void trace_seq_init(struct trace_seq *s)
 	s->readpos = 0;
 	s->buffer_size = TRACE_SEQ_BUF_SIZE;
 	s->buffer = malloc_or_die(s->buffer_size);
+	s->state = TRACE_SEQ__GOOD;
 }
 
 /**
@@ -81,7 +83,7 @@ static void expand_buffer(struct trace_seq *s)
 	s->buffer_size += TRACE_SEQ_BUF_SIZE;
 	s->buffer = realloc(s->buffer, s->buffer_size);
 	if (!s->buffer)
-		die("Can't allocate trace_seq buffer memory");
+		s->state = TRACE_SEQ__MEM_ALLOC_FAILED;
 }
 
 /**
@@ -108,6 +110,9 @@ trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
 	TRACE_SEQ_CHECK(s);
 
  try_again:
+	if (s->state != TRACE_SEQ__GOOD)
+		return 0;
+
 	len = (s->buffer_size - 1) - s->len;
 
 	va_start(ap, fmt);
@@ -144,6 +149,9 @@ trace_seq_vprintf(struct trace_seq *s, const char *fmt, va_list args)
 	TRACE_SEQ_CHECK(s);
 
  try_again:
+	if (s->state != TRACE_SEQ__GOOD)
+		return 0;
+
 	len = (s->buffer_size - 1) - s->len;
 
 	ret = vsnprintf(s->buffer + s->len, len, fmt, args);
@@ -174,11 +182,17 @@ int trace_seq_puts(struct trace_seq *s, const char *str)
 
 	TRACE_SEQ_CHECK(s);
 
+	if (s->state != TRACE_SEQ__GOOD)
+		return 0;
+
 	len = strlen(str);
 
 	while (len > ((s->buffer_size - 1) - s->len))
 		expand_buffer(s);
 
+	if (s->state != TRACE_SEQ__GOOD)
+		return 0;
+
 	memcpy(s->buffer + s->len, str, len);
 	s->len += len;
 
@@ -189,9 +203,15 @@ int trace_seq_putc(struct trace_seq *s, unsigned char c)
 {
 	TRACE_SEQ_CHECK(s);
 
+	if (s->state != TRACE_SEQ__GOOD)
+		return 0;
+
 	while (s->len >= (s->buffer_size - 1))
 		expand_buffer(s);
 
+	if (s->state != TRACE_SEQ__GOOD)
+		return 0;
+
 	s->buffer[s->len++] = c;
 
 	return 1;
@@ -201,6 +221,9 @@ void trace_seq_terminate(struct trace_seq *s)
 {
 	TRACE_SEQ_CHECK(s);
 
+	if (s->state != TRACE_SEQ__GOOD)
+		return;
+
 	/* There's always one character left on the buffer */
 	s->buffer[s->len] = 0;
 }
@@ -208,5 +231,16 @@ void trace_seq_terminate(struct trace_seq *s)
 int trace_seq_do_printf(struct trace_seq *s)
 {
 	TRACE_SEQ_CHECK(s);
-	return printf("%.*s", s->len, s->buffer);
+
+	switch (s->state) {
+	case TRACE_SEQ__GOOD:
+		return printf("%.*s", s->len, s->buffer);
+	case TRACE_SEQ__BUFFER_POISONED:
+		puts("Usage of trace_seq after it was destroyed");
+		break;
+	case TRACE_SEQ__MEM_ALLOC_FAILED:
+		puts("Can't allocate trace_seq buffer memory");
+		break;
+	}
+	return -1;
 }
-- 
1.7.11.7

