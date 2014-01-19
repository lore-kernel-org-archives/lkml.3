Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600AbaASM0O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 07:26:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56008 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217AbaASM0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 07:26:03 -0500
Date: Sun, 19 Jan 2014 04:25:08 -0800
From: tip-bot for Frederic Weisbecker <tipbot@zytor.com>
Message-ID: <tip-3178f58b989430fd0721df97bf21cf1c0e8cc419@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        adrian.hunter@intel.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <1389713836-13375-2-git-send-email-fweisbec@gmail.com>
References: <1389713836-13375-2-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Do proper comm override error handling
Git-Commit-ID: 3178f58b989430fd0721df97bf21cf1c0e8cc419
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 19 Jan 2014 04:25:14 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3178f58b989430fd0721df97bf21cf1c0e8cc419
Gitweb:     http://git.kernel.org/tip/3178f58b989430fd0721df97bf21cf1c0e8cc419
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Tue, 14 Jan 2014 16:37:14 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 16 Jan 2014 16:44:39 -0300

perf tools: Do proper comm override error handling

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
