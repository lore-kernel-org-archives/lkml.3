Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756457Ab3H2KJk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 06:09:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35112 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756438Ab3H2KJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 06:09:38 -0400
Date: Thu, 29 Aug 2013 03:08:58 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-n1i3m0vo6mgq3ddjj95sls2s@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, fweisbec@gmail.com, adrian.hunter@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, fweisbec@gmail.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf trace:
  Hide sys_exit messages about syscall id = -1
Git-Commit-ID: adaa18bf5d9128c4a34f5350b1d46555a949ebc4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 29 Aug 2013 03:09:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  adaa18bf5d9128c4a34f5350b1d46555a949ebc4
Gitweb:     http://git.kernel.org/tip/adaa18bf5d9128c4a34f5350b1d46555a949ebc4
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 22 Aug 2013 17:55:25 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 26 Aug 2013 17:25:45 -0300

perf trace: Hide sys_exit messages about syscall id = -1

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
 
