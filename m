Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922AbaDKIi3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 04:38:29 -0400
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:37325 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753107AbaDKIi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 04:38:26 -0400
Message-ID: <5347A9FD.2070706@vmware.com>
Date: Fri, 11 Apr 2014 10:38:21 +0200
From: Thomas Hellstrom <thellstrom@vmware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
CC: Thomas Hellstrom <thellstrom@vmware.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, ccross@google.com,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 2/2] [RFC v2 with seqcount] reservation: add suppport
 for read-only access using rcu
References: <20140409144239.26648.57918.stgit@patser> <20140409144831.26648.79163.stgit@patser> <53465A53.1090500@vmware.com> <53466D63.8080808@canonical.com> <53467B93.3000402@vmware.com> <5346B212.8050202@canonical.com>
In-Reply-To: <5346B212.8050202@canonical.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/mixed;
 boundary="------------060504020804050705070008"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060504020804050705070008
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi, Maarten.

Here I believe we encounter a lot of locking inconsistencies.

First, it seems you're use a number of pointers as RCU pointers without
annotating them as such and use the correct rcu
macros when assigning those pointers.

Some pointers (like the pointers in the shared fence list) are both used
as RCU pointers (in dma_buf_poll()) for example,
or considered protected by the seqlock
(reservation_object_get_fences_rcu()), which I believe is OK, but then
the pointers must
be assigned using the correct rcu macros. In the memcpy in
reservation_object_get_fences_rcu() we might get away with an
ugly typecast, but with a verbose comment that the pointers are
considered protected by the seqlock at that location.

So I've updated (attached) the headers with proper __rcu annotation and
locking comments according to how they are being used in the various
reading functions.
I believe if we want to get rid of this we need to validate those
pointers using the seqlock as well.
This will generate a lot of sparse warnings in those places needing
rcu_dereference()
rcu_assign_pointer()
rcu_dereference_protected()

With this I think we can get rid of all ACCESS_ONCE macros: It's not
needed when the rcu_x() macros are used, and
it's never needed for the members protected by the seqlock, (provided
that the seq is tested). The only place where I think that's
*not* the case is at the krealloc in reservation_object_get_fences_rcu().

Also I have some more comments in the
reservation_object_get_fences_rcu() function below:


