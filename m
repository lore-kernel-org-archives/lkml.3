Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896AbaDAUgM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 16:36:12 -0400
Received: from mail.kmu-office.ch ([178.209.48.102]:43772 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607AbaDAUgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 16:36:06 -0400
From: stefan@agner.ch
To: chris@printf.net, linux-mmc@vger.kernel.org
Cc: linux-tegra@vger.kernel.org, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, stefan@agner.ch
Subject: [RFC 1/2] mmc: read mmc alias from device tree
Date: Tue,  1 Apr 2014 22:35:51 +0200
Message-Id: <5570bdf5ebb3aaae5a376634ecfbac9c2fd7b9f4.1396384101.git.stefan@agner.ch>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1396384101.git.stefan@agner.ch>
References: <cover.1396384101.git.stefan@agner.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Agner <stefan@agner.ch>

To get the SD/MMC host device ID, read the alias from the device
tree.

This is useful in case a SoC has multipe SD/MMC host controllers while
the second controller should logically be the first device (e.g. if
the second controller is connected to an internal eMMC). Combined
with block device numbering using MMC/SD host device ID, this
results in predictable name assignment of the internal eMMC block
device.

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
 drivers/mmc/core/host.c | 24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/mmc/core/host.c b/drivers/mmc/core/host.c
index 49bc403..29f44cf 100644
--- a/drivers/mmc/core/host.c
+++ b/drivers/mmc/core/host.c
@@ -448,8 +448,8 @@ EXPORT_SYMBOL(mmc_of_parse);
  */
 struct mmc_host *mmc_alloc_host(int extra, struct device *dev)
 {
-	int err;
 	struct mmc_host *host;
+	int of_id = -1, id = -1;
 
 	host = kzalloc(sizeof(struct mmc_host) + extra, GFP_KERNEL);
 	if (!host)
@@ -459,12 +459,26 @@ struct mmc_host *mmc_alloc_host(int extra, struct device *dev)
 	host->rescan_disable = 1;
 	idr_preload(GFP_KERNEL);
 	spin_lock(&mmc_host_lock);
-	err = idr_alloc(&mmc_host_idr, host, 0, 0, GFP_NOWAIT);
-	if (err >= 0)
-		host->index = err;
+
+	if (dev->of_node)
+		of_id = of_alias_get_id(dev->of_node, "mmc");
+
+	if (of_id >= 0) {
+		id = idr_alloc(&mmc_host_idr, host, of_id, of_id + 1,
+				GFP_NOWAIT);
+		if (id < 0)
+			dev_warn(dev, "/aliases ID %d not available\n", of_id);
+	}
+
+	if (id < 0)
+		id = idr_alloc(&mmc_host_idr, host, 0, 0, GFP_NOWAIT);
+
+	if (id >= 0)
+		host->index = id;
+
 	spin_unlock(&mmc_host_lock);
 	idr_preload_end();
-	if (err < 0)
+	if (id < 0)
 		goto free;
 
 	dev_set_name(&host->class_dev, "mmc%d", host->index);
-- 
1.9.1

