Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013AbbAIUOI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 15:14:08 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:47144 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751091AbbAIUOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 15:14:06 -0500
Message-ID: <1420834443.8974.9.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 3.19-rc2
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Fri, 09 Jan 2015 12:14:03 -0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just one fix: a qlogic busy wait regression.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Bruno Prémont (1):
      qla2xxx: fix busy wait regression

And the diffstat:

 drivers/scsi/qla2xxx/qla_os.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

With full diff below.

James

---

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 12ca291..cce1cbc 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -734,7 +734,9 @@ qla2xxx_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	 * Return target busy if we've received a non-zero retry_delay_timer
 	 * in a FCP_RSP.
 	 */
-	if (time_after(jiffies, fcport->retry_delay_timestamp))
+	if (fcport->retry_delay_timestamp == 0) {
+		/* retry delay not set */
+	} else if (time_after(jiffies, fcport->retry_delay_timestamp))
 		fcport->retry_delay_timestamp = 0;
 	else
 		goto qc24_target_busy;


