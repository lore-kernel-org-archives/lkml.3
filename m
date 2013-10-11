Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758664Ab3JKUYz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 16:24:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45875 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932080Ab3JKTkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:40:36 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dmitry Khromov <icechrome@gmail.com>,
        Amitkumar Karwar <akarwar@marvell.com>, Bing Zhao <bzhao@marvell.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 081/110] mwifiex: fix hang issue for USB chipsets
Date: Fri, 11 Oct 2013 12:39:01 -0700
Message-Id: <20131011193816.649620821@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193807.584188672@linuxfoundation.org>
References: <20131011193807.584188672@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/mwifiex/11n_aggr.c |    3 ++-
 drivers/net/wireless/mwifiex/11n_aggr.h |    2 +-
 drivers/net/wireless/mwifiex/wmm.c      |    3 +--
 3 files changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/net/wireless/mwifiex/11n_aggr.c
+++ b/drivers/net/wireless/mwifiex/11n_aggr.c
@@ -149,7 +149,7 @@ mwifiex_11n_form_amsdu_txpd(struct mwifi
  */
 int
 mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
-			  struct mwifiex_ra_list_tbl *pra_list, int headroom,
+			  struct mwifiex_ra_list_tbl *pra_list,
 			  int ptrindex, unsigned long ra_list_flags)
 			  __releases(&priv->wmm.ra_list_spinlock)
 {
@@ -159,6 +159,7 @@ mwifiex_11n_aggregate_pkt(struct mwifiex
 	int pad = 0, ret;
 	struct mwifiex_tx_param tx_param;
 	struct txpd *ptx_pd = NULL;
+	int headroom = adapter->iface_type == MWIFIEX_USB ? 0 : INTF_HEADER_LEN;
 
 	skb_src = skb_peek(&pra_list->skb_head);
 	if (!skb_src) {
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
 
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -1236,8 +1236,7 @@ mwifiex_dequeue_tx_packet(struct mwifiex
 		if (mwifiex_is_amsdu_allowed(priv, tid) &&
 		    mwifiex_is_11n_aggragation_possible(priv, ptr,
 							adapter->tx_buf_size))
-			mwifiex_11n_aggregate_pkt(priv, ptr, INTF_HEADER_LEN,
-						  ptr_index, flags);
+			mwifiex_11n_aggregate_pkt(priv, ptr, ptr_index, flags);
 			/* ra_list_spinlock has been freed in
 			   mwifiex_11n_aggregate_pkt() */
 		else


