Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932243AbaAWOQM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 09:16:12 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:52214 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932160AbaAWOQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 09:16:04 -0500
From: David Herrmann <dh.herrmann@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: Ingo Molnar <mingo@kernel.org>, linux-fbdev@vger.kernel.org,
        Dave Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-kernel@vger.kernel.org,
        Tom Gundersen <teg@jklm.no>, David Herrmann <dh.herrmann@gmail.com>
Subject: [PATCH 08/11] drm/i915: remove sysfbs early
Date: Thu, 23 Jan 2014 15:15:00 +0100
Message-Id: <1390486503-1504-9-git-send-email-dh.herrmann@gmail.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1390486503-1504-1-git-send-email-dh.herrmann@gmail.com>
References: <1390486503-1504-1-git-send-email-dh.herrmann@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Once we allow DRM drivers for system-framebuffers, we need to evict such
devices *before* probing the real driver. A simple call to sysfb_claim()
does this and remove_conflicting_framebuffers() implicitly calls this.
However, it causes the sysfb device to be unloaded and thus locks
drm_global_mutex. remove_conflicting_framebuffers() must be called from
outside any ->load() callback to avoid a dead-lock.

All other DRM drivers call this right before probing the pci-device, which
is fine. For i915 we need to figure out the apertures before we can evict
fw-framebuffers, though. This turns out to be not as easy as you might
think, so lets just evict all sysfbs for now before loading i915.

A proper fix would be to make DRM code allow parallel device probing.
That's not going to happen soon, so be safe and make i915 evict all
sysfbs.

Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
---
 drivers/gpu/drm/i915/i915_drv.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/i915/i915_drv.c b/drivers/gpu/drm/i915/i915_drv.c
index 43245b3..ceb875a 100644
--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -838,6 +838,12 @@ static int i915_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	driver.driver_features &= ~(DRIVER_USE_AGP);
 
+	/* We cannot call remove_conflicting_framebuffers() here as we cannot
+	 * easily figure out the apertures here. So lets just remove all
+	 * system-framebuffers early so we don't deadlock later when calling it
+	 * with drm_global_mutex held. */
+	sysfb_claim(NULL, SYSFB_CLAIM_ALL);
+
 	return drm_get_pci_dev(pdev, ent, &driver);
 }
 
-- 
1.8.5.3

