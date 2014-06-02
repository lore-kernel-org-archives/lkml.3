Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923AbaFBKpt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 06:45:49 -0400
Received: from pegasos-out.vodafone.de ([80.84.1.38]:58307 "EHLO
	pegasos-out.vodafone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843AbaFBKps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 06:45:48 -0400
X-Spam-Flag: NO
X-Spam-Score: 0.2
Authentication-Results: rohrpostix2.prod.vfnet.de (amavisd-new); dkim=pass
	header.i=@vodafone.de
X-DKIM: OpenDKIM Filter v2.6.8 pegasos-out.vodafone.de 80ED06A483C
X-DKIM: OpenDKIM Filter v2.0.2 smtp-04.vodafone.de 22451E4C13
Message-ID: <538C55CA.6050804@vodafone.de>
Date: Mon, 02 Jun 2014 12:45:30 +0200
From: =?ISO-8859-1?Q?Christian_K=F6nig?= <deathsimple@vodafone.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>, airlied@linux.ie
CC: nouveau@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [RFC PATCH v1.2 08/16] drm/radeon: use common fence implementation
 for fences
References: <20140514145134.21163.32350.stgit@patser> <20140514145809.21163.64947.stgit@patser> <53738BCC.2070809@vodafone.de> <5374131D.4010906@canonical.com> <53748702.6070606@vodafone.de> <53748AFA.8010109@canonical.com> <53748BFD.1050608@vodafone.de> <5374BB4A.6070102@canonical.com> <5374BEE2.4060608@vodafone.de> <5374CC9A.9090905@canonical.com> <5374E1B5.2020408@vodafone.de> <5374E410.1080203@canonical.com> <5374E792.4070607@vodafone.de> <5379BA04.8000901@canonical.com> <5379C06D.3050507@vodafone.de> <5379D8AD.1000904@canonical.com> <5379F96C.1060806@vodafone.de> <537A08BC.7060501@canonical.com> <537A144F.1070909@vodafone.de> <538C4D68.2030403@canonical.com>
In-Reply-To: <538C4D68.2030403@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 02.06.2014 12:09, schrieb Maarten Lankhorst:
> Changes since v1:
> - Fixed interaction with reset handling.
>   + Use exclusive_lock, either with trylock or blocking.
>   + Bump sw irq refcount in the recovery function to prevent fiddling
>     with irq registers during gpu recovery.
> - Add radeon lockup detection to the default fence wait function.

First of all please separate out adding the timeout parameter to the 
fence lock function, so we can review it on it's own.

Thanks,
Christian.

> ---
> diff --git a/drivers/gpu/drm/radeon/radeon.h 
> b/drivers/gpu/drm/radeon/radeon.h
> index 68528619834a..a7d839a158ae 100644
> --- a/drivers/gpu/drm/radeon/radeon.h
> +++ b/drivers/gpu/drm/radeon/radeon.h
> @@ -64,6 +64,7 @@
>  #include <linux/wait.h>
>  #include <linux/list.h>
>  #include <linux/kref.h>
> +#include <linux/fence.h>
>
>  #include <ttm/ttm_bo_api.h>
>  #include <ttm/ttm_bo_driver.h>
> @@ -113,9 +114,6 @@ extern int radeon_hard_reset;
>  #define RADEONFB_CONN_LIMIT            4
>  #define RADEON_BIOS_NUM_SCRATCH            8
>
> -/* fence seq are set to this number when signaled */
> -#define RADEON_FENCE_SIGNALED_SEQ        0LL
> -
>  /* internal ring indices */
>  /* r1xx+ has gfx CP ring */
>  #define RADEON_RING_TYPE_GFX_INDEX        0
> @@ -347,12 +345,15 @@ struct radeon_fence_driver {
>  };
>
>  struct radeon_fence {
> +    struct fence base;
> +
>      struct radeon_device        *rdev;
> -    struct kref            kref;
>      /* protected by radeon_fence.lock */
>      uint64_t            seq;
>      /* RB, DMA, etc. */
>      unsigned            ring;
> +
> +    wait_queue_t fence_wake;
>  };
>
>  int radeon_fence_driver_start_ring(struct radeon_device *rdev, int 
> ring);
> @@ -2256,6 +2257,7 @@ struct radeon_device {
>      struct radeon_mman        mman;
>      struct radeon_fence_driver    fence_drv[RADEON_NUM_RINGS];
>      wait_queue_head_t        fence_queue;
> +    unsigned            fence_context;
>      struct mutex            ring_lock;
>      struct radeon_ring        ring[RADEON_NUM_RINGS];
>      bool                ib_pool_ready;
> @@ -2346,11 +2348,6 @@ u32 cik_mm_rdoorbell(struct radeon_device 
> *rdev, u32 index);
>  void cik_mm_wdoorbell(struct radeon_device *rdev, u32 index, u32 v);
>
>  /*
> - * Cast helper
> - */
> -#define to_radeon_fence(p) ((struct radeon_fence *)(p))
> -
> -/*
>   * Registers read & write functions.
>   */
>  #define RREG8(reg) readb((rdev->rmmio) + (reg))
> diff --git a/drivers/gpu/drm/radeon/radeon_device.c 
> b/drivers/gpu/drm/radeon/radeon_device.c
> index 0e770bbf7e29..6800a0f6dd33 100644
> --- a/drivers/gpu/drm/radeon/radeon_device.c
> +++ b/drivers/gpu/drm/radeon/radeon_device.c
> @@ -1175,6 +1175,7 @@ int radeon_device_init(struct radeon_device *rdev,
>      for (i = 0; i < RADEON_NUM_RINGS; i++) {
>          rdev->ring[i].idx = i;
>      }
> +    rdev->fence_context = fence_context_alloc(RADEON_NUM_RINGS);
>
>      DRM_INFO("initializing kernel modesetting (%s 0x%04X:0x%04X 
> 0x%04X:0x%04X).\n",
>          radeon_family_name[rdev->family], pdev->vendor, pdev->device,
> @@ -1565,6 +1566,54 @@ int radeon_resume_kms(struct drm_device *dev, 
> bool resume, bool fbcon)
>      return 0;
>  }
>
> +static uint32_t radeon_gpu_mask_sw_irq(struct radeon_device *rdev)
> +{
> +    uint32_t mask = 0;
> +    int i;
> +
> +    if (!rdev->ddev->irq_enabled)
> +        return mask;
> +
> +    /*
> +     * increase refcount on sw interrupts for all rings to stop
> +     * enabling interrupts in radeon_fence_enable_signaling during
> +     * gpu reset.
> +     */
> +
> +    for (i = 0; i < RADEON_NUM_RINGS; ++i) {
> +        if (!rdev->ring[i].ready)
> +            continue;
> +
> +        atomic_inc(&rdev->irq.ring_int[i]);
> +        mask |= 1 << i;
> +    }
> +    return mask;
> +}
> +
> +static void radeon_gpu_unmask_sw_irq(struct radeon_device *rdev, 
> uint32_t mask)
> +{
> +    unsigned long irqflags;
> +    int i;
> +
> +    if (!mask)
> +        return;
> +
> +    /*
> +     * undo refcount increase, and reset irqs to correct value.
> +     */
> +
> +    for (i = 0; i < RADEON_NUM_RINGS; ++i) {
> +        if (!(mask & (1 << i)))
> +            continue;
> +
> +        atomic_dec(&rdev->irq.ring_int[i]);
> +    }
> +
> +    spin_lock_irqsave(&rdev->irq.lock, irqflags);
> +    radeon_irq_set(rdev);
> +    spin_unlock_irqrestore(&rdev->irq.lock, irqflags);
> +}
> +
>  /**
>   * radeon_gpu_reset - reset the asic
>   *
> @@ -1582,6 +1631,7 @@ int radeon_gpu_reset(struct radeon_device *rdev)
>
>      int i, r;
>      int resched;
> +    uint32_t sw_mask;
>
>      down_write(&rdev->exclusive_lock);
>
> @@ -1595,6 +1645,7 @@ int radeon_gpu_reset(struct radeon_device *rdev)
>      radeon_save_bios_scratch_regs(rdev);
>      /* block TTM */
>      resched = ttm_bo_lock_delayed_workqueue(&rdev->mman.bdev);
> +    sw_mask = radeon_gpu_mask_sw_irq(rdev);
>      radeon_pm_suspend(rdev);
>      radeon_suspend(rdev);
>
> @@ -1644,13 +1695,20 @@ retry:
>      radeon_pm_resume(rdev);
>      drm_helper_resume_force_mode(rdev->ddev);
>
> +    radeon_gpu_unmask_sw_irq(rdev, sw_mask);
>      ttm_bo_unlock_delayed_workqueue(&rdev->mman.bdev, resched);
>      if (r) {
>          /* bad news, how to tell it to userspace ? */
>          dev_info(rdev->dev, "GPU reset failed\n");
>      }
>
> -    up_write(&rdev->exclusive_lock);
> +    /*
> +     * force all waiters to recheck, some may have been
> +     * added while the exclusive_lock was unavailable
> +     */
> +    downgrade_write(&rdev->exclusive_lock);
> +    wake_up_all(&rdev->fence_queue);
> +    up_read(&rdev->exclusive_lock);
>      return r;
>  }
>
> diff --git a/drivers/gpu/drm/radeon/radeon_fence.c 
> b/drivers/gpu/drm/radeon/radeon_fence.c
> index a77b1c13ea43..db1f3b4708fa 100644
> --- a/drivers/gpu/drm/radeon/radeon_fence.c
> +++ b/drivers/gpu/drm/radeon/radeon_fence.c
> @@ -39,6 +39,15 @@
>  #include "radeon.h"
>  #include "radeon_trace.h"
>
> +static const struct fence_ops radeon_fence_ops;
> +
> +#define to_radeon_fence(p) \
> +    ({                                \
> +        struct radeon_fence *__f;                \
> +        __f = container_of((p), struct radeon_fence, base);    \
> +        __f->base.ops == &radeon_fence_ops ? __f : NULL;    \
> +    })
> +
>  /*
>   * Fences
>   * Fences mark an event in the GPUs pipeline and are used
> @@ -111,30 +120,55 @@ int radeon_fence_emit(struct radeon_device *rdev,
>                struct radeon_fence **fence,
>                int ring)
>  {
> +    u64 seq = ++rdev->fence_drv[ring].sync_seq[ring];
> +
>      /* we are protected by the ring emission mutex */
>      *fence = kmalloc(sizeof(struct radeon_fence), GFP_KERNEL);
>      if ((*fence) == NULL) {
>          return -ENOMEM;
>      }
> -    kref_init(&((*fence)->kref));
> -    (*fence)->rdev = rdev;
> -    (*fence)->seq = ++rdev->fence_drv[ring].sync_seq[ring];
>      (*fence)->ring = ring;
> +    __fence_init(&(*fence)->base, &radeon_fence_ops,
> +             &rdev->fence_queue.lock, rdev->fence_context + ring, seq);
> +    (*fence)->rdev = rdev;
> +    (*fence)->seq = seq;
>      radeon_fence_ring_emit(rdev, ring, *fence);
>      trace_radeon_fence_emit(rdev->ddev, ring, (*fence)->seq);
>      return 0;
>  }
>
>  /**
> - * radeon_fence_process - process a fence
> - *
> - * @rdev: radeon_device pointer
> - * @ring: ring index the fence is associated with
> + * radeon_fence_check_signaled - callback from fence_queue
>   *
> - * Checks the current fence value and wakes the fence queue
> - * if the sequence number has increased (all asics).
> + * this function is called with fence_queue lock held, which is also 
> used
> + * for the fence locking itself, so unlocked variants are used for
> + * fence_signal, and remove_wait_queue.
>   */
> -void radeon_fence_process(struct radeon_device *rdev, int ring)
> +static int radeon_fence_check_signaled(wait_queue_t *wait, unsigned 
> mode, int flags, void *key)
> +{
> +    struct radeon_fence *fence;
> +    u64 seq;
> +
> +    fence = container_of(wait, struct radeon_fence, fence_wake);
> +
> +    seq = atomic64_read(&fence->rdev->fence_drv[fence->ring].last_seq);
> +    if (seq >= fence->seq) {
> +        int ret = __fence_signal(&fence->base);
> +
> +        if (!ret)
> +            FENCE_TRACE(&fence->base, "signaled from irq context\n");
> +        else
> +            FENCE_TRACE(&fence->base, "was already signaled\n");
> +
> +        radeon_irq_kms_sw_irq_put(fence->rdev, fence->ring);
> +        __remove_wait_queue(&fence->rdev->fence_queue, 
> &fence->fence_wake);
> +        fence_put(&fence->base);
> +    } else
> +        FENCE_TRACE(&fence->base, "pending\n");
> +    return 0;
> +}
> +
> +static bool __radeon_fence_process(struct radeon_device *rdev, int ring)
>  {
>      uint64_t seq, last_seq, last_emitted;
>      unsigned count_loop = 0;
> @@ -190,23 +224,22 @@ void radeon_fence_process(struct radeon_device 
> *rdev, int ring)
>          }
>      } while (atomic64_xchg(&rdev->fence_drv[ring].last_seq, seq) > seq);
>
> -    if (wake)
> -        wake_up_all(&rdev->fence_queue);
> +    return wake;
>  }
>
>  /**
> - * radeon_fence_destroy - destroy a fence
> + * radeon_fence_process - process a fence
>   *
> - * @kref: fence kref
> + * @rdev: radeon_device pointer
> + * @ring: ring index the fence is associated with
>   *
> - * Frees the fence object (all asics).
> + * Checks the current fence value and wakes the fence queue
> + * if the sequence number has increased (all asics).
>   */
> -static void radeon_fence_destroy(struct kref *kref)
> +void radeon_fence_process(struct radeon_device *rdev, int ring)
>  {
> -    struct radeon_fence *fence;
> -
> -    fence = container_of(kref, struct radeon_fence, kref);
> -    kfree(fence);
> +    if (__radeon_fence_process(rdev, ring))
> +        wake_up_all(&rdev->fence_queue);
>  }
>
>  /**
> @@ -237,6 +270,69 @@ static bool radeon_fence_seq_signaled(struct 
> radeon_device *rdev,
>      return false;
>  }
>
> +static bool __radeon_fence_signaled(struct fence *f)
> +{
> +    struct radeon_fence *fence = to_radeon_fence(f);
> +    struct radeon_device *rdev = fence->rdev;
> +    unsigned ring = fence->ring;
> +    u64 seq = fence->seq;
> +
> +    if (atomic64_read(&rdev->fence_drv[ring].last_seq) >= seq) {
> +        return true;
> +    }
> +
> +    if (down_read_trylock(&rdev->exclusive_lock)) {
> +        radeon_fence_process(rdev, ring);
> +        up_read(&rdev->exclusive_lock);
> +
> +        if (atomic64_read(&rdev->fence_drv[ring].last_seq) >= seq) {
> +            return true;
> +        }
> +    }
> +    return false;
> +}
> +
> +/**
> + * radeon_fence_enable_signaling - enable signalling on fence
> + * @fence: fence
> + *
> + * This function is called with fence_queue lock held, and adds a 
> callback
> + * to fence_queue that checks if this fence is signaled, and if so it
> + * signals the fence and removes itself.
> + */
> +static bool radeon_fence_enable_signaling(struct fence *f)
> +{
> +    struct radeon_fence *fence = to_radeon_fence(f);
> +    struct radeon_device *rdev = fence->rdev;
> +
> +    if (atomic64_read(&rdev->fence_drv[fence->ring].last_seq) >= 
> fence->seq ||
> +        !rdev->ddev->irq_enabled)
> +        return false;
> +
> +    radeon_irq_kms_sw_irq_get(rdev, fence->ring);
> +
> +    if (down_read_trylock(&rdev->exclusive_lock)) {
> +        if (__radeon_fence_process(rdev, fence->ring))
> +            wake_up_all_locked(&rdev->fence_queue);
> +
> +        up_read(&rdev->exclusive_lock);
> +    }
> +
> +    /* did fence get signaled after we enabled the sw irq? */
> +    if (atomic64_read(&rdev->fence_drv[fence->ring].last_seq) >= 
> fence->seq) {
> +        radeon_irq_kms_sw_irq_put(rdev, fence->ring);
> +        return false;
> +    }
> +
> +    fence->fence_wake.flags = 0;
> +    fence->fence_wake.private = NULL;
> +    fence->fence_wake.func = radeon_fence_check_signaled;
> +    __add_wait_queue(&rdev->fence_queue, &fence->fence_wake);
> +    fence_get(f);
> +
> +    return true;
> +}
> +
>  /**
>   * radeon_fence_signaled - check if a fence has signaled
>   *
> @@ -250,11 +346,13 @@ bool radeon_fence_signaled(struct radeon_fence 
> *fence)
>      if (!fence) {
>          return true;
>      }
> -    if (fence->seq == RADEON_FENCE_SIGNALED_SEQ) {
> -        return true;
> -    }
> +
>      if (radeon_fence_seq_signaled(fence->rdev, fence->seq, 
> fence->ring)) {
> -        fence->seq = RADEON_FENCE_SIGNALED_SEQ;
> +        int ret;
> +
> +        ret = fence_signal(&fence->base);
> +        if (!ret)
> +            FENCE_TRACE(&fence->base, "signaled from 
> radeon_fence_signaled\n");
>          return true;
>      }
>      return false;
> @@ -283,28 +381,35 @@ static bool radeon_fence_any_seq_signaled(struct 
> radeon_device *rdev, u64 *seq)
>  }
>
>  /**
> - * radeon_fence_wait_seq - wait for a specific sequence numbers
> + * radeon_fence_wait_seq_timeout - wait for a specific sequence numbers
>   *
>   * @rdev: radeon device pointer
>   * @target_seq: sequence number(s) we want to wait for
>   * @intr: use interruptable sleep
> + * @timeout: maximum time to wait, or MAX_SCHEDULE_TIMEOUT for 
> infinite wait
>   *
>   * Wait for the requested sequence number(s) to be written by any ring
>   * (all asics).  Sequnce number array is indexed by ring id.
>   * @intr selects whether to use interruptable (true) or 
> non-interruptable
>   * (false) sleep when waiting for the sequence number.  Helper function
>   * for radeon_fence_wait_*().
> - * Returns 0 if the sequence number has passed, error for all other 
> cases.
> + * Returns remaining time if the sequence number has passed, 0 when
> + * the wait timeout, or an error for all other cases.
>   * -EDEADLK is returned when a GPU lockup has been detected.
>   */
> -static int radeon_fence_wait_seq(struct radeon_device *rdev, u64 
> *target_seq,
> -                 bool intr)
> +static int radeon_fence_wait_seq_timeout(struct radeon_device *rdev,
> +                     u64 *target_seq, bool intr,
> +                     long timeout)
>  {
>      uint64_t last_seq[RADEON_NUM_RINGS];
>      bool signaled;
> -    int i, r;
> +    int i;
>
>      while (!radeon_fence_any_seq_signaled(rdev, target_seq)) {
> +        long r, waited = timeout;
> +
> +        waited = timeout < RADEON_FENCE_JIFFIES_TIMEOUT ?
> +             timeout : RADEON_FENCE_JIFFIES_TIMEOUT;
>
>          /* Save current sequence values, used to check for GPU 
> lockups */
>          for (i = 0; i < RADEON_NUM_RINGS; ++i) {
> @@ -319,13 +424,15 @@ static int radeon_fence_wait_seq(struct 
> radeon_device *rdev, u64 *target_seq,
>          if (intr) {
>              r = wait_event_interruptible_timeout(rdev->fence_queue, (
>                  (signaled = radeon_fence_any_seq_signaled(rdev, 
> target_seq))
> -                 || rdev->needs_reset), RADEON_FENCE_JIFFIES_TIMEOUT);
> +                 || rdev->needs_reset), waited);
>          } else {
>              r = wait_event_timeout(rdev->fence_queue, (
>                  (signaled = radeon_fence_any_seq_signaled(rdev, 
> target_seq))
> -                 || rdev->needs_reset), RADEON_FENCE_JIFFIES_TIMEOUT);
> +                 || rdev->needs_reset), waited);
>          }
>
> +        timeout -= waited - r;
> +
>          for (i = 0; i < RADEON_NUM_RINGS; ++i) {
>              if (!target_seq[i])
>                  continue;
> @@ -337,6 +444,12 @@ static int radeon_fence_wait_seq(struct 
> radeon_device *rdev, u64 *target_seq,
>          if (unlikely(r < 0))
>              return r;
>
> +        /*
> +         * If this is a timed wait and the wait completely timed out 
> just return.
> +         */
> +        if (!timeout)
> +            break;
> +
>          if (unlikely(!signaled)) {
>              if (rdev->needs_reset)
>                  return -EDEADLK;
> @@ -379,14 +492,14 @@ static int radeon_fence_wait_seq(struct 
> radeon_device *rdev, u64 *target_seq,
>              }
>          }
>      }
> -    return 0;
> +    return timeout;
>  }
>
>  /**
>   * radeon_fence_wait - wait for a fence to signal
>   *
>   * @fence: radeon fence object
> - * @intr: use interruptable sleep
> + * @intr: use interruptible sleep
>   *
>   * Wait for the requested fence to signal (all asics).
>   * @intr selects whether to use interruptable (true) or 
> non-interruptable
> @@ -398,20 +511,17 @@ int radeon_fence_wait(struct radeon_fence 
> *fence, bool intr)
>      uint64_t seq[RADEON_NUM_RINGS] = {};
>      int r;
>
> -    if (fence == NULL) {
> -        WARN(1, "Querying an invalid fence : %p !\n", fence);
> -        return -EINVAL;
> -    }
> -
> -    seq[fence->ring] = fence->seq;
> -    if (seq[fence->ring] == RADEON_FENCE_SIGNALED_SEQ)
> +    if (test_bit(FENCE_FLAG_SIGNALED_BIT, &fence->base.flags))
>          return 0;
>
> -    r = radeon_fence_wait_seq(fence->rdev, seq, intr);
> -    if (r)
> +    seq[fence->ring] = fence->seq;
> +    r = radeon_fence_wait_seq_timeout(fence->rdev, seq, intr, 
> MAX_SCHEDULE_TIMEOUT);
> +    if (r < 0) {
>          return r;
> -
> -    fence->seq = RADEON_FENCE_SIGNALED_SEQ;
> +    }
> +    r = fence_signal(&fence->base);
> +    if (!r)
> +        FENCE_TRACE(&fence->base, "signaled from fence_wait\n");
>      return 0;
>  }
>
> @@ -434,7 +544,7 @@ int radeon_fence_wait_any(struct radeon_device *rdev,
>  {
>      uint64_t seq[RADEON_NUM_RINGS];
>      unsigned i, num_rings = 0;
> -    int r;
> +    long r;
>
>      for (i = 0; i < RADEON_NUM_RINGS; ++i) {
>          seq[i] = 0;
> @@ -443,20 +553,21 @@ int radeon_fence_wait_any(struct radeon_device 
> *rdev,
>              continue;
>          }
>
> +        if (test_bit(FENCE_FLAG_SIGNALED_BIT, &fences[i]->base.flags)) {
> +            /* already signaled */
> +            return 0;
> +        }
> +
>          seq[i] = fences[i]->seq;
>          ++num_rings;
> -
> -        /* test if something was allready signaled */
> -        if (seq[i] == RADEON_FENCE_SIGNALED_SEQ)
> -            return 0;
>      }
>
>      /* nothing to wait for ? */
>      if (num_rings == 0)
>          return -ENOENT;
>
> -    r = radeon_fence_wait_seq(rdev, seq, intr);
> -    if (r) {
> +    r = radeon_fence_wait_seq_timeout(rdev, seq, intr, 
> MAX_SCHEDULE_TIMEOUT);
> +    if (r < 0) {
>          return r;
>      }
>      return 0;
> @@ -475,6 +586,7 @@ int radeon_fence_wait_any(struct radeon_device *rdev,
>  int radeon_fence_wait_next(struct radeon_device *rdev, int ring)
>  {
>      uint64_t seq[RADEON_NUM_RINGS] = {};
> +    long r;
>
>      seq[ring] = atomic64_read(&rdev->fence_drv[ring].last_seq) + 1ULL;
>      if (seq[ring] >= rdev->fence_drv[ring].sync_seq[ring]) {
> @@ -482,7 +594,10 @@ int radeon_fence_wait_next(struct radeon_device 
> *rdev, int ring)
>             already the last emited fence */
>          return -ENOENT;
>      }
> -    return radeon_fence_wait_seq(rdev, seq, false);
> +    r = radeon_fence_wait_seq_timeout(rdev, seq, false, 
> MAX_SCHEDULE_TIMEOUT);
> +    if (r < 0)
> +        return r;
> +    return 0;
>  }
>
>  /**
> @@ -504,8 +619,8 @@ int radeon_fence_wait_empty(struct radeon_device 
> *rdev, int ring)
>      if (!seq[ring])
>          return 0;
>
> -    r = radeon_fence_wait_seq(rdev, seq, false);
> -    if (r) {
> +    r = radeon_fence_wait_seq_timeout(rdev, seq, false, 
> MAX_SCHEDULE_TIMEOUT);
> +    if (r < 0) {
>          if (r == -EDEADLK)
>              return -EDEADLK;
>
> @@ -525,7 +640,7 @@ int radeon_fence_wait_empty(struct radeon_device 
> *rdev, int ring)
>   */
>  struct radeon_fence *radeon_fence_ref(struct radeon_fence *fence)
>  {
> -    kref_get(&fence->kref);
> +    fence_get(&fence->base);
>      return fence;
>  }
>
> @@ -541,9 +656,8 @@ void radeon_fence_unref(struct radeon_fence **fence)
>      struct radeon_fence *tmp = *fence;
>
>      *fence = NULL;
> -    if (tmp) {
> -        kref_put(&tmp->kref, radeon_fence_destroy);
> -    }
> +    if (tmp)
> +        fence_put(&tmp->base);
>  }
>
>  /**
> @@ -832,3 +946,51 @@ int radeon_debugfs_fence_init(struct 
> radeon_device *rdev)
>      return 0;
>  #endif
>  }
> +
> +static long __radeon_fence_wait(struct fence *f, bool intr, long 
> timeout)
> +{
> +    struct radeon_fence *fence = to_radeon_fence(f);
> +    u64 target_seq[RADEON_NUM_RINGS] = {};
> +    struct radeon_device *rdev = fence->rdev;
> +    unsigned long r;
> +
> +    target_seq[fence->ring] = fence->seq;
> +
> +    down_read(&rdev->exclusive_lock);
> +    r = radeon_fence_wait_seq_timeout(fence->rdev, target_seq, intr, 
> timeout);
> +
> +    if (r > 0 && !fence_signal(&fence->base))
> +        FENCE_TRACE(&fence->base, "signaled from 
> __radeon_fence_wait\n");
> +
> +    up_read(&rdev->exclusive_lock);
> +    return r;
> +
> +}
> +
> +static const char *radeon_fence_get_driver_name(struct fence *fence)
> +{
> +    return "radeon";
> +}
> +
> +static const char *radeon_fence_get_timeline_name(struct fence *f)
> +{
> +    struct radeon_fence *fence = to_radeon_fence(f);
> +    switch (fence->ring) {
> +    case RADEON_RING_TYPE_GFX_INDEX: return "radeon.gfx";
> +    case CAYMAN_RING_TYPE_CP1_INDEX: return "radeon.cp1";
> +    case CAYMAN_RING_TYPE_CP2_INDEX: return "radeon.cp2";
> +    case R600_RING_TYPE_DMA_INDEX: return "radeon.dma";
> +    case CAYMAN_RING_TYPE_DMA1_INDEX: return "radeon.dma1";
> +    case R600_RING_TYPE_UVD_INDEX: return "radeon.uvd";
> +    default: WARN_ON_ONCE(1); return "radeon.unk";
> +    }
> +}
> +
> +static const struct fence_ops radeon_fence_ops = {
> +    .get_driver_name = radeon_fence_get_driver_name,
> +    .get_timeline_name = radeon_fence_get_timeline_name,
> +    .enable_signaling = radeon_fence_enable_signaling,
> +    .signaled = __radeon_fence_signaled,
> +    .wait = __radeon_fence_wait,
> +    .release = NULL,
> +};
>

