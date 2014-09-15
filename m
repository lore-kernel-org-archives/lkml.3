Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757670AbaIOWPz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:15:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50894 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932807AbaIOWPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:15:53 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 155/187] drm/radeon/dpm: handle voltage info fetching on hawaii
Date: Mon, 15 Sep 2014 15:09:25 -0700
Message-Id: <1410818997-9432-156-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 6b57f20cb5b708415fbab63847f8f8429b051af8 upstream.

Some hawaii cards use a different method to fetch the
voltage info from the vbios.

bug:
https://bugs.freedesktop.org/show_bug.cgi?id=74250

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/ci_dpm.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/ci_dpm.c b/drivers/gpu/drm/radeon/ci_dpm.c
index ca13ab5..8bfab60 100644
--- a/drivers/gpu/drm/radeon/ci_dpm.c
+++ b/drivers/gpu/drm/radeon/ci_dpm.c
@@ -923,7 +923,18 @@ static void ci_get_leakage_voltages(struct radeon_device *rdev)
 	pi->vddc_leakage.count = 0;
 	pi->vddci_leakage.count = 0;
 
-	if (radeon_atom_get_leakage_id_from_vbios(rdev, &leakage_id) == 0) {
+	if (rdev->pm.dpm.platform_caps & ATOM_PP_PLATFORM_CAP_EVV) {
+		for (i = 0; i < CISLANDS_MAX_LEAKAGE_COUNT; i++) {
+			virtual_voltage_id = ATOM_VIRTUAL_VOLTAGE_ID0 + i;
+			if (radeon_atom_get_voltage_evv(rdev, virtual_voltage_id, &vddc) != 0)
+				continue;
+			if (vddc != 0 && vddc != virtual_voltage_id) {
+				pi->vddc_leakage.actual_voltage[pi->vddc_leakage.count] = vddc;
+				pi->vddc_leakage.leakage_id[pi->vddc_leakage.count] = virtual_voltage_id;
+				pi->vddc_leakage.count++;
+			}
+		}
+	} else if (radeon_atom_get_leakage_id_from_vbios(rdev, &leakage_id) == 0) {
 		for (i = 0; i < CISLANDS_MAX_LEAKAGE_COUNT; i++) {
 			virtual_voltage_id = ATOM_VIRTUAL_VOLTAGE_ID0 + i;
 			if (radeon_atom_get_leakage_vddc_based_on_leakage_params(rdev, &vddc, &vddci,
-- 
1.9.1

