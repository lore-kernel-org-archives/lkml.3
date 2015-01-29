Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755003AbbA2IRR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 03:17:17 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:51279 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020AbbA2IKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 03:10:10 -0500
X-Original-SENDERIP: 10.177.220.203
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 18/42] perf tools: Introduce thread__comm_time() helpers
Date: Thu, 29 Jan 2015 17:06:59 +0900
Message-Id: <1422518843-25818-19-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1422518843-25818-1-git-send-email-namhyung@kernel.org>
References: <1422518843-25818-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When data file indexing is enabled, it processes all task, comm and mmap
events first and then goes to the sample events.  So all it sees is the
last comm of a thread although it has information at the time of sample.

Sort thread's comm by time so that it can find appropriate comm at the
sample time.  The thread__comm_time() will mostly work even if
PERF_SAMPLE_TIME bit is off since in that case, sample->time will be
-1 so it'll take the last comm anyway.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/thread.c | 33 ++++++++++++++++++++++++++++++++-
 tools/perf/util/thread.h |  2 ++
 2 files changed, 34 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index 9ebc8b1f9be5..ad96725105c2 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -103,6 +103,21 @@ struct comm *thread__exec_comm(const struct thread *thread)
 	return last;
 }
 
+struct comm *thread__comm_time(const struct thread *thread, u64 timestamp)
+{
+	struct comm *comm;
+
+	list_for_each_entry(comm, &thread->comm_list, list) {
+		if (timestamp >= comm->start)
+			return comm;
+	}
+
+	if (list_empty(&thread->comm_list))
+		return NULL;
+
+	return list_last_entry(&thread->comm_list, struct comm, list);
+}
+
 int __thread__set_comm(struct thread *thread, const char *str, u64 timestamp,
 		       bool exec)
 {
@@ -118,7 +133,13 @@ int __thread__set_comm(struct thread *thread, const char *str, u64 timestamp,
 		new = comm__new(str, timestamp, exec);
 		if (!new)
 			return -ENOMEM;
-		list_add(&new->list, &thread->comm_list);
+
+		/* sort by time */
+		list_for_each_entry(curr, &thread->comm_list, list) {
+			if (timestamp >= curr->start)
+				break;
+		}
+		list_add_tail(&new->list, &curr->list);
 
 		if (exec)
 			unwind__flush_access(thread);
@@ -139,6 +160,16 @@ const char *thread__comm_str(const struct thread *thread)
 	return comm__str(comm);
 }
 
+const char *thread__comm_str_time(const struct thread *thread, u64 timestamp)
+{
+	const struct comm *comm = thread__comm_time(thread, timestamp);
+
+	if (!comm)
+		return NULL;
+
+	return comm__str(comm);
+}
+
 /* CHECKME: it should probably better return the max comm len from its comm list */
 int thread__comm_len(struct thread *thread)
 {
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index 160fd066a7d1..be67c3bad5e7 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -53,7 +53,9 @@ static inline int thread__set_comm(struct thread *thread, const char *comm,
 int thread__comm_len(struct thread *thread);
 struct comm *thread__comm(const struct thread *thread);
 struct comm *thread__exec_comm(const struct thread *thread);
+struct comm *thread__comm_time(const struct thread *thread, u64 timestamp);
 const char *thread__comm_str(const struct thread *thread);
+const char *thread__comm_str_time(const struct thread *thread, u64 timestamp);
 void thread__insert_map(struct thread *thread, struct map *map);
 int thread__fork(struct thread *thread, struct thread *parent, u64 timestamp);
 size_t thread__fprintf(struct thread *thread, FILE *fp);
-- 
2.2.2

