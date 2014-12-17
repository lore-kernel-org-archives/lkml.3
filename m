Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751096AbaLQQH5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 11:07:57 -0500
Received: from mail.kernel.org ([198.145.19.201]:40761 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951AbaLQQH4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 11:07:56 -0500
Date: Wed, 17 Dec 2014 13:07:49 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        ak@linux.intel.com, jolsa@redhat.com, dsahern@gmail.com,
        dzickus@redhat.com, rfowles@redhat.com, jmario@redhat.com,
        namhyung@kernel.org
Subject: Re: [PATCH v3] perf mem: enable sampling loads and stores
 simultaneously
Message-ID: <20141217160749.GH11607@kernel.org>
References: <20141217152355.GA10053@thinkpad>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="PEIAKu/WMn1b1Hv9"
Content-Disposition: inline
In-Reply-To: <20141217152355.GA10053@thinkpad>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PEIAKu/WMn1b1Hv9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Em Wed, Dec 17, 2014 at 04:23:55PM +0100, Stephane Eranian escreveu:
> 
> This patch modifies perf mem to default to sampling loads
> and stores simultaneously. It could only do one or the other
> before yet there was no hardware restriction preventing
> simultaneous collection. With this patch, one run is sufficient
> to collect both.
> 
> It is still possible to sample only loads or stores by using the
> -t option:
>  $ perf mem -t load rec
>  $ perf mem -t load rep
> Or
>  $ perf mem -t store rec
>  $ perf mem -t store rep
> 
> The perf report TUI will show one event at a time. The store
> output will contain a Weight column which will be empty.
> 
> In V2, we updated the man pages to reflect the change and
> also simplify the initialization of the argv vector passed
> to the cmd_*() functions as per LKML feedback.
> 
> In V3, we fixed typos in the changelog.
> 
> Signed-off-by: Stephane Eranian <eranian@google.com>

So here it goes a v4, just a minor change to avoid adding another global
variable and make this operation parm like the other parms inside that
struct perf_mem, attached goes the interdiff from your patch to this one
here, ok?

diff --git a/tools/perf/Documentation/perf-mem.txt b/tools/perf/Documentation/perf-mem.txt
index 1d78a4064da4..43310d8661fe 100644
--- a/tools/perf/Documentation/perf-mem.txt
+++ b/tools/perf/Documentation/perf-mem.txt
@@ -12,11 +12,12 @@ SYNOPSIS
 
 DESCRIPTION
 -----------
-"perf mem -t <TYPE> record" runs a command and gathers memory operation data
+"perf mem record" runs a command and gathers memory operation data
 from it, into perf.data. Perf record options are accepted and are passed through.
 
-"perf mem -t <TYPE> report" displays the result. It invokes perf report with the
-right set of options to display a memory access profile.
+"perf mem report" displays the result. It invokes perf report with the
+right set of options to display a memory access profile. By default, loads
+and stores are sampled. Use the -t option to limit to loads or stores.
 
 Note that on Intel systems the memory latency reported is the use-latency,
 not the pure load (or store latency). Use latency includes any pipeline
@@ -29,7 +30,7 @@ OPTIONS
 
 -t::
 --type=::
-	Select the memory operation type: load or store (default: load)
+	Select the memory operation type: load or store (default: load,store)
 
 -D::
 --dump-raw-samples=::
diff --git a/tools/perf/builtin-mem.c b/tools/perf/builtin-mem.c
index 24db6ffe2957..9b5663950a4d 100644
--- a/tools/perf/builtin-mem.c
+++ b/tools/perf/builtin-mem.c
@@ -7,44 +7,47 @@
 #include "util/session.h"
 #include "util/data.h"
 
-#define MEM_OPERATION_LOAD	"load"
-#define MEM_OPERATION_STORE	"store"
-
-static const char	*mem_operation		= MEM_OPERATION_LOAD;
+#define MEM_OPERATION_LOAD	0x1
+#define MEM_OPERATION_STORE	0x2
 
 struct perf_mem {
 	struct perf_tool	tool;
 	char const		*input_name;
 	bool			hide_unresolved;
 	bool			dump_raw;
+	int			operation;
 	const char		*cpu_list;
 	DECLARE_BITMAP(cpu_bitmap, MAX_NR_CPUS);
 };
 
-static int __cmd_record(int argc, const char **argv)
+static int __cmd_record(int argc, const char **argv, struct perf_mem *mem)
 {
 	int rec_argc, i = 0, j;
 	const char **rec_argv;
-	char event[64];
 	int ret;
 
-	rec_argc = argc + 4;
+	rec_argc = argc + 7; /* max number of arguments */
 	rec_argv = calloc(rec_argc + 1, sizeof(char *));
 	if (!rec_argv)
 		return -1;
 
-	rec_argv[i++] = strdup("record");
-	if (!strcmp(mem_operation, MEM_OPERATION_LOAD))
-		rec_argv[i++] = strdup("-W");
-	rec_argv[i++] = strdup("-d");
-	rec_argv[i++] = strdup("-e");
+	rec_argv[i++] = "record";
 
-	if (strcmp(mem_operation, MEM_OPERATION_LOAD))
-		sprintf(event, "cpu/mem-stores/pp");
-	else
-		sprintf(event, "cpu/mem-loads/pp");
+	if (mem->operation & MEM_OPERATION_LOAD)
+		rec_argv[i++] = "-W";
+
+	rec_argv[i++] = "-d";
+
+	if (mem->operation & MEM_OPERATION_LOAD) {
+		rec_argv[i++] = "-e";
+		rec_argv[i++] = "cpu/mem-loads/pp";
+	}
+
+	if (mem->operation & MEM_OPERATION_STORE) {
+		rec_argv[i++] = "-e";
+		rec_argv[i++] = "cpu/mem-stores/pp";
+	}
 
-	rec_argv[i++] = strdup(event);
 	for (j = 1; j < argc; j++, i++)
 		rec_argv[i] = argv[j];
 
@@ -162,17 +165,17 @@ static int report_events(int argc, const char **argv, struct perf_mem *mem)
 	if (!rep_argv)
 		return -1;
 
-	rep_argv[i++] = strdup("report");
-	rep_argv[i++] = strdup("--mem-mode");
-	rep_argv[i++] = strdup("-n"); /* display number of samples */
+	rep_argv[i++] = "report";
+	rep_argv[i++] = "--mem-mode";
+	rep_argv[i++] = "-n"; /* display number of samples */
 
 	/*
 	 * there is no weight (cost) associated with stores, so don't print
 	 * the column
 	 */
-	if (strcmp(mem_operation, MEM_OPERATION_LOAD))
-		rep_argv[i++] = strdup("--sort=mem,sym,dso,symbol_daddr,"
-				       "dso_daddr,tlb,locked");
+	if (!(mem->operation & MEM_OPERATION_LOAD))
+		rep_argv[i++] = "--sort=mem,sym,dso,symbol_daddr,"
+				"dso_daddr,tlb,locked";
 
 	for (j = 1; j < argc; j++, i++)
 		rep_argv[i] = argv[j];
@@ -182,6 +185,75 @@ static int report_events(int argc, const char **argv, struct perf_mem *mem)
 	return ret;
 }
 
+struct mem_mode {
+	const char *name;
+	int mode;
+};
+
+#define MEM_OPT(n, m) \
+	{ .name = n, .mode = (m) }
+
+#define MEM_END { .name = NULL }
+
+static const struct mem_mode mem_modes[]={
+	MEM_OPT("load", MEM_OPERATION_LOAD),
+	MEM_OPT("store", MEM_OPERATION_STORE),
+	MEM_END
+};
+
+static int
+parse_mem_ops(const struct option *opt, const char *str, int unset)
+{
+	int *mode = (int *)opt->value;
+	const struct mem_mode *m;
+	char *s, *os = NULL, *p;
+	int ret = -1;
+
+	if (unset)
+		return 0;
+
+	/* str may be NULL in case no arg is passed to -t */
+	if (str) {
+		/* because str is read-only */
+		s = os = strdup(str);
+		if (!s)
+			return -1;
+
+		/* reset mode */
+		*mode = 0;
+
+		for (;;) {
+			p = strchr(s, ',');
+			if (p)
+				*p = '\0';
+
+			for (m = mem_modes; m->name; m++) {
+				if (!strcasecmp(s, m->name))
+					break;
+			}
+			if (!m->name) {
+				fprintf(stderr, "unknown sampling op %s,"
+					    " check man page\n", s);
+				goto error;
+			}
+
+			*mode |= m->mode;
+
+			if (!p)
+				break;
+
+			s = p + 1;
+		}
+	}
+	ret = 0;
+
+	if (*mode == 0)
+		*mode = MEM_OPERATION_LOAD;
+error:
+	free(os);
+	return ret;
+}
+
 int cmd_mem(int argc, const char **argv, const char *prefix __maybe_unused)
 {
 	struct stat st;
@@ -197,10 +269,15 @@ int cmd_mem(int argc, const char **argv, const char *prefix __maybe_unused)
 			.ordered_events	= true,
 		},
 		.input_name		 = "perf.data",
+		/*
+		 * default to both load an store sampling
+		 */
+		.operation		 = MEM_OPERATION_LOAD | MEM_OPERATION_STORE,
 	};
 	const struct option mem_options[] = {
-	OPT_STRING('t', "type", &mem_operation,
-		   "type", "memory operations(load/store)"),
+	OPT_CALLBACK('t', "type", &mem.operation,
+		   "type", "memory operations(load,store) Default load,store",
+		    parse_mem_ops),
 	OPT_BOOLEAN('D', "dump-raw-samples", &mem.dump_raw,
 		    "dump raw samples in ASCII"),
 	OPT_BOOLEAN('U', "hide-unresolved", &mem.hide_unresolved,
@@ -225,7 +302,7 @@ int cmd_mem(int argc, const char **argv, const char *prefix __maybe_unused)
 	argc = parse_options_subcommand(argc, argv, mem_options, mem_subcommands,
 					mem_usage, PARSE_OPT_STOP_AT_NON_OPTION);
 
-	if (!argc || !(strncmp(argv[0], "rec", 3) || mem_operation))
+	if (!argc || !(strncmp(argv[0], "rec", 3) || mem.operation))
 		usage_with_options(mem_usage, mem_options);
 
 	if (!mem.input_name || !strlen(mem.input_name)) {
@@ -236,7 +313,7 @@ int cmd_mem(int argc, const char **argv, const char *prefix __maybe_unused)
 	}
 
 	if (!strncmp(argv[0], "rec", 3))
-		return __cmd_record(argc, argv);
+		return __cmd_record(argc, argv, &mem);
 	else if (!strncmp(argv[0], "rep", 3))
 		return report_events(argc, argv, &mem);
 	else

--PEIAKu/WMn1b1Hv9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="interdiff.patch"

diff -u b/tools/perf/builtin-mem.c b/tools/perf/builtin-mem.c
--- b/tools/perf/builtin-mem.c
+++ b/tools/perf/builtin-mem.c
@@ -10,21 +10,17 @@
 #define MEM_OPERATION_LOAD	0x1
 #define MEM_OPERATION_STORE	0x2
 
-/*
- * default to both load an store sampling
- */
-static int mem_operation = MEM_OPERATION_LOAD | MEM_OPERATION_STORE;
-
 struct perf_mem {
 	struct perf_tool	tool;
 	char const		*input_name;
 	bool			hide_unresolved;
 	bool			dump_raw;
+	int			operation;
 	const char		*cpu_list;
 	DECLARE_BITMAP(cpu_bitmap, MAX_NR_CPUS);
 };
 
-static int __cmd_record(int argc, const char **argv)
+static int __cmd_record(int argc, const char **argv, struct perf_mem *mem)
 {
 	int rec_argc, i = 0, j;
 	const char **rec_argv;
@@ -37,17 +33,17 @@
 
 	rec_argv[i++] = "record";
 
-	if (mem_operation & MEM_OPERATION_LOAD)
+	if (mem->operation & MEM_OPERATION_LOAD)
 		rec_argv[i++] = "-W";
 
 	rec_argv[i++] = "-d";
 
-	if (mem_operation & MEM_OPERATION_LOAD) {
+	if (mem->operation & MEM_OPERATION_LOAD) {
 		rec_argv[i++] = "-e";
 		rec_argv[i++] = "cpu/mem-loads/pp";
 	}
 
-	if (mem_operation & MEM_OPERATION_STORE) {
+	if (mem->operation & MEM_OPERATION_STORE) {
 		rec_argv[i++] = "-e";
 		rec_argv[i++] = "cpu/mem-stores/pp";
 	}
@@ -177,7 +173,7 @@
 	 * there is no weight (cost) associated with stores, so don't print
 	 * the column
 	 */
-	if (!(mem_operation & MEM_OPERATION_LOAD))
+	if (!(mem->operation & MEM_OPERATION_LOAD))
 		rep_argv[i++] = "--sort=mem,sym,dso,symbol_daddr,"
 				"dso_daddr,tlb,locked";
 
@@ -273,9 +269,13 @@
 			.ordered_events	= true,
 		},
 		.input_name		 = "perf.data",
+		/*
+		 * default to both load an store sampling
+		 */
+		.operation		 = MEM_OPERATION_LOAD | MEM_OPERATION_STORE,
 	};
 	const struct option mem_options[] = {
-	OPT_CALLBACK('t', "type", &mem_operation,
+	OPT_CALLBACK('t', "type", &mem.operation,
 		   "type", "memory operations(load,store) Default load,store",
 		    parse_mem_ops),
 	OPT_BOOLEAN('D', "dump-raw-samples", &mem.dump_raw,
@@ -302,7 +302,7 @@
 	argc = parse_options_subcommand(argc, argv, mem_options, mem_subcommands,
 					mem_usage, PARSE_OPT_STOP_AT_NON_OPTION);
 
-	if (!argc || !(strncmp(argv[0], "rec", 3) || mem_operation))
+	if (!argc || !(strncmp(argv[0], "rec", 3) || mem.operation))
 		usage_with_options(mem_usage, mem_options);
 
 	if (!mem.input_name || !strlen(mem.input_name)) {
@@ -313,7 +313,7 @@
 	}
 
 	if (!strncmp(argv[0], "rec", 3))
-		return __cmd_record(argc, argv);
+		return __cmd_record(argc, argv, &mem);
 	else if (!strncmp(argv[0], "rep", 3))
 		return report_events(argc, argv, &mem);
 	else

--PEIAKu/WMn1b1Hv9--
