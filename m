Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036Ab3LKO7W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 09:59:22 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:40310 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866Ab3LKO7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 09:59:18 -0500
From: Ethan Zhao <ethan.kernel@gmail.com>
To: davem@davemloft.net, ipul@chelsio.com
Cc: linux-kernel@vger.kernel.org, Ethan Zhao <ethan.kernel@gmail.com>
Subject: [PATCH] RDMA/cxgb4: replace __GFP_NOFAIL with GFP_ATOMIC
Date: Wed, 11 Dec 2013 22:57:30 +0800
Message-Id: <1386773850-991-1-git-send-email-ethan.kernel@gmail.com>
X-Mailer: git-send-email 1.8.3.4 (Apple Git-47)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In function _c4iw_write_mem_dma_aligned(), alloc_skb() with
GFP_ATOMIC is enough, has failure handling there already assume
it could fail.
change the allocation in del_filter_wr() and set_filter_wr() from
could block forever to nonblocking too. becuase of blocking allocation
might cause deadlock.

Signed-off-by: Ethan Zhao <ethan.kernel@gmail.com>
---
 drivers/infiniband/hw/cxgb4/mem.c               |  2 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c | 19 ++++++++++++++-----
 2 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/mem.c b/drivers/infiniband/hw/cxgb4/mem.c
index 4cb8eb2..ad5b663 100644
--- a/drivers/infiniband/hw/cxgb4/mem.c
+++ b/drivers/infiniband/hw/cxgb4/mem.c
@@ -66,7 +66,7 @@ static int _c4iw_write_mem_dma_aligned(struct c4iw_rdev *rdev, u32 addr,
 		c4iw_init_wr_wait(&wr_wait);
 	wr_len = roundup(sizeof(*req) + sizeof(*sgl), 16);
 
-	skb = alloc_skb(wr_len, GFP_KERNEL | __GFP_NOFAIL);
+	skb = alloc_skb(wr_len, GFP_KERNEL | GFP_ATOMIC);
 	if (!skb)
 		return -ENOMEM;
 	set_wr_txq(skb, CPL_PRIORITY_CONTROL, 0);
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index c73cabd..f2ee8a7 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -1184,15 +1184,15 @@ static int set_filter_wr(struct adapter *adapter, int fidx)
 			return -EAGAIN;
 		if (t4_l2t_set_switching(adapter, f->l2t, f->fs.vlan,
 					f->fs.eport, f->fs.dmac)) {
-			cxgb4_l2t_release(f->l2t);
-			f->l2t = NULL;
-			return -ENOMEM;
+			goto set_filter_nomem;
 		}
 	}
 
 	ftid = adapter->tids.ftid_base + fidx;
 
-	skb = alloc_skb(sizeof(*fwr), GFP_KERNEL | __GFP_NOFAIL);
+	skb = alloc_skb(sizeof(*fwr), GFP_KERNEL | GFP_ATOMIC);
+	if (!skb)
+		goto set_filter_nomem;
 	fwr = (struct fw_filter_wr *)__skb_put(skb, sizeof(*fwr));
 	memset(fwr, 0, sizeof(*fwr));
 
@@ -1276,6 +1276,13 @@ static int set_filter_wr(struct adapter *adapter, int fidx)
 	set_wr_txq(skb, CPL_PRIORITY_CONTROL, f->fs.val.iport & 0x3);
 	t4_ofld_send(adapter, skb);
 	return 0;
+
+set_filter_nomem:
+	if (f->l2t) {
+		cxgb4_l2t_release(f->l2t);
+		f->l2t = NULL;
+	}
+	return -ENOMEM;
 }
 
 /* Delete the filter at a specified index.
@@ -1290,7 +1297,9 @@ static int del_filter_wr(struct adapter *adapter, int fidx)
 	len = sizeof(*fwr);
 	ftid = adapter->tids.ftid_base + fidx;
 
-	skb = alloc_skb(len, GFP_KERNEL | __GFP_NOFAIL);
+	skb = alloc_skb(len, GFP_KERNEL | GFP_ATOMIC);
+	if (!skb)
+		return -ENOMEM;
 	fwr = (struct fw_filter_wr *)__skb_put(skb, len);
 	t4_mk_filtdelwr(ftid, fwr, adapter->sge.fw_evtq.abs_id);
 
-- 
1.8.3.4 (Apple Git-47)

