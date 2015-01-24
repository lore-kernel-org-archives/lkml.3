Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736AbbAXSPg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 13:15:36 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:8390 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754223AbbAXSOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 13:14:51 -0500
Message-Id: <20150124181449.157590751@goodmis.org>
User-Agent: quilt/0.61-1
Date: Sat, 24 Jan 2015 13:13:35 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 5/5] perf: Make perf aware of tracefs
References: <20150124181330.195149364@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0005-perf-Make-perf-aware-of-tracefs.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

As tracefs may be mounted instead of debugfs to get to the event directories,
have perf know about tracefs, and use that file system over debugfs if it
is present.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/perf/tests/open-syscall-all-cpus.c |  7 +++-
 tools/perf/tests/open-syscall.c          |  7 +++-
 tools/perf/tests/parse-events.c          | 13 +++++--
 tools/perf/util/cache.h                  |  1 +
 tools/perf/util/evlist.c                 |  7 ++--
 tools/perf/util/parse-events.c           | 15 +++++---
 tools/perf/util/parse-events.h           |  2 +-
 tools/perf/util/probe-event.c            | 24 ++++++++-----
 tools/perf/util/util.c                   | 60 ++++++++++++++++++++++++++------
 tools/perf/util/util.h                   |  1 +
 10 files changed, 106 insertions(+), 31 deletions(-)

diff --git a/tools/perf/tests/open-syscall-all-cpus.c b/tools/perf/tests/open-syscall-all-cpus.c
index 8fa82d1700c7..21969e99ea46 100644
--- a/tools/perf/tests/open-syscall-all-cpus.c
+++ b/tools/perf/tests/open-syscall-all-cpus.c
@@ -29,7 +29,12 @@ int test__open_syscall_event_on_all_cpus(void)
 
 	evsel = perf_evsel__newtp("syscalls", "sys_enter_open");
 	if (evsel == NULL) {
-		pr_debug("is debugfs mounted on /sys/kernel/debug?\n");
+		if (tracefs_configured())
+			pr_debug("is tracefs mounted on /sys/kernel/debug?\n");
+		else if (debugfs_configured())
+			pr_debug("is debugfs mounted on /sys/kernel/debug?\n");
+		else
+			pr_debug("Neither tracefs or debugfs is enabled in this kernel\n");
 		goto out_thread_map_delete;
 	}
 
diff --git a/tools/perf/tests/open-syscall.c b/tools/perf/tests/open-syscall.c
index a33b2daae40f..4250e40234d2 100644
--- a/tools/perf/tests/open-syscall.c
+++ b/tools/perf/tests/open-syscall.c
@@ -18,7 +18,12 @@ int test__open_syscall_event(void)
 
 	evsel = perf_evsel__newtp("syscalls", "sys_enter_open");
 	if (evsel == NULL) {
-		pr_debug("is debugfs mounted on /sys/kernel/debug?\n");
+		if (tracefs_configured())
+			pr_debug("is tracefs mounted on /sys/kernel/debug?\n");
+		else if (debugfs_configured())
+			pr_debug("is debugfs mounted on /sys/kernel/debug?\n");
+		else
+			pr_debug("Neither tracefs or debugfs is enabled in this kernel\n");
 		goto out_thread_map_delete;
 	}
 
diff --git a/tools/perf/tests/parse-events.c b/tools/perf/tests/parse-events.c
index 7f2f51f93619..ce474fba5a92 100644
--- a/tools/perf/tests/parse-events.c
+++ b/tools/perf/tests/parse-events.c
@@ -3,6 +3,7 @@
 #include "evsel.h"
 #include "evlist.h"
 #include <api/fs/fs.h>
+#include <api/fs/tracefs.h>
 #include <api/fs/debugfs.h>
 #include "tests.h"
 #include "debug.h"