On 04/10/2014 05:00 PM, Maarten Lankhorst wrote:
> op 10-04-14 13:08, Thomas Hellstrom schreef:
>> On 04/10/2014 12:07 PM, Maarten Lankhorst wrote:
>>> Hey,
>>>
>>> op 10-04-14 10:46, Thomas Hellstrom schreef:
>>>> Hi!
>>>>
>>>> Ugh. This became more complicated than I thought, but I'm OK with
>>>> moving
>>>> TTM over to fence while we sort out
>>>> how / if we're going to use this.
>>>>
>>>> While reviewing, it struck me that this is kind of error-prone, and
>>>> hard
>>>> to follow since we're operating on a structure that may be
>>>> continually updated under us, needing a lot of RCU-specific macros and
>>>> barriers.
>>> Yeah, but with the exception of dma_buf_poll I don't think there is
>>> anything else
>>> outside drivers/base/reservation.c has to deal with rcu.
>>>
>>>> Also the rcu wait appears to not complete until there are no busy
>>>> fences
>>>> left (new ones can be added while we wait) rather than
>>>> waiting on a snapshot of busy fences.
>>> This has been by design, because 'wait for bo idle' type of functions
>>> only care
>>> if the bo is completely idle or not.
>> No, not when using RCU, because the bo may be busy again before the
>> function returns :)
>> Complete idleness can only be guaranteed if holding the reservation, or
>> otherwise making sure
>> that no new rendering is submitted to the buffer, so it's an overkill to
>> wait for complete idleness here.
> You're probably right, but it makes waiting a lot easier if I don't
> have to deal with memory allocations. :P
>>> It would be easy to make a snapshot even without seqlocks, just copy
>>> reservation_object_test_signaled_rcu to return a shared list if
>>> test_all is set, or return pointer to exclusive otherwise.
>>>
>>>> I wonder if these issues can be addressed by having a function that
>>>> provides a snapshot of all busy fences: This can be accomplished
>>>> either by including the exclusive fence in the fence_list structure
>>>> and
>>>> allocate a new such structure each time it is updated. The RCU reader
>>>> could then just make a copy of the current fence_list structure
>>>> pointed
>>>> to by &obj->fence, but I'm not sure we want to reallocate *each*
>>>> time we
>>>> update the fence pointer.
>>> No, the most common operation is updating fence pointers, which is why
>>> the current design makes that cheap. It's also why doing rcu reads is
>>> more expensive.
>>>> The other approach uses a seqlock to obtain a consistent snapshot, and
>>>> I've attached an incomplete outline, and I'm not 100% whether it's
>>>> OK to
>>>> combine RCU and seqlocks in this way...
>>>>
>>>> Both these approaches have the benefit of hiding the RCU
>>>> snapshotting in
>>>> a single function, that can then be used by any waiting
>>>> or polling function.
>>>>
>>> I think the middle way with using seqlocks to protect the fence_excl
>>> pointer and shared list combination,
>>> and using RCU to protect the refcounts for fences and the availability
>>> of the list could work for our usecase
>>> and might remove a bunch of memory barriers. But yeah that depends on
>>> layering rcu and seqlocks.
>>> No idea if that is allowed. But I suppose it is.
>>>
>>> Also, you're being overly paranoid with seqlock reading, we would only
>>> need something like this:
>>>
>>> rcu_read_lock()
>>>      preempt_disable()
>>>      seq = read_seqcount_begin()
>>>      read fence_excl, shared_count = ACCESS_ONCE(fence->shared_count)
>>>      copy shared to a struct.
>>>      if (read_seqcount_retry()) { unlock and retry }
>>>    preempt_enable();
>>>    use fence_get_rcu() to bump refcount on everything, if that fails
>>> unlock, put, and retry
>>> rcu_read_unlock()
>>>
>>> But the shared list would still need to be RCU'd, to make sure we're
>>> not reading freed garbage.
>> Ah. OK,
>> But I think we should use rcu inside seqcount, because
>> read_seqcount_begin() may spin for a long time if there are
>> many writers. Also I don't think the preempt_disable() is needed for
>> read_seq critical sections other than they might
>> decrease the risc of retries..
>>
> Reading the seqlock code makes me suspect that's the case too. The
> lockdep code calls
> local_irq_disable, so it's probably safe without preemption disabled.
>
> ~Maarten
>
> I like the ability of not allocating memory, so I kept
> reservation_object_wait_timeout_rcu mostly
> the way it was. This code appears to fail on nouveau when using the
> shared members,
> but I'm not completely sure whether the error is in nouveau or this
> code yet.
>
> --8<--------
> [RFC v2] reservation: add suppport for read-only access using rcu
>
> This adds 4 more functions to deal with rcu.
>
> reservation_object_get_fences_rcu() will obtain the list of shared
> and exclusive fences without obtaining the ww_mutex.
>
> reservation_object_wait_timeout_rcu() will wait on all fences of the
> reservation_object, without obtaining the ww_mutex.
>
> reservation_object_test_signaled_rcu() will test if all fences of the
> reservation_object are signaled without using the ww_mutex.
>
> reservation_object_get_excl() is added because touching the fence_excl
> member directly will trigger a sparse warning.
>
> Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
>
> diff --git a/drivers/base/dma-buf.c b/drivers/base/dma-buf.c
> index d89a98d2c37b..ca6ef0c4b358 100644
> --- a/drivers/base/dma-buf.c
> +++ b/drivers/base/dma-buf.c
>
> +int reservation_object_get_fences_rcu(struct reservation_object *obj,
> +                      struct fence **pfence_excl,
> +                      unsigned *pshared_count,
> +                      struct fence ***pshared)
> +{
> +    unsigned shared_count = 0;
> +    unsigned retry = 1;
> +    struct fence **shared = NULL, *fence_excl = NULL;
> +    int ret = 0;
> +
> +    while (retry) {
> +        struct reservation_object_list *fobj;
> +        unsigned seq, retry;

You're shadowing retry?


> +
> +        seq = read_seqcount_begin(&obj->seq);
> +
> +        rcu_read_lock();
> +
> +        fobj = ACCESS_ONCE(obj->fence);
> +        if (fobj) {
> +            struct fence **nshared;
> +
> +            shared_count = ACCESS_ONCE(fobj->shared_count);
> +            nshared = krealloc(shared, sizeof(*shared) *
> shared_count, GFP_KERNEL);

krealloc inside rcu_read_lock(). Better to put this first in the loop.

>
> +            if (!nshared) {
> +                ret = -ENOMEM;
> +                shared_count = retry = 0;
> +                goto unlock;
> +            }
> +            shared = nshared;
> +            memcpy(shared, fobj->shared, sizeof(*shared) *
> shared_count);
> +        } else
> +            shared_count = 0;
> +        fence_excl = obj->fence_excl;
> +
> +        retry = read_seqcount_retry(&obj->seq, seq);
> +        if (retry)
> +            goto unlock;
> +
> +        if (!fence_excl || fence_get_rcu(fence_excl)) {
> +            unsigned i;
> +
> +            for (i = 0; i < shared_count; ++i) {
> +                if (fence_get_rcu(shared[i]))
> +                    continue;
> +
> +                /* uh oh, refcount failed, abort and retry */
> +                while (i--)
> +                    fence_put(shared[i]);
> +
> +                if (fence_excl) {
> +                    fence_put(fence_excl);
> +                    fence_excl = NULL;
> +                }
> +
> +                retry = 1;
> +                break;
> +            }
> +        } else
> +            retry = 1;
> +
> +unlock:
> +        rcu_read_unlock();
> +    }
> +    *pshared_count = shared_count;
> +    if (shared_count)
> +        *pshared = shared;
> +    else {
> +        *pshared = NULL;
> +        kfree(shared);
> +    }
> +    *pfence_excl = fence_excl;
> +
> +    return ret;
> +}
> +EXPORT_SYMBOL_GPL(reservation_object_get_fences_rcu);
> +

