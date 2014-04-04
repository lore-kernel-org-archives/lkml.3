Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955AbaDDT62 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 15:58:28 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:50181 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043AbaDDT6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 15:58:25 -0400
Date: Fri, 4 Apr 2014 21:58:18 +0200
From: Rabin Vincent <rabin@rab.in>
To: Kees Cook <keescook@chromium.org>
Cc: linux-arm-kernel@lists.infradead.org, Laura Abbott <lauraa@codeaurora.org>,
        Alexander Holler <holler@ahsoftware.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ARM: mm: make text and rodata read-only
Message-ID: <20140404195818.GA21028@debian>
References: <1396577719-14786-1-git-send-email-keescook@chromium.org>
 <1396577719-14786-3-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396577719-14786-3-git-send-email-keescook@chromium.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 03, 2014 at 07:15:19PM -0700, Kees Cook wrote:
> diff --git a/arch/arm/kernel/ftrace.c b/arch/arm/kernel/ftrace.c
> index 34e56647dcee..4ae343c1e2a3 100644
> --- a/arch/arm/kernel/ftrace.c
> +++ b/arch/arm/kernel/ftrace.c
> @@ -14,6 +14,7 @@
>  
>  #include <linux/ftrace.h>
>  #include <linux/uaccess.h>
> +#include <linux/stop_machine.h>
>  
>  #include <asm/cacheflush.h>
>  #include <asm/opcodes.h>
> @@ -34,6 +35,22 @@
>  
>  #define	OLD_NOP		0xe1a00000	/* mov r0, r0 */
>  
> +static int __ftrace_modify_code(void *data)

This is in the CONFIG_OLD_MCOUNT ifdef, but should be in the outer ifdef
(CONFIG_DYNAMIC_FTRACE) instead, otherwise it will not get enabled for
for example Thumb-2 kernels.  This was wrong in my example patch too.

> diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
> index 8539eb2a01ad..3baac4ad165f 100644
> --- a/arch/arm/mm/init.c
> +++ b/arch/arm/mm/init.c
> @@ -681,30 +716,52 @@ static inline bool arch_has_strict_perms(void)
>  	return true;
>  }
>  
> +#define set_section_perms(perms, field)	{				\
> +	size_t i;							\
> +	unsigned long addr;						\
> +									\
> +	if (!arch_has_strict_perms())					\
> +		return;							\
> +									\
> +	for (i = 0; i < ARRAY_SIZE(perms); i++) {			\
> +		if (!IS_ALIGNED(perms[i].start, SECTION_SIZE) ||	\
> +		    !IS_ALIGNED(perms[i].end, SECTION_SIZE)) {		\
> +			pr_err("BUG: section %lx-%lx not aligned to %lx\n", \
> +				perms[i].start, perms[i].end,		\
> +				SECTION_SIZE);				\
> +			continue;					\
> +		}							\
> +									\
> +		for (addr = perms[i].start;				\
> +		     addr < perms[i].end;				\
> +		     addr += SECTION_SIZE)				\
> +			section_update(addr, perms[i].mask,		\
> +				       perms[i].field);			\
> +	}								\
> +}
> +
>  static inline void fix_kernmem_perms(void)
>  {
> -	unsigned long addr;
> -	unsigned int i;
> +	set_section_perms(nx_perms, prot);
> +}
>  
> -	if (!arch_has_strict_perms())
> -		return;
> +#ifdef CONFIG_DEBUG_RODATA
> +void mark_rodata_ro(void)
> +{
> +	set_section_perms(ro_perms, prot);
> +}
>  
> -	for (i = 0; i < ARRAY_SIZE(section_perms); i++) {
> -		if (!IS_ALIGNED(section_perms[i].start, SECTION_SIZE) ||
> -		    !IS_ALIGNED(section_perms[i].end, SECTION_SIZE)) {
> -			pr_err("BUG: section %lx-%lx not aligned to %lx\n",
> -				section_perms[i].start, section_perms[i].end,
> -				SECTION_SIZE);
> -			continue;
> -		}
> +void set_kernel_text_rw(void)
> +{
> +	set_section_perms(ro_perms, clear);
> +}

You need a TLB flush.  I had a flush_tlb_all() in my example patch,
http://lists.infradead.org/pipermail/linux-arm-kernel/2014-April/244335.html,
but the following is probably nicer (on top of this patch):

diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index 9bea524..a92c45a 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -741,6 +741,8 @@ static inline bool arch_has_strict_perms(void)
 		     addr += SECTION_SIZE)				\
 			section_update(addr, perms[i].mask,		\
 				       perms[i].field);			\
+									\
+		flush_tlb_kernel_range(perms[i].start, perms[i].end);	\
 	}								\
 }
 
