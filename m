Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544Ab3CATpT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 14:45:19 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51344 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538Ab3CATpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 14:45:15 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        David Dillow <dave@thedillows.org>,
        Roland Dreier <roland@purestorage.com>
Subject: [ 07/77] IB/srp: Avoid sending a task management function needlessly
Date: Fri,  1 Mar 2013 11:43:52 -0800
Message-Id: <20130301194352.743401389@linuxfoundation.org>
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

commit 3780d1f08856f692116bcf026e4acf1c521df1c7 upstream.

Do not send a task management function if sending will fail anyway
because either there is no RDMA/RC connection or the QP is in the
error state.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Acked-by: David Dillow <dave@thedillows.org>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/ulp/srp/ib_srp.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1695,6 +1695,9 @@ static int srp_send_tsk_mgmt(struct srp_
 	struct srp_iu *iu;
 	struct srp_tsk_mgmt *tsk_mgmt;
 
+	if (!target->connected || target->qp_in_error)
+		return -1;
+
 	init_completion(&target->tsk_mgmt_done);
 
 	spin_lock_irq(&target->lock);
@@ -1754,8 +1757,6 @@ static int srp_reset_device(struct scsi_
 
 	shost_printk(KERN_ERR, target->scsi_host, "SRP reset_device called\n");
 
-	if (target->qp_in_error)
-		return FAILED;
 	if (srp_send_tsk_mgmt(target, SRP_TAG_NO_REQ, scmnd->device->lun,
 			      SRP_TSK_LUN_RESET))
 		return FAILED;


