Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932172AbaLATIh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 14:08:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42529 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754255AbaLATHJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 14:07:09 -0500
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 5/8] perf buildid-cache: Add automated tests
Date: Mon,  1 Dec 2014 20:06:26 +0100
Message-Id: <1417460789-13874-6-git-send-email-jolsa@kernel.org>
In-Reply-To: <1417460789-13874-1-git-send-email-jolsa@kernel.org>
References: <1417460789-13874-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding automated test for buildid-cache command/processing.

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/Makefile.perf          |  7 +++-
 tools/perf/tests/buildid-cache.c  | 88 +++++++++++++++++++++++++++++++++++++++
 tools/perf/tests/buildid-cache.sh | 60 ++++++++++++++++++++++++++
 tools/perf/tests/builtin-test.c   |  8 ++++
 tools/perf/tests/tests.h          |  1 +
 5 files changed, 163 insertions(+), 1 deletion(-)
 create mode 100644 tools/perf/tests/buildid-cache.c
 create mode 100755 tools/perf/tests/buildid-cache.sh

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 478efa9b2364..28a8f64ab49c 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -447,6 +447,7 @@ endif
 LIB_OBJS += $(OUTPUT)tests/mmap-thread-lookup.o
 LIB_OBJS += $(OUTPUT)tests/thread-mg-share.o
 LIB_OBJS += $(OUTPUT)tests/switch-tracking.o
+LIB_OBJS += $(OUTPUT)tests/buildid-cache.o
 
 BUILTIN_OBJS += $(OUTPUT)builtin-annotate.o
 BUILTIN_OBJS += $(OUTPUT)builtin-bench.o
@@ -699,6 +700,9 @@ $(OUTPUT)tests/attr.o: tests/attr.c $(OUTPUT)PERF-CFLAGS
 		'-DBINDIR="$(bindir_SQ)"' -DPYTHON='"$(PYTHON_WORD)"' \
 		$<
 
+$(OUTPUT)tests/buildid-cache.o: tests/buildid-cache.c $(OUTPUT)PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) '-DBINDIR="$(bindir_SQ)"' $<
+
 $(OUTPUT)tests/python-use.o: tests/python-use.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) \
 		-DPYTHONPATH='"$(OUTPUT)python"' \
@@ -944,7 +948,8 @@ endif
 		$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/tests'; \
 		$(INSTALL) tests/attr.py '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/tests'; \
 		$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/tests/attr'; \
