Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198AbbAZX6P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 18:58:15 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47789 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100AbbAZX6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 18:58:13 -0500
Date: Mon, 26 Jan 2015 15:58:11 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Toshi Kani <toshi.kani@hp.com>
Cc: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com, arnd@arndb.de,
        linux-mm@kvack.org, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 3/7] mm: Change ioremap to set up huge I/O mappings
Message-Id: <20150126155811.0ade183f5f3f89277d11fde6@linux-foundation.org>
In-Reply-To: <1422314009-31667-4-git-send-email-toshi.kani@hp.com>
References: <1422314009-31667-1-git-send-email-toshi.kani@hp.com>
	<1422314009-31667-4-git-send-email-toshi.kani@hp.com>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Jan 2015 16:13:25 -0700 Toshi Kani <toshi.kani@hp.com> wrote:

> Change ioremap_pud_range() and ioremap_pmd_range() to set up
> huge I/O mappings when their capability is enabled and their
> conditions are met in a given request -- both virtual & physical
> addresses are aligned and its range fufills the mapping size.
> 
> These changes are only enabled when both CONFIG_HUGE_IOMAP
> and CONFIG_HAVE_ARCH_HUGE_VMAP are defined.
> 
> --- a/lib/ioremap.c
> +++ b/lib/ioremap.c
> @@ -81,6 +81,14 @@ static inline int ioremap_pmd_range(pud_t *pud, unsigned long addr,
>  		return -ENOMEM;
>  	do {
>  		next = pmd_addr_end(addr, end);
> +
> +		if (ioremap_pmd_enabled() &&
> +		    ((next - addr) == PMD_SIZE) &&
> +		    !((phys_addr + addr) & (PMD_SIZE-1))) {

IS_ALIGNED might be a little neater here.

> +			pmd_set_huge(pmd, phys_addr + addr, prot);
> +			continue;
> +		}
> +
>  		if (ioremap_pte_range(pmd, addr, next, phys_addr + addr, prot))
>  			return -ENOMEM;
>  	} while (pmd++, addr = next, addr != end);
> @@ -99,6 +107,14 @@ static inline int ioremap_pud_range(pgd_t *pgd, unsigned long addr,
>  		return -ENOMEM;
>  	do {
>  		next = pud_addr_end(addr, end);
> +
> +		if (ioremap_pud_enabled() &&
> +		    ((next - addr) == PUD_SIZE) &&
> +		    !((phys_addr + addr) & (PUD_SIZE-1))) {

And here.

> +			pud_set_huge(pud, phys_addr + addr, prot);
> +			continue;
> +		}
> +
>  		if (ioremap_pmd_range(pud, addr, next, phys_addr + addr, prot))
>  			return -ENOMEM;
>  	} while (pud++, addr = next, addr != end);
