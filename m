Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277AbaLFCgR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 21:36:17 -0500
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:51237
	"EHLO p3plsmtps2ded01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751941AbaLFCgP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 21:36:15 -0500
X-Greylist: delayed 451 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Dec 2014 21:36:15 EST
x-originating-ip: 72.167.245.219
From: Long Li <longli@microsoft.com>
To: linux-scsi@vger.kernel.org
Cc: kys@microsoft.com, haiyangz@microsoft.com, JBottomley@parallels.com,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        Long Li <longli@microsoft.com>
Subject: drivers:scsi:storvsc: Fix a bug in handling ring buffer failures that may result in I/O freeze
Date: Fri,  5 Dec 2014 19:38:18 -0800
Message-Id: <1417837098-23815-1-git-send-email-longli@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When ring buffer returns an error indicating retry, storvsc may not return a proper error code to SCSI when bounce buffer is not used. This has introduced I/O freeze on RAID running atop storvsc devices. This patch fixes it by always returning a proper error code.

Signed-off-by: Long Li <longli@microsoft.com>
Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/scsi/storvsc_drv.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index e3ba251..4cff0dd 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1688,13 +1688,12 @@ static int storvsc_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scmnd)
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
2.1.0

