Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965689AbaFSVO1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 17:14:27 -0400
Received: from mail.kernel.org ([198.145.19.201]:34153 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965506AbaFSVOY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 17:14:24 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 04/11] perf trace: Cache the is_exit syscall test
Date: Thu, 19 Jun 2014 18:13:46 -0300
Message-Id: <1403212433-2714-5-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1403212433-2714-1-git-send-email-acme@kernel.org>
References: <1403212433-2714-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

No need to use two strcmp calls per syscall entry, do it just once, when
reading the per syscall info.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-lymtxhz0mg3adyt5e2pssn8f@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 28c86e21fad9..5549cee61680 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1108,6 +1108,7 @@ struct syscall {
 	struct event_format *tp_format;
 	const char	    *name;
 	bool		    filtered;
+	bool		    is_exit;
 	struct syscall_fmt  *fmt;
 	size_t		    (**arg_scnprintf)(char *bf, size_t size, struct syscall_arg *arg);
 	void		    **arg_parm;
@@ -1473,6 +1474,8 @@ static int trace__read_syscall_info(struct trace *trace, int id)
 	if (sc->tp_format == NULL)
 		return -1;
 
+	sc->is_exit = !strcmp(name, "exit_group") || !strcmp(name, "exit");
+
 	return syscall__set_arg_fmts(sc);
 }
 
@@ -1643,7 +1646,7 @@ static int trace__sys_enter(struct trace *trace, struct perf_evsel *evsel,
 	printed += syscall__scnprintf_args(sc, msg + printed, 1024 - printed,
 					   args, trace, thread);
 
-	if (!strcmp(sc->name, "exit_group") || !strcmp(sc->name, "exit")) {
+	if (sc->is_exit) {
 		if (!trace->duration_filter && !trace->summary_only) {
 			trace__fprintf_entry_head(trace, thread, 1, sample->time, trace->output);
 			fprintf(trace->output, "%-70s\n", ttrace->entry_str);
-- 
1.9.3

