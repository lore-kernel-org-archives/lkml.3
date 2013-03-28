Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601Ab3C1H7n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 03:59:43 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:53645 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756072Ab3C1H7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 03:59:08 -0400
X-AuditID: 9c930197-b7c9dae000006959-d2-5153f847cac0
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
        Paul Turner <pjt@google.com>, Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH 5/5] sched: limit sched_slice if it is more than sysctl_sched_latency
Date: Thu, 28 Mar 2013 16:58:56 +0900
Message-Id: <1364457537-15114-6-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1364457537-15114-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1364457537-15114-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sched_slice() compute ideal runtime slice. If there are many tasks
in cfs_rq, period for this cfs_rq is extended to guarantee that each task
has time slice at least, sched_min_granularity. And then each task get
a portion of this period for it. If there is a task which have much larger
load weight than others, a portion of period can exceed far more than
sysctl_sched_latency.

For exampple, you can simply imagine that one task with nice -20 and
9 tasks with nice 0 on one cfs_rq. In this case, load weight sum for
this cfs_rq is 88761 + 9 * 1024, 97977. So a portion of slice for the
task with nice -20 is sysctl_sched_min_granularity * 10 * (88761 / 97977),
that is, approximately, sysctl_sched_min_granularity * 9. This aspect
can be much larger if there is more tasks with nice 0.

So we should limit this possible weird situation.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index e232421..6ceffbc 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -645,6 +645,9 @@ static u64 sched_slice(struct cfs_rq *cfs_rq, struct sched_entity *se)
 	}
 	slice = calc_delta_mine(slice, se->load.weight, load);
 
+	if (unlikely(slice > sysctl_sched_latency))
+		slice = sysctl_sched_latency;
+
 	return slice;
 }
 
-- 
1.7.9.5

