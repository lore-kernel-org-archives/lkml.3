Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816Ab3JJPrU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 11:47:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52773 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755263Ab3JJPrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:47:16 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Amitkumar Karwar <akarwar@marvell.com>, Bing Zhao <bzhao@marvell.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 088/104] mwifiex: fix hang issue for USB chipsets
Date: Thu, 10 Oct 2013 08:42:16 -0700
Message-Id: <1381419752-29733-89-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381419752-29733-1-git-send-email-kamal@canonical.com>
References: <1381419752-29733-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amitkumar Karwar <akarwar@marvell.com>

commit bd1c6142edce787b8ac1be15635f845aa9905333 upstream.

Bug 60815 - Interface hangs in mwifiex_usb
https://bugzilla.kernel.org/show_bug.cgi?id=60815

We have 4 bytes of interface header for packets delivered to SDIO
and PCIe, but not for USB interface.

In Tx AMSDU case, currently 4 bytes of garbage data is unnecessarily
appended for USB packets. This sometimes leads to a firmware hang,
because it may not interpret the data packet correctly.

Problem is fixed by removing this redundant headroom for USB.

Tested-by: Dmitry Khromov <icechrome@gmail.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/wireless/mwifiex/11n_aggr.c | 3 ++-
 drivers/net/wireless/mwifiex/11n_aggr.h | 2 +-
 drivers/net/wireless/mwifiex/wmm.c      | 3 +--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n_aggr.c b/drivers/net/wireless/mwifiex/11n_aggr.c
index 68d52cf..167681a 100644
--- a/drivers/net/wireless/mwifiex/11n_aggr.c
+++ b/drivers/net/wireless/mwifiex/11n_aggr.c
@@ -149,7 +149,7 @@ mwifiex_11n_form_amsdu_txpd(struct mwifiex_private *priv,
  */
 int
 mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
-			  struct mwifiex_ra_list_tbl *pra_list, int headroom,
+			  struct mwifiex_ra_list_tbl *pra_list,
 			  int ptrindex, unsigned long ra_list_flags)
 			  __releases(&priv->wmm.ra_list_spinlock)
 {
@@ -159,6 +159,7 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 	int pad = 0, ret;
 	struct mwifiex_tx_param tx_param;
 	struct txpd *ptx_pd = NULL;
+	int headroom = adapter->iface_type == MWIFIEX_USB ? 0 : INTF_HEADER_LEN;
 
 	skb_src = skb_peek(&pra_list->skb_head);
 	if (!skb_src) {
diff --git a/drivers/net/wireless/mwifiex/11n_aggr.h b/drivers/net/wireless/mwifiex/11n_aggr.h
index 900e1c6..892098d 100644
--- a/drivers/net/wireless/mwifiex/11n_aggr.h
+++ b/drivers/net/wireless/mwifiex/11n_aggr.h
@@ -26,7 +26,7 @@
 int mwifiex_11n_deaggregate_pkt(struct mwifiex_private *priv,
 				struct sk_buff *skb);
 int mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
-			      struct mwifiex_ra_list_tbl *ptr, int headroom,
+			      struct mwifiex_ra_list_tbl *ptr,
 			      int ptr_index, unsigned long flags)
 			      __releases(&priv->wmm.ra_list_spinlock);
 
diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index 818f871..e59e575 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -1295,8 +1295,7 @@ mwifiex_dequeue_tx_packet(struct mwifiex_adapter *adapter)
 		if (mwifiex_is_amsdu_allowed(priv, tid) &&
 		    mwifiex_is_11n_aggragation_possible(priv, ptr,
 							adapter->tx_buf_size))
-			mwifiex_11n_aggregate_pkt(priv, ptr, INTF_HEADER_LEN,
-						  ptr_index, flags);
+			mwifiex_11n_aggregate_pkt(priv, ptr, ptr_index, flags);
 			/* ra_list_spinlock has been freed in
 			   mwifiex_11n_aggregate_pkt() */
 		else
-- 
1.8.1.2

