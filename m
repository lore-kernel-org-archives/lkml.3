Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432AbaAMQBo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:01:44 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:52918 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372AbaAMQBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:01:33 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chris Wilson <chris@chris-wilson.co.uk>, Daniel Vetter <daniel@ffwll.ch>,
        Paulo Zanoni <paulo.r.zanoni@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 027/208] drm/i915: Do not clobber config status after a forced restore of hw state
Date: Mon, 13 Jan 2014 15:57:48 +0000
Message-Id: <1389628849-1614-28-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/i915/i915_drv.c      | 1 +
 drivers/gpu/drm/i915/intel_display.c | 3 +--
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_drv.c b/drivers/gpu/drm/i915/i915_drv.c
index 45b3c03..9180fde 100644
--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -667,6 +667,7 @@ static int __i915_drm_thaw(struct drm_device *dev)
 		intel_modeset_init_hw(dev);
 
 		drm_modeset_lock_all(dev);
+		drm_mode_config_reset(dev);
 		intel_modeset_setup_hw_state(dev, true);
 		drm_modeset_unlock_all(dev);
 
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index af3e427..ee0b38f 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -9985,8 +9985,6 @@ void intel_modeset_setup_hw_state(struct drm_device *dev,
 	}
 
 	intel_modeset_check_state(dev);
-
-	drm_mode_config_reset(dev);
 }
 
 void intel_modeset_gem_init(struct drm_device *dev)
@@ -9996,6 +9994,7 @@ void intel_modeset_gem_init(struct drm_device *dev)
 	intel_setup_overlay(dev);
 
 	drm_modeset_lock_all(dev);
+	drm_mode_config_reset(dev);
 	intel_modeset_setup_hw_state(dev, false);
 	drm_modeset_unlock_all(dev);
 }
-- 
1.8.3.2

