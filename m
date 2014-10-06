Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091AbaJFQNj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 12:13:39 -0400
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:45080 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846AbaJFQN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 12:13:28 -0400
From: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Yarygin <yarygin@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH] perf kvm stat record: print kvm specific --help output
Date: Mon,  6 Oct 2014 20:13:18 +0400
Message-Id: <1412611998-8690-2-git-send-email-yarygin@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412611998-8690-1-git-send-email-yarygin@linux.vnet.ibm.com>
References: <1412611998-8690-1-git-send-email-yarygin@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14100616-3548-0000-0000-000001C574C7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'perf kvm stat record' tool is an alias of 'perf record' with
predefined kvm related options. All options that passed to 'perf kvm
stat record' are processed by the 'perf record' tool. So, 'perf kvm stat
record --help' prints  help of usage for the 'perf record'
command. There are a few options useful for 'perf kvm stat record', the
rest either break kvm related output or don't change it.

Let's print safe for 'perf kvm stat record' options in addition to
general 'perf record' --help output.

Signed-off-by: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 tools/perf/builtin-kvm.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 43367eb..0c169d7 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -1138,6 +1138,40 @@ exit:
 		_p;			\
 	})
 
+static void print_record_help(void)
+{
+	fprintf(stderr, "\n usage: perf kvm stat record [<options>]\n\n");
+
+	fprintf(stderr, "    -p, --pid <pid>      record events on existing process id\n");
+	fprintf(stderr, "    -t, --tid <tid>      record events on existing thread id\n");
+	fprintf(stderr, "    -r, --realtime <n>   collect data with this RT SCHED_FIFO priority\n");
+	fprintf(stderr, "        --no-buffering   collect data without buffering\n");
+	fprintf(stderr, "    -a, --all-cpus       system-wide collection from all CPUs\n");
+	fprintf(stderr, "    -C, --cpu <cpu>      list of cpus to monitor\n");
+	fprintf(stderr, "    -c, --count <n>      event period to sample\n");
+	fprintf(stderr, "    -o, --output <file>  output file name\n");
+	fprintf(stderr, "    -i, --no-inherit     child tasks do not inherit counters\n");
+	fprintf(stderr, "    -m, --mmap-pages <pages>\n");
+	fprintf(stderr, "                         number of mmap data pages\n");
+	fprintf(stderr, "    -v, --verbose        be more verbose (show counter open errors, etc)\n");
+	fprintf(stderr, "    -q, --quiet          don't print any message\n");
+	fprintf(stderr, "    -D, --delay <n>      ms to wait before starting measurement after program start\n");
+	fprintf(stderr, "    -u, --uid <user>     user to profile\n");
+	fprintf(stderr, "        --per-thread     use per-thread mmaps\n");
+
+	fprintf(stderr, "\nOtherwise, it is the alias of 'perf record:'\n");
+}
+
+static bool is_help_option(int argc, const char **argv)
+{
+	int i;
+
+	for (i = 0; i < argc; i++)
+		if (!strcmp(argv[i], "--help") || !strcmp(argv[i], "-h"))
+			return true;
+	return false;
+}
+
 static int
 kvm_events_record(struct perf_kvm_stat *kvm, int argc, const char **argv)
 {
@@ -1150,6 +1184,10 @@ kvm_events_record(struct perf_kvm_stat *kvm, int argc, const char **argv)
 		"-c", "1",
 	};
 	const char * const *events_tp;
+
+	if (argc == 1 || (argc > 1 && is_help_option(argc, argv)))
+		print_record_help();
+
 	events_tp_size = 0;
 
 	for (events_tp = kvm_events_tp; *events_tp; events_tp++)
-- 
1.9.1

