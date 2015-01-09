Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933393AbbAIKzb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 05:55:31 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:62948 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932338AbbAIKz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 05:55:27 -0500
Message-ID: <54AFB389.4030807@huawei.com>
Date: Fri, 9 Jan 2015 18:55:05 +0800
From: Wang Nan <wangnan0@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: "Jon Medhurst (Tixy)" <tixy@linaro.org>
CC: <masami.hiramatsu.pt@hitachi.com>, <linux@arm.linux.org.uk>,
        <lizefan@huawei.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v20 08/11] ARM: kprobes: enable OPTPROBES for ARM 32
References: <1420457376-77366-1-git-send-email-wangnan0@huawei.com>	 <1420785456-21900-1-git-send-email-wangnan0@huawei.com> <1420799154.4160.19.camel@linaro.org>
In-Reply-To: <1420799154.4160.19.camel@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.69.90]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015/1/9 18:25, Jon Medhurst (Tixy) wrote:
> On Fri, 2015-01-09 at 14:37 +0800, Wang Nan wrote:
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
>> Reviewed-by: Jon Medhurst (Tixy) <tixy@linaro.org>
>> Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>
>> Cc: Will Deacon <will.deacon@arm.com>
>> ---
> 
> [...]
> 
>> +asm (
>> +			".global optprobe_template_entry\n"
>> +			"optprobe_template_entry:\n"
>> +			".global optprobe_template_sub_sp\n"
>> +			"optprobe_template_sub_sp:"
>> +			"	sub	sp, sp, #0xff\n"
>> +			"	stmia	sp, {r0 - r14} \n"
>> +			".global optprobe_template_add_sp\n"
>> +			"optprobe_template_add_sp:"
>> +			"	add	r3, sp, #0xff\n"
>> +			"	str	r3, [sp, #52]\n"
>> +			"	mrs	r4, cpsr\n"
>> +			"	str	r4, [sp, #64]\n"
>> +			"	mov	r1, sp\n"
>> +			"	ldr	r0, 1f\n"
>> +			"	ldr	r2, 2f\n"
>> +			/*
>> +			 * AEABI requires an 8-bytes alignment stack. If
>> +			 * SP % 8 != 0 (SP % 4 == 0 should be ensured),
>> +			 * alloc more bytes here.
>> +			 */
>> +			"	and	r4, sp, #4\n"
>> +			"	sub	sp, sp, r4\n"
>> +#if __LINUX_ARM_ARCH__ >= 5
>> +			"	blx	r2\n"
>> +#else
>> +			"	mov     lr, pc\n"
>> +			"	bx	r2\n"
> 
> I think the BX instruction is not supported for ARMv4 chips that don't
> have Thumb support (e.g. SA110), at least an old ARM ARM I have says BX
> is supported on "Version 5 and above, and T variants of version 4".
> Though building assabet_defconfig with kprobes enabled doesn't produce
> an error for the BX instruction (!?)
> 
> To be safe I would be tempted to use "mov pc, r2" instead. Again, if you
> agree, I'll change this in the patch in the branch I'm putting together.
> 
> [...]
> 
Sure. I tested a function pointer calling and found that gcc generates
'mov pc, r2', and there is no need for ISA switching.

