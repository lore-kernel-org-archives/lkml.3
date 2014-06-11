Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408AbaFKX7p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 19:59:45 -0400
Received: from www.linutronix.de ([62.245.132.108]:36078 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755306AbaFKX7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 19:59:43 -0400
Message-Id: <20140611234607.607201623@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 11 Jun 2014 23:59:18 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Bing Zhao <bzhao@marvell.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org
Subject: [patch 11/13] wireless: mwifiex: Use the proper interfaces
References: <20140611234024.103571777@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=wireless-use-ktime-get-wtf.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Why is converting time formats so desired if there are proper
interfaces for this?

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Bing Zhao <bzhao@marvell.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
---
 drivers/net/wireless/mwifiex/cfg80211.c |    4 +---
 drivers/net/wireless/mwifiex/main.c     |    4 +---
 drivers/net/wireless/mwifiex/tdls.c     |    6 ++----
 drivers/net/wireless/mwifiex/uap_txrx.c |    4 +---
 drivers/net/wireless/mwifiex/wmm.c      |    9 +--------
 5 files changed, 6 insertions(+), 21 deletions(-)

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
@@ -552,8 +552,7 @@ int mwifiex_send_tdls_data_frame(struct
 	tx_info->bss_num = priv->bss_num;
 	tx_info->bss_type = priv->bss_type;
 
-	do_gettimeofday(&tv);
-	skb->tstamp = timeval_to_ktime(tv);
+	__net_timestamp(skb);
 	mwifiex_queue_tx_pkt(priv, skb);
 
 	return 0;
@@ -710,8 +709,7 @@ int mwifiex_send_tdls_action_frame(struc
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


