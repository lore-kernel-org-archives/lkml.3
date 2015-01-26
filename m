Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863AbbAZRtA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 12:49:00 -0500
Received: from mail.kernel.org ([198.145.29.136]:53157 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755273AbbAZRsy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 12:48:54 -0500
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>, Borislav Petkov <bp@suse.de>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 20/26] tools lib fs: Pass filename to debugfs__strerror_open
Date: Mon, 26 Jan 2015 14:47:23 -0300
Message-Id: <1422294449-12735-21-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1422294449-12735-1-git-send-email-acme@kernel.org>
References: <1422294449-12735-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

It was hardcoded for one specific tracepoint, leftover from its initial
user: 'perf trace'.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-j1jicvwljy5qx1nah4mkmyke@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/api/fs/debugfs.c | 6 +++---
 tools/lib/api/fs/debugfs.h | 2 +-
 tools/perf/builtin-trace.c | 5 +++--
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/tools/lib/api/fs/debugfs.c b/tools/lib/api/fs/debugfs.c
index fb700eed61c2..5e8f3913de43 100644
--- a/tools/lib/api/fs/debugfs.c
+++ b/tools/lib/api/fs/debugfs.c
@@ -100,7 +100,7 @@ out:
 	return debugfs_mountpoint;
 }
 
-int debugfs__strerror_open(int err, char *buf, size_t size)
+int debugfs__strerror_open(int err, char *buf, size_t size, const char *filename)
 {
 	char sbuf[128];
 
@@ -114,9 +114,9 @@ int debugfs__strerror_open(int err, char *buf, size_t size)
 		break;
 	case EACCES:
 		snprintf(buf, size,
-			 "Error:\tNo permissions to read %s/tracing/events/raw_syscalls\n"
+			 "Error:\tNo permissions to read %s/%s\n"
 			 "Hint:\tTry 'sudo mount -o remount,mode=755 %s'\n",
-			 debugfs_mountpoint, debugfs_mountpoint);
+			 debugfs_mountpoint, filename, debugfs_mountpoint);
 		break;
 	default:
 		snprintf(buf, size, "%s", strerror_r(err, sbuf, sizeof(sbuf)));
diff --git a/tools/lib/api/fs/debugfs.h b/tools/lib/api/fs/debugfs.h
index afa5043fec61..a1799aecd4d5 100644
--- a/tools/lib/api/fs/debugfs.h
+++ b/tools/lib/api/fs/debugfs.h
@@ -26,6 +26,6 @@ char *debugfs_mount(const char *mountpoint);
 
 extern char debugfs_mountpoint[];
 
-int debugfs__strerror_open(int err, char *buf, size_t size);
+int debugfs__strerror_open(int err, char *buf, size_t size, const char *filename);
 
 #endif /* __API_DEBUGFS_H__ */
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 2f82dd78b086..684609d7a83d 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -2056,7 +2056,7 @@ static int trace__run(struct trace *trace, int argc, const char **argv)
 	if (trace->trace_syscalls &&
 	    perf_evlist__add_syscall_newtp(evlist, trace__sys_enter,
 					   trace__sys_exit))
-		goto out_error_tp;
+		goto out_error_raw_syscalls;
 
 	if (trace->trace_syscalls)
 		perf_evlist__add_vfs_getname(evlist);
@@ -2210,7 +2210,8 @@ out:
 	char errbuf[BUFSIZ];
 
 out_error_tp:
-	debugfs__strerror_open(errno, errbuf, sizeof(errbuf));
+out_error_raw_syscalls:
+	debugfs__strerror_open(errno, errbuf, sizeof(errbuf), "tracing/events/raw_syscalls");
 	goto out_error;
 
 out_error_mmap:
-- 
1.9.3

