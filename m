Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751473AbaAOFDZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 00:03:25 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:50684 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286AbaAOFDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 00:03:23 -0500
X-AuditID: 9c930197-b7b7cae000000e34-3f-52d61698147b
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 01/17] tools lib traceevent: Add state member to struct trace_seq
References: <1389750340-15965-1-git-send-email-namhyung@kernel.org>
	<1389750340-15965-2-git-send-email-namhyung@kernel.org>
	<20140114210058.6b75c47a@gandalf.local.home>
	<87k3e29cxz.fsf@sejong.aot.lge.com>
	<20140114215655.666d7480@gandalf.local.home>
Date: Wed, 15 Jan 2014 14:03:20 +0900
In-Reply-To: <20140114215655.666d7480@gandalf.local.home> (Steven Rostedt's
	message of "Tue, 14 Jan 2014 21:56:55 -0500")
Message-ID: <87fvopalbb.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Jan 2014 21:56:55 -0500, Steven Rostedt wrote:
> On Wed, 15 Jan 2014 11:49:28 +0900
> Namhyung Kim <namhyung@kernel.org> wrote:
>> Oh, it looks better.  But I'd like to TRACE_SEQ_CHECK() as is for some
>> cases.  How about this?
>
> Looks good to me.
>
> Acked-by: Steven Rostedt <rostedt@goodmis.org>
>
> I'll try to look at the rest of the patches tomorrow.

Thanks, and I found that trace_seq_destroy() should use
TRACE_SEQ_TRACE_RET instead.  Here's an updated patch.

Thanks,
Namhyung


>From 539a5dd1cb3ba4cb03c283115a9a84f8e345514e Mon Sep 17 00:00:00 2001
From: Namhyung Kim <namhyung@kernel.org>
Date: Thu, 19 Dec 2013 18:17:44 +0900
Subject: [PATCH] tools lib traceevent: Add state member to struct trace_seq

The trace_seq->state is for tracking errors during the use of
trace_seq APIs and getting rid of die() in it.

Acked-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/traceevent/Makefile      |  2 +-
 tools/lib/traceevent/event-parse.h |  7 +++++
 tools/lib/traceevent/trace-seq.c   | 55 +++++++++++++++++++++++++++++---------
 3 files changed, 50 insertions(+), 14 deletions(-)

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
index d7f2e68bc5b9..f7112138e6af 100644
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
-- 
1.7.11.7

