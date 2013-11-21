Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993Ab3KURBq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 12:01:46 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:30518 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752317Ab3KURBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 12:01:21 -0500
Message-Id: <20131121170117.370418730@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 21 Nov 2013 11:59:54 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>,
        "Luis Claudio R. Goncalves" <lclaudio@uudg.org>
Subject: [PATCH RT 6/7] drm: remove preempt_disable() from
 drm_calc_vbltimestamp_from_scanoutpos()
References: <20131121165948.354971355@goodmis.org>
Content-Disposition: inline; filename=0006-drm-remove-preempt_disable-from-drm_calc_vbltimestam.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.13-rt25-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Luis captured the following:

| BUG: sleeping function called from invalid context at kernel/rtmutex.c:659
| in_atomic(): 1, irqs_disabled(): 0, pid: 517, name: Xorg
| 2 locks held by Xorg/517:
|  #0:
|  (
| &dev->vbl_lock
| ){......}
| , at:
| [<ffffffffa0024c60>] drm_vblank_get+0x30/0x2b0 [drm]
|  #1:
|  (
| &dev->vblank_time_lock
| ){......}
| , at:
| [<ffffffffa0024ce1>] drm_vblank_get+0xb1/0x2b0 [drm]
| Preemption disabled at:
| [<ffffffffa008bc95>] i915_get_vblank_timestamp+0x45/0xa0 [i915]
| CPU: 3 PID: 517 Comm: Xorg Not tainted 3.10.10-rt7+ #5
| Call Trace:
|  [<ffffffff8164b790>] dump_stack+0x19/0x1b
|  [<ffffffff8107e62f>] __might_sleep+0xff/0x170
|  [<ffffffff81651ac4>] rt_spin_lock+0x24/0x60
|  [<ffffffffa0084e67>] i915_read32+0x27/0x170 [i915]
|  [<ffffffffa008a591>] i915_pipe_enabled+0x31/0x40 [i915]
|  [<ffffffffa008a6be>] i915_get_crtc_scanoutpos+0x3e/0x1b0 [i915]
|  [<ffffffffa00245d4>] drm_calc_vbltimestamp_from_scanoutpos+0xf4/0x430 [drm]
|  [<ffffffffa008bc95>] i915_get_vblank_timestamp+0x45/0xa0 [i915]
|  [<ffffffffa0024998>] drm_get_last_vbltimestamp+0x48/0x70 [drm]
|  [<ffffffffa0024db5>] drm_vblank_get+0x185/0x2b0 [drm]
|  [<ffffffffa0025d03>] drm_wait_vblank+0x83/0x5d0 [drm]
|  [<ffffffffa00212a2>] drm_ioctl+0x552/0x6a0 [drm]
|  [<ffffffff811a0095>] do_vfs_ioctl+0x325/0x5b0
|  [<ffffffff811a03a1>] SyS_ioctl+0x81/0xa0
|  [<ffffffff8165a342>] tracesys+0xdd/0xe2

After a longer thread it was decided to drop the preempt_disable()/
enable() invocations which were meant for -RT and Mario Kleiner looks
for a replacement.

Cc: stable-rt@vger.kernel.org
Reported-By: Luis Claudio R. Goncalves <lclaudio@uudg.org>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/gpu/drm/drm_irq.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/gpu/drm/drm_irq.c b/drivers/gpu/drm/drm_irq.c
index 0f3cdda..fe7546e 100644
--- a/drivers/gpu/drm/drm_irq.c
+++ b/drivers/gpu/drm/drm_irq.c
@@ -624,11 +624,6 @@ int drm_calc_vbltimestamp_from_scanoutpos(struct drm_device *dev, int crtc,
 	 * code gets preempted or delayed for some reason.
 	 */
 	for (i = 0; i < DRM_TIMESTAMP_MAXRETRIES; i++) {
-		/* Disable preemption to make it very likely to
-		 * succeed in the first iteration even on PREEMPT_RT kernel.
-		 */
-		preempt_disable();
-
 		/* Get system timestamp before query. */
 		stime = ktime_get();
 
@@ -640,8 +635,6 @@ int drm_calc_vbltimestamp_from_scanoutpos(struct drm_device *dev, int crtc,
 		if (!drm_timestamp_monotonic)
 			mono_time_offset = ktime_get_monotonic_offset();
 
-		preempt_enable();
-
 		/* Return as no-op if scanout query unsupported or failed. */
 		if (!(vbl_status & DRM_SCANOUTPOS_VALID)) {
 			DRM_DEBUG("crtc %d : scanoutpos query failed [%d].\n",
-- 
1.8.4.rc3


