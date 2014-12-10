Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989AbaLJIYy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 03:24:54 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:28974 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708AbaLJIYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 03:24:53 -0500
Message-ID: <54880309.3010100@huawei.com>
Date: Wed, 10 Dec 2014 16:23:37 +0800
From: Wang Nan <wangnan0@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: "Jon Medhurst (Tixy)" <tixy@linaro.org>
CC: <masami.hiramatsu.pt@hitachi.com>, <lizefan@huawei.com>,
        <linux@arm.linux.org.uk>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3] ARM: kprobes: Add test cases for stack consuming instructions
References: <1418047765-53197-1-git-send-email-wangnan0@huawei.com>	 <1418047765-53197-6-git-send-email-wangnan0@huawei.com>	 <1418143407.3641.47.camel@linaro.org> <1418145071.3641.60.camel@linaro.org>
In-Reply-To: <1418145071.3641.60.camel@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.69.90]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tixy,

I experienced another FAIL during test:

[11567.220477] Miscellaneous instructions
[11567.265397] ---------------------------------------------------------
[11567.342626] mrs	r0, cpsr	@ e10f0000
[11568.612656] FAIL: registers differ
[11568.653414] FAIL: Test mrs	r0, cpsr
[11568.695210] FAIL: Scenario 5
[11568.729709] initial_regs:
[11568.761083] r0  21522152 | r1  21522052 | r2  21522352 | r3  21522252
[11568.838301] r4  21522552 | r5  21522452 | r6  21522752 | r7  21522652
[11568.915526] r8  21522952 | r9  21522852 | r10 21522b52 | r11 21522a52
[11568.992748] r12 21522d52 | sp  ed343cf0 | lr  21522f52 | pc  bf11f590
[11569.069969] cpsr 58050013
[11569.101336] expected_regs:
[11569.133750] r0  58050013 | r1  21522052 | r2  21522352 | r3  21522252
[11569.210975] r4  21522552 | r5  21522452 | r6  21522752 | r7  21522652
[11569.288197] r8  21522952 | r9  21522852 | r10 21522b52 | r11 21522a52
[11569.365417] r12 21522d52 | sp  ed343cf0 | lr  21522f52 | pc  bf11f594
[11569.442634] cpsr 58050013
[11569.474010] result_regs:
[11569.504337] r0  58050113 | r1  21522052 | r2  21522352 | r3  21522252     <--- see R0 in this line
[11569.581556] r4  21522552 | r5  21522452 | r6  21522752 | r7  21522652
[11569.658776] r8  21522952 | r9  21522852 | r10 21522b52 | r11 21522a52
[11569.736000] r12 21522d52 | sp  ed343cf0 | lr  21522f52 | pc  bf11f594
[11569.813222] cpsr 58050013
[11569.844593] mrspl	r7, cpsr	@ 510f7000
[11571.842652] mrs	r14, cpsr	@ e10fe000

The failure is raise when testing in "mrs r0, cpsr". The added bit is PSR_A_BIT, which
should be ignored.

So looks like this is also a problem in your test framework. If you don't have
enough time, you can give me some hints to deal with it.

