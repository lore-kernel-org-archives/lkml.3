Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149AbaFCSgw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 14:36:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45008 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564AbaFCSgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 14:36:50 -0400
Date: Tue, 3 Jun 2014 11:36:33 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-a1891aa4805fa77d98db44ec6e1d93e2921828fb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jolsa@kernel.org, namhyung@kernel.org, fweisbec@gmail.com,
        tglx@linutronix.de, asharma@fb.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jolsa@kernel.org, namhyung@kernel.org, fweisbec@gmail.com,
        tglx@linutronix.de, asharma@fb.com
In-Reply-To: <1401335910-16832-27-git-send-email-namhyung@kernel.org>
References: <1401335910-16832-27-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tests:
  Define and use symbolic names for fake symbols
Git-Commit-ID: a1891aa4805fa77d98db44ec6e1d93e2921828fb
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

Commit-ID:  a1891aa4805fa77d98db44ec6e1d93e2921828fb
Gitweb:     http://git.kernel.org/tip/a1891aa4805fa77d98db44ec6e1d93e2921828fb
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Fri, 23 May 2014 14:59:57 +0900
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Sun, 1 Jun 2014 14:35:11 +0200

perf tests: Define and use symbolic names for fake symbols

In various histogram test cases, fake symbols are used as raw numbers.
Define macros for each pid, map, symbols so that it can increase
readability somewhat.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Arun Sharma <asharma@fb.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/r/1401335910-16832-27-git-send-email-namhyung@kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/tests/hists_common.c | 47 ++++++++++++++++++++++-------------------
 tools/perf/tests/hists_common.h | 32 ++++++++++++++++++++++++++--
 tools/perf/tests/hists_filter.c | 23 ++++++++++----------
 tools/perf/tests/hists_link.c   | 32 ++++++++++++++--------------
 tools/perf/tests/hists_output.c | 20 +++++++++---------
 5 files changed, 92 insertions(+), 62 deletions(-)

