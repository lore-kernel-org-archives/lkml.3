Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856AbaGPVEb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:04:31 -0400
Received: from www.linutronix.de ([62.245.132.108]:59711 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830AbaGPVE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:04:28 -0400
Message-Id: <20140716205054.363898065@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 16 Jul 2014 21:04:26 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [patch V2 26/64] drm: Use ktime_mono_to_real()
References: <20140716205018.175419210@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=drm-use-ktime-mono-to-real.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the monotonic timestamp with ktime_mono_to_real() in
drm_calc_vbltimestamp_from_scanoutpos().

In get_drm_timestamp we can call either ktime_get() or
ktime_get_real() depending on drm_timestamp_monotonic. No point in
having two calls into the core for CLOCK_REALTIME.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/gpu/drm/drm_irq.c |   16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)
Index: tip/drivers/gpu/drm/drm_irq.c
===================================================================
--- tip.orig/drivers/gpu/drm/drm_irq.c
+++ tip/drivers/gpu/drm/drm_irq.c
@@ -542,8 +542,8 @@ int drm_calc_vbltimestamp_from_scanoutpo
 					  const struct drm_crtc *refcrtc,
 					  const struct drm_display_mode *mode)
 {
-	ktime_t stime, etime, mono_time_offset;
 	struct timeval tv_etime;
+	ktime_t stime, etime;
 	int vbl_status;
 	int vpos, hpos, i;
 	int framedur_ns, linedur_ns, pixeldur_ns, delta_ns, duration_ns;
@@ -588,13 +588,6 @@ int drm_calc_vbltimestamp_from_scanoutpo
 		vbl_status = dev->driver->get_scanout_position(dev, crtc, flags, &vpos,
 							       &hpos, &stime, &etime);
 
-		/*
-		 * Get correction for CLOCK_MONOTONIC -> CLOCK_REALTIME if
-		 * CLOCK_REALTIME is requested.
-		 */
-		if (!drm_timestamp_monotonic)
-			mono_time_offset = ktime_get_monotonic_offset();
-
 		/* Return as no-op if scanout query unsupported or failed. */
 		if (!(vbl_status & DRM_SCANOUTPOS_VALID)) {
 			DRM_DEBUG("crtc %d : scanoutpos query failed [%d].\n",
@@ -633,7 +626,7 @@ int drm_calc_vbltimestamp_from_scanoutpo
 	delta_ns = vpos * linedur_ns + hpos * pixeldur_ns;
 
 	if (!drm_timestamp_monotonic)
-		etime = ktime_sub(etime, mono_time_offset);
+		etime = ktime_mono_to_real(etime);
 
 	/* save this only for debugging purposes */
 	tv_etime = ktime_to_timeval(etime);
@@ -664,10 +657,7 @@ static struct timeval get_drm_timestamp(
 {
 	ktime_t now;
 
-	now = ktime_get();
-	if (!drm_timestamp_monotonic)
-		now = ktime_sub(now, ktime_get_monotonic_offset());
-
+	now = drm_timestamp_monotonic ? ktime_get() : ktime_get_real();
 	return ktime_to_timeval(now);
 }
 


