Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526AbaHKLTg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 07:19:36 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:4513 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402AbaHKLTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 07:19:34 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 11 Aug 2014 04:06:25 -0700
From: Mikko Perttunen <mperttunen@nvidia.com>
To: <tj@kernel.org>, <swarren@wwwdotorg.org>, <thierry.reding@gmail.com>
CC: <linux-ide@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Mikko Perttunen <mperttunen@nvidia.com>
Subject: [PATCH] ata: ahci_tegra: Read calibration fuse
Date: Mon, 11 Aug 2014 14:19:13 +0300
Message-ID: <1407755953-11785-1-git-send-email-mperttunen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The original version of the driver did not read the SATA calibration
fuse to remove the dependency to the fuse driver. The fuse driver
is now merged, so add this functionality.

The calibration fuse contains a 2-bit value used to pick a set
of calibration values for the SATA pad.

Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
---
 drivers/ata/ahci_tegra.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/ata/ahci_tegra.c b/drivers/ata/ahci_tegra.c
index f1fef74..ad99e0f5 100644
--- a/drivers/ata/ahci_tegra.c
+++ b/drivers/ata/ahci_tegra.c
@@ -26,6 +26,7 @@
 #include <linux/platform_device.h>
 #include <linux/regulator/consumer.h>
 #include <soc/tegra/pmc.h>
+#include <soc/tegra/fuse.h>
 #include "ahci.h"
 
 #define SATA_CONFIGURATION_0				0x180
@@ -180,9 +181,12 @@ static int tegra_ahci_controller_init(struct ahci_host_priv *hpriv)
 
 	/* Pad calibration */
 
-	/* FIXME Always use calibration 0. Change this to read the calibration
-	 * fuse once the fuse driver has landed. */
-	val = 0;
+	ret = tegra_fuse_readl(FUSE_SATA_CALIB, &val);
+	if (ret) {
+		dev_err(&tegra->pdev->dev,
+			"failed to read calibration fuse: %d\n", ret);
+		return ret;
+	}
 
 	calib = tegra124_pad_calibration[val & FUSE_SATA_CALIB_MASK];
 
-- 
1.8.1.5

