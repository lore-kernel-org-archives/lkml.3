Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751594AbaEQVoI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 17:44:08 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:51185 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452AbaEQVoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 17:44:06 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Roland Dreier <roland@kernel.org>
Cc: Peter Senna Tschudin <peter.senna@gmail.com>,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        dan.carpenter@oracle.com
Subject: [PATCH 4/4 V2] IB: Remove redundant error check
Date: Sat, 17 May 2014 23:43:42 +0200
Message-Id: <1400363022-7632-1-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove double checks, and move calls to pr_err and printk to the
first check. The simplified version of the coccinelle semantic
patch that fixes this issue is as follows:

// <smpl>
@@
expression E; identifier pr; expression list es;
@@
for(...;...;...){
...
-	if (E) break;
+	if (E){
+		pr(es);
+		break;
+	}
...
}
- if(E) pr(es);
// </smpl>

Tested by compilation only.

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

---
Changes from V1:
 - Replaced break with a return
 - On success return 0 instead of status

 drivers/infiniband/hw/ocrdma/ocrdma_hw.c |    6 +++---
 drivers/infiniband/ulp/srpt/ib_srpt.c    |    8 ++++----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index 3bbf201..62c2230 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -1839,13 +1839,13 @@ int ocrdma_reg_mr(struct ocrdma_dev *dev,
 
 		status = ocrdma_mbx_reg_mr_cont(dev, hwmr, cur_pbl_cnt,
 						pbl_offset, last);
-		if (status)
-			break;
+		if (status) {
+			pr_err("%s() err. status=%d\n", __func__, status);
+			return status;
+		}
 	}
-	if (status)
-		pr_err("%s() err. status=%d\n", __func__, status);
 
-	return status;
+	return 0;
 }
 
 bool ocrdma_is_qp_in_sq_flushlist(struct ocrdma_cq *cq, struct ocrdma_qp *qp)
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index fe09f27..ab23b07 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -2875,13 +2875,13 @@ static int srpt_perform_rdmas(struct srpt_rdma_ch *ch,
 			wr.send_flags = IB_SEND_SIGNALED;
 
 		ret = ib_post_send(ch->qp, &wr, &bad_wr);
-		if (ret)
+		if (ret) {
+			printk(KERN_ERR "%s[%d]: ib_post_send() returned %d for %d/%d",
+			       __func__, __LINE__, ret, i, n_rdma);
 			break;
+		}
 	}
 
-	if (ret)
-		printk(KERN_ERR "%s[%d]: ib_post_send() returned %d for %d/%d",
-				 __func__, __LINE__, ret, i, n_rdma);
 	if (ret && i > 0) {
 		wr.num_sge = 0;
 		wr.wr_id = encode_wr_id(SRPT_RDMA_ABORT, ioctx->ioctx.index);

