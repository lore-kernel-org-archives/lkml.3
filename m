Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984AbbA1VUs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 16:20:48 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40980 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762133AbbA1UuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:50:20 -0500
Date: Wed, 28 Jan 2015 07:09:42 -0800
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-q6e6zct49ql6nbcw8kkg0lbj@git.kernel.org>
Cc: dzickus@redhat.com, bp@suse.de, eranian@google.com, mingo@kernel.org,
        hpa@zytor.com, fweisbec@gmail.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, namhyung@kernel.org, jolsa@redhat.com,
        dsahern@gmail.com, tglx@linutronix.de, adrian.hunter@intel.com
Reply-To: tglx@linutronix.de, adrian.hunter@intel.com, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@kernel.org, eranian@google.com, bp@suse.de, dzickus@redhat.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib fs debugfs:
  Introduce debugfs__strerror_open_tp
Git-Commit-ID: 2cc990ba3af4f9511f0d016c73b8163591f890e7
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

Commit-ID:  2cc990ba3af4f9511f0d016c73b8163591f890e7
Gitweb:     http://git.kernel.org/tip/2cc990ba3af4f9511f0d016c73b8163591f890e7
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 22 Jan 2015 11:13:43 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 22 Jan 2015 17:02:20 -0300

tools lib fs debugfs: Introduce debugfs__strerror_open_tp

There will be other cases where not just a tracepoint event is being
opened below the debugfs mountpoint, but it is rather common, so provide
one helper for that.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-q6e6zct49ql6nbcw8kkg0lbj@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/api/fs/debugfs.c |  9 +++++++++
 tools/lib/api/fs/debugfs.h |  1 +
 tools/perf/builtin-trace.c | 13 ++++++++-----
 3 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/tools/lib/api/fs/debugfs.c b/tools/lib/api/fs/debugfs.c
index 5e8f391..bf9e216 100644
--- a/tools/lib/api/fs/debugfs.c
+++ b/tools/lib/api/fs/debugfs.c
@@ -125,3 +125,12 @@ int debugfs__strerror_open(int err, char *buf, size_t size, const char *filename
 
 	return 0;
 }
+
+int debugfs__strerror_open_tp(int err, char *buf, size_t size, const char *sys, const char *name)
+{
+	char path[PATH_MAX];
+
+	snprintf(path, PATH_MAX, "tracing/events/%s/%s", sys, name ?: "*");
+
+	return debugfs__strerror_open(err, buf, size, path);
+}
diff --git a/tools/lib/api/fs/debugfs.h b/tools/lib/api/fs/debugfs.h
index a1799ae..0739881 100644
--- a/tools/lib/api/fs/debugfs.h
+++ b/tools/lib/api/fs/debugfs.h
@@ -27,5 +27,6 @@ char *debugfs_mount(const char *mountpoint);
 extern char debugfs_mountpoint[];
 
 int debugfs__strerror_open(int err, char *buf, size_t size, const char *filename);
+int debugfs__strerror_open_tp(int err, char *buf, size_t size, const char *sys, const char *name);
 
 #endif /* __API_DEBUGFS_H__ */
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index eaaa540..7e935f1 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -2071,9 +2071,9 @@ static int trace__run(struct trace *trace, int argc, const char **argv)
 		goto out_error_mem;
 
 	if (trace->sched &&
-		perf_evlist__add_newtp(evlist, "sched", "sched_stat_runtime",
-				trace__sched_stat_runtime))
-		goto out_error_tp;
+	    perf_evlist__add_newtp(evlist, "sched", "sched_stat_runtime",
+				   trace__sched_stat_runtime))
+		goto out_error_sched_stat_runtime;
 
 	err = perf_evlist__create_maps(evlist, &trace->opts.target);
 	if (err < 0) {
@@ -2203,9 +2203,12 @@ out:
 {
 	char errbuf[BUFSIZ];
 
-out_error_tp:
+out_error_sched_stat_runtime:
+	debugfs__strerror_open_tp(errno, errbuf, sizeof(errbuf), "sched", "sched_stat_runtime");
+	goto out_error;
+
 out_error_raw_syscalls:
-	debugfs__strerror_open(errno, errbuf, sizeof(errbuf), "tracing/events/raw_syscalls");
+	debugfs__strerror_open_tp(errno, errbuf, sizeof(errbuf), "raw_syscalls", "sys_(enter|exit)");
 	goto out_error;
 
 out_error_mmap:
