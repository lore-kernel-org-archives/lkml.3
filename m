Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760842AbaGYPhc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 11:37:32 -0400
Received: from mail.kernel.org ([198.145.19.201]:34888 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752615AbaGYPh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 11:37:29 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 02/27] perf tools: Fix jump label always changing during tracing
Date: Fri, 25 Jul 2014 12:36:44 -0300
Message-Id: <1406302629-11790-3-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1406302629-11790-1-git-send-email-acme@kernel.org>
References: <1406302629-11790-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Intel PT decoding walks the object code to reconstruct the trace.  A
jump label change during tracing causes decoding errors.

The "Enable close-on-exec flag on perf file descriptor" patch caused
there to be always a jump label change.

It was found that using a per-cpu context instead of a per-thread
context for the probe of the close-on-exec feature, made the problem go
away.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1406035081-14301-2-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/cloexec.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/cloexec.c b/tools/perf/util/cloexec.c
index c5d05ec17220..6a37be53a5d2 100644
--- a/tools/perf/util/cloexec.c
+++ b/tools/perf/util/cloexec.c
@@ -1,3 +1,4 @@
+#include <sched.h>
 #include "util.h"
 #include "../perf.h"
 #include "cloexec.h"
@@ -14,9 +15,13 @@ static int perf_flag_probe(void)
 	};
 	int fd;
 	int err;
+	int cpu = sched_getcpu();
+
+	if (cpu < 0)
+		cpu = 0;
 
 	/* check cloexec flag */
-	fd = sys_perf_event_open(&attr, 0, -1, -1,
+	fd = sys_perf_event_open(&attr, -1, cpu, -1,
 				 PERF_FLAG_FD_CLOEXEC);
 	err = errno;
 
@@ -30,7 +35,7 @@ static int perf_flag_probe(void)
 		  err, strerror(err));
 
 	/* not supported, confirm error related to PERF_FLAG_FD_CLOEXEC */
-	fd = sys_perf_event_open(&attr, 0, -1, -1, 0);
+	fd = sys_perf_event_open(&attr, -1, cpu, -1, 0);
 	err = errno;
 
 	if (WARN_ONCE(fd < 0,
-- 
1.9.3

