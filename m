Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757414Ab3BANJ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 08:09:58 -0500
Received: from mail.kernel.org ([198.145.19.201]:44648 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757123Ab3BANJx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 08:09:53 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Arend van Spriel <arend@broadcom.com>,
        Pieter-Paul Giesberts <pieterpg@broadcom.com>,
        Piotr Haber <phaber@broadcom.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 30/89] brcmsmac: handle packet drop during transmit correctly
Date: Fri,  1 Feb 2013 14:07:45 +0100
Message-Id: <20130201130209.670399586@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130201130207.444989281@linuxfoundation.org>
References: <20130201130207.444989281@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Piotr Haber <phaber@broadcom.com>

commit c4dea35e34f5f46e1701156153a09cce429d1ea9 upstream.

The .tx() callback function can drop packets when there is no
space in the DMA fifo. Propagate that information to caller
and make sure the freed sk_buff reference is not accessed.

Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Piotr Haber <phaber@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c |    4 ++--
 drivers/net/wireless/brcm80211/brcmsmac/main.c        |   14 +++++++++-----
 drivers/net/wireless/brcm80211/brcmsmac/main.h        |    2 +-
 drivers/net/wireless/brcm80211/brcmsmac/pub.h         |    2 +-
 4 files changed, 13 insertions(+), 9 deletions(-)

--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
@@ -280,8 +280,8 @@ static void brcms_ops_tx(struct ieee8021
 		kfree_skb(skb);
 		goto done;
 	}
-	brcms_c_sendpkt_mac80211(wl->wlc, skb, hw);
-	tx_info->rate_driver_data[0] = control->sta;
+	if (brcms_c_sendpkt_mac80211(wl->wlc, skb, hw))
+		tx_info->rate_driver_data[0] = control->sta;
  done:
 	spin_unlock_bh(&wl->lock);
 }
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -6095,7 +6095,7 @@ static bool brcms_c_prec_enq(struct brcm
 	return brcms_c_prec_enq_head(wlc, q, pkt, prec, false);
 }
 
-void brcms_c_txq_enq(struct brcms_c_info *wlc, struct scb *scb,
+bool brcms_c_txq_enq(struct brcms_c_info *wlc, struct scb *scb,
 		     struct sk_buff *sdu, uint prec)
 {
 	struct brcms_txq_info *qi = wlc->pkt_queue;	/* Check me */
@@ -6110,7 +6110,9 @@ void brcms_c_txq_enq(struct brcms_c_info
 		 * packet flooding from mac80211 stack
 		 */
 		brcmu_pkt_buf_free_skb(sdu);
+		return false;
 	}
+	return true;
 }
 
 /*
@@ -7273,7 +7275,7 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_
 	return 0;
 }
 
-void brcms_c_sendpkt_mac80211(struct brcms_c_info *wlc, struct sk_buff *sdu,
+bool brcms_c_sendpkt_mac80211(struct brcms_c_info *wlc, struct sk_buff *sdu,
 			      struct ieee80211_hw *hw)
 {
 	u8 prio;
@@ -7288,10 +7290,12 @@ void brcms_c_sendpkt_mac80211(struct brc
 	prio = ieee80211_is_data(d11_header->frame_control) ? sdu->priority :
 		MAXPRIO;
 	fifo = prio2fifo[prio];
-	if (brcms_c_d11hdrs_mac80211(wlc, hw, sdu, scb, 0, 1, fifo, 0))
-		return;
-	brcms_c_txq_enq(wlc, scb, sdu, BRCMS_PRIO_TO_PREC(prio));
+	brcms_c_d11hdrs_mac80211(wlc, hw, sdu, scb, 0, 1, fifo, 0);
+	if (!brcms_c_txq_enq(wlc, scb, sdu, BRCMS_PRIO_TO_PREC(prio)))
+		return false;
 	brcms_c_send_q(wlc);
+
+	return true;
 }
 
 void brcms_c_send_q(struct brcms_c_info *wlc)
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.h
@@ -642,7 +642,7 @@ extern void brcms_c_txfifo(struct brcms_
 			   bool commit, s8 txpktpend);
 extern void brcms_c_txfifo_complete(struct brcms_c_info *wlc, uint fifo,
 				    s8 txpktpend);
-extern void brcms_c_txq_enq(struct brcms_c_info *wlc, struct scb *scb,
+extern bool brcms_c_txq_enq(struct brcms_c_info *wlc, struct scb *scb,
 			    struct sk_buff *sdu, uint prec);
 extern void brcms_c_print_txstatus(struct tx_status *txs);
 extern int brcms_b_xmtfifo_sz_get(struct brcms_hardware *wlc_hw, uint fifo,
--- a/drivers/net/wireless/brcm80211/brcmsmac/pub.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/pub.h
@@ -321,7 +321,7 @@ extern void brcms_c_intrsrestore(struct
 extern bool brcms_c_intrsupd(struct brcms_c_info *wlc);
 extern bool brcms_c_isr(struct brcms_c_info *wlc, bool *wantdpc);
 extern bool brcms_c_dpc(struct brcms_c_info *wlc, bool bounded);
-extern void brcms_c_sendpkt_mac80211(struct brcms_c_info *wlc,
+extern bool brcms_c_sendpkt_mac80211(struct brcms_c_info *wlc,
 				     struct sk_buff *sdu,
 				     struct ieee80211_hw *hw);
 extern bool brcms_c_aggregatable(struct brcms_c_info *wlc, u8 tid);


