Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755023AbaG3M3W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 08:29:22 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:36751 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752938AbaG3MPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 08:15:33 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 65/94] drm/radeon: avoid leaking edid data
Date: Wed, 30 Jul 2014 14:14:54 +0200
Message-Id: <9fc6b11117125440fe9cd9d590804f530c951f64.1406722270.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
References: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
In-Reply-To: <cover.1406722269.git.jslaby@suse.cz>
References: <cover.1406722269.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 0ac66effe7fcdee55bda6d5d10d3372c95a41920 upstream.

In some cases we fetch the edid in the detect() callback
in order to determine what sort of monitor is connected.
If that happens, don't fetch the edid again in the get_modes()
callback or we will leak the edid.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/radeon/radeon_display.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/radeon/radeon_display.c b/drivers/gpu/drm/radeon/radeon_display.c
index 0254a7596a55..9a19a0432f0f 100644
--- a/drivers/gpu/drm/radeon/radeon_display.c
+++ b/drivers/gpu/drm/radeon/radeon_display.c
@@ -708,6 +708,10 @@ int radeon_ddc_get_modes(struct radeon_connector *radeon_connector)
 	struct radeon_device *rdev = dev->dev_private;
 	int ret = 0;
 
+	/* don't leak the edid if we already fetched it in detect() */
+	if (radeon_connector->edid)
+		goto got_edid;
+
 	/* on hw with routers, select right port */
 	if (radeon_connector->router.ddc_valid)
 		radeon_router_select_ddc_port(radeon_connector);
@@ -747,6 +751,7 @@ int radeon_ddc_get_modes(struct radeon_connector *radeon_connector)
 			radeon_connector->edid = radeon_bios_get_hardcoded_edid(rdev);
 	}
 	if (radeon_connector->edid) {
+got_edid:
 		drm_mode_connector_update_edid_property(&radeon_connector->base, radeon_connector->edid);
 		ret = drm_add_edid_modes(&radeon_connector->base, radeon_connector->edid);
 		drm_edid_to_eld(&radeon_connector->base, radeon_connector->edid);
-- 
2.0.1

