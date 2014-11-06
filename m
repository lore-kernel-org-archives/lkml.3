Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752112AbaKFIas (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 03:30:48 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42029 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751692AbaKFIap (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 03:30:45 -0500
From: Hannes Reinecke <hare@suse.de>
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ewan Milne <emilne@redhat.com>,
        Robert Elliott <elliott@hp.com>, linux-scsi@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>, linux-ide@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 06/10] libata: use __scsi_format_command()
Date: Thu,  6 Nov 2014 09:30:35 +0100
Message-Id: <1415262639-121586-7-git-send-email-hare@suse.de>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1415262639-121586-1-git-send-email-hare@suse.de>
References: <1415262639-121586-1-git-send-email-hare@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

libata already uses an internal buffer, so we should be using
__scsi_format_command() here.

Cc: linux-ide@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/ata/libata-eh.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index dad83df..6550a9a 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -2509,15 +2509,12 @@ static void ata_eh_link_report(struct ata_link *link)
 
 		if (ata_is_atapi(qc->tf.protocol)) {
 			if (qc->scsicmd)
-				scsi_print_command(qc->scsicmd);
+				__scsi_format_command(cdb_buf, sizeof(cdb_buf),
+						      qc->scsicmd->cmnd,
+						      qc->scsicmd->cmd_len);
 			else
-				snprintf(cdb_buf, sizeof(cdb_buf),
-				 "cdb %02x %02x %02x %02x %02x %02x %02x %02x  "
-				 "%02x %02x %02x %02x %02x %02x %02x %02x\n         ",
-				 cdb[0], cdb[1], cdb[2], cdb[3],
-				 cdb[4], cdb[5], cdb[6], cdb[7],
-				 cdb[8], cdb[9], cdb[10], cdb[11],
-				 cdb[12], cdb[13], cdb[14], cdb[15]);
+				__scsi_format_command(cdb_buf, sizeof(cdb_buf),
+						      cdb, qc->dev->cdb_len);
 		} else {
 			const char *descr = ata_get_cmd_descript(cmd->command);
 			if (descr)
-- 
1.8.5.2

