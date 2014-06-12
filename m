Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932866AbaFLIby (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 04:31:54 -0400
Received: from www.linutronix.de ([62.245.132.108]:38141 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932740AbaFLIbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 04:31:49 -0400
Date: Thu, 12 Jun 2014 10:31:34 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Bing Zhao <bzhao@marvell.com>
cc: LKML <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: [patch V2] wireless: mwifiex: Use the proper interfaces
In-Reply-To: <477F20668A386D41ADCC57781B1F70430FE1F8B507@SC-VEXCH1.marvell.com>
Message-ID: <alpine.DEB.2.10.1406121029530.5170@nanos>
References: <20140611234024.103571777@linutronix.de> <20140611234607.607201623@linutronix.de> <477F20668A386D41ADCC57781B1F70430FE1F8B507@SC-VEXCH1.marvell.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Why is converting time formats so desired if there are proper
interfaces for this?

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Bing Zhao <bzhao@marvell.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
---
 drivers/net/wireless/mwifiex/cfg80211.c |    4 +---
 drivers/net/wireless/mwifiex/main.c     |    4 +---
 drivers/net/wireless/mwifiex/tdls.c     |    8 ++------
 drivers/net/wireless/mwifiex/uap_txrx.c |    4 +---
 drivers/net/wireless/mwifiex/wmm.c      |    9 +--------
 5 files changed, 6 insertions(+), 23 deletions(-)

Index: linux/drivers/net/wireless/mwifiex/cfg80211.c
===================================================================
--- linux.orig/drivers/net/wireless/mwifiex/cfg80211.c
+++ linux/drivers/net/wireless/mwifiex/cfg80211.c
@@ -151,7 +151,6 @@ mwifiex_form_mgmt_frame(struct sk_buff *
 	u8 addr[ETH_ALEN] = {0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF};
 	u16 pkt_len;
 	u32 tx_control = 0, pkt_type = PKT_TYPE_MGMT;
-	struct timeval tv;
 
 	pkt_len = len + ETH_ALEN;
 
@@ -173,8 +172,7 @@ mwifiex_form_mgmt_frame(struct sk_buff *
 	       len - sizeof(struct ieee80211_hdr_3addr));
 
 	skb->priority = LOW_PRIO_TID;
-	do_gettimeofday(&tv);
-	skb->tstamp = timeval_to_ktime(tv);
+	__net_timestamp(skb);
 
 	return 0;
 }
Index: linux/drivers/net/wireless/mwifiex/main.c
===================================================================
--- linux.orig/drivers/net/wireless/mwifiex/main.c
+++ linux/drivers/net/wireless/mwifiex/main.c
@@ -611,7 +611,6 @@ mwifiex_hard_start_xmit(struct sk_buff *
 	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
 	struct sk_buff *new_skb;
 	struct mwifiex_txinfo *tx_info;
-	struct timeval tv;
 
 	dev_dbg(priv->adapter->dev, "data: %lu BSS(%d-%d): Data <= kernel\n",
 		jiffies, priv->bss_type, priv->bss_num);
@@ -658,8 +657,7 @@ mwifiex_hard_start_xmit(struct sk_buff *
 	 * firmware for aggregate delay calculation for stats and
 	 * MSDU lifetime expiry.
 	 */
-	do_gettimeofday(&tv);
-	skb->tstamp = timeval_to_ktime(tv);
+	__net_timestamp(skb);
 
 	mwifiex_queue_tx_pkt(priv, skb);
 
Index: linux/drivers/net/wireless/mwifiex/tdls.c
===================================================================
--- linux.orig/drivers/net/wireless/mwifiex/tdls.c
+++ linux/drivers/net/wireless/mwifiex/tdls.c
@@ -474,7 +474,6 @@ int mwifiex_send_tdls_data_frame(struct
 {
 	struct sk_buff *skb;
 	struct mwifiex_txinfo *tx_info;
-	struct timeval tv;
 	int ret;
 	u16 skb_len;
 
@@ -552,8 +551,7 @@ int mwifiex_send_tdls_data_frame(struct
 	tx_info->bss_num = priv->bss_num;
 	tx_info->bss_type = priv->bss_type;
 
-	do_gettimeofday(&tv);
-	skb->tstamp = timeval_to_ktime(tv);
+	__net_timestamp(skb);
 	mwifiex_queue_tx_pkt(priv, skb);
 
 	return 0;
@@ -645,7 +643,6 @@ int mwifiex_send_tdls_action_frame(struc
 {
 	struct sk_buff *skb;
 	struct mwifiex_txinfo *tx_info;
-	struct timeval tv;
 	u8 *pos;
 	u32 pkt_type, tx_control;
 	u16 pkt_len, skb_len;
@@ -710,8 +707,7 @@ int mwifiex_send_tdls_action_frame(struc
 	pkt_len = skb->len - MWIFIEX_MGMT_FRAME_HEADER_SIZE - sizeof(pkt_len);
 	memcpy(skb->data + MWIFIEX_MGMT_FRAME_HEADER_SIZE, &pkt_len,
 	       sizeof(pkt_len));
-	do_gettimeofday(&tv);
-	skb->tstamp = timeval_to_ktime(tv);
+	__net_timestamp(skb);
 	mwifiex_queue_tx_pkt(priv, skb);
 
 	return 0;
Index: linux/drivers/net/wireless/mwifiex/uap_txrx.c
===================================================================
--- linux.orig/drivers/net/wireless/mwifiex/uap_txrx.c
+++ linux/drivers/net/wireless/mwifiex/uap_txrx.c
@@ -96,7 +96,6 @@ static void mwifiex_uap_queue_bridged_pk
 	struct sk_buff *new_skb;
 	struct mwifiex_txinfo *tx_info;
 	int hdr_chop;
-	struct timeval tv;
 	struct ethhdr *p_ethhdr;
 
 	uap_rx_pd = (struct uap_rxpd *)(skb->data);
@@ -192,8 +191,7 @@ static void mwifiex_uap_queue_bridged_pk
 		tx_info->pkt_len = skb->len;
 	}
 
-	do_gettimeofday(&tv);
-	skb->tstamp = timeval_to_ktime(tv);
+	__net_timestamp(skb);
 	mwifiex_wmm_add_buf_txqueue(priv, skb);
 	atomic_inc(&adapter->tx_pending);
 	atomic_inc(&adapter->pending_bridged_pkts);
Index: linux/drivers/net/wireless/mwifiex/wmm.c
===================================================================
--- linux.orig/drivers/net/wireless/mwifiex/wmm.c
+++ linux/drivers/net/wireless/mwifiex/wmm.c
@@ -886,15 +886,8 @@ u8
 mwifiex_wmm_compute_drv_pkt_delay(struct mwifiex_private *priv,
 				  const struct sk_buff *skb)
 {
+	u32 queue_delay = ktime_to_ms(net_timedelta(skb->tstamp));
 	u8 ret_val;
-	struct timeval out_tstamp, in_tstamp;
-	u32 queue_delay;
-
-	do_gettimeofday(&out_tstamp);
-	in_tstamp = ktime_to_timeval(skb->tstamp);
-
-	queue_delay = (out_tstamp.tv_sec - in_tstamp.tv_sec) * 1000;
-	queue_delay += (out_tstamp.tv_usec - in_tstamp.tv_usec) / 1000;
 
 	/*
 	 * Queue delay is passed as a uint8 in units of 2ms (ms shifted
