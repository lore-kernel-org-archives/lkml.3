Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594Ab3AQWgj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 17:36:39 -0500
Received: from relay3.sgi.com ([192.48.152.1]:33938 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750814Ab3AQWgi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 17:36:38 -0500
Message-ID: <50F87CF6.10601@sgi.com>
Date: Thu, 17 Jan 2013 16:36:38 -0600
From: Nathan Zimmer <nzimmer@sgi.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: <mingo@redhat.com>, <peterz@infradead.org>, <tglx@linutronix.de>,
        <johnstul@us.ibm.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND 1/4] sched: /proc/sched_stat fails on very very
 large machines.
References: <1358286372-13777-1-git-send-email-nzimmer@sgi.com> <1358286372-13777-2-git-send-email-nzimmer@sgi.com> <20130116135352.890bd6bd.akpm@linux-foundation.org>
In-Reply-To: <20130116135352.890bd6bd.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.162.233.130]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2013 03:53 PM, Andrew Morton wrote:
> On Tue, 15 Jan 2013 15:46:09 -0600
> Nathan Zimmer <nzimmer@sgi.com> wrote:
>
>> On systems with 4096 cores doing a cat /proc/sched_stat fails.
>> We are trying to push all the data into a single kmalloc buffer.
>> The issue is on these very large machines all the data will not fit in 4mb.
>>
>> A better solution is to not us the single_open mechanism but to provide
>> our own seq_operations.
>>
>> The output should be identical to previous version and thus not need the
>> version number.
>>
>> ...
>>
>> index 903ffa9..33a85c9 100644
>> --- a/kernel/sched/stats.c
>> +++ b/kernel/sched/stats.c
>> @@ -21,9 +21,13 @@ static int show_schedstat(struct seq_file *seq, void *v)
>>   	if (mask_str == NULL)
>>   		return -ENOMEM;
>>   
>> -	seq_printf(seq, "version %d\n", SCHEDSTAT_VERSION);
>> -	seq_printf(seq, "timestamp %lu\n", jiffies);
>> -	for_each_online_cpu(cpu) {
>> +	if (v == (void *)1) {
> The magic-numbers-in-pointers at least need comments, please.  Or nice
> and meaningful #defines.
>
>> +		seq_printf(seq, "version %d\n", SCHEDSTAT_VERSION);
>> +		seq_printf(seq, "timestamp %lu\n", jiffies);
> The code leaks the memory at mask_str here.
>
>> +	} else {
>> +
>> +		cpu = (unsigned long)(v - 2);
>> +
>>   		struct rq *rq = cpu_rq(cpu);
>>   #ifdef CONFIG_SMP
>>   		struct sched_domain *sd;
>> @@ -72,35 +76,64 @@ static int show_schedstat(struct seq_file *seq, void *v)
>>   		}
>>   		rcu_read_unlock();
>>   #endif
>> +		kfree(mask_str);
>>   	}
>> -	kfree(mask_str);
>>   	return 0;
>>   }
> Undoing this change will fix the leak.
>
> The schedstats code (both the original and after the patch) appears to
> be racy against cpu hotplug?  What prevents the rq from vanishing while
> we're playing with it?
>
>
Looking at other usages people seem to be quite willing to just read a 
variable
here and there without locking.  The structure is a percpu structure so 
I don't
believe rq will vanish, perhaps the backing data might become 
meaningless though...


