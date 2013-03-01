Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310Ab3CAUZh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 15:25:37 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51323 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366Ab3CATpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 14:45:10 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Roland Dreier <roland@purestorage.com>
Subject: [ 09/77] IB/srp: Fail I/O requests if the transport is offline
Date: Fri,  1 Mar 2013 11:43:54 -0800
Message-Id: <20130301194352.972859408@linuxfoundation.org>
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

commit 2ce19e72f4d570c87e025ee6fca4eae699a8b712 upstream.

If an SRP target is no longer reachable and srp_reset_host() fails to
reconnect then ib_srp will invoke scsi_remove_host().  That function
will invoke __scsi_remove_device() for each LUN.  And that last
function will change the device state from SDEV_TRANSPORT_OFFLINE into
SDEV_CANCEL.  Certain user space software, e.g. older versions of
multipathd, continue queueing I/O to SCSI devices that are in the
SDEV_CANCEL state.

If these I/O requests are submitted as SG_IO that means that the
REQ_PREEMPT flag will be set and hence that these requests will be
passed to srp_queuecommand().  These requests will time out.  If new
requests are queued fast enough from user space these active requests
will prevent __scsi_remove_device() to finish.

Avoid this by failing I/O requests in the SDEV_CANCEL state if the
transport is offline.  Introduce a new variable to keep track of the
transport state instead of failing requests if (!target->connected ||
target->qp_in_error), so that the SCSI error handler has a chance to
retry commands after a transport layer failure occurred.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/ulp/srp/ib_srp.c |    7 +++++++
 drivers/infiniband/ulp/srp/ib_srp.h |    1 +
 2 files changed, 8 insertions(+)

--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -734,6 +734,7 @@ static int srp_reconnect_target(struct s
 
 	scsi_target_unblock(&shost->shost_gendev, ret == 0 ? SDEV_RUNNING :
 			    SDEV_TRANSPORT_OFFLINE);
+	target->transport_offline = !!ret;
 
 	if (ret)
 		goto err;
@@ -1353,6 +1354,12 @@ static int srp_queuecommand(struct Scsi_
 	unsigned long flags;
 	int len;
 
+	if (unlikely(target->transport_offline)) {
+		scmnd->result = DID_NO_CONNECT << 16;
+		scmnd->scsi_done(scmnd);
+		return 0;
+	}
+
 	spin_lock_irqsave(&target->lock, flags);
 	iu = __srp_get_tx_iu(target, SRP_IU_CMD);
 	if (!iu)
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -140,6 +140,7 @@ struct srp_target_port {
 	unsigned int		cmd_sg_cnt;
 	unsigned int		indirect_size;
 	bool			allow_ext_sg;
+	bool			transport_offline;
 
 	/* Everything above this point is used in the hot path of
 	 * command processing. Try to keep them packed into cachelines.


