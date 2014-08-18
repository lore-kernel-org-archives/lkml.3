Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113AbaHRIYi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 04:24:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51605 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbaHRIYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 04:24:36 -0400
Date: Mon, 18 Aug 2014 01:23:33 -0700
From: tip-bot for Masami Hiramatsu <tipbot@zytor.com>
Message-ID: <tip-6e81c74cbf4b64620170da14844f1dc8a9a5950f@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, naota@elisp.net, namhyung@kernel.org,
        masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        naota@elisp.net, namhyung@kernel.org, masami.hiramatsu.pt@hitachi.com,
        tglx@linutronix.de
In-Reply-To: <20140814022236.3545.3367.stgit@kbuild-fedora.novalocal>
References: <20140814022236.3545.3367.stgit@kbuild-fedora.novalocal>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf util:
  Replace strerror with strerror_r for thread-safety
Git-Commit-ID: 6e81c74cbf4b64620170da14844f1dc8a9a5950f
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

Commit-ID:  6e81c74cbf4b64620170da14844f1dc8a9a5950f
Gitweb:     http://git.kernel.org/tip/6e81c74cbf4b64620170da14844f1dc8a9a5950f
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Thu, 14 Aug 2014 02:22:36 +0000
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 15 Aug 2014 10:58:35 -0300

perf util: Replace strerror with strerror_r for thread-safety

Replaces all strerror with strerror_r in util for making the perf lib
thread-safe.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Naohiro Aota <naota@elisp.net>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20140814022236.3545.3367.stgit@kbuild-fedora.novalocal
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/cloexec.c      | 6 ++++--
 tools/perf/util/data.c         | 8 ++++++--
 tools/perf/util/dso.c          | 8 ++++++--
 tools/perf/util/evlist.c       | 2 +-
 tools/perf/util/evsel.c        | 7 +++++--
 tools/perf/util/parse-events.c | 5 ++++-
 tools/perf/util/run-command.c  | 9 +++++++--
 tools/perf/util/util.c         | 5 +++--
 8 files changed, 36 insertions(+), 14 deletions(-)

diff --git a/tools/perf/util/cloexec.c b/tools/perf/util/cloexec.c
index 4945aa5..47b78b3 100644
--- a/tools/perf/util/cloexec.c
+++ b/tools/perf/util/cloexec.c
@@ -3,6 +3,7 @@
 #include "../perf.h"
 #include "cloexec.h"
 #include "asm/bug.h"
+#include "debug.h"
 
 static unsigned long flag = PERF_FLAG_FD_CLOEXEC;
 
@@ -18,6 +19,7 @@ static int perf_flag_probe(void)
 	int err;
 	int cpu;
 	pid_t pid = -1;
+	char sbuf[STRERR_BUFSIZE];
 
 	cpu = sched_getcpu();
 	if (cpu < 0)
@@ -42,7 +44,7 @@ static int perf_flag_probe(void)
 
 	WARN_ONCE(err != EINVAL && err != EBUSY,
 		  "perf_event_open(..., PERF_FLAG_FD_CLOEXEC) failed with unexpected error %d (%s)\n",
-		  err, strerror(err));
+		  err, strerror_r(err, sbuf, sizeof(sbuf)));
 
 	/* not supported, confirm error related to PERF_FLAG_FD_CLOEXEC */
 	fd = sys_perf_event_open(&attr, pid, cpu, -1, 0);
@@ -50,7 +52,7 @@ static int perf_flag_probe(void)
 
 	if (WARN_ONCE(fd < 0 && err != EBUSY,
 		      "perf_event_open(..., 0) failed unexpectedly with error %d (%s)\n",
-		      err, strerror(err)))
+		      err, strerror_r(err, sbuf, sizeof(sbuf))))
 		return -1;
 
 	close(fd);