-		$(INSTALL) tests/attr/* '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/tests/attr'
+		$(INSTALL) tests/attr/* '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/tests/attr'; \
+		$(INSTALL) tests/buildid-cache.sh '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/tests'
 
 install: install-bin try-install-man install-traceevent-plugins
 
diff --git a/tools/perf/tests/buildid-cache.c b/tools/perf/tests/buildid-cache.c
new file mode 100644
index 000000000000..52dfd2765527
--- /dev/null
+++ b/tools/perf/tests/buildid-cache.c
@@ -0,0 +1,88 @@
+#include <api/fs/fs.h>
+#include "tests.h"
+#include "symbol.h"
+#include "build-id.h"
+#include "debug.h"
+#include "exec_cmd.h"
+
+static int add_kernel(void)
+{
+	char path[PATH_MAX];
+	u8 build_id[BUILD_ID_SIZE];
+	char sbuild_id[BUILD_ID_SIZE * 2 + 1];
+	int ret;
+
+	sprintf(path, "%s/kernel/notes", sysfs__mountpoint());
+
+	ret = sysfs__read_build_id(path, build_id, sizeof(build_id));
+	TEST_ASSERT_VAL("failed to get kernel buildid", !ret);
+
+	build_id__sprintf(build_id, sizeof(build_id), sbuild_id);
+
+	return build_id_cache__add_s(sbuild_id, buildid_dir,
+				     "[kernel.kallsyms]", true, false);
+}
+
+static int __run_script(const char *script, const char *perf, char *cache)
+{
+	char cmd[PATH_MAX * 3 + 5];
+
+	scnprintf(cmd, sizeof(cmd), "%s/buildid-cache.sh %s %s %d",
+		  script, perf, cache, verbose);
+	return system(cmd);
+}
+
+static int run_script(char *cache)
+{
+	struct stat st;
+	char path_perf[PATH_MAX];
+	char path_script[PATH_MAX];
+
+	/* First try development tree tests. */
+	if (!lstat("./tests", &st))
+		return __run_script("./tests", "./perf", cache);
+
+	/* Then installed path. */
+	snprintf(path_script, PATH_MAX, "%s/tests", perf_exec_path());
+	snprintf(path_perf, PATH_MAX, "%s/perf", BINDIR);
+
+	if (!lstat(path_script, &st) && !lstat(path_perf, &st))
+		return __run_script(path_script, path_perf, cache);
+
+	fprintf(stderr, " (omitted)");
+	return 0;
+}
+
+static int __test__buildid_cache(char *cache)
+{
+	set_buildid_dir(cache);
+
+	/*
+	 * Adding [kernel.kallsyms] entry, because we will test
+	 * its removal via perf buildid-cache clean in the
+	 * script part.
+	 * NOTE it's not possible to add [kernel.kallsyms] entry
+	 * by script at the moment.
+	 */
+	TEST_ASSERT_VAL("failed to add [kernel.kallsyms] buildid",
+			!add_kernel());
+
+	TEST_ASSERT_VAL("script failed", !run_script(cache));
+	return 0;
+}
+
+int test__buildid_cache(void)
+{
+	char cache[50];
+
+	/*
+	 * The directory removal is done within
+	 * __test__buildid_cache function.
+	 */
+	snprintf(cache, sizeof(cache), "/tmp/perf-XXXXXX");
+	TEST_ASSERT_VAL("failed to make temp directory", mkdtemp(cache));
+
+	pr_debug("buildid cache directory: %s\n", cache);
+
+	return __test__buildid_cache(cache);
+}
diff --git a/tools/perf/tests/buildid-cache.sh b/tools/perf/tests/buildid-cache.sh
new file mode 100755
index 000000000000..fbd92c278c2a
--- /dev/null
+++ b/tools/perf/tests/buildid-cache.sh
@@ -0,0 +1,60 @@
+#!/bin/sh
+
+perf=$1
+cache=$2
+verbose=$3
+
+function pr_debug
+{
+	if [ "$verbose" -gt "0" ]; then
+		echo "$@"
+	fi
+}
+
+function run_perf
+{
+	$perf --no-pager --buildid-dir $cache $@
+}
+
+# Remove prepared '[kernel.kallsyms]' via 1 byte clean limit
+run_perf buildid-cache clean -a -r 1B 2>/dev/null
+dir="$cache/[kernel.kallsyms]"
+if [ "$(ls -A $cache)" ]; then
+	pr_debug "Failed to remove [kernel.kallsyms] cache files"
+	exit 1
+fi
+
+# add perf binary
+run_perf buildid-cache -a $perf 2>/dev/null
+dir_perf=$cache/`realpath $perf`
+if [ ! -d $dir_perf ]; then
+	pr_debug "Failed to add perf binary into cache"
+	exit 1
+fi
+
+# remove perf binary
+run_perf buildid-cache -r $perf 2>/dev/null
+if [ "$(ls -A $cache)" ]; then
+	pr_debug "Failed to remove perf binary from cache"
+	exit 1
+fi
+
+# add perf binary
+run_perf buildid-cache -a $perf 2>/dev/null
+# add sh binary
+run_perf buildid-cache -a `realpath /bin/sh` 2>/dev/null
+dir_sh=$cache/`realpath /bin/sh`
+if [ ! -d $dir_perf -o ! -d $dir_sh ]; then
+	pr_debug "Failed to add perf/sh binary into cache"
+	exit 1
+fi
+
+# clean all
+run_perf buildid-cache clean -r 2>/dev/null
+if [ "$(ls -A $cache)" ]; then
+	pr_debug "Failed to cleanup the cache"
+	exit 1
+fi
+
+# last command, $cache directory should be empty
+rmdir $cache
diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index 4b7d9ab0f049..5cbe55634181 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -167,6 +167,14 @@ static struct test {
 		.func = test__fdarray__add,
 	},
 	{
+		.desc = "Add fd to a fdarray, making it autogrow",
+		.func = test__fdarray__add,
+	},
+	{
+		.desc = "Test buildid cache",
+		.func = test__buildid_cache,
+	},
+	{
 		.func = NULL,
 	},
 };
diff --git a/tools/perf/tests/tests.h b/tools/perf/tests/tests.h
index 00e776a87a9c..190e3df7431f 100644
--- a/tools/perf/tests/tests.h
+++ b/tools/perf/tests/tests.h
@@ -51,6 +51,7 @@ int test__hists_cumulate(void);
 int test__switch_tracking(void);
 int test__fdarray__filter(void);
 int test__fdarray__add(void);
+int test__buildid_cache(void);
 
 #if defined(__x86_64__) || defined(__i386__) || defined(__arm__)
 #ifdef HAVE_DWARF_UNWIND_SUPPORT
-- 
1.9.3

