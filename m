Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868AbaJ2BjW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 21:39:22 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:46107 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515AbaJ2BjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 21:39:21 -0400
MIME-Version: 1.0
In-Reply-To: <1414495714-40815-1-git-send-email-Zubair.Kakakhel@imgtec.com>
References: <1414495714-40815-1-git-send-email-Zubair.Kakakhel@imgtec.com>
Date: Wed, 29 Oct 2014 09:39:20 +0800
Message-ID: <CAAhV-H6Vi2nuqx=MNhEiJH7m=7qafckgDWe0jnBiq5x=BF7QxQ@mail.gmail.com>
Subject: Re: [PATCH] mips: cma: Do not reserve memory if not required
From: Huacai Chen <chenhuacai@gmail.com>
To: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>
Cc: Ralf Baechle <ralf@linux-mips.org>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I meet the same problem on Loongson-3, and this patch resolve my
problem. Thanks.
Tested-by: Huacai Chen <chenhc@lemote.com>

On Tue, Oct 28, 2014 at 7:28 PM, Zubair Lutfullah Kakakhel
<Zubair.Kakakhel@imgtec.com> wrote:
> Even if CMA is disabled, the for_each_memblock macro expands
> to run reserve_bootmem once. Hence, reserve_bootmem attempts to
> reserve location 0 of size 0.
>
> Add a check to avoid that.
>
> Issue was highlighted during testing with EVA enabled.
> resrve_bootmem used to exit gracefully when passed arguments to
> reserve 0 size location at 0 without EVA.
>
> But with EVA enabled, macros would point to different addresses
> and the code would trigger a BUG.
>
> Signed-off-by: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>
> Tested-by: Markos Chandras <markos.chandras@imgtec.com>
> ---
>  arch/mips/kernel/setup.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/arch/mips/kernel/setup.c b/arch/mips/kernel/setup.c
> index 938f157..eacfd7d 100644
> --- a/arch/mips/kernel/setup.c
> +++ b/arch/mips/kernel/setup.c
> @@ -683,7 +683,8 @@ static void __init arch_mem_init(char **cmdline_p)
>         dma_contiguous_reserve(PFN_PHYS(max_low_pfn));
>         /* Tell bootmem about cma reserved memblock section */
>         for_each_memblock(reserved, reg)
> -               reserve_bootmem(reg->base, reg->size, BOOTMEM_DEFAULT);
> +               if (reg->size != 0)
> +                       reserve_bootmem(reg->base, reg->size, BOOTMEM_DEFAULT);
>  }
>
>  static void __init resource_init(void)
> --
> 1.9.1
>
>
