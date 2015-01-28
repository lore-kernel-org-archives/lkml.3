Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932110AbbA2JD6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:03:58 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44804 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932089AbbA2JDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:03:47 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 076/176] drm/radeon: properly filter DP1.2 4k modes on non-DP1.2 hw
Date: Wed, 28 Jan 2015 15:28:26 +0100
Message-Id: <a866f33e6f27555c3dd799bd9fb5800c2c586883.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 410cce2a6b82299b46ff316c6384e789ce275ecb upstream.

The check was already in place in the dp mode_valid check, but
radeon_dp_get_dp_link_clock() never returned the high clock
mode_valid was checking for because that function clipped the
clock based on the hw capabilities.  Add an explicit check
in the mode_valid function.

bug:
https://bugs.freedesktop.org/show_bug.cgi?id=87172

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/radeon/atombios_dp.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/radeon/atombios_dp.c b/drivers/gpu/drm/radeon/atombios_dp.c
index 4601969be373..26059ec8bafc 100644
--- a/drivers/gpu/drm/radeon/atombios_dp.c
+++ b/drivers/gpu/drm/radeon/atombios_dp.c
@@ -574,6 +574,10 @@ int radeon_dp_mode_valid_helper(struct drm_connector *connector,
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
2.2.2

