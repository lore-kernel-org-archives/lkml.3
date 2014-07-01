Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392AbaGABWR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 21:22:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39741 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750742AbaGABWQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 21:22:16 -0400
Date: Mon, 30 Jun 2014 21:21:46 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] hwpoison: Fix race with changing page during offlining v2
Message-ID: <20140701012146.GA23311@nhori.redhat.com>
References: <1404174736-17480-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404174736-17480-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2014 at 05:32:16PM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> When a hwpoison page is locked it could change state
> due to parallel modifications.  Check after the lock
> if the page is still the same compound page.
> 
> [v2: Removed earlier non LRU check which should be already
> covered elsewhere]
> 
> Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

Acked-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

Is it -stable matter?
Maybe 2.6.38+ can profit from this.

Thanks,
Naoya Horiguchi

> ---
>  mm/memory-failure.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index cd8989c..99e5077 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -1168,6 +1168,16 @@ int memory_failure(unsigned long pfn, int trapno, int flags)
>  	lock_page(hpage);
>  
>  	/*
> +	 * The page could have changed compound pages during the locking.
> +	 * If this happens just bail out.
> +	 */
> +	if (compound_head(p) != hpage) {
> +		action_result(pfn, "different compound page after locking", IGNORED);
> +		res = -EBUSY;
> +		goto out;
> +	}
> +
> +	/*
>  	 * We use page flags to determine what action should be taken, but
>  	 * the flags can be modified by the error containment action.  One
>  	 * example is an mlocked page, where PG_mlocked is cleared by
> -- 
> 1.9.3
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 
