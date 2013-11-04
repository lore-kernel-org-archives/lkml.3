Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041Ab3KDUUx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 15:20:53 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49944 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842Ab3KDUUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 15:20:50 -0500
Date: Mon, 4 Nov 2013 12:20:24 -0800
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-7ea95727af571d592c9d6aa7627690d44b114a2d@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, adrian.hunter@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <1383313899-15987-3-git-send-email-adrian.hunter@intel.com>
References: <1383313899-15987-3-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf script:
  Set up output options for in-stream attributes
Git-Commit-ID: 7ea95727af571d592c9d6aa7627690d44b114a2d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 04 Nov 2013 12:20:30 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7ea95727af571d592c9d6aa7627690d44b114a2d
Gitweb:     http://git.kernel.org/tip/7ea95727af571d592c9d6aa7627690d44b114a2d
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Fri, 1 Nov 2013 15:51:30 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 4 Nov 2013 12:19:26 -0300

perf script: Set up output options for in-stream attributes

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
index b866cc8..baf1798 100644
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
