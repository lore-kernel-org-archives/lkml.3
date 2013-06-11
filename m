Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756927Ab3FKUGt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 16:06:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42060 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756837Ab3FKUET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 16:04:19 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 67/79] radeon: use max_bus_speed to activate gen2 speeds
Date: Tue, 11 Jun 2013 13:03:33 -0700
Message-Id: <20130611195324.856071642@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.254.g5578ad7
In-Reply-To: <20130611195312.352656079@linuxfoundation.org>
References: <20130611195312.352656079@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>

commit 7e0e41963740525af702bb23edede8ae9afc4ac0 upstream.

radeon currently uses a drm function to get the speed capabilities for
the bus, drm_pcie_get_speed_cap_mask. However, this is a non-standard
method of performing this detection and this patch changes it to use
the max_bus_speed attribute.

From: Lucas Kannebley Tavares <lucaskt@linux.vnet.ibm.com>
Signed-off-by: Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/evergreen.c |   10 +++-------
 drivers/gpu/drm/radeon/r600.c      |    9 ++-------
 drivers/gpu/drm/radeon/rv770.c     |    9 ++-------
 3 files changed, 7 insertions(+), 21 deletions(-)

--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -3946,8 +3946,7 @@ void evergreen_fini(struct radeon_device
 
 void evergreen_pcie_gen2_enable(struct radeon_device *rdev)
 {
-	u32 link_width_cntl, speed_cntl, mask;
-	int ret;
+	u32 link_width_cntl, speed_cntl;
 
 	if (radeon_pcie_gen2 == 0)
 		return;
@@ -3962,11 +3961,8 @@ void evergreen_pcie_gen2_enable(struct r
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
 
 	speed_cntl = RREG32_PCIE_P(PCIE_LC_SPEED_CNTL);
--- a/drivers/gpu/drm/radeon/r600.c
+++ b/drivers/gpu/drm/radeon/r600.c
@@ -4353,8 +4353,6 @@ static void r600_pcie_gen2_enable(struct
 {
 	u32 link_width_cntl, lanes, speed_cntl, training_cntl, tmp;
 	u16 link_cntl2;
-	u32 mask;
-	int ret;
 
 	if (radeon_pcie_gen2 == 0)
 		return;
@@ -4373,11 +4371,8 @@ static void r600_pcie_gen2_enable(struct
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
 
 	speed_cntl = RREG32_PCIE_P(PCIE_LC_SPEED_CNTL);
--- a/drivers/gpu/drm/radeon/rv770.c
+++ b/drivers/gpu/drm/radeon/rv770.c
@@ -1240,8 +1240,6 @@ static void rv770_pcie_gen2_enable(struc
 {
 	u32 link_width_cntl, lanes, speed_cntl, tmp;
 	u16 link_cntl2;
-	u32 mask;
-	int ret;
 
 	if (radeon_pcie_gen2 == 0)
 		return;
@@ -1256,11 +1254,8 @@ static void rv770_pcie_gen2_enable(struc
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


