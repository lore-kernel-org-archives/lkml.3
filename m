Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741Ab3G3Brm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 21:47:42 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:47108 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675Ab3G3Brl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 21:47:41 -0400
Message-ID: <51F71AEC.1090709@huawei.com>
Date: Tue, 30 Jul 2013 09:46:20 +0800
From: Xie XiuQi <xiexiuqi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Jens Axboe <jens.axboe@oracle.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hanjun Guo <guohanjun@huawei.com>, Li Zefan <lizefan@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] smp: kill unnecessary variable - csd_flags
References: <51F5D399.3050609@huawei.com> <20130729121305.GE3008@twins.programming.kicks-ass.net>
In-Reply-To: <20130729121305.GE3008@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.69.18]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/7/29 20:13, Peter Zijlstra wrote:
> On Mon, Jul 29, 2013 at 10:29:45AM +0800, Xie XiuQi wrote:
>> We used csd_flags formerly because we allocated csd_data by
>> kmalloc when "wait == 0". When fail to allocation, we will
>> fall back to on-stack allocation. "csd_data" might be invalid
>> after generic_exec_single return.
>>
>> But now we use per cpu data for single cpu ipi calls, and
>> csd_data can't fall back to on-stack allocation when "wait == 0".
>>
>> So csd_flags is unnecessary now. Remove it.
> 
> The much simpler argument is that both callsites of
> generic_exec_single() do an unconditional csd_lock().
> 

That's right. All csd_data are protected by csd_lock.

>> Signed-off-by: Xie XiuQi <xiexiuqi@huawei.com>
>> ---
>>  kernel/smp.c |   11 +----------
>>  1 files changed, 1 insertions(+), 10 deletions(-)
>>
>> diff --git a/kernel/smp.c b/kernel/smp.c
>> index 4dba0f7..cac2b6e 100644
>> --- a/kernel/smp.c
>> +++ b/kernel/smp.c
>> @@ -186,25 +186,16 @@ void generic_smp_call_function_single_interrupt(void)
>>
>>  	while (!list_empty(&list)) {
>>  		struct call_single_data *csd;
>> -		unsigned int csd_flags;
>>
>>  		csd = list_entry(list.next, struct call_single_data, list);
>>  		list_del(&csd->list);
>>
>> -		/*
>> -		 * 'csd' can be invalid after this call if flags == 0
>> -		 * (when called through generic_exec_single()),
>> -		 * so save them away before making the call:
>> -		 */
>> -		csd_flags = csd->flags;
>> -
>>  		csd->func(csd->info);
>>
>>  		/*
>>  		 * Unlocked CSDs are valid through generic_exec_single():
>>  		 */
>> -		if (csd_flags & CSD_FLAG_LOCK)
>> -			csd_unlock(csd);
>> +		csd_unlock(csd);
> 
> The comment is completely useless and confusing after this; why do you
> leave it in? 
> 

Thanks for your comment, I'll remove the comment and send a new version soon.


