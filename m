Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965550AbaLKV1q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 16:27:46 -0500
Received: from mail.kernel.org ([198.145.19.201]:44608 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965517AbaLKV1n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 16:27:43 -0500
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>, Borislav Petkov <bp@suse.de>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 18/18] perf trace: Provide a better explanation when mmap fails
Date: Thu, 11 Dec 2014 18:26:06 -0300
Message-Id: <1418333166-15429-19-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1418333166-15429-1-git-send-email-acme@kernel.org>
References: <1418333166-15429-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

If we ask for a mmap lenght than the max configured via the relevant
sysctl, provide a better warning, instead of just expanding the EPERM
returned:

[acme@ssdandy ~]$ trace -m 256 -e nanosleep sleep 2
Error:	Operation not permitted.
Hint:	Check /proc/sys/kernel/perf_event_mlock_kb (516 kB) setting.
Hint:	Tried using 1028 kB.
Hint:	Try using a bigger -m/--mmap-pages value.

[acme@ssdandy ~]$ trace -m 128 -e nanosleep sleep 2
  2001.280 (2000.403 ms): nanosleep(rqtp: 0x7fff89a8a7f0) = 0
[acme@ssdandy ~]$

An upcoming patch will autotune the request for non-root users when -m
is not used.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-cdvxfz2gycetbkopm9sna1qp@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 83a4835c8118..327541e43c7f 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -2045,7 +2045,6 @@ static int trace__run(struct trace *trace, int argc, const char **argv)
 	unsigned long before;
 	const bool forks = argc > 0;
 	bool draining = false;
-	char sbuf[STRERR_BUFSIZE];
 
 	trace->live = true;
 
@@ -2106,11 +2105,8 @@ static int trace__run(struct trace *trace, int argc, const char **argv)
 		goto out_error_open;
 
 	err = perf_evlist__mmap(evlist, trace->opts.mmap_pages, false);
-	if (err < 0) {
-		fprintf(trace->output, "Couldn't mmap the events: %s\n",
-			strerror_r(errno, sbuf, sizeof(sbuf)));
-		goto out_delete_evlist;
-	}
+	if (err < 0)
+		goto out_error_mmap;
 
 	perf_evlist__enable(evlist);
 
@@ -2210,6 +2206,10 @@ out_error_tp:
 	perf_evlist__strerror_tp(evlist, errno, errbuf, sizeof(errbuf));
 	goto out_error;
 
+out_error_mmap:
+	perf_evlist__strerror_mmap(evlist, errno, errbuf, sizeof(errbuf));
+	goto out_error;
+
 out_error_open:
 	perf_evlist__strerror_open(evlist, errno, errbuf, sizeof(errbuf));
 
-- 
1.9.3

