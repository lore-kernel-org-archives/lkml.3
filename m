Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751887Ab3LKOoy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 09:44:54 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:39415 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707Ab3LKOow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 09:44:52 -0500
Date: Wed, 11 Dec 2013 06:44:47 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Alex Thorlton <athorlton@sgi.com>, Rik van Riel <riel@redhat.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: numa: Guarantee that tlb_flush_pending updates are
 visible before page table updates
Message-ID: <20131211144446.GP4208@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1386690695-27380-1-git-send-email-mgorman@suse.de>
 <20131211132109.GB24125@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131211132109.GB24125@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13121114-0928-0000-0000-0000048D628F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 11, 2013 at 01:21:09PM +0000, Mel Gorman wrote:
> According to documentation on barriers, stores issued before a LOCK can
> complete after the lock implying that it's possible tlb_flush_pending can
> be visible after a page table update. As per revised documentation, this patch
> adds a smp_mb__before_spinlock to guarantee the correct ordering.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Assuming that there is a lock acquisition after calls to
set_tlb_flush_pending():

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

(I don't see set_tlb_flush_pending() in mainline.)

> ---
>  include/linux/mm_types.h | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index c122bb1..a12f2ab 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -482,7 +482,12 @@ static inline bool tlb_flush_pending(struct mm_struct *mm)
>  static inline void set_tlb_flush_pending(struct mm_struct *mm)
>  {
>  	mm->tlb_flush_pending = true;
> -	barrier();
> +
> +	/*
> +	 * Guarantee that the tlb_flush_pending store does not leak into the
> +	 * critical section updating the page tables
> +	 */
> +	smp_mb__before_spinlock();
>  }
>  /* Clearing is done after a TLB flush, which also provides a barrier. */
>  static inline void clear_tlb_flush_pending(struct mm_struct *mm)
> 

