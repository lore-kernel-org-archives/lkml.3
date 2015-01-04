Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830AbbADTK3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 14:10:29 -0500
Received: from khitomer.mortis.eu ([185.27.175.75]:11413 "EHLO
	khitomer.mortis.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741AbbADTK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 14:10:27 -0500
X-Greylist: delayed 4018 seconds by postgrey-1.27 at vger.kernel.org; Sun, 04 Jan 2015 14:10:26 EST
From: Giel van Schijndel <me@mortis.eu>
To: linux-kernel@vger.kernel.org
Cc: Giel van Schijndel <me@mortis.eu>, Brian King <brking@us.ibm.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org (open list:SCSI SUBSYSTEM)
Subject: [PATCH] Cleanup: snprintf() always NUL-terminates: depend on it
Date: Sun,  4 Jan 2015 19:05:58 +0100
Message-Id: <1420394759-20345-1-git-send-email-me@mortis.eu>
X-Mailer: git-send-email 2.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Especially since one very strange piece of code seems to be written in
such a way that a NUL needs to be placed where a NUL is present already.
The author probably meant to fill the last byte of the buffer with a NUL
instead. But regardless of that: that isn't necessary since snprintf()
already guarantees NUL termination for buffers sizes > 0 and <= INT_MAX.
---
 drivers/scsi/ipr.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index df4e27c..b49fe45 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -3990,7 +3990,6 @@ static ssize_t ipr_store_update_fw(struct device *dev,
 		return -EACCES;
 
 	len = snprintf(fname, 99, "%s", buf);
-	fname[len-1] = '\0';
 
 	if (request_firmware(&fw_entry, fname, &ioa_cfg->pdev->dev)) {
 		dev_err(&ioa_cfg->pdev->dev, "Firmware file %s not found\n", fname);
@@ -9358,13 +9357,12 @@ static int ipr_enable_msi(struct ipr_ioa_cfg *ioa_cfg)
 
 static void name_msi_vectors(struct ipr_ioa_cfg *ioa_cfg)
 {
-	int vec_idx, n = sizeof(ioa_cfg->vectors_info[0].desc) - 1;
+	int vec_idx;
 
 	for (vec_idx = 0; vec_idx < ioa_cfg->nvectors; vec_idx++) {
-		snprintf(ioa_cfg->vectors_info[vec_idx].desc, n,
+		snprintf(ioa_cfg->vectors_info[vec_idx].desc,
+			 sizeof(ioa_cfg->vectors_info[vec_idx].desc),
 			 "host%d-%d", ioa_cfg->host->host_no, vec_idx);
-		ioa_cfg->vectors_info[vec_idx].
-			desc[strlen(ioa_cfg->vectors_info[vec_idx].desc)] = 0;
 	}
 }
 
-- 
2.1.4

