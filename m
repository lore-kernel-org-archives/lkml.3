Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076Ab3HBKju (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:39:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37435 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030489Ab3HBKLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:11:43 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jon Bloomfield <jon.bloomfield@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Carsten Emde <C.Emde@osadl.org>
Subject: [ 76/99] drm/i915: Fix incoherence with fence updates on Sandybridge+
Date: Fri,  2 Aug 2013 18:08:29 +0800
Message-Id: <20130802100236.556760240@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.4.841.g1a3f60e
In-Reply-To: <20130802100225.478715166@linuxfoundation.org>
References: <20130802100225.478715166@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit d18b9619034230b6f945e215276425636ca401fe upstream.

This hopefully fixes the root cause behind the workaround added in

commit 25ff1195f8a0b3724541ae7bbe331b4296de9c06
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Thu Apr 4 21:31:03 2013 +0100

    drm/i915: Workaround incoherence between fences and LLC across multiple CPUs

Thanks to further investigation by Jon Bloomfield, he realised that
the 64-bit register might be broken up by the hardware into two 32-bit
writes (a problem we have encountered elsewhere). This non-atomicity
would then cause an issue where a second thread would see an
intermediate register state (new high dword, old low dword), and this
register would randomly be used in preference to its own thread register.
This would cause the second thread to read from and write into a fairly
random tiled location.  Breaking the operation into 3 explicit 32-bit
updates (first disable the fence, poke the upper bits, then poke the lower
bits and enable) ensures that, given proper serialisation between the
32-bit register write and the memory transfer, that the fence value is
always consistent.

Armed with this knowledge, we can explain how the previous workaround
work. The key to the corruption is that a second thread sees an
erroneous fence register that conflicts and overrides its own. By
serialising the fence update across all CPUs, we have a small window
where no GTT access is occurring and so hide the potential corruption.
This also leads to the conclusion that the earlier workaround was
incomplete.

v2: Be overly paranoid about the order in which fence updates become
visible to the GPU to make really sure that we turn the fence off before
doing the update, and then only switch the fence on afterwards.

Signed-off-by: Jon Bloomfield <jon.bloomfield@intel.com>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Carsten Emde <C.Emde@osadl.org>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_gem.c |   30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -2538,7 +2538,6 @@ static void i965_write_fence_reg(struct
 	drm_i915_private_t *dev_priv = dev->dev_private;
 	int fence_reg;
 	int fence_pitch_shift;
-	uint64_t val;
 
 	if (INTEL_INFO(dev)->gen >= 6) {
 		fence_reg = FENCE_REG_SANDYBRIDGE_0;
@@ -2548,8 +2547,23 @@ static void i965_write_fence_reg(struct
 		fence_pitch_shift = I965_FENCE_PITCH_SHIFT;
 	}
 
+	fence_reg += reg * 8;
+
+	/* To w/a incoherency with non-atomic 64-bit register updates,
+	 * we split the 64-bit update into two 32-bit writes. In order
+	 * for a partial fence not to be evaluated between writes, we
+	 * precede the update with write to turn off the fence register,
+	 * and only enable the fence as the last step.
+	 *
+	 * For extra levels of paranoia, we make sure each step lands
+	 * before applying the next step.
+	 */
+	I915_WRITE(fence_reg, 0);
+	POSTING_READ(fence_reg);
+
 	if (obj) {
 		u32 size = obj->gtt_space->size;
+		uint64_t val;
 
 		val = (uint64_t)((obj->gtt_offset + size - 4096) &
 				 0xfffff000) << 32;
@@ -2558,12 +2572,16 @@ static void i965_write_fence_reg(struct
 		if (obj->tiling_mode == I915_TILING_Y)
 			val |= 1 << I965_FENCE_TILING_Y_SHIFT;
 		val |= I965_FENCE_REG_VALID;
-	} else
-		val = 0;
 
-	fence_reg += reg * 8;
-	I915_WRITE64(fence_reg, val);
-	POSTING_READ(fence_reg);
+		I915_WRITE(fence_reg + 4, val >> 32);
+		POSTING_READ(fence_reg + 4);
+
+		I915_WRITE(fence_reg + 0, val);
+		POSTING_READ(fence_reg);
+	} else {
+		I915_WRITE(fence_reg + 4, 0);
+		POSTING_READ(fence_reg + 4);
+	}
 }
 
 static void i915_write_fence_reg(struct drm_device *dev, int reg,


