Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934778AbaDJIqz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 04:46:55 -0400
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:50722 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965566AbaDJIqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 04:46:16 -0400
Message-ID: <53465A53.1090500@vmware.com>
Date: Thu, 10 Apr 2014 10:46:11 +0200
From: Thomas Hellstrom <thellstrom@vmware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
CC: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        ccross@google.com, linux-media@vger.kernel.org
Subject: Re: [PATCH 2/2] [RFC] reservation: add suppport for read-only access
 using rcu
References: <20140409144239.26648.57918.stgit@patser> <20140409144831.26648.79163.stgit@patser>
In-Reply-To: <20140409144831.26648.79163.stgit@patser>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/mixed;
 boundary="------------020400020705060706020403"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020400020705060706020403
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi!

Ugh. This became more complicated than I thought, but I'm OK with moving
TTM over to fence while we sort out
how / if we're going to use this.

While reviewing, it struck me that this is kind of error-prone, and hard
to follow since we're operating on a structure that may be
continually updated under us, needing a lot of RCU-specific macros and
barriers.

Also the rcu wait appears to not complete until there are no busy fences
left (new ones can be added while we wait) rather than
waiting on a snapshot of busy fences.

I wonder if these issues can be addressed by having a function that
provides a snapshot of all busy fences: This can be accomplished
either by including the exclusive fence in the fence_list structure and
allocate a new such structure each time it is updated. The RCU reader
could then just make a copy of the current fence_list structure pointed
to by &obj->fence, but I'm not sure we want to reallocate *each* time we
update the fence pointer.

The other approach uses a seqlock to obtain a consistent snapshot, and
I've attached an incomplete outline, and I'm not 100% whether it's OK to
combine RCU and seqlocks in this way...

Both these approaches have the benefit of hiding the RCU snapshotting in
a single function, that can then be used by any waiting
or polling function.

/Thomas



On 04/09/2014 04:49 PM, Maarten Lankhorst wrote:
> This adds 3 more functions to deal with rcu.
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
> ---
>  drivers/base/dma-buf.c      |   46 +++++++++++--
>  drivers/base/reservation.c  |  147 +++++++++++++++++++++++++++++++++++++++++--
>  include/linux/fence.h       |   22 ++++++
>  include/linux/reservation.h |   40 ++++++++----
>  4 files changed, 224 insertions(+), 31 deletions(-)
>


--------------020400020705060706020403
Content-Type: text/x-patch;
 name="rcu_fence.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="rcu_fence.diff"

