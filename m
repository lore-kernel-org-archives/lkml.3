Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756562AbaGZUFh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 16:05:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33783 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704AbaGZTDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 15:03:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.10 49/56] drm/radeon: avoid leaking edid data
Date: Sat, 26 Jul 2014 12:02:42 -0700
Message-Id: <20140726190201.678813625@linuxfoundation.org>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <20140726190200.061512159@linuxfoundation.org>
References: <20140726190200.061512159@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 0ac66effe7fcdee55bda6d5d10d3372c95a41920 upstream.

In some cases we fetch the edid in the detect() callback
in order to determine what sort of monitor is connected.
If that happens, don't fetch the edid again in the get_modes()
callback or we will leak the edid.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_display.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/gpu/drm/radeon/radeon_display.c
+++ b/drivers/gpu/drm/radeon/radeon_display.c
@@ -688,6 +688,10 @@ int radeon_ddc_get_modes(struct radeon_c
 	struct radeon_device *rdev = dev->dev_private;
 	int ret = 0;
 
+	/* don't leak the edid if we already fetched it in detect() */
+	if (radeon_connector->edid)
+		goto got_edid;
+
 	/* on hw with routers, select right port */
 	if (radeon_connector->router.ddc_valid)
 		radeon_router_select_ddc_port(radeon_connector);
@@ -727,6 +731,7 @@ int radeon_ddc_get_modes(struct radeon_c
 			radeon_connector->edid = radeon_bios_get_hardcoded_edid(rdev);
 	}
 	if (radeon_connector->edid) {
+got_edid:
 		drm_mode_connector_update_edid_property(&radeon_connector->base, radeon_connector->edid);
 		ret = drm_add_edid_modes(&radeon_connector->base, radeon_connector->edid);
 		drm_edid_to_eld(&radeon_connector->base, radeon_connector->edid);


