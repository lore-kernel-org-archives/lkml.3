Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049AbaEHEGB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 00:06:01 -0400
Received: from mga03.intel.com ([143.182.124.21]:27048 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750947AbaEHEF6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 00:05:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1008,1389772800"; 
   d="scan'208";a="429241900"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH v1 03/11] perf: Allow for multiple ring buffers per event
In-Reply-To: <20140507152640.GR30445@twins.programming.kicks-ass.net>
References: <1391683834-29868-1-git-send-email-alexander.shishkin@linux.intel.com> <1391683834-29868-4-git-send-email-alexander.shishkin@linux.intel.com> <20140507152640.GR30445@twins.programming.kicks-ass.net>
User-Agent: Notmuch/0.17+49~gaa57e9d (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Thu, 08 May 2014 07:05:26 +0300
Message-ID: <87ppjodiex.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

> How about something like this for the itrace thing?

It's much nicer than the page swizzling draft I was about to send you.

> You would mmap() the regular buffer; when write ->aux_{offset,size} in
> the control page. After which you can do a second mmap() with the .pgoff
> matching the aux_offset you gave and .length matching the aux_size you
> gave.

Why do we need aux_{offset,size} at all, then? Userspace should know how
they mmap()ed it.

> This way the mmap() content still looks like a single linear file (could
> be sparse if you leave a hole, although we could require the aux_offset
> to match the end of the data section).
>
> And there is still the single event->rb, not more.

Fair enough.

> Then, when data inside that aux data store changes they should inject an
> PERF_RECORD_AUX to indicate this did happen, which ties it back into the
> normal event flow.
>
> With this there should be no difficult page table tricks or anything.

True.

> The patch is way incomplete but should sketch enough of the idea..

Can I take it over?

> So the aux_head/tail values should also be in the file space and not
> start at 0 again, similar for the offsets in the AUX record.

With PERF_RECORD_AUX carrying offset and size, we shouldn't need
aux_{head,tail} either, don't you think?

>
> ---
>  include/uapi/linux/perf_event.h | 19 +++++++++++++++
>  kernel/events/core.c            | 51 +++++++++++++++++++++++++++++++++++++----
>  kernel/events/internal.h        |  6 +++++
>  kernel/events/ring_buffer.c     |  8 +------
>  4 files changed, 72 insertions(+), 12 deletions(-)
>
> diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
> index 853bc1ccb395..adef7c0f1e7c 100644
> --- a/include/uapi/linux/perf_event.h
> +++ b/include/uapi/linux/perf_event.h
> @@ -491,6 +491,13 @@ struct perf_event_mmap_page {
>  	 */
>  	__u64   data_head;		/* head in the data section */
>  	__u64	data_tail;		/* user-space written tail */
> +	__u64	data_offset;
> +	__u64	data_size;
> +
> +	__u64	aux_head;
> +	__u64	aux_tail;
> +	__u64	aux_offset;
> +	__u64	aux_size;
>  };
>  
>  #define PERF_RECORD_MISC_CPUMODE_MASK		(7 << 0)
> @@ -705,6 +712,18 @@ enum perf_event_type {
>  	 */
>  	PERF_RECORD_MMAP2			= 10,
>  
> +	/*
> +	 * Records that new data landed in the AUX buffer part.
> +	 *
> +	 * struct {
> +	 * 	struct perf_event_header	header;
> +	 *
> +	 * 	u64				aux_offset;
> +	 * 	u64				aux_size;
> +	 * };
> +	 */
> +	PERF_RECORD_AUX				= 11,
> +
>  	PERF_RECORD_MAX,			/* non-ABI */
>  };
>  
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index 5129b1201050..993995a23b73 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -4016,7 +4016,7 @@ static void perf_mmap_close(struct vm_area_struct *vma)
>  
>  static const struct vm_operations_struct perf_mmap_vmops = {
>  	.open		= perf_mmap_open,
> -	.close		= perf_mmap_close,
> +	.close		= perf_mmap_close, /* non mergable */
>  	.fault		= perf_mmap_fault,
>  	.page_mkwrite	= perf_mmap_fault,
>  };
> @@ -4030,6 +4030,7 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
>  	struct ring_buffer *rb;
>  	unsigned long vma_size;
>  	unsigned long nr_pages;
> +	unsigned long pgoff;
>  	long user_extra, extra;
>  	int ret = 0, flags = 0;
>  
> @@ -4045,7 +4046,50 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
>  		return -EINVAL;
>  
>  	vma_size = vma->vm_end - vma->vm_start;
> -	nr_pages = (vma_size / PAGE_SIZE) - 1;
> +
> +	if (vma->vm_pgoff == 0) {
> +		nr_pages = (vma_size / PAGE_SIZE) - 1;
> +	} else {
> +		if (!event->rb)
> +			return -EINVAL;
> +
> +		nr_pages = vma_size / PAGE_SIZE;
> +
> +		mutex_lock(&event->mmap_mutex);
> +		ret = -EINVAL;
> +		if (!event->rb)
> +			goto err_aux_unlock;
> +
> +		if (!atomic_inc_not_zero(&event->rb->mmap_count))
> +			goto err_aux_unlock;
> +
> +		if (userpg->aux_offset < userpg->data_offset + userpg->data_size)
> +			goto err_aux_unlock;

The data_{offset,size} seem to be only set by userspace too, maybe we
can do away with these altogether unless we want to allow for it to be a
sparse file?

> +		pgoff = userpg->aux_offset;

..and simply do a

                pgoff = event->rb->nr_pages + 1;

?

> +		if (pgoff & ~PAGE_MASK)
> +			goto err_aux_unlock;
> +
> +		pgoff >>= PAGE_SHIFT;
> +		if (pgoff != vma->vm_pgoff)
> +			goto err_aux_unlock;
> +
> +		/* XXX do we want to allow !power_of_2 sizes, for AUX?  */
> +		if (nr_pages == 0 || !is_power_of_2(nr_pages))
> +			goto err_aux_unlock;
> +
> +		if (vma_size != PAGE_SIZE * nr_pages)
> +			goto err_aux_unlock;
> +
> +		if (userpg->aux_size != vma_size)
> +			goto err_aux_unlock;
> +			
> +		ret = rb_alloc_aux(event->rb, userpg->aux_offset >> PAGE_SHIFT, nr_pages);
> +
> +err_aux_unlock:
> +		mutex_unlock(&event->mmap_mutex);
> +		return ret;
> +	}
>  
>  	/*
>  	 * If we have rb pages ensure they're a power-of-two number, so we
> @@ -4057,9 +4101,6 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
>  	if (vma_size != PAGE_SIZE * (1 + nr_pages))
>  		return -EINVAL;
>  
> -	if (vma->vm_pgoff != 0)
> -		return -EINVAL;
> -
>  	WARN_ON_ONCE(event->ctx->parent_ctx);
>  again:
>  	mutex_lock(&event->mmap_mutex);
> diff --git a/kernel/events/internal.h b/kernel/events/internal.h
> index 569b218782ad..6258aaa36097 100644
> --- a/kernel/events/internal.h
> +++ b/kernel/events/internal.h
> @@ -36,6 +36,7 @@ struct ring_buffer {
>  	struct user_struct		*mmap_user;
>  
>  	struct perf_event_mmap_page	*user_page;
> +	struct radix_tree_root		page_tree;
>  	void				*data_pages[0];
>  };
>  
> diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
> index 146a5792b1d2..b82505325df0 100644
> --- a/kernel/events/ring_buffer.c
> +++ b/kernel/events/ring_buffer.c
> @@ -251,13 +251,7 @@ ring_buffer_init(struct ring_buffer *rb, long watermark, int flags)
>  struct page *
>  perf_mmap_to_page(struct ring_buffer *rb, unsigned long pgoff)
>  {
> -	if (pgoff > rb->nr_pages)
> -		return NULL;
> -
> -	if (pgoff == 0)
> -		return virt_to_page(rb->user_page);
> -
> -	return virt_to_page(rb->data_pages[pgoff - 1]);
> +	return radix_tree_lookup(&rb->page_tree, pgoff);

This can instead call into the underlying driver, which will likely
maintain an array similar to data_pages[] anyway.

Regards,
--
Alex
