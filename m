Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720AbaHNIqV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 04:46:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36346 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754672AbaHNIqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 04:46:17 -0400
Date: Thu, 14 Aug 2014 01:45:23 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-f6edb53c4993ffe92ce521fb449d1c146cea6ec2@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org, jolsa@kernel.org,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        jolsa@kernel.org, peterz@infradead.org, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <1407855871-15024-5-git-send-email-adrian.hunter@intel.com>
References: <1407855871-15024-5-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Prefer to use a cpu-wide event for probing CLOEXEC
Git-Commit-ID: f6edb53c4993ffe92ce521fb449d1c146cea6ec2
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

Commit-ID:  f6edb53c4993ffe92ce521fb449d1c146cea6ec2
Gitweb:     http://git.kernel.org/tip/f6edb53c4993ffe92ce521fb449d1c146cea6ec2
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Tue, 12 Aug 2014 18:04:31 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 13 Aug 2014 16:24:13 -0300

perf tools: Prefer to use a cpu-wide event for probing CLOEXEC

When doing a system-wide trace with Intel PT, the jump label set up as a
result of probing CLOEXEC gets reset while the trace is running.  That
causes an Intel PT decoding error because the object code (obtained from
/proc/kcore) does not match the running code at that point.  While we
can't expect there never to be jump label changes, we can avoid cases
that the perf tool itself creates.

The problem is avoided by first trying a cpu-wide event (pid = -1) for
probing the PERF_FLAG_FD_CLOEXEC flag and falling back to an event for
the current process (pid = 0).

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1407855871-15024-5-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/cloexec.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/cloexec.c b/tools/perf/util/cloexec.c
index 000047c..4945aa5 100644
--- a/tools/perf/util/cloexec.c
+++ b/tools/perf/util/cloexec.c
@@ -1,3 +1,4 @@
+#include <sched.h>
 #include "util.h"
 #include "../perf.h"
 #include "cloexec.h"
@@ -15,10 +16,23 @@ static int perf_flag_probe(void)
 	};
 	int fd;
 	int err;
+	int cpu;
+	pid_t pid = -1;
 
-	/* check cloexec flag */
-	fd = sys_perf_event_open(&attr, 0, -1, -1,
-				 PERF_FLAG_FD_CLOEXEC);
+	cpu = sched_getcpu();
+	if (cpu < 0)
+		cpu = 0;
+
+	while (1) {
+		/* check cloexec flag */
+		fd = sys_perf_event_open(&attr, pid, cpu, -1,
+					 PERF_FLAG_FD_CLOEXEC);
+		if (fd < 0 && pid == -1 && errno == EACCES) {
+			pid = 0;
+			continue;
+		}
+		break;
+	}
 	err = errno;
 
 	if (fd >= 0) {
@@ -31,7 +45,7 @@ static int perf_flag_probe(void)
 		  err, strerror(err));
 
 	/* not supported, confirm error related to PERF_FLAG_FD_CLOEXEC */
-	fd = sys_perf_event_open(&attr, 0, -1, -1, 0);
+	fd = sys_perf_event_open(&attr, pid, cpu, -1, 0);
 	err = errno;
 
 	if (WARN_ONCE(fd < 0 && err != EBUSY,
