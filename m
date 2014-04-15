Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754434AbaDOCBz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 22:01:55 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:2869 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754394AbaDOCBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 22:01:53 -0400
Message-ID: <534C92B8.30408@huawei.com>
Date: Tue, 15 Apr 2014 10:00:24 +0800
From: Ding Tianhong <dingtianhong@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: Catalin Marinas <Catalin.Marinas@arm.com>, Sukie Peng <Sukie.Peng@arm.com>,
        "huxinwei@huawei.com" <huxinwei@huawei.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm64: Flush the process's mm context TLB entries when
 switching
References: <534BCE80.3090406@huawei.com> <20140414130154.GE3530@arm.com>
In-Reply-To: <20140414130154.GE3530@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.22.246]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/4/14 21:01, Will Deacon wrote:
> Hi Ding,
> 
> On Mon, Apr 14, 2014 at 01:03:12PM +0100, Ding Tianhong wrote:
>> I met a problem when migrating process by following steps:
>>
>> 1) The process was already running on core 0.
>> 2) Set the CPU affinity of the process to 0x02 and move it to core 1,
>>    it could work well.
>> 3) Set the CPU affinity of the process to 0x01 and move it to core 0 again,
>>    the problem occurs and the process was killed.
> 
> [...]
> 
>> It was a very strange problem that the PC and LR are both 0, and the esr is
>> 0x83000006, it means that the used for instruction access generated MMU faults
>> and synchronous external aborts, including synchronous parity errors.
>>
>> I try to fix the problem by invalidating the process's TLB entries when switching,
>> it will make the context stale and pick new one, and then it could work well.
>>
>> So I think in some situation that after the process switching, the modification of
>> the TLB entries in the new core didn't inform all other cores to invalidate the old
>> TLB entries which was in the inner shareable caches, and then if the process schedule
>> to another core, the old TLB entries may occur MMU faults.
> 
> Yes, it sounds like you don't have your TLBs configured correctly. Can you
> confirm that your EL3 firmware is configuring TLB broadcasting correctly
> please?
> 

Hi will:

Do you mean the SCR_EL3.NS?

>> Signed-off-by: Ding Tianhong <dingtianhong@huawei.com>
>> ---
>>  arch/arm64/kernel/process.c | 9 +++++++++
>>  1 file changed, 9 insertions(+)
>>
>> diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
>> index 6391485..d7d8439 100644
>> --- a/arch/arm64/kernel/process.c
>> +++ b/arch/arm64/kernel/process.c
>> @@ -283,6 +283,13 @@ static void tls_thread_switch(struct task_struct *next)
>>  	: : "r" (tpidr), "r" (tpidrro));
>>  }
>>  
>> +static void tlb_flush_thread(struct task_struct *prev)
>> +{
>> +	/* Flush the prev task's TLB entries */
>> +	if (prev->mm)
>> +		flush_tlb_mm(prev->mm);
>> +}
>> +
>>  /*
>>   * Thread switching.
>>   */
>> @@ -296,6 +303,8 @@ struct task_struct *__switch_to(struct task_struct *prev,
>>  	hw_breakpoint_thread_switch(next);
>>  	contextidr_thread_switch(next);
>>  
>> +	tlb_flush_thread(prev);
> 
> NAK to the patch -- the architecture certainly doesn't require this, and
> it's a huge hammer for what is more likely a firmware initialisation issue.
> 
> Will
> 

Yep, I am still doubt with this patch, thanks for your suggestion.

Regards
Ding

> .
> 


