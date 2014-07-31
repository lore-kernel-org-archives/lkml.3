Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056AbaGaVFx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 17:05:53 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:44180 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153AbaGaVFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 17:05:51 -0400
Message-ID: <53DAAFAC.9000502@amacapital.net>
Date: Thu, 31 Jul 2014 14:05:48 -0700
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: kan.liang@intel.com, peterz@infradead.org
CC: andi@firstfloor.org, alexander.shishkin@linux.intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] x86 msr: msr goto extension support
References: <1406799663-18192-1-git-send-email-kan.liang@intel.com>
In-Reply-To: <1406799663-18192-1-git-send-email-kan.liang@intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2014 02:41 AM, kan.liang@intel.com wrote:
> From: Kan Liang <kan.liang@intel.com>
> 
> Currently, {rd,wr}msrl_safe can handle the exception which caused by accessing
> specific MSR.
> However, it will introduce extra conditional branch for testing errors. That
> will impact the "fast" path's performance.
> The newly implemented {rd,wr}msrl_goto function can not only handle the
> exception which caused by accessing specific MSR,
> but also takes advantage of the asm goto extension to eliminate the impact of
> performance.
> 
> The asm goto extension is supported by GCC 4.5 and later versions. If the
> compiler doesn't support goto extension, _safe will be used to replace _goto.
> 
> Signed-off-by: Kan Liang <kan.liang@intel.com>
> ---
>  arch/x86/include/asm/msr.h      | 60 +++++++++++++++++++++++++++++++++++++++++
>  arch/x86/include/asm/paravirt.h | 18 +++++++++++++
>  2 files changed, 78 insertions(+)
> 
> diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
> index de36f22..55438da 100644
> --- a/arch/x86/include/asm/msr.h
> +++ b/arch/x86/include/asm/msr.h
> @@ -203,6 +203,66 @@ do {                                                            \
>  
>  #define rdtscpll(val, aux) (val) = native_read_tscp(&(aux))
>  
> +#ifdef CC_HAVE_ASM_GOTO
> +
> +/*
> + * The _goto version is rdmsrl/wrmsrl with exception handling
> + * The advantage (than _safe) is that it can directly jump in the
> + * exception handling code, and never test in the "fast" path.
> + *
> + * Since _goto doesn't support output, try to protect the output
> + * registers by clobbers, and process the registers immediately.
> + */
> +#define rdmsrl_goto(msr, result, fail_label)			\
> +do {								\
> +	DECLARE_ARGS(val, low, high);				\
> +	asm_volatile_goto("2: rdmsr\n"				\
> +			"1:\n\t"				\
> +			_ASM_EXTABLE(2b, %l[fail_label])	\
> +			: /* No outputs. */			\
> +			: "c" (msr)				\
> +			: "%rax", "%rdx"			\
> +			: fail_label);				\
> +	asm volatile (""					\
> +			: EAX_EDX_RET(val, low, high)		\
> +			: );					\

This is scary -- the compiler is free to optimize this incorrectly, and
it doesn't even seem very farfetched to me.

> +	result = EAX_EDX_VAL(val, low, high);			\
> +} while (0)
> +
> +#define wrmsrl_goto(msr, val, fail_label)			\
> +do {								\
> +	unsigned low, high;					\
> +	low = (u32)val;						\
> +	high = (u32)(val >> 32);				\
> +	asm_volatile_goto("2: wrmsr\n"				\
> +			"1:\n\t"				\
> +			_ASM_EXTABLE(2b, %l[fail_label])	\
> +			: /* No outputs. */			\
> +			: "c" (msr), "a" (low), "d" (high)	\
> +			: "memory"				\
> +			: fail_label);				\
> +} while (0)

I like this one.

--Andy
