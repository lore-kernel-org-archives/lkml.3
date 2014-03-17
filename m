Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933768AbaCQNpy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 09:45:54 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:51788 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933181AbaCQNbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 09:31:33 -0400
Message-Id: <20140317133133.123581521@bombadil.infradead.org>
User-Agent: quilt/0.60-1
Date: Mon, 17 Mar 2014 06:27:44 -0700
From: Christoph Hellwig <hch@infradead.org>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bart Van Assche <bvanassche@acm.org>, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 11/39] scsi: remove a useless get/put_device pair in scsi_next_command
References: <20140317132733.789623766@bombadil.infradead.org>
Content-Disposition: inline; filename=0011-scsi-remove-a-useless-get-put_device-pair-in-scsi_ne.patch
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eliminate a get_device() / put_device() pair from scsi_next_command().
Both are atomic operations hence removing these slightly improves
performance.

[hch: slight changes due to different context]

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Acked-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_lib.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index a6d5525..6866943 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -526,14 +526,9 @@ void scsi_next_command(struct scsi_cmnd *cmd)
 	struct scsi_device *sdev = cmd->device;
 	struct request_queue *q = sdev->request_queue;
 
-	/* need to hold a reference on the device before we let go of the cmd */
-	get_device(&sdev->sdev_gendev);
-
 	scsi_put_command(cmd);
-	put_device(&sdev->sdev_gendev);
 	scsi_run_queue(q);
 
-	/* ok to remove device now */
 	put_device(&sdev->sdev_gendev);
 }
 
-- 
1.7.10.4


