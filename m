Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935411Ab3DJGIk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 02:08:40 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:34042 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934966Ab3DJGIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 02:08:39 -0400
Message-ID: <51650185.9060905@linux.vnet.ibm.com>
Date: Wed, 10 Apr 2013 14:07:01 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Vincent Guittot <vincent.guittot@linaro.org>
CC: Alex Shi <alex.shi@intel.com>, "mingo@redhat.com" <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>, Paul Turner <pjt@google.com>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        gregkh@linuxfoundation.org,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Len Brown <len.brown@intel.com>, rafael.j.wysocki@intel.com,
        jkosina@suse.cz, clark.williams@gmail.com,
        "tony.luck@intel.com" <tony.luck@intel.com>, keescook@chromium.org,
        mgorman@suse.de, riel@redhat.com
Subject: Re: [patch v3 6/8] sched: consider runnable load average in move_tasks
References: <1364873008-3169-1-git-send-email-alex.shi@intel.com> <1364873008-3169-7-git-send-email-alex.shi@intel.com> <CAKfTPtBoV3KoSHuTnZVrvPdCM+5ckFGXfM11oCB1Le_Zmy1hYQ@mail.gmail.com>
In-Reply-To: <CAKfTPtBoV3KoSHuTnZVrvPdCM+5ckFGXfM11oCB1Le_Zmy1hYQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041005-0260-0000-0000-000002C89F32
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2013 03:08 PM, Vincent Guittot wrote:
> On 2 April 2013 05:23, Alex Shi <alex.shi@intel.com> wrote:
>> Except using runnable load average in background, move_tasks is also
>> the key functions in load balance. We need consider the runnable load
>> average in it in order to the apple to apple load comparison.
>>
>> Signed-off-by: Alex Shi <alex.shi@intel.com>
>> ---
>>  kernel/sched/fair.c | 11 ++++++++++-
>>  1 file changed, 10 insertions(+), 1 deletion(-)
>>
>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>> index 1f9026e..bf4e0d4 100644
>> --- a/kernel/sched/fair.c
>> +++ b/kernel/sched/fair.c
>> @@ -3966,6 +3966,15 @@ static unsigned long task_h_load(struct task_struct *p);
>>
>>  static const unsigned int sched_nr_migrate_break = 32;
>>
>> +static unsigned long task_h_load_avg(struct task_struct *p)
>> +{
>> +       u32 period = p->se.avg.runnable_avg_period;
>> +       if (!period)
>> +               return 0;
>> +
>> +       return task_h_load(p) * p->se.avg.runnable_avg_sum / period;
> 
> How do you ensure that runnable_avg_period and runnable_avg_sum are
> coherent ? an update of the statistic can occur in the middle of your
> sequence.

Hi, Vincent

Don't we have the 'rq->lock' to protect it?

move_tasks() was invoked with double locked, for all the se on src and
dst rq, no update should happen, isn't it?

Regards,
Michael Wang

> 
> Vincent
> 
>> +}
>> +
>>  /*
>>   * move_tasks tries to move up to imbalance weighted load from busiest to
>>   * this_rq, as part of a balancing operation within domain "sd".
>> @@ -4001,7 +4010,7 @@ static int move_tasks(struct lb_env *env)
>>                 if (throttled_lb_pair(task_group(p), env->src_cpu, env->dst_cpu))
>>                         goto next;
>>
>> -               load = task_h_load(p);
>> +               load = task_h_load_avg(p);
>>
>>                 if (sched_feat(LB_MIN) && load < 16 && !env->sd->nr_balance_failed)
>>                         goto next;
>> --
>> 1.7.12
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

