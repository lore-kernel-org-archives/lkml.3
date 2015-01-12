Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932137AbbALTBZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 14:01:25 -0500
Received: from mail-qa0-f47.google.com ([209.85.216.47]:35287 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754919AbbALTBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 14:01:22 -0500
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Daniel Vetter <daniel.vetter@intel.com>, David Airlie <airlied@linux.ie>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Jeremiah Mahler <jmmahler@gmail.com>
Subject: [PATCH v2] drm/i915: fix inconsistent brightness after resume
Date: Mon, 12 Jan 2015 11:01:03 -0800
Message-Id: <1421089263-30398-1-git-send-email-jmmahler@gmail.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <20150112184701.GA23217@hudson.localdomain>
References: <20150112184701.GA23217@hudson.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 6dda730e55f4 introduced a bug which resulted in inconsistent
brightness levels on different machines. If a suspended was entered
with the screen off some machines would resume with the screen
at minimum brightness and others at maximum brightness.

The following commands can be used to produce this behavior.

  xset dpms force off
  sleep 1
  sudo systemctl suspend
  (resume ...)

The root cause of this problem is a comparison which checks to see if
the backlight level is zero when the panel is enabled.  If it is zero,
it is set to the maximum level.  Unfortunately, not all machines have a
minimum level of zero. On those machines the level is left at the
minimum instead of begin set to the maximum.

Fix the bug by updating the comparison to check for the minimum
backlight level instead of zero.  Also, expand the comparison for
the possible case when the level is less than the minimum.

Fixes: 6dda730e55f4 ("respect the VBT minimum backlight brightness")
Signed-off-by: Jeremiah Mahler <jmmahler@gmail.com>
---

Notes:
    Changes in v2:
    
      - Expand the comparision for the possible case when
        the level is less than the minimum.

 drivers/gpu/drm/i915/intel_panel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/intel_panel.c b/drivers/gpu/drm/i915/intel_panel.c
index 4d63839..dfb783a 100644
--- a/drivers/gpu/drm/i915/intel_panel.c
+++ b/drivers/gpu/drm/i915/intel_panel.c
@@ -962,7 +962,7 @@ void intel_panel_enable_backlight(struct intel_connector *connector)
 
 	WARN_ON(panel->backlight.max == 0);
 
-	if (panel->backlight.level == 0) {
+	if (panel->backlight.level <= panel->backlight.min) {
 		panel->backlight.level = panel->backlight.max;
 		if (panel->backlight.device)
 			panel->backlight.device->props.brightness =
-- 
2.1.4

