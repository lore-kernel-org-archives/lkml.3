Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757625AbaIRGPj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 02:15:39 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:58373 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757602AbaIRGPh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 02:15:37 -0400
Date: Thu, 18 Sep 2014 09:15:33 +0300
From: Gleb Natapov <gleb@kernel.org>
To: Andres Lagar-Cavilla <andreslc@google.com>
Cc: Radim Krcmar <rkrcmar@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Rik van Riel <riel@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Mel Gorman <mgorman@suse.de>, Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Sasha Levin <sasha.levin@oracle.com>, Jianyu Zhan <nasa4836@gmail.com>,
        Paul Cassella <cassella@cray.com>, Hugh Dickins <hughd@google.com>,
        Peter Feiner <pfeiner@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2] kvm: Faults which trigger IO release the mmap_sem
Message-ID: <20140918061533.GD30733@minantech.com>
References: <1410811885-17267-1-git-send-email-andreslc@google.com>
 <1410976308-7683-1-git-send-email-andreslc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1410976308-7683-1-git-send-email-andreslc@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2014 at 10:51:48AM -0700, Andres Lagar-Cavilla wrote:
> When KVM handles a tdp fault it uses FOLL_NOWAIT. If the guest memory
> has been swapped out or is behind a filemap, this will trigger async
> readahead and return immediately. The rationale is that KVM will kick
> back the guest with an "async page fault" and allow for some other
> guest process to take over.
> 
> If async PFs are enabled the fault is retried asap from an async
> workqueue. If not, it's retried immediately in the same code path. In
> either case the retry will not relinquish the mmap semaphore and will
> block on the IO. This is a bad thing, as other mmap semaphore users
> now stall as a function of swap or filemap latency.
> 
> This patch ensures both the regular and async PF path re-enter the
> fault allowing for the mmap semaphore to be relinquished in the case
> of IO wait.
> 
Reviewed-by: Gleb Natapov <gleb@kernel.org>

> Reviewed-by: Radim Krčmář <rkrcmar@redhat.com>
> Signed-off-by: Andres Lagar-Cavilla <andreslc@google.com>
> 
> ---
> v1 -> v2
> 
> * WARN_ON_ONCE -> VM_WARN_ON_ONCE
> * pagep == NULL skips the final retry
> * kvm_gup_retry -> kvm_gup_io
> * Comment updates throughout
> ---
>  include/linux/kvm_host.h | 11 +++++++++++
>  include/linux/mm.h       |  1 +
>  mm/gup.c                 |  4 ++++
>  virt/kvm/async_pf.c      |  4 +---
>  virt/kvm/kvm_main.c      | 49 +++++++++++++++++++++++++++++++++++++++++++++---
>  5 files changed, 63 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 3addcbc..4c1991b 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -198,6 +198,17 @@ int kvm_setup_async_pf(struct kvm_vcpu *vcpu, gva_t gva, unsigned long hva,
>  int kvm_async_pf_wakeup_all(struct kvm_vcpu *vcpu);
>  #endif
>  
> +/*
> + * Carry out a gup that requires IO. Allow the mm to relinquish the mmap
> + * semaphore if the filemap/swap has to wait on a page lock. pagep == NULL
> + * controls whether we retry the gup one more time to completion in that case.
> + * Typically this is called after a FAULT_FLAG_RETRY_NOWAIT in the main tdp
> + * handler.
> + */
> +int kvm_get_user_page_io(struct task_struct *tsk, struct mm_struct *mm,
> +			 unsigned long addr, bool write_fault,
> +			 struct page **pagep);
> +
>  enum {
>  	OUTSIDE_GUEST_MODE,
>  	IN_GUEST_MODE,
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index ebc5f90..13e585f7 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -2011,6 +2011,7 @@ static inline struct page *follow_page(struct vm_area_struct *vma,
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
> diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
> index d6a3d09..5ff7f7f 100644
> --- a/virt/kvm/async_pf.c
> +++ b/virt/kvm/async_pf.c
> @@ -80,9 +80,7 @@ static void async_pf_execute(struct work_struct *work)
>  
>  	might_sleep();
>  
> -	down_read(&mm->mmap_sem);
> -	get_user_pages(NULL, mm, addr, 1, 1, 0, NULL, NULL);
> -	up_read(&mm->mmap_sem);
> +	kvm_get_user_page_io(NULL, mm, addr, 1, NULL);
>  	kvm_async_page_present_sync(vcpu, apf);
>  
>  	spin_lock(&vcpu->async_pf.lock);
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 7ef6b48..fa8a565 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1115,6 +1115,43 @@ static int get_user_page_nowait(struct task_struct *tsk, struct mm_struct *mm,
>  	return __get_user_pages(tsk, mm, start, 1, flags, page, NULL, NULL);
>  }
>  
> +int kvm_get_user_page_io(struct task_struct *tsk, struct mm_struct *mm,
> +			 unsigned long addr, bool write_fault,
> +			 struct page **pagep)
> +{
> +	int npages;
> +	int locked = 1;
> +	int flags = FOLL_TOUCH | FOLL_HWPOISON |
> +		    (pagep ? FOLL_GET : 0) |
> +		    (write_fault ? FOLL_WRITE : 0);
> +
> +	/*
> +	 * If retrying the fault, we get here *not* having allowed the filemap
> +	 * to wait on the page lock. We should now allow waiting on the IO with
> +	 * the mmap semaphore released.
> +	 */
> +	down_read(&mm->mmap_sem);
> +	npages = __get_user_pages(tsk, mm, addr, 1, flags, pagep, NULL,
> +				  &locked);
> +	if (!locked) {
> +		VM_BUG_ON(npages != -EBUSY);
> +
> +		if (!pagep)
> +			return 0;
> +
> +		/*
> +		 * The previous call has now waited on the IO. Now we can
> +		 * retry and complete. Pass TRIED to ensure we do not re
> +		 * schedule async IO (see e.g. filemap_fault).
> +		 */
> +		down_read(&mm->mmap_sem);
> +		npages = __get_user_pages(tsk, mm, addr, 1, flags | FOLL_TRIED,
> +					  pagep, NULL, NULL);
> +	}
> +	up_read(&mm->mmap_sem);
> +	return npages;
> +}
> +
>  static inline int check_user_page_hwpoison(unsigned long addr)
>  {
>  	int rc, flags = FOLL_TOUCH | FOLL_HWPOISON | FOLL_WRITE;
> @@ -1177,9 +1214,15 @@ static int hva_to_pfn_slow(unsigned long addr, bool *async, bool write_fault,
>  		npages = get_user_page_nowait(current, current->mm,
>  					      addr, write_fault, page);
>  		up_read(&current->mm->mmap_sem);
> -	} else
> -		npages = get_user_pages_fast(addr, 1, write_fault,
> -					     page);
> +	} else {
> +		/*
> +		 * By now we have tried gup_fast, and possibly async_pf, and we
> +		 * are certainly not atomic. Time to retry the gup, allowing
> +		 * mmap semaphore to be relinquished in the case of IO.
> +		 */
> +		npages = kvm_get_user_page_io(current, current->mm, addr,
> +					      write_fault, page);
> +	}
>  	if (npages != 1)
>  		return npages;
>  
> -- 
> 2.1.0.rc2.206.gedb03e5
> 

--
			Gleb.
