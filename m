Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423009Ab3LFXUh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 18:20:37 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48946 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161210Ab3LFXUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 18:20:30 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Bart Van Assche <bvanassche@acm.org>,
        Roland Dreier <roland@purestorage.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 086/152] IB/srp: Avoid offlining operational SCSI devices
Date: Fri,  6 Dec 2013 15:10:10 -0800
Message-Id: <1386371476-2477-87-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386371476-2477-1-git-send-email-kamal@canonical.com>
References: <1386371476-2477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.14 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 2223eb6..bff567b 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1749,7 +1749,7 @@ static int srp_abort(struct scsi_cmnd *scmnd)
 	shost_printk(KERN_ERR, target->scsi_host, "SRP abort called\n");
 
 	if (!req || !srp_claim_req(target, req, scmnd))
-		return FAILED;
+		return SUCCESS;
 	srp_send_tsk_mgmt(target, req->index, scmnd->device->lun,
 			  SRP_TSK_ABORT_TASK);
 	srp_free_req(target, req, scmnd, 0);
-- 
1.8.3.2

