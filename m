Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455Ab3CAUZt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 15:25:49 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51319 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317Ab3CATpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 14:45:09 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        David Dillow <dave@thedillows.org>,
        Roland Dreier <roland@purestorage.com>
Subject: [ 08/77] IB/srp: Avoid endless SCSI error handling loop
Date: Fri,  1 Mar 2013 11:43:53 -0800
Message-Id: <20130301194352.853242357@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130301194351.913471337@linuxfoundation.org>
References: <20130301194351.913471337@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

commit c7c4e7ff8047e43c45628b85ac200582e9404c39 upstream.

If a SCSI command times out it is passed to the SCSI error
handler. The SCSI error handler will try to abort the commands that
timed out.  If aborting fails, a device reset will be attempted.  If
the device reset also fails a host reset will be attempted.  If the
host reset also fails the whole procedure will be repeated.

srp_abort() and srp_reset_device() fail for a QP in the error state.
srp_reset_host() fails after host removal has started.  Hence if the
SCSI error handler gets invoked after host removal has started and
with the QP in the error state an endless loop will be triggered.

Modify the SCSI error handling functions in ib_srp as follows:
- Abort SCSI commands properly even if the QP is in the error state.
- Make srp_reset_host() reset SCSI requests even after host removal
  has already started or if reconnecting fails.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Acked-by: David Dillow <dave@thedillows.org>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/ulp/srp/ib_srp.c |   29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -700,23 +700,24 @@ static int srp_reconnect_target(struct s
 	struct Scsi_Host *shost = target->scsi_host;
 	int i, ret;
 
-	if (target->state != SRP_TARGET_LIVE)
-		return -EAGAIN;
-
 	scsi_target_block(&shost->shost_gendev);
 
 	srp_disconnect_target(target);
 	/*
-	 * Now get a new local CM ID so that we avoid confusing the
-	 * target in case things are really fouled up.
+	 * Now get a new local CM ID so that we avoid confusing the target in
+	 * case things are really fouled up. Doing so also ensures that all CM
+	 * callbacks will have finished before a new QP is allocated.
 	 */
 	ret = srp_new_cm_id(target);
-	if (ret)
-		goto unblock;
-
-	ret = srp_create_target_ib(target);
-	if (ret)
-		goto unblock;
+	/*
+	 * Whether or not creating a new CM ID succeeded, create a new
+	 * QP. This guarantees that all completion callback function
+	 * invocations have finished before request resetting starts.
+	 */
+	if (ret == 0)
+		ret = srp_create_target_ib(target);
+	else
+		srp_create_target_ib(target);
 
 	for (i = 0; i < SRP_CMD_SQ_SIZE; ++i) {
 		struct srp_request *req = &target->req_ring[i];
@@ -728,9 +729,9 @@ static int srp_reconnect_target(struct s
 	for (i = 0; i < SRP_SQ_SIZE; ++i)
 		list_add(&target->tx_ring[i]->list, &target->free_tx);
 
-	ret = srp_connect_target(target);
+	if (ret == 0)
+		ret = srp_connect_target(target);
 
-unblock:
 	scsi_target_unblock(&shost->shost_gendev, ret == 0 ? SDEV_RUNNING :
 			    SDEV_TRANSPORT_OFFLINE);
 
@@ -1739,7 +1740,7 @@ static int srp_abort(struct scsi_cmnd *s
 
 	shost_printk(KERN_ERR, target->scsi_host, "SRP abort called\n");
 
-	if (!req || target->qp_in_error || !srp_claim_req(target, req, scmnd))
+	if (!req || !srp_claim_req(target, req, scmnd))
 		return FAILED;
 	srp_send_tsk_mgmt(target, req->index, scmnd->device->lun,
 			  SRP_TSK_ABORT_TASK);


