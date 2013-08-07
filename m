Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932826Ab3HGLeA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 07:34:00 -0400
Received: from mga09.intel.com ([134.134.136.24]:29189 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757501Ab3HGLdz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 07:33:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,832,1367996400"; 
   d="scan'208";a="383214681"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH V4 09/13] perf tools: add kcore to the object code reading test
Date: Wed,  7 Aug 2013 14:38:53 +0300
Message-Id: <1375875537-4509-10-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1375875537-4509-1-git-send-email-adrian.hunter@intel.com>
References: <1375875537-4509-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the "object code reading" test attempt to read from
kcore.

The test uses objdump which struggles with kcore. i.e.
doesn't always work, sometimes takes a long time.
The test has been made to work around those issues.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/tests/code-reading.c | 100 ++++++++++++++++++++++++++++++++--------
 1 file changed, 82 insertions(+), 18 deletions(-)

diff --git a/tools/perf/tests/code-reading.c b/tools/perf/tests/code-reading.c
index 0c7b052..8e0943b 100644
--- a/tools/perf/tests/code-reading.c
+++ b/tools/perf/tests/code-reading.c
@@ -20,6 +20,11 @@
 #define BUFSZ	1024
 #define READLEN	128
 
+struct state {
+	u64 done[1024];
+	size_t done_cnt;
+};
+
 static unsigned int hex(char c)
 {
 	if (c >= '0' && c <= '9')
@@ -107,6 +112,9 @@ static int read_via_objdump(const char *filename, u64 addr, void *buf,
 
 	pr_debug("Objdump command is: %s\n", cmd);
 
+	/* Ignore objdump errors */
+	strcat(cmd, " 2>/dev/null");
+
 	f = popen(cmd, "r");
 	if (!f) {
 		pr_debug("popen failed\n");
@@ -126,7 +134,8 @@ static int read_via_objdump(const char *filename, u64 addr, void *buf,
 }
 
 static int read_object_code(u64 addr, size_t len, u8 cpumode,
-			    struct thread *thread, struct machine *machine)
+			    struct thread *thread, struct machine *machine,
+			    struct state *state)
 {
 	struct addr_location al;
 	unsigned char buf1[BUFSZ];
@@ -146,7 +155,8 @@ static int read_object_code(u64 addr, size_t len, u8 cpumode,
 
 	pr_debug("File is: %s\n", al.map->dso->long_name);
 
-	if (al.map->dso->symtab_type == DSO_BINARY_TYPE__KALLSYMS) {
+	if (al.map->dso->symtab_type == DSO_BINARY_TYPE__KALLSYMS &&
+	    !dso__is_kcore(al.map->dso)) {
 		pr_debug("Unexpected kernel address - skipping\n");
 		return 0;
 	}
@@ -175,6 +185,24 @@ static int read_object_code(u64 addr, size_t len, u8 cpumode,
 	if (map__load(al.map, NULL))
 		return -1;
 
+	/* objdump struggles with kcore - try each map only once */
+	if (dso__is_kcore(al.map->dso)) {
+		size_t d;
+
+		for (d = 0; d < state->done_cnt; d++) {
+			if (state->done[d] == al.map->start) {
+				pr_debug("kcore map tested already");
+				pr_debug(" - skipping\n");
+				return 0;
+			}
+		}
+		if (state->done_cnt >= ARRAY_SIZE(state->done)) {
+			pr_debug("Too many kcore maps - skipping\n");
+			return 0;
+		}
+		state->done[state->done_cnt++] = al.map->start;
+	}
+
 	/* Read the object code using objdump */
 	objdump_addr = map__rip_2objdump(al.map, al.addr);
 	ret = read_via_objdump(al.map->dso->long_name, objdump_addr, buf2, len);
@@ -186,10 +214,19 @@ static int read_object_code(u64 addr, size_t len, u8 cpumode,
 		if (cpumode == PERF_RECORD_MISC_KERNEL ||
 		    cpumode == PERF_RECORD_MISC_GUEST_KERNEL) {
 			len -= ret;
-			if (len)
+			if (len) {
 				pr_debug("Reducing len to %zu\n", len);
-			else
+			} else if (dso__is_kcore(al.map->dso)) {
+				/*
+				 * objdump cannot handle very large segments
+				 * that may be found in kcore.
+				 */
+				pr_debug("objdump failed for kcore");
+				pr_debug(" - skipping\n");
+				return 0;
+			} else {
 				return -1;
+			}
 		}
 	}
 	if (ret < 0) {
@@ -209,7 +246,7 @@ static int read_object_code(u64 addr, size_t len, u8 cpumode,
 
 static int process_sample_event(struct machine *machine,
 				struct perf_evlist *evlist,
-				union perf_event *event)
+				union perf_event *event, struct state *state)
 {
 	struct perf_sample sample;
 	struct thread *thread;
@@ -228,14 +265,15 @@ static int process_sample_event(struct machine *machine,
 
 	cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
 
-	return read_object_code(sample.ip, READLEN, cpumode, thread, machine);
+	return read_object_code(sample.ip, READLEN, cpumode, thread, machine,
+				state);
 }
 
 static int process_event(struct machine *machine, struct perf_evlist *evlist,
-			 union perf_event *event)
+			 union perf_event *event, struct state *state)
 {
 	if (event->header.type == PERF_RECORD_SAMPLE)
-		return process_sample_event(machine, evlist, event);
+		return process_sample_event(machine, evlist, event, state);
 
 	if (event->header.type < PERF_RECORD_MAX)
 		return machine__process_event(machine, event);
@@ -243,14 +281,15 @@ static int process_event(struct machine *machine, struct perf_evlist *evlist,
 	return 0;
 }
 
-static int process_events(struct machine *machine, struct perf_evlist *evlist)
+static int process_events(struct machine *machine, struct perf_evlist *evlist,
+			  struct state *state)
 {
 	union perf_event *event;
 	int i, ret;
 
 	for (i = 0; i < evlist->nr_mmaps; i++) {
 		while ((event = perf_evlist__mmap_read(evlist, i)) != NULL) {
-			ret = process_event(machine, evlist, event);
+			ret = process_event(machine, evlist, event, state);
 			if (ret < 0)
 				return ret;
 		}
@@ -331,10 +370,12 @@ static void do_something(void)
 enum {
 	TEST_CODE_READING_OK,
 	TEST_CODE_READING_NO_VMLINUX,
+	TEST_CODE_READING_NO_KCORE,
 	TEST_CODE_READING_NO_ACCESS,
+	TEST_CODE_READING_NO_KERNEL_OBJ,
 };
 
-static int do_test_code_reading(void)
+static int do_test_code_reading(bool try_kcore)
 {
 	struct machines machines;
 	struct machine *machine;
@@ -348,6 +389,9 @@ static int do_test_code_reading(void)
 			.uses_mmap   = true,
 		},
 	};
+	struct state state = {
+		.done_cnt = 0,
+	};
 	struct thread_map *threads = NULL;
 	struct cpu_map *cpus = NULL;
 	struct perf_evlist *evlist = NULL;
@@ -355,7 +399,7 @@ static int do_test_code_reading(void)
 	int err = -1, ret;
 	pid_t pid;
 	struct map *map;
-	bool have_vmlinux, excl_kernel = false;
+	bool have_vmlinux, have_kcore, excl_kernel = false;
 
 	pid = getpid();
 
@@ -368,6 +412,10 @@ static int do_test_code_reading(void)
 		goto out_err;
 	}
 
+	/* Force the use of kallsyms instead of vmlinux to try kcore */
+	if (try_kcore)
+		symbol_conf.kallsyms_name = "/proc/kallsyms";
+
 	/* Load kernel map */
 	map = machine->vmlinux_maps[MAP__FUNCTION];
 	ret = map__load(map, NULL);
@@ -375,9 +423,15 @@ static int do_test_code_reading(void)
 		pr_debug("map__load failed\n");
 		goto out_err;
 	}
-	have_vmlinux = map->dso->symtab_type == DSO_BINARY_TYPE__VMLINUX;
-	/* No point getting kernel events if there is no vmlinux */
-	if (!have_vmlinux)
+	have_vmlinux = dso__is_vmlinux(map->dso);
+	have_kcore = dso__is_kcore(map->dso);
+
+	/* 2nd time through we just try kcore */
+	if (try_kcore && !have_kcore)
+		return TEST_CODE_READING_NO_KCORE;
+
+	/* No point getting kernel events if there is no kernel object */
+	if (!have_vmlinux && !have_kcore)
 		excl_kernel = true;
 
 	threads = thread_map__new_by_tid(pid);
@@ -461,11 +515,13 @@ static int do_test_code_reading(void)
 
 	perf_evlist__disable(evlist);
 
-	ret = process_events(machine, evlist);
+	ret = process_events(machine, evlist, &state);
 	if (ret < 0)
 		goto out_err;
 
-	if (!have_vmlinux)
+	if (!have_vmlinux && !have_kcore && !try_kcore)
+		err = TEST_CODE_READING_NO_KERNEL_OBJ;
+	else if (!have_vmlinux && !try_kcore)
 		err = TEST_CODE_READING_NO_VMLINUX;
 	else if (excl_kernel)
 		err = TEST_CODE_READING_NO_ACCESS;
@@ -492,7 +548,9 @@ int test__code_reading(void)
 {
 	int ret;
 
-	ret = do_test_code_reading();
+	ret = do_test_code_reading(false);
+	if (!ret)
+		ret = do_test_code_reading(true);
 
 	switch (ret) {
 	case TEST_CODE_READING_OK:
@@ -500,9 +558,15 @@ int test__code_reading(void)
 	case TEST_CODE_READING_NO_VMLINUX:
 		fprintf(stderr, " (no vmlinux)");
 		return 0;
+	case TEST_CODE_READING_NO_KCORE:
+		fprintf(stderr, " (no kcore)");
+		return 0;
 	case TEST_CODE_READING_NO_ACCESS:
 		fprintf(stderr, " (no access)");
 		return 0;
+	case TEST_CODE_READING_NO_KERNEL_OBJ:
+		fprintf(stderr, " (no kernel obj)");
+		return 0;
 	default:
 		return -1;
 	};
-- 
1.7.11.7

