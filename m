Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932514AbaKSQJQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 11:09:16 -0500
Received: from mail.kernel.org ([198.145.19.201]:51756 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932206AbaKSQFD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 11:05:03 -0500
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 16/16] perf tools: Only override the default :tid comm entry
Date: Wed, 19 Nov 2014 13:03:36 -0300
Message-Id: <1416413016-19110-17-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1416413016-19110-1-git-send-email-acme@kernel.org>
References: <1416413016-19110-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Events may still be ordered even if there are no timestamps e.g. if the
data is recorded per-thread.

Also synthesized COMM events have a timestamp of zero.

Consequently it is better to keep comm entries even if they have a
timestamp of zero.

However, when a struct thread is created the command string is not known
and a comm entry with a string of the form ":<tid>" is used.

In that case thread->comm_set is false and the comm entry should be
overridden.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1415715423-15563-4-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/thread.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index a2157f0ef1df..9ebc8b1f9be5 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -103,15 +103,14 @@ struct comm *thread__exec_comm(const struct thread *thread)
 	return last;
 }
 
-/* CHECKME: time should always be 0 if event aren't ordered */
 int __thread__set_comm(struct thread *thread, const char *str, u64 timestamp,
 		       bool exec)
 {
 	struct comm *new, *curr = thread__comm(thread);
 	int err;
 
-	/* Override latest entry if it had no specific time coverage */
-	if (!curr->start && !curr->exec) {
+	/* Override the default :tid entry */
+	if (!thread->comm_set) {
 		err = comm__override(curr, str, timestamp, exec);
 		if (err)
 			return err;
-- 
1.9.3

