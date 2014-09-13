Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751817AbaIMKjZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 06:39:25 -0400
Received: from smtp2-g21.free.fr ([212.27.42.2]:14105 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141AbaIMKjV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
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
Subject: [PATCH 1/2] perf tools: shortcut PERF_FLAG_FD_CLOEXEC probing in case of EBUSY error
Date: Sat, 13 Sep 2014 10:46:23 +0200
Message-Id: <837882a41da788ce0df5e7e95534580e8b4cbb66.1410595700.git.ydroneaud@opteya.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1410595700.git.ydroneaud@opteya.com>
References: <cover.1410595700.git.ydroneaud@opteya.com>
In-Reply-To: <cover.1410595700.git.ydroneaud@opteya.com>
References: <cover.1410595700.git.ydroneaud@opteya.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is a simplification of the logic introduced as part of
commit 63914aca8f7e7a75d0ee027af7b1755c69cc1e2c ('perf tools: Show
better error message in case we fail to open counters due to EBUSY
error'): if EBUSY is reported by perf_event_open(), it will not be
possible to probe PERF_FLAG_FD_CLOEXEC, so it's safe to leave early.

Note that EBUSY errors are not really expected here since commit
038fa0b9739d7f375f3f61a2ce4f78ad44329f66 ('perf tools: Fix
PERF_FLAG_FD_CLOEXEC flag probing event type open counters due to
EBUSY error'): the perf event type used now should be safe to use
regarding -EBUSY error.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: William Cohen <wcohen@redhat.com>
Link: http://lkml.kernel.org/r/1406908014-8312-1-git-send-email-jolsa@kernel.org
Link: http://lkml.kernel.org/r/cover.1410595700.git.ydroneaud@opteya.com
Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
---
 tools/perf/util/cloexec.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/cloexec.c b/tools/perf/util/cloexec.c
index 47b78b3f0325..6b948e05e5f0 100644
--- a/tools/perf/util/cloexec.c
+++ b/tools/perf/util/cloexec.c
@@ -42,7 +42,11 @@ static int perf_flag_probe(void)
 		return 1;
 	}
 
-	WARN_ONCE(err != EINVAL && err != EBUSY,
+	/* ignore busy errors */
+	if (err == EBUSY)
+		return -1;
+
+	WARN_ONCE(err != EINVAL,
 		  "perf_event_open(..., PERF_FLAG_FD_CLOEXEC) failed with unexpected error %d (%s)\n",
 		  err, strerror_r(err, sbuf, sizeof(sbuf)));
 
@@ -50,7 +54,7 @@ static int perf_flag_probe(void)
 	fd = sys_perf_event_open(&attr, pid, cpu, -1, 0);
 	err = errno;
 
-	if (WARN_ONCE(fd < 0 && err != EBUSY,
+	if (WARN_ONCE(fd < 0,
 		      "perf_event_open(..., 0) failed unexpectedly with error %d (%s)\n",
 		      err, strerror_r(err, sbuf, sizeof(sbuf))))
 		return -1;
-- 
1.9.3

