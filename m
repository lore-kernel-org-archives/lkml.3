Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758359AbaHHWbA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 18:31:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40184 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756522AbaHHUlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:41:50 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 149/259] drm/radeon: avoid leaking edid data
Date: Fri,  8 Aug 2014 13:39:32 -0700
Message-Id: <1407530482-4483-150-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 0ac66effe7fcdee55bda6d5d10d3372c95a41920 upstream.

In some cases we fetch the edid in the detect() callback
in order to determine what sort of monitor is connected.
If that happens, don't fetch the edid again in the get_modes()
callback or we will leak the edid.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_display.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/radeon/radeon_display.c b/drivers/gpu/drm/radeon/radeon_display.c
index f3514ea..f41c080 100644
--- a/drivers/gpu/drm/radeon/radeon_display.c
+++ b/drivers/gpu/drm/radeon/radeon_display.c
@@ -753,6 +753,10 @@ int radeon_ddc_get_modes(struct radeon_connector *radeon_connector)
 	struct radeon_device *rdev = dev->dev_private;
 	int ret = 0;
 
+	/* don't leak the edid if we already fetched it in detect() */
+	if (radeon_connector->edid)
+		goto got_edid;
+
 	/* on hw with routers, select right port */
 	if (radeon_connector->router.ddc_valid)
 		radeon_router_select_ddc_port(radeon_connector);
@@ -792,6 +796,7 @@ int radeon_ddc_get_modes(struct radeon_connector *radeon_connector)
 			radeon_connector->edid = radeon_bios_get_hardcoded_edid(rdev);
 	}
 	if (radeon_connector->edid) {
+got_edid:
 		drm_mode_connector_update_edid_property(&radeon_connector->base, radeon_connector->edid);
 		ret = drm_add_edid_modes(&radeon_connector->base, radeon_connector->edid);
 		drm_edid_to_eld(&radeon_connector->base, radeon_connector->edid);
-- 
1.9.1

