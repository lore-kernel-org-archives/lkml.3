Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751810AbaANPhj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 10:37:39 -0500
Received: from mail-ea0-f179.google.com ([209.85.215.179]:42827 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbaANPhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 10:37:35 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 1/3] perf tools: Do proper comm override error handling
Date: Tue, 14 Jan 2014 16:37:14 +0100
Message-Id: <1389713836-13375-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1389713836-13375-1-git-send-email-fweisbec@gmail.com>
References: <1389713836-13375-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The comm overriding API ignores memory allocation failures by silently
keeping the previous and out of date comm.

As a result, the user may get buggy events without ever being notified
about the problem and its source.

Lets start to fix this by propagating the error from the API. Not all
callers may be doing proper error handling on comm set yet but this
is the first step toward it.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/util/comm.c   | 19 ++++++++++---------
 tools/perf/util/comm.h   |  2 +-
 tools/perf/util/thread.c |  5 ++++-
 3 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/tools/perf/util/comm.c b/tools/perf/util/comm.c
index 67d1e40..f9e7776 100644
--- a/tools/perf/util/comm.c
+++ b/tools/perf/util/comm.c
@@ -94,19 +94,20 @@ struct comm *comm__new(const char *str, u64 timestamp)
 	return comm;
 }
 
-void comm__override(struct comm *comm, const char *str, u64 timestamp)
+int comm__override(struct comm *comm, const char *str, u64 timestamp)
 {
-	struct comm_str *old = comm->comm_str;
+	struct comm_str *new, *old = comm->comm_str;
 
-	comm->comm_str = comm_str__findnew(str, &comm_str_root);
-	if (!comm->comm_str) {
-		comm->comm_str = old;
-		return;
-	}
+	new = comm_str__findnew(str, &comm_str_root);
+	if (!new)
+		return -ENOMEM;
 
-	comm->start = timestamp;
-	comm_str__get(comm->comm_str);
+	comm_str__get(new);
 	comm_str__put(old);
+	comm->comm_str = new;
+	comm->start = timestamp;
+
+	return 0;
 }
 
 void comm__free(struct comm *comm)
diff --git a/tools/perf/util/comm.h b/tools/perf/util/comm.h
index 7a86e56..fac5bd5 100644
--- a/tools/perf/util/comm.h
+++ b/tools/perf/util/comm.h
@@ -16,6 +16,6 @@ struct comm {
 void comm__free(struct comm *comm);
 struct comm *comm__new(const char *str, u64 timestamp);
 const char *comm__str(const struct comm *comm);
-void comm__override(struct comm *comm, const char *str, u64 timestamp);
+int comm__override(struct comm *comm, const char *str, u64 timestamp);
 
 #endif  /* __PERF_COMM_H */
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index e394861..0358882 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -66,10 +66,13 @@ struct comm *thread__comm(const struct thread *thread)
 int thread__set_comm(struct thread *thread, const char *str, u64 timestamp)
 {
 	struct comm *new, *curr = thread__comm(thread);
+	int err;
 
 	/* Override latest entry if it had no specific time coverage */
 	if (!curr->start) {
-		comm__override(curr, str, timestamp);
+		err = comm__override(curr, str, timestamp);
+		if (err)
+			return err;
 	} else {
 		new = comm__new(str, timestamp);
 		if (!new)
-- 
1.8.3.1

