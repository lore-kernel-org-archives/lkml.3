Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756200Ab3IZI62 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 04:58:28 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:61659 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821Ab3IZI6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 04:58:24 -0400
X-AuditID: 9c93016f-b7bc8ae000004e6e-ec-5243f726243d
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 8/8] perf tools: Get current comm instead of last one
Date: Thu, 26 Sep 2013 17:58:10 +0900
Message-Id: <1380185890-25758-9-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1380185890-25758-1-git-send-email-namhyung@kernel.org>
References: <1380185890-25758-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

At insert time, a hist entry should reference comm at the time
otherwise it'll get the last comm anyway.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
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
index 0cfb55202537..ecd3c9938d3e 100644
--- a/tools/perf/util/comm.c
+++ b/tools/perf/util/comm.c
@@ -94,6 +94,21 @@ struct comm *comm__new(const char *str, u64 timestamp)
 	return comm;
 }
 
+void comm__override(struct comm *comm, const char *str, u64 timestamp)
+{
+	struct comm_str *old = comm->comm_str;
+
+	comm->comm_str = comm_str_findnew(str, &comm_str_root);
+	if (!comm->comm_str) {
+		comm->comm_str = old;
+		return;
+	}
+
+	comm->start = timestamp;
+	comm_str_get(comm->comm_str);
+	comm_str_put(old);
+}
+
 void comm__free(struct comm *comm)
 {
 	comm_str_put(comm->comm_str);
diff --git a/tools/perf/util/comm.h b/tools/perf/util/comm.h
index f62d215bede2..b2c364b37468 100644
--- a/tools/perf/util/comm.h
+++ b/tools/perf/util/comm.h
@@ -16,5 +16,6 @@ struct comm {
 void comm__free(struct comm *comm);
 struct comm *comm__new(const char *str, u64 timestamp);
 const char *comm__str(const struct comm *comm);
+void comm__override(struct comm *self, const char *str, u64 timestamp);
 
 #endif  /* __PERF_COMM_H */
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index a2d58e7abdcf..1aa97b012a09 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -412,6 +412,7 @@ struct hist_entry *__hists__add_mem_entry(struct hists *self,
 {
 	struct hist_entry entry = {
 		.thread	= al->thread,
+		.comm = curr_comm(al->thread),
 		.ms = {
 			.map	= al->map,
 			.sym	= al->sym,
@@ -442,6 +443,7 @@ struct hist_entry *__hists__add_branch_entry(struct hists *self,
 {
 	struct hist_entry entry = {
 		.thread	= al->thread,
+		.comm = curr_comm(al->thread),
 		.ms = {
 			.map	= bi->to.map,
 			.sym	= bi->to.sym,
@@ -471,6 +473,7 @@ struct hist_entry *__hists__add_entry(struct hists *self,
 {
 	struct hist_entry entry = {
 		.thread	= al->thread,
+		.comm = curr_comm(al->thread),
 		.ms = {
 			.map	= al->map,
 			.sym	= al->sym,
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 48e6a38132c9..eefc0e623966 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -1,5 +1,6 @@
 #include "sort.h"
 #include "hist.h"
+#include "comm.h"
 #include "symbol.h"
 
 regex_t		parent_regex;
@@ -80,25 +81,20 @@ static int64_t
 sort__comm_cmp(struct hist_entry *left, struct hist_entry *right)
 {
 	/* Compare the addr that should be unique among comm */
-	return thread__comm_curr(right->thread) - thread__comm_curr(left->thread);
+	return comm__str(right->comm) - comm__str(left->comm);
 }
 
 static int64_t
 sort__comm_collapse(struct hist_entry *left, struct hist_entry *right)
 {
-	const char *comm_l = thread__comm_curr(left->thread);
-	const char *comm_r = thread__comm_curr(right->thread);
-
-	if (!comm_l || !comm_r)
-		return cmp_null(comm_l, comm_r);
-
-	return strcmp(comm_l, comm_r);
+	/* Compare the addr that should be unique among comm */
+	return comm__str(right->comm) - comm__str(left->comm);
 }
 
 static int hist_entry__comm_snprintf(struct hist_entry *self, char *bf,
 				     size_t size, unsigned int width)
 {
-	return repsep_snprintf(bf, size, "%*s", width, thread__comm_curr(self->thread));
+	return repsep_snprintf(bf, size, "%*s", width, comm__str(self->comm));
 }
 
 struct sort_entry sort_comm = {
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 4e80dbd271e7..4d0153f83e3c 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -84,6 +84,7 @@ struct hist_entry {
 	struct he_stat		stat;
 	struct map_symbol	ms;
 	struct thread		*thread;
+	struct comm		*comm;
 	u64			ip;
 	s32			cpu;
 
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index 9cb01566eff1..444de7a8527f 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -54,7 +54,7 @@ void thread__delete(struct thread *self)
 	free(self);
 }
 
-static struct comm *curr_comm(const struct thread *thread)
+struct comm *curr_comm(const struct thread *thread)
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
index 0ec37bae88d0..196c6c2dfbe1 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -26,6 +26,7 @@ struct thread {
 };
 
 struct machine;
+struct comm;
 
 struct thread *thread__new(pid_t pid, pid_t tid);
 void thread__delete(struct thread *self);
@@ -36,6 +37,7 @@ static inline void thread__exited(struct thread *thread)
 
 int thread__set_comm(struct thread *self, const char *comm, u64 timestamp);
 int thread__comm_len(struct thread *self);
+struct comm *curr_comm(const struct thread *self);
 const char *thread__comm_curr(const struct thread *thread);
 void thread__insert_map(struct thread *self, struct map *map);
 int thread__fork(struct thread *self, struct thread *parent, u64 timestamp);
-- 
1.7.11.7

