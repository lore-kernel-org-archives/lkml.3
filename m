Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901AbaGGXyh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 19:54:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55689 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753710AbaGGXy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:54:26 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ulrich Obergfell <uobergfe@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Christoph Hellwig <hch@lst.de>,
        "Ewan D. Milne" <emilne@redhat.com>, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 3.14 04/94] scsi_error: fix invalid setting of host byte
Date: Mon,  7 Jul 2014 16:56:54 -0700
Message-Id: <20140707235756.909764529@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140707235756.780319003@linuxfoundation.org>
References: <20140707235756.780319003@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ulrich Obergfell <uobergfe@redhat.com>

commit 8922a908908ff947f1f211e07e2e97f1169ad3cb upstream.

After scsi_try_to_abort_cmd returns, the eh_abort_handler may have
already found that the command has completed in the device, causing
the host_byte to be nonzero (e.g. it could be DID_ABORT).  When
this happens, ORing DID_TIME_OUT into the host byte will corrupt
the result field and initiate an unwanted command retry.

Fix this by using set_host_byte instead, following the model of
commit 2082ebc45af9c9c648383b8cde0dc1948eadbf31.

Signed-off-by: Ulrich Obergfell <uobergfe@redhat.com>
[Fix all instances according to review comments. - Paolo]
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Ewan D. Milne <emilne@redhat.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/scsi_error.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -131,7 +131,7 @@ scmd_eh_abort_handler(struct work_struct
 				    "aborting command %p\n", scmd));
 		rtn = scsi_try_to_abort_cmd(sdev->host->hostt, scmd);
 		if (rtn == SUCCESS) {
-			scmd->result |= DID_TIME_OUT << 16;
+			set_host_byte(scmd, DID_TIME_OUT);
 			if (scsi_host_eh_past_deadline(sdev->host)) {
 				SCSI_LOG_ERROR_RECOVERY(3,
 					scmd_printk(KERN_INFO, scmd,
@@ -167,7 +167,7 @@ scmd_eh_abort_handler(struct work_struct
 			scmd_printk(KERN_WARNING, scmd,
 				    "scmd %p terminate "
 				    "aborted command\n", scmd));
-		scmd->result |= DID_TIME_OUT << 16;
+		set_host_byte(scmd, DID_TIME_OUT);
 		scsi_finish_command(scmd);
 	}
 }
@@ -290,7 +290,7 @@ enum blk_eh_timer_return scsi_times_out(
 		if (scsi_abort_command(scmd) == SUCCESS)
 			return BLK_EH_NOT_HANDLED;
 
-	scmd->result |= DID_TIME_OUT << 16;
+	set_host_byte(scmd, DID_TIME_OUT);
 
 	if (unlikely(rtn == BLK_EH_NOT_HANDLED &&
 		     !scsi_eh_scmd_add(scmd, SCSI_EH_CANCEL_CMD)))
@@ -1773,7 +1773,7 @@ int scsi_decide_disposition(struct scsi_
 		break;
 	case DID_ABORT:
 		if (scmd->eh_eflags & SCSI_EH_ABORT_SCHEDULED) {
-			scmd->result |= DID_TIME_OUT << 16;
+			set_host_byte(scmd, DID_TIME_OUT);
 			return SUCCESS;
 		}
 	case DID_NO_CONNECT:


