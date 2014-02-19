Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753744AbaBSN4Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 08:56:16 -0500
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:37685 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753201AbaBSN4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 08:56:14 -0500
Message-ID: <5304B7F9.4070907@vmware.com>
Date: Wed, 19 Feb 2014 14:56:09 +0100
From: Thomas Hellstrom <thellstrom@vmware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
CC: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        ccross@google.com, linux-media@vger.kernel.org
Subject: Re: [PATCH 4/6] android: convert sync to fence api, v4
References: <20140217155056.20337.25254.stgit@patser> <20140217155640.20337.13331.stgit@patser>
In-Reply-To: <20140217155640.20337.13331.stgit@patser>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17/2014 04:57 PM, Maarten Lankhorst wrote:
> Android syncpoints can be mapped to a timeline. This removes the need
> to maintain a separate api for synchronization. I've left the android
> trace events in place, but the core fence events should already be
> sufficient for debugging.
>
> v2:
> - Call fence_remove_callback in sync_fence_free if not all fences have fired.
> v3:
> - Merge Colin Cross' bugfixes, and the android fence merge optimization.
> v4:
> - Merge with the upstream fixes.
>
> Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
> ---
>  drivers/staging/android/Kconfig      |    1 
>  drivers/staging/android/Makefile     |    2 
>  drivers/staging/android/sw_sync.c    |    4 
>  drivers/staging/android/sync.c       |  892 +++++++++++-----------------------
>  drivers/staging/android/sync.h       |   80 ++-
>  drivers/staging/android/sync_debug.c |  245 +++++++++
>  drivers/staging/android/trace/sync.h |   12 
>  7 files changed, 592 insertions(+), 644 deletions(-)
>  create mode 100644 drivers/staging/android/sync_debug.c
>
> diff --git a/drivers/staging/android/Kconfig b/drivers/staging/android/Kconfig
> index b91c758883bf..ecc8194242b5 100644
> --- a/drivers/staging/android/Kconfig
> +++ b/drivers/staging/android/Kconfig
> @@ -77,6 +77,7 @@ config SYNC
>  	bool "Synchronization framework"
>  	default n
>  	select ANON_INODES
> +	select DMA_SHARED_BUFFER
>  	---help---
>  	  This option enables the framework for synchronization between multiple
>  	  drivers.  Sync implementations can take advantage of hardware
> diff --git a/drivers/staging/android/Makefile b/drivers/staging/android/Makefile
> index 0a01e1914905..517ad5ffa429 100644
> --- a/drivers/staging/android/Makefile
> +++ b/drivers/staging/android/Makefile
> @@ -9,5 +9,5 @@ obj-$(CONFIG_ANDROID_TIMED_OUTPUT)	+= timed_output.o
>  obj-$(CONFIG_ANDROID_TIMED_GPIO)	+= timed_gpio.o
>  obj-$(CONFIG_ANDROID_LOW_MEMORY_KILLER)	+= lowmemorykiller.o
>  obj-$(CONFIG_ANDROID_INTF_ALARM_DEV)	+= alarm-dev.o
> -obj-$(CONFIG_SYNC)			+= sync.o
> +obj-$(CONFIG_SYNC)			+= sync.o sync_debug.o
>  obj-$(CONFIG_SW_SYNC)			+= sw_sync.o
> diff --git a/drivers/staging/android/sw_sync.c b/drivers/staging/android/sw_sync.c
> index f24493ac65e3..a76db3ff87cb 100644
> --- a/drivers/staging/android/sw_sync.c
> +++ b/drivers/staging/android/sw_sync.c
> @@ -50,7 +50,7 @@ static struct sync_pt *sw_sync_pt_dup(struct sync_pt *sync_pt)
>  {
>  	struct sw_sync_pt *pt = (struct sw_sync_pt *) sync_pt;
>  	struct sw_sync_timeline *obj =
> -		(struct sw_sync_timeline *)sync_pt->parent;
> +		(struct sw_sync_timeline *)sync_pt_parent(sync_pt);
>  
>  	return (struct sync_pt *) sw_sync_pt_create(obj, pt->value);
>  }
> @@ -59,7 +59,7 @@ static int sw_sync_pt_has_signaled(struct sync_pt *sync_pt)
>  {
>  	struct sw_sync_pt *pt = (struct sw_sync_pt *)sync_pt;
>  	struct sw_sync_timeline *obj =
> -		(struct sw_sync_timeline *)sync_pt->parent;
> +		(struct sw_sync_timeline *)sync_pt_parent(sync_pt);
>  
>  	return sw_sync_cmp(obj->value, pt->value) >= 0;
>  }
> diff --git a/drivers/staging/android/sync.c b/drivers/staging/android/sync.c
> index 3d05f662110b..8e77cd73b739 100644
> --- a/drivers/staging/android/sync.c
> +++ b/drivers/staging/android/sync.c
> @@ -31,22 +31,13 @@
>  #define CREATE_TRACE_POINTS
>  #include "trace/sync.h"
>  
> -static void sync_fence_signal_pt(struct sync_pt *pt);
> -static int _sync_pt_has_signaled(struct sync_pt *pt);
> -static void sync_fence_free(struct kref *kref);
> -static void sync_dump(void);
> -
> -static LIST_HEAD(sync_timeline_list_head);
> -static DEFINE_SPINLOCK(sync_timeline_list_lock);
> -
> -static LIST_HEAD(sync_fence_list_head);
> -static DEFINE_SPINLOCK(sync_fence_list_lock);
> +static const struct fence_ops android_fence_ops;
> +static const struct file_operations sync_fence_fops;
>  
>  struct sync_timeline *sync_timeline_create(const struct sync_timeline_ops *ops,
>  					   int size, const char *name)
>  {
>  	struct sync_timeline *obj;
> -	unsigned long flags;
>  
>  	if (size < sizeof(struct sync_timeline))
>  		return NULL;
> @@ -57,17 +48,14 @@ struct sync_timeline *sync_timeline_create(const struct sync_timeline_ops *ops,
>  
>  	kref_init(&obj->kref);
>  	obj->ops = ops;
> +	obj->context = fence_context_alloc(1);
>  	strlcpy(obj->name, name, sizeof(obj->name));
>  
>  	INIT_LIST_HEAD(&obj->child_list_head);
> -	spin_lock_init(&obj->child_list_lock);
> -
>  	INIT_LIST_HEAD(&obj->active_list_head);
> -	spin_lock_init(&obj->active_list_lock);
> +	spin_lock_init(&obj->child_list_lock);
>  
> -	spin_lock_irqsave(&sync_timeline_list_lock, flags);
> -	list_add_tail(&obj->sync_timeline_list, &sync_timeline_list_head);
> -	spin_unlock_irqrestore(&sync_timeline_list_lock, flags);
> +	sync_timeline_debug_add(obj);
>  
>  	return obj;
>  }
> @@ -77,11 +65,8 @@ static void sync_timeline_free(struct kref *kref)
>  {
>  	struct sync_timeline *obj =
>  		container_of(kref, struct sync_timeline, kref);
> -	unsigned long flags;
>  
> -	spin_lock_irqsave(&sync_timeline_list_lock, flags);
> -	list_del(&obj->sync_timeline_list);
> -	spin_unlock_irqrestore(&sync_timeline_list_lock, flags);
> +	sync_timeline_debug_remove(obj);
>  
>  	if (obj->ops->release_obj)
>  		obj->ops->release_obj(obj);
> @@ -89,6 +74,16 @@ static void sync_timeline_free(struct kref *kref)
>  	kfree(obj);
>  }
>  
> +static void sync_timeline_get(struct sync_timeline *obj)
> +{
> +	kref_get(&obj->kref);
> +}
> +
> +static void sync_timeline_put(struct sync_timeline *obj)
> +{
> +	kref_put(&obj->kref, sync_timeline_free);
> +}
> +
>  void sync_timeline_destroy(struct sync_timeline *obj)
>  {
>  	obj->destroyed = true;
> @@ -98,75 +93,30 @@ void sync_timeline_destroy(struct sync_timeline *obj)
>  	 * signal any children that their parent is going away.
>  	 */
>  	sync_timeline_signal(obj);
> -
> -	kref_put(&obj->kref, sync_timeline_free);
> +	sync_timeline_put(obj);
>  }
>  EXPORT_SYMBOL(sync_timeline_destroy);
>  
> -static void sync_timeline_add_pt(struct sync_timeline *obj, struct sync_pt *pt)
> -{
> -	unsigned long flags;
> -
> -	pt->parent = obj;
> -
> -	spin_lock_irqsave(&obj->child_list_lock, flags);
> -	list_add_tail(&pt->child_list, &obj->child_list_head);
> -	spin_unlock_irqrestore(&obj->child_list_lock, flags);
> -}
> -
> -static void sync_timeline_remove_pt(struct sync_pt *pt)
> -{
> -	struct sync_timeline *obj = pt->parent;
> -	unsigned long flags;
> -
> -	spin_lock_irqsave(&obj->active_list_lock, flags);
> -	if (!list_empty(&pt->active_list))
> -		list_del_init(&pt->active_list);
> -	spin_unlock_irqrestore(&obj->active_list_lock, flags);
> -
> -	spin_lock_irqsave(&obj->child_list_lock, flags);
> -	if (!list_empty(&pt->child_list))
> -		list_del_init(&pt->child_list);
> -
> -	spin_unlock_irqrestore(&obj->child_list_lock, flags);
> -}
> -
>  void sync_timeline_signal(struct sync_timeline *obj)
>  {
>  	unsigned long flags;
>  	LIST_HEAD(signaled_pts);
> -	struct list_head *pos, *n;
> +	struct sync_pt *pt, *next;
>  
>  	trace_sync_timeline(obj);
>  
> -	spin_lock_irqsave(&obj->active_list_lock, flags);
> -
> -	list_for_each_safe(pos, n, &obj->active_list_head) {
> -		struct sync_pt *pt =
> -			container_of(pos, struct sync_pt, active_list);
> -
> -		if (_sync_pt_has_signaled(pt)) {
> -			list_del_init(pos);
> -			list_add(&pt->signaled_list, &signaled_pts);
> -			kref_get(&pt->fence->kref);
> -		}
> -	}
> -
> -	spin_unlock_irqrestore(&obj->active_list_lock, flags);
> -
> -	list_for_each_safe(pos, n, &signaled_pts) {
> -		struct sync_pt *pt =
> -			container_of(pos, struct sync_pt, signaled_list);
> -
> -		list_del_init(pos);
> -		sync_fence_signal_pt(pt);
> -		kref_put(&pt->fence->kref, sync_fence_free);
> +	spin_lock_irqsave(&obj->child_list_lock, flags);
> +	list_for_each_entry_safe(pt, next, &obj->active_list_head, active_list) {
> +		if (__fence_is_signaled(&pt->base))
> +			list_del(&pt->active_list);
>  	}
> +	spin_unlock_irqrestore(&obj->child_list_lock, flags);
>  }
>  EXPORT_SYMBOL(sync_timeline_signal);
>  
> -struct sync_pt *sync_pt_create(struct sync_timeline *parent, int size)
> +struct sync_pt *sync_pt_create(struct sync_timeline *obj, int size)
>  {
> +	unsigned long flags;
>  	struct sync_pt *pt;
>  
>  	if (size < sizeof(struct sync_pt))
> @@ -176,87 +126,27 @@ struct sync_pt *sync_pt_create(struct sync_timeline *parent, int size)
>  	if (pt == NULL)
>  		return NULL;
>  
> +	spin_lock_irqsave(&obj->child_list_lock, flags);
> +	sync_timeline_get(obj);
> +	__fence_init(&pt->base, &android_fence_ops, &obj->child_list_lock, obj->context, ++obj->value);
> +	list_add_tail(&pt->child_list, &obj->child_list_head);
>  	INIT_LIST_HEAD(&pt->active_list);
> -	kref_get(&parent->kref);
> -	sync_timeline_add_pt(parent, pt);
> -
> +	spin_unlock_irqrestore(&obj->child_list_lock, flags);
>  	return pt;
>  }
>  EXPORT_SYMBOL(sync_pt_create);
>  
>  void sync_pt_free(struct sync_pt *pt)
>  {
> -	if (pt->parent->ops->free_pt)
> -		pt->parent->ops->free_pt(pt);
> -
> -	sync_timeline_remove_pt(pt);
> -
> -	kref_put(&pt->parent->kref, sync_timeline_free);
> -
> -	kfree(pt);
> +	fence_put(&pt->base);
>  }
>  EXPORT_SYMBOL(sync_pt_free);
>  
> -/* call with pt->parent->active_list_lock held */
> -static int _sync_pt_has_signaled(struct sync_pt *pt)
> -{
> -	int old_status = pt->status;
> -
> -	if (!pt->status)
> -		pt->status = pt->parent->ops->has_signaled(pt);
> -
> -	if (!pt->status && pt->parent->destroyed)
> -		pt->status = -ENOENT;
> -
> -	if (pt->status != old_status)
> -		pt->timestamp = ktime_get();
> -
> -	return pt->status;
> -}
> -
> -static struct sync_pt *sync_pt_dup(struct sync_pt *pt)
> -{
> -	return pt->parent->ops->dup(pt);
> -}
> -
> -/* Adds a sync pt to the active queue.  Called when added to a fence */
> -static void sync_pt_activate(struct sync_pt *pt)
> -{
> -	struct sync_timeline *obj = pt->parent;
> -	unsigned long flags;
> -	int err;
> -
> -	spin_lock_irqsave(&obj->active_list_lock, flags);
> -
> -	err = _sync_pt_has_signaled(pt);
> -	if (err != 0)
> -		goto out;
> -
> -	list_add_tail(&pt->active_list, &obj->active_list_head);
> -
> -out:
> -	spin_unlock_irqrestore(&obj->active_list_lock, flags);
> -}
> -
> -static int sync_fence_release(struct inode *inode, struct file *file);
> -static unsigned int sync_fence_poll(struct file *file, poll_table *wait);
> -static long sync_fence_ioctl(struct file *file, unsigned int cmd,
> -			     unsigned long arg);
> -
> -
> -static const struct file_operations sync_fence_fops = {
> -	.release = sync_fence_release,
> -	.poll = sync_fence_poll,
> -	.unlocked_ioctl = sync_fence_ioctl,
> -	.compat_ioctl = sync_fence_ioctl,
> -};
> -
> -static struct sync_fence *sync_fence_alloc(const char *name)
> +static struct sync_fence *sync_fence_alloc(int size, const char *name)
>  {
>  	struct sync_fence *fence;
> -	unsigned long flags;
>  
> -	fence = kzalloc(sizeof(struct sync_fence), GFP_KERNEL);
> +	fence = kzalloc(size, GFP_KERNEL);
>  	if (fence == NULL)
>  		return NULL;
>  
> @@ -268,16 +158,8 @@ static struct sync_fence *sync_fence_alloc(const char *name)
>  	kref_init(&fence->kref);
>  	strlcpy(fence->name, name, sizeof(fence->name));
>  
> -	INIT_LIST_HEAD(&fence->pt_list_head);
> -	INIT_LIST_HEAD(&fence->waiter_list_head);
> -	spin_lock_init(&fence->waiter_list_lock);
> -
>  	init_waitqueue_head(&fence->wq);
>  
> -	spin_lock_irqsave(&sync_fence_list_lock, flags);
> -	list_add_tail(&fence->sync_fence_list, &sync_fence_list_head);
> -	spin_unlock_irqrestore(&sync_fence_list_lock, flags);
> -
>  	return fence;
>  
>  err:
> @@ -285,119 +167,40 @@ err:
>  	return NULL;
>  }
>  
> +static void fence_check_cb_func(struct fence *f, struct fence_cb *cb)
> +{
> +	struct sync_fence_cb *check = container_of(cb, struct sync_fence_cb, cb);
> +	struct sync_fence *fence = check->fence;
> +
> +	// TODO: Add a fence->status member and check it

Hmm, C++ / C99 style comments makes checkpatch.pl complain. Did you run
this series through checkpatch?

/Thomas
