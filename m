Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934506AbaH0NhW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 09:37:22 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:46278 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933404AbaH0NhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 09:37:19 -0400
Message-ID: <53FDDF08.5090604@hitachi.com>
Date: Wed, 27 Aug 2014 22:37:12 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Wang Nan <wangnan0@huawei.com>, Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@linux.intel.com>,
        Pei Feiyue <peifeiyue@huawei.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kprobes/x86: opt: free optinsn cache when range check
 fails
References: <1406550019-70935-1-git-send-email-wangnan0@huawei.com> <53D6FC38.8070801@hitachi.com> <53FDCBF1.2020606@huawei.com>
In-Reply-To: <53FDCBF1.2020606@huawei.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Ingo,

Could you pull this for a bugfix of a memory leak?

(2014/08/27 21:15), Wang Nan wrote:
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
> 
> Hi Masami Hiramatsu,
> 
> I don't find this patch in newest upstream. Is there any problem?
> 
>> BTW, would you really have hit this error?
>> I'd like to know the case if this really happens.
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
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


