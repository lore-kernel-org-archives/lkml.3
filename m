Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633AbaEONTt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 09:19:49 -0400
Received: from pegasos-out.vodafone.de ([80.84.1.38]:54904 "EHLO
	pegasos-out.vodafone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235AbaEONTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 09:19:48 -0400
X-Spam-Flag: NO
X-Spam-Score: 0.2
Authentication-Results: rohrpostix2.prod.vfnet.de (amavisd-new); dkim=pass
	header.i=@vodafone.de
X-DKIM: OpenDKIM Filter v2.6.8 pegasos-out.vodafone.de B7C1266FA36
X-DKIM: OpenDKIM Filter v2.0.2 smtp-04.vodafone.de 93A94E4CCD
Message-ID: <5374BEE2.4060608@vodafone.de>
Date: Thu, 15 May 2014 15:19:30 +0200
From: =?ISO-8859-1?Q?Christian_K=F6nig?= <deathsimple@vodafone.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>, airlied@linux.ie
CC: nouveau@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [RFC PATCH v1 08/16] drm/radeon: use common fence implementation
 for fences
References: <20140514145134.21163.32350.stgit@patser> <20140514145809.21163.64947.stgit@patser> <53738BCC.2070809@vodafone.de> <5374131D.4010906@canonical.com> <53748702.6070606@vodafone.de> <53748AFA.8010109@canonical.com> <53748BFD.1050608@vodafone.de> <5374BB4A.6070102@canonical.com>
In-Reply-To: <5374BB4A.6070102@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 15.05.2014 15:04, schrieb Maarten Lankhorst:
> op 15-05-14 11:42, Christian König schreef:
>> Am 15.05.2014 11:38, schrieb Maarten Lankhorst:
>>> op 15-05-14 11:21, Christian König schreef:
>>>> Am 15.05.2014 03:06, schrieb Maarten Lankhorst:
>>>>> op 14-05-14 17:29, Christian König schreef:
>>>>>>> +    /* did fence get signaled after we enabled the sw irq? */
>>>>>>> +    if 
>>>>>>> (atomic64_read(&fence->rdev->fence_drv[fence->ring].last_seq) >= 
>>>>>>> fence->seq) {
>>>>>>> +        radeon_irq_kms_sw_irq_put(fence->rdev, fence->ring);
>>>>>>> +        return false;
>>>>>>> +    }
>>>>>>> +
>>>>>>> +    fence->fence_wake.flags = 0;
>>>>>>> +    fence->fence_wake.private = NULL;
>>>>>>> +    fence->fence_wake.func = radeon_fence_check_signaled;
>>>>>>> + __add_wait_queue(&fence->rdev->fence_queue, &fence->fence_wake);
>>>>>>> +    fence_get(f);
>>>>>> That looks like a race condition to me. The fence needs to be 
>>>>>> added to the wait queue before the check, not after.
>>>>>>
>>>>>> Apart from that the whole approach looks like a really bad idea 
>>>>>> to me. How for example is lockup detection supposed to happen 
>>>>>> with this? 
>>>>> It's not a race condition because fence_queue.lock is held when 
>>>>> this function is called.
>>>> Ah, I see. That's also the reason why you moved the wake_up_all out 
>>>> of the processing function.
>>> Correct. :-)
>>>>> Lockup's a bit of a weird problem, the changes wouldn't allow core 
>>>>> ttm code to handle the lockup any more,
>>>>> but any driver specific wait code would still handle this. I did 
>>>>> this by design, because in future patches the wait
>>>>> function may be called from outside of the radeon driver. The 
>>>>> official wait function takes a timeout parameter,
>>>>> so lockups wouldn't be fatal if the timeout is set to something 
>>>>> like 30*HZ for example, it would still return
>>>>> and report that the function timed out.
>>>> Timeouts help with the detection of the lockup, but not at all with 
>>>> the handling of them.
>>>>
>>>> What we essentially need is a wait callback into the driver that is 
>>>> called in non atomic context without any locks held.
>>>>
>>>> This way we can block for the fence to become signaled with a 
>>>> timeout and can then also initiate the reset handling if necessary.
>>>>
>>>> The way you designed the interface now means that the driver never 
>>>> gets a chance to wait for the hardware to become idle and so never 
>>>> has the opportunity to the reset the whole thing.
>>> You could set up a hangcheck timer like intel does, and end up with 
>>> a reliable hangcheck detection that doesn't depend on cpu waits. :-) 
>>> Or override the default wait function and restore the old behavior.
>>
>> Overriding the default wait function sounds better, please implement 
>> it this way.
>>
>> Thanks,
>> Christian. 
>
> Does this modification look sane?
Adding the timeout is on my todo list for quite some time as well, so 
this part makes sense.

