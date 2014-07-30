Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164AbaG3M43 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 08:56:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43961 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754097AbaG3M41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 08:56:27 -0400
Date: Wed, 30 Jul 2014 05:55:27 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-8578b891ec38c39abd5d6376afd05fce78e2628c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, jolsa@kernel.org,
        peterz@infradead.org, namhyung@gmail.com, fweisbec@gmail.com,
        adrian.hunter@intel.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, jolsa@kernel.org,
        peterz@infradead.org, namhyung@gmail.com, fweisbec@gmail.com,
        dsahern@gmail.com, adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <20140728065844.GK6758@twins.programming.kicks-ass.net>
References: <20140728065844.GK6758@twins.programming.kicks-ass.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] Revert "perf tools:
  Fix jump label always changing during tracing"
Git-Commit-ID: 8578b891ec38c39abd5d6376afd05fce78e2628c
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

Commit-ID:  8578b891ec38c39abd5d6376afd05fce78e2628c
Gitweb:     http://git.kernel.org/tip/8578b891ec38c39abd5d6376afd05fce78e2628c
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Mon, 28 Jul 2014 15:58:47 +0200
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Mon, 28 Jul 2014 16:39:18 +0200

Revert "perf tools: Fix jump label always changing during tracing"

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
index 6a37be5..c5d05ec 100644
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
