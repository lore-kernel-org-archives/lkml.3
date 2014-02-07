Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247AbaBGLZC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:25:02 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41114 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753167AbaBGLY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:24:56 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ira Weiny <ira.weiny@intel.com>, Roland Dreier <roland@purestorage.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 63/88] IB/qib: Fix QP check when looping back to/from QP1
Date: Fri,  7 Feb 2014 11:23:00 +0000
Message-Id: <1391772205-22239-64-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391772205-22239-1-git-send-email-luis.henriques@canonical.com>
References: <1391772205-22239-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.30 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ira Weiny <ira.weiny@intel.com>

commit 6e0ea9e6cbcead7fa8c76e3e3b9de4a50c5131c5 upstream.

The GSI QP type is compatible with and should be allowed to send data
to/from any UD QP.  This was found when testing ibacm on the same node
as an SA.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/infiniband/hw/qib/qib_ud.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/qib/qib_ud.c b/drivers/infiniband/hw/qib/qib_ud.c
index a468bf2..9c96545 100644
--- a/drivers/infiniband/hw/qib/qib_ud.c
+++ b/drivers/infiniband/hw/qib/qib_ud.c
@@ -57,13 +57,20 @@ static void qib_ud_loopback(struct qib_qp *sqp, struct qib_swqe *swqe)
 	struct qib_sge *sge;
 	struct ib_wc wc;
 	u32 length;
+	enum ib_qp_type sqptype, dqptype;
 
 	qp = qib_lookup_qpn(ibp, swqe->wr.wr.ud.remote_qpn);
 	if (!qp) {
 		ibp->n_pkt_drops++;
 		return;
 	}
-	if (qp->ibqp.qp_type != sqp->ibqp.qp_type ||
+
+	sqptype = sqp->ibqp.qp_type == IB_QPT_GSI ?
+			IB_QPT_UD : sqp->ibqp.qp_type;
+	dqptype = qp->ibqp.qp_type == IB_QPT_GSI ?
+			IB_QPT_UD : qp->ibqp.qp_type;
+
+	if (dqptype != sqptype ||
 	    !(ib_qib_state_ops[qp->state] & QIB_PROCESS_RECV_OK)) {
 		ibp->n_pkt_drops++;
 		goto drop;
-- 
1.8.3.2

