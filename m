Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758298AbbA0MRS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:17:18 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34869 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758241AbbA0MRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:17:11 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 016/126] drm/radeon: properly filter DP1.2 4k modes on non-DP1.2 hw
Date: Tue, 27 Jan 2015 12:15:21 +0000
Message-Id: <1422361031-19364-17-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
References: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 410cce2a6b82299b46ff316c6384e789ce275ecb upstream.

The check was already in place in the dp mode_valid check, but
radeon_dp_get_dp_link_clock() never returned the high clock
mode_valid was checking for because that function clipped the
clock based on the hw capabilities.  Add an explicit check
in the mode_valid function.

bug:
https://bugs.freedesktop.org/show_bug.cgi?id=87172

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/atombios_dp.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/radeon/atombios_dp.c b/drivers/gpu/drm/radeon/atombios_dp.c
index 67fb65428b1e..d011729f20b0 100644
--- a/drivers/gpu/drm/radeon/atombios_dp.c
+++ b/drivers/gpu/drm/radeon/atombios_dp.c
@@ -495,6 +495,10 @@ int radeon_dp_mode_valid_helper(struct drm_connector *connector,
 	struct radeon_connector_atom_dig *dig_connector;
 	int dp_clock;
 
+	if ((mode->clock > 340000) &&
+	    (!radeon_connector_is_dp12_capable(connector)))
+		return MODE_CLOCK_HIGH;
+
 	if (!radeon_connector->con_priv)
 		return MODE_CLOCK_HIGH;
 	dig_connector = radeon_connector->con_priv;
-- 
2.1.4

