Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994AbaIPXYu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 19:24:50 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:53954 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512AbaIPXYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 19:24:49 -0400
Message-ID: <5418C6BF.9090208@mvista.com>
Date: Tue, 16 Sep 2014 18:24:47 -0500
From: Corey Minyard <cminyard@mvista.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: minyard@acm.org, Ralf Baechle <ralf@linux-mips.org>,
        linux-mips@linux-mips.org
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mips: Save all registers when saving the frame
References: <1410903925-10744-1-git-send-email-minyard@acm.org>
In-Reply-To: <1410903925-10744-1-git-send-email-minyard@acm.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well, there's a bug I noticed in this patch, $1 is restored from the
wrong location.
I'm not sure $1 ($at) needs to be restored at all, really.  I guess make
this a RFC.

-corey


On 09/16/2014 04:45 PM, minyard@acm.org wrote:
> From: Corey Minyard <cminyard@mvista.com>
>
> The MIPS frame save code was just saving a few registers, enough to
> do a backtrace if every function set up a frame.  However, this is
> not working if you are using DWARF unwinding, because most of the
> registers are wrong.  This was causing kdump backtraces to be short
> or bogus.
>
> So save all the registers.
>
> Signed-off-by: Corey Minyard <cminyard@mvista.com>
> ---
>  arch/mips/include/asm/stacktrace.h | 64 +++++++++++++++++++++++++++++---------
>  1 file changed, 50 insertions(+), 14 deletions(-)
>
> diff --git a/arch/mips/include/asm/stacktrace.h b/arch/mips/include/asm/stacktrace.h
> index 780ee2c..05a2195 100644
> --- a/arch/mips/include/asm/stacktrace.h
> +++ b/arch/mips/include/asm/stacktrace.h
> @@ -2,6 +2,8 @@
>  #define _ASM_STACKTRACE_H
>  
>  #include <asm/ptrace.h>
> +#include <asm/asm.h>
> +#include <linux/stringify.h>
>  
>  #ifdef CONFIG_KALLSYMS
>  extern int raw_show_trace;
> @@ -20,6 +22,14 @@ static inline unsigned long unwind_stack(struct task_struct *task,
>  }
>  #endif
>  
> +#define STR_PTR_LA    __stringify(PTR_LA)
> +#define STR_LONG_S    __stringify(LONG_S)
> +#define STR_LONG_L    __stringify(LONG_L)
> +#define STR_LONGSIZE  __stringify(LONGSIZE)
> +
> +#define STORE_ONE_REG(r) \
> +    STR_LONG_S   " $" __stringify(r)",("STR_LONGSIZE"*"__stringify(r)")(%1)\n\t"
> +
>  static __always_inline void prepare_frametrace(struct pt_regs *regs)
>  {
>  #ifndef CONFIG_KALLSYMS
> @@ -32,21 +42,47 @@ static __always_inline void prepare_frametrace(struct pt_regs *regs)
>  	__asm__ __volatile__(
>  		".set push\n\t"
>  		".set noat\n\t"
> -#ifdef CONFIG_64BIT
> -		"1: dla $1, 1b\n\t"
> -		"sd $1, %0\n\t"
> -		"sd $29, %1\n\t"
> -		"sd $31, %2\n\t"
> -#else
> -		"1: la $1, 1b\n\t"
> -		"sw $1, %0\n\t"
> -		"sw $29, %1\n\t"
> -		"sw $31, %2\n\t"
> -#endif
> +		/* Store $1 so we can use it */
> +		STR_LONG_S " $1,"STR_LONGSIZE"(%1)\n\t"
> +		/* Store the PC */
> +		"1: " STR_PTR_LA " $1, 1b\n\t"
> +		STR_LONG_S " $1,%0\n\t"
> +		STORE_ONE_REG(2)
> +		STORE_ONE_REG(3)
> +		STORE_ONE_REG(4)
> +		STORE_ONE_REG(5)
> +		STORE_ONE_REG(6)
> +		STORE_ONE_REG(7)
> +		STORE_ONE_REG(8)
> +		STORE_ONE_REG(9)
> +		STORE_ONE_REG(10)
> +		STORE_ONE_REG(11)
> +		STORE_ONE_REG(12)
> +		STORE_ONE_REG(13)
> +		STORE_ONE_REG(14)
> +		STORE_ONE_REG(15)
> +		STORE_ONE_REG(16)
> +		STORE_ONE_REG(17)
> +		STORE_ONE_REG(18)
> +		STORE_ONE_REG(19)
> +		STORE_ONE_REG(20)
> +		STORE_ONE_REG(21)
> +		STORE_ONE_REG(22)
> +		STORE_ONE_REG(23)
> +		STORE_ONE_REG(24)
> +		STORE_ONE_REG(25)
> +		STORE_ONE_REG(26)
> +		STORE_ONE_REG(27)
> +		STORE_ONE_REG(28)
> +		STORE_ONE_REG(29)
> +		STORE_ONE_REG(30)
> +		STORE_ONE_REG(31)
> +		/* Restore $1 */
> +		STR_LONG_L " $1,(%1)\n\t"
>  		".set pop\n\t"
> -		: "=m" (regs->cp0_epc),
> -		"=m" (regs->regs[29]), "=m" (regs->regs[31])
> -		: : "memory");
> +		: "=m" (regs->cp0_epc)
> +		: "r" (regs->regs)
> +		: "memory");
>  }
>  
>  #endif /* _ASM_STACKTRACE_H */

