Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822AbaHKIvC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 04:51:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4045 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752740AbaHKIu7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 04:50:59 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 11/20] perf top: Join the display thread on exit
Date: Mon, 11 Aug 2014 10:50:05 +0200
Message-Id: <1407747014-18394-12-git-send-email-jolsa@kernel.org>
In-Reply-To: <1407747014-18394-1-git-send-email-jolsa@kernel.org>
References: <1407747014-18394-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We create the display thread, but never join it. It gives
the display thread a chance to quit and cleanup properly.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/builtin-top.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index d0eeeb7ca5ff..eca2318b68a3 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -992,7 +992,7 @@ static int __cmd_top(struct perf_top *top)
 		param.sched_priority = top->realtime_prio;
 		if (sched_setscheduler(0, SCHED_FIFO, &param)) {
 			ui__error("Could not set realtime priority.\n");
-			goto out_delete;
+			goto out_join;
 		}
 	}
 
@@ -1006,6 +1006,8 @@ static int __cmd_top(struct perf_top *top)
 	}
 
 	ret = 0;
+out_join:
+	pthread_join(thread, NULL);
 out_delete:
 	perf_session__delete(top->session);
 	top->session = NULL;
-- 
1.8.3.1

