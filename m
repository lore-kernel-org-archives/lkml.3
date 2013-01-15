Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933698Ab3AOX32 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 18:29:28 -0500
Received: from mail.kernel.org ([198.145.19.201]:46811 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933654Ab3AOWw3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:52:29 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Ben Hutchings <ben@decadent.org.uk>,
        Julien Cristau <jcristau@debian.org>
Subject: [ 126/171] drm/i915: Reduce a pin-leak BUG into a WARN
Date: Tue, 15 Jan 2013 14:44:51 -0800
Message-Id: <20130115224322.435467352@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115224313.394976595@linuxfoundation.org>
References: <20130115224313.394976595@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 7e81a42e341a4f15d76624b7c02ffb21b085b56f upstream.

Pin-leaks persist and we get the perennial bug reports of machine
lockups to the BUG_ON(pin_count==MAX). If we instead loudly report that
the object cannot be pinned at that time it should prevent the driver from
locking up, and hopefully restore a semblance of working whilst still
leaving us a OOPS to debug.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Julien Cristau <jcristau@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/i915_gem.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -3318,7 +3318,8 @@ i915_gem_object_pin(struct drm_i915_gem_
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	int ret;
 
-	BUG_ON(obj->pin_count == DRM_I915_GEM_OBJECT_MAX_PIN_COUNT);
+	if (WARN_ON(obj->pin_count == DRM_I915_GEM_OBJECT_MAX_PIN_COUNT))
+		return -EBUSY;
 	WARN_ON(i915_verify_lists(dev));
 
 	if (obj->gtt_space != NULL) {


