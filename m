Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504AbaG2LgX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 07:36:23 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:33231 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383AbaG2LgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 07:36:21 -0400
Message-ID: <53D7872E.8050506@hitachi.com>
Date: Tue, 29 Jul 2014 20:36:14 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Wang Nan <wangnan0@huawei.com>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andi Kleen <ak@linux.intel.com>, Pei Feiyue <peifeiyue@huawei.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Re: [PATCH] kprobes/x86: opt: free optinsn cache when range
 check fails
References: <1406550019-70935-1-git-send-email-wangnan0@huawei.com> <53D6FC38.8070801@hitachi.com> <53D6FEFE.8060307@huawei.com>
In-Reply-To: <53D6FEFE.8060307@huawei.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wang,

(2014/07/29 10:55), Wang Nan wrote:
> On 2014/7/29 9:43, Masami Hiramatsu wrote:
>> (2014/07/28 21:20), Wang Nan wrote:
>>> This patch frees optinsn slot when range check error to prevent memory
>>> leaks. Before this patch, cache entry in kprobe_insn_cache won't be
>>> freed if kprobe optimizing fails due to range check failure.
>>>
>>> Signed-off-by: Wang Nan <wangnan0@huawei.com>
>>
>> Oops, thank you for finding it!
>>
>> Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
>>
>> BTW, would you really have hit this error?
>> I'd like to know the case if this really happens.
> 
> I'm not really hit it on x86_64. I found this problem when trying to implement kprobe opt on arm.

That's interesting :)

> 
> On arm, relative jump can only branch on/backward 64MB, which makes it a realistic problem.

Yeah, that is what I expected on RISC processor such as ARM.

Perhaps you'll need to overwrite 2 words, one is for "ldr pc, [pc, #-4]" and one is for
the address data. In this case, you have no branch range limitation in 32bit mode. This
requires branch destination checking for safety as x86 optprobe does.
Plus, you'll have to use same technique of x86 to make a detour code and deferred
optimization for overwriting multiple instructions. Put a breakpoint at the probe point,
wait for synchronize_sched(), put the 2nd instruction(.data) and overwrite the breakpoint
with the "ldr". :)

However, that is only for arm32.
For ARM64, I'm not so sure about its ISA. I guess we need a scratchpad area for that..

Anyway, please CC to me when you've done the prototyping and sending RFC. I'll review
and test it. :)

Thank you,

> 
>>
>>> ---
>>>  arch/x86/kernel/kprobes/opt.c | 4 +++-
>>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/arch/x86/kernel/kprobes/opt.c b/arch/x86/kernel/kprobes/opt.c
>>> index f304773..f1314d0 100644
>>> --- a/arch/x86/kernel/kprobes/opt.c
>>> +++ b/arch/x86/kernel/kprobes/opt.c
>>> @@ -338,8 +338,10 @@ int arch_prepare_optimized_kprobe(struct optimized_kprobe *op)
>>>  	 * a relative jump.
>>>  	 */
>>>  	rel = (long)op->optinsn.insn - (long)op->kp.addr + RELATIVEJUMP_SIZE;
>>> -	if (abs(rel) > 0x7fffffff)
>>> +	if (abs(rel) > 0x7fffffff) {
>>> +		__arch_remove_optimized_kprobe(op, 0);
>>>  		return -ERANGE;
>>> +	}
>>>  
>>>  	buf = (u8 *)op->optinsn.insn;
>>>  
>>>
>>
>>
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


