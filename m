Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753Ab3LJIPd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 03:15:33 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58909 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753677Ab3LJIB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 03:01:56 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Williams <dan.j.williams@intel.com>,
        Praveen Murali <pmurali@logicube.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [PATCH 3.12 34/62] SCSI: libsas: fix usage of ata_tf_to_fis
Date: Tue, 10 Dec 2013 00:01:05 -0800
Message-Id: <20131210080059.844093501@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131210080057.415644748@linuxfoundation.org>
References: <20131210080057.415644748@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/libsas/sas_ata.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -211,7 +211,7 @@ static unsigned int sas_ata_qc_issue(str
 		qc->tf.nsect = 0;
 	}
 
-	ata_tf_to_fis(&qc->tf, 1, 0, (u8*)&task->ata_task.fis);
+	ata_tf_to_fis(&qc->tf, qc->dev->link->pmp, 1, (u8 *)&task->ata_task.fis);
 	task->uldd_task = qc;
 	if (ata_is_atapi(qc->tf.protocol)) {
 		memcpy(task->ata_task.atapi_packet, qc->cdb, qc->dev->cdb_len);


