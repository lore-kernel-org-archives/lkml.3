Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752276AbaFDKMH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 06:12:07 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:40768 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038AbaFDKMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 06:12:02 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: hch@lst.de, JBottomley@Parallels.com, venkateshs@google.com,
        Ulrich Obergfell <uobergfe@redhat.com>, stable@vger.kernel.org
Subject: [PATCH v2 4/6] scsi_error: fix invalid setting of host byte
Date: Wed,  4 Jun 2014 12:11:41 +0200
Message-Id: <1401876703-10236-5-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1401876703-10236-1-git-send-email-pbonzini@redhat.com>
References: <1401876703-10236-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ulrich Obergfell <uobergfe@redhat.com>

After scsi_try_to_abort_cmd returns, the eh_abort_handler may have
already found that the command has completed in the device, causing
the host_byte to be nonzero (e.g. it could be DID_ABORT).  When
this happens, ORing DID_TIME_OUT into the host byte will corrupt
the result field and initiate an unwanted command retry.

Fix this by using set_host_byte instead, following the model of
commit 2082ebc45af9c9c648383b8cde0dc1948eadbf31.

Cc: stable@vger.kernel.org
Signed-off-by: Ulrich Obergfell <uobergfe@redhat.com>
[Fix all instances according to review comments. - Paolo]
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
	v1->v2: fix all occurrences [Bart]

 drivers/scsi/scsi_error.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index f17aa7aa7879..8e7a0f8d4f52 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -131,7 +131,7 @@ scmd_eh_abort_handler(struct work_struct *work)
 				    "aborting command %p\n", scmd));
 		rtn = scsi_try_to_abort_cmd(sdev->host->hostt, scmd);
 		if (rtn == SUCCESS) {
-			scmd->result |= DID_TIME_OUT << 16;
+			set_host_byte(scmd, DID_TIME_OUT);
 			if (scsi_host_eh_past_deadline(sdev->host)) {
 				SCSI_LOG_ERROR_RECOVERY(3,
 					scmd_printk(KERN_INFO, scmd,
@@ -167,7 +167,7 @@ scmd_eh_abort_handler(struct work_struct *work)
 			scmd_printk(KERN_WARNING, scmd,
 				    "scmd %p terminate "
 				    "aborted command\n", scmd));
-		scmd->result |= DID_TIME_OUT << 16;
+		set_host_byte(scmd, DID_TIME_OUT);
 		scsi_finish_command(scmd);
 	}
 }
@@ -291,7 +291,7 @@ enum blk_eh_timer_return scsi_times_out(struct request *req)
 		if (scsi_abort_command(scmd) == SUCCESS)
 			return BLK_EH_NOT_HANDLED;
 
-	scmd->result |= DID_TIME_OUT << 16;
+	set_host_byte(scmd, DID_TIME_OUT);
 
 	if (unlikely(rtn == BLK_EH_NOT_HANDLED &&
 		     !scsi_eh_scmd_add(scmd, SCSI_EH_CANCEL_CMD)))
-- 
1.8.3.1


