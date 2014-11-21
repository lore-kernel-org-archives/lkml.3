Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751300AbaKUSAX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 13:00:23 -0500
Received: from smarthost01c.mail.zen.net.uk ([212.23.1.5]:53697 "EHLO
	smarthost01c.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751097AbaKUSAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 13:00:18 -0500
Message-ID: <1416592797.1827.8.camel@linaro.org>
Subject: Re: [PATCH v3 3/3] ARM: kprobes: disallow probing stack consuming
 instructions
From: "Jon Medhurst (Tixy)" <tixy@linaro.org>
To: Wang Nan <wangnan0@huawei.com>
Cc: masami.hiramatsu.pt@hitachi.com, linux@arm.linux.org.uk,
        will.deacon@arm.com, taras.kondratiuk@linaro.org,
        ben.dooks@codethink.co.uk, cl@linux.com, rabin@rab.in,
        davem@davemloft.net, lizefan@huawei.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Date: Fri, 21 Nov 2014 17:59:57 +0000
In-Reply-To: <1416551731-50777-4-git-send-email-wangnan0@huawei.com>
References: <1416551731-50777-1-git-send-email-wangnan0@huawei.com>
	 <1416551731-50777-4-git-send-email-wangnan0@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-smarthost01c-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-11-21 at 14:35 +0800, Wang Nan wrote:
> This patch prohibit probing instructions for which the stack

Needs an 's' on the end of 'prohibit'

> requirement are unable to be determined statically. Some test cases

and another 's' on the end of 'requirement'

> are found not work again after the modification, this patch also
> removes them.
> 
> Signed-off-by: Wang Nan <wangnan0@huawei.com>

Reviewed-by: Jon Medhurst <tixy@linaro.org>

I think we also need to add new test cases to cover the stack store
instructions. I have already produced these (which is how I found the
Thumb decoding bugs) so I will follow up with a separate patch with
those. It would be good if you could that it to the end of your series.

Thanks

-- 
Tixy

> ---
> 
> v1 -> v2:
>  - Use MAX_STACK_SIZE macro instead of hard coded stack size.
> 
> v2 -> v3:
>  - Commit message improvements.
> ---
>  arch/arm/include/asm/kprobes.h     |  1 -
>  arch/arm/include/asm/probes.h      | 12 ++++++++++++
>  arch/arm/kernel/entry-armv.S       |  3 ++-
>  arch/arm/kernel/kprobes-test-arm.c | 16 ++++++++++------
>  arch/arm/kernel/kprobes.c          |  9 +++++++++
>  5 files changed, 33 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/arm/include/asm/kprobes.h b/arch/arm/include/asm/kprobes.h
> index 49fa0df..56f9ac6 100644
> --- a/arch/arm/include/asm/kprobes.h
> +++ b/arch/arm/include/asm/kprobes.h
> @@ -22,7 +22,6 @@
>  
>  #define __ARCH_WANT_KPROBES_INSN_SLOT
>  #define MAX_INSN_SIZE			2
> -#define MAX_STACK_SIZE			64	/* 32 would probably be OK */
>  
>  #define flush_insn_slot(p)		do { } while (0)
>  #define kretprobe_blacklist_size	0
> diff --git a/arch/arm/include/asm/probes.h b/arch/arm/include/asm/probes.h
> index ccf9af3..f0a1ee8 100644
> --- a/arch/arm/include/asm/probes.h
> +++ b/arch/arm/include/asm/probes.h
> @@ -19,6 +19,8 @@
>  #ifndef _ASM_PROBES_H
>  #define _ASM_PROBES_H
>  
> +#ifndef __ASSEMBLY__
> +
>  typedef u32 probes_opcode_t;
>  
>  struct arch_probes_insn;
> @@ -41,4 +43,14 @@ struct arch_probes_insn {
>  	int stack_space;
>  };
>  
> +#endif /* __ASSEMBLY__ */
> +
> +/*
> + * We assume one instruction can consume at most 64 bytes stack, which is
> + * 'push {r0-r15}'. Instructions consume more or unknown stack space like
> + * 'str r0, [sp, #-80]' and 'str r0, [sp, r1]' should be prohibit to probe.
> + * Both kprobe and jprobe use this macro.
> + */
> +#define MAX_STACK_SIZE			64
> +
>  #endif
> diff --git a/arch/arm/kernel/entry-armv.S b/arch/arm/kernel/entry-armv.S
> index 2f5555d..672b219 100644
> --- a/arch/arm/kernel/entry-armv.S
> +++ b/arch/arm/kernel/entry-armv.S
> @@ -31,6 +31,7 @@
>  
>  #include "entry-header.S"
>  #include <asm/entry-macro-multi.S>
> +#include <asm/probes.h>
>  
>  /*
>   * Interrupt handling.
> @@ -249,7 +250,7 @@ __und_svc:
>  	@ If a kprobe is about to simulate a "stmdb sp..." instruction,
>  	@ it obviously needs free stack space which then will belong to
>  	@ the saved context.
> -	svc_entry 64
> +	svc_entry MAX_STACK_SIZE
>  #else
>  	svc_entry
>  #endif
> diff --git a/arch/arm/kernel/kprobes-test-arm.c b/arch/arm/kernel/kprobes-test-arm.c
> index cb14242..d8ad5bb 100644
> --- a/arch/arm/kernel/kprobes-test-arm.c
> +++ b/arch/arm/kernel/kprobes-test-arm.c
> @@ -476,7 +476,8 @@ void kprobe_arm_test_cases(void)
>  	TEST_GROUP("Extra load/store instructions")
>  
>  	TEST_RPR(  "strh	r",0, VAL1,", [r",1, 48,", -r",2, 24,"]")
> -	TEST_RPR(  "streqh	r",14,VAL2,", [r",13,0, ", r",12, 48,"]")
> +	TEST_RPR(  "streqh	r",14,VAL2,", [r",11,0, ", r",12, 48,"]")
> +	TEST_UNSUPPORTED(  "streqh	r14, [r13, r12]")
>  	TEST_RPR(  "strh	r",1, VAL1,", [r",2, 24,", r",3,  48,"]!")
>  	TEST_RPR(  "strneh	r",12,VAL2,", [r",11,48,", -r",10,24,"]!")
>  	TEST_RPR(  "strh	r",2, VAL1,", [r",3, 24,"], r",4, 48,"")
> @@ -565,7 +566,8 @@ void kprobe_arm_test_cases(void)
>  
>  #if __LINUX_ARM_ARCH__ >= 5
>  	TEST_RPR(  "strd	r",0, VAL1,", [r",1, 48,", -r",2,24,"]")
> -	TEST_RPR(  "strccd	r",8, VAL2,", [r",13,0, ", r",12,48,"]")
> +	TEST_RPR(  "strccd	r",8, VAL2,", [r",11,0, ", r",12,48,"]")
> +	TEST_UNSUPPORTED(  "strccd r8, [r13, r12]")
>  	TEST_RPR(  "strd	r",4, VAL1,", [r",2, 24,", r",3, 48,"]!")
>  	TEST_RPR(  "strcsd	r",12,VAL2,", [r",11,48,", -r",10,24,"]!")
>  	TEST_RPR(  "strd	r",2, VAL1,", [r",5, 24,"], r",4,48,"")
> @@ -638,13 +640,15 @@ void kprobe_arm_test_cases(void)
>  	TEST_RP( "str"byte"	r",2, VAL1,", [r",3, 24,"], #48")		\
>  	TEST_RP( "str"byte"	r",10,VAL2,", [r",9, 64,"], #-48")		\
>  	TEST_RPR("str"byte"	r",0, VAL1,", [r",1, 48,", -r",2, 24,"]")	\
> -	TEST_RPR("str"byte"	r",14,VAL2,", [r",13,0, ", r",12, 48,"]")	\
> +	TEST_RPR("str"byte"	r",14,VAL2,", [r",11,0, ", r",12, 48,"]")	\
> +	TEST_UNSUPPORTED("str"byte" r14, [r13, r12]")	\
>  	TEST_RPR("str"byte"	r",1, VAL1,", [r",2, 24,", r",3,  48,"]!")	\
>  	TEST_RPR("str"byte"	r",12,VAL2,", [r",11,48,", -r",10,24,"]!")	\
>  	TEST_RPR("str"byte"	r",2, VAL1,", [r",3, 24,"], r",4, 48,"")	\
>  	TEST_RPR("str"byte"	r",10,VAL2,", [r",9, 48,"], -r",11,24,"")	\
>  	TEST_RPR("str"byte"	r",0, VAL1,", [r",1, 24,", r",2,  32,", asl #1]")\
> -	TEST_RPR("str"byte"	r",14,VAL2,", [r",13,0, ", r",12, 32,", lsr #2]")\
> +	TEST_RPR("str"byte"	r",14,VAL2,", [r",11,0, ", r",12, 32,", lsr #2]")\
> +	TEST_UNSUPPORTED("str"byte"	r14, [r13, r12, lsr #2]")\
>  	TEST_RPR("str"byte"	r",1, VAL1,", [r",2, 24,", r",3,  32,", asr #3]!")\
>  	TEST_RPR("str"byte"	r",12,VAL2,", [r",11,24,", r",10, 4,", ror #31]!")\
>  	TEST_P(  "ldr"byte"	r0, [r",0,  24,", #-2]")			\
> @@ -668,12 +672,12 @@ void kprobe_arm_test_cases(void)
>  
>  	LOAD_STORE("")
>  	TEST_P(   "str	pc, [r",0,0,", #15*4]")
> -	TEST_R(   "str	pc, [sp, r",2,15*4,"]")
> +	TEST_UNSUPPORTED(   "str	pc, [sp, r2]")
>  	TEST_BF(  "ldr	pc, [sp, #15*4]")
>  	TEST_BF_R("ldr	pc, [sp, r",2,15*4,"]")
>  
>  	TEST_P(   "str	sp, [r",0,0,", #13*4]")
> -	TEST_R(   "str	sp, [sp, r",2,13*4,"]")
> +	TEST_UNSUPPORTED(   "str	sp, [sp, r2]")
>  	TEST_BF(  "ldr	sp, [sp, #13*4]")
>  	TEST_BF_R("ldr	sp, [sp, r",2,13*4,"]")
>  
> diff --git a/arch/arm/kernel/kprobes.c b/arch/arm/kernel/kprobes.c
> index d7bee4b..30498436 100644
> --- a/arch/arm/kernel/kprobes.c
> +++ b/arch/arm/kernel/kprobes.c
> @@ -115,6 +115,15 @@ int __kprobes arch_prepare_kprobe(struct kprobe *p)
>  		break;
>  	}
>  
> +	/*
> +	 * Never instrument insn like 'str r0, [sp, +/-r1]'. Also, insn likes
> +	 * 'str r0, [sp, #-68]' should also be prohibited.
> +	 * See __und_svc.
> +	 */
> +	if ((p->ainsn.stack_space < 0) ||
> +			(p->ainsn.stack_space > MAX_STACK_SIZE))
> +		return -EINVAL;
> +
>  	return 0;
>  }
>  


