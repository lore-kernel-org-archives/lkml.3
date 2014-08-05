Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089AbaHEPme (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 11:42:34 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:35464 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173AbaHEPmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 11:42:33 -0400
MIME-Version: 1.0
In-Reply-To: <20140722153623.25088.37742.stgit@buzz>
References: <20140722153623.25088.37742.stgit@buzz>
Date: Tue, 5 Aug 2014 19:42:32 +0400
Message-ID: <CALYGNiPGoRskspqTc_u3VSbb+DPvM+jnvhjUuZFh8394bZuP5Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] ARM: LPAE: load upper bits of early TTBR0/TTBR1
From: Konstantin Khlebnikov <koct9i@gmail.com>
To: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Will Deacon <will.deacon@arm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Vitaly Andrianov <vitalya@ti.com>, Cyril Chemparathy <cyril@ti.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 7:36 PM, Konstantin Khlebnikov
<k.khlebnikov@samsung.com> wrote:
> This patch fixes booting when idmap pgd lays above 4gb. Commit
> 4756dcbfd37 mostly had fixed this, but it'd failed to load upper bits.
>
> Also this fixes adding TTBR1_OFFSET to TTRR1: if lower part overflows
> carry flag must be added to the upper part.
>
> Signed-off-by: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
> Cc: Cyril Chemparathy <cyril@ti.com>
> Cc: Vitaly Andrianov <vitalya@ti.com>
> ---
>  arch/arm/mm/proc-v7-3level.S |    7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
>
> diff --git a/arch/arm/mm/proc-v7-3level.S b/arch/arm/mm/proc-v7-3level.S
> index 22e3ad6..f0481dd 100644
> --- a/arch/arm/mm/proc-v7-3level.S
> +++ b/arch/arm/mm/proc-v7-3level.S
> @@ -140,12 +140,11 @@ ENDPROC(cpu_v7_set_pte_ext)
>         mov     \tmp, \ttbr1, lsr #(32 - ARCH_PGD_SHIFT)        @ upper bits
>         mov     \ttbr1, \ttbr1, lsl #ARCH_PGD_SHIFT             @ lower bits
>         addls   \ttbr1, \ttbr1, #TTBR1_OFFSET
> -       mcrr    p15, 1, \ttbr1, \zero, c2                       @ load TTBR1
> +       adcls   \tmp, \tmp, #0


Oops, this carry fixup is wrong. addls above doesn't set carry flag.


> +       mcrr    p15, 1, \ttbr1, \tmp, c2                        @ load TTBR1
>         mov     \tmp, \ttbr0, lsr #(32 - ARCH_PGD_SHIFT)        @ upper bits
>         mov     \ttbr0, \ttbr0, lsl #ARCH_PGD_SHIFT             @ lower bits
> -       mcrr    p15, 0, \ttbr0, \zero, c2                       @ load TTBR0
> -       mcrr    p15, 1, \ttbr1, \zero, c2                       @ load TTBR1
> -       mcrr    p15, 0, \ttbr0, \zero, c2                       @ load TTBR0
> +       mcrr    p15, 0, \ttbr0, \tmp, c2                        @ load TTBR0
>         .endm
>
>         /*
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
