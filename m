Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268AbaLHMG6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 07:06:58 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:27938 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982AbaLHMG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 07:06:57 -0500
Message-ID: <54859454.30603@huawei.com>
Date: Mon, 8 Dec 2014 20:06:44 +0800
From: Wang Nan <wangnan0@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: "Jon Medhurst (Tixy)" <tixy@linaro.org>
CC: <masami.hiramatsu.pt@hitachi.com>, <linux@arm.linux.org.uk>,
        <lizefan@huawei.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v14 7/7] ARM: kprobes: enable OPTPROBES for ARM 32
References: <1418020040-68977-1-git-send-email-wangnan0@huawei.com>		 <1418020131-69375-1-git-send-email-wangnan0@huawei.com>	 <1418036666.3647.33.camel@linaro.org> <5485886E.2060303@huawei.com> <1418039451.3647.48.camel@linaro.org>
In-Reply-To: <1418039451.3647.48.camel@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.69.90]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A0B0206.5485945F.009A,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 9257eea5d514716c828b0c252b8d71d0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/12/8 19:50, Jon Medhurst (Tixy) wrote:
> On Mon, 2014-12-08 at 19:15 +0800, Wang Nan wrote:
>> On 2014/12/8 19:04, Jon Medhurst (Tixy) wrote:
>>> On Mon, 2014-12-08 at 14:28 +0800, Wang Nan wrote:
>>>> This patch introduce kprobeopt for ARM 32.
>>>>
>>>> Limitations:
>>>>  - Currently only kernel compiled with ARM ISA is supported.
>>>>
>>>>  - Offset between probe point and optinsn slot must not larger than
>>>>    32MiB. Masami Hiramatsu suggests replacing 2 words, it will make
>>>>    things complex. Futher patch can make such optimization.
>>>>
>>>> Kprobe opt on ARM is relatively simpler than kprobe opt on x86 because
>>>> ARM instruction is always 4 bytes aligned and 4 bytes long. This patch
>>>> replace probed instruction by a 'b', branch to trampoline code and then
>>>> calls optimized_callback(). optimized_callback() calls opt_pre_handler()
>>>> to execute kprobe handler. It also emulate/simulate replaced instruction.
>>>>
>>>> When unregistering kprobe, the deferred manner of unoptimizer may leave
>>>> branch instruction before optimizer is called. Different from x86_64,
>>>> which only copy the probed insn after optprobe_template_end and
>>>> reexecute them, this patch call singlestep to emulate/simulate the insn
>>>> directly. Futher patch can optimize this behavior.
>>>>
>>>> Signed-off-by: Wang Nan <wangnan0@huawei.com>
>>>> Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
>>>> Cc: Jon Medhurst (Tixy) <tixy@linaro.org>
>>>> Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>
>>>> Cc: Will Deacon <will.deacon@arm.com>
>>>> ---
>>> [...]
>>>> v13 -> v14:
>>>>   - Use stop_machine to wrap arch_optimize_kprobes to avoid a racing.
>>>
>>> Think we need to use stop_machine differently, see comments on code
>>> below.
>>
>> Well, yes, I experienced one deadlock at serval minutes before.
>> I'm not very sure the reason and working on it now. I think it may caused
>> by recursivly stop_machine().
>>
>>>
>>>> ---
>>>>  arch/arm/Kconfig                        |   1 +
>>>>  arch/arm/{kernel => include/asm}/insn.h |   0
>>>>  arch/arm/include/asm/kprobes.h          |  29 +++
>>>>  arch/arm/kernel/Makefile                |   2 +-
>>>>  arch/arm/kernel/ftrace.c                |   3 +-
>>>>  arch/arm/kernel/jump_label.c            |   3 +-
>>>>  arch/arm/probes/kprobes/Makefile        |   1 +
>>>>  arch/arm/probes/kprobes/opt-arm.c       | 322 ++++++++++++++++++++++++++++++++
>>>>  samples/kprobes/kprobe_example.c        |   2 +-
>>>
>>> The change kprobe_example.c doesn't apply and I guess wasn't meant to be
>>> included in the patch?
>>>
>>
>> Yes. These 2 lines are introduced by mistake.
>>
>>> [...]
>>>> +/*
>>>> + * Similar to __arch_disarm_kprobe, operations which removing
>>>> + * breakpoints must be wrapped by stop_machine to avoid racing.
>>>> + */
>>>> +static __kprobes int __arch_optimize_kprobes(void *p)
>>>> +{
>>>> +	struct list_head *oplist = p;
>>>> +	struct optimized_kprobe *op, *tmp;
>>>> +
>>>> +	list_for_each_entry_safe(op, tmp, oplist, list) {
>>>> +		unsigned long insn;
>>>> +		WARN_ON(kprobe_disabled(&op->kp));
>>>> +
>>>> +		/*
>>>> +		 * Backup instructions which will be replaced
>>>> +		 * by jump address
>>>> +		 */
>>>> +		memcpy(op->optinsn.copied_insn, op->kp.addr,
>>>> +				RELATIVEJUMP_SIZE);
>>>> +
>>>> +		insn = arm_gen_branch((unsigned long)op->kp.addr,
>>>> +				(unsigned long)op->optinsn.insn);
>>>> +		BUG_ON(insn == 0);
>>>> +
>>>> +		/*
>>>> +		 * Make it a conditional branch if replaced insn
>>>> +		 * is consitional
>>>> +		 */
>>>> +		insn = (__mem_to_opcode_arm(
>>>> +			  op->optinsn.copied_insn[0]) & 0xf0000000) |
>>>> +			(insn & 0x0fffffff);
>>>> +
>>>> +		patch_text(op->kp.addr, insn);
>>>
>>> patch_text() itself may use stop_machine under certain circumstances,
>>> and if it were to do so, I believe that would cause the system to
>>> lock/panic. So, this should be __patch_text() instead, but we would also
>>> need to take care of the cache_ops_need_broadcast() case, where all
>>> CPU's need to invalidate their own caches and we can't rely on just one
>>> CPU executing the code patching whilst other CPUs spin and wait. Though
>>> to make life easier, we could just not optimise kprobes in the legacy
>>> cache_ops_need_broadcast() case.
>>>
>>>> +
>>>> +		list_del_init(&op->list);
>>>> +	}
>>>> +	return 0;
>>>> +}
>>>> +
>>>> +void arch_optimize_kprobes(struct list_head *oplist)
>>>> +{
>>>> +	stop_machine(__arch_optimize_kprobes, oplist, cpu_online_mask);
>>>> +}
>>>
>>> I believe passing cpu_online_mask above will cause
>>> __arch_optimize_kprobes to be executed on every CPU, is this safe? If it
>>> is, it's a serendipitous optimisation if each CPU can process different
>>> probes in the list. If it's not safe, this needs to be NULL instead so
>>> only one CPU executes the code.
>>>
>>
>> This stop_machine() call is copied from arch_disarm_kprobe, I think their
>> senario should be similar.
> 
> arch_disarm_kprobe is just executing __patch_text on each cpu, which
> pokes a word of memory with a new value and flushes caches for it.
> 
> arch_optimize_kprobes is calling __arch_optimize_kprobes, which is
> iterating over a list of probes and removing each one in turn, if this
> is happening on multiple cpu's simultaneously, it's not clear to me that
> such an operation is safe. list_del_init calls __list_del which does
> 
> 	next->prev = prev;
> 	prev->next = next;
> 
> so what happens if another cpu is at the same time updating any of those
> list entries? Without even fully analysing the code I can see that with
> the fact that the list handling helpers have no memory barriers, that
> the above two lines could be seen to execute in the reverse order, e.g.
>  
> 	prev->next = next;
> 	next->prev = prev;
> 
> so another CPU could find and delete next before this one has finished
> doing so. Would the list end up in a consistent state where no loops
> develop and no probes are missed? I don't know the answer and a full
> analysis would be complicated, but my gut feeling is that if a cpu can
> observe the links in the list in an inconsistent state then only bad
> things can result.
> 

I see the problem.

I'm thinking about making core.c and opt-arm.c to share stop_machine() code.
stop_machine() is required when removing breakpoint, so I'd like to define
a "remove_breakpoint" function in core.c and make opt-arm.c to call it.
Do you think it is a good idea?


