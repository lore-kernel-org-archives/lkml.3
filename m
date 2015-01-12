Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755655AbbALSpv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:45:51 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58316 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755192AbbALSai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:30:38 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Long Li <longli@microsoft.com>, Christoph Hellwig <hch@lst.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 177/216] storvsc: ring buffer failures may result in I/O freeze
Date: Mon, 12 Jan 2015 18:29:15 +0000
Message-Id: <1421087394-2712-65-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Long Li <longli@microsoft.com>

commit e86fb5e8ab95f10ec5f2e9430119d5d35020c951 upstream.

When ring buffer returns an error indicating retry, storvsc may not
return a proper error code to SCSI when bounce buffer is not used.
This has introduced I/O freeze on RAID running atop storvsc devices.
This patch fixes it by always returning a proper error code.

Signed-off-by: Long Li <longli@microsoft.com>
Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/scsi/storvsc_drv.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index ed0f899e8aa5..86b05151fdab 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1690,13 +1690,12 @@ static int storvsc_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scmnd)
 	if (ret == -EAGAIN) {
 		/* no more space */
 
-		if (cmd_request->bounce_sgl_count) {
+		if (cmd_request->bounce_sgl_count)
 			destroy_bounce_buffer(cmd_request->bounce_sgl,
 					cmd_request->bounce_sgl_count);
 
-			ret = SCSI_MLQUEUE_DEVICE_BUSY;
-			goto queue_error;
-		}
+		ret = SCSI_MLQUEUE_DEVICE_BUSY;
+		goto queue_error;
 	}
 
 	return 0;
-- 
2.1.4

