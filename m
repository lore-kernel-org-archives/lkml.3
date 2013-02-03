Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895Ab3BCPXp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 10:23:45 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34114 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753742Ab3BCOzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:55:03 -0500
Message-Id: <20130203144645.728067627@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:47:03 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 019/128] drm/i915; Only increment the user-pin-count after successfully
 pinning the bo
In-Reply-To: <20130203144644.035172954@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 93be8788e648817d62fda33e2998eb6ca6ebf3a3 upstream.

As along the error path we do not correct the user pin-count for the
failure, we may end up with userspace believing that it has a pinned
object at offset 0 (when interrupted by a signal for example).

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/i915_gem.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -3456,14 +3456,15 @@ i915_gem_pin_ioctl(struct drm_device *de
 		goto out;
 	}
 
-	obj->user_pin_count++;
-	obj->pin_filp = file;
-	if (obj->user_pin_count == 1) {
+	if (obj->user_pin_count == 0) {
 		ret = i915_gem_object_pin(obj, args->alignment, true);
 		if (ret)
 			goto out;
 	}
 
+	obj->user_pin_count++;
+	obj->pin_filp = file;
+
 	/* XXX - flush the CPU caches for pinned objects
 	 * as the X server doesn't manage domains yet
 	 */


