Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751691AbbASMCA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 07:02:00 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52918 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751474AbbASMBD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 07:01:03 -0500
From: Hannes Reinecke <hare@suse.de>
To: Tejun Heo <tj@kernel.org>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH] libata: fixup oops in ata_eh_link_report()
Date: Mon, 19 Jan 2015 13:00:59 +0100
Message-Id: <1421668859-4593-1-git-send-email-hare@suse.de>
X-Mailer: git-send-email 1.8.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should only try to evaluate the cdb if this is an ATAPI
device, for any other device the 'cdb' field and the cdb_len
has no meaning.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/ata/libata-eh.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 9179f11..584c6ae 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -2481,8 +2481,6 @@ static void ata_eh_link_report(struct ata_link *link)
 	for (tag = 0; tag < ATA_MAX_QUEUE; tag++) {
 		struct ata_queued_cmd *qc = __ata_qc_from_tag(ap, tag);
 		struct ata_taskfile *cmd = &qc->tf, *res = &qc->result_tf;
-		const u8 *cdb = qc->cdb;
-		size_t cdb_len = qc->dev->cdb_len;
 		char data_buf[20] = "";
 		char cdb_buf[70] = "";
 
@@ -2510,6 +2508,9 @@ static void ata_eh_link_report(struct ata_link *link)
 		}
 
 		if (ata_is_atapi(qc->tf.protocol)) {
+			const u8 *cdb = qc->cdb;
+			size_t cdb_len = qd->dev->cdb_len;
+
 			if (qc->scsicmd) {
 				cdb = qc->scsicmd->cmnd;
 				cdb_len = qc->scsicmd->cmd_len;
-- 
1.8.5.2

