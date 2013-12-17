Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609Ab3LQHZL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 02:25:11 -0500
Received: from mail-oa0-f41.google.com ([209.85.219.41]:51141 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690Ab3LQHZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 02:25:09 -0500
MIME-Version: 1.0
In-Reply-To: <1387256873-21350-4-git-send-email-john.stultz@linaro.org>
References: <1387256873-21350-1-git-send-email-john.stultz@linaro.org>
	<1387256873-21350-4-git-send-email-john.stultz@linaro.org>
Date: Mon, 16 Dec 2013 23:25:08 -0800
X-Google-Sender-Auth: DWx_EaqindMK1pW11ZEivm1qWJk
Message-ID: <CAMbhsRRSyrnG_XMHAyNyx4ApwQGOsn0uv2E3TVWDtV-WptzpyQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] staging: ion: Avoid using rt_mutexes directly.
From: Colin Cross <ccross@android.com>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        Greg KH <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 16, 2013 at 9:07 PM, John Stultz <john.stultz@linaro.org> wrote:
> RT_MUTEXES can be configured out of the kernel, causing compile
> problems with ION.
>
> To quote Colin:
> "rt_mutexes were added with the deferred freeing feature.  Heaps need
> to return zeroed memory to userspace, but zeroing the memory on every
> allocation was causing performance issues.  We added a SCHED_IDLE
> thread to zero memory in the background after freeing, but locking the
> heap from the SCHED_IDLE thread might block a high priority allocation
> thread for a long time.
>
> The lock is only used to protect the heap's free_list and
> free_list_size members, and is not held for any long or sleeping
> operations.  Converting to a spinlock should prevent priority
> inversion without using the rt_mutex.  I'd also rename it to free_lock
> to so it doesn't get used as a general heap lock."
>
> Thus this patch converts the rt_mutex usage to a spinlock and
> renames the lock free_lock to be more clear as to its use.
>
> I also had to change a bit of logic in ion_heap_freelist_drain()
> despite the for loop being a for_each_entry_safe(), I was still
> seeing list corruption or buffer sg table corruption if I dropped
> the lock before calling ion_buffer_destroy().
>
> Not being able to sort out exactly why, I borrowed the loop structure
> from ion_heap_deferred_free() and that works in my testing w/o issue.
>
> Not sure if its the mixing of list traversal methods causing the issue?
> Thoughts would be appreciated.

list_for_each_entry_safe just stores the next pointer to allow
deleting the current pointer, but that isn't safe if you follow my
suggestion to drop the lock because the next pointer could also become
invalid, so the while loop is necessary.

> Cc: Colin Cross <ccross@android.com>
> Cc: Android Kernel Team <kernel-team@android.com>
> Cc: Greg KH <gregkh@linuxfoundation.org>
> Reported-by: Jim Davis <jim.epost@gmail.com>
> Signed-off-by: John Stultz <john.stultz@linaro.org>
> ---
>  drivers/staging/android/ion/ion_heap.c | 31 +++++++++++++++++++------------
>  drivers/staging/android/ion/ion_priv.h |  2 +-
>  2 files changed, 20 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/staging/android/ion/ion_heap.c b/drivers/staging/android/ion/ion_heap.c
> index 9cf5622..72fe74b 100644
> --- a/drivers/staging/android/ion/ion_heap.c
> +++ b/drivers/staging/android/ion/ion_heap.c
> @@ -160,10 +160,10 @@ int ion_heap_pages_zero(struct page *page, size_t size, pgprot_t pgprot)
>
>  void ion_heap_freelist_add(struct ion_heap *heap, struct ion_buffer *buffer)
>  {
> -       rt_mutex_lock(&heap->lock);
> +       spin_lock(&heap->free_lock);
>         list_add(&buffer->list, &heap->free_list);
>         heap->free_list_size += buffer->size;
> -       rt_mutex_unlock(&heap->lock);
> +       spin_unlock(&heap->free_lock);
>         wake_up(&heap->waitqueue);
>  }
>
> @@ -171,34 +171,41 @@ size_t ion_heap_freelist_size(struct ion_heap *heap)
>  {
>         size_t size;
>
> -       rt_mutex_lock(&heap->lock);
> +       spin_lock(&heap->free_lock);
>         size = heap->free_list_size;
> -       rt_mutex_unlock(&heap->lock);
> +       spin_unlock(&heap->free_lock);
>
>         return size;
>  }
>
>  size_t ion_heap_freelist_drain(struct ion_heap *heap, size_t size)
>  {
> -       struct ion_buffer *buffer, *tmp;
> +       struct ion_buffer *buffer;
>         size_t total_drained = 0;
>
>         if (ion_heap_freelist_size(heap) == 0)
>                 return 0;
>
> -       rt_mutex_lock(&heap->lock);
> +       spin_lock(&heap->free_lock);
>         if (size == 0)
>                 size = heap->free_list_size;
>
> -       list_for_each_entry_safe(buffer, tmp, &heap->free_list, list) {
> +       while (true) {
I'd use while (!list_empty(&heap->free_list)), it makes it clearer
what the loop is for.
