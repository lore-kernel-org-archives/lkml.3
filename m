Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555Ab3EIBYl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 21:24:41 -0400
Received: from mga14.intel.com ([143.182.124.37]:17677 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752817Ab3EIBYk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 21:24:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,638,1363158000"; 
   d="scan'208";a="238854968"
Message-ID: <518AFAC6.5010906@intel.com>
Date: Thu, 09 May 2013 09:24:22 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Paul Turner <pjt@google.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
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
Subject: Re: [PATCH v5 6/7] sched: consider runnable load average in move_tasks
References: <1367804711-30308-1-git-send-email-alex.shi@intel.com> <1367804711-30308-7-git-send-email-alex.shi@intel.com> <CAPM31RK71tBPdnXzLmr1o6nmFhbhU9+b_DqX9zNSbDc4EhC8FQ@mail.gmail.com> <20130506150428.GD15446@dyad.programming.kicks-ass.net> <CAPM31RKqMGAvFh1JmUjCjBo4EJWqA39i8=YPiUw8GUkG9dj7Fw@mail.gmail.com> <51888E87.2090506@intel.com> <5189ACD2.1080105@intel.com>
In-Reply-To: <5189ACD2.1080105@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul,

I am wondering if the following patch needed.
The wakeuped migrated task will __synchronize_entity_decay(se); in migrate_task_fair,
then it needs to set `se->avg.last_runnable_update -= (-se->avg.decay_count) << 20'
before update_entity_load_avg, in order to avoid slept time is updated twice for 
se.avg.load_avg_contrib in both __syncchronize and update_entity_load_avg.

but if the slept task is waked up from self cpu, it miss the last_runnable_update before
 update_entity_load_avg(se, 0, 1), so the slept time was used twice in both functions.
Is that right?

Regards
Alex
---
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index a80ae94..1b49e97 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1532,7 +1532,8 @@ static inline void enqueue_entity_load_avg(struct cfs_rq *cfs_rq,
                }
                wakeup = 0;
        } else {
-               __synchronize_entity_decay(se);
+               se->avg.last_runnable_update += __synchronize_entity_decay(se)
+                                                       << 20;
        }
 
        /* migrated tasks did not contribute to our blocked load */
        if (wakeup) {
                subtract_blocked_load_contrib(cfs_rq, se->avg.load_avg_contrib);                                                 
                update_entity_load_avg(se, 0, 1);                                                                                
        }


-- 
Thanks
    Alex