Thanks,
Thomas


--------------060504020804050705070008
Content-Type: text/x-patch;
 name="wake_up_sparse.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="wake_up_sparse.diff"

diff --git a/include/linux/fence.h b/include/linux/fence.h
index 8499ace..33a265d 100644
--- a/include/linux/fence.h
+++ b/include/linux/fence.h
@@ -200,10 +200,13 @@ static inline void fence_get(struct fence *fence)
  */
 static inline struct fence *fence_get_rcu(struct fence *fence)
 {
-	struct fence *f = ACCESS_ONCE(fence);
+	/*
+	 * Either we make the function operate on __rcu pointers
+	 * or remove ACCESS_ONCE
+	 */
 
-	if (kref_get_unless_zero(&f->refcount))
-		return f;
+	if (kref_get_unless_zero(&fence->refcount))
+		return fence;
 	else
 		return NULL;
 }
diff --git a/include/linux/reservation.h b/include/linux/reservation.h
index d6e1f62..ab586a6 100644
--- a/include/linux/reservation.h
+++ b/include/linux/reservation.h
@@ -50,16 +50,26 @@ extern struct lock_class_key reservation_seqcount_class;
 
 struct reservation_object_list {
 	struct rcu_head rcu;
+	/* Protected by reservation_object::seq */
 	u32 shared_count, shared_max;
-	struct fence *shared[];
+	/* 
+	 * Immutable. Individual pointers in the array are protected
+	 * by reservation_object::seq and rcu. Hence while assigning those
+	 * pointers, rcu_assign_pointer is needed. When reading them
+	 * inside the seqlock, you may use rcu_dereference_protected().
+	 */
+	struct fence __rcu *shared[];
 };
 
 struct reservation_object {
 	struct ww_mutex lock;
 	seqcount_t seq;
 
+	/* protected by @seq */
 	struct fence *fence_excl;
-	struct reservation_object_list *fence;
+	/* rcu protected by @lock */
+	struct reservation_object_list __rcu *fence;
+	/* Protected by @lock */
 	struct reservation_object_list *staged;
 };
 
@@ -109,7 +119,7 @@ reservation_object_get_list(struct reservation_object *obj)
 {
 	reservation_object_assert_held(obj);
 
-	return obj->fence;
+	return rcu_dereference_protected(obj->fence, 1);
 }
 
 static inline struct fence *

--------------060504020804050705070008--
