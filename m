Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358Ab3H1PDQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 11:03:16 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40602 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754013Ab3H1O7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 10:59:53 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 11/21] perf trace: Hide sys_exit messages about syscall id = -1
Date: Wed, 28 Aug 2013 11:59:27 -0300
Message-Id: <1377701977-2085-12-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1377701977-2085-1-git-send-email-acme@infradead.org>
References: <1377701977-2085-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

That was reproduced via ftrace as described in this cset comment log,
need to investigate further.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-n1i3m0vo6mgq3ddjj95sls2s@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index c907e7e..c3caabb 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -298,7 +298,22 @@ static struct syscall *trace__syscall_info(struct trace *trace,
 	int id = perf_evsel__intval(evsel, sample, "id");
 
 	if (id < 0) {
-		fprintf(trace->output, "Invalid syscall %d id, skipping...\n", id);
+
+		/*
+		 * XXX: Noticed on x86_64, reproduced as far back as 3.0.36, haven't tried
+		 * before that, leaving at a higher verbosity level till that is
+		 * explained. Reproduced with plain ftrace with:
+		 *
+		 * echo 1 > /t/events/raw_syscalls/sys_exit/enable
+		 * grep "NR -1 " /t/trace_pipe
+		 *
+		 * After generating some load on the machine.
+ 		 */
+		if (verbose > 1) {
+			static u64 n;
+			fprintf(trace->output, "Invalid syscall %d id, skipping (%s, %" PRIu64 ") ...\n",
+				id, perf_evsel__name(evsel), ++n);
+		}
 		return NULL;
 	}
 
-- 
1.8.1.4

