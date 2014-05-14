Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551AbaENP3c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 11:29:32 -0400
Received: from pegasos-out.vodafone.de ([80.84.1.38]:35403 "EHLO
	pegasos-out.vodafone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042AbaENP3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 11:29:31 -0400
X-Spam-Flag: NO
X-Spam-Score: 0.2
Authentication-Results: rohrpostix2.prod.vfnet.de (amavisd-new); dkim=pass
	header.i=@vodafone.de
X-DKIM: OpenDKIM Filter v2.6.8 pegasos-out.vodafone.de 4DE2066E7FF
X-DKIM: OpenDKIM Filter v2.0.2 smtp-04.vodafone.de 278E4E4E5C
Message-ID: <53738BCC.2070809@vodafone.de>
Date: Wed, 14 May 2014 17:29:16 +0200
From: =?ISO-8859-1?Q?Christian_K=F6nig?= <deathsimple@vodafone.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>, airlied@linux.ie
CC: nouveau@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [RFC PATCH v1 08/16] drm/radeon: use common fence implementation
 for fences
References: <20140514145134.21163.32350.stgit@patser> <20140514145809.21163.64947.stgit@patser>
In-Reply-To: <20140514145809.21163.64947.stgit@patser>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +	/* did fence get signaled after we enabled the sw irq? */
> +	if (atomic64_read(&fence->rdev->fence_drv[fence->ring].last_seq) >= fence->seq) {
> +		radeon_irq_kms_sw_irq_put(fence->rdev, fence->ring);
> +		return false;
> +	}
> +
> +	fence->fence_wake.flags = 0;
> +	fence->fence_wake.private = NULL;
> +	fence->fence_wake.func = radeon_fence_check_signaled;
> +	__add_wait_queue(&fence->rdev->fence_queue, &fence->fence_wake);
> +	fence_get(f);
That looks like a race condition to me. The fence needs to be added to 
the wait queue before the check, not after.

Apart from that the whole approach looks like a really bad idea to me. 
How for example is lockup detection supposed to happen with this?

Christian.

Am 14.05.2014 16:58, schrieb Maarten Lankhorst:
> Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
> ---
>   drivers/gpu/drm/radeon/radeon.h        |   15 +--
>   drivers/gpu/drm/radeon/radeon_device.c |    1
>   drivers/gpu/drm/radeon/radeon_fence.c  |  189 +++++++++++++++++++++++++-------
>   3 files changed, 153 insertions(+), 52 deletions(-)
>
> diff --git a/drivers/gpu/drm/radeon/radeon.h b/drivers/gpu/drm/radeon/radeon.h
> index 68528619834a..a7d839a158ae 100644
> --- a/drivers/gpu/drm/radeon/radeon.h
> +++ b/drivers/gpu/drm/radeon/radeon.h
> @@ -64,6 +64,7 @@
>   #include <linux/wait.h>
>   #include <linux/list.h>
>   #include <linux/kref.h>
> +#include <linux/fence.h>
>   
>   #include <ttm/ttm_bo_api.h>
>   #include <ttm/ttm_bo_driver.h>
> @@ -113,9 +114,6 @@ extern int radeon_hard_reset;
>   #define RADEONFB_CONN_LIMIT			4
>   #define RADEON_BIOS_NUM_SCRATCH			8
>   
> -/* fence seq are set to this number when signaled */
> -#define RADEON_FENCE_SIGNALED_SEQ		0LL
> -
>   /* internal ring indices */
>   /* r1xx+ has gfx CP ring */
>   #define RADEON_RING_TYPE_GFX_INDEX		0
> @@ -347,12 +345,15 @@ struct radeon_fence_driver {
>   };
>   
>   struct radeon_fence {
> +	struct fence base;
> +
>   	struct radeon_device		*rdev;
> -	struct kref			kref;
>   	/* protected by radeon_fence.lock */
>   	uint64_t			seq;
>   	/* RB, DMA, etc. */
>   	unsigned			ring;
> +
> +	wait_queue_t fence_wake;
>   };
>   
>   int radeon_fence_driver_start_ring(struct radeon_device *rdev, int ring);
> @@ -2256,6 +2257,7 @@ struct radeon_device {
>   	struct radeon_mman		mman;
>   	struct radeon_fence_driver	fence_drv[RADEON_NUM_RINGS];
>   	wait_queue_head_t		fence_queue;
> +	unsigned			fence_context;
>   	struct mutex			ring_lock;
>   	struct radeon_ring		ring[RADEON_NUM_RINGS];
>   	bool				ib_pool_ready;
> @@ -2346,11 +2348,6 @@ u32 cik_mm_rdoorbell(struct radeon_device *rdev, u32 index);
>   void cik_mm_wdoorbell(struct radeon_device *rdev, u32 index, u32 v);
>   
>   /*
> - * Cast helper
> - */
> -#define to_radeon_fence(p) ((struct radeon_fence *)(p))
> -
> -/*
>    * Registers read & write functions.
>    */
>   #define RREG8(reg) readb((rdev->rmmio) + (reg))
> diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
> index 0e770bbf7e29..501d0cf9eb8b 100644
> --- a/drivers/gpu/drm/radeon/radeon_device.c
> +++ b/drivers/gpu/drm/radeon/radeon_device.c
> @@ -1175,6 +1175,7 @@ int radeon_device_init(struct radeon_device *rdev,
>   	for (i = 0; i < RADEON_NUM_RINGS; i++) {
>   		rdev->ring[i].idx = i;
>   	}
> +	rdev->fence_context = fence_context_alloc(RADEON_NUM_RINGS);
>   
>   	DRM_INFO("initializing kernel modesetting (%s 0x%04X:0x%04X 0x%04X:0x%04X).\n",
>   		radeon_family_name[rdev->family], pdev->vendor, pdev->device,
> diff --git a/drivers/gpu/drm/radeon/radeon_fence.c b/drivers/gpu/drm/radeon/radeon_fence.c
> index a77b1c13ea43..bc844f300d3f 100644
> --- a/drivers/gpu/drm/radeon/radeon_fence.c
> +++ b/drivers/gpu/drm/radeon/radeon_fence.c
> @@ -39,6 +39,15 @@
>   #include "radeon.h"
>   #include "radeon_trace.h"
>   
> +static const struct fence_ops radeon_fence_ops;
> +
> +#define to_radeon_fence(p) \
> +	({								\
> +		struct radeon_fence *__f;				\
> +		__f = container_of((p), struct radeon_fence, base);	\
> +		__f->base.ops == &radeon_fence_ops ? __f : NULL;	\
> +	})
> +
>   /*
>    * Fences
>    * Fences mark an event in the GPUs pipeline and are used
> @@ -111,30 +120,55 @@ int radeon_fence_emit(struct radeon_device *rdev,
>   		      struct radeon_fence **fence,
>   		      int ring)
>   {
> +	u64 seq = ++rdev->fence_drv[ring].sync_seq[ring];
> +
>   	/* we are protected by the ring emission mutex */
>   	*fence = kmalloc(sizeof(struct radeon_fence), GFP_KERNEL);
>   	if ((*fence) == NULL) {
>   		return -ENOMEM;
>   	}
> -	kref_init(&((*fence)->kref));
> -	(*fence)->rdev = rdev;
> -	(*fence)->seq = ++rdev->fence_drv[ring].sync_seq[ring];
>   	(*fence)->ring = ring;
> +	__fence_init(&(*fence)->base, &radeon_fence_ops,
> +		     &rdev->fence_queue.lock, rdev->fence_context + ring, seq);
> +	(*fence)->rdev = rdev;
> +	(*fence)->seq = seq;
>   	radeon_fence_ring_emit(rdev, ring, *fence);
>   	trace_radeon_fence_emit(rdev->ddev, ring, (*fence)->seq);
>   	return 0;
>   }
>   
>   /**
> - * radeon_fence_process - process a fence
> + * radeon_fence_check_signaled - callback from fence_queue
>    *
> - * @rdev: radeon_device pointer
> - * @ring: ring index the fence is associated with
> - *
> - * Checks the current fence value and wakes the fence queue
> - * if the sequence number has increased (all asics).
> + * this function is called with fence_queue lock held, which is also used
> + * for the fence locking itself, so unlocked variants are used for
> + * fence_signal, and remove_wait_queue.
>    */
> -void radeon_fence_process(struct radeon_device *rdev, int ring)
> +static int radeon_fence_check_signaled(wait_queue_t *wait, unsigned mode, int flags, void *key)
> +{
> +	struct radeon_fence *fence;
> +	u64 seq;
> +
> +	fence = container_of(wait, struct radeon_fence, fence_wake);
> +
> +	seq = atomic64_read(&fence->rdev->fence_drv[fence->ring].last_seq);
> +	if (seq >= fence->seq) {
> +		int ret = __fence_signal(&fence->base);
> +
> +		if (!ret)
> +			FENCE_TRACE(&fence->base, "signaled from irq context\n");
> +		else
> +			FENCE_TRACE(&fence->base, "was already signaled\n");
> +
> +		radeon_irq_kms_sw_irq_put(fence->rdev, fence->ring);
> +		__remove_wait_queue(&fence->rdev->fence_queue, &fence->fence_wake);
> +		fence_put(&fence->base);
> +	} else
> +		FENCE_TRACE(&fence->base, "pending\n");
> +	return 0;
> +}
> +
> +static bool __radeon_fence_process(struct radeon_device *rdev, int ring)
>   {
>   	uint64_t seq, last_seq, last_emitted;
>   	unsigned count_loop = 0;
> @@ -190,23 +224,22 @@ void radeon_fence_process(struct radeon_device *rdev, int ring)
>   		}
>   	} while (atomic64_xchg(&rdev->fence_drv[ring].last_seq, seq) > seq);
>   
> -	if (wake)
> -		wake_up_all(&rdev->fence_queue);
> +	return wake;
>   }
>   
>   /**
> - * radeon_fence_destroy - destroy a fence
> + * radeon_fence_process - process a fence
>    *
> - * @kref: fence kref
> + * @rdev: radeon_device pointer
> + * @ring: ring index the fence is associated with
>    *
> - * Frees the fence object (all asics).
> + * Checks the current fence value and wakes the fence queue
> + * if the sequence number has increased (all asics).
>    */
> -static void radeon_fence_destroy(struct kref *kref)
> +void radeon_fence_process(struct radeon_device *rdev, int ring)
>   {
> -	struct radeon_fence *fence;
> -
> -	fence = container_of(kref, struct radeon_fence, kref);
> -	kfree(fence);
> +	if (__radeon_fence_process(rdev, ring))
> +		wake_up_all(&rdev->fence_queue);
>   }
>   
>   /**
> @@ -237,6 +270,49 @@ static bool radeon_fence_seq_signaled(struct radeon_device *rdev,
>   	return false;
>   }
>   
> +static bool __radeon_fence_signaled(struct fence *f)
> +{
> +	struct radeon_fence *fence = to_radeon_fence(f);
> +
> +	return radeon_fence_seq_signaled(fence->rdev, fence->seq, fence->ring);
> +}
> +
> +/**
> + * radeon_fence_enable_signaling - enable signalling on fence
> + * @fence: fence
> + *
> + * This function is called with fence_queue lock held, and adds a callback
> + * to fence_queue that checks if this fence is signaled, and if so it
> + * signals the fence and removes itself.
> + */
> +static bool radeon_fence_enable_signaling(struct fence *f)
> +{
> +	struct radeon_fence *fence = to_radeon_fence(f);
> +
> +	if (atomic64_read(&fence->rdev->fence_drv[fence->ring].last_seq) >= fence->seq ||
> +	    !fence->rdev->ddev->irq_enabled)
> +		return false;
> +
> +	radeon_irq_kms_sw_irq_get(fence->rdev, fence->ring);
> +
> +	if (__radeon_fence_process(fence->rdev, fence->ring))
> +		wake_up_all_locked(&fence->rdev->fence_queue);
> +
> +	/* did fence get signaled after we enabled the sw irq? */
> +	if (atomic64_read(&fence->rdev->fence_drv[fence->ring].last_seq) >= fence->seq) {
> +		radeon_irq_kms_sw_irq_put(fence->rdev, fence->ring);
> +		return false;
> +	}
> +
> +	fence->fence_wake.flags = 0;
> +	fence->fence_wake.private = NULL;
> +	fence->fence_wake.func = radeon_fence_check_signaled;
> +	__add_wait_queue(&fence->rdev->fence_queue, &fence->fence_wake);
> +	fence_get(f);
> +
> +	return true;
> +}
> +
>   /**
>    * radeon_fence_signaled - check if a fence has signaled
>    *
> @@ -250,11 +326,13 @@ bool radeon_fence_signaled(struct radeon_fence *fence)
>   	if (!fence) {
>   		return true;
>   	}
> -	if (fence->seq == RADEON_FENCE_SIGNALED_SEQ) {
> -		return true;
> -	}
> +
>   	if (radeon_fence_seq_signaled(fence->rdev, fence->seq, fence->ring)) {
> -		fence->seq = RADEON_FENCE_SIGNALED_SEQ;
> +		int ret;
> +
> +		ret = fence_signal(&fence->base);
> +		if (!ret)
> +			FENCE_TRACE(&fence->base, "signaled from radeon_fence_signaled\n");
>   		return true;
>   	}
>   	return false;
> @@ -386,7 +464,7 @@ static int radeon_fence_wait_seq(struct radeon_device *rdev, u64 *target_seq,
>    * radeon_fence_wait - wait for a fence to signal
>    *
>    * @fence: radeon fence object
> - * @intr: use interruptable sleep
> + * @intr: use interruptible sleep
>    *
>    * Wait for the requested fence to signal (all asics).
>    * @intr selects whether to use interruptable (true) or non-interruptable
> @@ -398,20 +476,17 @@ int radeon_fence_wait(struct radeon_fence *fence, bool intr)
>   	uint64_t seq[RADEON_NUM_RINGS] = {};
>   	int r;
>   
> -	if (fence == NULL) {
> -		WARN(1, "Querying an invalid fence : %p !\n", fence);
> -		return -EINVAL;
> -	}
> -
> -	seq[fence->ring] = fence->seq;
> -	if (seq[fence->ring] == RADEON_FENCE_SIGNALED_SEQ)
> +	if (test_bit(FENCE_FLAG_SIGNALED_BIT, &fence->base.flags))
>   		return 0;
>   
> +	seq[fence->ring] = fence->seq;
>   	r = radeon_fence_wait_seq(fence->rdev, seq, intr);
> -	if (r)
> +	if (r) {
>   		return r;
> -
> -	fence->seq = RADEON_FENCE_SIGNALED_SEQ;
> +	}
> +	r = fence_signal(&fence->base);
> +	if (!r)
> +		FENCE_TRACE(&fence->base, "signaled from fence_wait\n");
>   	return 0;
>   }
>   
> @@ -443,12 +518,13 @@ int radeon_fence_wait_any(struct radeon_device *rdev,
>   			continue;
>   		}
>   
> +		if (test_bit(FENCE_FLAG_SIGNALED_BIT, &fences[i]->base.flags)) {
> +			/* already signaled */
> +			return 0;
> +		}
> +
>   		seq[i] = fences[i]->seq;
>   		++num_rings;
> -
> -		/* test if something was allready signaled */
> -		if (seq[i] == RADEON_FENCE_SIGNALED_SEQ)
> -			return 0;
>   	}
>   
>   	/* nothing to wait for ? */
> @@ -525,7 +601,7 @@ int radeon_fence_wait_empty(struct radeon_device *rdev, int ring)
>    */
>   struct radeon_fence *radeon_fence_ref(struct radeon_fence *fence)
>   {
> -	kref_get(&fence->kref);
> +	fence_get(&fence->base);
>   	return fence;
>   }
>   
> @@ -541,9 +617,8 @@ void radeon_fence_unref(struct radeon_fence **fence)
>   	struct radeon_fence *tmp = *fence;
>   
>   	*fence = NULL;
> -	if (tmp) {
> -		kref_put(&tmp->kref, radeon_fence_destroy);
> -	}
> +	if (tmp)
> +		fence_put(&tmp->base);
>   }
>   
>   /**
> @@ -832,3 +907,31 @@ int radeon_debugfs_fence_init(struct radeon_device *rdev)
>   	return 0;
>   #endif
>   }
> +
> +static const char *radeon_fence_get_driver_name(struct fence *fence)
> +{
> +	return "radeon";
> +}
> +
> +static const char *radeon_fence_get_timeline_name(struct fence *f)
> +{
> +	struct radeon_fence *fence = to_radeon_fence(f);
> +	switch (fence->ring) {
> +	case RADEON_RING_TYPE_GFX_INDEX: return "radeon.gfx";
> +	case CAYMAN_RING_TYPE_CP1_INDEX: return "radeon.cp1";
> +	case CAYMAN_RING_TYPE_CP2_INDEX: return "radeon.cp2";
> +	case R600_RING_TYPE_DMA_INDEX: return "radeon.dma";
> +	case CAYMAN_RING_TYPE_DMA1_INDEX: return "radeon.dma1";
> +	case R600_RING_TYPE_UVD_INDEX: return "radeon.uvd";
> +	default: WARN_ON_ONCE(1); return "radeon.unk";
> +	}
> +}
> +
> +static const struct fence_ops radeon_fence_ops = {
> +	.get_driver_name = radeon_fence_get_driver_name,
> +	.get_timeline_name = radeon_fence_get_timeline_name,
> +	.enable_signaling = radeon_fence_enable_signaling,
> +	.signaled = __radeon_fence_signaled,
> +	.wait = fence_default_wait,
> +	.release = NULL,
> +};
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel

