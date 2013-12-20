Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952Ab3LTWj7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 17:39:59 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:48104 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751810Ab3LTWj5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 17:39:57 -0500
Message-ID: <52B4C71D.9030904@ti.com>
Date: Fri, 20 Dec 2013 17:39:25 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Russell King <linux@arm.linux.org.uk>
CC: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm/ARM: fix ARMs __ffs() to conform to avoid warning
 with NO_BOOTMEM
References: <1386981486-3173-1-git-send-email-santosh.shilimkar@ti.com>
In-Reply-To: <1386981486-3173-1-git-send-email-santosh.shilimkar@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell,

On Friday 13 December 2013 07:38 PM, Santosh Shilimkar wrote:
> Building ARM with NO_BOOTMEM generates below warning.
> 
> mm/nobootmem.c: In function _____free_pages_memory___:
> mm/nobootmem.c:88:11: warning: comparison of distinct pointer types lacks a cast
> 
> 	order = min(MAX_ORDER - 1UL, __ffs(start));
> 
> ARM's __ffs() differs from other architectures in that it ends up being
> an int, whereas almost everyone else is unsigned long.
> 
> So fix ARMs __ffs() to conform to other architectures. Suggested by
> Russell King <linux@arm.linux.org.uk>
> 
> Some more details in below thread -
> 	https://lkml.org/lkml/2013/12/9/807
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Russell King <linux@arm.linux.org.uk>
> Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> ---
Is this patch inline with what we discussed off-list ?
If you ack it, it can go into the Andrews tree to kill that one last
warning with the memblock series. Thanks


>  arch/arm/include/asm/bitops.h |   23 +++++++++++++++++++----
>  1 file changed, 19 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm/include/asm/bitops.h b/arch/arm/include/asm/bitops.h
> index e691ec9..5f41d81 100644
> --- a/arch/arm/include/asm/bitops.h
> +++ b/arch/arm/include/asm/bitops.h
> @@ -270,10 +270,25 @@ static inline int fls(int x)
>  	return ret;
>  }
>  
> -#define __fls(x) (fls(x) - 1)
> -#define ffs(x) ({ unsigned long __t = (x); fls(__t & -__t); })
> -#define __ffs(x) (ffs(x) - 1)
> -#define ffz(x) __ffs( ~(x) )
> +static inline unsigned long __fls(unsigned long x)
> +{
> +	return fls(x) - 1;
> +}
> +
> +static inline int ffs(int x)
> +{
> +	return fls(x & -x);
> +}
> +
> +static inline unsigned long __ffs(unsigned long x)
> +{
> +	return ffs(x) - 1;
> +}
> +
> +static inline unsigned long ffz(unsigned long x)
> +{
> +	return __ffs(~x);
> +}
>  
>  #endif
>  
> 

