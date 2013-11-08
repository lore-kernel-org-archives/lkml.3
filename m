Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757431Ab3KHCZV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 21:25:21 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34927 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932710Ab3KHCWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 21:22:03 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Gwendal Grignou <gwendal@google.com>, Tejun Heo <tj@kernel.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 47/91] libata: make ata_eh_qc_retry() bump scmd->allowed on bogus failures
Date: Thu,  7 Nov 2013 18:15:02 -0800
Message-Id: <1383876946-2396-48-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383876946-2396-1-git-send-email-kamal@canonical.com>
References: <1383876946-2396-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gwendal Grignou <gwendal@google.com>

commit f13e220161e738c2710b9904dcb3cf8bb0bcce61 upstream.

libata EH decrements scmd->retries when the command failed for reasons
unrelated to the command itself so that, for example, commands aborted
due to suspend / resume cycle don't get penalized; however,
decrementing scmd->retries isn't enough for ATA passthrough commands.

Without this fix, ATA passthrough commands are not resend to the
drive, and no error is signalled to the caller because:

- allowed retry count is 1
- ata_eh_qc_complete fill the sense data, so result is valid
- sense data is filled with untouched ATA registers.

Signed-off-by: Gwendal Grignou <gwendal@google.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/ata/libata-eh.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index bcf4437..005e458 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -1322,14 +1322,14 @@ void ata_eh_qc_complete(struct ata_queued_cmd *qc)
  *	should be retried.  To be used from EH.
  *
  *	SCSI midlayer limits the number of retries to scmd->allowed.
- *	scmd->retries is decremented for commands which get retried
+ *	scmd->allowed is incremented for commands which get retried
  *	due to unrelated failures (qc->err_mask is zero).
  */
 void ata_eh_qc_retry(struct ata_queued_cmd *qc)
 {
 	struct scsi_cmnd *scmd = qc->scsicmd;
-	if (!qc->err_mask && scmd->retries)
-		scmd->retries--;
+	if (!qc->err_mask)
+		scmd->allowed++;
 	__ata_eh_qc_complete(qc);
 }
 
-- 
1.8.1.2

