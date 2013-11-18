Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130Ab3KRUdZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 15:33:25 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:51603 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608Ab3KRUdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 15:33:06 -0500
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 4/8] perf thread: Move comm_list check into function
Date: Mon, 18 Nov 2013 13:32:47 -0700
Message-Id: <1384806771-2945-5-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.8.3.4 (Apple Git-47)
In-Reply-To: <1384806771-2945-1-git-send-email-dsahern@gmail.com>
References: <1384806771-2945-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Stephane Eranian <eranian@google.com>
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
1.8.3.4 (Apple Git-47)

