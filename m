Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756259Ab3GYNzb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 09:55:31 -0400
Received: from mga14.intel.com ([143.182.124.37]:40319 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755921Ab3GYNz2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 09:55:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,743,1367996400"; 
   d="scan'208";a="273137111"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 8/9] perf tools: add kcore to the object code reading test
Date: Thu, 25 Jul 2013 17:01:29 +0300
Message-Id: <1374760890-30558-9-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1374760890-30558-1-git-send-email-adrian.hunter@intel.com>
References: <1374760890-30558-1-git-send-email-adrian.hunter@intel.com>
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
 tools/perf/tests/code-reading.c | 77 +++++++++++++++++++++++++++++++++++------
 1 file changed, 67 insertions(+), 10 deletions(-)

diff --git a/tools/perf/tests/code-reading.c b/tools/perf/tests/code-reading.c
index 087e6cf..5fffc6f 100644
--- a/tools/perf/tests/code-reading.c
+++ b/tools/perf/tests/code-reading.c
@@ -109,6 +109,9 @@ static int read_via_objdump(const char *filename, u64 addr, void *buf,
 
 	pr_debug("Objdump command is: %s\n", cmd);
 
+	/* Ignore objdump errors */
+	strcat(cmd, " 2>/dev/null");
+
 	f = popen(cmd, "r");
 	if (!f) {
 		pr_debug("popen failed\n");
@@ -148,7 +151,8 @@ static int read_object_code(u64 addr, size_t len, u8 cpumode,
 
 	pr_debug("File is: %s\n", al.map->dso->long_name);
 
-	if (al.map->dso->symtab_type == DSO_BINARY_TYPE__KALLSYMS) {
+	if (al.map->dso->symtab_type == DSO_BINARY_TYPE__KALLSYMS &&
+	    !dso__is_kcore(al.map->dso)) {
 		pr_debug("Unexpected kernel address - skipping\n");
 		return 0;
 	}
@@ -177,6 +181,26 @@ static int read_object_code(u64 addr, size_t len, u8 cpumode,
 	if (map__load(al.map, NULL))
 		return -1;
 
+	/* objdump struggles with kcore - try each map only once */
+	if (dso__is_kcore(al.map->dso)) {
+		static u64 done[1024];
+		static size_t done_cnt;
+		size_t d;
+
+		for (d = 0; d < done_cnt; d++) {
+			if (done[d] == al.map->start) {
+				pr_debug("kcore map tested already");
+				pr_debug(" - skipping\n");
+				return 0;
+			}
+		}
+		if (done_cnt >= ARRAY_SIZE(done)) {
+			pr_debug("Too many kcore maps - skipping\n");
+			return 0;
+		}
+		done[done_cnt++] = al.map->start;
+	}
+
 	/* Read the object code using objdump */
 	objdump_addr = map__rip_2objdump(al.map, al.addr);
 	ret = read_via_objdump(al.map->dso->long_name, objdump_addr, buf2, len);
@@ -188,10 +212,19 @@ static int read_object_code(u64 addr, size_t len, u8 cpumode,
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
@@ -325,10 +358,12 @@ static void do_something(void)
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
@@ -349,7 +384,7 @@ static int do_test_code_reading(void)
 	int err = -1, ret;
 	pid_t pid;
 	struct map *map;
-	bool have_vmlinux, excl_kernel = false;
+	bool have_vmlinux, have_kcore, excl_kernel = false;
 
 	pid = getpid();
 
@@ -362,6 +397,10 @@ static int do_test_code_reading(void)
 		goto out_err;
 	}
 
+	/* Force the use of kallsyms instead of vmlinux to try kcore */
+	if (try_kcore)
+		symbol_conf.kallsyms_name = "/proc/kallsyms";
+
 	/* Load kernel map */
 	map = machine->vmlinux_maps[MAP__FUNCTION];
 	ret = map__load(map, NULL);
@@ -369,9 +408,15 @@ static int do_test_code_reading(void)
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
@@ -457,8 +502,12 @@ static int do_test_code_reading(void)
 	if (ret < 0)
 		goto out_err;
 
-	if (!have_vmlinux)
+	if (!have_vmlinux && !have_kcore && !try_kcore)
+		err = TEST_CODE_READING_NO_KERNEL_OBJ;
+	else if (!have_vmlinux && !try_kcore)
 		err = TEST_CODE_READING_NO_VMLINUX;
+	else if (!have_kcore && try_kcore)
+		err = TEST_CODE_READING_NO_KCORE;
 	else if (excl_kernel)
 		err = TEST_CODE_READING_NO_ACCESS;
 	else
@@ -485,7 +534,9 @@ int test__code_reading(void)
 {
 	int ret;
 
-	ret = do_test_code_reading();
+	ret = do_test_code_reading(false);
+	if (!ret)
+		ret = do_test_code_reading(true);
 
 	switch (ret) {
 	case TEST_CODE_READING_OK:
@@ -493,9 +544,15 @@ int test__code_reading(void)
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

