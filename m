Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752943AbaDYLIU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 07:08:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:41782 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709AbaDYLHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 07:07:52 -0400
From: Christoph Hellwig <hch@lst.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        James Bottomley <JBottomley@Parallels.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 2/2] scsi: don't reference freed command in scsi_prep_return
Date: Fri, 25 Apr 2014 13:09:50 +0200
Message-Id: <1398424190-21325-3-git-send-email-hch@lst.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1398424190-21325-1-git-send-email-hch@lst.de>
References: <1398424190-21325-1-git-send-email-hch@lst.de>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the kill case of scsi_prep_return we have to release our device
reference, but we do this trying to reference the just freed command.
Use the local sdev pointer instead.

Reported-by: Joe Lawrence <joe.lawrence@stratus.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_lib.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 54eff6a..7fa54fe 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1274,7 +1274,7 @@ int scsi_prep_return(struct request_queue *q, struct request *req, int ret)
 			struct scsi_cmnd *cmd = req->special;
 			scsi_release_buffers(cmd);
 			scsi_put_command(cmd);
-			put_device(&cmd->device->sdev_gendev);
+			put_device(&sdev->sdev_gendev);
 			req->special = NULL;
 		}
 		break;
-- 
1.7.10.4

