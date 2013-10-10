Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757403Ab3JJUTT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 16:19:19 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40900 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756676Ab3JJUTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 16:19:16 -0400
Date: Thu, 10 Oct 2013 21:18:05 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH 11/34] arm: handle pgtable_page_ctor() fail
Message-ID: <20131010201805.GR25034@n2100.arm.linux.org.uk>
References: <1381428359-14843-1-git-send-email-kirill.shutemov@linux.intel.com> <1381428359-14843-12-git-send-email-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381428359-14843-12-git-send-email-kirill.shutemov@linux.intel.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So, all I see is this patch, with such a brilliant description which
describes what this change is about, why it is being made, and so
forth, and you're sending it to me, presumably because you want me to
do something with it.  No, not really.

What context do I have to say whether this is correct or not?  How can
I test it when the mainline version of pgtable_page_ctor returns void,
so if I were to apply this patch I'd get compile errors.

Oh, I guess you're changing pgtable_page_ctor() in some way.  What is
the nature of that change?

Please, I'm not a mind reader.  Please ensure that your "generic" patch
of your series reaches the appropriate recipients: if you don't want to
explicitly Cc: all the people individually, please at least copy all
relevant mailing lists found for the entire series.

(No, I am not on the excessively noisy linux-arch: I dropped off it
years ago because it just became yet another mailing list to endlessly
talk mainly about x86 rather than being a separate list to linux-kernel
which discussed problems relevant to many arch maintainers.)

Thanks.

On Thu, Oct 10, 2013 at 09:05:36PM +0300, Kirill A. Shutemov wrote:
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> ---
>  arch/arm/include/asm/pgalloc.h | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm/include/asm/pgalloc.h b/arch/arm/include/asm/pgalloc.h
> index 943504f53f..78a7793616 100644
> --- a/arch/arm/include/asm/pgalloc.h
> +++ b/arch/arm/include/asm/pgalloc.h
> @@ -102,12 +102,14 @@ pte_alloc_one(struct mm_struct *mm, unsigned long addr)
>  #else
>  	pte = alloc_pages(PGALLOC_GFP, 0);
>  #endif
> -	if (pte) {
> -		if (!PageHighMem(pte))
> -			clean_pte_table(page_address(pte));
> -		pgtable_page_ctor(pte);
> +	if (!pte)
> +		return NULL;
> +	if (!PageHighMem(pte))
> +		clean_pte_table(page_address(pte));
> +	if (!pgtable_page_ctor(pte)) {
> +		__free_page(pte);
> +		return NULL;
>  	}
> -
>  	return pte;
>  }
>  
> -- 
> 1.8.4.rc3
> 
