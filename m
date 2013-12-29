Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147Ab3L2Cje (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:39:34 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55311 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752499Ab3L2CKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:10:35 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "James Bottomley" <JBottomley@Parallels.com>,
        "Dan Williams" <dan.j.williams@intel.com>,
        "Praveen Murali" <pmurali@logicube.com>
Date: Sun, 29 Dec 2013 03:08:44 +0100
Message-ID: <lsq.1388282924.168796121@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 101/185] [SCSI] libsas: fix usage of ata_tf_to_fis
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/libsas/sas_ata.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -197,7 +197,7 @@ static unsigned int sas_ata_qc_issue(str
 		qc->tf.nsect = 0;
 	}
 
-	ata_tf_to_fis(&qc->tf, 1, 0, (u8*)&task->ata_task.fis);
+	ata_tf_to_fis(&qc->tf, qc->dev->link->pmp, 1, (u8 *)&task->ata_task.fis);
 	task->uldd_task = qc;
 	if (ata_is_atapi(qc->tf.protocol)) {
 		memcpy(task->ata_task.atapi_packet, qc->cdb, qc->dev->cdb_len);

