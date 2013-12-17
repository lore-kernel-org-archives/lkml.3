Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932464Ab3LQSiH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 13:38:07 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:60850 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755620Ab3LQSO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 13:14:26 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Williams <dan.j.williams@intel.com>,
        James Bottomley <JBottomley@Parallels.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 032/103] [SCSI] libsas: fix usage of ata_tf_to_fis
Date: Tue, 17 Dec 2013 18:12:21 +0000
Message-Id: <1387304012-23805-33-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387304012-23805-1-git-send-email-luis.henriques@canonical.com>
References: <1387304012-23805-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.28 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Williams <dan.j.williams@intel.com>

commit ae5fbae0ccd982dfca0ce363036ed92f5b13f150 upstream.

Since commit 110dd8f19df5 "[SCSI] libsas: fix scr_read/write users and
update the libata documentation" we have been passing pmp=1 and is_cmd=0
to ata_tf_to_fis().  Praveen reports that eSATA attached drives do not
discover correctly.  His investigation found that the BIOS was passing
pmp=0 while Linux was passing pmp=1 and failing to discover the drives.
Update libsas to follow the libata example of pulling the pmp setting
from the ata_link and correct is_cmd to be 1 since all tf's submitted
through ->qc_issue are commands.  Presumably libsas lldds do not care
about is_cmd as they have sideband mechanisms to perform link
management.

http://marc.info/?l=linux-scsi&m=138179681726990

[jejb: checkpatch fix]
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reported-by: Praveen Murali <pmurali@logicube.com>
Tested-by: Praveen Murali <pmurali@logicube.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/scsi/libsas/sas_ata.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index d109cc3..51ee663 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -211,7 +211,7 @@ static unsigned int sas_ata_qc_issue(struct ata_queued_cmd *qc)
 		qc->tf.nsect = 0;
 	}
 
-	ata_tf_to_fis(&qc->tf, 1, 0, (u8*)&task->ata_task.fis);
+	ata_tf_to_fis(&qc->tf, qc->dev->link->pmp, 1, (u8 *)&task->ata_task.fis);
 	task->uldd_task = qc;
 	if (ata_is_atapi(qc->tf.protocol)) {
 		memcpy(task->ata_task.atapi_packet, qc->cdb, qc->dev->cdb_len);
-- 
1.8.3.2