> +static long __radeon_fence_wait(struct fence *f, bool intr, long 
> timeout)
> +{
> +    struct radeon_fence *fence = to_radeon_fence(f);
> +    u64 target_seq[RADEON_NUM_RINGS] = {};
> +
> +    target_seq[fence->ring] = fence->seq;
> +    return radeon_fence_wait_seq_timeout(fence->rdev, target_seq, 
> intr, timeout);
> +}
When this call is comming from outside the radeon driver you need to 
lock rdev->exclusive_lock here to make sure not to interfere with a 
possible reset.

>      .get_timeline_name = radeon_fence_get_timeline_name,
>      .enable_signaling = radeon_fence_enable_signaling,
>      .signaled = __radeon_fence_signaled,
Do we still need those callback when we implemented the wait callback?

Christian.

>
> diff --git a/drivers/gpu/drm/radeon/radeon_fence.c 
> b/drivers/gpu/drm/radeon/radeon_fence.c
> index bc844f300d3f..2d415eb2834a 100644
> --- a/drivers/gpu/drm/radeon/radeon_fence.c
> +++ b/drivers/gpu/drm/radeon/radeon_fence.c
> @@ -361,28 +361,35 @@ static bool radeon_fence_any_seq_signaled(struct 
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
> @@ -397,13 +404,15 @@ static int radeon_fence_wait_seq(struct 
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
> @@ -415,6 +424,12 @@ static int radeon_fence_wait_seq(struct 
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
> @@ -457,7 +472,7 @@ static int radeon_fence_wait_seq(struct 
> radeon_device *rdev, u64 *target_seq,
>              }
>          }
>      }
> -    return 0;
> +    return timeout;
>  }
>
>  /**
> @@ -480,8 +495,8 @@ int radeon_fence_wait(struct radeon_fence *fence, 
> bool intr)
>          return 0;
>
>      seq[fence->ring] = fence->seq;
> -    r = radeon_fence_wait_seq(fence->rdev, seq, intr);
> -    if (r) {
> +    r = radeon_fence_wait_seq_timeout(fence->rdev, seq, intr, 
> MAX_SCHEDULE_TIMEOUT);
> +    if (r < 0) {
>          return r;
>      }
>      r = fence_signal(&fence->base);
> @@ -509,7 +524,7 @@ int radeon_fence_wait_any(struct radeon_device *rdev,
>  {
>      uint64_t seq[RADEON_NUM_RINGS];
>      unsigned i, num_rings = 0;
> -    int r;
> +    long r;
>
>      for (i = 0; i < RADEON_NUM_RINGS; ++i) {
>          seq[i] = 0;
> @@ -531,8 +546,8 @@ int radeon_fence_wait_any(struct radeon_device *rdev,
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
> @@ -551,6 +566,7 @@ int radeon_fence_wait_any(struct radeon_device *rdev,
>  int radeon_fence_wait_next(struct radeon_device *rdev, int ring)
>  {
>      uint64_t seq[RADEON_NUM_RINGS] = {};
> +    long r;
>
>      seq[ring] = atomic64_read(&rdev->fence_drv[ring].last_seq) + 1ULL;
>      if (seq[ring] >= rdev->fence_drv[ring].sync_seq[ring]) {
> @@ -558,7 +574,10 @@ int radeon_fence_wait_next(struct radeon_device 
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
> @@ -580,8 +599,8 @@ int radeon_fence_wait_empty(struct radeon_device 
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
> @@ -908,6 +927,15 @@ int radeon_debugfs_fence_init(struct 
> radeon_device *rdev)
>  #endif
>  }
>
> +static long __radeon_fence_wait(struct fence *f, bool intr, long 
> timeout)
> +{
> +    struct radeon_fence *fence = to_radeon_fence(f);
> +    u64 target_seq[RADEON_NUM_RINGS] = {};
> +
> +    target_seq[fence->ring] = fence->seq;
> +    return radeon_fence_wait_seq_timeout(fence->rdev, target_seq, 
> intr, timeout);
> +}
> +
>  static const char *radeon_fence_get_driver_name(struct fence *fence)
>  {
>      return "radeon";
> @@ -932,6 +960,6 @@ static const struct fence_ops radeon_fence_ops = {
>      .get_timeline_name = radeon_fence_get_timeline_name,
>      .enable_signaling = radeon_fence_enable_signaling,
>      .signaled = __radeon_fence_signaled,
> -    .wait = fence_default_wait,
> +    .wait = __radeon_fence_wait,
>      .release = NULL,
>  };
>

