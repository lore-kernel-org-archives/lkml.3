Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932295AbaAFWjG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 17:39:06 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47566 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932250AbaAFWi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:38:58 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eugene Shatokhin <eugene.shatokhin@rosalab.ru>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 3.12 070/144] drm/i915: dont update the dri1 breadcrumb with modesetting
Date: Mon,  6 Jan 2014 14:37:11 -0800
Message-Id: <20140106223747.358738783@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223745.326293132@linuxfoundation.org>
References: <20140106223745.326293132@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_dma.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -83,6 +83,14 @@ void i915_update_dri1_breadcrumb(struct
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


