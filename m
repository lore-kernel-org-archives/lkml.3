Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304AbaFEEdt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:33:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44401 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418AbaFEEWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:22:01 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Ben Hutchings <ben@decadent.org.uk>,
        Weng Meiling <wengmeiling.weng@huawei.com>
Subject: [PATCH 3.4 167/214] drm/i915; Only increment the user-pin-count after successfully pinning the bo
Date: Wed,  4 Jun 2014 21:18:50 -0700
Message-Id: <20140605041701.982182415@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Cc: Weng Meiling <wengmeiling.weng@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_gem.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -3411,14 +3411,15 @@ i915_gem_pin_ioctl(struct drm_device *de
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


