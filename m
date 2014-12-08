Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932114AbaLHLQT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 06:16:19 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:1663 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932080AbaLHLQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 06:16:18 -0500
Message-ID: <5485886E.2060303@huawei.com>
Date: Mon, 8 Dec 2014 19:15:58 +0800
From: Wang Nan <wangnan0@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: "Jon Medhurst (Tixy)" <tixy@linaro.org>
CC: <masami.hiramatsu.pt@hitachi.com>, <linux@arm.linux.org.uk>,
        <lizefan@huawei.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v14 7/7] ARM: kprobes: enable OPTPROBES for ARM 32
References: <1418020040-68977-1-git-send-email-wangnan0@huawei.com>	 <1418020131-69375-1-git-send-email-wangnan0@huawei.com> <1418036666.3647.33.camel@linaro.org>
In-Reply-To: <1418036666.3647.33.camel@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.69.90]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/12/8 19:04, Jon Medhurst (Tixy) wrote:
> On Mon, 2014-12-08 at 14:28 +0800, Wang Nan wrote:
>> This patch introduce kprobeopt for ARM 32.
>>
>> Limitations:
>>  - Currently only kernel compiled with ARM ISA is supported.
>>
>>  - Offset between probe point and optinsn slot must not larger than
>>    32MiB. Masami Hiramatsu suggests replacing 2 words, it will make
>>    things complex. Futher patch can make such optimization.
>>
>> Kprobe opt on ARM is relatively simpler than kprobe opt on x86 because
>> ARM instruction is always 4 bytes aligned and 4 bytes long. This patch
>> replace probed instruction by a 'b', branch to trampoline code and then
>> calls optimized_callback(). optimized_callback() calls opt_pre_handler()
>> to execute kprobe handler. It also emulate/simulate replaced instruction.
>>
>> When unregistering kprobe, the deferred manner of unoptimizer may leave
>> branch instruction before optimizer is called. Different from x86_64,
>> which only copy the probed insn after optprobe_template_end and
>> reexecute them, this patch call singlestep to emulate/simulate the insn
>> directly. Futher patch can optimize this behavior.
>>
>> Signed-off-by: Wang Nan <wangnan0@huawei.com>
>> Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
>> Cc: Jon Medhurst (Tixy) <tixy@linaro.org>
>> Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>
>> Cc: Will Deacon <will.deacon@arm.com>
>> ---
> [...]
>> v13 -> v14:
>>   - Use stop_machine to wrap arch_optimize_kprobes to avoid a racing.
> 
> Think we need to use stop_machine differently, see comments on code
> below.

Well, yes, I experienced one deadlock at serval minutes before.
I'm not very sure the reason and working on it now. I think it may caused
by recursivly stop_machine().

> 
>> ---
>>  arch/arm/Kconfig                        |   1 +
>>  arch/arm/{kernel => include/asm}/insn.h |   0
>>  arch/arm/include/asm/kprobes.h          |  29 +++
>>  arch/arm/kernel/Makefile                |   2 +-
>>  arch/arm/kernel/ftrace.c                |   3 +-
>>  arch/arm/kernel/jump_label.c            |   3 +-
>>  arch/arm/probes/kprobes/Makefile        |   1 +
>>  arch/arm/probes/kprobes/opt-arm.c       | 322 ++++++++++++++++++++++++++++++++
>>  samples/kprobes/kprobe_example.c        |   2 +-
> 
> The change kprobe_example.c doesn't apply and I guess wasn't meant to be
> included in the patch?
> 

Yes. These 2 lines are introduced by mistake.

> [...]
>> +/*
>> + * Similar to __arch_disarm_kprobe, operations which removing
>> + * breakpoints must be wrapped by stop_machine to avoid racing.
>> + */
>> +static __kprobes int __arch_optimize_kprobes(void *p)
>> +{
>> +	struct list_head *oplist = p;
>> +	struct optimized_kprobe *op, *tmp;
>> +
>> +	list_for_each_entry_safe(op, tmp, oplist, list) {
>> +		unsigned long insn;
>> +		WARN_ON(kprobe_disabled(&op->kp));
>> +
>> +		/*
>> +		 * Backup instructions which will be replaced
>> +		 * by jump address
>> +		 */
>> +		memcpy(op->optinsn.copied_insn, op->kp.addr,
>> +				RELATIVEJUMP_SIZE);
>> +
>> +		insn = arm_gen_branch((unsigned long)op->kp.addr,
>> +				(unsigned long)op->optinsn.insn);
>> +		BUG_ON(insn == 0);
>> +
>> +		/*
>> +		 * Make it a conditional branch if replaced insn
>> +		 * is consitional
>> +		 */
>> +		insn = (__mem_to_opcode_arm(
>> +			  op->optinsn.copied_insn[0]) & 0xf0000000) |
>> +			(insn & 0x0fffffff);
>> +
>> +		patch_text(op->kp.addr, insn);
> 
> patch_text() itself may use stop_machine under certain circumstances,
> and if it were to do so, I believe that would cause the system to
> lock/panic. So, this should be __patch_text() instead, but we would also
> need to take care of the cache_ops_need_broadcast() case, where all
> CPU's need to invalidate their own caches and we can't rely on just one
> CPU executing the code patching whilst other CPUs spin and wait. Though
> to make life easier, we could just not optimise kprobes in the legacy
> cache_ops_need_broadcast() case.
> 
>> +
>> +		list_del_init(&op->list);
>> +	}
>> +	return 0;
>> +}
>> +
>> +void arch_optimize_kprobes(struct list_head *oplist)
>> +{
>> +	stop_machine(__arch_optimize_kprobes, oplist, cpu_online_mask);
>> +}
> 
> I believe passing cpu_online_mask above will cause
> __arch_optimize_kprobes to be executed on every CPU, is this safe? If it
> is, it's a serendipitous optimisation if each CPU can process different
> probes in the list. If it's not safe, this needs to be NULL instead so
> only one CPU executes the code.
> 

This stop_machine() call is copied from arch_disarm_kprobe, I think their
senario should be similar.

> However, I wonder if optimising all probes under a single stop_machine
> call is the best thing to do because stop_machine does what it says and
> prevents everything else in the system from running, including interrupt
> handlers. Perhaps for system responsiveness this should be a single
> stop_machine per kprobe? Though of course that compounds the overhead of
> stop_machine use and puts another delay of one scheduler tick per probe.
> (stop_machine waits for the next tick to schedule the threads to perform
> the work which is why the test code takes so long to run).
>  
> What do people think?
> 


