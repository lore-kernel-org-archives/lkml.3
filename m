Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933561AbaJ2OHv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 10:07:51 -0400
Received: from mail.kernel.org ([198.145.19.201]:41200 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932906AbaJ2OHr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 10:07:47 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Alexander Yarygin <yarygin@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 10/25] perf kvm: Print kvm specific --help output
Date: Wed, 29 Oct 2014 12:06:22 -0200
Message-Id: <1414591597-2763-11-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1414591597-2763-1-git-send-email-acme@kernel.org>
References: <1414591597-2763-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

The 'perf kvm stat record' tool is an alias of 'perf record' with
predefined kvm related options. All options that passed to 'perf kvm
stat record' are processed by the 'perf record' tool. So, 'perf kvm
stat record --help' prints help of usage for the 'perf record'
command. There are a few options useful for 'perf kvm stat record',
the rest either break kvm related output or don't change it.

Let's print safe for 'perf kvm stat record' options in addition to
general 'perf record' --help output.

With this patch, new output looks like below:

  $ perf kvm stat record -h

   usage: perf kvm stat record [<options>]

      -p, --pid <pid>       record events on existing process id
      -t, --tid <tid>       record events on existing thread id
      -r, --realtime <n>    collect data with this RT SCHED_FIFO priority
          --no-buffering    collect data without buffering
      -a, --all-cpus        system-wide collection from all CPUs
      -C, --cpu <cpu>       list of cpus to monitor
      -c, --count <n>       event period to sample
      -o, --output <file>   output file name
      -i, --no-inherit      child tasks do not inherit counters
      -m, --mmap-pages <pages>
                            number of mmap data pages
      -v, --verbose         be more verbose (show counter open errors, etc)
      -q, --quiet           don't print any message
      -s, --stat            per thread counts
      -D, --delay <n>       ms to wait before starting measurement after program start
      -u, --uid <user>      user to profile
          --per-thread      use per-thread mmaps

  $ perf kvm stat record -n sleep 1
    Error: switch `n' is not usable

   usage: perf kvm stat record [<options>]

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Hemant Kumar <hemant@linux.vnet.ibm.com>
Cc: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1413990949-13953-4-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-kvm.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index b65eb0507b38..3c0f3d4fb021 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -1132,6 +1132,10 @@ kvm_events_record(struct perf_kvm_stat *kvm, int argc, const char **argv)
 		"-m", "1024",
 		"-c", "1",
 	};
+	const char * const kvm_stat_record_usage[] = {
+		"perf kvm stat record [<options>]",
+		NULL
+	};
 	const char * const *events_tp;
 	events_tp_size = 0;
 
@@ -1159,6 +1163,27 @@ kvm_events_record(struct perf_kvm_stat *kvm, int argc, const char **argv)
 	for (j = 1; j < (unsigned int)argc; j++, i++)
 		rec_argv[i] = argv[j];
 
+	set_option_flag(record_options, 'e', "event", PARSE_OPT_HIDDEN);
+	set_option_flag(record_options, 0, "filter", PARSE_OPT_HIDDEN);
+	set_option_flag(record_options, 'R', "raw-samples", PARSE_OPT_HIDDEN);
+
+	set_option_flag(record_options, 'F', "freq", PARSE_OPT_DISABLED);
+	set_option_flag(record_options, 0, "group", PARSE_OPT_DISABLED);
+	set_option_flag(record_options, 'g', NULL, PARSE_OPT_DISABLED);
+	set_option_flag(record_options, 0, "call-graph", PARSE_OPT_DISABLED);
+	set_option_flag(record_options, 'd', "data", PARSE_OPT_DISABLED);
+	set_option_flag(record_options, 'T', "timestamp", PARSE_OPT_DISABLED);
+	set_option_flag(record_options, 'P', "period", PARSE_OPT_DISABLED);
+	set_option_flag(record_options, 'n', "no-samples", PARSE_OPT_DISABLED);
+	set_option_flag(record_options, 'N', "no-buildid-cache", PARSE_OPT_DISABLED);
+	set_option_flag(record_options, 'B', "no-buildid", PARSE_OPT_DISABLED);
+	set_option_flag(record_options, 'G', "cgroup", PARSE_OPT_DISABLED);
+	set_option_flag(record_options, 'b', "branch-any", PARSE_OPT_DISABLED);
+	set_option_flag(record_options, 'j', "branch-filter", PARSE_OPT_DISABLED);
+	set_option_flag(record_options, 'W', "weight", PARSE_OPT_DISABLED);
+	set_option_flag(record_options, 0, "transaction", PARSE_OPT_DISABLED);
+
+	record_usage = kvm_stat_record_usage;
 	return cmd_record(i, rec_argv, NULL);
 }
 
-- 
1.9.3

