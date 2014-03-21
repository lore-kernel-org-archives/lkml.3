Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760072AbaCUBF6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 21:05:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36763 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965028AbaCUAEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:04:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sagi Grimberg <sagig@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 3.13 093/149] iser-target: Ignore completions for FRWRs in isert_cq_tx_work
Date: Thu, 20 Mar 2014 17:04:16 -0700
Message-Id: <20140321000440.179667186@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000436.377902063@linuxfoundation.org>
References: <20140321000436.377902063@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit 9bb4ca68fc48eea618b1af1c1cde2a251ae32d1b upstream.

This patch changes IB_WR_FAST_REG_MR + IB_WR_LOCAL_INV related
work requests to include a ISER_FRWR_LI_WRID value in order to
signal isert_cq_tx_work() that these requests should be ignored.

This is necessary because even though IB_SEND_SIGNALED is not
set for either work request, during a QP failure event the work
requests will be returned with exception status from the TX
completion queue.

v2 changes:
 - Rename ISER_FRWR_LI_WRID -> ISER_FASTREG_LI_WRID (Sagi)

Acked-by: Sagi Grimberg <sagig@mellanox.com>
Cc: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/ulp/isert/ib_isert.c |    8 ++++++--
 drivers/infiniband/ulp/isert/ib_isert.h |    1 +
 2 files changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -1732,8 +1732,10 @@ isert_cq_tx_work(struct work_struct *wor
 			pr_debug("TX wc.status: 0x%08x\n", wc.status);
 			pr_debug("TX wc.vendor_err: 0x%08x\n", wc.vendor_err);
 
-			atomic_dec(&isert_conn->post_send_buf_count);
-			isert_cq_tx_comp_err(tx_desc, isert_conn);
+			if (wc.wr_id != ISER_FASTREG_LI_WRID) {
+				atomic_dec(&isert_conn->post_send_buf_count);
+				isert_cq_tx_comp_err(tx_desc, isert_conn);
+			}
 		}
 	}
 
@@ -2198,6 +2200,7 @@ isert_fast_reg_mr(struct fast_reg_descri
 
 	if (!fr_desc->valid) {
 		memset(&inv_wr, 0, sizeof(inv_wr));
+		inv_wr.wr_id = ISER_FASTREG_LI_WRID;
 		inv_wr.opcode = IB_WR_LOCAL_INV;
 		inv_wr.ex.invalidate_rkey = fr_desc->data_mr->rkey;
 		wr = &inv_wr;
@@ -2208,6 +2211,7 @@ isert_fast_reg_mr(struct fast_reg_descri
 
 	/* Prepare FASTREG WR */
 	memset(&fr_wr, 0, sizeof(fr_wr));
+	fr_wr.wr_id = ISER_FASTREG_LI_WRID;
 	fr_wr.opcode = IB_WR_FAST_REG_MR;
 	fr_wr.wr.fast_reg.iova_start =
 		fr_desc->data_frpl->page_list[0] + page_off;
--- a/drivers/infiniband/ulp/isert/ib_isert.h
+++ b/drivers/infiniband/ulp/isert/ib_isert.h
@@ -6,6 +6,7 @@
 
 #define ISERT_RDMA_LISTEN_BACKLOG	10
 #define ISCSI_ISER_SG_TABLESIZE		256
+#define ISER_FASTREG_LI_WRID		0xffffffffffffffffULL
 
 enum isert_desc_type {
 	ISCSI_TX_CONTROL,


