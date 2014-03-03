Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398AbaCCVLO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 16:11:14 -0500
Received: from mail-ig0-f176.google.com ([209.85.213.176]:45133 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241AbaCCVLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 16:11:11 -0500
MIME-Version: 1.0
X-Originating-IP: [84.73.67.144]
In-Reply-To: <20140217155640.20337.13331.stgit@patser>
References: <20140217155056.20337.25254.stgit@patser>
	<20140217155640.20337.13331.stgit@patser>
Date: Mon, 3 Mar 2014 22:11:10 +0100
X-Google-Sender-Auth: QBEt5oLKsD5MjO7rK0TsagUI-KQ
Message-ID: <CAKMK7uESOhk_i8ui1pVknA=6s8oQsBOCTULYszxe5fodcBwTGw@mail.gmail.com>
Subject: Re: [PATCH 4/6] android: convert sync to fence api, v4
From: Daniel Vetter <daniel@ffwll.ch>
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Ian Lister <ian.lister@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arch@vger.kernel.org, Colin Cross <ccross@google.com>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        "Clark, Rob" <robdclark@gmail.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Daniel Vetter <daniel@ffwll.ch>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17, 2014 at 04:57:19PM +0100, Maarten Lankhorst wrote:
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

Snipped everything but headers - Ian Lister from our android team is
signed up to have a more in-depth look at proper integration with android
syncpoints. Adding him to cc.

> diff --git a/drivers/staging/android/sync.h b/drivers/staging/android/sync.h
> index 62e2255b1c1e..6036dbdc8e6f 100644
> --- a/drivers/staging/android/sync.h
> +++ b/drivers/staging/android/sync.h
> @@ -21,6 +21,7 @@
>  #include <linux/list.h>
>  #include <linux/spinlock.h>
>  #include <linux/wait.h>
> +#include <linux/fence.h>
>
>  struct sync_timeline;
>  struct sync_pt;
> @@ -40,8 +41,6 @@ struct sync_fence;
>   * -1 if a will signal before b
>   * @free_pt: called before sync_pt is freed
>   * @release_obj: called before sync_timeline is freed
> - * @print_obj: deprecated
> - * @print_pt: deprecated
>   * @fill_driver_data: write implementation specific driver data to data.
>   *  should return an error if there is not enough room
>   *  as specified by size.  This information is returned
> @@ -67,13 +66,6 @@ struct sync_timeline_ops {
>   /* optional */
>   void (*release_obj)(struct sync_timeline *sync_timeline);
>
> - /* deprecated */
> - void (*print_obj)(struct seq_file *s,
> -  struct sync_timeline *sync_timeline);
> -
> - /* deprecated */
> - void (*print_pt)(struct seq_file *s, struct sync_pt *sync_pt);
> -
>   /* optional */
>   int (*fill_driver_data)(struct sync_pt *syncpt, void *data, int size);
>
> @@ -104,42 +96,48 @@ struct sync_timeline {
>
>   /* protected by child_list_lock */
>   bool destroyed;
> + int context, value;
>
>   struct list_head child_list_head;
>   spinlock_t child_list_lock;
>
>   struct list_head active_list_head;
> - spinlock_t active_list_lock;
>
> +#ifdef CONFIG_DEBUG_FS
>   struct list_head sync_timeline_list;
> +#endif
>  };
>
>  /**
>   * struct sync_pt - sync point
> - * @parent: sync_timeline to which this sync_pt belongs
> + * @fence: base fence class
>   * @child_list: membership in sync_timeline.child_list_head
>   * @active_list: membership in sync_timeline.active_list_head
> +<<<<<<< current
>   * @signaled_list: membership in temporary signaled_list on stack
>   * @fence: sync_fence to which the sync_pt belongs
>   * @pt_list: membership in sync_fence.pt_list_head
>   * @status: 1: signaled, 0:active, <0: error
>   * @timestamp: time which sync_pt status transitioned from active to
>   *  signaled or error.
> +=======
> +>>>>>>> patched

Conflict markers ...

>   */
>  struct sync_pt {
> - struct sync_timeline *parent;
> - struct list_head child_list;
> + struct fence base;

Hm, embedding feels wrong, since that still means that I'll need to
implement two kinds of fences in i915 - one using the seqno fence to make
dma-buf sync work, and one to implmenent sync_pt to make the android folks
happy.

If I can dream I think we should have a pointer to an underlying fence
here, i.e. a struct sync_pt would just be a userspace interface wrapper to
do explicit syncing using native fences, instead of implicit syncing like
with dma-bufs. But this is all drive-by comments from a very cursory
high-level look. I might be full of myself again ;-)
-Daniel

>
> + struct list_head child_list;
>   struct list_head active_list;
> - struct list_head signaled_list;
> -
> - struct sync_fence *fence;
> - struct list_head pt_list;
> +};
>
> - /* protected by parent->active_list_lock */
> - int status;
> +static inline struct sync_timeline *sync_pt_parent(struct sync_pt *pt) {
> + return container_of(pt->base.lock, struct sync_timeline, child_list_lock);
> +}
>
> - ktime_t timestamp;
> +struct sync_fence_cb {
> + struct fence_cb cb;
> + struct fence *sync_pt;
> + struct sync_fence *fence;
>  };
>
>  /**
> @@ -149,9 +147,7 @@ struct sync_pt {
>   * @name: name of sync_fence.  Useful for debugging
>   * @pt_list_head: list of sync_pts in the fence.  immutable once fence
>   *  is created
> - * @waiter_list_head: list of asynchronous waiters on this fence
> - * @waiter_list_lock: lock protecting @waiter_list_head and @status
> - * @status: 1: signaled, 0:active, <0: error
> + * @status: 0: signaled, >0:active, <0: error
>   *
>   * @wq: wait queue for fence signaling
>   * @sync_fence_list: membership in global fence list
> @@ -160,17 +156,15 @@ struct sync_fence {
>   struct file *file;
>   struct kref kref;
>   char name[32];
> -
> - /* this list is immutable once the fence is created */
> - struct list_head pt_list_head;
> -
> - struct list_head waiter_list_head;
> - spinlock_t waiter_list_lock; /* also protects status */
> - int status;
> +#ifdef CONFIG_DEBUG_FS
> + struct list_head sync_fence_list;
> +#endif
> + int num_fences;
>
>   wait_queue_head_t wq;
> + atomic_t status;
>
> - struct list_head sync_fence_list;
> + struct sync_fence_cb cbs[];
>  };
>
>  struct sync_fence_waiter;
> @@ -184,14 +178,14 @@ typedef void (*sync_callback_t)(struct sync_fence *fence,
>   * @callback_data: pointer to pass to @callback
>   */
>  struct sync_fence_waiter {
> - struct list_head waiter_list;
> -
> - sync_callback_t callback;
> + wait_queue_t work;
> + sync_callback_t callback;
>  };
>
>  static inline void sync_fence_waiter_init(struct sync_fence_waiter *waiter,
>    sync_callback_t callback)
>  {
> + INIT_LIST_HEAD(&waiter->work.task_list);
>   waiter->callback = callback;
>  }
>
> @@ -423,4 +417,22 @@ struct sync_fence_info_data {
>  #define SYNC_IOC_FENCE_INFO _IOWR(SYNC_IOC_MAGIC, 2,\
>   struct sync_fence_info_data)
>
> +#ifdef CONFIG_DEBUG_FS
> +
> +extern void sync_timeline_debug_add(struct sync_timeline *obj);
> +extern void sync_timeline_debug_remove(struct sync_timeline *obj);
> +extern void sync_fence_debug_add(struct sync_fence *fence);
> +extern void sync_fence_debug_remove(struct sync_fence *fence);
> +extern void sync_dump(void);
> +
> +#else
> +# define sync_timeline_debug_add(obj)
> +# define sync_timeline_debug_remove(obj)
> +# define sync_fence_debug_add(fence)
> +# define sync_fence_debug_remove(fence)
> +# define sync_dump()
> +#endif
> +int sync_fence_wake_up_wq(wait_queue_t *curr, unsigned mode,
> + int wake_flags, void *key);
> +
>  #endif /* _LINUX_SYNC_H */
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
