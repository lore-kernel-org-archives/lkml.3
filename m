Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264AbaA0V6X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 16:58:23 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:57380 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754058AbaA0V6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 16:58:21 -0500
Message-ID: <52E6D67A.8050409@amacapital.net>
Date: Mon, 27 Jan 2014 13:58:18 -0800
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Qiaowei Ren <qiaowei.ren@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
CC: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 4/4] x86, mpx: extend siginfo structure to include
 bound violation information
References: <1390727338-20487-1-git-send-email-qiaowei.ren@intel.com> <1390727338-20487-5-git-send-email-qiaowei.ren@intel.com>
In-Reply-To: <1390727338-20487-5-git-send-email-qiaowei.ren@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26/2014 01:08 AM, Qiaowei Ren wrote:
> This patch adds new fields about bound violation into siginfo
> structure. si_lower and si_upper are respectively lower bound
> and upper bound when bound violation is caused.
> 
> These fields will be set in #BR exception handler by decoding
> the user instruction and constructing the faulting pointer.
> A userspace application can get violation address, lower bound
> and upper bound for bound violation from this new siginfo structure.
> 
> Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
> ---
>  arch/x86/include/asm/mpx.h         |   19 +++
>  arch/x86/kernel/mpx.c              |  287 ++++++++++++++++++++++++++++++++++++
>  arch/x86/kernel/traps.c            |    6 +
>  include/uapi/asm-generic/siginfo.h |    9 +-
>  kernel/signal.c                    |    4 +
>  5 files changed, 324 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/include/asm/mpx.h b/arch/x86/include/asm/mpx.h
> index 9652e9e..e099573 100644
> --- a/arch/x86/include/asm/mpx.h
> +++ b/arch/x86/include/asm/mpx.h
> @@ -3,6 +3,7 @@
>  
>  #include <linux/types.h>
>  #include <asm/ptrace.h>
> +#include <asm/insn.h>
>  
>  #ifdef CONFIG_X86_64
>  
> @@ -30,6 +31,22 @@
>  
>  #endif
>  
> +struct mpx_insn {
> +	struct insn_field rex_prefix;	/* REX prefix */
> +	struct insn_field modrm;
> +	struct insn_field sib;
> +	struct insn_field displacement;
> +
> +	unsigned char addr_bytes;	/* effective address size */
> +	unsigned char limit;
> +	unsigned char x86_64;
> +
> +	const unsigned char *kaddr;	/* kernel address of insn to analyze */
> +	const unsigned char *next_byte;
> +};
> +
> +#define MAX_MPX_INSN_SIZE	15
> +
>  typedef union {
>  	struct {
>  		unsigned long ignored:MPX_IGN_BITS;
> @@ -40,5 +57,7 @@ typedef union {
>  } mpx_addr;
>  
>  void do_mpx_bt_fault(struct xsave_struct *xsave_buf);
> +void do_mpx_bounds(struct pt_regs *regs, siginfo_t *info,
> +		struct xsave_struct *xsave_buf);
>  
>  #endif /* _ASM_X86_MPX_H */
> diff --git a/arch/x86/kernel/mpx.c b/arch/x86/kernel/mpx.c
> index 9e91178..983abf7 100644
> --- a/arch/x86/kernel/mpx.c
> +++ b/arch/x86/kernel/mpx.c
> @@ -91,6 +91,269 @@ int mpx_release(struct task_struct *tsk)
>  	return 0;
>  }
>  
> +typedef enum {REG_TYPE_RM, REG_TYPE_INDEX, REG_TYPE_BASE} reg_type_t;
> +static unsigned long get_reg(struct mpx_insn *insn, struct pt_regs *regs,
> +			     reg_type_t type)
> +{
> +	int regno = 0;
> +	unsigned char modrm = (unsigned char)insn->modrm.value;
> +	unsigned char sib = (unsigned char)insn->sib.value;
> +
> +	static const int regoff[] = {
> +		offsetof(struct pt_regs, ax),
> +		offsetof(struct pt_regs, cx),
> +		offsetof(struct pt_regs, dx),
> +		offsetof(struct pt_regs, bx),
> +		offsetof(struct pt_regs, sp),
> +		offsetof(struct pt_regs, bp),
> +		offsetof(struct pt_regs, si),
> +		offsetof(struct pt_regs, di),
> +#ifdef CONFIG_X86_64
> +		offsetof(struct pt_regs, r8),
> +		offsetof(struct pt_regs, r9),
> +		offsetof(struct pt_regs, r10),
> +		offsetof(struct pt_regs, r11),
> +		offsetof(struct pt_regs, r12),
> +		offsetof(struct pt_regs, r13),
> +		offsetof(struct pt_regs, r14),
> +		offsetof(struct pt_regs, r15),
> +#endif
> +	};
> +
> +	switch (type) {
> +	case REG_TYPE_RM:
> +		regno = X86_MODRM_RM(modrm);
> +		if (X86_REX_B(insn->rex_prefix.value) == 1)
> +			regno += 8;
> +		break;
> +
> +	case REG_TYPE_INDEX:
> +		regno = X86_SIB_INDEX(sib);
> +		if (X86_REX_X(insn->rex_prefix.value) == 1)
> +			regno += 8;
> +		break;
> +
> +	case REG_TYPE_BASE:
> +		regno = X86_SIB_BASE(sib);
> +		if (X86_REX_B(insn->rex_prefix.value) == 1)
> +			regno += 8;
> +		break;
> +
> +	default:
> +		break;
> +	}
> +
> +	return regs_get_register(regs, regoff[regno]);
> +}

This (and the rest of the decoder) is IMO hideous.  Is there any reason
that this belongs in the kernel and not in, say, a libmpx?

(Why on earth does Intel not expose this stuff in cr2 or an MSR or
something?)

--Andy

