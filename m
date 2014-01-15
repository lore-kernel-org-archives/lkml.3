Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751989AbaAOBpp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 20:45:45 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:43403 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbaAOBpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 20:45:42 -0500
X-AuditID: 9c930197-b7b7cae000000e34-44-52d5e844acc2
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 01/17] tools lib traceevent: Add state member to struct trace_seq
Date: Wed, 15 Jan 2014 10:45:24 +0900
Message-Id: <1389750340-15965-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1389750340-15965-1-git-send-email-namhyung@kernel.org>
References: <1389750340-15965-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The trace_seq->state is for tracking errors during the use of
trace_seq APIs and getting rid of die() in it.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/traceevent/Makefile      |  2 +-
 tools/lib/traceevent/event-parse.h |  7 ++++++
 tools/lib/traceevent/trace-seq.c   | 46 +++++++++++++++++++++++++++++++++-----
 3 files changed, 49 insertions(+), 6 deletions(-)

diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
index f778d48ac609..56d52a33a3df 100644
--- a/tools/lib/traceevent/Makefile
+++ b/tools/lib/traceevent/Makefile
@@ -136,7 +136,7 @@ export Q VERBOSE
 
 EVENT_PARSE_VERSION = $(EP_VERSION).$(EP_PATCHLEVEL).$(EP_EXTRAVERSION)
 
-INCLUDES = -I. $(CONFIG_INCLUDES)
+INCLUDES = -I. -I $(srctree)/../../include $(CONFIG_INCLUDES)
 
 # Set compile option CFLAGS if not set elsewhere
 CFLAGS ?= -g -Wall
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
index d7f2e68bc5b9..7f24e8989401 100644
--- a/tools/lib/traceevent/trace-seq.c
+++ b/tools/lib/traceevent/trace-seq.c
@@ -22,6 +22,7 @@
 #include <string.h>
 #include <stdarg.h>
 
+#include <asm/bug.h>
 #include "event-parse.h"
 #include "event-utils.h"
 
@@ -32,8 +33,9 @@
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
@@ -46,6 +48,7 @@ void trace_seq_init(struct trace_seq *s)
 	s->readpos = 0;
 	s->buffer_size = TRACE_SEQ_BUF_SIZE;
 	s->buffer = malloc_or_die(s->buffer_size);
+	s->state = TRACE_SEQ__GOOD;
 }
 
 /**
@@ -80,8 +83,9 @@ static void expand_buffer(struct trace_seq *s)
 {
 	s->buffer_size += TRACE_SEQ_BUF_SIZE;
 	s->buffer = realloc(s->buffer, s->buffer_size);
-	if (!s->buffer)
-		die("Can't allocate trace_seq buffer memory");
+	if (WARN_ONCE(!s->buffer,
+		      "Can't allocate trace_seq buffer memory"))
+		s->state = TRACE_SEQ__MEM_ALLOC_FAILED;
 }
 
 /**
@@ -108,6 +112,9 @@ trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
 	TRACE_SEQ_CHECK(s);
 
  try_again:
+	if (s->state != TRACE_SEQ__GOOD)
+		return 0;
+
 	len = (s->buffer_size - 1) - s->len;
 
 	va_start(ap, fmt);
@@ -144,6 +151,9 @@ trace_seq_vprintf(struct trace_seq *s, const char *fmt, va_list args)
 	TRACE_SEQ_CHECK(s);
 
  try_again:
+	if (s->state != TRACE_SEQ__GOOD)
+		return 0;
+
 	len = (s->buffer_size - 1) - s->len;
 
 	ret = vsnprintf(s->buffer + s->len, len, fmt, args);
@@ -174,11 +184,17 @@ int trace_seq_puts(struct trace_seq *s, const char *str)
 
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
 
@@ -189,9 +205,15 @@ int trace_seq_putc(struct trace_seq *s, unsigned char c)
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
@@ -201,6 +223,9 @@ void trace_seq_terminate(struct trace_seq *s)
 {
 	TRACE_SEQ_CHECK(s);
 
+	if (s->state != TRACE_SEQ__GOOD)
+		return;
+
 	/* There's always one character left on the buffer */
 	s->buffer[s->len] = 0;
 }
@@ -208,5 +233,16 @@ void trace_seq_terminate(struct trace_seq *s)
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

