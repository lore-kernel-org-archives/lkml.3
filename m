Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753072Ab3KYKMh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 05:12:37 -0500
Received: from cloud1-vm137.de-nserver.de ([178.250.10.41]:50801 "EHLO
	cloud1-vm137.de-nserver.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752904Ab3KYKMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 05:12:34 -0500
From: Stefan Priebe <s.priebe@profihost.ag>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, rwheeler@redhat.com,
        JBottomley@Parallels.com, Stefan Priebe <s.priebe@profihost.ag>
Subject: [PATCH] Commit 39c60a0948cc '[SCSI] sd: fix array cache flushing bug causing performance problems' added a possibility to temporary disable the write cache and skip flushing. But when setting temporary it forgots to revalidate the disk. Change sd_store_cache_type to goto out in case of cache_override.
Date: Mon, 25 Nov 2013 11:03:15 +0100
Message-Id: <1385373795-3293-1-git-send-email-s.priebe@profihost.ag>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Stefan Priebe <s.priebe@profihost.ag>
---
 drivers/scsi/sd.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 734a29a..ccc6242 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -174,7 +174,7 @@ sd_store_cache_type(struct device *dev, struct device_attribute *attr,
 	if (sdkp->cache_override) {
 		sdkp->WCE = wce;
 		sdkp->RCD = rcd;
-		return count;
+		goto out;
 	}
 
 	if (scsi_mode_sense(sdp, 0x08, 8, buffer, sizeof(buffer), SD_TIMEOUT,
@@ -194,6 +194,7 @@ sd_store_cache_type(struct device *dev, struct device_attribute *attr,
 			sd_print_sense_hdr(sdkp, &sshdr);
 		return -EINVAL;
 	}
+out:
 	revalidate_disk(sdkp->disk);
 	return count;
 }
-- 
1.7.10.4

