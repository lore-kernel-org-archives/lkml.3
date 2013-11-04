Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986Ab3KDUUa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 15:20:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49906 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753919Ab3KDUUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 15:20:21 -0500
Date: Mon, 4 Nov 2013 12:20:05 -0800
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-n6pykiiymtgmcjs834go2t8x@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Get current comm instead of last one
Git-Commit-ID: 4dfced359fbc719a35527416f1b4b3999647f68b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 04 Nov 2013 12:20:11 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4dfced359fbc719a35527416f1b4b3999647f68b
Gitweb:     http://git.kernel.org/tip/4dfced359fbc719a35527416f1b4b3999647f68b
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Fri, 13 Sep 2013 16:28:57 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 4 Nov 2013 12:16:39 -0300

perf tools: Get current comm instead of last one

At insert time, a hist entry should reference comm at the time otherwise
it'll get the last comm anyway.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Tested-by: Jiri Olsa <jolsa@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/n/tip-n6pykiiymtgmcjs834go2t8x@git.kernel.org
[ Fixed up const pointer issues ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/comm.c   | 15 +++++++++++++++
 tools/perf/util/comm.h   |  1 +
 tools/perf/util/hist.c   |  3 +++
 tools/perf/util/sort.c   | 14 +++++---------
 tools/perf/util/sort.h   |  1 +
 tools/perf/util/thread.c |  6 +++---
 tools/perf/util/thread.h |  2 ++
 7 files changed, 30 insertions(+), 12 deletions(-)

diff --git a/tools/perf/util/comm.c b/tools/perf/util/comm.c
index 8b3ac9f..ee0df0e 100644
--- a/tools/perf/util/comm.c
+++ b/tools/perf/util/comm.c
@@ -94,6 +94,21 @@ struct comm *comm__new(const char *str, u64 timestamp)
 	return comm;
 }
 
+void comm__override(struct comm *comm, const char *str, u64 timestamp)
+{
+	struct comm_str *old = comm->comm_str;
+
+	comm->comm_str = comm_str__findnew(str, &comm_str_root);
+	if (!comm->comm_str) {
+		comm->comm_str = old;
+		return;
+	}
+
+	comm->start = timestamp;
+	comm_str__get(comm->comm_str);
+	comm_str__put(old);
+}
+
 void comm__free(struct comm *comm)
 {
 	comm_str__put(comm->comm_str);
diff --git a/tools/perf/util/comm.h b/tools/perf/util/comm.h
index f62d215..7a86e56 100644
--- a/tools/perf/util/comm.h
+++ b/tools/perf/util/comm.h
@@ -16,5 +16,6 @@ struct comm {
 void comm__free(struct comm *comm);
 struct comm *comm__new(const char *str, u64 timestamp);
 const char *comm__str(const struct comm *comm);
+void comm__override(struct comm *comm, const char *str, u64 timestamp);
 
 #endif  /* __PERF_COMM_H */
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 7e80253..30793f9 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -416,6 +416,7 @@ struct hist_entry *__hists__add_mem_entry(struct hists *hists,
 {
 	struct hist_entry entry = {
 		.thread	= al->thread,
+		.comm = thread__comm(al->thread),
 		.ms = {
 			.map	= al->map,
 			.sym	= al->sym,
@@ -446,6 +447,7 @@ struct hist_entry *__hists__add_branch_entry(struct hists *hists,
 {
 	struct hist_entry entry = {
 		.thread	= al->thread,
+		.comm = thread__comm(al->thread),
 		.ms = {
 			.map	= bi->to.map,
 			.sym	= bi->to.sym,
@@ -475,6 +477,7 @@ struct hist_entry *__hists__add_entry(struct hists *hists,
 {
 	struct hist_entry entry = {
 		.thread	= al->thread,
+		.comm = thread__comm(al->thread),
 		.ms = {
 			.map	= al->map,
 			.sym	= al->sym,
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index bf91d0e..3c1b75c 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -1,5 +1,6 @@
 #include "sort.h"
 #include "hist.h"
+#include "comm.h"
 #include "symbol.h"
 
 regex_t		parent_regex;
@@ -81,25 +82,20 @@ static int64_t
 sort__comm_cmp(struct hist_entry *left, struct hist_entry *right)
 {
 	/* Compare the addr that should be unique among comm */
-	return thread__comm_str(right->thread) - thread__comm_str(left->thread);
+	return comm__str(right->comm) - comm__str(left->comm);
 }
 
 static int64_t
 sort__comm_collapse(struct hist_entry *left, struct hist_entry *right)
 {
-	const char *comm_l = thread__comm_str(left->thread);
-	const char *comm_r = thread__comm_str(right->thread);
-
-	if (!comm_l || !comm_r)
-		return cmp_null(comm_l, comm_r);
-
-	return strcmp(comm_l, comm_r);
+	/* Compare the addr that should be unique among comm */
+	return comm__str(right->comm) - comm__str(left->comm);
 }
 
 static int hist_entry__comm_snprintf(struct hist_entry *he, char *bf,
 				     size_t size, unsigned int width)
 {
-	return repsep_snprintf(bf, size, "%*s", width, thread__comm_str(he->thread));
+	return repsep_snprintf(bf, size, "%*s", width, comm__str(he->comm));
 }
 
 struct sort_entry sort_comm = {
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index bf43336..f4e16f3 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -84,6 +84,7 @@ struct hist_entry {
 	struct he_stat		stat;
 	struct map_symbol	ms;
 	struct thread		*thread;
+	struct comm		*comm;
 	u64			ip;
 	u64			transaction;
 	s32			cpu;
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index 15c53c2..cd8e2f5 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -54,7 +54,7 @@ void thread__delete(struct thread *thread)
 	free(thread);
 }
 
-static struct comm *thread__comm(const struct thread *thread)
+struct comm *thread__comm(const struct thread *thread)
 {
 	if (list_empty(&thread->comm_list))
 		return NULL;
@@ -69,8 +69,8 @@ int thread__set_comm(struct thread *thread, const char *str, u64 timestamp)
 
 	/* Override latest entry if it had no specific time coverage */
 	if (!curr->start) {
-		list_del(&curr->list);
-		comm__free(curr);
+		comm__override(curr, str, timestamp);
+		return 0;
 	}
 
 	new = comm__new(str, timestamp);
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index 8702c6b..373c055 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -26,6 +26,7 @@ struct thread {
 };
 
 struct machine;
+struct comm;
 
 struct thread *thread__new(pid_t pid, pid_t tid);
 void thread__delete(struct thread *self);
@@ -36,6 +37,7 @@ static inline void thread__exited(struct thread *thread)
 
 int thread__set_comm(struct thread *thread, const char *comm, u64 timestamp);
 int thread__comm_len(struct thread *self);
+struct comm *thread__comm(const struct thread *thread);
 const char *thread__comm_str(const struct thread *thread);
 void thread__insert_map(struct thread *self, struct map *map);
 int thread__fork(struct thread *thread, struct thread *parent, u64 timestamp);
