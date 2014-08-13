Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333AbaHMWs7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 18:48:59 -0400
Received: from mail.kernel.org ([198.145.19.201]:54821 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753236AbaHMWsz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 18:48:55 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jean Pihet <jean.pihet@linaro.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 03/41] perf top: Join the display thread on exit
Date: Wed, 13 Aug 2014 19:47:49 -0300
Message-Id: <1407970107-24540-4-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1407970107-24540-1-git-send-email-acme@kernel.org>
References: <1407970107-24540-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@kernel.org>

We create the display thread, but never join it. It gives
the display thread a chance to quit and cleanup properly.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1407747014-18394-12-git-send-email-jolsa@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 4fb6f726271c..10fc7e844872 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -965,7 +965,7 @@ static int __cmd_top(struct perf_top *top)
 		param.sched_priority = top->realtime_prio;
 		if (sched_setscheduler(0, SCHED_FIFO, &param)) {
 			ui__error("Could not set realtime priority.\n");
-			goto out_delete;
+			goto out_join;
 		}
 	}
 
@@ -979,6 +979,8 @@ static int __cmd_top(struct perf_top *top)
 	}
 
 	ret = 0;
+out_join:
+	pthread_join(thread, NULL);
 out_delete:
 	perf_session__delete(top->session);
 	top->session = NULL;
-- 
1.9.3

