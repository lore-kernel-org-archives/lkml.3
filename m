Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781AbaAQPBJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 10:01:09 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36310 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375AbaAQO5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 09:57:41 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 17/19] perf tools: Do proper comm override error handling
Date: Fri, 17 Jan 2014 11:57:23 -0300
Message-Id: <1389970645-12075-18-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1389970645-12075-1-git-send-email-acme@infradead.org>
References: <1389970645-12075-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>

The comm overriding API ignores memory allocation failures by silently
keeping the previous and out of date comm.

As a result, the user may get buggy events without ever being notified
about the problem and its source.

Lets start to fix this by propagating the error from the API. Not all
callers may be doing proper error handling on comm set yet but this is
the first step toward it.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1389713836-13375-2-git-send-email-fweisbec@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/comm.c   | 19 ++++++++++---------
 tools/perf/util/comm.h   |  2 +-
 tools/perf/util/thread.c |  5 ++++-
 3 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/tools/perf/util/comm.c b/tools/perf/util/comm.c
index 67d1e404c0cb..f9e777629e21 100644
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
index 7a86e5656710..fac5bd51befc 100644
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
index e3948612543e..0358882c8910 100644
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
1.8.1.4

