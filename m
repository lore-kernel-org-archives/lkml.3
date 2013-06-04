Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759552Ab3FDBq1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 21:46:27 -0400
Received: from mga02.intel.com ([134.134.136.20]:24659 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758919Ab3FDBqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 21:46:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,796,1363158000"; 
   d="scan'208";a="344317243"
Message-ID: <51AD46CA.9020609@intel.com>
Date: Tue, 04 Jun 2013 09:45:46 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Paul Turner <pjt@google.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Namhyung Kim <namhyung@kernel.org>,
        Mike Galbraith <efault@gmx.de>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        Michael Wang <wangyun@linux.vnet.ibm.com>
Subject: Re: [PATCH v5 5/7] sched: compute runnable load avg in cpu_load and
 cpu_avg_load_per_task
References: <1367804711-30308-1-git-send-email-alex.shi@intel.com> <1367804711-30308-6-git-send-email-alex.shi@intel.com> <CAPM31RLJe19FH+RYipwm4kwtzmFHoS2xGTx4iZ9+qwDJZ_pf3A@mail.gmail.com> <20130506101936.GE13861@dyad.programming.kicks-ass.net> <CAPM31RJg87C0nO_tAaOGLaDCUAB+QmfV4LkNcwnk9j9voNocfg@mail.gmail.com> <20130506111041.GA15446@dyad.programming.kicks-ass.net> <51889C8A.5000806@intel.com>
In-Reply-To: <51889C8A.5000806@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2013 02:17 PM, Alex Shi wrote:
> On 05/06/2013 07:10 PM, Peter Zijlstra wrote:
>>>> The runnable_avgs themselves actually have a fair bit of history in
>>>> them already (50% is last 32ms); but given that they don't need to be
>>>> cut-off to respond to load being migrated I'm guessing we could
>>>> actually potentially get by with just "instaneous" and "use averages"
>>>> where appropriate?
>> Sure,. worth a try. If things fall over we can always look at it again.
>>
>>>> We always end up having to re-pick/tune them based on a variety of
>>>> workloads; if we can eliminate them I think it would be a win.
>> Agreed, esp. the plethora of weird idx things we currently have. If we need to
>> re-introduce something it would likely only be the busy case and for that we
>> can immediately link to the balance interval or so.
>>
>>
>>
> 
> I like to have try bases on this patchset. :)
> 
> First, we can remove the idx, to check if the removing is fine for our
> benchmarks, kbuild, dbench, tbench, hackbench, aim7, specjbb etc.
> 
> If there are some regression. we can think more.
> 

Peter,

I just tried to remove the variety rq.cpu_load, by the following patch. 
Because forkexec_idx and busy_idx are all zero, after the patch system just keep cpu_load[0]
and remove other values.
I tried the patch base 3.10-rc3 and latest tip/sched/core with benchmark dbench,tbench,
aim7,hackbench. and oltp of sysbench. Seems performance doesn't change clear.
So, for my tested machines, core2, NHM, SNB, with 2 or 4 CPU sockets, and above tested
benchmark. We are fine to remove the variety cpu_load. 
Don't know if there some other concerns on other scenarios.

---
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 590d535..f0ca983 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4626,7 +4626,7 @@ static inline void update_sd_lb_stats(struct lb_env *env,
        if (child && child->flags & SD_PREFER_SIBLING)
                prefer_sibling = 1;
 
-       load_idx = get_sd_load_idx(env->sd, env->idle);
+       load_idx = 0; //get_sd_load_idx(env->sd, env->idle);
 
        do {
                int local_group;


-- 
Thanks
    Alex
