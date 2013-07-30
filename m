Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756359Ab3G3PSU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 11:18:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55311 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755697Ab3G3PSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 11:18:07 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 07/75] drm/i915: Fix write-read race with multiple rings
Date: Tue, 30 Jul 2013 08:16:36 -0700
Message-Id: <1375197464-27962-8-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1375197464-27962-1-git-send-email-kamal@canonical.com>
References: <1375197464-27962-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 02978ff57a5bdfbf703d2bc5a4d933a53ede3144 upstream.

Daniel noticed a problem where is we wrote to an object with ring A in
the middle of a very long running batch, then executed a quick batch on
ring B before a batch that reads from the same object, its obj->ring would
now point to ring B, but its last_write_seqno would be still relative to
ring A. This would allow for the user to read from the object before the
GPU had completed the write, as set_domain would only check that ring B
had passed the last_write_seqno.

To fix this simply (and inelegantly), we bump the last_write_seqno when
switching rings so that the last_write_seqno is always relative to the
current obj->ring.

This fixes igt/tests/gem_write_read_ring_switch.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
[danvet: Add note about the newly created igt which exercises this
bug.]
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/i915/i915_gem.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 0e01617..919cc5c 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -1882,6 +1882,10 @@ i915_gem_object_move_to_active(struct drm_i915_gem_object *obj,
 	u32 seqno = intel_ring_get_seqno(ring);
 
 	BUG_ON(ring == NULL);
+	if (obj->ring != ring && obj->last_write_seqno) {
+		/* Keep the seqno relative to the current ring */
+		obj->last_write_seqno = seqno;
+	}
 	obj->ring = ring;
 
 	/* Add a reference if we're newly entering the active list. */
-- 
1.8.1.2

