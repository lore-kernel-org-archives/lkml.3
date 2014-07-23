Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756577AbaGWNRD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 09:17:03 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48909 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756446AbaGWNQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 09:16:59 -0400
Message-ID: <53CFB5C2.7060207@canonical.com>
Date: Wed, 23 Jul 2014 15:16:50 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: =?UTF-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?= <christian.koenig@amd.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
CC: =?UTF-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?= <deathsimple@vodafone.de>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        nouveau <nouveau@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        "Deucher, Alexander" <alexander.deucher@amd.com>
Subject: Re: [Nouveau] [PATCH 09/17] drm/radeon: use common fence implementation
 for fences
References: <20140709093124.11354.3774.stgit@patser>	<53CF5B9F.1050800@amd.com>	<53CF5EFE.6070307@canonical.com>	<53CF63C2.7070407@vodafone.de>	<CAKMK7uGJj+UwcnnzA+fj_=uWPN3i0sneWkoD+wfPJ_8Q6Y-DQg@mail.gmail.com>	<53CF6622.6060803@amd.com>	<53CF699D.9070902@canonical.com>	<53CF6B18.5070107@vodafone.de>	<CAKMK7uGd65HR11thcv8KjDw-RnTa7W-QGOzFGFd+oO_hp8wyHA@mail.gmail.com>	<53CF7035.2060808@amd.com>	<53CF7191.2090008@canonical.com>	<CAKMK7uGLqzePAREsWhX0D1oN4FdqKwPgAL6x8sULpJSqYH5LwA@mail.gmail.com>	<53CF765E.7020802@vodafone.de>	<CAKMK7uE1G-EjbJ2RAXC3ZfkaCo=Gber5PJuRG623Yoz9D=FmGw@mail.gmail.com>	<53CF8010.9060809@amd.com>	<CAKMK7uEowhvc+4Jc6t2NAeE1joFaohJ6cP7sU-Akut6b3ta=1g@mail.gmail.com>	<53CF822E.7050601@amd.com>	<CAKMK7uG85KV94PTqkzvY8RPxg6ApRKHVZrD20e48GHZM=s06=w@mail.gmail.com>	<53CF84C7.2020507@vodafone.de>	<53CF8693.1040006@canonical.com>	<53CF8AB1.2000009@amd.com> <CAKMK7uEgGzKb3Vsnz0FCgFCcSM39QntEisg0JMg=HOvnwLCZgw@mail.gmail.com> <53CFAC38.9050501@amd.com>
In-Reply-To: <53CFAC38.9050501@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

op 23-07-14 14:36, Christian König schreef:
> Am 23.07.2014 12:52, schrieb Daniel Vetter:
>> On Wed, Jul 23, 2014 at 12:13 PM, Christian König
>> <christian.koenig@amd.com> wrote:
>>>> And the dma-buf would still have fences belonging to both drivers, and it
>>>> would still call from outside the driver.
>>>
>>> Calling from outside the driver is fine as long as the driver can do
>>> everything necessary to complete it's work and isn't forced into any ugly
>>> hacks and things that are not 100% reliable.
>>>
>>> So I don't see much other approach as integrating recovery code for not
>>> firing interrupts and some kind of lockup handling into the fence code as
>>> well.
>> That approach doesn't really work at that well since every driver has
>> it's own reset semantics. And we're trying to move away from global
>> reset to fine-grained reset. So stop-the-world reset is out of
>> fashion, at least for i915. As you said, reset is normal in gpus and
>> we're trying to make reset less invasive. I really don't see a point
>> in imposing a reset scheme upon all drivers and I think you have about
>> as much motivation to convert radeon to the scheme used by i915 as
>> I'll have for converting to the one used by radeon. If it would fit at
>> all.
> Oh my! No, I didn't wanted to suggest any global reset infrastructure.
>
> My idea was more that the fence framework provides a fence->process_signaling callback that is periodically called after enable_signaling is called to trigger manual signal processing in the driver.
>
> This would both be suitable as a fallback in case of not working interrupts as well as a chance for any driver to do necessary lockup handling.
I managed to do it without needing it to be part of the interface? I'm not sure whether radeon_fence_driver_recheck needs exclusive_lock, but if so it's a small change..

