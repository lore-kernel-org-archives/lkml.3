Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020Ab3K3M4E (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 07:56:04 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59726 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637Ab3K3MxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 07:53:10 -0500
Date: Sat, 30 Nov 2013 04:52:39 -0800
From: tip-bot for David Ahern <tipbot@zytor.com>
Message-ID: <tip-1f3878c11ca8c9f2d9545ec6e1e6bb5386e0565f@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1384806771-2945-5-git-send-email-dsahern@gmail.com>
References: <1384806771-2945-5-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf thread: Move comm_list check into function
Git-Commit-ID: 1f3878c11ca8c9f2d9545ec6e1e6bb5386e0565f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sat, 30 Nov 2013 04:52:45 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1f3878c11ca8c9f2d9545ec6e1e6bb5386e0565f
Gitweb:     http://git.kernel.org/tip/1f3878c11ca8c9f2d9545ec6e1e6bb5386e0565f
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Mon, 18 Nov 2013 13:32:47 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 27 Nov 2013 14:58:37 -0300

perf thread: Move comm_list check into function

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
index bb788c1..c77814b 100644
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
index 897c1b2..5b856bf 100644
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
