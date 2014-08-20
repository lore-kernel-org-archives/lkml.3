Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268AbaHTLvd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 07:51:33 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59023 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752616AbaHTLoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 07:44:11 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Roland Dreier <roland@purestorage.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 093/104] RDMA/cxgb3: Fix information leak in send_abort()
Date: Wed, 20 Aug 2014 13:43:56 +0200
Message-Id: <066c1c484969b9a151d2c5e39f61f1829f65fe22.1408535000.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
References: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
In-Reply-To: <cover.1408535000.git.jslaby@suse.cz>
References: <cover.1408535000.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit e4514cbd972786af67dd6c442c072685387e22a2 upstream.

The cpl_abort_req struct has several reserved members which need to be
cleared to avoid disclosing kernel information.  I have added a memset()
so now it matches the cxgb4 version of this function.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Steve Wise <swise@opengridcomputing.com>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/infiniband/hw/cxgb3/iwch_cm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/cxgb3/iwch_cm.c b/drivers/infiniband/hw/cxgb3/iwch_cm.c
index 095bb046e2c8..cb78b1e9bcd9 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_cm.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_cm.c
@@ -418,6 +418,7 @@ static int send_abort(struct iwch_ep *ep, struct sk_buff *skb, gfp_t gfp)
 	skb->priority = CPL_PRIORITY_DATA;
 	set_arp_failure_handler(skb, abort_arp_failure);
 	req = (struct cpl_abort_req *) skb_put(skb, sizeof(*req));
+	memset(req, 0, sizeof(*req));
 	req->wr.wr_hi = htonl(V_WR_OP(FW_WROPCODE_OFLD_HOST_ABORT_CON_REQ));
 	req->wr.wr_lo = htonl(V_WR_TID(ep->hwtid));
 	OPCODE_TID(req) = htonl(MK_OPCODE_TID(CPL_ABORT_REQ, ep->hwtid));
-- 
2.0.4

