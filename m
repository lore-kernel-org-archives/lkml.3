Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272AbaAPNoz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 08:44:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38261 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389AbaAPNiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 08:38:09 -0500
Date: Thu, 16 Jan 2014 05:37:34 -0800
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-3c6d8d84423932f1d9949179c6acdf2405515ee4@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <87fvopalbb.fsf@sejong.aot.lge.com>
References: <87fvopalbb.fsf@sejong.aot.lge.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent:
  Add state member to struct trace_seq
Git-Commit-ID: 3c6d8d84423932f1d9949179c6acdf2405515ee4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 16 Jan 2014 05:37:41 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3c6d8d84423932f1d9949179c6acdf2405515ee4
Gitweb:     http://git.kernel.org/tip/3c6d8d84423932f1d9949179c6acdf2405515ee4
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Thu, 19 Dec 2013 18:17:44 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 15 Jan 2014 15:10:19 -0300

tools lib traceevent: Add state member to struct trace_seq

The trace_seq->state is for tracking errors during the use of trace_seq
APIs and getting rid of die() in it.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Reviewed-by: Jiri Olsa <jolsa@redhat.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/87fvopalbb.fsf@sejong.aot.lge.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/Makefile      |  2 +-
 tools/lib/traceevent/event-parse.h |  7 +++++
 tools/lib/traceevent/trace-seq.c   | 55 +++++++++++++++++++++++++++++---------
 3 files changed, 50 insertions(+), 14 deletions(-)

diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
index f778d48..56d52a3 100644
--- a/tools/lib/traceevent/Makefile
+++ b/tools/lib/traceevent/Makefile
@@ -136,7 +136,7 @@ export Q VERBOSE
 
 EVENT_PARSE_VERSION = $(EP_VERSION).$(EP_PATCHLEVEL).$(EP_EXTRAVERSION)
 
-INCLUDES = -I. $(CONFIG_INCLUDES)
+INCLUDES = -I. -I $(srctree)/../../include $(CONFIG_INCLUDES)
 
 # Set compile option CFLAGS if not set elsewhere
 CFLAGS ?= -g -Wall
diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index cf5db90..3c890cb 100644
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
index d7f2e68..f711213 100644
--- a/tools/lib/traceevent/trace-seq.c
+++ b/tools/lib/traceevent/trace-seq.c
@@ -22,6 +22,7 @@
 #include <string.h>
 #include <stdarg.h>
 
+#include <asm/bug.h>
 #include "event-parse.h"
 #include "event-utils.h"
 
@@ -32,10 +33,21 @@
 #define TRACE_SEQ_POISON	((void *)0xdeadbeef)
 #define TRACE_SEQ_CHECK(s)						\
 do {									\
-	if ((s)->buffer == TRACE_SEQ_POISON)			\
-		die("Usage of trace_seq after it was destroyed");	\
+	if (WARN_ONCE((s)->buffer == TRACE_SEQ_POISON,			\
+		      "Usage of trace_seq after it was destroyed"))	\
+		(s)->state = TRACE_SEQ__BUFFER_POISONED;		\
 } while (0)
 
+#define TRACE_SEQ_CHECK_RET_N(s, n)		\
+do {						\
+	TRACE_SEQ_CHECK(s);			\
+	if ((s)->state != TRACE_SEQ__GOOD)	\
+		return n; 			\
+} while (0)
+
+#define TRACE_SEQ_CHECK_RET(s)   TRACE_SEQ_CHECK_RET_N(s, )
+#define TRACE_SEQ_CHECK_RET0(s)  TRACE_SEQ_CHECK_RET_N(s, 0)
+
 /**
  * trace_seq_init - initialize the trace_seq structure
  * @s: a pointer to the trace_seq structure to initialize
@@ -46,6 +58,7 @@ void trace_seq_init(struct trace_seq *s)
 	s->readpos = 0;
 	s->buffer_size = TRACE_SEQ_BUF_SIZE;
 	s->buffer = malloc_or_die(s->buffer_size);
+	s->state = TRACE_SEQ__GOOD;
 }
 
 /**
@@ -71,7 +84,7 @@ void trace_seq_destroy(struct trace_seq *s)
 {
 	if (!s)
 		return;
-	TRACE_SEQ_CHECK(s);
+	TRACE_SEQ_CHECK_RET(s);
 	free(s->buffer);
 	s->buffer = TRACE_SEQ_POISON;
 }
@@ -80,8 +93,9 @@ static void expand_buffer(struct trace_seq *s)
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
@@ -105,9 +119,9 @@ trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
 	int len;
 	int ret;
 
-	TRACE_SEQ_CHECK(s);
-
  try_again:
+	TRACE_SEQ_CHECK_RET0(s);
+
 	len = (s->buffer_size - 1) - s->len;
 
 	va_start(ap, fmt);
@@ -141,9 +155,9 @@ trace_seq_vprintf(struct trace_seq *s, const char *fmt, va_list args)
 	int len;
 	int ret;
 
-	TRACE_SEQ_CHECK(s);
-
  try_again:
+	TRACE_SEQ_CHECK_RET0(s);
+
 	len = (s->buffer_size - 1) - s->len;
 
 	ret = vsnprintf(s->buffer + s->len, len, fmt, args);
@@ -172,13 +186,15 @@ int trace_seq_puts(struct trace_seq *s, const char *str)
 {
 	int len;
 
-	TRACE_SEQ_CHECK(s);
+	TRACE_SEQ_CHECK_RET0(s);
 
 	len = strlen(str);
 
 	while (len > ((s->buffer_size - 1) - s->len))
 		expand_buffer(s);
 
+	TRACE_SEQ_CHECK_RET0(s);
+
 	memcpy(s->buffer + s->len, str, len);
 	s->len += len;
 
@@ -187,11 +203,13 @@ int trace_seq_puts(struct trace_seq *s, const char *str)
 
 int trace_seq_putc(struct trace_seq *s, unsigned char c)
 {
-	TRACE_SEQ_CHECK(s);
+	TRACE_SEQ_CHECK_RET0(s);
 
 	while (s->len >= (s->buffer_size - 1))
 		expand_buffer(s);
 
+	TRACE_SEQ_CHECK_RET0(s);
+
 	s->buffer[s->len++] = c;
 
 	return 1;
@@ -199,7 +217,7 @@ int trace_seq_putc(struct trace_seq *s, unsigned char c)
 
 void trace_seq_terminate(struct trace_seq *s)
 {
-	TRACE_SEQ_CHECK(s);
+	TRACE_SEQ_CHECK_RET(s);
 
 	/* There's always one character left on the buffer */
 	s->buffer[s->len] = 0;
@@ -208,5 +226,16 @@ void trace_seq_terminate(struct trace_seq *s)
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
