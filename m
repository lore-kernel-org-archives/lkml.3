Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816AbaEPJwD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 05:52:03 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:21976 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751475AbaEPJwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 05:52:01 -0400
X-IronPort-AV: E=Sophos;i="4.97,1066,1389715200"; 
   d="scan'208";a="30616545"
Message-ID: <5375E0BA.7020208@cn.fujitsu.com>
Date: Fri, 16 May 2014 17:56:10 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: <jjherne@linux.vnet.ibm.com>, Sasha Levin <sasha.levin@oracle.com>,
        Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: workqueue: WARN at at kernel/workqueue.c:2176
References: <537119EF.2060102@oracle.com> <20140512200135.GL1421@htj.dyndns.org> <53718119.1090000@cn.fujitsu.com> <537180B9.6080407@oracle.com> <53739F3B.4060608@linux.vnet.ibm.com> <53758B12.8060609@cn.fujitsu.com> <20140516093530.GN11096@twins.programming.kicks-ass.net>
In-Reply-To: <20140516093530.GN11096@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2014 05:35 PM, Peter Zijlstra wrote:
> On Fri, May 16, 2014 at 11:50:42AM +0800, Lai Jiangshan wrote:
>> After debugging, I found the hotlug-in cpu is atctive but !online in this case.
>> the problem was introduced by 5fbd036b.
>> Some code assumes that any cpu in cpu_active_mask is also online, but 5fbd036b breaks
>> this assumption, so the corresponding code with this assumption should be changed too.
> 
> Good find, and yes it does that.
> 
>> The following patch is just a workaround. After it is applied, the above WARNING
>> is gone, but I can't hit the wq problem that you found.
> 
> Seeing how the entirety of hotplug is basically duct tape and twigs, the
> below isn't that bad.

I think we need to find a more grace solution...

> 
>> ---
>> diff --git a/kernel/cpu.c b/kernel/cpu.c
>> index a9e710e..253a129 100644
>> --- a/kernel/cpu.c
>> +++ b/kernel/cpu.c
>> @@ -726,9 +726,10 @@ void set_cpu_present(unsigned int cpu, bool present)
>>  
>>  void set_cpu_online(unsigned int cpu, bool online)
>>  {
>> -	if (online)
>> +	if (online) {
>>  		cpumask_set_cpu(cpu, to_cpumask(cpu_online_bits));
>> -	else
>> +		cpumask_set_cpu(cpu, to_cpumask(cpu_active_bits));
>> +	} else
>>  		cpumask_clear_cpu(cpu, to_cpumask(cpu_online_bits));
>>  }
>>  
>> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
>> index 268a45e..c1a712d 100644
>> --- a/kernel/sched/core.c
>> +++ b/kernel/sched/core.c
>> @@ -5043,7 +5043,6 @@ static int sched_cpu_active(struct notifier_block *nfb,
>>  				      unsigned long action, void *hcpu)
>>  {
>>  	switch (action & ~CPU_TASKS_FROZEN) {
>> -	case CPU_STARTING:
>>  	case CPU_DOWN_FAILED:
>>  		set_cpu_active((long)hcpu, true);
>>  		return NOTIFY_OK;

