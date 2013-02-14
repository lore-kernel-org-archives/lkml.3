Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760415Ab3BNNIY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 08:08:24 -0500
Received: from mga03.intel.com ([143.182.124.21]:16751 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757608Ab3BNNIX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 08:08:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,665,1355126400"; 
   d="scan'208";a="202330418"
Message-ID: <511CE1AB.5020503@intel.com>
Date: Thu, 14 Feb 2013 21:07:55 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Paul Turner <pjt@google.com>
CC: Peter Zijlstra <peterz@infradead.org>, torvalds@linux-foundation.org,
        mingo@redhat.com, tglx@linutronix.de, akpm@linux-foundation.org,
        arjan@linux.intel.com, bp@alien8.de, namhyung@kernel.org,
        efault@gmx.de, vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch v4 07/18] sched: set initial load avg of new forked task
References: <1358996820-23036-1-git-send-email-alex.shi@intel.com> <1358996820-23036-8-git-send-email-alex.shi@intel.com> <1360664784.4485.17.camel@laptop> <511BADE3.4050009@intel.com> <CAPM31RJw7a-+QNRwwukg3h3bHCQs++cnT3DgCyHaJTZY7qDsXA@mail.gmail.com>
In-Reply-To: <CAPM31RJw7a-+QNRwwukg3h3bHCQs++cnT3DgCyHaJTZY7qDsXA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 1dff78a..9d1c193 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -1557,8 +1557,8 @@ static void __sched_fork(struct task_struct *p)
>   * load-balance).
>   */
>  #if defined(CONFIG_SMP) && defined(CONFIG_FAIR_GROUP_SCHED)
> -       p->se.avg.runnable_avg_period = 0;
> -       p->se.avg.runnable_avg_sum = 0;
> +       p->se.avg.runnable_avg_period = 1024;
> +       p->se.avg.runnable_avg_sum = 1024;

It can't work.
avg.decay_count needs to be set to 0 before enqueue_entity_load_avg(), then
update_entity_load_avg() can't be called, so, runnable_avg_period/sum
are unusable.

Even we has chance to call __update_entity_runnable_avg(),
avg.last_runnable_update needs be set before that, usually, it needs to
be set as 'now', that cause __update_entity_runnable_avg() function
return 0, then update_entity_load_avg() still can not reach to
__update_entity_load_avg_contrib().

If we embed a simple new task load initialization to many functions,
that is too hard for future reader.

>  #endif
>  #ifdef CONFIG_SCHEDSTATS
>         memset(&p->se.statistics, 0, sizeof(p->se.statistics));
> 
> 
> 
>>
>>
>> --
>> Thanks
>>     Alex


-- 
Thanks
    Alex
