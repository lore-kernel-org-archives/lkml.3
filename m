Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933414AbaJDAIc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 20:08:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45712 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756692AbaJCVxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:53:18 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.14 013/238] drm/radeon/dpm: handle voltage info fetching on hawaii
Date: Fri,  3 Oct 2014 14:28:48 -0700
Message-Id: <20141003212914.089254020@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212913.680985295@linuxfoundation.org>
References: <20141003212913.680985295@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 6b57f20cb5b708415fbab63847f8f8429b051af8 upstream.

Some hawaii cards use a different method to fetch the
voltage info from the vbios.

bug:
https://bugs.freedesktop.org/show_bug.cgi?id=74250

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/ci_dpm.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/ci_dpm.c
+++ b/drivers/gpu/drm/radeon/ci_dpm.c
@@ -922,7 +922,18 @@ static void ci_get_leakage_voltages(stru
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


