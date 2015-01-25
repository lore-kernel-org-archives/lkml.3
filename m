Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758774AbbAYS6K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:58:10 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57852 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755541AbbAYSJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:09:43 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.18 039/183] drm/radeon: properly filter DP1.2 4k modes on non-DP1.2 hw
Date: Sun, 25 Jan 2015 10:06:01 -0800
Message-Id: <20150125180811.872018366@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180810.160428929@linuxfoundation.org>
References: <20150125180810.160428929@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/atombios_dp.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/radeon/atombios_dp.c
+++ b/drivers/gpu/drm/radeon/atombios_dp.c
@@ -492,6 +492,10 @@ int radeon_dp_mode_valid_helper(struct d
 	struct radeon_connector_atom_dig *dig_connector;
 	int dp_clock;
 
+	if ((mode->clock > 340000) &&
+	    (!radeon_connector_is_dp12_capable(connector)))
+		return MODE_CLOCK_HIGH;
+
 	if (!radeon_connector->con_priv)
 		return MODE_CLOCK_HIGH;
 	dig_connector = radeon_connector->con_priv;


