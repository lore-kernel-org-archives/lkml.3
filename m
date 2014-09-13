Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953AbaIMKj0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 06:39:26 -0400
Received: from smtp2-g21.free.fr ([212.27.42.2]:14137 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751211AbaIMKjV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 06:39:21 -0400
From: Yann Droneaud <ydroneaud@opteya.com>
To: linux-kernel@vger.kernel.org
Cc: Yann Droneaud <ydroneaud@opteya.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        William Cohen <wcohen@redhat.com>
Subject: [PATCH 2/2] perf tools: report PERF_FLAG_FD_CLOEXEC probing error once
Date: Sat, 13 Sep 2014 10:46:24 +0200
Message-Id: <e4a509282b69c8f0712fd035ce16a4a965043b3a.1410595700.git.ydroneaud@opteya.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1410595700.git.ydroneaud@opteya.com>
References: <cover.1410595700.git.ydroneaud@opteya.com>
In-Reply-To: <cover.1410595700.git.ydroneaud@opteya.com>
References: <cover.1410595700.git.ydroneaud@opteya.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case of failure, unrelated to PERF_FLAG_FD_CLOEXEC,
perf_flag_probe() reports the error twice. For example:

  $ perf record ls
  Error:
  perf_event_open(..., PERF_FLAG_FD_CLOEXEC) failed with unexpected error 16 (Device or resource busy)
  perf_event_open(..., 0) failed unexpectedly with error 16 (Device or resource busy)

There's no need for the second error message, so this
patch changes the function to only report a second
error message when the two calls to perf_even_open(2)
fail with different error codes.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: William Cohen <wcohen@redhat.com>
Reported-by: Jiri Olsa <jolsa@kernel.org>
Link: http://lkml.kernel.org/r/1406908014-8312-1-git-send-email-jolsa@kernel.org
Link: http://lkml.kernel.org/r/cover.1410595700.git.ydroneaud@opteya.com
Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
---
 tools/perf/util/cloexec.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/tools/perf/util/cloexec.c b/tools/perf/util/cloexec.c
index 6b948e05e5f0..91331b4ffc3d 100644
--- a/tools/perf/util/cloexec.c
+++ b/tools/perf/util/cloexec.c
@@ -16,7 +16,7 @@ static int perf_flag_probe(void)
 		.exclude_kernel = 1,
 	};
 	int fd;
-	int err;
+	int err0, err1;
 	int cpu;
 	pid_t pid = -1;
 	char sbuf[STRERR_BUFSIZE];
@@ -35,7 +35,7 @@ static int perf_flag_probe(void)
 		}
 		break;
 	}
-	err = errno;
+	err0 = errno;
 
 	if (fd >= 0) {
 		close(fd);
@@ -43,25 +43,27 @@ static int perf_flag_probe(void)
 	}
 
 	/* ignore busy errors */
-	if (err == EBUSY)
+	if (err0 == EBUSY)
 		return -1;
 
-	WARN_ONCE(err != EINVAL,
+	WARN_ONCE(err0 != EINVAL,
 		  "perf_event_open(..., PERF_FLAG_FD_CLOEXEC) failed with unexpected error %d (%s)\n",
-		  err, strerror_r(err, sbuf, sizeof(sbuf)));
+		  err0, strerror_r(err0, sbuf, sizeof(sbuf)));
 
 	/* not supported, confirm error related to PERF_FLAG_FD_CLOEXEC */
 	fd = sys_perf_event_open(&attr, pid, cpu, -1, 0);
-	err = errno;
+	err1 = errno;
 
-	if (WARN_ONCE(fd < 0,
-		      "perf_event_open(..., 0) failed unexpectedly with error %d (%s)\n",
-		      err, strerror_r(err, sbuf, sizeof(sbuf))))
-		return -1;
+	if (fd >= 0) {
+		close(fd);
+		return 0;
+	}
 
-	close(fd);
+	WARN_ONCE(err0 != err1,
+		  "perf_event_open(..., 0) failed unexpectedly with error %d (%s)\n",
+		  err1, strerror_r(err1, sbuf, sizeof(sbuf)));
 
-	return 0;
+	return -1;
 }
 
 unsigned long perf_event_open_cloexec_flag(void)
-- 
1.9.3

