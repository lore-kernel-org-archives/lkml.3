Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758822Ab3EIWlQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 18:41:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46371 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758436Ab3EIWe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 18:34:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 19/26] drm/radeon/evergreen+: dont enable HPD interrupts on eDP/LVDS
Date: Thu,  9 May 2013 15:34:33 -0700
Message-Id: <20130509223424.448977523@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130509223422.368544659@linuxfoundation.org>
References: <20130509223422.368544659@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 2e97be73e5f74a317232740ae82eb8f95326a660 upstream.

Avoids potential interrupt storms when the display is disabled.

May fix:
https://bugzilla.kernel.org/show_bug.cgi?id=56041

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/evergreen.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -445,6 +445,16 @@ void evergreen_hpd_init(struct radeon_de
 
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


