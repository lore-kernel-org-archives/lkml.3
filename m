Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030784AbaGRNOW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:14:22 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17728 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S935023AbaGRNOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:14:17 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Roland Dreier <roland@purestorage.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 030/170] IB/srp: Fix a sporadic crash triggered by cable pulling
Date: Fri, 18 Jul 2014 14:10:35 +0200
Message-Id: <237de203cc2ebaccc8c023fe9e2599bba967941a.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
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
2.0.0

