Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752008AbaE0Lic (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 07:38:32 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:37333 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbaE0Lib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 07:38:31 -0400
From: Vaughan Cao <vaughan.cao@oracle.com>
To: JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        vaughan.cao@oracle.com
Subject: [PATCH] notify block layer when using temporary change to cache_type
Date: Tue, 27 May 2014 19:39:14 +0800
Message-Id: <1401190754-6822-1-git-send-email-vaughan.cao@oracle.com>
X-Mailer: git-send-email 1.9.0
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a fix for commit:
  39c60a0948cc06139e2fbfe084f83cb7e7deae3b sd: fix array cache flushing bug causing performance problems
We must notify the block layer via q->flush_flags after temporary change the cache_type to write through.
If not, SYNCHRONIZE CACHE command will still be generated.

Signed-off-by: Vaughan Cao <vaughan.cao@oracle.com>
---
 drivers/scsi/sd.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 6146b9d..366e48b 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -144,6 +144,7 @@ sd_store_cache_type(struct device *dev, struct device_attribute *attr,
 	struct scsi_sense_hdr sshdr;
 	static const char temp[] = "temporary ";
 	int len;
+	unsigned flush;
 
 	if (sdp->type != TYPE_DISK)
 		/* no cache control on RBC devices; theoretically they
@@ -174,6 +175,17 @@ sd_store_cache_type(struct device *dev, struct device_attribute *attr,
 	if (sdkp->cache_override) {
 		sdkp->WCE = wce;
 		sdkp->RCD = rcd;
+
+		/* set flush_flags to notify the block layer */
+		flush = 0;
+		if (sdkp->WCE) {
+			flush |= REQ_FLUSH;
+			if (sdkp->DPOFUA)
+				flush |= REQ_FUA;
+		}
+
+		blk_queue_flush(sdkp->disk->queue, flush);
+
 		return count;
 	}
 
-- 
1.9.0

