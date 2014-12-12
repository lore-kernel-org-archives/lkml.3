Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759840AbaLLIUy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 03:20:54 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43301 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757513AbaLLIUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 03:20:52 -0500
Date: Fri, 12 Dec 2014 00:20:11 -0800
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-cdvxfz2gycetbkopm9sna1qp@git.kernel.org>
Cc: fweisbec@gmail.com, jolsa@redhat.com, adrian.hunter@intel.com,
        mingo@kernel.org, dsahern@gmail.com, acme@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, dzickus@redhat.com, peterz@infradead.org,
        bp@suse.de, efault@gmx.de, namhyung@kernel.org, paulus@samba.org,
        tglx@linutronix.de, eranian@google.com
Reply-To: tglx@linutronix.de, eranian@google.com, paulus@samba.org,
        namhyung@kernel.org, efault@gmx.de, bp@suse.de, peterz@infradead.org,
        dzickus@redhat.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        hpa@zytor.com, dsahern@gmail.com, mingo@kernel.org,
        adrian.hunter@intel.com, jolsa@redhat.com, fweisbec@gmail.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf trace:
  Provide a better explanation when mmap fails
Git-Commit-ID: e09b18d4907992d3d615b215c1abf585721b2810
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

Commit-ID:  e09b18d4907992d3d615b215c1abf585721b2810
Gitweb:     http://git.kernel.org/tip/e09b18d4907992d3d615b215c1abf585721b2810
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 11 Dec 2014 18:04:10 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 11 Dec 2014 18:04:10 -0300

perf trace: Provide a better explanation when mmap fails

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
index 83a4835..327541e 100644
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
 