diff --git a/drivers/gpu/drm/radeon/radeon.h b/drivers/gpu/drm/radeon/radeon.h
index 7fbfd41479f1..51b646b9c8bb 100644
--- a/drivers/gpu/drm/radeon/radeon.h
+++ b/drivers/gpu/drm/radeon/radeon.h
@@ -345,6 +345,9 @@ struct radeon_fence_driver {
 	uint64_t			sync_seq[RADEON_NUM_RINGS];
 	atomic64_t			last_seq;
 	bool				initialized;
+	struct delayed_work		work;
+	struct radeon_device *rdev;
+	unsigned ring;
 };
 
 struct radeon_fence_cb {
diff --git a/drivers/gpu/drm/radeon/radeon_fence.c b/drivers/gpu/drm/radeon/radeon_fence.c
index da83f36dd708..955c825946ad 100644
--- a/drivers/gpu/drm/radeon/radeon_fence.c
+++ b/drivers/gpu/drm/radeon/radeon_fence.c
@@ -231,6 +231,9 @@ static bool __radeon_fence_process(struct radeon_device *rdev, int ring)
 		}
 	} while (atomic64_xchg(&rdev->fence_drv[ring].last_seq, seq) > seq);
 
+	if (!wake && last_seq < last_emitted)
+		schedule_delayed_work(&rdev->fence_drv[ring].work, jiffies_to_msecs(10));
+
 	return wake;
 }
 
@@ -815,6 +818,14 @@ int radeon_fence_driver_start_ring(struct radeon_device *rdev, int ring)
 	return 0;
 }
 
+static void radeon_fence_driver_recheck(struct work_struct *work)
+{
+	struct radeon_fence_driver *drv = container_of(work, struct radeon_fence_driver, work.work);
+
+	DRM_ERROR("omg, working!\n");
+	radeon_fence_process(drv->rdev, drv->ring);
+}
+
 /**
  * radeon_fence_driver_init_ring - init the fence driver
  * for the requested ring.
@@ -836,6 +847,10 @@ static void radeon_fence_driver_init_ring(struct radeon_device *rdev, int ring)
 		rdev->fence_drv[ring].sync_seq[i] = 0;
 	atomic64_set(&rdev->fence_drv[ring].last_seq, 0);
 	rdev->fence_drv[ring].initialized = false;
+
+	rdev->fence_drv[ring].ring = ring;
+	rdev->fence_drv[ring].rdev = rdev;
+	INIT_DELAYED_WORK(&rdev->fence_drv[ring].work, radeon_fence_driver_recheck);
 }
 
 /**
@@ -880,6 +895,7 @@ void radeon_fence_driver_fini(struct radeon_device *rdev)
 	for (ring = 0; ring < RADEON_NUM_RINGS; ring++) {
 		if (!rdev->fence_drv[ring].initialized)
 			continue;
+		cancel_delayed_work_sync(&rdev->fence_drv[ring].work);
 		r = radeon_fence_wait_empty(rdev, ring);
 		if (r) {
 			/* no need to trigger GPU reset as we are unloading */
diff --git a/drivers/gpu/drm/radeon/radeon_irq_kms.c b/drivers/gpu/drm/radeon/radeon_irq_kms.c
index 16807afab362..85391ddd3ce9 100644
--- a/drivers/gpu/drm/radeon/radeon_irq_kms.c
+++ b/drivers/gpu/drm/radeon/radeon_irq_kms.c
@@ -331,7 +331,7 @@ void radeon_irq_kms_sw_irq_get(struct radeon_device *rdev, int ring)
 {
 	unsigned long irqflags;
 
-	if (!rdev->ddev->irq_enabled)
+//	if (!rdev->ddev->irq_enabled)
 		return;
 
 	if (atomic_inc_return(&rdev->irq.ring_int[ring]) == 1) {
@@ -355,7 +355,7 @@ void radeon_irq_kms_sw_irq_put(struct radeon_device *rdev, int ring)
 {
 	unsigned long irqflags;
 
-	if (!rdev->ddev->irq_enabled)
+//	if (!rdev->ddev->irq_enabled)
 		return;
 
 	if (atomic_dec_and_test(&rdev->irq.ring_int[ring])) {

