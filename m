Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755768AbaJ1LGR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 07:06:17 -0400
Received: from www.linutronix.de ([62.245.132.108]:45871 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755733AbaJ1LGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:06:13 -0400
Date: Tue, 28 Oct 2014 12:06:03 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Minfei Huang <mnfhuang@gmail.com>
cc: mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: Avoid overlap the fixmap area on i386
In-Reply-To: <6B680A9E-6CE9-4C96-934B-CB01DCB58278@gmail.com>
Message-ID: <alpine.DEB.2.11.1410281159590.5308@nanos>
References: <6B680A9E-6CE9-4C96-934B-CB01DCB58278@gmail.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Oct 2014, Minfei Huang wrote:

> From: Minfei Huang <mnfhuang@gmail.com>
> 
> It is a problem when configuring high memory off where the vmalloc
> reserve area could end up overlapping the early_ioremap fixmap
> area on i386.
> 
> The ordering of the VMALLOC_RESERVE space is:
> FIXADDR_TOP
>                        fixed_addresses
> FIXADDR_START
>                        early_ioremap fixed addresses
> FIXADDR_BOOT_START
>                        Persistent kmap area
> PKMAP_BASE
> VMALLOC_END
>                        Vmalloc area
> VMALLOC_START
> high_memory
> 
> The available address we can use is lower than FIXADDR_BOOT_START. So
> We will set the kmap boundary below the FIXADDR_BOOT_START, if configure
> the high memory.
> 
> If we configure the high memory, the vmalloc reserve area should end
> up to PKMAP_BASE, otherwise should end up to FIXADDR_BOOT_START.

Which is not really a problem, because the FIXADDR_BOOT area is only
used during boot for early_ioremap() and it's unused when ioremap() is
functional. vmalloc becomes available after early boot so the
FIXADDR_BOOT area is available for reuse.

Though in the highmem case the PKMAP area is not overlapping the
FIXADDR_BOOT area. So having the !highmem case use the same layout
(minus the PKMAP area) makes sense.

Acked-by: Thomas Gleixner <tglx@linutronix.de>

> Signed-off-by: Minfei Huang <mnfhuang@gmail.com>
> ---
> arch/x86/include/asm/pgtable_32_types.h | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/pgtable_32_types.h b/arch/x86/include/asm/pgtable_32_types.h
> index ed5903b..2ac5fc8 100644
> --- a/arch/x86/include/asm/pgtable_32_types.h
> +++ b/arch/x86/include/asm/pgtable_32_types.h
> @@ -43,7 +43,7 @@ extern bool __vmalloc_start_set; /* set once high_memory is set */
> #ifdef CONFIG_HIGHMEM
> # define VMALLOC_END	(PKMAP_BASE - 2 * PAGE_SIZE)
> #else
> -# define VMALLOC_END	(FIXADDR_START - 2 * PAGE_SIZE)
> +# define VMALLOC_END	(FIXADDR_BOOT_START - 2 * PAGE_SIZE)
> #endif
> 
> #define MODULES_VADDR	VMALLOC_START
> -- 
> 1.8.3.1