diff --git a/tools/perf/tests/hists_common.c b/tools/perf/tests/hists_common.c
index e4e01aad..e4e120d 100644
--- a/tools/perf/tests/hists_common.c
+++ b/tools/perf/tests/hists_common.c
@@ -12,9 +12,9 @@ static struct {
 	u32 pid;
 	const char *comm;
 } fake_threads[] = {
-	{ 100, "perf" },
-	{ 200, "perf" },
-	{ 300, "bash" },
+	{ FAKE_PID_PERF1, "perf" },
+	{ FAKE_PID_PERF2, "perf" },
+	{ FAKE_PID_BASH,  "bash" },
 };
 
 static struct {
@@ -22,15 +22,15 @@ static struct {
 	u64 start;
 	const char *filename;
 } fake_mmap_info[] = {
-	{ 100, 0x40000, "perf" },
-	{ 100, 0x50000, "libc" },
-	{ 100, 0xf0000, "[kernel]" },
-	{ 200, 0x40000, "perf" },
-	{ 200, 0x50000, "libc" },
-	{ 200, 0xf0000, "[kernel]" },
-	{ 300, 0x40000, "bash" },
-	{ 300, 0x50000, "libc" },
-	{ 300, 0xf0000, "[kernel]" },
+	{ FAKE_PID_PERF1, FAKE_MAP_PERF,   "perf" },
+	{ FAKE_PID_PERF1, FAKE_MAP_LIBC,   "libc" },
+	{ FAKE_PID_PERF1, FAKE_MAP_KERNEL, "[kernel]" },
+	{ FAKE_PID_PERF2, FAKE_MAP_PERF,   "perf" },
+	{ FAKE_PID_PERF2, FAKE_MAP_LIBC,   "libc" },
+	{ FAKE_PID_PERF2, FAKE_MAP_KERNEL, "[kernel]" },
+	{ FAKE_PID_BASH,  FAKE_MAP_BASH,   "bash" },
+	{ FAKE_PID_BASH,  FAKE_MAP_LIBC,   "libc" },
+	{ FAKE_PID_BASH,  FAKE_MAP_KERNEL, "[kernel]" },
 };
 
 struct fake_sym {
@@ -40,27 +40,30 @@ struct fake_sym {
 };
 
 static struct fake_sym perf_syms[] = {
-	{ 700, 100, "main" },
-	{ 800, 100, "run_command" },
-	{ 900, 100, "cmd_record" },
+	{ FAKE_SYM_OFFSET1, FAKE_SYM_LENGTH, "main" },
+	{ FAKE_SYM_OFFSET2, FAKE_SYM_LENGTH, "run_command" },
+	{ FAKE_SYM_OFFSET3, FAKE_SYM_LENGTH, "cmd_record" },
 };
 
 static struct fake_sym bash_syms[] = {
-	{ 700, 100, "main" },
-	{ 800, 100, "xmalloc" },
-	{ 900, 100, "xfree" },
+	{ FAKE_SYM_OFFSET1, FAKE_SYM_LENGTH, "main" },
+	{ FAKE_SYM_OFFSET2, FAKE_SYM_LENGTH, "xmalloc" },
+	{ FAKE_SYM_OFFSET3, FAKE_SYM_LENGTH, "xfree" },
 };
 
 static struct fake_sym libc_syms[] = {
 	{ 700, 100, "malloc" },
 	{ 800, 100, "free" },
 	{ 900, 100, "realloc" },
+	{ FAKE_SYM_OFFSET1, FAKE_SYM_LENGTH, "malloc" },
+	{ FAKE_SYM_OFFSET2, FAKE_SYM_LENGTH, "free" },
+	{ FAKE_SYM_OFFSET3, FAKE_SYM_LENGTH, "realloc" },
 };
 
 static struct fake_sym kernel_syms[] = {
-	{ 700, 100, "schedule" },
-	{ 800, 100, "page_fault" },
-	{ 900, 100, "sys_perf_event_open" },
+	{ FAKE_SYM_OFFSET1, FAKE_SYM_LENGTH, "schedule" },
+	{ FAKE_SYM_OFFSET2, FAKE_SYM_LENGTH, "page_fault" },
+	{ FAKE_SYM_OFFSET3, FAKE_SYM_LENGTH, "sys_perf_event_open" },
 };
 
 static struct {
@@ -102,7 +105,7 @@ struct machine *setup_fake_machine(struct machines *machines)
 				.pid = fake_mmap_info[i].pid,
 				.tid = fake_mmap_info[i].pid,
 				.start = fake_mmap_info[i].start,
-				.len = 0x1000ULL,
+				.len = FAKE_MAP_LENGTH,
 				.pgoff = 0ULL,
 			},
 		};
diff --git a/tools/perf/tests/hists_common.h b/tools/perf/tests/hists_common.h
index 1415ae6..888254e 100644
--- a/tools/perf/tests/hists_common.h
+++ b/tools/perf/tests/hists_common.h
@@ -4,6 +4,34 @@
 struct machine;
 struct machines;
 
+#define FAKE_PID_PERF1  100
+#define FAKE_PID_PERF2  200
+#define FAKE_PID_BASH   300
+
+#define FAKE_MAP_PERF    0x400000
+#define FAKE_MAP_BASH    0x400000
+#define FAKE_MAP_LIBC    0x500000
+#define FAKE_MAP_KERNEL  0xf00000
+#define FAKE_MAP_LENGTH  0x100000
+
+#define FAKE_SYM_OFFSET1  700
+#define FAKE_SYM_OFFSET2  800
+#define FAKE_SYM_OFFSET3  900
+#define FAKE_SYM_LENGTH   100
+
+#define FAKE_IP_PERF_MAIN  FAKE_MAP_PERF + FAKE_SYM_OFFSET1
+#define FAKE_IP_PERF_RUN_COMMAND  FAKE_MAP_PERF + FAKE_SYM_OFFSET2
+#define FAKE_IP_PERF_CMD_RECORD  FAKE_MAP_PERF + FAKE_SYM_OFFSET3
+#define FAKE_IP_BASH_MAIN  FAKE_MAP_BASH + FAKE_SYM_OFFSET1
+#define FAKE_IP_BASH_XMALLOC  FAKE_MAP_BASH + FAKE_SYM_OFFSET2
+#define FAKE_IP_BASH_XFREE  FAKE_MAP_BASH + FAKE_SYM_OFFSET3
+#define FAKE_IP_LIBC_MALLOC  FAKE_MAP_LIBC + FAKE_SYM_OFFSET1
+#define FAKE_IP_LIBC_FREE  FAKE_MAP_LIBC + FAKE_SYM_OFFSET2
+#define FAKE_IP_LIBC_REALLOC  FAKE_MAP_LIBC + FAKE_SYM_OFFSET3
+#define FAKE_IP_KERNEL_SCHEDULE  FAKE_MAP_KERNEL + FAKE_SYM_OFFSET1
+#define FAKE_IP_KERNEL_PAGE_FAULT  FAKE_MAP_KERNEL + FAKE_SYM_OFFSET2
+#define FAKE_IP_KERNEL_SYS_PERF_EVENT_OPEN  FAKE_MAP_KERNEL + FAKE_SYM_OFFSET3
+
 /*
  * The setup_fake_machine() provides a test environment which consists
  * of 3 processes that have 3 mappings and in turn, have 3 symbols
@@ -13,7 +41,7 @@ struct machines;
  * .............  .............  ...................
  *    perf:  100           perf  main
  *    perf:  100           perf  run_command
- *    perf:  100           perf  comd_record
+ *    perf:  100           perf  cmd_record
  *    perf:  100           libc  malloc
  *    perf:  100           libc  free
  *    perf:  100           libc  realloc
@@ -22,7 +50,7 @@ struct machines;
  *    perf:  100       [kernel]  sys_perf_event_open
  *    perf:  200           perf  main
  *    perf:  200           perf  run_command
- *    perf:  200           perf  comd_record
+ *    perf:  200           perf  cmd_record
  *    perf:  200           libc  malloc
  *    perf:  200           libc  free
  *    perf:  200           libc  realloc
diff --git a/tools/perf/tests/hists_filter.c b/tools/perf/tests/hists_filter.c
index 3539403..821f581 100644
--- a/tools/perf/tests/hists_filter.c
+++ b/tools/perf/tests/hists_filter.c
@@ -21,25 +21,25 @@ struct sample {
 /* For the numbers, see hists_common.c */
 static struct sample fake_samples[] = {
 	/* perf [kernel] schedule() */
-	{ .pid = 100, .ip = 0xf0000 + 700, },
+	{ .pid = FAKE_PID_PERF1, .ip = FAKE_IP_KERNEL_SCHEDULE, },
 	/* perf [perf]   main() */
-	{ .pid = 100, .ip = 0x40000 + 700, },
+	{ .pid = FAKE_PID_PERF1, .ip = FAKE_IP_PERF_MAIN, },
 	/* perf [libc]   malloc() */
-	{ .pid = 100, .ip = 0x50000 + 700, },
+	{ .pid = FAKE_PID_PERF1, .ip = FAKE_IP_LIBC_MALLOC, },
 	/* perf [perf]   main() */
-	{ .pid = 200, .ip = 0x40000 + 700, }, /* will be merged */
+	{ .pid = FAKE_PID_PERF2, .ip = FAKE_IP_PERF_MAIN, }, /* will be merged */
 	/* perf [perf]   cmd_record() */
-	{ .pid = 200, .ip = 0x40000 + 900, },
+	{ .pid = FAKE_PID_PERF2, .ip = FAKE_IP_PERF_CMD_RECORD, },
 	/* perf [kernel] page_fault() */
-	{ .pid = 200, .ip = 0xf0000 + 800, },
+	{ .pid = FAKE_PID_PERF2, .ip = FAKE_IP_KERNEL_PAGE_FAULT, },
 	/* bash [bash]   main() */
-	{ .pid = 300, .ip = 0x40000 + 700, },
+	{ .pid = FAKE_PID_BASH,  .ip = FAKE_IP_BASH_MAIN, },
 	/* bash [bash]   xmalloc() */
-	{ .pid = 300, .ip = 0x40000 + 800, },
+	{ .pid = FAKE_PID_BASH,  .ip = FAKE_IP_BASH_XMALLOC, },
 	/* bash [libc]   malloc() */
-	{ .pid = 300, .ip = 0x50000 + 700, },
+	{ .pid = FAKE_PID_BASH,  .ip = FAKE_IP_LIBC_MALLOC, },
 	/* bash [kernel] page_fault() */
-	{ .pid = 300, .ip = 0xf0000 + 800, },
+	{ .pid = FAKE_PID_BASH,  .ip = FAKE_IP_KERNEL_PAGE_FAULT, },
 };
 
 static int add_hist_entries(struct perf_evlist *evlist,
@@ -47,7 +47,7 @@ static int add_hist_entries(struct perf_evlist *evlist,
 {
 	struct perf_evsel *evsel;
 	struct addr_location al;
-	struct perf_sample sample = { .cpu = 0, };
+	struct perf_sample sample = { .period = 100, };
 	size_t i;
 
 	/*
@@ -75,7 +75,6 @@ static int add_hist_entries(struct perf_evlist *evlist,
 			sample.pid = fake_samples[i].pid;
 			sample.tid = fake_samples[i].pid;
 			sample.ip = fake_samples[i].ip;
-			sample.period = 100;
 
 			if (perf_event__preprocess_sample(&event, machine, &al,
 							  &sample) < 0)
diff --git a/tools/perf/tests/hists_link.c b/tools/perf/tests/hists_link.c
index ca6693b..d4b34b0 100644
--- a/tools/perf/tests/hists_link.c
+++ b/tools/perf/tests/hists_link.c
@@ -21,41 +21,41 @@ struct sample {
 /* For the numbers, see hists_common.c */
 static struct sample fake_common_samples[] = {
 	/* perf [kernel] schedule() */
-	{ .pid = 100, .ip = 0xf0000 + 700, },
+	{ .pid = FAKE_PID_PERF1, .ip = FAKE_IP_KERNEL_SCHEDULE, },
 	/* perf [perf]   main() */
-	{ .pid = 200, .ip = 0x40000 + 700, },
+	{ .pid = FAKE_PID_PERF2, .ip = FAKE_IP_PERF_MAIN, },
 	/* perf [perf]   cmd_record() */
-	{ .pid = 200, .ip = 0x40000 + 900, },
+	{ .pid = FAKE_PID_PERF2, .ip = FAKE_IP_PERF_CMD_RECORD, },
 	/* bash [bash]   xmalloc() */
-	{ .pid = 300, .ip = 0x40000 + 800, },
+	{ .pid = FAKE_PID_BASH,  .ip = FAKE_IP_BASH_XMALLOC, },
 	/* bash [libc]   malloc() */
-	{ .pid = 300, .ip = 0x50000 + 700, },
+	{ .pid = FAKE_PID_BASH,  .ip = FAKE_IP_LIBC_MALLOC, },
 };
 
 static struct sample fake_samples[][5] = {
 	{
 		/* perf [perf]   run_command() */
-		{ .pid = 100, .ip = 0x40000 + 800, },
+		{ .pid = FAKE_PID_PERF1, .ip = FAKE_IP_PERF_RUN_COMMAND, },
 		/* perf [libc]   malloc() */
-		{ .pid = 100, .ip = 0x50000 + 700, },
+		{ .pid = FAKE_PID_PERF1, .ip = FAKE_IP_LIBC_MALLOC, },
 		/* perf [kernel] page_fault() */
-		{ .pid = 100, .ip = 0xf0000 + 800, },
+		{ .pid = FAKE_PID_PERF1, .ip = FAKE_IP_KERNEL_PAGE_FAULT, },
 		/* perf [kernel] sys_perf_event_open() */
-		{ .pid = 200, .ip = 0xf0000 + 900, },
+		{ .pid = FAKE_PID_PERF2, .ip = FAKE_IP_KERNEL_SYS_PERF_EVENT_OPEN, },
 		/* bash [libc]   free() */
-		{ .pid = 300, .ip = 0x50000 + 800, },
+		{ .pid = FAKE_PID_BASH,  .ip = FAKE_IP_LIBC_FREE, },
 	},
 	{
 		/* perf [libc]   free() */
-		{ .pid = 200, .ip = 0x50000 + 800, },
+		{ .pid = FAKE_PID_PERF2, .ip = FAKE_IP_LIBC_FREE, },
 		/* bash [libc]   malloc() */
-		{ .pid = 300, .ip = 0x50000 + 700, }, /* will be merged */
+		{ .pid = FAKE_PID_BASH,  .ip = FAKE_IP_LIBC_MALLOC, }, /* will be merged */
 		/* bash [bash]   xfee() */
-		{ .pid = 300, .ip = 0x40000 + 900, },
+		{ .pid = FAKE_PID_BASH,  .ip = FAKE_IP_BASH_XFREE, },
 		/* bash [libc]   realloc() */
-		{ .pid = 300, .ip = 0x50000 + 900, },
+		{ .pid = FAKE_PID_BASH,  .ip = FAKE_IP_LIBC_REALLOC, },
 		/* bash [kernel] page_fault() */
-		{ .pid = 300, .ip = 0xf0000 + 800, },
+		{ .pid = FAKE_PID_BASH,  .ip = FAKE_IP_KERNEL_PAGE_FAULT, },
 	},
 };
 
@@ -64,7 +64,7 @@ static int add_hist_entries(struct perf_evlist *evlist, struct machine *machine)
 	struct perf_evsel *evsel;
 	struct addr_location al;
 	struct hist_entry *he;
-	struct perf_sample sample = { .cpu = 0, };
+	struct perf_sample sample = { .period = 1, };
 	size_t i = 0, k;
 
 	/*
diff --git a/tools/perf/tests/hists_output.c b/tools/perf/tests/hists_output.c
index d40461e..e3bbd6c 100644
--- a/tools/perf/tests/hists_output.c
+++ b/tools/perf/tests/hists_output.c
@@ -22,25 +22,25 @@ struct sample {
 /* For the numbers, see hists_common.c */
 static struct sample fake_samples[] = {
 	/* perf [kernel] schedule() */
-	{ .cpu = 0, .pid = 100, .ip = 0xf0000 + 700, },
+	{ .cpu = 0, .pid = FAKE_PID_PERF1, .ip = FAKE_IP_KERNEL_SCHEDULE, },
 	/* perf [perf]   main() */
-	{ .cpu = 1, .pid = 100, .ip = 0x40000 + 700, },
+	{ .cpu = 1, .pid = FAKE_PID_PERF1, .ip = FAKE_IP_PERF_MAIN, },
 	/* perf [perf]   cmd_record() */
-	{ .cpu = 1, .pid = 100, .ip = 0x40000 + 900, },
+	{ .cpu = 1, .pid = FAKE_PID_PERF1, .ip = FAKE_IP_PERF_CMD_RECORD, },
 	/* perf [libc]   malloc() */
-	{ .cpu = 1, .pid = 100, .ip = 0x50000 + 700, },
+	{ .cpu = 1, .pid = FAKE_PID_PERF1, .ip = FAKE_IP_LIBC_MALLOC, },
 	/* perf [libc]   free() */
-	{ .cpu = 2, .pid = 100, .ip = 0x50000 + 800, },
+	{ .cpu = 2, .pid = FAKE_PID_PERF1, .ip = FAKE_IP_LIBC_FREE, },
 	/* perf [perf]   main() */
-	{ .cpu = 2, .pid = 200, .ip = 0x40000 + 700, },
+	{ .cpu = 2, .pid = FAKE_PID_PERF2, .ip = FAKE_IP_PERF_MAIN, },
 	/* perf [kernel] page_fault() */
-	{ .cpu = 2, .pid = 200, .ip = 0xf0000 + 800, },
+	{ .cpu = 2, .pid = FAKE_PID_PERF2, .ip = FAKE_IP_KERNEL_PAGE_FAULT, },
 	/* bash [bash]   main() */
-	{ .cpu = 3, .pid = 300, .ip = 0x40000 + 700, },
+	{ .cpu = 3, .pid = FAKE_PID_BASH,  .ip = FAKE_IP_BASH_MAIN, },
 	/* bash [bash]   xmalloc() */
-	{ .cpu = 0, .pid = 300, .ip = 0x40000 + 800, },
+	{ .cpu = 0, .pid = FAKE_PID_BASH,  .ip = FAKE_IP_BASH_XMALLOC, },
 	/* bash [kernel] page_fault() */
-	{ .cpu = 1, .pid = 300, .ip = 0xf0000 + 800, },
+	{ .cpu = 1, .pid = FAKE_PID_BASH,  .ip = FAKE_IP_KERNEL_PAGE_FAULT, },
 };
 
 static int add_hist_entries(struct hists *hists, struct machine *machine)
