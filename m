Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757497AbaHEJeT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 05:34:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44040 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754689AbaHEJeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 05:34:17 -0400
Message-ID: <53E0A50E.6060301@canonical.com>
Date: Tue, 05 Aug 2014 11:34:06 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: =?UTF-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?= <christian.koenig@amd.com>,
        airlied@linux.ie
CC: thellstrom@vmware.com, nouveau@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        bskeggs@redhat.com, alexander.deucher@amd.com
Subject: Re: [PATCH 09/19] drm/radeon: handle lockup in delayed work, v2
References: <20140731153245.15061.63023.stgit@patser> <20140731153342.15061.54264.stgit@patser> <53DBC1EC.1010001@amd.com> <53DBD269.80807@canonical.com> <53DF462B.2060102@amd.com> <53DF4A7D.3040505@canonical.com> <53DF7516.2010408@amd.com> <53DF8BF2.4000309@canonical.com> <53DF9AC4.3010700@amd.com> <53DF9B58.8000403@canonical.com> <53DF9C88.6060107@amd.com> <53DF9F89.60202@canonical.com> <53DFA0EB.5040302@amd.com> <53DFA210.2020603@canonical.com> <53DFBD2E.5070001@amd.com>
In-Reply-To: <53DFBD2E.5070001@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

op 04-08-14 19:04, Christian König schreef:
> Am 04.08.2014 um 17:09 schrieb Maarten Lankhorst:
>> op 04-08-14 17:04, Christian König schreef:
>>> Am 04.08.2014 um 16:58 schrieb Maarten Lankhorst:
>>>> op 04-08-14 16:45, Christian König schreef:
>>>>> Am 04.08.2014 um 16:40 schrieb Maarten Lankhorst:
>>>>>> op 04-08-14 16:37, Christian König schreef:
>>>>>>>> It'a pain to deal with gpu reset.
>>>>>>> Yeah, well that's nothing new.
>>>>>>>
>>>>>>>> I've now tried other solutions but that would mean reverting to the old style during gpu lockup recovery, and only running the delayed work when !lockup.
>>>>>>>> But this meant that the timeout was useless to add. I think the cleanest is keeping the v2 patch, because potentially any waiting code can be called during lockup recovery.
>>>>>>> The lockup code itself should never call any waiting code and V2 doesn't seem to handle a couple of cases correctly either.
>>>>>>>
>>>>>>> How about moving the fence waiting out of the reset code?
>>>>>> What cases did I miss then?
>>>>>>
>>>>>> I'm curious how you want to move the fence waiting out of reset, when there are so many places that could potentially wait, like radeon_ib_get can call radeon_sa_bo_new which can do a wait, or radeon_ring_alloc that can wait on radeon_fence_wait_next, etc.
>>>>> The IB test itself doesn't needs to be protected by the exclusive lock. Only everything between radeon_save_bios_scratch_regs and radeon_ring_restore.
>>>> I'm not sure about that, what do you want to do if the ring tests fail? Do you have to retake the exclusive lock?
>>> Just set need_reset again and return -EAGAIN, that should have mostly the same effect as what we are doing right now.
>> Yeah, except for the locking the ttm delayed workqueue, but that bool should be easy to save/restore.
>> I think this could work.
>
> Actually you could activate the delayed workqueue much earlier as well.
>
> Thinking more about it that sounds like a bug in the current code, because we probably want the workqueue activated before waiting for the fence.

Ok, how about this?

Because of the downgrade_write, a second gpu reset can't be started until the first finishes.

I'm uncertain about it, I think I might either have to stop calling radeon_restore_bios_scratch_regs a second time,
or I should call save_bios_scratch_regs the second time around.

Also it feels like drm_helper_resume_force_mode should be called before downgrading exclusive_lock, but it might depend on PM restore.
Tough! Maybe move both calls to before downgrade_write?
 
commit 3644aae8581a15e3a935279287c397f7eab400ff
Author: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Date:   Tue Aug 5 10:29:23 2014 +0200

    drm/radeon: take exclusive_lock in read mode during ring tests
    
    Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>

