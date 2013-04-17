Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966160Ab3DQJri (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 05:47:38 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:11762 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965887Ab3DQJrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 05:47:35 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 17 Apr 2013 02:47:23 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <broonie@kernel.org>
CC: <sameo@linux.intel.com>, <gg@slimlogic.co.uk>, <ian@slimlogic.co.uk>,
        <linux-kernel@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 1/3] regulator: palmas: clear sleep bits if not selected
Date: Wed, 17 Apr 2013 15:13:11 +0530
Message-ID: <1366191793-13934-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clear the sleep/warm reset bits when it is not selected through
regulator platform data. This will make sure that configuration
is inline with the platform data regardless of boot/POR
configuration.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/regulator/palmas-regulator.c |   18 ++++++++++++------
 1 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
index 7c54e31..7c7992b 100644
--- a/drivers/regulator/palmas-regulator.c
+++ b/drivers/regulator/palmas-regulator.c
@@ -444,24 +444,26 @@ static int palmas_smps_init(struct palmas *palmas, int id,
 
 	switch (id) {
 	case PALMAS_REG_SMPS10:
-		if (reg_init->mode_sleep) {
-			reg &= ~PALMAS_SMPS10_CTRL_MODE_SLEEP_MASK;
+		reg &= ~PALMAS_SMPS10_CTRL_MODE_SLEEP_MASK;
+		if (reg_init->mode_sleep)
 			reg |= reg_init->mode_sleep <<
 					PALMAS_SMPS10_CTRL_MODE_SLEEP_SHIFT;
-		}
 		break;
 	default:
 		if (reg_init->warm_reset)
 			reg |= PALMAS_SMPS12_CTRL_WR_S;
+		else
+			reg &= ~PALMAS_SMPS12_CTRL_WR_S;
 
 		if (reg_init->roof_floor)
 			reg |= PALMAS_SMPS12_CTRL_ROOF_FLOOR_EN;
+		else
+			reg &= ~PALMAS_SMPS12_CTRL_ROOF_FLOOR_EN;
 
-		if (reg_init->mode_sleep) {
-			reg &= ~PALMAS_SMPS12_CTRL_MODE_SLEEP_MASK;
+		reg &= ~PALMAS_SMPS12_CTRL_MODE_SLEEP_MASK;
+		if (reg_init->mode_sleep)
 			reg |= reg_init->mode_sleep <<
 					PALMAS_SMPS12_CTRL_MODE_SLEEP_SHIFT;
-		}
 	}
 
 	ret = palmas_smps_write(palmas, addr, reg);
@@ -507,9 +509,13 @@ static int palmas_ldo_init(struct palmas *palmas, int id,
 
 	if (reg_init->warm_reset)
 		reg |= PALMAS_LDO1_CTRL_WR_S;
+	else
+		reg &= ~PALMAS_LDO1_CTRL_WR_S;
 
 	if (reg_init->mode_sleep)
 		reg |= PALMAS_LDO1_CTRL_MODE_SLEEP;
+	else
+		reg &= ~PALMAS_LDO1_CTRL_MODE_SLEEP;
 
 	ret = palmas_ldo_write(palmas, addr, reg);
 	if (ret)
-- 
1.7.1.1

