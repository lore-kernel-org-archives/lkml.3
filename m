Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387AbaDGN57 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 09:57:59 -0400
Received: from smarthost01b.mail.zen.net.uk ([212.23.1.3]:53456 "EHLO
	smarthost01b.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754274AbaDGN5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 09:57:54 -0400
Message-ID: <1396879071.3654.43.camel@linaro1.home>
Subject: Re: [PATCH 2/2] arm: use fixmap for text patching when text is RO
From: "Jon Medhurst (Tixy)" <tixy@linaro.org>
To: Rabin Vincent <rabin@rab.in>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kees Cook <keescook@chromium.org>,
        Laura Abbott <lauraa@codeaurora.org>
Date: Mon, 07 Apr 2014 14:57:51 +0100
In-Reply-To: <1396646870-29695-2-git-send-email-rabin@rab.in>
References: <1396646870-29695-1-git-send-email-rabin@rab.in>
	 <1396646870-29695-2-git-send-email-rabin@rab.in>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-smarthost01b-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-04-04 at 23:27 +0200, Rabin Vincent wrote:
> Use fixmaps for text patching when the kernel text is read-only,
> inspired by x86.  This makes jump labels and kprobes work with the
> currently available CONFIG_DEBUG_SET_MODULE_RONX and the upcoming
> CONFIG_DEBUG_RODATA options.
> 
> Signed-off-by: Rabin Vincent <rabin@rab.in>
> ---
>  arch/arm/include/asm/fixmap.h |  3 ++
>  arch/arm/kernel/jump_label.c  |  2 +-
>  arch/arm/kernel/patch.c       | 66 ++++++++++++++++++++++++++++++++++++++-----
>  arch/arm/kernel/patch.h       | 12 +++++++-
>  4 files changed, 74 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/arm/include/asm/fixmap.h b/arch/arm/include/asm/fixmap.h
> index 55ed076..79c1719 100644
> --- a/arch/arm/include/asm/fixmap.h
> +++ b/arch/arm/include/asm/fixmap.h
> @@ -18,6 +18,9 @@
>  #define FIXADDR_TOP		(FIXADDR_END - PAGE_SIZE)
>  
>  enum fixed_addresses {
> +	FIX_TEXT_POKE0,
> +	FIX_TEXT_POKE1,
> +
>  	FIX_KMAP_BEGIN,
>  	FIX_KMAP_END = (FIXADDR_TOP - FIXADDR_START) >> PAGE_SHIFT,
>  	__end_of_fixed_addresses
> diff --git a/arch/arm/kernel/jump_label.c b/arch/arm/kernel/jump_label.c
> index 4ce4f78..afeeb9e 100644
> --- a/arch/arm/kernel/jump_label.c
> +++ b/arch/arm/kernel/jump_label.c
> @@ -19,7 +19,7 @@ static void __arch_jump_label_transform(struct jump_entry *entry,
>  		insn = arm_gen_nop();
>  
>  	if (is_static)
> -		__patch_text(addr, insn);
> +		__patch_text_early(addr, insn);
>  	else
>  		patch_text(addr, insn);
>  }
> diff --git a/arch/arm/kernel/patch.c b/arch/arm/kernel/patch.c
> index 07314af..761c5b6 100644
> --- a/arch/arm/kernel/patch.c
> +++ b/arch/arm/kernel/patch.c
> @@ -1,8 +1,11 @@
>  #include <linux/kernel.h>
> +#include <linux/spinlock.h>
>  #include <linux/kprobes.h>
> +#include <linux/mm.h>
>  #include <linux/stop_machine.h>
>  
>  #include <asm/cacheflush.h>
> +#include <asm/fixmap.h>
>  #include <asm/smp_plat.h>
>  #include <asm/opcodes.h>
>  
> @@ -13,21 +16,67 @@ struct patch {
>  	unsigned int insn;
>  };
>  
> -void __kprobes __patch_text(void *addr, unsigned int insn)
> +static DEFINE_SPINLOCK(patch_lock);
> +
> +static void __kprobes *patch_map(void *addr, int fixmap, unsigned long *flags)
> +{
> +	unsigned int uintaddr = (uintptr_t) addr;
> +	bool module = !core_kernel_text(uintaddr);
> +	struct page *page;
> +
> +	if (module && IS_ENABLED(CONFIG_DEBUG_SET_MODULE_RONX)) {
> +		page = vmalloc_to_page(addr);
> +	} else if (!module && IS_ENABLED(CONFIG_ARM_KERNMEM_PERMS)) {
> +		page = virt_to_page(addr);
> +	} else {
> +		return addr;
> +	}

I can't help but think that it'd be more maintainable to just always use
fixmap, though that would obviously have some performance impact (not
sure that particularly matters for text patching) and it would expose
possible fixmap bugginess to more kernels (see my next comment...)

> +
> +	if (flags)
> +		spin_lock_irqsave(&patch_lock, *flags);
> +
> +	set_fixmap(fixmap, page_to_phys(page));
> +
> +	return (void *) (__fix_to_virt(fixmap) + (uintaddr & ~PAGE_MASK));

How does fixmap cope with cache colouring? Looking at the implementation
it looks like it doesn't and so fixmap use on ARM is possibly buggy.

For the text patching case where we know there are no writeable mappings
[1] this should be OK if we used set_fixmap_nocache here, so long as we
also invalidated the dcache later for the proper virtual address.

[1] Can we know there are no writeable mappings though, the ftrace code
modifying patches from Kees Cook have there own way of modifying text
code permissions.

[...]

Rest of patch trimmed

-- 
Tixy



