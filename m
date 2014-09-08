Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927AbaIHN4P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 09:56:15 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:63050 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973AbaIHN4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 09:56:14 -0400
MIME-Version: 1.0
In-Reply-To: <1410183102-6969-1-git-send-email-msalter@redhat.com>
References: <1410183102-6969-1-git-send-email-msalter@redhat.com>
Date: Mon, 8 Sep 2014 15:56:12 +0200
Message-ID: <CAKv+Gu9mNuCXo1mBH_m1nXZqLjRvMoq87mrB8mVCNOqoY8AVsg@mail.gmail.com>
Subject: Re: [PATCH] efi/arm64: fix fdt-related memory reservation
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: Mark Salter <msalter@redhat.com>
Cc: Leif Lindholm <leif.lindholm@linaro.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 September 2014 15:31, Mark Salter <msalter@redhat.com> wrote:
> Commit 86c8b27a01cf:
>  "arm64: ignore DT memreserve entries when booting in UEFI mode
>
> prevents early_init_fdt_scan_reserved_mem() from being called for
> arm64 kernels booting via UEFI. This was done because the kernel
> will use the UEFI memory map to determine reserved memory regions.
> That approach has problems in that early_init_fdt_scan_reserved_mem()
> also reserves the FDT itself and any node-specific reserved memory.
> By chance of some kernel configs, the FDT may be overwritten before
> it can be unflattened and the kernel will fail to boot. More subtle
> problems will result if the FDT has node specific reserved memory
> which is not really reserved.
>
> This patch has the UEFI stub remove the memory reserve map entries
> from the FDT as it does with the memory nodes. This allows
> early_init_fdt_scan_reserved_mem() to be called unconditionally
> so that the other needed reservations are made.
>
> Signed-off-by: Mark Salter <msalter@redhat.com>

Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Interesting. I noticed the other day that my FDT got clobbered when
accidentally booting with very little memory on QEMU , but I hadn't
looked into it yet in more detail.

Matt: could you put this in your 'urgent' queue as well, please?

Cheers,
Ard.


> ---
>  arch/arm64/mm/init.c               |  3 +--
>  drivers/firmware/efi/libstub/fdt.c | 10 +++++++++-
>  2 files changed, 10 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
> index 5472c24..a83061f 100644
> --- a/arch/arm64/mm/init.c
> +++ b/arch/arm64/mm/init.c
> @@ -149,8 +149,7 @@ void __init arm64_memblock_init(void)
>                 memblock_reserve(__virt_to_phys(initrd_start), initrd_end - initrd_start);
>  #endif
>
> -       if (!efi_enabled(EFI_MEMMAP))
> -               early_init_fdt_scan_reserved_mem();
> +       early_init_fdt_scan_reserved_mem();
>
>         /* 4GB maximum for 32-bit only capable devices */
>         if (IS_ENABLED(CONFIG_ZONE_DMA))
> diff --git a/drivers/firmware/efi/libstub/fdt.c b/drivers/firmware/efi/libstub/fdt.c
> index a56bb35..723c7da 100644
> --- a/drivers/firmware/efi/libstub/fdt.c
> +++ b/drivers/firmware/efi/libstub/fdt.c
> @@ -22,7 +22,7 @@ efi_status_t update_fdt(efi_system_table_t *sys_table, void *orig_fdt,
>                         unsigned long map_size, unsigned long desc_size,
>                         u32 desc_ver)
>  {
> -       int node, prev;
> +       int node, prev, i, num_rsv;
>         int status;
>         u32 fdt_val32;
>         u64 fdt_val64;
> @@ -73,6 +73,14 @@ efi_status_t update_fdt(efi_system_table_t *sys_table, void *orig_fdt,
>                 prev = node;
>         }
>
> +       /*
> +        * Delete all memory reserve map entries. When booting via UEFI,
> +        * kernel will use the UEFI memory map to find reserved regions.
> +        */
> +       num_rsv = fdt_num_mem_rsv(fdt);
> +       for (i = 0; i < num_rsv; i++)
> +               fdt_del_mem_rsv(fdt, i);
> +
>         node = fdt_subnode_offset(fdt, 0, "chosen");
>         if (node < 0) {
>                 node = fdt_add_subnode(fdt, 0, "chosen");
> --
> 1.8.3.1
>
