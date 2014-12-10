Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978AbaLJNUU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 08:20:20 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:18463 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753728AbaLJNUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 08:20:18 -0500
Message-ID: <5488483D.1080900@huawei.com>
Date: Wed, 10 Dec 2014 21:18:53 +0800
From: Wang Nan <wangnan0@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: "Jon Medhurst (Tixy)" <tixy@linaro.org>
CC: <masami.hiramatsu.pt@hitachi.com>, <lizefan@huawei.com>,
        <linux@arm.linux.org.uk>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3] ARM: kprobes: Add test cases for stack consuming instructions
References: <1418047765-53197-1-git-send-email-wangnan0@huawei.com>		 <1418047765-53197-6-git-send-email-wangnan0@huawei.com>		 <1418143407.3641.47.camel@linaro.org>	 <1418145071.3641.60.camel@linaro.org> <54880309.3010100@huawei.com> <1418214862.3661.17.camel@linaro.org>
In-Reply-To: <1418214862.3661.17.camel@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.69.90]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/12/10 20:34, Jon Medhurst (Tixy) wrote:
> On Wed, 2014-12-10 at 16:23 +0800, Wang Nan wrote:
>> Hi Tixy,
>>
>> I experienced another FAIL during test:
>>
>> [11567.220477] Miscellaneous instructions
>> [11567.265397] ---------------------------------------------------------
>> [11567.342626] mrs	r0, cpsr	@ e10f0000
>> [11568.612656] FAIL: registers differ
>> [11568.653414] FAIL: Test mrs	r0, cpsr
>> [11568.695210] FAIL: Scenario 5
>> [11568.729709] initial_regs:
>> [11568.761083] r0  21522152 | r1  21522052 | r2  21522352 | r3  21522252
>> [11568.838301] r4  21522552 | r5  21522452 | r6  21522752 | r7  21522652
>> [11568.915526] r8  21522952 | r9  21522852 | r10 21522b52 | r11 21522a52
>> [11568.992748] r12 21522d52 | sp  ed343cf0 | lr  21522f52 | pc  bf11f590
>> [11569.069969] cpsr 58050013
>> [11569.101336] expected_regs:
>> [11569.133750] r0  58050013 | r1  21522052 | r2  21522352 | r3  21522252
>> [11569.210975] r4  21522552 | r5  21522452 | r6  21522752 | r7  21522652
>> [11569.288197] r8  21522952 | r9  21522852 | r10 21522b52 | r11 21522a52
>> [11569.365417] r12 21522d52 | sp  ed343cf0 | lr  21522f52 | pc  bf11f594
>> [11569.442634] cpsr 58050013
>> [11569.474010] result_regs:
>> [11569.504337] r0  58050113 | r1  21522052 | r2  21522352 | r3  21522252     <--- see R0 in this line
>> [11569.581556] r4  21522552 | r5  21522452 | r6  21522752 | r7  21522652
>> [11569.658776] r8  21522952 | r9  21522852 | r10 21522b52 | r11 21522a52
>> [11569.736000] r12 21522d52 | sp  ed343cf0 | lr  21522f52 | pc  bf11f594
>> [11569.813222] cpsr 58050013
>> [11569.844593] mrspl	r7, cpsr	@ 510f7000
>> [11571.842652] mrs	r14, cpsr	@ e10fe000
>>
>> The failure is raise when testing in "mrs r0, cpsr". The added bit is PSR_A_BIT, which
>> should be ignored.
>>
>> So looks like this is also a problem in your test framework. If you don't have
>> enough time, you can give me some hints to deal with it.
> 
> The problem is that the A bit can change randomly when interrupts or
> reschedules happen (I'm not sure it should, and it may be a bug). For
> the purposes of this test code, we can't disable interrupts and
> scheduling around all the iterations of a test case, because inserting
> and removing probes requires them to be enabled. So we need a method of
> ignoring bits in cpsr, how about the following patch...
> 
> ----------------------------------------------------------------------------
> 
> From: Jon Medhurst <tixy@linaro.org>
> Subject: [PATCH] ARM: kprobes: Fix unreliable MRS instruction tests
> 
> For the instruction 'mrs Rn, cpsr' the resulting value of Rn can vary due to
> external factors we can't control. So get the test code to mask out these
> indeterminate bits.
> 
> Signed-off-by: Jon Medhurst <tixy@linaro.org>
> ---
>  arch/arm/probes/kprobes/test-arm.c   |  6 +++---
>  arch/arm/probes/kprobes/test-core.c  | 19 ++++++++++---------
>  arch/arm/probes/kprobes/test-core.h  | 33 ++++++++++++++++++++++++++++-----
>  arch/arm/probes/kprobes/test-thumb.c |  4 ++--
>  4 files changed, 43 insertions(+), 19 deletions(-)
> 
> diff --git a/arch/arm/probes/kprobes/test-arm.c b/arch/arm/probes/kprobes/test-arm.c
> index 9b3b1b4..e72b07e 100644
> --- a/arch/arm/probes/kprobes/test-arm.c
> +++ b/arch/arm/probes/kprobes/test-arm.c
> @@ -204,9 +204,9 @@ void kprobe_arm_test_cases(void)
>  #endif
>  	TEST_GROUP("Miscellaneous instructions")
>  
> -	TEST("mrs	r0, cpsr")
> -	TEST("mrspl	r7, cpsr")
> -	TEST("mrs	r14, cpsr")
> +	TEST_RMASKED("mrs	r",0,~PSR_IGNORE_BITS,", cpsr")
> +	TEST_RMASKED("mrspl	r",7,~PSR_IGNORE_BITS,", cpsr")
> +	TEST_RMASKED("mrs	r",14,~PSR_IGNORE_BITS,", cpsr")
>  	TEST_UNSUPPORTED(__inst_arm(0xe10ff000) "	@ mrs r15, cpsr")
>  	TEST_UNSUPPORTED("mrs	r0, spsr")
>  	TEST_UNSUPPORTED("mrs	lr, spsr")
> diff --git a/arch/arm/probes/kprobes/test-core.c b/arch/arm/probes/kprobes/test-core.c
> index 7c5ddd5..e495127 100644
> --- a/arch/arm/probes/kprobes/test-core.c
> +++ b/arch/arm/probes/kprobes/test-core.c
> @@ -1056,15 +1056,6 @@ static int test_case_run_count;
>  static bool test_case_is_thumb;
>  static int test_instance;
>  
> -/*
> - * We ignore the state of the imprecise abort disable flag (CPSR.A) because this
> - * can change randomly as the kernel doesn't take care to preserve or initialise
> - * this across context switches. Also, with Security Extentions, the flag may
> - * not be under control of the kernel; for this reason we ignore the state of
> - * the FIQ disable flag CPSR.F as well.
> - */
> -#define PSR_IGNORE_BITS (PSR_A_BIT | PSR_F_BIT)
> -
>  static unsigned long test_check_cc(int cc, unsigned long cpsr)
>  {
>  	int ret = arm_check_condition(cc << 28, cpsr);
> @@ -1271,11 +1262,21 @@ test_case_pre_handler(struct kprobe *p, struct pt_regs *regs)
>  static int __kprobes
>  test_after_pre_handler(struct kprobe *p, struct pt_regs *regs)
>  {
> +	struct test_arg *args;
> +
>  	if (container_of(p, struct test_probe, kprobe)->hit == test_instance)
>  		return 0; /* Already run for this test instance */
>  
>  	result_regs = *regs;
> +
> +	/* Mask out results which are indeterminate */
>  	result_regs.ARM_cpsr &= ~PSR_IGNORE_BITS;
> +	for (args = current_args; args[0].type != ARG_TYPE_END; ++args)
> +		if (args[0].type == ARG_TYPE_REG_MASKED) {
> +			struct test_arg_regptr *arg =
> +				(struct test_arg_regptr *)args;
> +			result_regs.uregs[arg->reg] &= arg->val;
> +		}
>  
>  	/* Undo any changes done to SP by the test case */
>  	regs->ARM_sp = (unsigned long)current_stack;
> diff --git a/arch/arm/probes/kprobes/test-core.h b/arch/arm/probes/kprobes/test-core.h
> index 9991754..32f7aa7 100644
> --- a/arch/arm/probes/kprobes/test-core.h
> +++ b/arch/arm/probes/kprobes/test-core.h
> @@ -45,10 +45,11 @@ extern int kprobe_test_cc_position;
>   *
>   */
>  
> -#define	ARG_TYPE_END	0
> -#define	ARG_TYPE_REG	1
> -#define	ARG_TYPE_PTR	2
> -#define	ARG_TYPE_MEM	3
> +#define	ARG_TYPE_END		0
> +#define	ARG_TYPE_REG		1
> +#define	ARG_TYPE_PTR		2
> +#define	ARG_TYPE_MEM		3
> +#define	ARG_TYPE_REG_MASKED	4
>  
>  #define ARG_FLAG_UNSUPPORTED	0x01
>  #define ARG_FLAG_SUPPORTED	0x02
> @@ -61,7 +62,7 @@ struct test_arg {
>  };
>  
>  struct test_arg_regptr {
> -	u8	type;		/* ARG_TYPE_REG or ARG_TYPE_PTR */
> +	u8	type;		/* ARG_TYPE_REG or ARG_TYPE_PTR or ARG_TYPE_REG_MASKED */
>  	u8	reg;
>  	u8	_padding[2];
>  	u32	val;
> @@ -138,6 +139,12 @@ struct test_arg_end {
>  	".short	0					\n\t"	\
>  	".word	"#val"					\n\t"
>  
> +#define	TEST_ARG_REG_MASKED(reg, val)				\
> +	".byte	"__stringify(ARG_TYPE_REG_MASKED)"	\n\t"	\
> +	".byte	"#reg"					\n\t"	\
> +	".short	0					\n\t"	\
> +	".word	"#val"					\n\t"
> +
>  #define	TEST_ARG_END(flags)					\
>  	".byte	"__stringify(ARG_TYPE_END)"		\n\t"	\
>  	".byte	"TEST_ISA flags"			\n\t"	\
> @@ -395,6 +402,22 @@ struct test_arg_end {
>  	"	"codex"			\n\t"					\
>  	TESTCASE_END
>  
> +#define TEST_RMASKED(code1, reg, mask, code2)		\
> +	TESTCASE_START(code1 #reg code2)		\
> +	TEST_ARG_REG_MASKED(reg, mask)			\
> +	TEST_ARG_END("")				\
> +	TEST_INSTRUCTION(code1 #reg code2)		\
> +	TESTCASE_END
> +
> +/*
> + * We ignore the state of the imprecise abort disable flag (CPSR.A) because this
> + * can change randomly as the kernel doesn't take care to preserve or initialise
> + * this across context switches. Also, with Security Extensions, the flag may
> + * not be under control of the kernel; for this reason we ignore the state of
> + * the FIQ disable flag CPSR.F as well.
> + */
> +#define PSR_IGNORE_BITS (PSR_A_BIT | PSR_F_BIT)
> +
>  
>  /*
>   * Macros for defining space directives spread over multiple lines.
> diff --git a/arch/arm/probes/kprobes/test-thumb.c b/arch/arm/probes/kprobes/test-thumb.c
> index e8cf193..b683b45 100644
> --- a/arch/arm/probes/kprobes/test-thumb.c
> +++ b/arch/arm/probes/kprobes/test-thumb.c
> @@ -778,8 +778,8 @@ CONDITION_INSTRUCTIONS(22,
>  
>  	TEST_UNSUPPORTED("subs	pc, lr, #4")
>  
> -	TEST("mrs	r0, cpsr")
> -	TEST("mrs	r14, cpsr")
> +	TEST_RMASKED("mrs	r",0,~PSR_IGNORE_BITS,", cpsr")
> +	TEST_RMASKED("mrs	r",14,~PSR_IGNORE_BITS,", cpsr")
>  	TEST_UNSUPPORTED(__inst_thumb32(0xf3ef8d00) "	@ mrs	sp, spsr")
>  	TEST_UNSUPPORTED(__inst_thumb32(0xf3ef8f00) "	@ mrs	pc, spsr")
>  	TEST_UNSUPPORTED("mrs	r0, spsr")
> 

Well, I'm just working on a patch which introducing a TEST_INTOFF and disable interrupts
for "MRS" testcase. Do you think it is inappropriate? I'll use your patch test for a night
in my hardware, and will let you know the result tomorrow.

Thank you!