diff --git a/drivers/base/reservation.c b/drivers/base/reservation.c
index b82a5b6..c4bcf10 100644
--- a/drivers/base/reservation.c
+++ b/drivers/base/reservation.c
@@ -82,6 +82,8 @@ reservation_object_add_shared_inplace(struct reservation_object *obj,
 {
 	u32 i;
 
+	preempt_disable();
+	write_seqcount_begin(&obj->seq);
 	for (i = 0; i < fobj->shared_count; ++i) {
 		if (fobj->shared[i]->context == fence->context) {
 			struct fence *old_fence = fobj->shared[i];
@@ -90,6 +92,8 @@ reservation_object_add_shared_inplace(struct reservation_object *obj,
 
 			fobj->shared[i] = fence;
 
+			write_seqcount_end(&obj->seq);
+			preempt_enable();
 			fence_put(old_fence);
 			return;
 		}
@@ -101,8 +105,9 @@ reservation_object_add_shared_inplace(struct reservation_object *obj,
 	 * make the new fence visible before incrementing
 	 * fobj->shared_count
 	 */
-	smp_wmb();
 	fobj->shared_count++;
+	write_seqcount_end(&obj->seq);
+	preempt_enable();
 }
 
 static void
@@ -141,7 +146,11 @@ reservation_object_add_shared_replace(struct reservation_object *obj,
 		fobj->shared[fobj->shared_count++] = fence;
 
 done:
+	preempt_disable();
+	write_seqcount_begin(&obj->seq);
 	obj->fence = fobj;
+	write_seqcount_end(&obj->seq);
+	preempt_enable();
 	kfree(old);
 }
 
@@ -173,6 +182,8 @@ void reservation_object_add_excl_fence(struct reservation_object *obj,
 	u32 i = 0;
 
 	old = reservation_object_get_list(obj);
+	preempt_disable();
+	write_seqcount_begin(&obj->seq);
 	if (old) {
 		i = old->shared_count;
 		old->shared_count = 0;
@@ -182,7 +193,8 @@ void reservation_object_add_excl_fence(struct reservation_object *obj,
 		fence_get(fence);
 
 	obj->fence_excl = fence;
-
+	write_seqcount_end(&obj->seq);
+	preempt_enable();
 	/* inplace update, no shared fences */
 	while (i--)
 		fence_put(old->shared[i]);
@@ -191,3 +203,76 @@ void reservation_object_add_excl_fence(struct reservation_object *obj,
 		fence_put(old_fence);
 }
 EXPORT_SYMBOL(reservation_object_add_excl_fence);
+
+struct unsignaled {
+	unsigned shared_max;
+	unsigned shared_count;
+	struct fence **shared;
+	struct fence *exclusive;
+};
+
+static int reservation_object_unsignaled_rcu(struct reservation_object *obj,
+					     struct unsignaled *us)
+{
+	unsigned seq;
+	struct reservation_object_list *fobj, list;
+	struct fence *fence;
+
+retry:
+	seq = read_seqcount_begin(&obj->seq);
+	rcu_read_lock();
+
+	fobj = obj->fence;
+	fence = obj->exclusive;
+
+	/* Check pointers for validity */
+	if (read_seqcount_retry(&obj->seq, seq)) {
+		rcu_read_unlock();
+		goto retry;
+	}
+
+	list = *fobj;
+
+	/* Check list for validity */
+	if (read_seqcount_retry(&obj->seq, seq)) {
+		rcu_read_unlock();
+		goto retry;
+	}
+
+	if (list.shared_count == 0) {
+		if (fence &&
+		    !test_bit(FENCE_FLAG_SIGNALED_BIT, &fence->flags) &&
+		    fence_get_rcu(fence))
+			us->exclusive = exclusive;
+		rcu_read_unlock();
+		return 0;
+	}
+	
+
+	/* Needs reallocation? Either in this function or outside */
+	if (us->shared_max < list.shared_count) {
+		rcu_read_unlock();
+		return -ENOMEM;
+	}
+
+	memcpy(us->shared, list.shared,
+	       list.shared_count * sizeof(*list.shared));
+
+	/* Check the fence pointer array for validity */
+	if (read_seqcount_retry(&obj->seq, seq)) {
+		rcu_read_unlock();
+		goto retry;
+	}
+
+	for (i = 0; i < list.shared_count; ++i) {
+		struct fence *fence = us->shared[i];
+	       
+		if (fence && !test_bit(FENCE_FLAG_SIGNALED_BIT, &fence->flags)
+		    && fence_get_rcu(fence));			
+		us->shared[us->shared_count++] = fence;
+	}
+
+	rcu_read_unlock();
+	
+	return 0;
+}
diff --git a/include/linux/reservation.h b/include/linux/reservation.h
index b602365..4bf791a 100644
--- a/include/linux/reservation.h
+++ b/include/linux/reservation.h
@@ -52,6 +52,7 @@ struct reservation_object_list {
 
 struct reservation_object {
 	struct ww_mutex lock;
+	struct seqcount seq;
 
 	struct fence *fence_excl;
 	struct reservation_object_list *fence;
@@ -69,6 +70,7 @@ reservation_object_init(struct reservation_object *obj)
 	obj->fence_excl = NULL;
 	obj->fence = NULL;
 	obj->staged = NULL;
+	seqcount_init(&obj->seq);
 }
 
 static inline void

--------------020400020705060706020403--
