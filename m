Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030493AbaGCKQ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 06:16:26 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51556 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758185AbaGCJVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:21:33 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Bart Van Assche <bvanassche@acm.org>,
        Roland Dreier <roland@purestorage.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 031/198] IB/srp: Fix a sporadic crash triggered by cable pulling
Date: Thu,  3 Jul 2014 10:17:54 +0100
Message-Id: <1404379241-8590-32-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 17b58f4f0681..024fa025a7ab 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1412,6 +1412,12 @@ err_unmap:
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

