Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757447Ab3BFPQz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 10:16:55 -0500
Received: from mail-vb0-f50.google.com ([209.85.212.50]:48394 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757412Ab3BFPQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 10:16:51 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v2 14/14] sg_io: use unpriv_sgio to disable whitelisting for scanners
Date: Wed,  6 Feb 2013 16:16:01 +0100
Message-Id: <1360163761-8541-15-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1360163761-8541-1-git-send-email-pbonzini@redhat.com>
References: <1360163761-8541-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Scanners allow all commands because vendor-specific commands are common.
The queue flag we just added lets us keep this behavior by default,
while making it possible to disable it.

Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 drivers/scsi/scsi_scan.c |   12 +++++++++++-
 drivers/scsi/sg.c        |    3 ---
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 86940f3..702b0ef 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -785,13 +785,23 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	sdev->request_queue->sgio_type = sdev->type;
 
 	switch (sdev->type) {
+	case TYPE_SCANNER:
+		/*
+		 * Scanners often use(d) vendor-specific commands.  A bunch
+		 * of them is whitelisted, but just allow everything by
+		 * default for maximum compatibility.
+		 */
+		__set_bit(QUEUE_FLAG_UNPRIV_SGIO,
+			  &sdev->request_queue->queue_flags);
+		sdev->writeable = 1;
+		break;
+
 	case TYPE_RBC:
 	case TYPE_TAPE:
 	case TYPE_DISK:
 	case TYPE_PRINTER:
 	case TYPE_MOD:
 	case TYPE_PROCESSOR:
-	case TYPE_SCANNER:
 	case TYPE_MEDIUM_CHANGER:
 	case TYPE_ENCLOSURE:
 	case TYPE_COMM:
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index cab816f..1c35628 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -219,9 +219,6 @@ static int sg_allow_access(struct file *filp, unsigned char *cmd)
 	struct sg_fd *sfp = filp->private_data;
 	struct request_queue *q = sfp->parentdp->device->request_queue;
 
-	if (sfp->parentdp->device->type == TYPE_SCANNER)
-		return 0;
-
 	return blk_verify_command(q, cmd, filp->f_mode & FMODE_WRITE);
 }
 
-- 
1.7.1

