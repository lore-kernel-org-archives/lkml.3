Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196AbbAZRtH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 12:49:07 -0500
Received: from mail.kernel.org ([198.145.29.136]:53185 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755273AbbAZRtC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 12:49:02 -0500
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>, Borislav Petkov <bp@suse.de>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 22/26] tools lib fs debugfs: Introduce debugfs__strerror_open_tp
Date: Mon, 26 Jan 2015 14:47:25 -0300
Message-Id: <1422294449-12735-23-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1422294449-12735-1-git-send-email-acme@kernel.org>
References: <1422294449-12735-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

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
index 5e8f3913de43..bf9e21648894 100644
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
index a1799aecd4d5..0739881a9897 100644
--- a/tools/lib/api/fs/debugfs.h
+++ b/tools/lib/api/fs/debugfs.h
@@ -27,5 +27,6 @@ char *debugfs_mount(const char *mountpoint);
 extern char debugfs_mountpoint[];
 
 int debugfs__strerror_open(int err, char *buf, size_t size, const char *filename);
+int debugfs__strerror_open_tp(int err, char *buf, size_t size, const char *sys, const char *name);
 
 #endif /* __API_DEBUGFS_H__ */
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index eaaa540bf1f3..7e935f1083ec 100644
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
-- 
1.9.3

