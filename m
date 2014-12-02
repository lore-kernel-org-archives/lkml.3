Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934023AbaLBTvf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:51:35 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46603 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933187AbaLBTWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:22:09 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Christoph Hellwig <hch@lst.de>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 069/121] scsi: only re-lock door after EH on devices that were reset
Date: Tue,  2 Dec 2014 11:19:08 -0800
Message-Id: <1417548000-1794-70-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417548000-1794-1-git-send-email-kamal@canonical.com>
References: <1417548000-1794-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

commit 48379270fe6808cf4612ee094adc8da2b7a83baa upstream.

Setups that use the blk-mq I/O path can lock up if a host with a single
device that has its door locked enters EH.  Make sure to only send the
command to re-lock the door to devices that actually were reset and thus
might have lost their state.  Otherwise the EH code might be get blocked
on blk_get_request as all requests for non-reset devices might be in use.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reported-by: Meelis Roos <meelis.roos@ut.ee>
Tested-by: Meelis Roos <meelis.roos@ut.ee>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/scsi/scsi_error.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 09f930d..c6dcbe6 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1860,8 +1860,10 @@ static void scsi_restart_operations(struct Scsi_Host *shost)
 	 * is no point trying to lock the door of an off-line device.
 	 */
 	shost_for_each_device(sdev, shost) {
-		if (scsi_device_online(sdev) && sdev->locked)
+		if (scsi_device_online(sdev) && sdev->was_reset && sdev->locked) {
 			scsi_eh_lock_door(sdev);
+			sdev->was_reset = 0;
+		}
 	}
 
 	/*
-- 
1.9.1

