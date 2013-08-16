Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951Ab3HPWhg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 18:37:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51445 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755869Ab3HPWhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:37:31 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ben Widawsky <ben@bwidawsk.net>, Dave Airlie <airlied@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 071/133] drm/i915: fix missed hunk after GT access breakage
Date: Fri, 16 Aug 2013 15:33:33 -0700
Message-Id: <1376692475-28413-72-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376692475-28413-1-git-send-email-kamal@canonical.com>
References: <1376692475-28413-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Widawsky <ben@bwidawsk.net>

commit e1b4d3036c07ff137955fb1c0197ab62534f46ec upstream.

Upon some code refactoring, a hunk was missed. This was fixed for
next, but missed the current trees, and hasn't yet been merged by Dave
Airlie. It is fixed in:
commit 907b28c56ea40629aa6595ddfa414ec2fc7da41c
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Fri Jul 19 20:36:52 2013 +0100

    drm/i915: Colocate all GT access routines in the same file

It is introduced by:
commit 181d1b9e31c668259d3798c521672afb8edd355c
Author: Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Sun Jul 21 13:16:24 2013 +0200

    drm/i915: fix up gt init sequence fallout

Reported-by: Dave Jones <davej@redhat.com>
Signed-off-by: Ben Widawsky <ben@bwidawsk.net>
Signed-off-by: Dave Airlie <airlied@redhat.com>
[ kamal: backport to 3.8 (context) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/i915/i915_dma.c | 1 +
 drivers/gpu/drm/i915/i915_drv.h | 1 +
 drivers/gpu/drm/i915/intel_pm.c | 6 ++++++
 3 files changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
index 565a889..7e5f232 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -1561,6 +1561,7 @@ int i915_driver_load(struct drm_device *dev, unsigned long flags)
 	intel_detect_pch(dev);
 
 	intel_irq_init(dev);
+	intel_pm_init(dev);
 	intel_gt_sanitize(dev);
 	intel_gt_init(dev);
 
diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index 8c661512..d47283d 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -1328,6 +1328,7 @@ void i915_hangcheck_elapsed(unsigned long data);
 void i915_handle_error(struct drm_device *dev, bool wedged);
 
 extern void intel_irq_init(struct drm_device *dev);
+extern void intel_pm_init(struct drm_device *dev);
 extern void intel_gt_init(struct drm_device *dev);
 extern void intel_gt_sanitize(struct drm_device *dev);
 
diff --git a/drivers/gpu/drm/i915/intel_pm.c b/drivers/gpu/drm/i915/intel_pm.c
index 6538d3f..b035d41 100644
--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -4447,6 +4447,12 @@ void intel_gt_init(struct drm_device *dev)
 		dev_priv->gt.force_wake_get = __gen6_gt_force_wake_get;
 		dev_priv->gt.force_wake_put = __gen6_gt_force_wake_put;
 	}
+}
+
+void intel_pm_init(struct drm_device *dev)
+{
+	struct drm_i915_private *dev_priv = dev->dev_private;
+
 	INIT_DELAYED_WORK(&dev_priv->rps.delayed_resume_work,
 			  intel_gen6_powersave_work);
 }
-- 
1.8.1.2

