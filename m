Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758113AbaGOG2M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 02:28:12 -0400
Received: from mail.net13.info ([94.19.113.221]:47838 "EHLO mail.net13.info"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758096AbaGOG2I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 02:28:08 -0400
From: Alexey Asemov <alex@alex-at.ru>
To: linux-ide@vger.kernel.org
Cc: tj@kernel.org, linux-kernel@vger.kernel.org,
        Alexey Asemov <alex@alex-at.ru>
Subject: [PATCH] libata-eh.c should handle AMNF error condition (error byte bit 0, usually code 0x01) in libata-eh.c along with UNC as a media error so SCSI stack can handle it properly (translation code 0x01 is already present in libata-scsi.c) but was never passed down due to lack of handling in EH.
Date: Tue, 15 Jul 2014 10:28:42 +0400
Message-Id: <1405405722-12470-1-git-send-email-alex@alex-at.ru>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20140714161010.GE31610@htj.dyndns.org>
References: <20140714161010.GE31610@htj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While using linux-based machine (AMD 6550M-based notebook, PCI IDs for the
controller are 1022:7801 subsys 1025:059d) and ddrescue to salvage data
from failing hard drive (WD7500BPVT 2.5" 750G SATA2), I've found that pure
AMNF 0x01 error code generates generic "device error" that is retried
several times by SCSI stack instead of "media error" that is passed up to
software.

So we may assume deprecated AMNF error code is surely not dead yet, and
it's better for it to be handled properly. As we may see it is used by
modern enough devices, and used properly: drive returned AMNF only when IDs
for track cannot be read completely due to dying head or positioning,
otherwise it returned UNC(orrectables).

Not handling it causes wrong generic error code ("device error") reporting
down the stack, can damage failing drives further because of excessive
retries, and slows salvaging down a lot. Also, there is handling code in
libata-scsi.c for 0x01 AMNF error already.

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

