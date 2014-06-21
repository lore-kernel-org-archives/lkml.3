Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758013AbaFUAj5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 20:39:57 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:38099 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757196AbaFUAjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 20:39:52 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: hariprasad@chelsio.com, leedom@chelsio.com
Cc: poswald@suse.com, santosh@chelsio.com, jcheung@suse.com, dchang@suse.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, mcgrof@suse.com
Subject: [RFT 1/3] cxgb4: make ethtool set_flash use request_firmware_nowait()
Date: Fri, 20 Jun 2014 17:39:39 -0700
Message-Id: <1403311181-9328-2-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403311181-9328-1-git-send-email-mcgrof@do-not-panic.com>
References: <1403311181-9328-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@suse.com>

cxgb4 loading can take a while, this is part of the crusade to
change it to be asynchronous.

Cc: Casey Leedom <leedom@chelsio.com>
Cc: Hariprasad Shenai <hariprasad@chelsio.com>
Cc: Philip Oswald <poswald@suse.com>
Cc: Santosh Rastapur <santosh@chelsio.com>
Cc: Jeffrey Cheung <jcheung@suse.com>
Cc: David Chang <dchang@suse.com>
Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h      |  3 ++
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c | 40 ++++++++++++++++++++-----
 2 files changed, 36 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
index f503dce..bcf9acf 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
@@ -647,6 +647,9 @@ struct adapter {
 	struct dentry *debugfs_root;
 
 	spinlock_t stats_lock;
+
+	struct completion flash_comp;
+	int flash_comp_status;
 };
 
 /* Defined bit width of user definable filter tuples
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index 2f8d6b9..9cf6f3e 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -2713,22 +2713,48 @@ out:
 	return err;
 }
 
+static void cxgb4_flash_complete(const struct firmware *fw, void *context)
+{
+	struct adapter *adap = context;
+	int ret;
+
+	if (!fw) {
+		adap->flash_comp_status = -EINVAL;
+		goto out;
+	}
+
+	ret = t4_load_fw(adap, fw->data, fw->size);
+	if (!ret)
+		adap->flash_comp_status = ret;
+
+out:
+	release_firmware(fw);
+	complete(&adap->flash_comp);
+}
+
 static int set_flash(struct net_device *netdev, struct ethtool_flash *ef)
 {
 	int ret;
-	const struct firmware *fw;
 	struct adapter *adap = netdev2adap(netdev);
 
+	init_completion(&adap->flash_comp);
+	adap->flash_comp_status = 0;
+
 	ef->data[sizeof(ef->data) - 1] = '\0';
-	ret = request_firmware(&fw, ef->data, adap->pdev_dev);
+	ret = request_firmware_nowait(THIS_MODULE, 1, ef->data,
+				      adap->pdev_dev, GFP_KERNEL,
+				      adap, cxgb4_flash_complete);
 	if (ret < 0)
 		return ret;
 
-	ret = t4_load_fw(adap, fw->data, fw->size);
-	release_firmware(fw);
-	if (!ret)
-		dev_info(adap->pdev_dev, "loaded firmware %s\n", ef->data);
-	return ret;
+	wait_for_completion(&adap->flash_comp);
+
+	if (adap->flash_comp_status != 0)
+		return adap->flash_comp_status;
+
+	dev_info(adap->pdev_dev, "loaded firmware %s\n", ef->data);
+
+	return 0;
 }
 
 #define WOL_SUPPORTED (WAKE_BCAST | WAKE_MAGIC)
-- 
2.0.0

