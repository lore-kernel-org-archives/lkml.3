Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181AbaLIKZQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 05:25:16 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:47363 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754248AbaLIKZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 05:25:14 -0500
Message-ID: <5486CE02.5070808@hitachi.com>
Date: Tue, 09 Dec 2014 19:25:06 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: "Jon Medhurst (Tixy)" <tixy@linaro.org>
Cc: Wang Nan <wangnan0@huawei.com>, linux@arm.linux.org.uk, lizefan@huawei.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: Re: [RESEND][PATCH v15 7/7] ARM: kprobes: enable OPTPROBES
 for ARM 32
References: <1418047765-53197-1-git-send-email-wangnan0@huawei.com>  <1418047765-53197-8-git-send-email-wangnan0@huawei.com>  <54869B1C.6050401@hitachi.com> <1418116450.3641.7.camel@linaro.org>
In-Reply-To: <1418116450.3641.7.camel@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/12/09 18:14), Jon Medhurst (Tixy) wrote:
[...]
>>> diff --git a/arch/arm/probes/kprobes/core.c b/arch/arm/probes/kprobes/core.c
>>> index 3a58db4..a4ec240 100644
>>> --- a/arch/arm/probes/kprobes/core.c
>>> +++ b/arch/arm/probes/kprobes/core.c
>>> @@ -163,19 +163,31 @@ void __kprobes arch_arm_kprobe(struct kprobe *p)
>>>   * memory. It is also needed to atomically set the two half-words of a 32-bit
>>>   * Thumb breakpoint.
>>>   */
>>> -int __kprobes __arch_disarm_kprobe(void *p)
>>> -{
>>> -	struct kprobe *kp = p;
>>> -	void *addr = (void *)((uintptr_t)kp->addr & ~1);
>>> -
>>> -	__patch_text(addr, kp->opcode);
>>> +struct patch {
>>> +	void *addr;
>>> +	unsigned int insn;
>>> +};
>>>  
>>> +static int __kprobes_remove_breakpoint(void *data)
>>> +{
>>> +	struct patch *p = data;
>>> +	__patch_text(p->addr, p->insn);
>>>  	return 0;
>>>  }
>>>  
>>> +void __kprobes kprobes_remove_breakpoint(void *addr, unsigned int insn)
>>> +{
>>> +	struct patch p = {
>>> +		.addr = addr,
>>> +		.insn = insn,
>>> +	};
>>> +	stop_machine(__kprobes_remove_breakpoint, &p, cpu_online_mask);
>>> +}
>>
>> Hmm, I think finally we should fix patch_text() in patch.c to forcibly use stop_machine
>> by adding "bool stop" parameter, instead of introducing new another patch_text()
>> implementation, because we'd better avoid two private "patch" data structures.
> 
> That was my first thought too, then I realised that breaks encapsulation
> of the patch_text implementation, because its use of stop_machine is an
> implementation detail and it could be rewritten to not use stop machine.
> (That is sort of on my long term todo list
> https://lkml.org/lkml/2014/9/4/188)

Indeed. OK, now let it goes. :)

> Whereas stop machine is used by kprobes to avoid race conditions with
> the undefined instruction exception handler and something like that
> would be needed even if patch_text didn't use stop_machine.

At this point, it's OK.

However, I'm not convinced completely. Perhaps, it depends on cache-coherent bus
implementation, but there may be some implementations which can allow us to
change one instruction atomically without stop_machine.

I'm actually interested in PREEMPT_RT on arm32, and this stop_machine() is a barrier
to apply kprobes on real-time systems.

Thank you,


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


