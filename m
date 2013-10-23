Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752057Ab3JWHxT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 03:53:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55791 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378Ab3JWHxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 03:53:13 -0400
Date: Wed, 23 Oct 2013 00:52:08 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-ydo5rumyv9hdc1vsfmqamugs@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, jolsa@redhat.com, fweisbec@gmail.com,
        adrian.hunter@intel.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, adrian.hunter@intel.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf trace: Split fd -> pathname array handling
Git-Commit-ID: 97119f37bbebbab852899bd37ed52b80396728f9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 23 Oct 2013 00:52:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  97119f37bbebbab852899bd37ed52b80396728f9
Gitweb:     http://git.kernel.org/tip/97119f37bbebbab852899bd37ed52b80396728f9
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 27 Sep 2013 17:34:10 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 16 Oct 2013 11:05:01 -0300

perf trace: Split fd -> pathname array handling

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
index d0f91fe..763bef4 100644
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
