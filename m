Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757627AbaHHUpt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 16:45:49 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40356 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757571AbaHHUpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:45:21 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        Mika Kuoppala <mika.kuoppala@intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 168/259] drm/i915: Reorder the semaphore deadlock check, again
Date: Fri,  8 Aug 2014 13:39:51 -0700
Message-Id: <1407530482-4483-169-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit a0d036b074b4a5a933e37fcb9bdd6b3cc80a0387 upstream.

commit 4be173813e57c7298103a83155c2391b5b167b4c
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Fri Jun 6 10:22:29 2014 +0100

    drm/i915: Reorder semaphore deadlock check

did the majority of the work, but it missed one crucial detail:

The check for the unkickable deadlock on this ring must come after the
check whether the ring that we are waiting on has already passed its
target seqno.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=80709
Tested-by: Stefan Huber <shuber@sthu.org>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Mika Kuoppala <mika.kuoppala@intel.com>
Cc: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/i915/i915_irq.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_irq.c b/drivers/gpu/drm/i915/i915_irq.c
index 2093c72..3a10da2 100644
--- a/drivers/gpu/drm/i915/i915_irq.c
+++ b/drivers/gpu/drm/i915/i915_irq.c
@@ -2392,7 +2392,7 @@ static int semaphore_passed(struct intel_ring_buffer *ring)
 {
 	struct drm_i915_private *dev_priv = ring->dev->dev_private;
 	struct intel_ring_buffer *signaller;
-	u32 seqno, ctl;
+	u32 seqno;
 
 	ring->hangcheck.deadlock++;
 
@@ -2404,15 +2404,12 @@ static int semaphore_passed(struct intel_ring_buffer *ring)
 	if (signaller->hangcheck.deadlock >= I915_NUM_RINGS)
 		return -1;
 
-	/* cursory check for an unkickable deadlock */
-	ctl = I915_READ_CTL(signaller);
-	if (ctl & RING_WAIT_SEMAPHORE && semaphore_passed(signaller) < 0)
-		return -1;
-
 	if (i915_seqno_passed(signaller->get_seqno(signaller, false), seqno))
 		return 1;
 
-	if (signaller->hangcheck.deadlock)
+	/* cursory check for an unkickable deadlock */
+	if (I915_READ_CTL(signaller) & RING_WAIT_SEMAPHORE &&
+	    semaphore_passed(signaller) < 0)
 		return -1;
 
 	return 0;
-- 
1.9.1

