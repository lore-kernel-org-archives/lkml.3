Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933634AbaFLNrX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 09:47:23 -0400
Received: from casper.infradead.org ([85.118.1.10]:59486 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933492AbaFLNrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 09:47:14 -0400
From: Christoph Hellwig <hch@lst.de>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <axboe@kernel.dk>, Bart Van Assche <bvanassche@fusionio.com>,
        Robert Elliot <Elliott@hp.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hiral Patel <hiralpat@cisco.com>,
        Suma Ramars <sramars@cisco.com>, Brian Uchino <buchino@cisco.com>
Subject: [PATCH 14/14] fnic: reject device resets without assigned tags for the blk-mq case
Date: Thu, 12 Jun 2014 15:49:06 +0200
Message-Id: <1402580946-11470-15-git-send-email-hch@lst.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1402580946-11470-1-git-send-email-hch@lst.de>
References: <1402580946-11470-1-git-send-email-hch@lst.de>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current the midlayer fakes up a struct request for the explicit reset
ioctls, and those don't have a tag allocated to them.  The fnic driver pokes
into midlayer structures to paper over this design issue, but that won't
work for the blk-mq case.

Either someone who can actually test the hardware will have to come up with
a similar hack for the blk-mq case, or we'll have to bite the bullet and fix
the way the EH ioctls work for real, but until that happens we fail these
explicit requests here.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Hiral Patel <hiralpat@cisco.com>
Cc: Suma Ramars <sramars@cisco.com>
Cc: Brian Uchino <buchino@cisco.com>
---
 drivers/scsi/fnic/fnic_scsi.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index ea28b5c..f5dd7e0 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -2224,6 +2224,22 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 
 	tag = sc->request->tag;
 	if (unlikely(tag < 0)) {
+		/*
+		 * XXX(hch): current the midlayer fakes up a struct
+		 * request for the explicit reset ioctls, and those
+		 * don't have a tag allocated to them.  The below
+		 * code pokes into midlayer structures to paper over
+		 * this design issue, but that won't work for blk-mq.
+		 *
+		 * Either someone who can actually test the hardware
+		 * will have to come up with a similar hack for the
+		 * blk-mq case, or we'll have to bite the bullet and
+		 * fix the way the EH ioctls work for real, but until
+		 * that happens we fail these explicit requests here.
+		 */
+		if (shost_use_blk_mq(sc->device->host))
+			goto fnic_device_reset_end;
+
 		tag = fnic_scsi_host_start_tag(fnic, sc);
 		if (unlikely(tag == SCSI_NO_TAG))
 			goto fnic_device_reset_end;
-- 
1.7.10.4

