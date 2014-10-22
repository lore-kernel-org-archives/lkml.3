Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527AbaJVFjs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 01:39:48 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53890 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbaJVFjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 01:39:47 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.0.1
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-3
Message-ID: <544742F8.80000@jp.fujitsu.com>
Date: Wed, 22 Oct 2014 14:39:04 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: <mingo@redhat.com>, <kernellwp@gmail.com>, <riel@redhat.com>,
        <tkhai@yandex.ru>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] sched/fair: Care divide error in update_task_scan_period()
References: <543F945F.4020303@jp.fujitsu.com> <20141021092112.GO23531@worktop.programming.kicks-ass.net>
In-Reply-To: <20141021092112.GO23531@worktop.programming.kicks-ass.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/10/21 18:21), Peter Zijlstra wrote:
> On Thu, Oct 16, 2014 at 06:48:15PM +0900, Yasuaki Ishimatsu wrote:
>> +++ b/kernel/sched/fair.c
>> @@ -1466,6 +1466,7 @@ static void update_task_scan_period(struct task_struct *p,
>>
>>   	unsigned long remote = p->numa_faults_locality[0];
>>   	unsigned long local = p->numa_faults_locality[1];
>> +	unsigned long total_faults = shared + private;
>>
>>   	/*
>>   	 * If there were no record hinting faults then either the task is
>> @@ -1496,6 +1497,14 @@ static void update_task_scan_period(struct task_struct *p,
>>   			slot = 1;
>>   		diff = slot * period_slot;
>>   	} else {
>> +		/*
>> +		 * This is a rare case. total_faults might become 0 after
>> +		 * offlining node. In this case, total_faults is set to 1
>> +		 * for avoiding divide error.
>> +		 */
>> +		if (unlikely(total_faults == 0))
>> +			total_faults = 1;
>> +
>>   		diff = -(NUMA_PERIOD_THRESHOLD - ratio) * period_slot;
>>
>>   		/*
>> @@ -1506,7 +1515,7 @@ static void update_task_scan_period(struct task_struct *p,
>>   		 * scanning faster if shared accesses dominate as it may
>>   		 * simply bounce migrations uselessly
>>   		 */
>> -		ratio = DIV_ROUND_UP(private * NUMA_PERIOD_SLOTS, (private + shared));
>> +		ratio = DIV_ROUND_UP(private * NUMA_PERIOD_SLOTS, (total_faults));
>>   		diff = (diff * ratio) / NUMA_PERIOD_SLOTS;
>

> So what was wrong with the 'normal' unconditional +1 approach? Also
> you've got superfluous parenthese.
>

When (private + shared) was not 0, I did not want to change behavior of
update_task_scan_period(). But I understood your comment. I'll update it.

Thanks,
Yasuaki Ishimatsu

