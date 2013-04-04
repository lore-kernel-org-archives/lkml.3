Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932828Ab3DDCEt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 22:04:49 -0400
Received: from mga03.intel.com ([143.182.124.21]:29711 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932802Ab3DDCCd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 22:02:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,404,1363158000"; 
   d="scan'208";a="280534450"
From: Alex Shi <alex.shi@intel.com>
To: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        morten.rasmussen@arm.com
Cc: vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, alex.shi@intel.com, len.brown@intel.com,
        rafael.j.wysocki@intel.com, jkosina@suse.cz, clark.williams@gmail.com,
        tony.luck@intel.com, keescook@chromium.org, mgorman@suse.de,
        riel@redhat.com
Subject: [patch v7 12/21] sched: using avg_idle to detect bursty wakeup
Date: Thu,  4 Apr 2013 10:00:53 +0800
Message-Id: <1365040862-8390-13-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1365040862-8390-1-git-send-email-alex.shi@intel.com>
References: <1365040862-8390-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sleeping task has no utiliation, when they were bursty waked up, the
zero utilization make scheduler out of balance, like aim7 benchmark.

rq->avg_idle is 'to used to accommodate bursty loads in a dirt simple
dirt cheap manner' -- Mike Galbraith.

With this cheap and smart bursty indicator, we can find the wake up
burst, and use nr_running as instant utilization in this scenario.

For other scenarios, we still use the precise CPU utilization to
judage if a domain is eligible for power scheduling.

Thanks for Mike Galbraith's idea!
Thanks for Namhyung's suggestion to compact the burst into
max_rq_util()!

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/fair.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index f610313..a729939 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3363,6 +3363,10 @@ static unsigned int max_rq_util(int cpu)
 	unsigned int cfs_util;
 	unsigned int nr_running;
 
+	/* use nr_running as instant utilization for burst cpu */
+	if (cpu_rq(cpu)->avg_idle < sysctl_sched_burst_threshold)
+		return rq->nr_running * FULL_UTIL;
+
 	/* yield cfs utilization to rt's, if total utilization > 100% */
 	cfs_util = min(rq->util, (unsigned int)(FULL_UTIL - rt_util));
 
-- 
1.7.12

