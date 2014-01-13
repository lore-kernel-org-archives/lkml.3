Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587AbaAMRHU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 12:07:20 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:52910 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753355AbaAMQBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:01:32 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
	<ville.syrjala@linux.intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 026/208] drm/i915: Take modeset locks around intel_modeset_setup_hw_state()
Date: Mon, 13 Jan 2014 15:57:47 +0000
Message-Id: <1389628849-1614-27-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>

commit 027476642811f8559cbe00ef6cc54db230e48a20 upstream.

Some lower level things get angry if we don't have modeset locks
during intel_modeset_setup_hw_state(). Actually the resume and
lid_notify codepaths alreday hold the locks, but the init codepath
doesn't, so fix that.

Note: This slipped through since we only disable pipes if the
plane/pipe linking doesn't match. Which is only relevant on older
gen3 mobile machines, if the BIOS fails to set up our preferred
linking.

Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Tested-and-reported-by: Paul Bolle <pebolle@tiscali.nl>
[danvet: Add note now that I could confirm my theory with the log
files Paul Bolle provided.]
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/i915/intel_display.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 9d39620..af3e427 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -9995,7 +9995,9 @@ void intel_modeset_gem_init(struct drm_device *dev)
 
 	intel_setup_overlay(dev);
 
+	drm_modeset_lock_all(dev);
 	intel_modeset_setup_hw_state(dev, false);
+	drm_modeset_unlock_all(dev);
 }
 
 void intel_modeset_cleanup(struct drm_device *dev)
-- 
1.8.3.2

