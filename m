Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910Ab3JVO24 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 10:28:56 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53882 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753648Ab3JVO2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 10:28:50 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 02/26] perf trace: Split fd -> pathname array handling
Date: Tue, 22 Oct 2013 11:28:10 -0300
Message-Id: <1382452114-1243-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1382452114-1243-1-git-send-email-acme@infradead.org>
References: <1382452114-1243-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

So that the part that grows the array as needed is untied from the code
that reads the /proc/pid/fd symlink and can be used for the vfs_getname
hook that will set the fd -> path translation too, when available.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-ydo5rumyv9hdc1vsfmqamugs@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 49 +++++++++++++++++++++++++---------------------
 1 file changed, 27 insertions(+), 22 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index d0f91fe755a3..763bef45afad 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -975,30 +975,9 @@ struct trace {
 	double			runtime_ms;
 };
 
-static int thread__read_fd_path(struct thread *thread, int fd)
+static int trace__set_fd_pathname(struct thread *thread, int fd, const char *pathname)
 {
 	struct thread_trace *ttrace = thread->priv;
-	char linkname[PATH_MAX], pathname[PATH_MAX];
-	struct stat st;
-	int ret;
-
-	if (thread->pid_ == thread->tid) {
-		scnprintf(linkname, sizeof(linkname),
-			  "/proc/%d/fd/%d", thread->pid_, fd);
-	} else {
-		scnprintf(linkname, sizeof(linkname),
-			  "/proc/%d/task/%d/fd/%d", thread->pid_, thread->tid, fd);
-	}
-
-	if (lstat(linkname, &st) < 0 || st.st_size + 1 > (off_t)sizeof(pathname))
-		return -1;
-
-	ret = readlink(linkname, pathname, sizeof(pathname));
-
-	if (ret < 0 || ret > st.st_size)
-		return -1;
-
-	pathname[ret] = '\0';
 
 	if (fd > ttrace->paths.max) {
 		char **npath = realloc(ttrace->paths.table, (fd + 1) * sizeof(char *));
@@ -1022,6 +1001,32 @@ static int thread__read_fd_path(struct thread *thread, int fd)
 	return ttrace->paths.table[fd] != NULL ? 0 : -1;
 }
 
+static int thread__read_fd_path(struct thread *thread, int fd)
+{
+	char linkname[PATH_MAX], pathname[PATH_MAX];
+	struct stat st;
+	int ret;
+
+	if (thread->pid_ == thread->tid) {
+		scnprintf(linkname, sizeof(linkname),
+			  "/proc/%d/fd/%d", thread->pid_, fd);
+	} else {
+		scnprintf(linkname, sizeof(linkname),
+			  "/proc/%d/task/%d/fd/%d", thread->pid_, thread->tid, fd);
+	}
+
+	if (lstat(linkname, &st) < 0 || st.st_size + 1 > (off_t)sizeof(pathname))
+		return -1;
+
+	ret = readlink(linkname, pathname, sizeof(pathname));
+
+	if (ret < 0 || ret > st.st_size)
+		return -1;
+
+	pathname[ret] = '\0';
+	return trace__set_fd_pathname(thread, fd, pathname);
+}
+
 static const char *thread__fd_path(struct thread *thread, int fd, bool live)
 {
 	struct thread_trace *ttrace = thread->priv;
-- 
1.8.1.4

