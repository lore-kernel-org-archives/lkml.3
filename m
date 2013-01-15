Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901Ab3AOM1b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 07:27:31 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:25827 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754065Ab3AOM1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 07:27:30 -0500
X-IronPort-AV: E=Sophos;i="4.84,473,1355097600"; 
   d="scan'208";a="3576844"
Date: Tue, 15 Jan 2013 12:27:27 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v7u1 01/31] x86, mm: Fix page table early allocation
 offset checking
In-Reply-To: <1357260531-11115-2-git-send-email-yinghai@kernel.org>
Message-ID: <alpine.DEB.2.02.1301151227130.4978@kaball.uk.xensource.com>
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org> <1357260531-11115-2-git-send-email-yinghai@kernel.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Jan 2013, Yinghai Lu wrote:
> During debugging loading kernel above 4G, found one page if is not used
> in BRK with early page allocation.
> 
> pgt_buf_top is address that can not be used, so should check if that new
> end is above that top, otherwise last page will not be used.
> 
> Fix that checking and also add print out for every allocation from BRK.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>


>  arch/x86/mm/init.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
> index 6f85de8..c4293cf 100644
> --- a/arch/x86/mm/init.c
> +++ b/arch/x86/mm/init.c
> @@ -47,7 +47,7 @@ __ref void *alloc_low_pages(unsigned int num)
>  						__GFP_ZERO, order);
>  	}
>  
> -	if ((pgt_buf_end + num) >= pgt_buf_top) {
> +	if ((pgt_buf_end + num) > pgt_buf_top) {
>  		unsigned long ret;
>  		if (min_pfn_mapped >= max_pfn_mapped)
>  			panic("alloc_low_page: ran out of memory");
> @@ -61,6 +61,8 @@ __ref void *alloc_low_pages(unsigned int num)
>  	} else {
>  		pfn = pgt_buf_end;
>  		pgt_buf_end += num;
> +		printk(KERN_DEBUG "BRK [%#010lx, %#010lx] PGTABLE\n",
> +			pfn << PAGE_SHIFT, (pgt_buf_end << PAGE_SHIFT) - 1);
>  	}
>  
>  	for (i = 0; i < num; i++) {
> -- 
> 1.7.10.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
