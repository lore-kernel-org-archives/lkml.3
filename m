Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322Ab3KTWYu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 17:24:50 -0500
Received: from smtprelay0102.hostedemail.com ([216.40.44.102]:37258 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751757Ab3KTWYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 17:24:49 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:960:966:967:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2196:2199:2393:2525:2561:2564:2682:2685:2828:2859:2899:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3352:3622:3657:3770:3865:3866:3867:3868:3870:3871:3872:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4250:4321:4385:5007:6117:6119:7652:8599:9010:9025:9388:10004:10400:10848:11026:11232:11253:11658:11854:11914:12043:12214:12438:12517:12519:12555:12679:12740:12776:13019:13069:13095:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL
X-HE-Tag: space82_29c2158cae414
X-Filterd-Recvd-Size: 2270
Message-ID: <1384986285.2164.19.camel@joe-AO722>
Subject: Re: [git pull] vfs.git bits and pieces
From: Joe Perches <joe@perches.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Date: Wed, 20 Nov 2013 14:24:45 -0800
In-Reply-To: <20131120221636.GH10323@ZenIV.linux.org.uk>
References: <20131120174211.GF10323@ZenIV.linux.org.uk>
	 <20131120174712.GG10323@ZenIV.linux.org.uk>
	 <20131120221636.GH10323@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-11-20 at 22:16 +0000, Al Viro wrote:
> While digging in the same area:
> 
> Wrong page freed on preallocate_pmds() failure exit
> 
> Note that pmds[i] is simply uninitialized at that point...
> Granted, it's very hard to hit (you need split page locks
> *and* kmalloc(sizeof(spinlock_t), GFP_KERNEL) failing),
> but the code is obviously bogus.
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
> diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
> index a7cccb6d..36aa999 100644
> --- a/arch/x86/mm/pgtable.c
> +++ b/arch/x86/mm/pgtable.c
> @@ -209,7 +209,7 @@ static int preallocate_pmds(pmd_t *pmds[])
>  		if (!pmd)
>  			failed = true;
>  		if (pmd && !pgtable_pmd_page_ctor(virt_to_page(pmd))) {
> -			free_page((unsigned long)pmds[i]);
> +			free_page((unsigned long)pmd);
>  			pmd = NULL;
>  			failed = true;
>  		}

trivia: It'd probably read better with an else too

		if (!pmd) {
			failed = true;
		} else if (!pgtable_pmd_page_ctor(virt_to_page(pmd))) {
			etc...

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



