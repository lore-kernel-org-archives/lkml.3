Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759384AbbA1VVD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 16:21:03 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40980 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757549AbbA1UuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:50:19 -0500
Date: Wed, 28 Jan 2015 07:09:05 -0800
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-j1jicvwljy5qx1nah4mkmyke@git.kernel.org>
Cc: namhyung@kernel.org, eranian@google.com, jolsa@redhat.com,
        mingo@kernel.org, linux-kernel@vger.kernel.org, dzickus@redhat.com,
        tglx@linutronix.de, dsahern@gmail.com, fweisbec@gmail.com,
        adrian.hunter@intel.com, acme@redhat.com, hpa@zytor.com, bp@suse.de
Reply-To: hpa@zytor.com, bp@suse.de, dzickus@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de, acme@redhat.com, adrian.hunter@intel.com,
        fweisbec@gmail.com, linux-kernel@vger.kernel.org, namhyung@kernel.org,
        eranian@google.com, mingo@kernel.org, jolsa@redhat.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib fs:
  Pass filename to debugfs__strerror_open
Git-Commit-ID: 801c67b05f55d0cdafcda9fdcbb3da375b03c192
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

Commit-ID:  801c67b05f55d0cdafcda9fdcbb3da375b03c192
Gitweb:     http://git.kernel.org/tip/801c67b05f55d0cdafcda9fdcbb3da375b03c192
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 22 Jan 2015 10:52:55 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 22 Jan 2015 11:16:31 -0300

tools lib fs: Pass filename to debugfs__strerror_open

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
index fb700ee..5e8f391 100644
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
index afa5043..a1799ae 100644
--- a/tools/lib/api/fs/debugfs.h
+++ b/tools/lib/api/fs/debugfs.h
@@ -26,6 +26,6 @@ char *debugfs_mount(const char *mountpoint);
 
 extern char debugfs_mountpoint[];
 
-int debugfs__strerror_open(int err, char *buf, size_t size);
+int debugfs__strerror_open(int err, char *buf, size_t size, const char *filename);
 
 #endif /* __API_DEBUGFS_H__ */
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 2f82dd7..684609d 100644
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
