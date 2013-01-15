Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933738Ab3AOX27 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 18:28:59 -0500
Received: from mail.kernel.org ([198.145.19.201]:46825 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933662Ab3AOWwb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:52:31 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Sean Paul <seanpaul@chromium.org>, Ben Widawsky <ben@bwidawsk.net>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Julien Cristau <jcristau@debian.org>
Subject: [ 118/171] drm/i915: Add wait_for in init_ring_common
Date: Tue, 15 Jan 2013 14:44:43 -0800
Message-Id: <20130115224321.865507991@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115224313.394976595@linuxfoundation.org>
References: <20130115224313.394976595@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Paul <seanpaul@chromium.org>

commit f01db988ef6f6c70a6cc36ee71e4a98a68901229 upstream.

I have seen a number of "blt ring initialization failed" messages
where the ctl or start registers are not the correct value. Upon further
inspection, if the code just waited a little bit, it would read the
correct value. Adding the wait_for to these reads should eliminate the
issue.

Signed-off-by: Sean Paul <seanpaul@chromium.org>
Reviewed-by: Ben Widawsky <ben@bwidawsk.net>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Julien Cristau <jcristau@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/intel_ringbuffer.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/i915/intel_ringbuffer.c
+++ b/drivers/gpu/drm/i915/intel_ringbuffer.c
@@ -295,9 +295,9 @@ static int init_ring_common(struct intel
 			| RING_VALID);
 
 	/* If the head is still not zero, the ring is dead */
-	if ((I915_READ_CTL(ring) & RING_VALID) == 0 ||
-	    I915_READ_START(ring) != obj->gtt_offset ||
-	    (I915_READ_HEAD(ring) & HEAD_ADDR) != 0) {
+	if (wait_for((I915_READ_CTL(ring) & RING_VALID) != 0 &&
+		     I915_READ_START(ring) == obj->gtt_offset &&
+		     (I915_READ_HEAD(ring) & HEAD_ADDR) == 0, 50)) {
 		DRM_ERROR("%s initialization failed "
 				"ctl %08x head %08x tail %08x start %08x\n",
 				ring->name,


