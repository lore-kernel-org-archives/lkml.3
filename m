Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755113AbaHBSPv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 14:15:51 -0400
Received: from smtp2-g21.free.fr ([212.27.42.2]:52904 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754723AbaHBSPu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 14:15:50 -0400
From: Yann Droneaud <ydroneaud@opteya.com>
To: Jiri Olsa <jolsa@kernel.org>
Cc: Yann Droneaud <ydroneaud@opteya.com>, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Stephane Eranian <eranian@google.com>,
        William Cohen <wcohen@redhat.com>
Subject: [PATCH] perf tools: report PERF_FLAG_FD_CLOEXEC probing error once
Date: Sat,  2 Aug 2014 20:13:22 +0200
Message-Id: <1407003202-13672-1-git-send-email-ydroneaud@opteya.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1406908014-8312-1-git-send-email-jolsa@kernel.org>
References: <1406908014-8312-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case of failure, unrelated to PERF_FLAG_FD_CLOEXEC,
perf_flag_probe() reports the error twice. For example:

  $ perf record ls
  Error:
  perf_event_open(..., PERF_FLAG_FD_CLOEXEC) failed with unexpected error 16 (Device or resource busy)
  perf_event_open(..., 0) failed unexpectedly with error 16 (Device or resource busy)
  The PMU counters are busy/taken by another profiler.
  We found oprofile daemon running, please stop it and try again.

This patch changes the function to only report a second
error message when the two calls to perf_even_open(2)
fail with different error codes.

Cc: Andi Kleen <ak@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: William Cohen <wcohen@redhat.com>
Link: http://lkml.kernel.org/r/1406908014-8312-1-git-send-email-jolsa@kernel.org
Reported-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
---
 tools/perf/util/cloexec.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/tools/perf/util/cloexec.c b/tools/perf/util/cloexec.c
index c5d05ec17220..dc360ebde745 100644
--- a/tools/perf/util/cloexec.c
+++ b/tools/perf/util/cloexec.c
@@ -13,34 +13,36 @@ static int perf_flag_probe(void)
 		.config = PERF_COUNT_SW_CPU_CLOCK,
 	};
 	int fd;
-	int err;
+	int err0, err1;
 
 	/* check cloexec flag */
 	fd = sys_perf_event_open(&attr, 0, -1, -1,
 				 PERF_FLAG_FD_CLOEXEC);
-	err = errno;
+	err0 = errno;
 
 	if (fd >= 0) {
 		close(fd);
 		return 1;
 	}
 
-	WARN_ONCE(err != EINVAL,
+	WARN_ONCE(err0 != EINVAL,
 		  "perf_event_open(..., PERF_FLAG_FD_CLOEXEC) failed with unexpected error %d (%s)\n",
-		  err, strerror(err));
+		  err0, strerror(err0));
 
 	/* not supported, confirm error related to PERF_FLAG_FD_CLOEXEC */
 	fd = sys_perf_event_open(&attr, 0, -1, -1, 0);
-	err = errno;
+	err1 = errno;
 
-	if (WARN_ONCE(fd < 0,
-		      "perf_event_open(..., 0) failed unexpectedly with error %d (%s)\n",
-		      err, strerror(err)))
-		return -1;
+	if (fd >= 0) {
+		close(fd);
+		return 0;
+	}
 
-	close(fd);
+	WARN_ONCE(err0 != err1,
+		  "perf_event_open(..., 0) failed unexpectedly with error %d (%s)\n",
+		  err1, strerror(err1));
 
-	return 0;
+	return -1;
 }
 
 unsigned long perf_event_open_cloexec_flag(void)
-- 
1.9.3

