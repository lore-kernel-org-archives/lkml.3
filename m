Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663AbaHAQgJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 12:36:09 -0400
Received: from mail-by2lp0244.outbound.protection.outlook.com ([207.46.163.244]:56075
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750851AbaHAQgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 12:36:07 -0400
X-WSS-ID: 0N9MZFY-08-JPZ-02
X-M-MSG: 
Message-ID: <53DBC1EC.1010001@amd.com>
Date: Fri, 1 Aug 2014 18:35:56 +0200
From: =?UTF-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?= <christian.koenig@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>, <airlied@linux.ie>
CC: <thellstrom@vmware.com>, <nouveau@lists.freedesktop.org>,
        <linux-kernel@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        <bskeggs@redhat.com>, <alexander.deucher@amd.com>
Subject: Re: [PATCH 09/19] drm/radeon: handle lockup in delayed work, v2
References: <20140731153245.15061.63023.stgit@patser>
 <20140731153342.15061.54264.stgit@patser>
In-Reply-To: <20140731153342.15061.54264.stgit@patser>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.224.152.119]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(51704005)(189002)(199002)(44976005)(36756003)(87936001)(83322001)(85306004)(19580405001)(74502001)(80316001)(50986999)(19580395003)(23676002)(65816999)(76176999)(54356999)(87266999)(85202003)(106466001)(21056001)(95666004)(99396002)(105586002)(85852003)(92566001)(83072002)(64126003)(92726001)(85182001)(68736004)(97736001)(31966008)(107046002)(86362001)(83506001)(84676001)(76482001)(33656002)(77982001)(59896001)(79102001)(102836001)(50466002)(101416001)(74662001)(4396001)(65806001)(64706001)(80022001)(46102001)(81542001)(47776003)(65956001)(20776003)(81342001);DIR:OUT;SFP:;SCL:1;SRVR:CO1PR02MB046;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 029097202E
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Christian.Koenig@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 31.07.2014 um 17:33 schrieb Maarten Lankhorst:
> Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
> ---
> V1 had a nasty bug breaking gpu lockup recovery. The fix is not
> allowing radeon_fence_driver_check_lockup to take exclusive_lock,
> and kill it during lockup recovery instead.

That looks like the delayed work starts running as soon as we submit a 
fence, and not when it's needed for waiting.

Since it's a backup for failing IRQs I would rather put it into 
radeon_irq_kms.c and start/stop it when the IRQs are started/stoped.

Christian.

