Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752045AbaGLI2e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 04:28:34 -0400
Received: from mail.net13.info ([94.19.113.221]:57061 "EHLO mail.net13.info"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751760AbaGLI21 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 04:28:27 -0400
X-Greylist: delayed 328 seconds by postgrey-1.27 at vger.kernel.org; Sat, 12 Jul 2014 04:28:27 EDT
From: Alexey Asemov <alex@alex-at.ru>
To: linux-ide@vger.kernel.org
Cc: tj@kernel.org, linux-kernel@vger.kernel.org,
        Alexey Asemov <alex@alex-at.ru>
Subject: [PATCH] libata: handle IDE AMNF errors in the EH path
Date: Sat, 12 Jul 2014 12:22:53 +0400
Message-Id: <1405153373-11108-1-git-send-email-alex@alex-at.ru>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

libata-eh.c should handle AMNF error condition (error byte bit 0, usually
code 0x01) in libata-eh.c along with UNC as a media error so SCSI stack
can handle it properly (translation code 0x01 is already present in
libata-scsi.c) but was never passed down due to lack of handling in EH.

https://bugzilla.kernel.org/show_bug.cgi?id=80031

Signed-off-by: Alexey Asemov <alex@alex-at.ru>
---
 drivers/ata/libata-eh.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 6760fc4..dad83df 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -1811,7 +1811,7 @@ static unsigned int ata_eh_analyze_tf(struct ata_queued_cmd *qc,
 	case ATA_DEV_ATA:
 		if (err & ATA_ICRC)
 			qc->err_mask |= AC_ERR_ATA_BUS;
-		if (err & ATA_UNC)
+		if (err & (ATA_UNC | ATA_AMNF))
 			qc->err_mask |= AC_ERR_MEDIA;
 		if (err & ATA_IDNF)
 			qc->err_mask |= AC_ERR_INVALID;
@@ -2556,11 +2556,12 @@ static void ata_eh_link_report(struct ata_link *link)
 		}
 
 		if (cmd->command != ATA_CMD_PACKET &&
-		    (res->feature & (ATA_ICRC | ATA_UNC | ATA_IDNF |
-				     ATA_ABORTED)))
-			ata_dev_err(qc->dev, "error: { %s%s%s%s}\n",
+		    (res->feature & (ATA_ICRC | ATA_UNC | ATA_AMNF |
+				     ATA_IDNF | ATA_ABORTED)))
+			ata_dev_err(qc->dev, "error: { %s%s%s%s%s}\n",
 			  res->feature & ATA_ICRC ? "ICRC " : "",
 			  res->feature & ATA_UNC ? "UNC " : "",
+			  res->feature & ATA_AMNF ? "AMNF " : "",
 			  res->feature & ATA_IDNF ? "IDNF " : "",
 			  res->feature & ATA_ABORTED ? "ABRT " : "");
 #endif
-- 
1.7.1

