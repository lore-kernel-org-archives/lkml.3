Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762355Ab3DCGBo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 02:01:44 -0400
Received: from mga02.intel.com ([134.134.136.20]:3749 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760093Ab3DCGBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 02:01:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,399,1363158000"; 
   d="scan'208";a="311543721"
Message-ID: <515BC5AE.4070808@intel.com>
Date: Wed, 03 Apr 2013 14:01:18 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Michael Wang <wangyun@linux.vnet.ibm.com>
CC: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        morten.rasmussen@arm.com, vincent.guittot@linaro.org,
        gregkh@linuxfoundation.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org,
        len.brown@intel.com, rafael.j.wysocki@intel.com, jkosina@suse.cz,
        clark.williams@gmail.com, tony.luck@intel.com, keescook@chromium.org,
        mgorman@suse.de, riel@redhat.com
Subject: Re: [patch v3 0/8] sched: use runnable avg in load balance
References: <1364873008-3169-1-git-send-email-alex.shi@intel.com> <515A877B.3020908@linux.vnet.ibm.com> <515A9859.6000606@intel.com> <515B97FF.2040409@linux.vnet.ibm.com> <515B9A7A.6030807@intel.com> <515BA0B7.2090906@linux.vnet.ibm.com> <515BAFE6.1020804@intel.com> <515BC04C.6050403@linux.vnet.ibm.com>
In-Reply-To: <515BC04C.6050403@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2013 01:38 PM, Michael Wang wrote:
> On 04/03/2013 12:28 PM, Alex Shi wrote:
> [snip]
>>
>> but the patch may cause some unfairness if this/prev cpu are not burst at 
>> same time. So could like try the following patch?
> 
> I will try it later, some doubt below :)
> 
> [snip]
>> +
>> +	if (cpu_rq(this_cpu)->avg_idle < sysctl_sched_migration_cost ||
>> +		cpu_rq(prev_cpu)->avg_idle < sysctl_sched_migration_cost)
>> +		burst= 1;
>> +
>> +	/* use instant load for bursty waking up */
>> +	if (!burst) {
>> +		load = source_load(prev_cpu, idx);
>> +		this_load = target_load(this_cpu, idx);
>> +	} else {
>> +		load = cpu_rq(prev_cpu)->load.weight;
>> +		this_load = cpu_rq(this_cpu)->load.weight;
> 
> Ok, my understanding is, we want pull if 'prev_cpu' is burst, and don't
> want pull if 'this_cpu' is burst, correct?

Nope, as my thought, a burst cpu doesn't mean it has heavy load than
others, so we still need to compare their load on the same condition.
> 
> And we do this by guess the load higher or lower, is that right?

ditto.
> 
> And I think target_load() is capable enough to choose the higher load,
> if 'cpu_rq(cpu)->load.weight' is really higher, the results will be the
> same.
> 
> So what about this:
> 
> 	/* prefer higher load if burst */
> 	load = burst_prev ?
> 		target_load(prev_cpu, idx) : source_load(prev_cpu, idx);
> 
> 	this_load = target_load(this_cpu, idx);

here, the idx is zero, so source_load and target load is same.
> 
> Regards,
> Michael Wang
> 
>> +	}
>>
>>  	/*
>>  	 * If sync wakeup then subtract the (maximum possible)
>>
> 


-- 
Thanks Alex
