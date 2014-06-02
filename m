Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755084AbaFBN1s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 09:27:48 -0400
Received: from pegasos-out.vodafone.de ([80.84.1.38]:50127 "EHLO
	pegasos-out.vodafone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754341AbaFBN1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 09:27:46 -0400
X-Spam-Flag: NO
X-Spam-Score: -0.045
Authentication-Results: rohrpostix2.prod.vfnet.de (amavisd-new); dkim=pass
	header.i=@vodafone.de
X-DKIM: OpenDKIM Filter v2.6.8 pegasos-out.vodafone.de 3B0CD6A4BE5
X-DKIM: OpenDKIM Filter v2.0.2 smtp-04.vodafone.de 15FDAE69A8
Message-ID: <538C7BC3.6040301@vodafone.de>
Date: Mon, 02 Jun 2014 15:27:31 +0200
From: =?ISO-8859-1?Q?Christian_K=F6nig?= <deathsimple@vodafone.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>, airlied@linux.ie
CC: nouveau@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [RFC PATCH v1.3 08/16 1/2] drm/radeon: add timeout argument to
 radeon_fence_wait_seq
References: <20140514145134.21163.32350.stgit@patser> <20140514145809.21163.64947.stgit@patser> <53738BCC.2070809@vodafone.de> <5374131D.4010906@canonical.com> <53748702.6070606@vodafone.de> <53748AFA.8010109@canonical.com> <53748BFD.1050608@vodafone.de> <5374BB4A.6070102@canonical.com> <5374BEE2.4060608@vodafone.de> <5374CC9A.9090905@canonical.com> <5374E1B5.2020408@vodafone.de> <5374E410.1080203@canonical.com> <5374E792.4070607@vodafone.de> <5379BA04.8000901@canonical.com> <5379C06D.3050507@vodafone.de> <5379D8AD.1000904@canonical.com> <5379F96C.1060806@vodafone.de> <537A08BC.7060501@canonical.com> <537A144F.1070909@vodafone.de> <538C4D68.2030403@canonical.com> <538C55CA.6050804@vodafone.de> <538C78B3.8080502@canonical.com>
In-Reply-To: <538C78B3.8080502@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 02.06.2014 15:14, schrieb Maarten Lankhorst:
> This makes it possible to wait for a specific amount of time,
> rather than wait until infinity.
>
> Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
> ---
>  Splitted out version, I've noticed that I forgot to convert 
> radeon_fence_wait_empty to long r, fixed.
>  drivers/gpu/drm/radeon/radeon_fence.c | 60 
> +++++++++++++++++++++++------------
>  1 file changed, 40 insertions(+), 20 deletions(-)
>
> diff --git a/drivers/gpu/drm/radeon/radeon_fence.c 
> b/drivers/gpu/drm/radeon/radeon_fence.c
> index a77b1c13ea43..bf4bfe65a050 100644
> --- a/drivers/gpu/drm/radeon/radeon_fence.c
> +++ b/drivers/gpu/drm/radeon/radeon_fence.c
> @@ -283,28 +283,35 @@ static bool radeon_fence_any_seq_signaled(struct 
> radeon_device *rdev, u64 *seq)
>  }
>
>  /**
> - * radeon_fence_wait_seq - wait for a specific sequence numbers
> + * radeon_fence_wait_seq_timeout - wait for a specific sequence numbers

Not necessary a hard requirement, but I would like to keep the name 
since it's already long enough.

> *
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

The initialize seems to be unnecessary here.

> +
> +        waited = timeout < RADEON_FENCE_JIFFIES_TIMEOUT ?
> +             timeout : RADEON_FENCE_JIFFIES_TIMEOUT;
>
>          /* Save current sequence values, used to check for GPU 
> lockups */
>          for (i = 0; i < RADEON_NUM_RINGS; ++i) {
> @@ -319,13 +326,15 @@ static int radeon_fence_wait_seq(struct 
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
> @@ -337,6 +346,12 @@ static int radeon_fence_wait_seq(struct 
> radeon_device *rdev, u64 *target_seq,
>          if (unlikely(r < 0))
>              return r;
>
> +        /*
> +         * If this is a timed wait and the wait completely timed out 
> just return.
> +         */

Please move the "timeout -= waited..." here, after the "if (unlikely(r < 
0))". It doesn't really matter for the logic, but my feeling says that 
we should check for errors first and then make the calculation.

Apart from that the patch has my rb with those two minor things fixed.

Regards,
Christian.

> + if (!timeout)
> +            break;
> +
>          if (unlikely(!signaled)) {
>              if (rdev->needs_reset)
>                  return -EDEADLK;
> @@ -379,14 +394,14 @@ static int radeon_fence_wait_seq(struct 
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
> @@ -396,7 +411,7 @@ static int radeon_fence_wait_seq(struct 
> radeon_device *rdev, u64 *target_seq,
>  int radeon_fence_wait(struct radeon_fence *fence, bool intr)
>  {
>      uint64_t seq[RADEON_NUM_RINGS] = {};
> -    int r;
> +    long r;
>
>      if (fence == NULL) {
>          WARN(1, "Querying an invalid fence : %p !\n", fence);
> @@ -407,9 +422,10 @@ int radeon_fence_wait(struct radeon_fence *fence, 
> bool intr)
>      if (seq[fence->ring] == RADEON_FENCE_SIGNALED_SEQ)
>          return 0;
>
> -    r = radeon_fence_wait_seq(fence->rdev, seq, intr);
> -    if (r)
> +    r = radeon_fence_wait_seq_timeout(fence->rdev, seq, intr, 
> MAX_SCHEDULE_TIMEOUT);
> +    if (r < 0) {
>          return r;
> +    }
>
>      fence->seq = RADEON_FENCE_SIGNALED_SEQ;
>      return 0;
> @@ -434,7 +450,7 @@ int radeon_fence_wait_any(struct radeon_device *rdev,
>  {
>      uint64_t seq[RADEON_NUM_RINGS];
>      unsigned i, num_rings = 0;
> -    int r;
> +    long r;
>
>      for (i = 0; i < RADEON_NUM_RINGS; ++i) {
>          seq[i] = 0;
> @@ -455,8 +471,8 @@ int radeon_fence_wait_any(struct radeon_device *rdev,
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
> @@ -475,6 +491,7 @@ int radeon_fence_wait_any(struct radeon_device *rdev,
>  int radeon_fence_wait_next(struct radeon_device *rdev, int ring)
>  {
>      uint64_t seq[RADEON_NUM_RINGS] = {};
> +    long r;
>
>      seq[ring] = atomic64_read(&rdev->fence_drv[ring].last_seq) + 1ULL;
>      if (seq[ring] >= rdev->fence_drv[ring].sync_seq[ring]) {
> @@ -482,7 +499,10 @@ int radeon_fence_wait_next(struct radeon_device 
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
> @@ -498,18 +518,18 @@ int radeon_fence_wait_next(struct radeon_device 
> *rdev, int ring)
>  int radeon_fence_wait_empty(struct radeon_device *rdev, int ring)
>  {
>      uint64_t seq[RADEON_NUM_RINGS] = {};
> -    int r;
> +    long r;
>
>      seq[ring] = rdev->fence_drv[ring].sync_seq[ring];
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
> -        dev_err(rdev->dev, "error waiting for ring[%d] to become idle 
> (%d)\n",
> +        dev_err(rdev->dev, "error waiting for ring[%d] to become idle 
> (%ld)\n",
>              ring, r);
>      }
>      return 0;