diff --git a/tools/perf/util/data.c b/tools/perf/util/data.c
index 29d720c..1921942 100644
--- a/tools/perf/util/data.c
+++ b/tools/perf/util/data.c
@@ -50,12 +50,14 @@ static int open_file_read(struct perf_data_file *file)
 {
 	struct stat st;
 	int fd;
+	char sbuf[STRERR_BUFSIZE];
 
 	fd = open(file->path, O_RDONLY);
 	if (fd < 0) {
 		int err = errno;
 
-		pr_err("failed to open %s: %s", file->path, strerror(err));
+		pr_err("failed to open %s: %s", file->path,
+			strerror_r(err, sbuf, sizeof(sbuf)));
 		if (err == ENOENT && !strcmp(file->path, "perf.data"))
 			pr_err("  (try 'perf record' first)");
 		pr_err("\n");
@@ -88,6 +90,7 @@ static int open_file_read(struct perf_data_file *file)
 static int open_file_write(struct perf_data_file *file)
 {
 	int fd;
+	char sbuf[STRERR_BUFSIZE];
 
 	if (check_backup(file))
 		return -1;
@@ -95,7 +98,8 @@ static int open_file_write(struct perf_data_file *file)
 	fd = open(file->path, O_CREAT|O_RDWR|O_TRUNC, S_IRUSR|S_IWUSR);
 
 	if (fd < 0)
-		pr_err("failed to open %s : %s\n", file->path, strerror(errno));
+		pr_err("failed to open %s : %s\n", file->path,
+			strerror_r(errno, sbuf, sizeof(sbuf)));
 
 	return fd;
 }
diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index bdafd30..55e39dc 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -162,13 +162,15 @@ static void close_first_dso(void);
 static int do_open(char *name)
 {
 	int fd;
+	char sbuf[STRERR_BUFSIZE];
 
 	do {
 		fd = open(name, O_RDONLY);
 		if (fd >= 0)
 			return fd;
 
-		pr_debug("dso open failed, mmap: %s\n", strerror(errno));
+		pr_debug("dso open failed, mmap: %s\n",
+			 strerror_r(errno, sbuf, sizeof(sbuf)));
 		if (!dso__data_open_cnt || errno != EMFILE)
 			break;
 
@@ -530,10 +532,12 @@ static ssize_t cached_read(struct dso *dso, u64 offset, u8 *data, ssize_t size)
 static int data_file_size(struct dso *dso)
 {
 	struct stat st;
+	char sbuf[STRERR_BUFSIZE];
 
 	if (!dso->data.file_size) {
 		if (fstat(dso->data.fd, &st)) {
-			pr_err("dso mmap failed, fstat: %s\n", strerror(errno));
+			pr_err("dso mmap failed, fstat: %s\n",
+				strerror_r(errno, sbuf, sizeof(sbuf)));
 			return -1;
 		}
 		dso->data.file_size = st.st_size;
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 5dcd28c..a3e28b4 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -1295,7 +1295,7 @@ int perf_evlist__strerror_open(struct perf_evlist *evlist __maybe_unused,
 			       int err, char *buf, size_t size)
 {
 	int printed, value;
-	char sbuf[128], *emsg = strerror_r(err, sbuf, sizeof(sbuf));
+	char sbuf[STRERR_BUFSIZE], *emsg = strerror_r(err, sbuf, sizeof(sbuf));
 
 	switch (err) {
 	case EACCES:
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 01ce14c..b38de58 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -2027,6 +2027,8 @@ bool perf_evsel__fallback(struct perf_evsel *evsel, int err,
 int perf_evsel__open_strerror(struct perf_evsel *evsel, struct target *target,
 			      int err, char *msg, size_t size)
 {
+	char sbuf[STRERR_BUFSIZE];
+
 	switch (err) {
 	case EPERM:
 	case EACCES:
@@ -2072,8 +2074,9 @@ int perf_evsel__open_strerror(struct perf_evsel *evsel, struct target *target,
 	}
 
 	return scnprintf(msg, size,
-	"The sys_perf_event_open() syscall returned with %d (%s) for event (%s).  \n"
+	"The sys_perf_event_open() syscall returned with %d (%s) for event (%s).\n"
 	"/bin/dmesg may provide additional information.\n"
 	"No CONFIG_PERF_EVENTS=y kernel support configured?\n",
-			 err, strerror(err), perf_evsel__name(evsel));
+			 err, strerror_r(err, sbuf, sizeof(sbuf)),
+			 perf_evsel__name(evsel));
 }
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 1e15df1..e34c81a 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -10,6 +10,7 @@
 #include "symbol.h"
 #include "cache.h"
 #include "header.h"
+#include "debug.h"
 #include <api/fs/debugfs.h>
 #include "parse-events-bison.h"
 #define YY_EXTRA_TYPE int
@@ -1006,9 +1007,11 @@ void print_tracepoint_events(const char *subsys_glob, const char *event_glob,
 	struct dirent *sys_next, *evt_next, sys_dirent, evt_dirent;
 	char evt_path[MAXPATHLEN];
 	char dir_path[MAXPATHLEN];
+	char sbuf[STRERR_BUFSIZE];
 
 	if (debugfs_valid_mountpoint(tracing_events_path)) {
-		printf("  [ Tracepoints not available: %s ]\n", strerror(errno));
+		printf("  [ Tracepoints not available: %s ]\n",
+			strerror_r(errno, sbuf, sizeof(sbuf)));
 		return;
 	}
 
diff --git a/tools/perf/util/run-command.c b/tools/perf/util/run-command.c
index da8e9b2..34622b5 100644
--- a/tools/perf/util/run-command.c
+++ b/tools/perf/util/run-command.c
@@ -1,6 +1,7 @@
 #include "cache.h"
 #include "run-command.h"
 #include "exec_cmd.h"
+#include "debug.h"
 
 static inline void close_pair(int fd[2])
 {
@@ -19,6 +20,7 @@ int start_command(struct child_process *cmd)
 {
 	int need_in, need_out, need_err;
 	int fdin[2], fdout[2], fderr[2];
+	char sbuf[STRERR_BUFSIZE];
 
 	/*
 	 * In case of errors we must keep the promise to close FDs
@@ -99,7 +101,7 @@ int start_command(struct child_process *cmd)
 
 		if (cmd->dir && chdir(cmd->dir))
 			die("exec %s: cd to %s failed (%s)", cmd->argv[0],
-			    cmd->dir, strerror(errno));
+			    cmd->dir, strerror_r(errno, sbuf, sizeof(sbuf)));
 		if (cmd->env) {
 			for (; *cmd->env; cmd->env++) {
 				if (strchr(*cmd->env, '='))
@@ -153,6 +155,8 @@ int start_command(struct child_process *cmd)
 
 static int wait_or_whine(pid_t pid)
 {
+	char sbuf[STRERR_BUFSIZE];
+
 	for (;;) {
 		int status, code;
 		pid_t waiting = waitpid(pid, &status, 0);
@@ -160,7 +164,8 @@ static int wait_or_whine(pid_t pid)
 		if (waiting < 0) {
 			if (errno == EINTR)
 				continue;
-			error("waitpid failed (%s)", strerror(errno));
+			error("waitpid failed (%s)",
+			      strerror_r(errno, sbuf, sizeof(sbuf)));
 			return -ERR_RUN_COMMAND_WAITPID;
 		}
 		if (waiting != pid)
diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index 25822bd..24e8d87 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -456,6 +456,7 @@ int filename__read_str(const char *filename, char **buf, size_t *sizep)
 	size_t size = 0, alloc_size = 0;
 	void *bf = NULL, *nbf;
 	int fd, n, err = 0;
+	char sbuf[STRERR_BUFSIZE];
 
 	fd = open(filename, O_RDONLY);
 	if (fd < 0)
@@ -476,8 +477,8 @@ int filename__read_str(const char *filename, char **buf, size_t *sizep)
 		n = read(fd, bf + size, alloc_size - size);
 		if (n < 0) {
 			if (size) {
-				pr_warning("read failed %d: %s\n",
-					   errno, strerror(errno));
+				pr_warning("read failed %d: %s\n", errno,
+					 strerror_r(errno, sbuf, sizeof(sbuf)));
 				err = 0;
 			} else
 				err = -errno;
