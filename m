Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201AbaLVJJf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 04:09:35 -0500
Received: from mail-lb0-f171.google.com ([209.85.217.171]:45763 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980AbaLVJJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 04:09:34 -0500
MIME-Version: 1.0
In-Reply-To: <1419218249-5744-1-git-send-email-yamada.m@jp.panasonic.com>
References: <1419218249-5744-1-git-send-email-yamada.m@jp.panasonic.com>
Date: Mon, 22 Dec 2014 10:09:32 +0100
Message-ID: <CAKv+Gu8QSSC32VVwBzSiDL_3t_dd=2Oa+Xp5r8mtDrGBW9E0ow@mail.gmail.com>
Subject: Re: [PATCH v2] ARM: mm: fix size rounding-down of arm_add_memory() function
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: Masahiro Yamada <yamada.m@jp.panasonic.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Will Deacon <will.deacon@arm.com>, Olof Johansson <olof@lixom.net>,
        Laura Abbott <lauraa@codeaurora.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 December 2014 at 04:17, Masahiro Yamada <yamada.m@jp.panasonic.com> wrote:
> The current rounding of "size" is wrong:
>
>  - If "start" is sufficiently near the next page boundary, "size"
>    is decremented by more than enough and the last page is lost.
>
>  - If "size" is sufficiently small, it is wrapped around and gets
>    a bogus value.
>
> Signed-off-by: Masahiro Yamada <yamada.m@jp.panasonic.com>
> Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>


> ---
>
> Changes in v2:
>  - Avoid wrap around of "size"
>
>  arch/arm/kernel/setup.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
> index f9c8639..d13f185 100644
> --- a/arch/arm/kernel/setup.c
> +++ b/arch/arm/kernel/setup.c
> @@ -657,10 +657,13 @@ int __init arm_add_memory(u64 start, u64 size)
>
>         /*
>          * Ensure that start/size are aligned to a page boundary.
> -        * Size is appropriately rounded down, start is rounded up.
> +        * Size is rounded down, start is rounded up.
>          */
> -       size -= start & ~PAGE_MASK;
>         aligned_start = PAGE_ALIGN(start);
> +       if (aligned_start > start + size)
> +               size = 0;
> +       else
> +               size -= aligned_start - start;
>
>  #ifndef CONFIG_ARCH_PHYS_ADDR_T_64BIT
>         if (aligned_start > ULONG_MAX) {
> --
> 1.9.1
>
