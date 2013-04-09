Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964859Ab3DIIGi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 04:06:38 -0400
Received: from mga02.intel.com ([134.134.136.20]:35488 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935595Ab3DIIG3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 04:06:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,437,1363158000"; 
   d="scan'208";a="292211525"
Message-ID: <5163CBE6.4070209@intel.com>
Date: Tue, 09 Apr 2013 16:05:58 +0800
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

Thanks for your question, Vincent!
the runnable_avg_period and runnable_avg_sum, only updated in
__update_entity_runnable_avg().
Yes, I didn't see some locks to ensure the coherent of them. but they
are updated closely, and it is not big deal even a little incorrect to
their value. These data are collected periodically, don't need very very
precise at every time.
Am I right? :)

-- 
Thanks Alex
