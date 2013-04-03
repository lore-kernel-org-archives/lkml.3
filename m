Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759456Ab3DCIKy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 04:10:54 -0400
Received: from mga09.intel.com ([134.134.136.24]:29709 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758920Ab3DCIKw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 04:10:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,399,1363158000"; 
   d="scan'208";a="288642666"
Message-ID: <515BE3F6.6050901@intel.com>
Date: Wed, 03 Apr 2013 16:10:30 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, efault@gmx.de, vincent.guittot@linaro.org,
        gregkh@linuxfoundation.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org
Subject: Re: [patch v6 13/21] sched: using avg_idle to detect bursty wakeup
References: <1364654108-16307-1-git-send-email-alex.shi@intel.com> <1364654108-16307-14-git-send-email-alex.shi@intel.com> <876204fbgu.fsf@sejong.aot.lge.com>
In-Reply-To: <876204fbgu.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2013 01:08 PM, Namhyung Kim wrote:
>> > -	for_each_cpu(i, sched_group_cpus(group))
>> > -		sgs->group_util += max_rq_util(i);
>> > +	for_each_cpu(i, sched_group_cpus(group)) {
>> > +		struct rq *rq = cpu_rq(i);
>> > +
>> > +		if (burst && rq->nr_running > 1)
>> > +			/* use nr_running as instant utilization */
>> > +			sgs->group_util += rq->nr_running;
> I guess multiplying FULL_UTIL to rq->nr_running here will remove
> special-casing the burst in is_sd_full().  Also moving this logic to
> max_rq_util() looks better IMHO.
> 
> 

Thanks Namhyung! patch updated.

>From b6384f4e3294e19103f706195a95265faf1ea7ef Mon Sep 17 00:00:00 2001
From: Alex Shi <alex.shi@intel.com>
Date: Mon, 25 Mar 2013 16:07:39 +0800
Subject: [PATCH 12/21] sched: using avg_idle to detect bursty wakeup

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


-- 
Thanks Alex
