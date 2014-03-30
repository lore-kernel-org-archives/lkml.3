Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176AbaCaAGQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 20:06:16 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37332 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754377AbaC3Xms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:42:48 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Roland Dreier" <roland@purestorage.com>,
        "Ira Weiny" <ira.weiny@intel.com>,
        "Mike Marciniszyn" <mike.marciniszyn@intel.com>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.525516962@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 051/200] IB/qib: Fix QP check when looping back
 to/from QP1
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Ira Weiny <ira.weiny@intel.com>

commit 6e0ea9e6cbcead7fa8c76e3e3b9de4a50c5131c5 upstream.

The GSI QP type is compatible with and should be allowed to send data
to/from any UD QP.  This was found when testing ibacm on the same node
as an SA.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/infiniband/hw/qib/qib_ud.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/infiniband/hw/qib/qib_ud.c
+++ b/drivers/infiniband/hw/qib/qib_ud.c
@@ -57,13 +57,20 @@ static void qib_ud_loopback(struct qib_q
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