> ---
>   drivers/gpu/drm/radeon/radeon.h        |    3 +
>   drivers/gpu/drm/radeon/radeon_device.c |    5 +
>   drivers/gpu/drm/radeon/radeon_fence.c  |  124 ++++++++++++++++++--------------
>   drivers/gpu/drm/radeon/radeon_ring.c   |    1
>   4 files changed, 77 insertions(+), 56 deletions(-)
>
> diff --git a/drivers/gpu/drm/radeon/radeon.h b/drivers/gpu/drm/radeon/radeon.h
> index 60c47f829122..b01d88fc10cb 100644
> --- a/drivers/gpu/drm/radeon/radeon.h
> +++ b/drivers/gpu/drm/radeon/radeon.h
> @@ -347,6 +347,8 @@ struct radeon_fence_driver {
>   	uint64_t			sync_seq[RADEON_NUM_RINGS];
>   	atomic64_t			last_seq;
>   	bool				initialized;
> +	struct delayed_work	fence_check_work;
> +	struct radeon_device	*rdev;
>   };
>   
>   struct radeon_fence {
> @@ -360,6 +362,7 @@ struct radeon_fence {
>   
>   int radeon_fence_driver_start_ring(struct radeon_device *rdev, int ring);
>   int radeon_fence_driver_init(struct radeon_device *rdev);
> +void radeon_fence_cancel_delayed_check(struct radeon_device *rdev, int ring);
>   void radeon_fence_driver_fini(struct radeon_device *rdev);
>   void radeon_fence_driver_force_completion(struct radeon_device *rdev);
>   int radeon_fence_emit(struct radeon_device *rdev, struct radeon_fence **fence, int ring);
> diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
> index 697add2cd4e3..21efd32d07ee 100644
> --- a/drivers/gpu/drm/radeon/radeon_device.c
> +++ b/drivers/gpu/drm/radeon/radeon_device.c
> @@ -1637,6 +1637,11 @@ int radeon_gpu_reset(struct radeon_device *rdev)
>   	radeon_save_bios_scratch_regs(rdev);
>   	/* block TTM */
>   	resched = ttm_bo_lock_delayed_workqueue(&rdev->mman.bdev);
> +
> +	/* kill all the hangcheck tests too */
> +	for (i = 0; i < RADEON_NUM_RINGS; ++i)
> +		radeon_fence_cancel_delayed_check(rdev, i);
> +
>   	radeon_pm_suspend(rdev);
>   	radeon_suspend(rdev);
>   
> diff --git a/drivers/gpu/drm/radeon/radeon_fence.c b/drivers/gpu/drm/radeon/radeon_fence.c
> index 913787085dfa..c055acc3a271 100644
> --- a/drivers/gpu/drm/radeon/radeon_fence.c
> +++ b/drivers/gpu/drm/radeon/radeon_fence.c
> @@ -125,16 +125,7 @@ int radeon_fence_emit(struct radeon_device *rdev,
>   	return 0;
>   }
>   
> -/**
> - * radeon_fence_process - process a fence
> - *
> - * @rdev: radeon_device pointer
> - * @ring: ring index the fence is associated with
> - *
> - * Checks the current fence value and wakes the fence queue
> - * if the sequence number has increased (all asics).
> - */
> -void radeon_fence_process(struct radeon_device *rdev, int ring)
> +static bool __radeon_fence_process(struct radeon_device *rdev, int ring)
>   {
>   	uint64_t seq, last_seq, last_emitted;
>   	unsigned count_loop = 0;
> @@ -190,7 +181,51 @@ void radeon_fence_process(struct radeon_device *rdev, int ring)
>   		}
>   	} while (atomic64_xchg(&rdev->fence_drv[ring].last_seq, seq) > seq);
>   
> -	if (wake)
> +	if (seq < last_emitted)
> +		mod_delayed_work(system_power_efficient_wq,
> +				 &rdev->fence_drv[ring].fence_check_work,
> +				 RADEON_FENCE_JIFFIES_TIMEOUT);
> +
> +	return wake;
> +}
> +
> +static void radeon_fence_driver_check_lockup(struct work_struct *work)
> +{
> +	struct radeon_fence_driver *fence_drv;
> +	struct radeon_device *rdev;
> +	unsigned long iring;
> +
> +	fence_drv = container_of(work, struct radeon_fence_driver, fence_check_work.work);
> +	rdev = fence_drv->rdev;
> +	iring = fence_drv - &rdev->fence_drv[0];
> +
> +	if (__radeon_fence_process(rdev, iring))
> +		wake_up_all(&rdev->fence_queue);
> +	else if (radeon_ring_is_lockup(rdev, iring, &rdev->ring[iring])) {
> +		/* good news we believe it's a lockup */
> +		dev_warn(rdev->dev, "GPU lockup (current fence id "
> +			 "0x%016llx last fence id 0x%016llx on ring %ld)\n",
> +			 (uint64_t)atomic64_read(&fence_drv->last_seq),
> +			 fence_drv->sync_seq[iring], iring);
> +
> +		/* remember that we need an reset */
> +		rdev->needs_reset = true;
> +		wake_up_all(&rdev->fence_queue);
> +	}
> +}
> +
> +/**
> + * radeon_fence_process - process a fence
> + *
> + * @rdev: radeon_device pointer
> + * @ring: ring index the fence is associated with
> + *
> + * Checks the current fence value and wakes the fence queue
> + * if the sequence number has increased (all asics).
> + */
> +void radeon_fence_process(struct radeon_device *rdev, int ring)
> +{
> +	if (__radeon_fence_process(rdev, ring))
>   		wake_up_all(&rdev->fence_queue);
>   }
>   
> @@ -302,9 +337,10 @@ static int radeon_fence_wait_seq(struct radeon_device *rdev, u64 *target_seq,
>   {
>   	uint64_t last_seq[RADEON_NUM_RINGS];
>   	bool signaled;
> -	int i, r;
> +	int i;
>   
>   	while (!radeon_fence_any_seq_signaled(rdev, target_seq)) {
> +		long r;
>   
>   		/* Save current sequence values, used to check for GPU lockups */
>   		for (i = 0; i < RADEON_NUM_RINGS; ++i) {
> @@ -319,11 +355,11 @@ static int radeon_fence_wait_seq(struct radeon_device *rdev, u64 *target_seq,
>   		if (intr) {
>   			r = wait_event_interruptible_timeout(rdev->fence_queue, (
>   				(signaled = radeon_fence_any_seq_signaled(rdev, target_seq))
> -				 || rdev->needs_reset), RADEON_FENCE_JIFFIES_TIMEOUT);
> +				 || rdev->needs_reset), MAX_SCHEDULE_TIMEOUT);
>   		} else {
>   			r = wait_event_timeout(rdev->fence_queue, (
>   				(signaled = radeon_fence_any_seq_signaled(rdev, target_seq))
> -				 || rdev->needs_reset), RADEON_FENCE_JIFFIES_TIMEOUT);
> +				 || rdev->needs_reset), MAX_SCHEDULE_TIMEOUT);
>   		}
>   
>   		for (i = 0; i < RADEON_NUM_RINGS; ++i) {
> @@ -334,50 +370,11 @@ static int radeon_fence_wait_seq(struct radeon_device *rdev, u64 *target_seq,
>   			trace_radeon_fence_wait_end(rdev->ddev, i, target_seq[i]);
>   		}
>   
> -		if (unlikely(r < 0))
> +		if (r < 0)
>   			return r;
>   
> -		if (unlikely(!signaled)) {
> -			if (rdev->needs_reset)
> -				return -EDEADLK;
> -
> -			/* we were interrupted for some reason and fence
> -			 * isn't signaled yet, resume waiting */
> -			if (r)
> -				continue;
> -
> -			for (i = 0; i < RADEON_NUM_RINGS; ++i) {
> -				if (!target_seq[i])
> -					continue;
> -
> -				if (last_seq[i] != atomic64_read(&rdev->fence_drv[i].last_seq))
> -					break;
> -			}
> -
> -			if (i != RADEON_NUM_RINGS)
> -				continue;
> -
> -			for (i = 0; i < RADEON_NUM_RINGS; ++i) {
> -				if (!target_seq[i])
> -					continue;
> -
> -				if (radeon_ring_is_lockup(rdev, i, &rdev->ring[i]))
> -					break;
> -			}
> -
> -			if (i < RADEON_NUM_RINGS) {
> -				/* good news we believe it's a lockup */
> -				dev_warn(rdev->dev, "GPU lockup (waiting for "
> -					 "0x%016llx last fence id 0x%016llx on"
> -					 " ring %d)\n",
> -					 target_seq[i], last_seq[i], i);
> -
> -				/* remember that we need an reset */
> -				rdev->needs_reset = true;
> -				wake_up_all(&rdev->fence_queue);
> -				return -EDEADLK;
> -			}
> -		}
> +		if (rdev->needs_reset)
> +			return -EDEADLK;
>   	}
>   	return 0;
>   }
> @@ -711,6 +708,8 @@ static void radeon_fence_driver_init_ring(struct radeon_device *rdev, int ring)
>   		rdev->fence_drv[ring].sync_seq[i] = 0;
>   	atomic64_set(&rdev->fence_drv[ring].last_seq, 0);
>   	rdev->fence_drv[ring].initialized = false;
> +	INIT_DELAYED_WORK(&rdev->fence_drv[ring].fence_check_work, radeon_fence_driver_check_lockup);
> +	rdev->fence_drv[ring].rdev = rdev;
>   }
>   
>   /**
> @@ -740,6 +739,17 @@ int radeon_fence_driver_init(struct radeon_device *rdev)
>   }
>   
>   /**
> + * radeon_fence_cancel_delayed_check - cancel all delayed checks on a ring during lockup
> + *
> + * This prevents the lockup check from being done while suspend is running
> + * during a recovery from a lockup.
> + */
> +void radeon_fence_cancel_delayed_check(struct radeon_device *rdev, int ring)
> +{
> +	cancel_delayed_work_sync(&rdev->fence_drv[ring].fence_check_work);
> +}
> +
> +/**
>    * radeon_fence_driver_fini - tear down the fence driver
>    * for all possible rings.
>    *
> @@ -755,6 +765,8 @@ void radeon_fence_driver_fini(struct radeon_device *rdev)
>   	for (ring = 0; ring < RADEON_NUM_RINGS; ring++) {
>   		if (!rdev->fence_drv[ring].initialized)
>   			continue;
> +
> +		cancel_delayed_work_sync(&rdev->fence_drv[ring].fence_check_work);
>   		r = radeon_fence_wait_empty(rdev, ring);
>   		if (r) {
>   			/* no need to trigger GPU reset as we are unloading */
> diff --git a/drivers/gpu/drm/radeon/radeon_ring.c b/drivers/gpu/drm/radeon/radeon_ring.c
> index f8050f5429e2..594d871a6fce 100644
> --- a/drivers/gpu/drm/radeon/radeon_ring.c
> +++ b/drivers/gpu/drm/radeon/radeon_ring.c
> @@ -261,6 +261,7 @@ int radeon_ib_ring_tests(struct radeon_device *rdev)
>   
>   		r = radeon_ib_test(rdev, i, ring);
>   		if (r) {
> +			radeon_fence_cancel_delayed_check(rdev, i);
>   			ring->ready = false;
>   			rdev->needs_reset = false;
>   
>

