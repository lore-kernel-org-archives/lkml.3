Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751983AbaKKOSt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 09:18:49 -0500
Received: from mga01.intel.com ([192.55.52.88]:55261 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751883AbaKKOSr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 09:18:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,361,1413270000"; 
   d="scan'208";a="630151533"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 03/25] perf tools: Only override the default :tid comm entry
Date: Tue, 11 Nov 2014 16:16:41 +0200
Message-Id: <1415715423-15563-4-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415715423-15563-1-git-send-email-adrian.hunter@intel.com>
References: <1415715423-15563-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Events may still be ordered even if there are no
timestamps e.g. if the data is recorded per-thread.

Also synthesized COMM events have a timestamp of zero.

Consequently it is better to keep comm entries even
if they have a timestamp of zero.

However, when a struct thread is created the command
string is not known and a comm entry with a string
of the form ":<tid>" is used.  In that case
thread->comm_set is false and the comm entry should
be overridden.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/thread.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index a2157f0..9ebc8b1 100644
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
1.9.1

