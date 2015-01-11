Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414AbbAKWan (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 17:30:43 -0500
Received: from mail-we0-f179.google.com ([74.125.82.179]:55128 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029AbbAKWai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 17:30:38 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Steve Wise <swise@chelsio.com>, Roland Dreier <roland@kernel.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] IB: cxgb3: iwch_cm: Remove some unused functions
Date: Sun, 11 Jan 2015 23:33:43 +0100
Message-Id: <1421015623-24924-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes some functions that are not used anywhere:
iwch_resume_tid() iwch_quiesce_tid()

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/infiniband/hw/cxgb3/iwch_cm.c |   42 ---------------------------------
 drivers/infiniband/hw/cxgb3/iwch_cm.h |    2 --
 2 files changed, 44 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb3/iwch_cm.c b/drivers/infiniband/hw/cxgb3/iwch_cm.c
index cb78b1e..ae8ff80 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_cm.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_cm.c
@@ -183,48 +183,6 @@ static void release_tid(struct t3cdev *tdev, u32 hwtid, struct sk_buff *skb)
 	return;
 }
 
-int iwch_quiesce_tid(struct iwch_ep *ep)
-{
-	struct cpl_set_tcb_field *req;
-	struct sk_buff *skb = get_skb(NULL, sizeof(*req), GFP_KERNEL);
-
-	if (!skb)
-		return -ENOMEM;
-	req = (struct cpl_set_tcb_field *) skb_put(skb, sizeof(*req));
-	req->wr.wr_hi = htonl(V_WR_OP(FW_WROPCODE_FORWARD));
-	req->wr.wr_lo = htonl(V_WR_TID(ep->hwtid));
-	OPCODE_TID(req) = htonl(MK_OPCODE_TID(CPL_SET_TCB_FIELD, ep->hwtid));
-	req->reply = 0;
-	req->cpu_idx = 0;
-	req->word = htons(W_TCB_RX_QUIESCE);
-	req->mask = cpu_to_be64(1ULL << S_TCB_RX_QUIESCE);
-	req->val = cpu_to_be64(1 << S_TCB_RX_QUIESCE);
-
-	skb->priority = CPL_PRIORITY_DATA;
-	return iwch_cxgb3_ofld_send(ep->com.tdev, skb);
-}
-
-int iwch_resume_tid(struct iwch_ep *ep)
-{
-	struct cpl_set_tcb_field *req;
-	struct sk_buff *skb = get_skb(NULL, sizeof(*req), GFP_KERNEL);
-
-	if (!skb)
-		return -ENOMEM;
-	req = (struct cpl_set_tcb_field *) skb_put(skb, sizeof(*req));
-	req->wr.wr_hi = htonl(V_WR_OP(FW_WROPCODE_FORWARD));
-	req->wr.wr_lo = htonl(V_WR_TID(ep->hwtid));
-	OPCODE_TID(req) = htonl(MK_OPCODE_TID(CPL_SET_TCB_FIELD, ep->hwtid));
-	req->reply = 0;
-	req->cpu_idx = 0;
-	req->word = htons(W_TCB_RX_QUIESCE);
-	req->mask = cpu_to_be64(1ULL << S_TCB_RX_QUIESCE);
-	req->val = 0;
-
-	skb->priority = CPL_PRIORITY_DATA;
-	return iwch_cxgb3_ofld_send(ep->com.tdev, skb);
-}
-
 static void set_emss(struct iwch_ep *ep, u16 opt)
 {
 	PDBG("%s ep %p opt %u\n", __func__, ep, opt);
diff --git a/drivers/infiniband/hw/cxgb3/iwch_cm.h b/drivers/infiniband/hw/cxgb3/iwch_cm.h
index b9efadf..22e6663 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_cm.h
+++ b/drivers/infiniband/hw/cxgb3/iwch_cm.h
@@ -220,8 +220,6 @@ int iwch_destroy_listen(struct iw_cm_id *cm_id);
 int iwch_reject_cr(struct iw_cm_id *cm_id, const void *pdata, u8 pdata_len);
 int iwch_accept_cr(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param);
 int iwch_ep_disconnect(struct iwch_ep *ep, int abrupt, gfp_t gfp);
-int iwch_quiesce_tid(struct iwch_ep *ep);
-int iwch_resume_tid(struct iwch_ep *ep);
 void __free_ep(struct kref *kref);
 void iwch_rearp(struct iwch_ep *ep);
 int iwch_ep_redirect(void *ctx, struct dst_entry *old, struct dst_entry *new, struct l2t_entry *l2t);
-- 
1.7.10.4

