Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932286AbaBGNVo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 08:21:44 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41482 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754284AbaBGLsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:48:08 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
	<ville.syrjala@linux.intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 023/233] drm/i915: Don't grab crtc mutexes in intel_modeset_gem_init()
Date: Fri,  7 Feb 2014 11:44:02 +0000
Message-Id: <1391773652-25214-24-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>

commit 7ad228b11ec26a820291c9f5a1168d6176580dc1 upstream.

When the pipe A force quirk is applied the code will attempt to grab
a crtc mutex during intel_modeset_setup_hw_state(). If we're already
holding all crtc mutexes this will obviously deadlock every time.

So instead of using drm_modeset_lock_all() just grab the
mode_config.mutex. This is enough to avoid the unlocked mutex warnings
from certain lower level functions.

The regression was introduced in:

 commit 027476642811f8559cbe00ef6cc54db230e48a20
 Author: Ville Syrjälä <ville.syrjala@linux.intel.com>
 Date:   Mon Dec 2 11:08:06 2013 +0200

    drm/i915: Take modeset locks around intel_modeset_setup_hw_state()

Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
[danvet: Add cc: stable since the offending commit has that, too.]
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/i915/intel_display.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index cfe124a..0e3f213 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -9993,10 +9993,10 @@ void intel_modeset_gem_init(struct drm_device *dev)
 
 	intel_setup_overlay(dev);
 
-	drm_modeset_lock_all(dev);
+	mutex_lock(&dev->mode_config.mutex);
 	drm_mode_config_reset(dev);
 	intel_modeset_setup_hw_state(dev, false);
-	drm_modeset_unlock_all(dev);
+	mutex_unlock(&dev->mode_config.mutex);
 }
 
 void intel_modeset_cleanup(struct drm_device *dev)
-- 
1.8.3.2

