Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759786AbaGOVz3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 17:55:29 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54822 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759602AbaGOViP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:38:15 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Bart Van Assche <bvanassche@acm.org>,
        Roland Dreier <roland@purestorage.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 040/198] IB/srp: Fix a sporadic crash triggered by cable pulling
Date: Tue, 15 Jul 2014 14:28:30 -0700
Message-Id: <1405459868-15089-41-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405459868-15089-1-git-send-email-kamal@canonical.com>
References: <1405459868-15089-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.5 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index a886319..c74d8b6 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1575,6 +1575,12 @@ err_unmap:
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
 
-- 
1.9.1

