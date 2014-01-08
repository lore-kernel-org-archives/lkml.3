Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077AbaAHJsN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 04:48:13 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:60042 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755943AbaAHJre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 04:47:34 -0500
From: Roger Quadros <rogerq@ti.com>
To: <tj@kernel.org>
CC: <sergei.shtylyov@cogentembedded.com>, <kishon@ti.com>,
        <b.zolnierkie@samsung.com>, <hdegoede@redhat.com>,
        <linux-ide@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Roger Quadros <rogerq@ti.com>,
        Balaji T K <balajitk@ti.com>
Subject: [PATCH v3 3/3] ata: ahci_platform: runtime resume the device before use
Date: Wed, 8 Jan 2014 15:17:08 +0530
Message-ID: <1389174428-31414-4-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389174428-31414-1-git-send-email-rogerq@ti.com>
References: <1389174428-31414-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On OMAP platforms the device needs to be runtime resumed before
it can be accessed. The OMAP HWMOD framework takes care of
enabling the module and its resources based on the
device's runtime PM state.

In this patch we runtime resume during .probe() and runtime suspend
during .remove() (i.e. ahci_host_stop()).

We also update the runtime PM state during .resume().

Signed-off-by: Roger Quadros <rogerq@ti.com>
Signed-off-by: Balaji T K <balajitk@ti.com>
---
 drivers/ata/ahci_platform.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/ata/ahci_platform.c b/drivers/ata/ahci_platform.c
index f61093b..04c4ac2 100644
--- a/drivers/ata/ahci_platform.c
+++ b/drivers/ata/ahci_platform.c
@@ -23,6 +23,7 @@
 #include <linux/platform_device.h>
 #include <linux/libata.h>
 #include <linux/ahci_platform.h>
+#include <linux/pm_runtime.h>
 #include "ahci.h"
 
 static void ahci_host_stop(struct ata_host *host);
@@ -142,6 +143,9 @@ static int ahci_probe(struct platform_device *pdev)
 		}
 	}
 
+	pm_runtime_enable(dev);
+	pm_runtime_get_sync(dev);
+
 	hpriv->phy = devm_phy_get(dev, "sata-phy");
 	if (IS_ERR(hpriv->phy)) {
 		dev_dbg(dev, "can't get sata-phy\n");
@@ -269,6 +273,9 @@ static void ahci_host_stop(struct ata_host *host)
 		clk_disable_unprepare(hpriv->clk);
 		clk_put(hpriv->clk);
 	}
+
+	pm_runtime_put_sync(dev);
+	pm_runtime_disable(dev);
 }
 
 #ifdef CONFIG_PM_SLEEP
@@ -340,6 +347,11 @@ static int ahci_resume(struct device *dev)
 
 	ata_host_resume(host);
 
+	/* We resumed so update PM runtime state */
+	pm_runtime_disable(dev);
+	pm_runtime_set_active(dev);
+	pm_runtime_enable(dev);
+
 	return 0;
 
 disable_unprepare_clk:
-- 
1.8.3.2

