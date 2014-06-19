Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199AbaFSN5X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 09:57:23 -0400
Received: from mail-ve0-f181.google.com ([209.85.128.181]:52706 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754891AbaFSN5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 09:57:22 -0400
MIME-Version: 1.0
In-Reply-To: <1403154257-14591-1-git-send-email-lauraa@codeaurora.org>
References: <1403154257-14591-1-git-send-email-lauraa@codeaurora.org>
From: Rob Herring <robherring2@gmail.com>
Date: Thu, 19 Jun 2014 08:57:00 -0500
Message-ID: <CAL_JsqJW-mBb7C=ni2YLK-h9kfcAHs6b-uVJ-Zi-+MW0F_x1=Q@mail.gmail.com>
Subject: Re: [PATCH] of: Check for phys_addr_t overflows in early_init_dt_add_memory_arch
To: Laura Abbott <lauraa@codeaurora.org>
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 12:04 AM, Laura Abbott <lauraa@codeaurora.org> wrote:
> The common early_init_dt_add_memory_arch takes the base and size
> of a memory region as u64 types. The function never checks if
> the base and size can actually fit in a phys_addr_t which may
> be smaller than 64-bits. This may result in incorrect memory
> being passed to memblock_add if the memory falls outside the
> range of phys_addr_t. Add range checks for the base and size if
> phys_addr_t is smaller than u64.
>
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
> ---
> Geert, can you drop my other patch and give this a test to see if it fixes
> your bootup problem?
>
> ---
>  drivers/of/fdt.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
>
> diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
> index c4cddf0..f72132c 100644
> --- a/drivers/of/fdt.c
> +++ b/drivers/of/fdt.c
> @@ -880,6 +880,21 @@ void __init __weak early_init_dt_add_memory_arch(u64 base, u64 size)
>         const u64 phys_offset = __pa(PAGE_OFFSET);
>         base &= PAGE_MASK;
>         size &= PAGE_MASK;
> +
> +#ifndef CONFIG_ARCH_PHYS_ADDR_T_64BIT
> +       if (base > ULONG_MAX) {

How about removing the ifdef and doing something like:

if ((base >> 32) && (sizeof(phys_addr_t) != sizeof(u64)))

> +               pr_warning("Ignoring memory block 0x%llx - 0x%llx\n",
> +                               base, base + size);
> +               return;
> +       }
> +
> +       if (base + size > ULONG_MAX) {
> +               pr_warning("Ignoring memory range 0x%lx - 0x%llx\n",
> +                               ULONG_MAX, base + size);
> +               size = ULONG_MAX - base;
> +       }
> +#endif
> +
>         if (base + size < phys_offset) {
>                 pr_warning("Ignoring memory block 0x%llx - 0x%llx\n",
>                            base, base + size);
> --
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> hosted by The Linux Foundation
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
