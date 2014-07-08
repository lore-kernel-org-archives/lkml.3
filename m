Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756617AbaGHT3s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:29:48 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54201 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755708AbaGHTIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:08:40 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Roland Dreier" <roland@purestorage.com>,
        "Bart Van Assche" <bvanassche@acm.org>,
        "Sagi Grimberg" <sagig@mellanox.com>
Date: Tue, 08 Jul 2014 20:01:50 +0100
Message-ID: <lsq.1404846110.291596992@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 008/125] IB/srp: Fix a sporadic crash triggered by
 cable pulling
In-Reply-To: <lsq.1404846109.699842714@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.61-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1353,6 +1353,12 @@ err_unmap:
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
 

