Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031643AbaGDWfJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 18:35:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57575 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031358AbaGDWVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 18:21:44 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sagi Grimberg <sagig@mellanox.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Roland Dreier <roland@purestorage.com>
Subject: [PATCH 3.10 19/46] IB/srp: Fix a sporadic crash triggered by cable pulling
Date: Fri,  4 Jul 2014 15:19:23 -0700
Message-Id: <20140704221603.146008976@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140704221602.280733370@linuxfoundation.org>
References: <20140704221602.280733370@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

commit 024ca90151f5e4296d30f72c13ff9a075e23c9ec upstream.

Avoid that the loops that iterate over the request ring can encounter
a pointer to a SCSI command in req->scmnd that is no longer associated
with that request. If the function srp_unmap_data() is invoked twice
for a SCSI command that is not in flight then that would cause
ib_fmr_pool_unmap() to be invoked with an invalid pointer as argument,
resulting in a kernel oops.

Reported-by: Sagi Grimberg <sagig@mellanox.com>
Reference: http://thread.gmane.org/gmane.linux.drivers.rdma/19068/focus=19069
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Sagi Grimberg <sagig@mellanox.com>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/ulp/srp/ib_srp.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1409,6 +1409,12 @@ err_unmap:
 err_iu:
 	srp_put_tx_iu(target, iu, SRP_IU_CMD);
 
+	/*
+	 * Avoid that the loops that iterate over the request ring can
+	 * encounter a dangling SCSI command pointer.
+	 */
+	req->scmnd = NULL;
+
 	spin_lock_irqsave(&target->lock, flags);
 	list_add(&req->list, &target->free_reqs);
 


