Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528AbaGEKlt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 06:41:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57822 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754909AbaGEKlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 06:41:47 -0400
Date: Sat, 5 Jul 2014 03:41:27 -0700
From: tip-bot for Stanislav Fomichev <tipbot@zytor.com>
Message-ID: <tip-1e28fe0a4ff8680d5a0fb84995fd2444dac19cc4@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, jolsa@redhat.com, stfomichev@yandex-team.ru,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, stfomichev@yandex-team.ru, dsahern@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1403799268-1367-4-git-send-email-stfomichev@yandex-team.ru>
References: <1403799268-1367-4-git-send-email-stfomichev@yandex-team.ru>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf trace:
  Add pagefaults record and replay support
Git-Commit-ID: 1e28fe0a4ff8680d5a0fb84995fd2444dac19cc4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1e28fe0a4ff8680d5a0fb84995fd2444dac19cc4
Gitweb:     http://git.kernel.org/tip/1e28fe0a4ff8680d5a0fb84995fd2444dac19cc4
Author:     Stanislav Fomichev <stfomichev@yandex-team.ru>
AuthorDate: Thu, 26 Jun 2014 20:14:26 +0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 26 Jun 2014 17:43:24 -0300

perf trace: Add pagefaults record and replay support

Previous commit added live pagefault trace support, this one adds record
and replay support.

Example:

  [root@zoo /]# echo 1 > /proc/sys/vm/drop_caches ; trace -F all record -a sleep 10
  [ perf record: Woken up 0 times to write data ]
  [ perf record: Captured and wrote 1029.722 MB perf.data (~44989242 samples) ]

  [root@zoo /]# ls -la perf.data
  -rw-------. 1 root root 1083921722 Jun 26 17:44 perf.data

  [root@zoo /]# perf evlist
  raw_syscalls:sys_enter
  raw_syscalls:sys_exit
  major-faults
  minor-faults

  [root@zoo /]# trace -i perf.data | grep -v trace\/ | tail -15
     156.137 ( 0.000 ms): perl/18476 minfault [0xb4243] => 0x0 (?.)
     156.139 ( 0.000 ms): perl/18476 minfault [Perl_sv_clear+0x123] => 0x0 (?.)
     156.140 ( 0.000 ms): perl/18476 minfault [Perl_sv_clear+0xc4] => 0x0 (?.)
     156.144 ( 0.000 ms): perl/18476 minfault [_int_free+0xda] => 0x0 (?.)
     156.151 ( 0.000 ms): perl/18476 minfault [_int_free+0x1df] => 0x0 (?.)
     156.158 ( 0.000 ms): perl/18476 minfault [0xb4243] => 0x0 (?.)
     156.161 ( 0.000 ms): perl/18476 minfault [0xb4243] => 0x0 (?.)
     156.168 ( 0.000 ms): perl/18476 minfault [0xb4243] => 0x0 (?.)
     156.172 ( 0.000 ms): perl/18476 minfault [0xb4243] => 0x0 (?.)
     156.173 ( 0.000 ms): perl/18476 minfault [_int_free+0xda] => 0x0 (?.)
     156.183 ( 0.000 ms): perl/18476 minfault [Perl_hfree_next_entry+0xb4] => 0x0 (?.)
     156.197 ( 0.000 ms): perl/18476 minfault [_int_free+0x1df] => 0x0 (?.)
     156.216 ( 0.000 ms): perl/18476 minfault [Perl_sv_clear+0x123] => 0x0 (?.)
     156.221 ( 0.000 ms): perl/18476 minfault [Perl_sv_clear+0x123] => 0x0 (?.)
  [root@zoo /]#

Signed-off-by: Stanislav Fomichev <stfomichev@yandex-team.ru>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1403799268-1367-4-git-send-email-stfomichev@yandex-team.ru
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 63 +++++++++++++++++++++++++++++++++-------------
 1 file changed, 45 insertions(+), 18 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 1985c3b..0b58e24 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1897,7 +1897,7 @@ static int parse_target_str(struct trace *trace)
 	return 0;
 }
 
-static int trace__record(int argc, const char **argv)
+static int trace__record(struct trace *trace, int argc, const char **argv)
 {
 	unsigned int rec_argc, i, j;
 	const char **rec_argv;
@@ -1906,34 +1906,52 @@ static int trace__record(int argc, const char **argv)
 		"-R",
 		"-m", "1024",
 		"-c", "1",
-		"-e",
 	};
 