diff --git a/drivers/gpu/drm/radeon/radeon.h b/drivers/gpu/drm/radeon/radeon.h
index 29d9cc04c04e..de14e35da002 100644
--- a/drivers/gpu/drm/radeon/radeon.h
+++ b/drivers/gpu/drm/radeon/radeon.h
@@ -2286,7 +2286,7 @@ struct radeon_device {
 	bool				need_dma32;
 	bool				accel_working;
 	bool				fastfb_working; /* IGP feature*/
-	bool				needs_reset;
+	bool				needs_reset, in_reset;
 	struct radeon_surface_reg surface_regs[RADEON_GEM_MAX_SURFACES];
 	const struct firmware *me_fw;	/* all family ME firmware */
 	const struct firmware *pfp_fw;	/* r6/700 PFP firmware */
diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
index 03686fab842d..6317b8a2ef20 100644
--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -1620,37 +1620,44 @@ int radeon_gpu_reset(struct radeon_device *rdev)
 	unsigned ring_sizes[RADEON_NUM_RINGS];
 	uint32_t *ring_data[RADEON_NUM_RINGS];
 
-	bool saved = false;
+	bool saved;
 
 	int i, r;
 	int resched;
 
+retry:
+	saved = false;
 	down_write(&rdev->exclusive_lock);
 
 	if (!rdev->needs_reset) {
+		WARN_ON(rdev->in_reset);
 		up_write(&rdev->exclusive_lock);
 		return 0;
 	}
 
 	rdev->needs_reset = false;
-
-	radeon_save_bios_scratch_regs(rdev);
-	/* block TTM */
 	resched = ttm_bo_lock_delayed_workqueue(&rdev->mman.bdev);
-	radeon_pm_suspend(rdev);
-	radeon_suspend(rdev);
 
-	for (i = 0; i < RADEON_NUM_RINGS; ++i) {
-		ring_sizes[i] = radeon_ring_backup(rdev, &rdev->ring[i],
-						   &ring_data[i]);
-		if (ring_sizes[i]) {
-			saved = true;
-			dev_info(rdev->dev, "Saved %d dwords of commands "
-				 "on ring %d.\n", ring_sizes[i], i);
+	if (!rdev->in_reset) {
+		rdev->in_reset = true;
+
+		radeon_save_bios_scratch_regs(rdev);
+		/* block TTM */
+		radeon_pm_suspend(rdev);
+		radeon_suspend(rdev);
+
+		for (i = 0; i < RADEON_NUM_RINGS; ++i) {
+			ring_sizes[i] = radeon_ring_backup(rdev, &rdev->ring[i],
+							   &ring_data[i]);
+			if (ring_sizes[i]) {
+				saved = true;
+				dev_info(rdev->dev, "Saved %d dwords of commands "
+					 "on ring %d.\n", ring_sizes[i], i);
+			}
 		}
-	}
+	} else
+		memset(ring_data, 0, sizeof(ring_data));
 
-retry:
 	r = radeon_asic_reset(rdev);
 	if (!r) {
 		dev_info(rdev->dev, "GPU reset succeeded, trying to resume\n");
@@ -1659,40 +1666,46 @@ retry:
 
 	radeon_restore_bios_scratch_regs(rdev);
 
-	if (!r) {
+	if (!r && saved) {
 		for (i = 0; i < RADEON_NUM_RINGS; ++i) {
 			radeon_ring_restore(rdev, &rdev->ring[i],
 					    ring_sizes[i], ring_data[i]);
-			ring_sizes[i] = 0;
 			ring_data[i] = NULL;
 		}
+	} else {
+		radeon_fence_driver_force_completion(rdev);
+
+		for (i = 0; i < RADEON_NUM_RINGS; ++i) {
+			kfree(ring_data[i]);
+		}
+	}
+	downgrade_write(&rdev->exclusive_lock);
+	ttm_bo_unlock_delayed_workqueue(&rdev->mman.bdev, resched);
 
+	if (!r) {
 		r = radeon_ib_ring_tests(rdev);
 		if (r) {
 			dev_err(rdev->dev, "ib ring test failed (%d).\n", r);
 			if (saved) {
-				saved = false;
+				/* if reset fails, try without saving data */
+				rdev->needs_reset = true;
 				radeon_suspend(rdev);
+				up_read(&rdev->exclusive_lock);
 				goto retry;
 			}
 		}
-	} else {
-		radeon_fence_driver_force_completion(rdev);
-		for (i = 0; i < RADEON_NUM_RINGS; ++i) {
-			kfree(ring_data[i]);
-		}
 	}
 
 	radeon_pm_resume(rdev);
 	drm_helper_resume_force_mode(rdev->ddev);
 
-	ttm_bo_unlock_delayed_workqueue(&rdev->mman.bdev, resched);
 	if (r) {
 		/* bad news, how to tell it to userspace ? */
 		dev_info(rdev->dev, "GPU reset failed\n");
 	}
 
-	up_write(&rdev->exclusive_lock);
+	rdev->in_reset = false;
+	up_read(&rdev->exclusive_lock);
 	return r;
 }
 

