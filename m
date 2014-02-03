Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751872AbaBCIsT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 03:48:19 -0500
Received: from navarro.puc.rediris.es ([130.206.18.131]:35210 "EHLO
	navarro.puc.rediris.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109AbaBCIsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 03:48:18 -0500
X-Greylist: delayed 922 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Feb 2014 03:48:18 EST
X-Envelope-From: paubert@iram.es
Date: Mon, 3 Feb 2014 09:32:36 +0100
From: Gabriel Paubert <paubert@iram.es>
To: Michael Moese <michael.moese@men.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] powerpc: add ioremap_wt
Message-ID: <20140203083236.GA30407@visitor2.iram.es>
References: <1391411809-1845-1-git-send-email-michael.moese@men.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391411809-1845-1-git-send-email-michael.moese@men.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Spamina-Bogosity: Ham
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 03, 2014 at 08:16:49AM +0100, Michael Moese wrote:
> Allow for IO memory to be mapped cacheable for performing
> PCI read bursts.
> 
> Signed-off-by: Michael Moese <michael.moese@men.de>
> ---
>  arch/powerpc/include/asm/io.h | 3 +++
>  arch/powerpc/mm/pgtable_32.c  | 8 ++++++++
>  2 files changed, 11 insertions(+)
> 
> diff --git a/arch/powerpc/include/asm/io.h b/arch/powerpc/include/asm/io.h
> index 45698d5..9591fff 100644
> --- a/arch/powerpc/include/asm/io.h
> +++ b/arch/powerpc/include/asm/io.h
> @@ -631,6 +631,8 @@ static inline void iosync(void)
>   *
>   * * ioremap_wc enables write combining
>   *
> + * * ioremap_wc enables write thru

Typo: _wc -> _wt

Looks fine in principle, but there is a significant difference with wc
on x86, where read accesses always go to the bus (no read caching).

	Gabriel

> + *
>   * * iounmap undoes such a mapping and can be hooked
>   *
>   * * __ioremap_at (and the pending __iounmap_at) are low level functions to
> @@ -652,6 +654,7 @@ extern void __iomem *ioremap(phys_addr_t address, unsigned long size);
>  extern void __iomem *ioremap_prot(phys_addr_t address, unsigned long size,
>  				  unsigned long flags);
>  extern void __iomem *ioremap_wc(phys_addr_t address, unsigned long size);
> +extern void __iomem *ioremap_wt(phys_addr_t address, unsigned long size);
>  #define ioremap_nocache(addr, size)	ioremap((addr), (size))
>  
>  extern void iounmap(volatile void __iomem *addr);
> diff --git a/arch/powerpc/mm/pgtable_32.c b/arch/powerpc/mm/pgtable_32.c
> index 51f8795..9ab0a54 100644
> --- a/arch/powerpc/mm/pgtable_32.c
> +++ b/arch/powerpc/mm/pgtable_32.c
> @@ -141,6 +141,14 @@ ioremap_wc(phys_addr_t addr, unsigned long size)
>  EXPORT_SYMBOL(ioremap_wc);
>  
>  void __iomem *
> +ioremap_wt(phys_addr_t addr, unsigned long size)
> +{
> +	return __ioremap_caller(addr, size, _PAGE_WRITETHRU,
> +				__builtin_return_address(0));
> +}
> +EXPORT_SYMBOL(ioremap_wt);
> +
> +void __iomem *
>  ioremap_prot(phys_addr_t addr, unsigned long size, unsigned long flags)
>  {
>  	/* writeable implies dirty for kernel addresses */
> -- 
> 1.8.5.3
> 
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev
