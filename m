Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934237AbaHZJAo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 05:00:44 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:3244 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932421AbaHZJAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 05:00:42 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 26 Aug 2014 01:50:41 -0700
From: Mikko Perttunen <mperttunen@nvidia.com>
To: <tj@kernel.org>, <swarren@wwwdotorg.org>, <thierry.reding@gmail.com>
CC: <linux-ide@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Mikko Perttunen <mperttunen@nvidia.com>
Subject: [PATCH v2] ata: ahci_tegra: Read calibration fuse
Date: Tue, 26 Aug 2014 12:00:30 +0300
Message-ID: <1409043630-9674-1-git-send-email-mperttunen@nvidia.com>
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
v2: reordered and separated includes

 drivers/ata/ahci_tegra.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/ata/ahci_tegra.c b/drivers/ata/ahci_tegra.c
index f1fef74..0329044 100644
--- a/drivers/ata/ahci_tegra.c
+++ b/drivers/ata/ahci_tegra.c
@@ -18,14 +18,17 @@
  */
 
 #include <linux/ahci_platform.h>
-#include <linux/reset.h>
 #include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/of_device.h>
 #include <linux/platform_device.h>
 #include <linux/regulator/consumer.h>
+#include <linux/reset.h>
+
+#include <soc/tegra/fuse.h>
 #include <soc/tegra/pmc.h>
+
 #include "ahci.h"
 
 #define SATA_CONFIGURATION_0				0x180
@@ -180,9 +183,12 @@ static int tegra_ahci_controller_init(struct ahci_host_priv *hpriv)
 
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

