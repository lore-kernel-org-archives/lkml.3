Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751780AbaL2ELm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 23:11:42 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:38298 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbaL2ELl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 23:11:41 -0500
Message-ID: <54A0D450.6060909@huawei.com>
Date: Mon, 29 Dec 2014 12:10:56 +0800
From: Wang Nan <wangnan0@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: <tixy@linaro.org>, <linux@arm.linux.org.uk>, <lizefan@huawei.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v17 11/11] ARM: optprobes: execute instruction during
 restoring if possible.
References: <1419665637-12744-1-git-send-email-wangnan0@huawei.com> <1419665760-13336-1-git-send-email-wangnan0@huawei.com> <54A07FBE.3010206@hitachi.com>
In-Reply-To: <54A07FBE.3010206@hitachi.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.69.90]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/12/29 6:10, Masami Hiramatsu wrote:
> (2014/12/27 16:36), Wang Nan wrote:
>> This patch removes software emulation or simulation for most of probed
>> instructions. If the instruction doesn't use PC relative addressing,
>> it will be translated into following instructions in the restore code
>> in code template:
>>
>>  ldmia {r0 - r14}  // restore all instruction except PC
>>  <instruction>     // direct execute the probed instruction
>>  b next_insn       // branch to next instruction.
>>
>> Signed-off-by: Wang Nan <wangnan0@huawei.com>
>> ---
>>  arch/arm/include/asm/kprobes.h    |  3 +++
>>  arch/arm/include/asm/probes.h     |  1 +
>>  arch/arm/probes/kprobes/opt-arm.c | 47 +++++++++++++++++++++++++++++++++++++--
>>  3 files changed, 49 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/arm/include/asm/kprobes.h b/arch/arm/include/asm/kprobes.h
>> index 50ff3bc..3ea9be5 100644
>> --- a/arch/arm/include/asm/kprobes.h
>> +++ b/arch/arm/include/asm/kprobes.h
>> @@ -57,6 +57,9 @@ extern __visible kprobe_opcode_t optprobe_template_call;
>>  extern __visible kprobe_opcode_t optprobe_template_end;
>>  extern __visible kprobe_opcode_t optprobe_template_sub_sp;
>>  extern __visible kprobe_opcode_t optprobe_template_add_sp;
>> +extern __visible kprobe_opcode_t optprobe_template_restore_begin;
>> +extern __visible kprobe_opcode_t optprobe_template_restore_orig_insn;
>> +extern __visible kprobe_opcode_t optprobe_template_restore_end;
>>  
>>  #define MAX_OPTIMIZED_LENGTH	4
>>  #define MAX_OPTINSN_SIZE				\
>> diff --git a/arch/arm/include/asm/probes.h b/arch/arm/include/asm/probes.h
>> index ee8725c..8ebbe83 100644
>> --- a/arch/arm/include/asm/probes.h
>> +++ b/arch/arm/include/asm/probes.h
>> @@ -50,6 +50,7 @@ struct arch_probes_insn {
>>  #define set_register_nouse(m, n)	__clear_register_flag(m, n, REG_NO_USE)
>>  #define set_register_use(m, n)	__set_register_flag(m, n, REG_USE)
>>  	int register_usage_mask;
>> +	bool kprobe_direct_exec;
>>  };
>>  
>>  #endif /* __ASSEMBLY__ */
>> diff --git a/arch/arm/probes/kprobes/opt-arm.c b/arch/arm/probes/kprobes/opt-arm.c
>> index 6a60df3..f3bd1cc 100644
>> --- a/arch/arm/probes/kprobes/opt-arm.c
>> +++ b/arch/arm/probes/kprobes/opt-arm.c
>> @@ -32,6 +32,13 @@
>>  #include "core.h"
>>  
>>  /*
>> + * See register_usage_mask. If the probed instruction doesn't use PC,
>> + * we can copy it into template and have it executed directly without
>> + * simulation or emulation.
>> + */
>> +#define can_kprobe_direct_exec(m)	(!((m) & 0xc0000000UL))
> 
> I think you'd better define a macro for this bitmask.
> 
> 
>> +
>> +/*
>>   * NOTE: the first sub and add instruction will be modified according
>>   * to the stack cost of the instruction.
>>   */
>> @@ -66,7 +73,15 @@ asm (
>>  			"	orrne	r2, #1\n"
>>  			"	strne	r2, [sp, #60] @ set bit0 of PC for thumb\n"
>>  			"	msr	cpsr_cxsf, r1\n"
>> +			".global optprobe_template_restore_begin\n"
>> +			"optprobe_template_restore_begin:\n"
>>  			"	ldmia	sp, {r0 - r15}\n"
>> +			".global optprobe_template_restore_orig_insn\n"
>> +			"optprobe_template_restore_orig_insn:\n"
>> +			"	nop\n"
>> +			".global optprobe_template_restore_end\n"
>> +			"optprobe_template_restore_end:\n"
>> +			"	ldmia	sp, {r13 - r15}\n"
> 
> Why this can't be a nop too?
> 
> Thank you,
> 

Good suggestion. I'll send a new version of patch 10 and 11.

Thank you.



