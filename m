Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759106AbaIOWgy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:36:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51159 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933071AbaIOWTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:19:17 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jiri Kosina <jkosina@suse.cz>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 170/187] drm/i915: read HEAD register back in init_ring_common() to enforce ordering
Date: Mon, 15 Sep 2014 15:09:40 -0700
Message-Id: <1410818997-9432-171-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Kosina <jkosina@suse.cz>

commit ece4a17d237a79f63fbfaf3f724a12b6d500555c upstream.

Withtout this, ring initialization fails reliabily during resume with

	[drm:init_ring_common] *ERROR* render ring initialization failed ctl 0001f001 head ffffff8804 tail 00000000 start 000e4000

This is not a complete fix, but it is verified to make the ring
initialization failures during resume much less likely.

We were not able to root-cause this bug (likely HW-specific to Gen4 chips)
yet. This is therefore used as a ducttape before problem is fully
understood and proper fix created, so that people don't suffer from
completely unusable systems in the meantime.

The discussion and debugging is happening at

	https://bugs.freedesktop.org/show_bug.cgi?id=76554

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/i915/intel_ringbuffer.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/i915/intel_ringbuffer.c b/drivers/gpu/drm/i915/intel_ringbuffer.c
index 53f5458..dfb8546 100644
--- a/drivers/gpu/drm/i915/intel_ringbuffer.c
+++ b/drivers/gpu/drm/i915/intel_ringbuffer.c
@@ -473,6 +473,9 @@ static int init_ring_common(struct intel_ring_buffer *ring)
 		}
 	}
 
+	/* Enforce ordering by reading HEAD register back */
+	I915_READ_HEAD(ring);
+
 	/* Initialize the ring. This must happen _after_ we've cleared the ring
 	 * registers with the above sequence (the readback of the HEAD registers
 	 * also enforces ordering), otherwise the hw might lose the new ring
-- 
1.9.1

