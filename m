Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757948AbaDWVJV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 17:09:21 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:52523 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155AbaDWVJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 17:09:17 -0400
MIME-Version: 1.0
In-Reply-To: <1396646870-29695-2-git-send-email-rabin@rab.in>
References: <1396646870-29695-1-git-send-email-rabin@rab.in>
	<1396646870-29695-2-git-send-email-rabin@rab.in>
Date: Wed, 23 Apr 2014 14:09:16 -0700
X-Google-Sender-Auth: UBRA8dsduOQNv4Oua58NljuriSQ
Message-ID: <CAGXu5jJFRapP6EA_T6fCK1po_4sf=34mpC13t9L0SCo1COB5gQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] arm: use fixmap for text patching when text is RO
From: Kees Cook <keescook@chromium.org>
To: Rabin Vincent <rabin@rab.in>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Laura Abbott <lauraa@codeaurora.org>, Jon Medhurst <tixy@linaro.org>,
        Doug Anderson <dianders@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 4, 2014 at 2:27 PM, Rabin Vincent <rabin@rab.in> wrote:
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
>  #define FIXADDR_TOP            (FIXADDR_END - PAGE_SIZE)
>
>  enum fixed_addresses {
> +       FIX_TEXT_POKE0,
> +       FIX_TEXT_POKE1,
> +
>         FIX_KMAP_BEGIN,
>         FIX_KMAP_END = (FIXADDR_TOP - FIXADDR_START) >> PAGE_SHIFT,
>         __end_of_fixed_addresses
> diff --git a/arch/arm/kernel/jump_label.c b/arch/arm/kernel/jump_label.c
> index 4ce4f78..afeeb9e 100644
> --- a/arch/arm/kernel/jump_label.c
> +++ b/arch/arm/kernel/jump_label.c
> @@ -19,7 +19,7 @@ static void __arch_jump_label_transform(struct jump_entry *entry,
>                 insn = arm_gen_nop();
>
>         if (is_static)
> -               __patch_text(addr, insn);
> +               __patch_text_early(addr, insn);
>         else
>                 patch_text(addr, insn);
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
>         unsigned int insn;
>  };
>
> -void __kprobes __patch_text(void *addr, unsigned int insn)
> +static DEFINE_SPINLOCK(patch_lock);
> +
> +static void __kprobes *patch_map(void *addr, int fixmap, unsigned long *flags)
> +{
> +       unsigned int uintaddr = (uintptr_t) addr;
> +       bool module = !core_kernel_text(uintaddr);
> +       struct page *page;
> +
> +       if (module && IS_ENABLED(CONFIG_DEBUG_SET_MODULE_RONX)) {
> +               page = vmalloc_to_page(addr);
> +       } else if (!module && IS_ENABLED(CONFIG_ARM_KERNMEM_PERMS)) {
> +               page = virt_to_page(addr);
> +       } else {
> +               return addr;
> +       }
> +
> +       if (flags)
> +               spin_lock_irqsave(&patch_lock, *flags);
> +
> +       set_fixmap(fixmap, page_to_phys(page));
> +
> +       return (void *) (__fix_to_virt(fixmap) + (uintaddr & ~PAGE_MASK));
> +}
> +
> +static void __kprobes patch_unmap(int fixmap, unsigned long *flags)
> +{
> +       clear_fixmap(fixmap);
> +
> +       if (flags)
> +               spin_unlock_irqrestore(&patch_lock, *flags);
> +}
> +
> +void __kprobes __patch_text_real(void *addr, unsigned int insn, bool remap)
>  {
>         bool thumb2 = IS_ENABLED(CONFIG_THUMB2_KERNEL);
> +       unsigned int uintaddr = (uintptr_t) addr;
> +       unsigned long flags;
> +       void *waddr = addr;
>         int size;
>
> +       if (remap)
> +               waddr = patch_map(addr, FIX_TEXT_POKE0, &flags);
> +
>         if (thumb2 && __opcode_is_thumb16(insn)) {
> -               *(u16 *)addr = __opcode_to_mem_thumb16(insn);
> +               *(u16 *)waddr = __opcode_to_mem_thumb16(insn);
>                 size = sizeof(u16);
> -       } else if (thumb2 && ((uintptr_t)addr & 2)) {
> +       } else if (thumb2 && (uintaddr & 2)) {
> +               bool twopage = (uintaddr & ~PAGE_MASK) == PAGE_SIZE - 2;
>                 u16 first = __opcode_thumb32_first(insn);
>                 u16 second = __opcode_thumb32_second(insn);
> -               u16 *addrh = addr;
> +               u16 *addrh0 = waddr;
> +               u16 *addrh1 = waddr + 2;
> +
> +               if (remap && twopage)
> +                       addrh1 = patch_map(addr + 2, FIX_TEXT_POKE1, NULL);
>
> -               addrh[0] = __opcode_to_mem_thumb16(first);
> -               addrh[1] = __opcode_to_mem_thumb16(second);
> +               *addrh0 = __opcode_to_mem_thumb16(first);
> +               *addrh1 = __opcode_to_mem_thumb16(second);
> +
> +               if (twopage && addrh1 != addr + 2)
> +                       patch_unmap(FIX_TEXT_POKE1, NULL);
>
>                 size = sizeof(u32);
>         } else {
> @@ -36,10 +85,13 @@ void __kprobes __patch_text(void *addr, unsigned int insn)
>                 else
>                         insn = __opcode_to_mem_arm(insn);
>
> -               *(u32 *)addr = insn;
> +               *(u32 *)waddr = insn;
>                 size = sizeof(u32);
>         }
>
> +       if (waddr != addr)
> +               patch_unmap(FIX_TEXT_POKE0, &flags);
> +
>         flush_icache_range((uintptr_t)(addr),
>                            (uintptr_t)(addr) + size);
>  }
> diff --git a/arch/arm/kernel/patch.h b/arch/arm/kernel/patch.h
> index b4731f2..77e054c 100644
> --- a/arch/arm/kernel/patch.h
> +++ b/arch/arm/kernel/patch.h
> @@ -2,6 +2,16 @@
>  #define _ARM_KERNEL_PATCH_H
>
>  void patch_text(void *addr, unsigned int insn);
> -void __patch_text(void *addr, unsigned int insn);
> +void __patch_text_real(void *addr, unsigned int insn, bool remap);
> +
> +static inline void __patch_text(void *addr, unsigned int insn)
> +{
> +       __patch_text_real(addr, insn, true);
> +}
> +
> +static inline void __patch_text_early(void *addr, unsigned int insn)
> +{
> +       __patch_text_real(addr, insn, false);
> +}
>
>  #endif
> --
> 1.9.1
>

I think we can use this for the kgdb case too. Has anyone tried that
yet? Perhaps implementing text_poke() in terms of patch_map/unmap
calls would be best? Then the arm-specific kgdb hooks can use that,
since it does the icache flushing separately.

-Kees

-- 
Kees Cook
Chrome OS Security