On 2014/12/10 1:11, Jon Medhurst (Tixy) wrote:
> These have extra 'checker' functions associated with them so lets make
> sure those get covered by testing. As they may create uninitialised
> space on the stack we also update the test code to ensure such space is
> consistent between test runs. This is done by disabling interrupts in
> setup_test_context().
> 
> Signed-off-by: Jon Medhurst <tixy@linaro.org>
> ---
> 
> Sorry for the extra noise, sent this new version to correct whitespace
> and spelling errors in previous one.
> 
>  arch/arm/probes/kprobes/test-arm.c   | 17 +++++++++++++++--
>  arch/arm/probes/kprobes/test-core.c  |  9 +++++++++
>  arch/arm/probes/kprobes/test-thumb.c | 12 ++++++++++++
>  3 files changed, 36 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/probes/kprobes/test-arm.c b/arch/arm/probes/kprobes/test-arm.c
> index fdeb300..9b3b1b4 100644
> --- a/arch/arm/probes/kprobes/test-arm.c
> +++ b/arch/arm/probes/kprobes/test-arm.c
> @@ -12,6 +12,7 @@
>  #include <linux/module.h>
>  #include <asm/system_info.h>
>  #include <asm/opcodes.h>
> +#include <asm/probes.h>
>  
>  #include "test-core.h"
>  
> @@ -478,6 +479,7 @@ void kprobe_arm_test_cases(void)
>  	TEST_RPR(  "strh	r",0, VAL1,", [r",1, 48,", -r",2, 24,"]")
>  	TEST_RPR(  "streqh	r",14,VAL2,", [r",11,0, ", r",12, 48,"]")
>  	TEST_UNSUPPORTED(  "streqh	r14, [r13, r12]")
> +	TEST_UNSUPPORTED(  "streqh	r14, [r12, r13]")
>  	TEST_RPR(  "strh	r",1, VAL1,", [r",2, 24,", r",3,  48,"]!")
>  	TEST_RPR(  "strneh	r",12,VAL2,", [r",11,48,", -r",10,24,"]!")
>  	TEST_RPR(  "strh	r",2, VAL1,", [r",3, 24,"], r",4, 48,"")
> @@ -502,6 +504,9 @@ void kprobe_arm_test_cases(void)
>  	TEST_RP(   "strplh	r",12,VAL2,", [r",11,24,", #-4]!")
>  	TEST_RP(   "strh	r",2, VAL1,", [r",3, 24,"], #48")
>  	TEST_RP(   "strh	r",10,VAL2,", [r",9, 64,"], #-48")
> +	TEST_RP(   "strh	r",3, VAL1,", [r",13,TEST_MEMORY_SIZE,", #-"__stringify(MAX_STACK_SIZE)"]!")
> +	TEST_UNSUPPORTED("strh r3, [r13, #-"__stringify(MAX_STACK_SIZE)"-8]!")
> +	TEST_RP(   "strh	r",4, VAL1,", [r",14,TEST_MEMORY_SIZE,", #-"__stringify(MAX_STACK_SIZE)"-8]!")
>  	TEST_UNSUPPORTED(__inst_arm(0xe1efc3b0) "	@ strh r12, [pc, #48]!")
>  	TEST_UNSUPPORTED(__inst_arm(0xe0c9f3b0) "	@ strh pc, [r9], #48")
>  
> @@ -568,6 +573,7 @@ void kprobe_arm_test_cases(void)
>  	TEST_RPR(  "strd	r",0, VAL1,", [r",1, 48,", -r",2,24,"]")
>  	TEST_RPR(  "strccd	r",8, VAL2,", [r",11,0, ", r",12,48,"]")
>  	TEST_UNSUPPORTED(  "strccd r8, [r13, r12]")
> +	TEST_UNSUPPORTED(  "strccd r8, [r12, r13]")
>  	TEST_RPR(  "strd	r",4, VAL1,", [r",2, 24,", r",3, 48,"]!")
>  	TEST_RPR(  "strcsd	r",12,VAL2,", [r",11,48,", -r",10,24,"]!")
>  	TEST_RPR(  "strd	r",2, VAL1,", [r",5, 24,"], r",4,48,"")
> @@ -591,6 +597,9 @@ void kprobe_arm_test_cases(void)
>  	TEST_RP(   "strvcd	r",12,VAL2,", [r",11,24,", #-16]!")
>  	TEST_RP(   "strd	r",2, VAL1,", [r",4, 24,"], #48")
>  	TEST_RP(   "strd	r",10,VAL2,", [r",9, 64,"], #-48")
> +	TEST_RP(   "strd	r",6, VAL1,", [r",13,TEST_MEMORY_SIZE,", #-"__stringify(MAX_STACK_SIZE)"]!")
> +	TEST_UNSUPPORTED("strd r6, [r13, #-"__stringify(MAX_STACK_SIZE)"-8]!")
> +	TEST_RP(   "strd	r",4, VAL1,", [r",12,TEST_MEMORY_SIZE,", #-"__stringify(MAX_STACK_SIZE)"-8]!")
>  	TEST_UNSUPPORTED(__inst_arm(0xe1efc3f0) "	@ strd r12, [pc, #48]!")
>  
>  	TEST_P(	   "ldrd	r0, [r",0, 24,", #-8]")
> @@ -639,16 +648,20 @@ void kprobe_arm_test_cases(void)
>  	TEST_RP( "str"byte"	r",12,VAL2,", [r",11,24,", #-4]!")		\
>  	TEST_RP( "str"byte"	r",2, VAL1,", [r",3, 24,"], #48")		\
>  	TEST_RP( "str"byte"	r",10,VAL2,", [r",9, 64,"], #-48")		\
> +	TEST_RP( "str"byte"	r",3, VAL1,", [r",13,TEST_MEMORY_SIZE,", #-"__stringify(MAX_STACK_SIZE)"]!") \
> +	TEST_UNSUPPORTED("str"byte" r3, [r13, #-"__stringify(MAX_STACK_SIZE)"-8]!")				\
> +	TEST_RP( "str"byte"	r",4, VAL1,", [r",10,TEST_MEMORY_SIZE,", #-"__stringify(MAX_STACK_SIZE)"-8]!") \
>  	TEST_RPR("str"byte"	r",0, VAL1,", [r",1, 48,", -r",2, 24,"]")	\
>  	TEST_RPR("str"byte"	r",14,VAL2,", [r",11,0, ", r",12, 48,"]")	\
> -	TEST_UNSUPPORTED("str"byte" r14, [r13, r12]")	\
> +	TEST_UNSUPPORTED("str"byte" r14, [r13, r12]")				\
> +	TEST_UNSUPPORTED("str"byte" r14, [r12, r13]")				\
>  	TEST_RPR("str"byte"	r",1, VAL1,", [r",2, 24,", r",3,  48,"]!")	\
>  	TEST_RPR("str"byte"	r",12,VAL2,", [r",11,48,", -r",10,24,"]!")	\
>  	TEST_RPR("str"byte"	r",2, VAL1,", [r",3, 24,"], r",4, 48,"")	\
>  	TEST_RPR("str"byte"	r",10,VAL2,", [r",9, 48,"], -r",11,24,"")	\
>  	TEST_RPR("str"byte"	r",0, VAL1,", [r",1, 24,", r",2,  32,", asl #1]")\
>  	TEST_RPR("str"byte"	r",14,VAL2,", [r",11,0, ", r",12, 32,", lsr #2]")\
> -	TEST_UNSUPPORTED("str"byte"	r14, [r13, r12, lsr #2]")\
> +	TEST_UNSUPPORTED("str"byte"	r14, [r13, r12, lsr #2]")		\
>  	TEST_RPR("str"byte"	r",1, VAL1,", [r",2, 24,", r",3,  32,", asr #3]!")\
>  	TEST_RPR("str"byte"	r",12,VAL2,", [r",11,24,", r",10, 4,", ror #31]!")\
>  	TEST_P(  "ldr"byte"	r0, [r",0,  24,", #-2]")			\
> diff --git a/arch/arm/probes/kprobes/test-core.c b/arch/arm/probes/kprobes/test-core.c
> index 7ab633d..7c5ddd5 100644
> --- a/arch/arm/probes/kprobes/test-core.c
> +++ b/arch/arm/probes/kprobes/test-core.c
> @@ -1196,6 +1196,13 @@ static void setup_test_context(struct pt_regs *regs)
>  			regs->uregs[arg->reg] =
>  				(unsigned long)current_stack + arg->val;
>  			memory_needs_checking = true;
> +			/*
> +			 * Test memory at an address below SP is in danger of
> +			 * being altered by an interrupt occurring and pushing
> +			 * data onto the stack. Disable interrupts to stop this.
> +			 */
> +			if (arg->reg == 13)
> +				regs->ARM_cpsr |= PSR_I_BIT;
>  			break;
>  		}
>  		case ARG_TYPE_MEM: {
> @@ -1272,6 +1279,8 @@ test_after_pre_handler(struct kprobe *p, struct pt_regs *regs)
>  
>  	/* Undo any changes done to SP by the test case */
>  	regs->ARM_sp = (unsigned long)current_stack;
> +	/* Enable interrupts in case setup_test_context disabled them */
> +	regs->ARM_cpsr &= ~PSR_I_BIT;
>  
>  	container_of(p, struct test_probe, kprobe)->hit = test_instance;
>  	return 0;
> diff --git a/arch/arm/probes/kprobes/test-thumb.c b/arch/arm/probes/kprobes/test-thumb.c
> index 6c6e9a9..e8cf193 100644
> --- a/arch/arm/probes/kprobes/test-thumb.c
> +++ b/arch/arm/probes/kprobes/test-thumb.c
> @@ -11,6 +11,7 @@
>  #include <linux/kernel.h>
>  #include <linux/module.h>
>  #include <asm/opcodes.h>
> +#include <asm/probes.h>
>  
>  #include "test-core.h"
>  
> @@ -416,6 +417,9 @@ void kprobe_thumb32_test_cases(void)
>  	TEST_RR( "strd	r",14,VAL2,", r",12,VAL1,", [sp, #16]!")
>  	TEST_RRP("strd	r",1, VAL1,", r",0, VAL2,", [r",7, 24,"], #16")
>  	TEST_RR( "strd	r",7, VAL2,", r",8, VAL1,", [sp], #-16")
> +	TEST_RRP("strd	r",6, VAL1,", r",7, VAL2,", [r",13, TEST_MEMORY_SIZE,", #-"__stringify(MAX_STACK_SIZE)"]!")
> +	TEST_UNSUPPORTED("strd r6, r7, [r13, #-"__stringify(MAX_STACK_SIZE)"-8]!")
> +	TEST_RRP("strd	r",4, VAL1,", r",5, VAL2,", [r",14, TEST_MEMORY_SIZE,", #-"__stringify(MAX_STACK_SIZE)"-8]!")
>  	TEST_UNSUPPORTED(__inst_thumb32(0xe9efec04) "	@ strd	r14, r12, [pc, #16]!")
>  	TEST_UNSUPPORTED(__inst_thumb32(0xe8efec04) "	@ strd	r14, r12, [pc], #16")
>  
> @@ -821,14 +825,22 @@ CONDITION_INSTRUCTIONS(22,
>  	TEST_RP( "str"size"	r",14,VAL2,", [r",1, 256,  ", #-128]!")		\
>  	TEST_RPR("str"size".w	r",0, VAL1,", [r",1, 0,", r",2, 4,"]")		\
>  	TEST_RPR("str"size"	r",14,VAL2,", [r",10,0,", r",11,4,", lsl #1]")	\
> +	TEST_UNSUPPORTED("str"size"	r0, [r13, r1]")				\
>  	TEST_R(  "str"size".w	r",7, VAL1,", [sp, #24]")			\
>  	TEST_RP( "str"size".w	r",0, VAL2,", [r",0,0, "]")			\
> +	TEST_RP( "str"size"	r",6, VAL1,", [r",13, TEST_MEMORY_SIZE,", #-"__stringify(MAX_STACK_SIZE)"]!") \
> +	TEST_UNSUPPORTED("str"size"	r6, [r13, #-"__stringify(MAX_STACK_SIZE)"-8]!")			\
> +	TEST_RP( "str"size"	r",4, VAL2,", [r",12, TEST_MEMORY_SIZE,", #-"__stringify(MAX_STACK_SIZE)"-8]!") \
>  	TEST_UNSUPPORTED("str"size"t	r0, [r1, #4]")
>  
>  	SINGLE_STORE("b")
>  	SINGLE_STORE("h")
>  	SINGLE_STORE("")
>  
> +	TEST_UNSUPPORTED(__inst_thumb32(0xf801000d) "	@ strb	r0, [r1, r13]")
> +	TEST_UNSUPPORTED(__inst_thumb32(0xf821000d) "	@ strh	r0, [r1, r13]")
> +	TEST_UNSUPPORTED(__inst_thumb32(0xf841000d) "	@ str	r0, [r1, r13]")
> +
>  	TEST("str	sp, [sp]")
>  	TEST_UNSUPPORTED(__inst_thumb32(0xf8cfe000) "	@ str	r14, [pc]")
>  	TEST_UNSUPPORTED(__inst_thumb32(0xf8cef000) "	@ str	pc, [r14]")
> 


