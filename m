Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933588AbaCQNhS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 09:37:18 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:51818 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933287AbaCQNbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 09:31:36 -0400
Message-Id: <20140317133136.205027675@bombadil.infradead.org>
User-Agent: quilt/0.60-1
Date: Mon, 17 Mar 2014 06:28:05 -0700
From: Christoph Hellwig <hch@infradead.org>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 32/39] scsi: unwind blk_end_request_all and blk_end_request_err calls
References: <20140317132733.789623766@bombadil.infradead.org>
Content-Disposition: inline; filename=0032-scsi-unwind-blk_end_request_all-and-blk_end_request_.patch
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Calling blk_end_request directly with the helpers to get the right amount
will make the conversion to blk-mq easier as we only have one place to
switch between the different completion functions.  It also makes the
intention a little more clear to me, but that's a minor side effect.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_lib.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index cd82e4c..94d5893 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -808,7 +808,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 	 * Kill remainder if no retrys.
 	 */
 	if (error && scsi_noretry_cmd(cmd)) {
-		blk_end_request_all(req, error);
+		blk_end_request(req, error, blk_rq_bytes(req));
 		goto next_command;
 	}
 
@@ -948,7 +948,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 				scsi_print_sense("", cmd);
 			scsi_print_command(cmd);
 		}
-		if (!blk_end_request_err(req, error))
+		if (!blk_end_request(req, error, blk_rq_err_bytes(req)))
 			goto next_command;
 		/*FALLTHRU*/
 	case ACTION_REPREP:
-- 
1.7.10.4


