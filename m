Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448AbaFLAAK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 20:00:10 -0400
Received: from www.linutronix.de ([62.245.132.108]:36077 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755267AbaFKX7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 19:59:42 -0400
Message-Id: <20140611234607.683770899@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 11 Jun 2014 23:59:18 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org
Subject: [patch 12/13] net: mac80211: Remove silly timespec dance
References: <20140611234024.103571777@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline;
 filename=net-max80211-remove-silly-timespec-dance.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Converting time from one format to another seems to give coders a warm
and fuzzy feeling.

Use the proper interfaces.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
---
 net/mac80211/status.c |    7 ++-----
 net/mac80211/tx.c     |    5 +----
 2 files changed, 3 insertions(+), 9 deletions(-)

Index: linux/net/mac80211/status.c
===================================================================
--- linux.orig/net/mac80211/status.c
+++ linux/net/mac80211/status.c
@@ -473,8 +473,6 @@ static void ieee80211_tx_latency_end_msr
 					    struct sta_info *sta,
 					    struct ieee80211_hdr *hdr)
 {
-	ktime_t skb_dprt;
-	struct timespec dprt_time;
 	u32 msrmnt;
 	u16 tid;
 	u8 *qc;
@@ -506,9 +504,8 @@ static void ieee80211_tx_latency_end_msr
 
 	tx_lat = &sta->tx_lat[tid];
 
-	ktime_get_ts(&dprt_time); /* time stamp completion time */
-	skb_dprt = ktime_set(dprt_time.tv_sec, dprt_time.tv_nsec);
-	msrmnt = ktime_to_ms(ktime_sub(skb_dprt, skb_arv));
+	/* Calculate the latency */
+	msrmnt = ktime_to_ms(net_timedelta(skb_arv));
 
 	if (tx_lat->max < msrmnt) /* update stats */
 		tx_lat->max = msrmnt;
Index: linux/net/mac80211/tx.c
===================================================================
--- linux.orig/net/mac80211/tx.c
+++ linux/net/mac80211/tx.c
@@ -1767,15 +1767,12 @@ fail:
 static void ieee80211_tx_latency_start_msrmnt(struct ieee80211_local *local,
 					      struct sk_buff *skb)
 {
-	struct timespec skb_arv;
 	struct ieee80211_tx_latency_bin_ranges *tx_latency;
 
 	tx_latency = rcu_dereference(local->tx_latency);
 	if (!tx_latency)
 		return;
-
-	ktime_get_ts(&skb_arv);
-	skb->tstamp = ktime_set(skb_arv.tv_sec, skb_arv.tv_nsec);
+	__net_timestamp(skb);
 }
 
 /**


