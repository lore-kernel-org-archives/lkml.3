Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965716AbaLLGhk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:37:40 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51864 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759301AbaLLGQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:16:56 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Meelis Roos" <meelis.roos@ut.ee>, "Christoph Hellwig" <hch@lst.de>
Date: Fri, 12 Dec 2014 06:14:25 +0000
Message-ID: <lsq.1418364865.269958255@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 123/164] scsi: only re-lock door after EH on devices
 that were reset
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/scsi_error.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1665,8 +1665,10 @@ static void scsi_restart_operations(stru
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

