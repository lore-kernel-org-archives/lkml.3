Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110AbaBKVCp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 16:02:45 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39570 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587AbaBKTFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:05:09 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Ira Weiny <ira.weiny@intel.com>,
        Roland Dreier <roland@purestorage.com>
Subject: [PATCH 3.13 037/120] IB/qib: Fix QP check when looping back to/from QP1
Date: Tue, 11 Feb 2014 11:04:38 -0800
Message-Id: <20140211184824.639570910@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140211184823.492407127@linuxfoundation.org>
References: <20140211184823.492407127@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ira Weiny <ira.weiny@intel.com>

commit 6e0ea9e6cbcead7fa8c76e3e3b9de4a50c5131c5 upstream.

The GSI QP type is compatible with and should be allowed to send data
to/from any UD QP.  This was found when testing ibacm on the same node
as an SA.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/qib/qib_ud.c |    9 ++++++++-
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


