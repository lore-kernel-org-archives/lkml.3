Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758027Ab3K0URs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 15:17:48 -0500
Received: from merlin.infradead.org ([205.233.59.134]:32892 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757940Ab3K0URI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 15:17:08 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 23/34] perf thread: Move comm_list check into function
Date: Wed, 27 Nov 2013 17:16:23 -0300
Message-Id: <1385583394-3703-24-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1385583394-3703-1-git-send-email-acme@infradead.org>
References: <1385583394-3703-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1384806771-2945-5-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/event.c  |  3 +--
 tools/perf/util/thread.h | 12 ++++++++++++
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index bb788c109fe6..c77814bf01e1 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -732,8 +732,7 @@ int perf_event__preprocess_sample(const union perf_event *event,
 	if (thread == NULL)
 		return -1;
 
-	if (symbol_conf.comm_list &&
-	    !strlist__has_entry(symbol_conf.comm_list, thread__comm_str(thread)))
+	if (thread__is_filtered(thread))
 		goto out_filtered;
 
 	dump_printf(" ... thread: %s:%d\n", thread__comm_str(thread), thread->tid);
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index 897c1b2a750a..5b856bf942e1 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -6,6 +6,7 @@
 #include <unistd.h>
 #include <sys/types.h>
 #include "symbol.h"
+#include <strlist.h>
 
 struct thread {
 	union {
@@ -66,4 +67,15 @@ static inline void thread__set_priv(struct thread *thread, void *p)
 {
 	thread->priv = p;
 }
+
+static inline bool thread__is_filtered(struct thread *thread)
+{
+	if (symbol_conf.comm_list &&
+	    !strlist__has_entry(symbol_conf.comm_list, thread__comm_str(thread))) {
+		return true;
+	}
+
+	return false;
+}
+
 #endif	/* __PERF_THREAD_H */
-- 
1.8.1.4

