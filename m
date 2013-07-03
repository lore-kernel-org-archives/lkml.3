Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933237Ab3GCTLi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 15:11:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28849 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964935Ab3GCTAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 15:00:24 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=2yw6yl73iq8A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=jXBEW2bLh-sA:10 a=VnNF1IyMAAAA:8 a=zd2uoN0lAAAA:8 a=e0gVtgZ23HrhdBXb4dMA:9 a=wu_e27o_rKQA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184104.304391047@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:40:43 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [106/141] radeon: use max_bus_speed to activate gen2 speeds
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0106-radeon-use-max_bus_speed-to-activate-gen2-speeds.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>

[ Upstream commit 7e0e41963740525af702bb23edede8ae9afc4ac0 ]

radeon currently uses a drm function to get the speed capabilities for
the bus, drm_pcie_get_speed_cap_mask. However, this is a non-standard
method of performing this detection and this patch changes it to use
the max_bus_speed attribute.

From: Lucas Kannebley Tavares <lucaskt@linux.vnet.ibm.com>
Signed-off-by: Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/gpu/drm/radeon/evergreen.c |   10 +++-------
 drivers/gpu/drm/radeon/r600.c      |    9 ++-------
 drivers/gpu/drm/radeon/rv770.c     |    9 ++-------
 3 files changed, 7 insertions(+), 21 deletions(-)

diff --git a/drivers/gpu/drm/radeon/evergreen.c b/drivers/gpu/drm/radeon/evergreen.c
index c3173e4..f3e0e8e 100644
--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -3425,8 +3425,7 @@ void evergreen_fini(struct radeon_device *rdev)
 
 void evergreen_pcie_gen2_enable(struct radeon_device *rdev)
 {
-	u32 link_width_cntl, speed_cntl, mask;
-	int ret;
+	u32 link_width_cntl, speed_cntl;
 
 	if (radeon_pcie_gen2 == 0)
 		return;
@@ -3441,11 +3440,8 @@ void evergreen_pcie_gen2_enable(struct radeon_device *rdev)
 	if (ASIC_IS_X2(rdev))
 		return;
 
-	ret = drm_pcie_get_speed_cap_mask(rdev->ddev, &mask);
-	if (ret != 0)
-		return;
-
-	if (!(mask & DRM_PCIE_SPEED_50))
+	if ((rdev->pdev->bus->max_bus_speed != PCIE_SPEED_5_0GT) &&
+		(rdev->pdev->bus->max_bus_speed != PCIE_SPEED_8_0GT))
 		return;
 
 	DRM_INFO("enabling PCIE gen 2 link speeds, disable with radeon.pcie_gen2=0\n");
diff --git a/drivers/gpu/drm/radeon/r600.c b/drivers/gpu/drm/radeon/r600.c
index 2fa2642..4c6b4156 100644
--- a/drivers/gpu/drm/radeon/r600.c
+++ b/drivers/gpu/drm/radeon/r600.c
@@ -3683,8 +3683,6 @@ static void r600_pcie_gen2_enable(struct radeon_device *rdev)
 {
 	u32 link_width_cntl, lanes, speed_cntl, training_cntl, tmp;
 	u16 link_cntl2;
-	u32 mask;
-	int ret;
 
 	if (radeon_pcie_gen2 == 0)
 		return;
@@ -3703,11 +3701,8 @@ static void r600_pcie_gen2_enable(struct radeon_device *rdev)
 	if (rdev->family <= CHIP_R600)
 		return;
 
-	ret = drm_pcie_get_speed_cap_mask(rdev->ddev, &mask);
-	if (ret != 0)
-		return;
-
-	if (!(mask & DRM_PCIE_SPEED_50))
+	if ((rdev->pdev->bus->max_bus_speed != PCIE_SPEED_5_0GT) &&
+		(rdev->pdev->bus->max_bus_speed != PCIE_SPEED_8_0GT))
 		return;
 
 	DRM_INFO("enabling PCIE gen 2 link speeds, disable with radeon.pcie_gen2=0\n");
diff --git a/drivers/gpu/drm/radeon/rv770.c b/drivers/gpu/drm/radeon/rv770.c
index fcd30f7..a4c4dc6 100644
--- a/drivers/gpu/drm/radeon/rv770.c
+++ b/drivers/gpu/drm/radeon/rv770.c
@@ -1114,8 +1114,6 @@ static void rv770_pcie_gen2_enable(struct radeon_device *rdev)
 {
 	u32 link_width_cntl, lanes, speed_cntl, tmp;
 	u16 link_cntl2;
-	u32 mask;
-	int ret;
 
 	if (radeon_pcie_gen2 == 0)
 		return;
@@ -1130,11 +1128,8 @@ static void rv770_pcie_gen2_enable(struct radeon_device *rdev)
 	if (ASIC_IS_X2(rdev))
 		return;
 
-	ret = drm_pcie_get_speed_cap_mask(rdev->ddev, &mask);
-	if (ret != 0)
-		return;
-
-	if (!(mask & DRM_PCIE_SPEED_50))
+	if ((rdev->pdev->bus->max_bus_speed != PCIE_SPEED_5_0GT) &&
+		(rdev->pdev->bus->max_bus_speed != PCIE_SPEED_8_0GT))
 		return;
 
 	DRM_INFO("enabling PCIE gen 2 link speeds, disable with radeon.pcie_gen2=0\n");
-- 
1.7.10.4