+	const char * const sc_args[] = { "-e", };
+	unsigned int sc_args_nr = ARRAY_SIZE(sc_args);
+	const char * const majpf_args[] = { "-e", "major-faults" };
+	unsigned int majpf_args_nr = ARRAY_SIZE(majpf_args);
+	const char * const minpf_args[] = { "-e", "minor-faults" };
+	unsigned int minpf_args_nr = ARRAY_SIZE(minpf_args);
+
 	/* +1 is for the event string below */
-	rec_argc = ARRAY_SIZE(record_args) + 1 + argc;
+	rec_argc = ARRAY_SIZE(record_args) + sc_args_nr + 1 +
+		majpf_args_nr + minpf_args_nr + argc;
 	rec_argv = calloc(rec_argc + 1, sizeof(char *));
 
 	if (rec_argv == NULL)
 		return -ENOMEM;
 
+	j = 0;
 	for (i = 0; i < ARRAY_SIZE(record_args); i++)
-		rec_argv[i] = record_args[i];
+		rec_argv[j++] = record_args[i];
+
+	for (i = 0; i < sc_args_nr; i++)
+		rec_argv[j++] = sc_args[i];
 
 	/* event string may be different for older kernels - e.g., RHEL6 */
 	if (is_valid_tracepoint("raw_syscalls:sys_enter"))
-		rec_argv[i] = "raw_syscalls:sys_enter,raw_syscalls:sys_exit";
+		rec_argv[j++] = "raw_syscalls:sys_enter,raw_syscalls:sys_exit";
 	else if (is_valid_tracepoint("syscalls:sys_enter"))
-		rec_argv[i] = "syscalls:sys_enter,syscalls:sys_exit";
+		rec_argv[j++] = "syscalls:sys_enter,syscalls:sys_exit";
 	else {
 		pr_err("Neither raw_syscalls nor syscalls events exist.\n");
 		return -1;
 	}
-	i++;
 
-	for (j = 0; j < (unsigned int)argc; j++, i++)
-		rec_argv[i] = argv[j];
+	if (trace->trace_pgfaults & TRACE_PFMAJ)
+		for (i = 0; i < majpf_args_nr; i++)
+			rec_argv[j++] = majpf_args[i];
+
+	if (trace->trace_pgfaults & TRACE_PFMIN)
+		for (i = 0; i < minpf_args_nr; i++)
+			rec_argv[j++] = minpf_args[i];
+
+	for (i = 0; i < (unsigned int)argc; i++)
+		rec_argv[j++] = argv[i];
 
-	return cmd_record(i, rec_argv, NULL);
+	return cmd_record(j, rec_argv, NULL);
 }
 
 static size_t trace__fprintf_thread_summary(struct trace *trace, FILE *fp);
@@ -2224,6 +2242,14 @@ static int trace__replay(struct trace *trace)
 		goto out;
 	}
 
+	evlist__for_each(session->evlist, evsel) {
+		if (evsel->attr.type == PERF_TYPE_SOFTWARE &&
+		    (evsel->attr.config == PERF_COUNT_SW_PAGE_FAULTS_MAJ ||
+		     evsel->attr.config == PERF_COUNT_SW_PAGE_FAULTS_MIN ||
+		     evsel->attr.config == PERF_COUNT_SW_PAGE_FAULTS))
+			evsel->handler = trace__pgfault;
+	}
+
 	err = parse_target_str(trace);
 	if (err != 0)
 		goto out;
@@ -2458,20 +2484,21 @@ int cmd_trace(int argc, const char **argv, const char *prefix __maybe_unused)
 	int err;
 	char bf[BUFSIZ];
 
-	if ((argc > 1) && (strcmp(argv[1], "record") == 0))
-		return trace__record(argc-2, &argv[2]);
-
-	argc = parse_options(argc, argv, trace_options, trace_usage, 0);
-
-	/* summary_only implies summary option, but don't overwrite summary if set */
-	if (trace.summary_only)
-		trace.summary = trace.summary_only;
+	argc = parse_options(argc, argv, trace_options, trace_usage,
+			     PARSE_OPT_STOP_AT_NON_OPTION);
 
 	if (trace.trace_pgfaults) {
 		trace.opts.sample_address = true;
 		trace.opts.sample_time = true;
 	}
 
+	if ((argc >= 1) && (strcmp(argv[0], "record") == 0))
+		return trace__record(&trace, argc-1, &argv[1]);
+
+	/* summary_only implies summary option, but don't overwrite summary if set */
+	if (trace.summary_only)
+		trace.summary = trace.summary_only;
+
 	if (output_name != NULL) {
 		err = trace__open_output(&trace, output_name);
 		if (err < 0) {
