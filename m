Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182AbaGHA66 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 20:58:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55403 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbaGGXyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:54:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        Mika Kuoppala <mika.kuoppala@intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 3.15 040/122] drm/i915: Reorder semaphore deadlock check
Date: Mon,  7 Jul 2014 16:56:42 -0700
Message-Id: <20140707235735.448844403@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140707235734.234226883@linuxfoundation.org>
References: <20140707235734.234226883@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_irq.c         |   18 ++++++++++++++----
 drivers/gpu/drm/i915/intel_ringbuffer.h |    2 +-
 2 files changed, 15 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/i915/i915_irq.c
+++ b/drivers/gpu/drm/i915/i915_irq.c
@@ -2561,10 +2561,14 @@ static int semaphore_passed(struct intel
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
@@ -2572,7 +2576,13 @@ static int semaphore_passed(struct intel
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
@@ -2581,7 +2591,7 @@ static void semaphore_clear_deadlocks(st
 	int i;
 
 	for_each_ring(ring, dev_priv, i)
-		ring->hangcheck.deadlock = false;
+		ring->hangcheck.deadlock = 0;
 }
 
 static enum intel_ring_hangcheck_action
--- a/drivers/gpu/drm/i915/intel_ringbuffer.h
+++ b/drivers/gpu/drm/i915/intel_ringbuffer.h
@@ -51,7 +51,7 @@ struct intel_ring_hangcheck {
 	u32 seqno;
 	int score;
 	enum intel_ring_hangcheck_action action;
-	bool deadlock;
+	int deadlock;
 };
 
 struct  intel_ring_buffer {


