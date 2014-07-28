Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160AbaG1PCE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 11:02:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49481 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753125AbaG1PCB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 11:02:01 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 2/2] Revert "perf tools: Fix jump label always changing during tracing"
Date: Mon, 28 Jul 2014 17:01:02 +0200
Message-Id: <1406559662-4376-3-git-send-email-jolsa@kernel.org>
In-Reply-To: <1406559662-4376-1-git-send-email-jolsa@kernel.org>
References: <1406559662-4376-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit deaff8b659cf4d34181c087b8cdf74f1eb17b02b.

This commit makes CLOEXEC feature undetected for normal users,
because per-cpu events are priviledged.

Reported-by: Peter Zijlstra <peterz@infradead.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/20140728065844.GK6758@twins.programming.kicks-ass.net
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/util/cloexec.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/tools/perf/util/cloexec.c b/tools/perf/util/cloexec.c
index 6a37be53a5d2..c5d05ec17220 100644
--- a/tools/perf/util/cloexec.c
+++ b/tools/perf/util/cloexec.c
@@ -1,4 +1,3 @@
-#include <sched.h>
 #include "util.h"
 #include "../perf.h"
 #include "cloexec.h"
@@ -15,13 +14,9 @@ static int perf_flag_probe(void)
 	};
 	int fd;
 	int err;
-	int cpu = sched_getcpu();
-
-	if (cpu < 0)
-		cpu = 0;
 
 	/* check cloexec flag */
-	fd = sys_perf_event_open(&attr, -1, cpu, -1,
+	fd = sys_perf_event_open(&attr, 0, -1, -1,
 				 PERF_FLAG_FD_CLOEXEC);
 	err = errno;
 
@@ -35,7 +30,7 @@ static int perf_flag_probe(void)
 		  err, strerror(err));
 
 	/* not supported, confirm error related to PERF_FLAG_FD_CLOEXEC */
-	fd = sys_perf_event_open(&attr, -1, cpu, -1, 0);
+	fd = sys_perf_event_open(&attr, 0, -1, -1, 0);
 	err = errno;
 
 	if (WARN_ONCE(fd < 0,
-- 
1.8.3.1