@@ -1149,11 +1150,19 @@ static int count_tracepoints(void)
 {
 	char events_path[PATH_MAX];
 	struct dirent *events_ent;
+	const char *mountpoint;
 	DIR *events_dir;
 	int cnt = 0;
 
-	scnprintf(events_path, PATH_MAX, "%s/tracing/events",
-		  debugfs_find_mountpoint());
+	mountpoint = tracefs_find_mountpoint();
+	if (mountpoint) {
+		scnprintf(events_path, PATH_MAX, "%s/events",
+			  mountpoint);
+	} else {
+		mountpoint = debugfs_find_mountpoint();
+		scnprintf(events_path, PATH_MAX, "%s/tracing/events",
+			  mountpoint);
+	}
 
 	events_dir = opendir(events_path);
 
diff --git a/tools/perf/util/cache.h b/tools/perf/util/cache.h
index 5cf9e1b5989d..99f7f8bd5fcd 100644
--- a/tools/perf/util/cache.h
+++ b/tools/perf/util/cache.h
@@ -17,6 +17,7 @@
 #define EXEC_PATH_ENVIRONMENT "PERF_EXEC_PATH"
 #define DEFAULT_PERF_DIR_ENVIRONMENT ".perf"
 #define PERF_DEBUGFS_ENVIRONMENT "PERF_DEBUGFS_DIR"
+#define PERF_TRACEFS_ENVIRONMENT "PERF_TRACEFS_DIR"
 
 typedef int (*config_fn_t)(const char *, const char *, void *);
 extern int perf_default_config(const char *, const char *, void *);
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index cbab1fb77b1d..cbe7ac93bedb 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -1444,10 +1444,11 @@ int perf_evlist__strerror_tp(struct perf_evlist *evlist __maybe_unused,
 	switch (err) {
 	case ENOENT:
 		scnprintf(buf, size, "%s",
-			  "Error:\tUnable to find debugfs\n"
+			  "Error:\tUnable to find tracefs or debugfs\n"
 			  "Hint:\tWas your kernel was compiled with debugfs support?\n"
-			  "Hint:\tIs the debugfs filesystem mounted?\n"
-			  "Hint:\tTry 'sudo mount -t debugfs nodev /sys/kernel/debug'");
+			  "Hint:\tIs the debugfs or tracefs filesystem mounted?\n"
+			  "Hint:\tTry 'sudo mount -t tracefs nodev /sys/kernel/tracing'\n"
+			  "Hint:\t or 'sudo mount -t debugfs nodev /sys/kernel/debug'");
 		break;
 	case EACCES:
 		scnprintf(buf, size,
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 77b43fe43d55..62f996aa1a28 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -30,6 +30,13 @@ extern int parse_events_debug;
 #endif
 int parse_events_parse(void *data, void *scanner);
 
+static int perf_valid_mountpoint(const char *fs)
+{
+	if (!tracefs_valid_mountpoint(fs))
+		return 0;
+	return debugfs_valid_mountpoint(fs);
+}
+
 static struct perf_pmu_event_symbol *perf_pmu_events_list;
 /*
  * The variable indicates the number of supported pmu event symbols.
@@ -175,7 +182,7 @@ struct tracepoint_path *tracepoint_id_to_path(u64 config)
 	char evt_path[MAXPATHLEN];
 	char dir_path[MAXPATHLEN];
 
-	if (debugfs_valid_mountpoint(tracing_events_path))
+	if (perf_valid_mountpoint(tracing_events_path))
 		return NULL;
 
 	sys_dir = opendir(tracing_events_path);
@@ -475,7 +482,7 @@ int parse_events_add_tracepoint(struct list_head *list, int *idx,
 {
 	int ret;
 
-	ret = debugfs_valid_mountpoint(tracing_events_path);
+	ret = perf_valid_mountpoint(tracing_events_path);
 	if (ret)
 		return ret;
 
@@ -1110,7 +1117,7 @@ void print_tracepoint_events(const char *subsys_glob, const char *event_glob,
 	char dir_path[MAXPATHLEN];
 	char sbuf[STRERR_BUFSIZE];
 
-	if (debugfs_valid_mountpoint(tracing_events_path)) {
+	if (perf_valid_mountpoint(tracing_events_path)) {
 		printf("  [ Tracepoints not available: %s ]\n",
 			strerror_r(errno, sbuf, sizeof(sbuf)));
 		return;
@@ -1162,7 +1169,7 @@ int is_valid_tracepoint(const char *event_string)
 	char evt_path[MAXPATHLEN];
 	char dir_path[MAXPATHLEN];
 
-	if (debugfs_valid_mountpoint(tracing_events_path))
+	if (perf_valid_mountpoint(tracing_events_path))
 		return 0;
 
 	sys_dir = opendir(tracing_events_path);
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index db2cf78ff0f3..87e3434af124 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -121,6 +121,6 @@ void print_tracepoint_events(const char *subsys_glob, const char *event_glob,
 int print_hwcache_events(const char *event_glob, bool name_only);
 extern int is_valid_tracepoint(const char *event_string);
 
-extern int valid_debugfs_mount(const char *debugfs);
+int valid_event_mount(const char *eventfs);
 
 #endif /* __PERF_PARSE_EVENTS_H */
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 7f9b8632e433..9f26913713b2 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -41,6 +41,7 @@
 #include "symbol.h"
 #include "thread.h"
 #include <api/fs/debugfs.h>
+#include <api/fs/tracefs.h>
 #include "trace-event.h"	/* For __maybe_unused */
 #include "probe-event.h"
 #include "probe-finder.h"
@@ -1805,7 +1806,7 @@ static void print_open_warning(int err, bool is_kprobe)
 			   " - please rebuild kernel with %s.\n",
 			   is_kprobe ? 'k' : 'u', config);
 	} else if (err == -ENOTSUP)
-		pr_warning("Debugfs is not mounted.\n");
+		pr_warning("Tracefs or debugfs is not mounted.\n");
 	else
 		pr_warning("Failed to open %cprobe_events: %s\n",
 			   is_kprobe ? 'k' : 'u',
@@ -1816,7 +1817,7 @@ static void print_both_open_warning(int kerr, int uerr)
 {
 	/* Both kprobes and uprobes are disabled, warn it. */
 	if (kerr == -ENOTSUP && uerr == -ENOTSUP)
-		pr_warning("Debugfs is not mounted.\n");
+		pr_warning("Tracefs or debugfs is not mounted.\n");
 	else if (kerr == -ENOENT && uerr == -ENOENT)
 		pr_warning("Please rebuild kernel with CONFIG_KPROBE_EVENTS "
 			   "or/and CONFIG_UPROBE_EVENTS.\n");
@@ -1833,13 +1834,20 @@ static int open_probe_events(const char *trace_file, bool readwrite)
 {
 	char buf[PATH_MAX];
 	const char *__debugfs;
+	const char *tracing_dir = "";
 	int ret;
 
-	__debugfs = debugfs_find_mountpoint();
-	if (__debugfs == NULL)
-		return -ENOTSUP;
+	__debugfs = tracefs_find_mountpoint();
+	if (__debugfs == NULL) {
+		tracing_dir = "tracing/";
 
-	ret = e_snprintf(buf, PATH_MAX, "%s/%s", __debugfs, trace_file);
+		__debugfs = debugfs_find_mountpoint();
+		if (__debugfs == NULL)
+			return -ENOTSUP;
+	}
+
+	ret = e_snprintf(buf, PATH_MAX, "%s/%s%s",
+			 __debugfs, tracing_dir, trace_file);
 	if (ret >= 0) {
 		pr_debug("Opening %s write=%d\n", buf, readwrite);
 		if (readwrite && !probe_event_dry_run)
@@ -1855,12 +1863,12 @@ static int open_probe_events(const char *trace_file, bool readwrite)
 
 static int open_kprobe_events(bool readwrite)
 {
-	return open_probe_events("tracing/kprobe_events", readwrite);
+	return open_probe_events("kprobe_events", readwrite);
 }
 
 static int open_uprobe_events(bool readwrite)
 {
-	return open_probe_events("tracing/uprobe_events", readwrite);
+	return open_probe_events("uprobe_events", readwrite);
 }
 
 /* Get raw string list of current kprobe_events  or uprobe_events */
diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index b86744f29eef..6fe49d4922f3 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -303,13 +303,26 @@ void set_term_quiet_input(struct termios *old)
 	tcsetattr(0, TCSANOW, &tc);
 }
 
-static void set_tracing_events_path(const char *mountpoint)
+static void set_tracing_events_path(const char *tracing, const char *mountpoint)
 {
-	snprintf(tracing_events_path, sizeof(tracing_events_path), "%s/%s",
-		 mountpoint, "tracing/events");
+	snprintf(tracing_events_path, sizeof(tracing_events_path), "%s/%s%s",
+		 mountpoint, tracing, "events");
 }
 
-const char *perf_debugfs_mount(const char *mountpoint)
+static const char *__perf_tracefs_mount(const char *mountpoint)
+{
+	const char *mnt;
+
+	mnt = tracefs_mount(mountpoint);
+	if (!mnt)
+		return NULL;
+
+	set_tracing_events_path("", mnt);
+
+	return mnt;
+}
+
+static const char *__perf_debugfs_mount(const char *mountpoint)
 {
 	const char *mnt;
 
@@ -317,7 +330,20 @@ const char *perf_debugfs_mount(const char *mountpoint)
 	if (!mnt)
 		return NULL;
 
-	set_tracing_events_path(mnt);
+	set_tracing_events_path("tracing/", mnt);
+
+	return mnt;
+}
+
+const char *perf_debugfs_mount(const char *mountpoint)
+{
+	const char *mnt;
+
+	mnt = __perf_tracefs_mount(mountpoint);
+	if (mnt)
+		return mnt;
+
+	mnt = __perf_debugfs_mount(mountpoint);
 
 	return mnt;
 }
@@ -325,12 +351,19 @@ const char *perf_debugfs_mount(const char *mountpoint)
 void perf_debugfs_set_path(const char *mntpt)
 {
 	snprintf(debugfs_mountpoint, strlen(debugfs_mountpoint), "%s", mntpt);
-	set_tracing_events_path(mntpt);
+	set_tracing_events_path("tracing/", mntpt);
+}
+
+static const char *find_tracefs(void)
+{
+	const char *path = __perf_tracefs_mount(NULL);
+
+	return path;
 }
 
 static const char *find_debugfs(void)
 {
-	const char *path = perf_debugfs_mount(NULL);
+	const char *path = __perf_debugfs_mount(NULL);
 
 	if (!path)
 		fprintf(stderr, "Your kernel does not support the debugfs filesystem");
@@ -344,6 +377,7 @@ static const char *find_debugfs(void)
  */
 const char *find_tracing_dir(void)
 {
+	const char *tracing_dir = "";
 	static char *tracing;
 	static int tracing_found;
 	const char *debugfs;
@@ -351,11 +385,15 @@ const char *find_tracing_dir(void)
 	if (tracing_found)
 		return tracing;
 
-	debugfs = find_debugfs();
-	if (!debugfs)
-		return NULL;
+	debugfs = find_tracefs();
+	if (!debugfs) {
+		tracing_dir = "/tracing";
+		debugfs = find_debugfs();
+		if (!debugfs)
+			return NULL;
+	}
 
-	if (asprintf(&tracing, "%s/tracing", debugfs) < 0)
+	if (asprintf(&tracing, "%s%s", tracing_dir, debugfs) < 0)
 		return NULL;
 
 	tracing_found = 1;
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 027a5153495c..73c2f8e557ab 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -75,6 +75,7 @@
 #include <linux/types.h>
 #include <sys/ttydefaults.h>
 #include <api/fs/debugfs.h>
+#include <api/fs/tracefs.h>
 #include <termios.h>
 #include <linux/bitops.h>
 #include <termios.h>
-- 
2.1.4


