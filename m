Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628AbaG2Bzh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 21:55:37 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:21508 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbaG2Bzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 21:55:36 -0400
Message-ID: <53D6FEFE.8060307@huawei.com>
Date: Tue, 29 Jul 2014 09:55:10 +0800
From: Wang Nan <wangnan0@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "Andi Kleen" <ak@linux.intel.com>, Pei Feiyue <peifeiyue@huawei.com>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kprobes/x86: opt: free optinsn cache when range check
 fails
References: <1406550019-70935-1-git-send-email-wangnan0@huawei.com> <53D6FC38.8070801@hitachi.com>
In-Reply-To: <53D6FC38.8070801@hitachi.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.69.90]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A02020A.53D6FF16.00A8,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2011-05-27 18:58:46
X-Mirapoint-Loop-Id: 01fca3654177396cbe02ba33025b5184
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/7/29 9:43, Masami Hiramatsu wrote:
> (2014/07/28 21:20), Wang Nan wrote:
>> This patch frees optinsn slot when range check error to prevent memory
>> leaks. Before this patch, cache entry in kprobe_insn_cache won't be
>> freed if kprobe optimizing fails due to range check failure.
>>
>> Signed-off-by: Wang Nan <wangnan0@huawei.com>
> 
> Oops, thank you for finding it!
> 
> Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> 
> BTW, would you really have hit this error?
> I'd like to know the case if this really happens.

I'm not really hit it on x86_64. I found this problem when trying to implement kprobe opt on arm.

On arm, relative jump can only branch on/backward 64MB, which makes it a realistic problem.

> 
>> ---
>>  arch/x86/kernel/kprobes/opt.c | 4 +++-
>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kernel/kprobes/opt.c b/arch/x86/kernel/kprobes/opt.c
>> index f304773..f1314d0 100644
>> --- a/arch/x86/kernel/kprobes/opt.c
>> +++ b/arch/x86/kernel/kprobes/opt.c
>> @@ -338,8 +338,10 @@ int arch_prepare_optimized_kprobe(struct optimized_kprobe *op)
>>  	 * a relative jump.
>>  	 */
>>  	rel = (long)op->optinsn.insn - (long)op->kp.addr + RELATIVEJUMP_SIZE;
>> -	if (abs(rel) > 0x7fffffff)
>> +	if (abs(rel) > 0x7fffffff) {
>> +		__arch_remove_optimized_kprobe(op, 0);
>>  		return -ERANGE;
>> +	}
>>  
>>  	buf = (u8 *)op->optinsn.insn;
>>  
>>
> 
> 


