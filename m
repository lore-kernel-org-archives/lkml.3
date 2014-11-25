Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754372AbaKYLFt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:05:49 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58928 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832AbaKYKmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:42:55 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Christoph Hellwig <hch@lst.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 185/254] scsi: only re-lock door after EH on devices that were reset
Date: Tue, 25 Nov 2014 10:38:55 +0000
Message-Id: <1416912004-5928-186-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/scsi/scsi_error.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 7e957918f33f..b350eb8ec898 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1989,8 +1989,10 @@ static void scsi_restart_operations(struct Scsi_Host *shost)
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
2.1.0

