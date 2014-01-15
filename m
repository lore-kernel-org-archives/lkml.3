Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608AbaAOWSo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 17:18:44 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41174 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753853AbaAOV6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 16:58:50 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chris Wilson <chris@chris-wilson.co.uk>, Daniel Vetter <daniel@ffwll.ch>,
        Paulo Zanoni <paulo.r.zanoni@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 059/166] drm/i915: Do not clobber config status after a forced restore of hw state
Date: Wed, 15 Jan 2014 13:51:13 -0800
Message-Id: <1389822780-4729-60-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389822780-4729-1-git-send-email-kamal@canonical.com>
References: <1389822780-4729-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit edd5b13313551d6b04acfb90d3db58ed3cf3c814 upstream.

We call intel_modeset_setup_hw_state() along two paths, driver
load/resume and after a lid event notification. During initialisation of
the driver, it is imperative that we reset the config state. This
correctly sets up the initial connector statuses and prepares the
hardware for a thorough probing. However, during a lid event, we only
want to undo the damage caused by the bios by resetting our last known
mode. In this cirumstance, we do not want to clobber our desired state.

In order to try and keep sanity between the config state and our own
tracking, do the drm_mode_config_reset() first along the load/resume
paths before reading out the hw state and apply any definite known
corrections.

v2: "As discussed on irc I don't think we should force the connector
state to anything here: Imo connector->status should reflect what we
believe to be the true output connection state, whereas connector->encoder
reflects whether this connector is wired up to a pipe. And since we no
longer reject modeset on disconnected connectors and never nuked the pipe
if the connector gets disconnected there's no reason for that - such policy
is userspace's job.

This regression has been introduced in

commit 2e9388923e83bc4e2726f170a984621f1d582e77
Author: Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Thu Oct 11 20:08:24 2012 +0200

    drm/i915/crt: explicitly set up HOTPLUG_BITS on resume"
so sayeth Daniel.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Paulo Zanoni <paulo.r.zanoni@intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
[ kamal: backport to 3.8 (context) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/i915/i915_drv.c      | 1 +
 drivers/gpu/drm/i915/intel_display.c | 3 +--
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_drv.c b/drivers/gpu/drm/i915/i915_drv.c
index a749aca..bfa8910 100644
--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -590,6 +590,7 @@ static int __i915_drm_thaw(struct drm_device *dev)
 		mutex_unlock(&dev->struct_mutex);
 
 		intel_modeset_init_hw(dev);
+		drm_mode_config_reset(dev);
 		intel_modeset_setup_hw_state(dev, false);
 		drm_irq_install(dev);
 	}
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 82fcb37..5b769a7 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -9357,8 +9357,6 @@ void intel_modeset_setup_hw_state(struct drm_device *dev,
 	}
 
 	intel_modeset_check_state(dev);
-
-	drm_mode_config_reset(dev);
 }
 
 void intel_modeset_gem_init(struct drm_device *dev)
@@ -9367,6 +9365,7 @@ void intel_modeset_gem_init(struct drm_device *dev)
 
 	intel_setup_overlay(dev);
 
+	drm_mode_config_reset(dev);
 	intel_modeset_setup_hw_state(dev, false);
 }
 
-- 
1.8.3.2

