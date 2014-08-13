Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751AbaHMWtj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 18:49:39 -0400
Received: from mail.kernel.org ([198.145.19.201]:55038 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752876AbaHMWtf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 18:49:35 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 13/41] perf tools: Prefer to use a cpu-wide event for probing CLOEXEC
Date: Wed, 13 Aug 2014 19:47:59 -0300
Message-Id: <1407970107-24540-14-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1407970107-24540-1-git-send-email-acme@kernel.org>
References: <1407970107-24540-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

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
index 000047cb3fee..4945aa56a017 100644
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
-- 
1.9.3

