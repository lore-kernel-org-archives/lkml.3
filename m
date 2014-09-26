Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526AbaIZJ4o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 05:56:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32932 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755114AbaIZJqr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:46:47 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 134/142] drm/radeon: enable bapm by default on desktop TN/RL boards
Date: Fri, 26 Sep 2014 11:45:45 +0200
Message-Id: <e8dbfe481cdad75166b36b0f31cdf87bd6f1ddde.1411724724.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 0c78a44964db3d483b0c09a8236e0fe123aa9cfc upstream.

bapm enabled the GPU and CPU to share TDP headroom.  It was
disabled by default since some laptops hung when it was enabled
in conjunction with dpm.  It seems to be stable on desktop
boards and fixes hangs on boot with dpm enabled on certain
boards, so enable it by default on desktop boards.

bug:
https://bugs.freedesktop.org/show_bug.cgi?id=72921

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/radeon/trinity_dpm.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/trinity_dpm.c b/drivers/gpu/drm/radeon/trinity_dpm.c
index d700698a1f22..37023884d102 100644
--- a/drivers/gpu/drm/radeon/trinity_dpm.c
+++ b/drivers/gpu/drm/radeon/trinity_dpm.c
@@ -1868,7 +1868,15 @@ int trinity_dpm_init(struct radeon_device *rdev)
 	for (i = 0; i < SUMO_MAX_HARDWARE_POWERLEVELS; i++)
 		pi->at[i] = TRINITY_AT_DFLT;
 
-	pi->enable_bapm = false;
+	/* There are stability issues reported on latops with
+	 * bapm installed when switching between AC and battery
+	 * power.  At the same time, some desktop boards hang
+	 * if it's not enabled and dpm is enabled.
+	 */
+	if (rdev->flags & RADEON_IS_MOBILITY)
+		pi->enable_bapm = false;
+	else
+		pi->enable_bapm = true;
 	pi->enable_nbps_policy = true;
 	pi->enable_sclk_ds = true;
 	pi->enable_gfx_power_gating = true;
-- 
2.1.0

