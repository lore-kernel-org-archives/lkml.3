Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947AbaLCDXK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 22:23:10 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:33821 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215AbaLCDXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 22:23:08 -0500
Message-ID: <547E81F8.3000701@huawei.com>
Date: Wed, 3 Dec 2014 11:22:32 +0800
From: Wang Nan <wangnan0@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: "Jon Medhurst (Tixy)" <tixy@linaro.org>
CC: <masami.hiramatsu.pt@hitachi.com>, <linux@arm.linux.org.uk>,
        <lizefan@huawei.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v11 7/7] ARM: kprobes: enable OPTPROBES for ARM 32
References: <1417423513-47161-1-git-send-email-wangnan0@huawei.com>	 <1417423751-47872-1-git-send-email-wangnan0@huawei.com> <1417545498.2430.10.camel@linaro.org>
In-Reply-To: <1417545498.2430.10.camel@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.69.90]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/12/3 2:38, Jon Medhurst (Tixy) wrote:
> On Mon, 2014-12-01 at 16:49 +0800, Wang Nan wrote:
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
>>
>> ---
>>
> [...]
> 
>> v10 -> v11:
>>   - Move to arch/arm/probes/, insn.h is moved to arch/arm/include/asm.
>>   - Code cleanup.
>>   - Bugfix based on Tixy's test result:
>>     - Trampoline deal with ARM -> Thumb transision instructions and
>>       AEABI stack alignment requirement correctly.
>>     - Trampoline code buffer should start at 4 byte aligned address.
>>       We enforces it in this series by using macro to wrap 'code' var.
> 
> I'm wondering if this alignment is needed. I'm not familiar with the
> Linux memory code but following it through...
> 
> - kernel/kprobes.c allocates memory for the instruction slots using
> module_alloc()
> 
> - module_alloc calls __vmalloc_node_range and passes in an alignment of
> 1 byte however...
> 
> - __vmalloc_node_range has the comment "Allocate enough pages to cover
> @size from the page level allocator". And it rounds size up to one page
> and calls  __get_vm_area_node which also makes sure the size is page
> aligned and also allocates a guard page afterwards.
> 
> So it looks to me as though allocated memory would always be page
> aligned.
> 
> Another reason why I think this must be true is that module_alloc seems
> to be used to allocate memory for loading modules to (see move_module in
> kernel/module.c) and that code doesn't seem to align things.
> 
> Though, as I already said, I'm not familiar with this code so could well
> have missed something. And the thing that is giving me most worries is
> that all the vmalloc code takes an alignment value in bytes.
> 
> Anyway, I'll comment on this patch on the assumption that alignment is
> needed...
> 

Thanks for your comments.

By checking code in mm/vmalloc.c I find that, although the algorithm it uses is possible
to get unaligned addresses, all users of alloc_vmap_area() allocate full pages, and
no-page-aligned allocation is forbidden from the first version on that functon.
Therefore, alignment requirements less than PAGE_SIZE is actually meanless.
Although module_alloc() requires only 1-byte alignment, it will get a page aligned address.

It is true for all architectures except cris, on which use module_alloc() simple kmalloc()
However, it doesn't support kprobes so we don't need to care about it.

I'll remove the alignment tricks in the next version of code.

> [...]

>> +			/*
>> +			 * AEABI require a 8-bytes alignment stack. If
>> +			 * SP % 8 == 4, we alloc another 4 bytes here.
>> +			 */
>> +			"	tst	sp, #4\n"
>> +			"	subne	sp, #4\n"
>> +			"	blx	r2\n"
>> +
>> +			/*
>> +			 * Here is a trick: the called handler should
>> +			 * return its second param by r0, which is
>> +			 * happens to be SP before the above AEABI
>> +			 * adjustment. Therefore, we don't need to save
>> +			 * and check whether we have done the above
>> +			 * adjustment. See optimized_callback().
>> +			 */
>> +			"	mov	sp, r0\n"
> 
> I think this trick is a bit too tricky :-) and might cause unnecessary
> problems for someone in the future. How about replacing the above 4
> instruction with these 4 instead...
> 
> 			"	and	r4, sp, #4\n"
> 			"	sub	sp, sp, r4\n"
> 			"	blx	r2\n"
> 			"	add	sp, sp, r4\n"
> 
> and that actually makes things slightly faster as optimized_callback no
> longer needs to return a value.
> 

Your code is better. AAPCS requires subroutines must preserve the contents of
the registers r4-r8, r10-r11, so we can use them freely in our asm code.

> 
>> +			"	ldr	r1, [sp, #64]\n"
>> +			"	tst	r1, #"__stringify(PSR_T_BIT)"\n"
>> +			"	ldrne	r2, [sp, #60]\n"
>> +			"	orrne	r2, #1\n"
>> +			"	strne	r2, [sp, #60] @ set bit0 of PC for thumb\n"
>> +			"	msr	cpsr_cxsf, r1\n"
>> +			"	ldmia	sp, {r0 - r15}\n"
>> +			".global optprobe_template_val\n"
>> +			"optprobe_template_val:\n"
>> +			"1:	.long 0\n"
>> +			".global optprobe_template_call\n"
>> +			"optprobe_template_call:\n"
>> +			"2:	.long 0\n"
>> +			".global optprobe_template_end\n"
>> +			"optprobe_template_end:\n");
>> +
> 
> [...]
> 
>> +int arch_prepare_optimized_kprobe(struct optimized_kprobe *op, struct kprobe *orig)
>> +{
>> +	kprobe_opcode_t *code_unaligned;
> 
> kprobe_opcode_t is a u32 and the ABI and compiler expect this to be
> aligned, so best use a void * instead.
>

It is the return value of get_optinsn_slot() and should be that type. However
I'll remove these unaligned things.

[...]

