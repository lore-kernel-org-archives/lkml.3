Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757297Ab3LBUOI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:14:08 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39220 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754572Ab3LBTR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:17:29 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Roland Dreier <roland@purestorage.com>
Subject: [PATCH 3.12 064/212] IB/srp: Avoid offlining operational SCSI devices
Date: Mon,  2 Dec 2013 11:14:15 -0800
Message-Id: <20131202191255.177610014@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

commit 99b6697a50c2acbe3ca2772d359fc9a28835dc84 upstream.

If SCSI commands are submitted with a SCSI request timeout that is
lower than the the IB RC timeout, it can happen that the SCSI error
handler has already started device recovery before transport layer
error handling starts.  So it can happen that the SCSI error handler
tries to abort a SCSI command after it has been reset by
srp_rport_reconnect().

Tell the SCSI error handler that such commands have finished and that
it is not necessary to continue its recovery strategy for commands
that have been reset by srp_rport_reconnect().

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/ulp/srp/ib_srp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1752,7 +1752,7 @@ static int srp_abort(struct scsi_cmnd *s
 	shost_printk(KERN_ERR, target->scsi_host, "SRP abort called\n");
 
 	if (!req || !srp_claim_req(target, req, scmnd))
-		return FAILED;
+		return SUCCESS;
 	if (srp_send_tsk_mgmt(target, req->index, scmnd->device->lun,
 			      SRP_TSK_ABORT_TASK) == 0)
 		ret = SUCCESS;


