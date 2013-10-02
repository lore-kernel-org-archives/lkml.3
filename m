Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944Ab3JBWex (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 18:34:53 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:60375 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752983Ab3JBWev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 18:34:51 -0400
Date: Wed, 2 Oct 2013 15:34:48 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: David Miller <davem@davemloft.net>
cc: sparclinux@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix generic hugetlb pte check return type.
In-Reply-To: <20131002.142509.1450460988268165850.davem@davemloft.net>
Message-ID: <alpine.DEB.2.02.1310021531030.18461@chino.kir.corp.google.com>
References: <20131002.142509.1450460988268165850.davem@davemloft.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Oct 2013, David Miller wrote:

> The include/asm-generic/hugetlb.h stubs that just vector huge_pte_*()
> calls to the pte_*() implementations won't work in certain situations.
> 
> x86 and sparc, for example, return "unsigned long" from the bit
> checks, and just go "return pte_val(pte) & PTE_BIT_FOO;"
> 

x86 should be safe since it's known that both _PAGE_BIT_RW and 
_PAGE_BIT_DIRTY are <= 32.

> But since huge_pte_*() returns 'int', if any high bits on 64-bit are
> relevant, they get chopped off.
> 
> The net effect is that we can loop forever trying to COW a huge page,
> because the huge_pte_write() check signals false all the time.
> 
> Reported-by: Gurudas Pai <gurudas.pai@oracle.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>

Acked-by: David Rientjes <rientjes@google.com>

> ---
> 
> Anyone mind if I push this through the sparc tree?
> 

Makes sense since it's the only arch that appears affected.

> diff --git a/include/asm-generic/hugetlb.h b/include/asm-generic/hugetlb.h
> index d06079c..99b490b 100644
> --- a/include/asm-generic/hugetlb.h
> +++ b/include/asm-generic/hugetlb.h
> @@ -6,12 +6,12 @@ static inline pte_t mk_huge_pte(struct page *page, pgprot_t pgprot)
>  	return mk_pte(page, pgprot);
>  }
>  
> -static inline int huge_pte_write(pte_t pte)
> +static inline unsigned long huge_pte_write(pte_t pte)
>  {
>  	return pte_write(pte);
>  }
>  
> -static inline int huge_pte_dirty(pte_t pte)
> +static inline unsigned long huge_pte_dirty(pte_t pte)
>  {
>  	return pte_dirty(pte);
>  }
