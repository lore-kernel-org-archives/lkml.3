Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751809AbaG1IYD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 04:24:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42427 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462AbaG1IXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 04:23:54 -0400
Date: Mon, 28 Jul 2014 01:22:04 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-deaff8b659cf4d34181c087b8cdf74f1eb17b02b@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de
In-Reply-To: <1406035081-14301-2-git-send-email-adrian.hunter@intel.com>
References: <1406035081-14301-2-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Fix jump label always changing during tracing
Git-Commit-ID: deaff8b659cf4d34181c087b8cdf74f1eb17b02b
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

Commit-ID:  deaff8b659cf4d34181c087b8cdf74f1eb17b02b
Gitweb:     http://git.kernel.org/tip/deaff8b659cf4d34181c087b8cdf74f1eb17b02b
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Tue, 22 Jul 2014 16:17:10 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 23 Jul 2014 11:12:59 -0300

perf tools: Fix jump label always changing during tracing

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
index c5d05ec..6a37be5 100644
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
