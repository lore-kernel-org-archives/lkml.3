Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246AbaJIKgP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 06:36:15 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:55451 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958AbaJIKgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 06:36:08 -0400
Date: Thu, 9 Oct 2014 12:35:59 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andres Lagar-Cavilla <andreslc@google.com>,
        Gleb Natapov <gleb@kernel.org>, Radim Krcmar <rkrcmar@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sasha.levin@oracle.com>, Jianyu Zhan <nasa4836@gmail.com>,
        Paul Cassella <cassella@cray.com>, Hugh Dickins <hughd@google.com>,
        Peter Feiner <pfeiner@google.com>,
        "\\\"Dr. David Alan Gilbert\\\"" <dgilbert@redhat.com>
Subject: Re: [PATCH 1/4] mm: gup: add FOLL_TRIED
Message-ID: <20141009103559.GK4750@worktop.programming.kicks-ass.net>
References: <1412153797-6667-1-git-send-email-aarcange@redhat.com>
 <1412153797-6667-2-git-send-email-aarcange@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1412153797-6667-2-git-send-email-aarcange@redhat.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 01, 2014 at 10:56:34AM +0200, Andrea Arcangeli wrote:
> From: Andres Lagar-Cavilla <andreslc@google.com>

This needs a changelog....

> Reviewed-by: Radim Krčmář <rkrcmar@redhat.com>
> Signed-off-by: Andres Lagar-Cavilla <andreslc@google.com>
> Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
> ---
>  include/linux/mm.h | 1 +
>  mm/gup.c           | 4 ++++
>  2 files changed, 5 insertions(+)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 8981cc8..0f4196a 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1985,6 +1985,7 @@ static inline struct page *follow_page(struct vm_area_struct *vma,
>  #define FOLL_HWPOISON	0x100	/* check page is hwpoisoned */
>  #define FOLL_NUMA	0x200	/* force NUMA hinting page fault */
>  #define FOLL_MIGRATION	0x400	/* wait for page to replace migration entry */
> +#define FOLL_TRIED	0x800	/* a retry, previous pass started an IO */
>  
>  typedef int (*pte_fn_t)(pte_t *pte, pgtable_t token, unsigned long addr,
>  			void *data);
> diff --git a/mm/gup.c b/mm/gup.c
> index 91d044b..af7ea3e 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -281,6 +281,10 @@ static int faultin_page(struct task_struct *tsk, struct vm_area_struct *vma,
>  		fault_flags |= FAULT_FLAG_ALLOW_RETRY;
>  	if (*flags & FOLL_NOWAIT)
>  		fault_flags |= FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_RETRY_NOWAIT;
> +	if (*flags & FOLL_TRIED) {
> +		VM_WARN_ON_ONCE(fault_flags & FAULT_FLAG_ALLOW_RETRY);
> +		fault_flags |= FAULT_FLAG_TRIED;
> +	}
>  
>  	ret = handle_mm_fault(mm, vma, address, fault_flags);
>  	if (ret & VM_FAULT_ERROR) {
