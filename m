Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759149Ab3DCBDI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 21:03:08 -0400
Received: from mga11.intel.com ([192.55.52.93]:3215 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759053Ab3DCBDG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 21:03:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,396,1363158000"; 
   d="scan'208";a="316003360"
Message-ID: <515B7F99.3000407@intel.com>
Date: Wed, 03 Apr 2013 09:02:17 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Vincent Guittot <vincent.guittot@linaro.org>
CC: "mingo@redhat.com" <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>, Paul Turner <pjt@google.com>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        gregkh@linuxfoundation.org,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch v6 03/21] sched: only count runnable avg on cfs_rq's nr_running
References: <1364654108-16307-1-git-send-email-alex.shi@intel.com> <1364654108-16307-4-git-send-email-alex.shi@intel.com> <CAKfTPtArivjSsVn=Xc_421oqo+mXUfMaXhfyATK+s=xXO+P3eA@mail.gmail.com>
In-Reply-To: <CAKfTPtArivjSsVn=Xc_421oqo+mXUfMaXhfyATK+s=xXO+P3eA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2013 10:30 PM, Vincent Guittot wrote:
> On 30 March 2013 15:34, Alex Shi <alex.shi@intel.com> wrote:
>> Old function count the runnable avg on rq's nr_running even there is
>> only rt task in rq. That is incorrect, so correct it to cfs_rq's
>> nr_running.
>>
>> Signed-off-by: Alex Shi <alex.shi@intel.com>
>> ---
>>  kernel/sched/fair.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>> index 2881d42..026e959 100644
>> --- a/kernel/sched/fair.c
>> +++ b/kernel/sched/fair.c
>> @@ -2829,7 +2829,7 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
>>         }
>>
>>         if (!se) {
>> -               update_rq_runnable_avg(rq, rq->nr_running);
>> +               update_rq_runnable_avg(rq, rq->cfs.nr_running);
> 
> A RT task that preempts your CFS task will be accounted in the
> runnable_avg fields. So whatever you do, RT task will impact your
> runnable_avg statistics. Instead of trying to get only CFS tasks, you
> should take into account all tasks activity in the rq.

Thanks for comments, Vincent!

Yes, I know some rt task time was counted into cfs, but now we have no
good idea to remove them clearly. So I just want to a bit more precise
cfs runnable load here.
On the other side, periodic LB balance on combined the cfs/rt load, but
removed the RT utilisation in cpu_power.

So, PJT, Peter, what's your idea of this point?
> 
> Vincent
>>                 inc_nr_running(rq);
>>         }
>>         hrtick_update(rq);
>> --
>> 1.7.12
>>


-- 
Thanks Alex
