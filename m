Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079Ab3KEAxW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 19:53:22 -0500
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:34021 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753833Ab3KEAxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 19:53:03 -0500
X-Authority-Analysis: v=2.0 cv=LKjkseq9 c=1 sm=0 a=3SewDSjaRW4vdJyuxQ33ZQ==:17 a=DeBnktw0k-IA:10 a=S7odh0Gf1mcA:10 a=S1A5HrydsesA:10 a=fxJcL_dCAAAA:8 a=KGjhK52YXX0A:10 a=n2y2MpndqSQA:10 a=7Z2EJvZXTn7YVNZo5r0A:9 a=2eKvNQJKnqYA:10 a=3SewDSjaRW4vdJyuxQ33ZQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 72.238.73.171
From: Phillip Susi <psusi@ubuntu.com>
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] libata: avoid waking disk to check power
Date: Mon,  4 Nov 2013 19:53:00 -0500
Message-Id: <1383612780-6591-2-git-send-email-psusi@ubuntu.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1383612780-6591-1-git-send-email-psusi@ubuntu.com>
References: <1383612780-6591-1-git-send-email-psusi@ubuntu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a disk is in SLEEP mode it can not respond to commands,
including the CHECK POWER command.  Instead of waking up the
sleeping disk, fake the reply to the CHECK POWER command to
indicate the disk is in standby mode.  This prevents udisks
from waking up sleeping disks when it polls to see if they
are awake or not before trying to read their smart status.

Signed-off-by: Phillip Susi <psusi@ubuntu.com>
---
 drivers/ata/libata-core.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 83b1a9f..573d151 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5084,6 +5084,13 @@ void ata_qc_issue(struct ata_queued_cmd *qc)
 
 	/* if device is sleeping, schedule reset and abort the link */
 	if (unlikely(qc->dev->flags & ATA_DFLAG_SLEEPING)) {
+		if (unlikely(qc->tf.command == ATA_CMD_CHK_POWER))
+		{
+			/* fake reply to avoid waking drive */
+			qc->result_tf.nsect = 0;
+			ata_qc_complete(qc);
+			return;
+		}
 		link->eh_info.action |= ATA_EH_RESET;
 		ata_ehi_push_desc(&link->eh_info, "waking up from sleep");
 		ata_link_abort(link);
-- 
1.8.3.2

