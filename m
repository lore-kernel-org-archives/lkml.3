Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291AbaHDQyB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 12:54:01 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56654 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751125AbaHDQt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:49:57 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Alex Deucher" <alexander.deucher@amd.com>
Date: Mon, 04 Aug 2014 17:48:32 +0100
Message-ID: <lsq.1407170912.573542137@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 53/94] drm/radeon: avoid leaking edid data
In-Reply-To: <lsq.1407170911.107020799@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.62-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 0ac66effe7fcdee55bda6d5d10d3372c95a41920 upstream.

In some cases we fetch the edid in the detect() callback
in order to determine what sort of monitor is connected.
If that happens, don't fetch the edid again in the get_modes()
callback or we will leak the edid.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/radeon/radeon_display.c | 5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/gpu/drm/radeon/radeon_display.c
+++ b/drivers/gpu/drm/radeon/radeon_display.c
@@ -697,6 +697,10 @@ int radeon_ddc_get_modes(struct radeon_c
 	struct radeon_device *rdev = dev->dev_private;
 	int ret = 0;
 
+	/* don't leak the edid if we already fetched it in detect() */
+	if (radeon_connector->edid)
+		goto got_edid;
+
 	/* on hw with routers, select right port */
 	if (radeon_connector->router.ddc_valid)
 		radeon_router_select_ddc_port(radeon_connector);
@@ -736,6 +740,7 @@ int radeon_ddc_get_modes(struct radeon_c
 			radeon_connector->edid = radeon_bios_get_hardcoded_edid(rdev);
 	}
 	if (radeon_connector->edid) {
+got_edid:
 		drm_mode_connector_update_edid_property(&radeon_connector->base, radeon_connector->edid);
 		ret = drm_add_edid_modes(&radeon_connector->base, radeon_connector->edid);
 		drm_edid_to_eld(&radeon_connector->base, radeon_connector->edid);

