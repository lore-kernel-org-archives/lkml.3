Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756403Ab3G2OJX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 10:09:23 -0400
Received: from relay.parallels.com ([195.214.232.42]:43394 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755821Ab3G2OJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 10:09:20 -0400
Message-ID: <51F67777.6060609@parallels.com>
Date: Mon, 29 Jul 2013 18:08:55 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] mm: Save soft-dirty bits on file pages
References: <20130726201807.GJ8661@moon>
In-Reply-To: <20130726201807.GJ8661@moon>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.16.114]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/27/2013 12:18 AM, Cyrill Gorcunov wrote:
> Andy reported that if file page get reclaimed we loose soft-dirty bit
> if it was there, so save _PAGE_BIT_SOFT_DIRTY bit when page address
> get encoded into pte entry. Thus when #pf happens on such non-present
> pte we can restore it back.
> 
> Reported-by: Andy Lutomirski <luto@amacapital.net>
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> Cc: Pavel Emelyanov <xemul@parallels.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Matt Mackall <mpm@selenic.com>
> Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> Cc: Marcelo Tosatti <mtosatti@redhat.com>
> Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
> Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> ---

> @@ -57,17 +57,25 @@ static int install_file_pte(struct mm_st
>  		unsigned long addr, unsigned long pgoff, pgprot_t prot)
>  {
>  	int err = -ENOMEM;
> -	pte_t *pte;
> +	pte_t *pte, ptfile;
>  	spinlock_t *ptl;
>  
>  	pte = get_locked_pte(mm, addr, &ptl);
>  	if (!pte)
>  		goto out;
>  
> -	if (!pte_none(*pte))
> +	ptfile = pgoff_to_pte(pgoff);
> +
> +	if (!pte_none(*pte)) {
> +#ifdef CONFIG_MEM_SOFT_DIRTY
> +		if (pte_present(*pte) &&
> +		    pte_soft_dirty(*pte))

I think there's no need in wrapping every such if () inside #ifdef CONFIG_...,
since the pte_soft_dirty() routine itself would be 0 for non-soft-dirty case
and compiler would optimize this code out.

> +			pte_file_mksoft_dirty(ptfile);
> +#endif
>  		zap_pte(mm, vma, addr, pte);
> +	}
>  
> -	set_pte_at(mm, addr, pte, pgoff_to_pte(pgoff));
> +	set_pte_at(mm, addr, pte, ptfile);
>  	/*
>  	 * We don't need to run update_mmu_cache() here because the "file pte"
>  	 * being installed by install_file_pte() is not a real pte - it's a
