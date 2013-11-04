Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053Ab3KDR7i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 12:59:38 -0500
Received: from merlin.infradead.org ([205.233.59.134]:37949 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849Ab3KDR73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 12:59:29 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 09/29] perf script: Set up output options for in-stream attributes
Date: Mon,  4 Nov 2013 14:58:47 -0300
Message-Id: <1383587947-17419-10-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1383587947-17419-1-git-send-email-acme@infradead.org>
References: <1383587947-17419-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Attributes (struct perf_event_attr) are recorded separately in the
perf.data file.  perf script uses them to set up output options.
However attributes can also be in the event stream, for example when the
input is a pipe (i.e. live mode).  This patch makes perf script process
in-stream attributes in the same way as on-file attributes.

Here is an example:

Before this patch:

$ perf record uname | perf script
Linux
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.015 MB (null) (~655 samples) ]
:4220  4220 [-01] 2933367.838906: cycles:

:4220  4220 [-01] 2933367.838910: cycles:

:4220  4220 [-01] 2933367.838912: cycles:

:4220  4220 [-01] 2933367.838914: cycles:

:4220  4220 [-01] 2933367.838916: cycles:

:4220  4220 [-01] 2933367.838918: cycles:

uname  4220 [-01] 2933367.838938: cycles:

uname  4220 [-01] 2933367.839207: cycles:

After this patch:

$ perf record uname | perf script
Linux
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.015 MB (null) (~655 samples) ]
           :4582  4582 2933425.707724: cycles:  ffffffff81043ffa native_write_msr_safe ([kernel.kallsyms])
           :4582  4582 2933425.707728: cycles:  ffffffff81043ffa native_write_msr_safe ([kernel.kallsyms])
           :4582  4582 2933425.707730: cycles:  ffffffff81043ffa native_write_msr_safe ([kernel.kallsyms])
           :4582  4582 2933425.707732: cycles:  ffffffff81043ffa native_write_msr_safe ([kernel.kallsyms])
           :4582  4582 2933425.707734: cycles:  ffffffff81043ffa native_write_msr_safe ([kernel.kallsyms])
           :4582  4582 2933425.707736: cycles:  ffffffff81309a24 memcpy ([kernel.kallsyms])
           uname  4582 2933425.707760: cycles:  ffffffff8109c1c7 enqueue_task_fair ([kernel.kallsyms])
           uname  4582 2933425.707978: cycles:  ffffffff81308457 clear_page_c ([kernel.kallsyms])

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1383313899-15987-3-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-script.c | 64 +++++++++++++++++++++++++++++++++------------
 1 file changed, 48 insertions(+), 16 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index b866cc8c3878..baf17989a216 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -229,6 +229,24 @@ static int perf_evsel__check_attr(struct perf_evsel *evsel,
 	return 0;
 }
 
+static void set_print_ip_opts(struct perf_event_attr *attr)
+{
+	unsigned int type = attr->type;
+
+	output[type].print_ip_opts = 0;
+	if (PRINT_FIELD(IP))
+		output[type].print_ip_opts |= PRINT_IP_OPT_IP;
+
+	if (PRINT_FIELD(SYM))
+		output[type].print_ip_opts |= PRINT_IP_OPT_SYM;
+
+	if (PRINT_FIELD(DSO))
+		output[type].print_ip_opts |= PRINT_IP_OPT_DSO;
+
+	if (PRINT_FIELD(SYMOFFSET))
+		output[type].print_ip_opts |= PRINT_IP_OPT_SYMOFFSET;
+}
+
 /*
  * verify all user requested events exist and the samples
  * have the expected data
@@ -237,7 +255,6 @@ static int perf_session__check_output_opt(struct perf_session *session)
 {
 	int j;
 	struct perf_evsel *evsel;
-	struct perf_event_attr *attr;
 
 	for (j = 0; j < PERF_TYPE_MAX; ++j) {
 		evsel = perf_session__find_first_evtype(session, j);
@@ -260,20 +277,7 @@ static int perf_session__check_output_opt(struct perf_session *session)
 		if (evsel == NULL)
 			continue;
 
-		attr = &evsel->attr;
-
-		output[j].print_ip_opts = 0;
-		if (PRINT_FIELD(IP))
-			output[j].print_ip_opts |= PRINT_IP_OPT_IP;
-
-		if (PRINT_FIELD(SYM))
-			output[j].print_ip_opts |= PRINT_IP_OPT_SYM;
-
-		if (PRINT_FIELD(DSO))
-			output[j].print_ip_opts |= PRINT_IP_OPT_DSO;
-
-		if (PRINT_FIELD(SYMOFFSET))
-			output[j].print_ip_opts |= PRINT_IP_OPT_SYMOFFSET;
+		set_print_ip_opts(&evsel->attr);
 	}
 
 	return 0;
@@ -547,6 +551,34 @@ struct perf_script {
 	struct perf_session	*session;
 };
 
+static int process_attr(struct perf_tool *tool, union perf_event *event,
+			struct perf_evlist **pevlist)
+{
+	struct perf_script *scr = container_of(tool, struct perf_script, tool);
+	struct perf_evlist *evlist;
+	struct perf_evsel *evsel, *pos;
+	int err;
+
+	err = perf_event__process_attr(tool, event, pevlist);
+	if (err)
+		return err;
+
+	evlist = *pevlist;
+	evsel = perf_evlist__last(*pevlist);
+
+	if (evsel->attr.type >= PERF_TYPE_MAX)
+		return 0;
+
+	list_for_each_entry(pos, &evlist->entries, node) {
+		if (pos->attr.type == evsel->attr.type && pos != evsel)
+			return 0;
+	}
+
+	set_print_ip_opts(&evsel->attr);
+
+	return perf_evsel__check_attr(evsel, scr->session);
+}
+
 static void sig_handler(int sig __maybe_unused)
 {
 	session_done = 1;
@@ -1272,7 +1304,7 @@ int cmd_script(int argc, const char **argv, const char *prefix __maybe_unused)
 			.comm		 = perf_event__process_comm,
 			.exit		 = perf_event__process_exit,
 			.fork		 = perf_event__process_fork,
-			.attr		 = perf_event__process_attr,
+			.attr		 = process_attr,
 			.tracing_data	 = perf_event__process_tracing_data,
 			.build_id	 = perf_event__process_build_id,
 			.ordered_samples = true,
-- 
1.8.1.4

