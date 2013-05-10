Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213Ab3EJOWI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:22:08 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57290 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756016Ab3EJOWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:22:03 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Alex Deucher" <alexander.deucher@amd.com>
Date: Fri, 10 May 2013 14:39:41 +0100
Message-ID: <lsq.1368193181.464434923@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [030/118] drm/radeon/evergreen+: don't enable HPD interrupts on
 eDP/LVDS
In-Reply-To: <lsq.1368193179.973009354@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d51a:8785:aa0a:cebe
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.45-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 2e97be73e5f74a317232740ae82eb8f95326a660 upstream.

Avoids potential interrupt storms when the display is disabled.

May fix:
https://bugzilla.kernel.org/show_bug.cgi?id=56041

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/radeon/evergreen.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -412,6 +412,16 @@ void evergreen_hpd_init(struct radeon_de
 
 	list_for_each_entry(connector, &dev->mode_config.connector_list, head) {
 		struct radeon_connector *radeon_connector = to_radeon_connector(connector);
+
+		if (connector->connector_type == DRM_MODE_CONNECTOR_eDP ||
+		    connector->connector_type == DRM_MODE_CONNECTOR_LVDS) {
+			/* don't try to enable hpd on eDP or LVDS avoid breaking the
+			 * aux dp channel on imac and help (but not completely fix)
+			 * https://bugzilla.redhat.com/show_bug.cgi?id=726143
+			 * also avoid interrupt storms during dpms.
+			 */
+			continue;
+		}
 		switch (radeon_connector->hpd.hpd) {
 		case RADEON_HPD_1:
 			WREG32(DC_HPD1_CONTROL, tmp);

