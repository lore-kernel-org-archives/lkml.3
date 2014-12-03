Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057AbaLCLzX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 06:55:23 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54703 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752322AbaLCL1N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:27:13 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 043/101] scsi: only re-lock door after EH on devices that were reset
Date: Wed,  3 Dec 2014 12:26:05 +0100
Message-Id: <7a6e7a368541b06df81597056667035aedbe514c.1417605922.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
References: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
In-Reply-To: <cover.1417605922.git.jslaby@suse.cz>
References: <cover.1417605922.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/scsi/scsi_error.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 9ba3642cb19e..066e3198838d 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1746,8 +1746,10 @@ static void scsi_restart_operations(struct Scsi_Host *shost)
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
2.1.3

