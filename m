Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759557AbaGOViE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 17:38:04 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54671 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933906AbaGOVhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:37:41 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 144/198] drm/i915: Reorder semaphore deadlock check
Date: Tue, 15 Jul 2014 14:30:14 -0700
Message-Id: <1405459868-15089-145-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405459868-15089-1-git-send-email-kamal@canonical.com>
References: <1405459868-15089-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 4be173813e57c7298103a83155c2391b5b167b4c upstream.

If a semaphore is waiting on another ring, which in turn happens to be
waiting on the first ring, but that second semaphore has been signalled,
we will be able to kick the second ring and so can treat the first ring
as a valid WAIT and not as HUNG.

v2: Be paranoid and cap the potential recursion depth whilst visiting
the semaphore signallers. (Mika)

References: https://bugs.freedesktop.org/show_bug.cgi?id=54226
References: https://bugs.freedesktop.org/show_bug.cgi?id=75502
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Reviewed-by: Mika Kuoppala <mika.kuoppala@intel.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/i915/i915_irq.c         | 18 ++++++++++++++----
 drivers/gpu/drm/i915/intel_ringbuffer.h |  2 +-
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_irq.c b/drivers/gpu/drm/i915/i915_irq.c
index 4ad5cc5..2093c72 100644
--- a/drivers/gpu/drm/i915/i915_irq.c
+++ b/drivers/gpu/drm/i915/i915_irq.c
@@ -2394,10 +2394,14 @@ static int semaphore_passed(struct intel_ring_buffer *ring)
 	struct intel_ring_buffer *signaller;
 	u32 seqno, ctl;
 
-	ring->hangcheck.deadlock = true;
+	ring->hangcheck.deadlock++;
 
 	signaller = semaphore_waits_for(ring, &seqno);
-	if (signaller == NULL || signaller->hangcheck.deadlock)
+	if (signaller == NULL)
+		return -1;
+
+	/* Prevent pathological recursion due to driver bugs */
+	if (signaller->hangcheck.deadlock >= I915_NUM_RINGS)
 		return -1;
 
 	/* cursory check for an unkickable deadlock */
@@ -2405,7 +2409,13 @@ static int semaphore_passed(struct intel_ring_buffer *ring)
 	if (ctl & RING_WAIT_SEMAPHORE && semaphore_passed(signaller) < 0)
 		return -1;
 
-	return i915_seqno_passed(signaller->get_seqno(signaller, false), seqno);
+	if (i915_seqno_passed(signaller->get_seqno(signaller, false), seqno))
+		return 1;
+
+	if (signaller->hangcheck.deadlock)
+		return -1;
+
+	return 0;
 }
 
 static void semaphore_clear_deadlocks(struct drm_i915_private *dev_priv)
@@ -2414,7 +2424,7 @@ static void semaphore_clear_deadlocks(struct drm_i915_private *dev_priv)
 	int i;
 
 	for_each_ring(ring, dev_priv, i)
-		ring->hangcheck.deadlock = false;
+		ring->hangcheck.deadlock = 0;
 }
 
 static enum intel_ring_hangcheck_action
diff --git a/drivers/gpu/drm/i915/intel_ringbuffer.h b/drivers/gpu/drm/i915/intel_ringbuffer.h
index 0b243ce..78b875a 100644
--- a/drivers/gpu/drm/i915/intel_ringbuffer.h
+++ b/drivers/gpu/drm/i915/intel_ringbuffer.h
@@ -42,11 +42,11 @@ enum intel_ring_hangcheck_action {
 };
 
 struct intel_ring_hangcheck {
-	bool deadlock;
 	u32 seqno;
 	u32 acthd;
 	int score;
 	enum intel_ring_hangcheck_action action;
+	int deadlock;
 };
 
 struct  intel_ring_buffer {
-- 
1.9.1

