Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161921Ab3LFNEX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:04:23 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44517 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161856Ab3LFNED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:04:03 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Bart Van Assche <bvanassche@acm.org>,
        Roland Dreier <roland@purestorage.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 201/272] IB/srp: Avoid offlining operational SCSI devices
Date: Fri,  6 Dec 2013 12:58:10 +0000
Message-Id: <1386334761-25517-202-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index bc003a5..17b58f4 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1751,7 +1751,7 @@ static int srp_abort(struct scsi_cmnd *scmnd)
 	shost_printk(KERN_ERR, target->scsi_host, "SRP abort called\n");
 
 	if (!req || !srp_claim_req(target, req, scmnd))
-		return FAILED;
+		return SUCCESS;
 	if (srp_send_tsk_mgmt(target, req->index, scmnd->device->lun,
 			      SRP_TSK_ABORT_TASK) == 0)
 		ret = SUCCESS;
-- 
1.8.3.2

