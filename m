Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541AbaLXHWH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 02:22:07 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:39674 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946AbaLXHOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 02:14:54 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 11/37] perf tools: Introduce thread__comm_time() helpers
Date: Wed, 24 Dec 2014 16:15:07 +0900
Message-Id: <1419405333-27952-12-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1419405333-27952-1-git-send-email-namhyung@kernel.org>
References: <1419405333-27952-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When multi-file data storage is enabled, it processes all task, comm
and mmap events first and then goes to the sample events.  So all it
sees is the last comm of a thread although it has information at the
time of sample.

Sort thread's comm by time so that it can find appropriate comm at the
sample time.  The thread__comm_time() will mostly work even if
PERF_SAMPLE_TIME bit is off since in that case, sample->time will be
-1 so it'll take the last comm anyway.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/thread.c | 34 +++++++++++++++++++++++++++++++++-
 tools/perf/util/thread.h |  2 ++
 2 files changed, 35 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index 9ebc8b1f9be5..083fa0fcf316 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -103,6 +103,22 @@ struct comm *thread__exec_comm(const struct thread *thread)
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
+/* CHECKME: time should always be 0 if event aren't ordered */
 int __thread__set_comm(struct thread *thread, const char *str, u64 timestamp,
 		       bool exec)
 {
@@ -118,7 +134,13 @@ int __thread__set_comm(struct thread *thread, const char *str, u64 timestamp,
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
@@ -139,6 +161,16 @@ const char *thread__comm_str(const struct thread *thread)
 	return comm__str(comm);
 }
 
+const char *thread__comm_time_str(const struct thread *thread, u64 timestamp)
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
index 160fd066a7d1..0b6dcd70bc8b 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -53,7 +53,9 @@ static inline int thread__set_comm(struct thread *thread, const char *comm,
 int thread__comm_len(struct thread *thread);
 struct comm *thread__comm(const struct thread *thread);
 struct comm *thread__exec_comm(const struct thread *thread);
+struct comm *thread__comm_time(const struct thread *thread, u64 timestamp);
 const char *thread__comm_str(const struct thread *thread);
+const char *thread__comm_time_str(const struct thread *thread, u64 timestamp);
 void thread__insert_map(struct thread *thread, struct map *map);
 int thread__fork(struct thread *thread, struct thread *parent, u64 timestamp);
 size_t thread__fprintf(struct thread *thread, FILE *fp);
-- 
2.1.3

