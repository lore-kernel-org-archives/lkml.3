Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740AbaFRPAf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 11:00:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4861 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751066AbaFRPAI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 11:00:08 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 17/18] perf tools: Limit the ordered events queue by default to 100MB
Date: Wed, 18 Jun 2014 16:58:58 +0200
Message-Id: <1403103539-16807-18-git-send-email-jolsa@kernel.org>
In-Reply-To: <1403103539-16807-1-git-send-email-jolsa@kernel.org>
References: <1403103539-16807-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's still configurable by report.queue-size config option,
but looks like 100MB limit is more sane than no limit at all.

There's some speedup for report on huge data files:

With the limit of 100 MB, I've got around 15% speedup on reporting
of ~10GB perf.data file.

  current code:
   621,685,704,665      cycles                    ( +-  0.52% )
   873,397,467,969      instructions              ( +-  0.00% )

     286.133268732 seconds time elapsed           ( +-  1.13% )

  with patches:
   603,933,987,185      cycles                    ( +-  0.45% )
   869,139,445,070      instructions              ( +-  0.00% )

     245.337510637 seconds time elapsed           ( +-  0.49% )

The speed up seems to be mainly in less cycles spent in servicing
page faults.

  current code:
     4.44%     0.01%  perf.old  [kernel.kallsyms]   [k] page_fault

  with patches:
     1.45%     0.00%      perf  [kernel.kallsyms]   [k] page_fault

  current code (faults event):
         6,643,807      faults                    ( +-  0.36% )

  with patches (faults event):
         2,214,756      faults                    ( +-  3.03% )

Also there's lower memory consuption.

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
 tools/perf/util/ordered-events.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/ordered-events.c b/tools/perf/util/ordered-events.c
index 662ee0c..aa98b6a 100644
--- a/tools/perf/util/ordered-events.c
+++ b/tools/perf/util/ordered-events.c
@@ -252,7 +252,8 @@ void ordered_events_queue_init(struct ordered_events_queue *q)
 	INIT_LIST_HEAD(&q->events);
 	INIT_LIST_HEAD(&q->cache);
 	INIT_LIST_HEAD(&q->to_free);
-	q->max_alloc_size = (u64) -1;
+	/* 100MB limitation by default */
+	q->max_alloc_size = 100 * 1024 * 1024;
 	q->cur_alloc_size = 0;
 }
 
-- 
1.8.3.1

