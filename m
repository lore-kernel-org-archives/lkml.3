Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880AbaAOV64 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 16:58:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41148 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753820AbaAOV6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 16:58:42 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eugene Shatokhin <eugene.shatokhin@rosalab.ru>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 065/166] drm/i915: don't update the dri1 breadcrumb with modesetting
Date: Wed, 15 Jan 2014 13:51:19 -0800
Message-Id: <1389822780-4729-66-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389822780-4729-1-git-send-email-kamal@canonical.com>
References: <1389822780-4729-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit 6c719faca2aceca72f1bf5b1645c1734ed3e9447 upstream.

The update is horribly racy since it doesn't protect at all against
concurrent closing of the master fd. And it can't really since that
requires us to grab a mutex.

Instead of jumping through hoops and offloading this to a worker
thread just block this bit of code for the modesetting driver.

Note that the race is fairly easy to hit since we call the breadcrumb
function for any interrupt. So the vblank interrupt (which usually
keeps going for a bit) is enough. But even if we'd block this and only
update the breadcrumb for user interrupts from the CS we could hit
this race with kms/gem userspace: If a non-master is waiting somewhere
(and hence has interrupts enabled) and the master closes its fd
(probably due to crashing).

v2: Add a code comment to explain why fixing this for real isn't
really worth it. Also improve the commit message a bit.

v3: Fix the spelling in the comment.

Reported-by: Eugene Shatokhin <eugene.shatokhin@rosalab.ru>
Cc: Eugene Shatokhin <eugene.shatokhin@rosalab.ru>
Acked-by: Chris Wilson <chris@chris-wilson.co.uk>
Tested-by: Eugene Shatokhin <eugene.shatokhin@rosalab.ru>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/i915/i915_dma.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
index 92896bf..bb98a4e 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -84,6 +84,14 @@ void i915_update_dri1_breadcrumb(struct drm_device *dev)
 	drm_i915_private_t *dev_priv = dev->dev_private;
 	struct drm_i915_master_private *master_priv;
 
+	/*
+	 * The dri breadcrumb update races against the drm master disappearing.
+	 * Instead of trying to fix this (this is by far not the only ums issue)
+	 * just don't do the update in kms mode.
+	 */
+	if (drm_core_check_feature(dev, DRIVER_MODESET))
+		return;
+
 	if (dev->primary->master) {
 		master_priv = dev->primary->master->driver_priv;
 		if (master_priv->sarea_priv)
-- 
1.8.3.2

