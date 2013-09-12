Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417Ab3ILP5W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 11:57:22 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:40068 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753768Ab3ILP5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 11:57:20 -0400
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: DRI Development <dri-devel@lists.freedesktop.org>
Cc: Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 1/2] drm/i915: kill set_need_resched
Date: Thu, 12 Sep 2013 17:57:28 +0200
Message-Id: <1379001449-17380-1-git-send-email-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 1.8.4.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is just a remnant from the old days when our reset handling was
horribly racy, suffered from terribly locking issues and often happily
live-locked. Those days are now gone so we can drop the hacks and just
rip the reschedule-point out.

Reported-by: Peter Zijlstra <peterz@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
---
 drivers/gpu/drm/i915/i915_gem.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index d80f33d..3871060 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -1389,14 +1389,11 @@ out:
 		if (i915_terminally_wedged(&dev_priv->gpu_error))
 			return VM_FAULT_SIGBUS;
 	case -EAGAIN:
-		/* Give the error handler a chance to run and move the
-		 * objects off the GPU active list. Next time we service the
-		 * fault, we should be able to transition the page into the
-		 * GTT without touching the GPU (and so avoid further
-		 * EIO/EGAIN). If the GPU is wedged, then there is no issue
-		 * with coherency, just lost writes.
+		/*
+		 * EAGAIN means the gpu is hung and we'll wait for the error
+		 * handler to reset everything when re-faulting in
+		 * i915_mutex_lock_interruptible.
 		 */
-		set_need_resched();
 	case 0:
 	case -ERESTARTSYS:
 	case -EINTR:
-- 
1.8.4.rc3

