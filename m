Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098Ab3LBJIN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 04:08:13 -0500
Received: from mga09.intel.com ([134.134.136.24]:60583 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132Ab3LBJIL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 04:08:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,809,1378882800"; 
   d="scan'208";a="445176008"
From: ville.syrjala@linux.intel.com
To: intel-gfx@lists.freedesktop.org
Cc: pebolle@tiscali.nl, "Daniel Vetter" <daniel@ffwll.ch>,
        "Dave Airlie" <airlied@redhat.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH] drm/i915: Take modeset locks around intel_modeset_setup_hw_state()
Date: Mon,  2 Dec 2013 11:08:06 +0200
Message-Id: <1385975286-25392-1-git-send-email-ville.syrjala@linux.intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <CAKMK7uE_L8cqyYk6mQ4paXeh2m7tmoMXRv_KxoAeBq9MEAnFqw@mail.gmail.com>
References: <CAKMK7uE_L8cqyYk6mQ4paXeh2m7tmoMXRv_KxoAeBq9MEAnFqw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

Some lower level things get angry if we don't have modeset locks
during intel_modeset_setup_hw_state(). Actually the resume and
lid_notify codepaths alreday hold the locks, but the init codepath
doesn't, so fix that.

Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
---
Totally untested, but looks correct to me.

 drivers/gpu/drm/i915/intel_display.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 080f6fd..114db51 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -11046,7 +11046,9 @@ void intel_modeset_gem_init(struct drm_device *dev)
 
 	intel_setup_overlay(dev);
 
+	drm_modeset_lock_all(dev);
 	intel_modeset_setup_hw_state(dev, false);
+	drm_modeset_unlock_all(dev);
 }
 
 void intel_modeset_cleanup(struct drm_device *dev)
-- 
1.8.3.2

