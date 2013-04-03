Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758777Ab3DCIIl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 04:08:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:35415 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758607Ab3DCIIa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 04:08:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,399,1363158000"; 
   d="scan'208";a="288641710"
Message-ID: <515BE358.2010108@intel.com>
Date: Wed, 03 Apr 2013 16:07:52 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Paul Turner <pjt@google.com>
CC: Namhyung Kim <namhyung@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>, Mike Galbraith <efault@gmx.de>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        gregkh@linuxfoundation.org,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch v6 10/21] sched: get rq potential maximum utilization
References: <1364654108-16307-1-git-send-email-alex.shi@intel.com> <1364654108-16307-11-git-send-email-alex.shi@intel.com> <87a9phfgox.fsf@sejong.aot.lge.com> <515B90A5.7080403@intel.com> <CAPM31RKj0SJB6eCDSpH29OdfeNGDXqzoQQWhQP7t3gdxYx+wrQ@mail.gmail.com>
In-Reply-To: <CAPM31RKj0SJB6eCDSpH29OdfeNGDXqzoQQWhQP7t3gdxYx+wrQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2013 10:22 AM, Paul Turner wrote:
> On Tue, Apr 2, 2013 at 7:15 PM, Alex Shi <alex.shi@intel.com> wrote:
>> On 04/02/2013 05:02 PM, Namhyung Kim wrote:
>>>>> +  cfs_util = (FULL_UTIL - rt_util) > rq->util ? rq->util
>>>>> +                  : (FULL_UTIL - rt_util);
>>>>> +  nr_running = rq->nr_running ? rq->nr_running : 1;
>>> This can be cleaned up with proper min/max().
>>>
>>>>> +
>>>>> +  return rt_util + cfs_util * nr_running;
>>> Should this nr_running consider tasks in cfs_rq only?
>>
>> use nr_running of cfs_rq seems better, but when use sched autogroup,
>> only cfs->nr_running just the active group number, not the total active
>> task number. :(
> 
> Why not just use cfs_rq->h_nr_running?  This is always the total
> *tasks* in he hierarchy parented that cfs_rq.  (This also has the nice property
> of not including group_entities.)
> 

Thanks for Namhyung and PJT's suggestions!
patch updated!

>From 5f6fc3129784db5fb96b8bb7014fe41ee7e059c5 Mon Sep 17 00:00:00 2001
From: Alex Shi <alex.shi@intel.com>
Date: Sun, 24 Mar 2013 21:47:59 +0800
Subject: [PATCH 09/21] sched: get rq potential maximum utilization

Since the rt task priority is higher than fair tasks, cfs_rq utilization
is just the left of rt utilization.

When there are some cfs tasks in queue, the potential utilization may
be yielded, so mulitiplying cfs task number to get max potential
utilization of cfs. Then the rq utilization is sum of rt util and cfs
util.

Thanks for Paul Turner and Namhyung's reminder!

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/fair.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index c47933f..70a99c9 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3350,6 +3350,27 @@ struct sg_lb_stats {
 	unsigned int group_util;	/* sum utilization of group */
 };
 
+static unsigned long scale_rt_util(int cpu);
+
+/*
+ * max_rq_util - get the possible maximum cpu utilization
+ */
+static unsigned int max_rq_util(int cpu)
+{
+	struct rq *rq = cpu_rq(cpu);
+	unsigned int rt_util = scale_rt_util(cpu);
+	unsigned int cfs_util;
+	unsigned int nr_running;
+
+	/* yield cfs utilization to rt's, if total utilization > 100% */
+	cfs_util = min(rq->util, (unsigned int)(FULL_UTIL - rt_util));
+
+	/* count transitory task utilization */
+	nr_running = max(rq->cfs.h_nr_running, (unsigned int)1);
+
+	return rt_util + cfs_util * nr_running;
+}
+
 /*
  * sched_balance_self: balance the current task (running on cpu) in domains
  * that have the 'flag' flag set. In practice, this is SD_BALANCE_FORK and
-- 
1.7.12


-- 
Thanks Alex
