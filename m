Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756795Ab3JJUAU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 16:00:20 -0400
Received: from a9-42.smtp-out.amazonses.com ([54.240.9.42]:48357 "EHLO
	a9-42.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755783Ab3JJUAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 16:00:18 -0400
Date: Thu, 10 Oct 2013 20:00:14 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH 34/34] mm: dynamically allocate page->ptl if it cannot
 be embedded to struct page
In-Reply-To: <1381428359-14843-35-git-send-email-kirill.shutemov@linux.intel.com>
Message-ID: <00000141a3f48ada-37ee9c14-2f2b-40a2-93f4-70258363351b-000000@email.amazonses.com>
References: <1381428359-14843-1-git-send-email-kirill.shutemov@linux.intel.com> <1381428359-14843-35-git-send-email-kirill.shutemov@linux.intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.10.10-54.240.9.42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Oct 2013, Kirill A. Shutemov wrote:

> +static inline bool ptlock_alloc(struct page *page)
> +{
> +	if (sizeof(spinlock_t) > sizeof(page->ptl))
> +		return __ptlock_alloc(page);
> +	return true;
> +}

Could you make the check a CONFIG option? CONFIG_PTLOCK_DOES_NOT_FIT_IN_PAGE_STRUCT or
so?

> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -147,7 +147,10 @@ struct page {
>  						 * system if PG_buddy is set.
>  						 */
>  #if USE_SPLIT_PTE_PTLOCKS
> -		spinlock_t ptl;
> +		unsigned long ptl; /* It's spinlock_t if it fits to long,
> +				    * otherwise it's pointer to dynamicaly
> +				    * allocated spinlock_t.
> +				    */

If you had such a CONFIG option then you could use the proper type here.

#ifdef CONFIG_PTLOCK_NOT_FITTING
	spinlock_t *ptl;
#else
	spinlock_t ptl;
#endif

Or some such thing?
