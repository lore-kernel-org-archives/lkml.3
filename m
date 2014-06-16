Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558AbaFPQI7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 12:08:59 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:54420 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899AbaFPQGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 12:06:19 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 1/9] staging: rtl8188eu: Remove function rtw_br_client_tx()
Date: Mon, 16 Jun 2014 21:35:38 +0530
Message-Id: <1402934746-29422-2-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1402934746-29422-1-git-send-email-navin.patidar@gmail.com>
References: <1402934746-29422-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rtw_br_client_tx() pass tx packet to functions responsible for
building NAT table.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_xmit.c |  135 -----------------------------
 1 file changed, 135 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_xmit.c b/drivers/staging/rtl8188eu/core/rtw_xmit.c
index 1413ec8..a113f0f 100644
--- a/drivers/staging/rtl8188eu/core/rtw_xmit.c
+++ b/drivers/staging/rtl8188eu/core/rtw_xmit.c
@@ -1676,127 +1676,6 @@ void rtw_init_hwxmits(struct hw_xmit *phwxmit, int entry)
 		phwxmit->accnt = 0;
 }
 
-static int rtw_br_client_tx(struct adapter *padapter, struct sk_buff **pskb)
-{
-	struct sk_buff *skb = *pskb;
-	int res, is_vlan_tag = 0, i, do_nat25 = 1;
-	unsigned short vlan_hdr = 0;
-	void *br_port = NULL;
-
-	rcu_read_lock();
-	br_port = rcu_dereference(padapter->pnetdev->rx_handler_data);
-	rcu_read_unlock();
-	spin_lock_bh(&padapter->br_ext_lock);
-	if (!(skb->data[0] & 1) && br_port &&
-	    memcmp(skb->data+MACADDRLEN, padapter->br_mac, MACADDRLEN) &&
-	    *((__be16 *)(skb->data+MACADDRLEN*2)) != __constant_htons(ETH_P_8021Q) &&
-	    *((__be16 *)(skb->data+MACADDRLEN*2)) == __constant_htons(ETH_P_IP) &&
-	    !memcmp(padapter->scdb_mac, skb->data+MACADDRLEN, MACADDRLEN) && padapter->scdb_entry) {
-		memcpy(skb->data+MACADDRLEN, GET_MY_HWADDR(padapter), MACADDRLEN);
-		padapter->scdb_entry->ageing_timer = jiffies;
-		spin_unlock_bh(&padapter->br_ext_lock);
-	} else {
-		if (*((__be16 *)(skb->data+MACADDRLEN*2)) == __constant_htons(ETH_P_8021Q)) {
-			is_vlan_tag = 1;
-			vlan_hdr = *((unsigned short *)(skb->data+MACADDRLEN*2+2));
-			for (i = 0; i < 6; i++)
-				*((unsigned short *)(skb->data+MACADDRLEN*2+2-i*2)) = *((unsigned short *)(skb->data+MACADDRLEN*2-2-i*2));
-			skb_pull(skb, 4);
-		}
-		if (!memcmp(skb->data+MACADDRLEN, padapter->br_mac, MACADDRLEN) &&
-		    (*((__be16 *)(skb->data+MACADDRLEN*2)) == __constant_htons(ETH_P_IP)))
-			memcpy(padapter->br_ip, skb->data+WLAN_ETHHDR_LEN+12, 4);
-
-		if (*((__be16 *)(skb->data+MACADDRLEN*2)) == __constant_htons(ETH_P_IP)) {
-			if (memcmp(padapter->scdb_mac, skb->data+MACADDRLEN, MACADDRLEN)) {
-				padapter->scdb_entry = (struct nat25_network_db_entry *)scdb_findEntry(padapter,
-							skb->data+MACADDRLEN, skb->data+WLAN_ETHHDR_LEN+12);
-				if (padapter->scdb_entry) {
-					memcpy(padapter->scdb_mac, skb->data+MACADDRLEN, MACADDRLEN);
-					memcpy(padapter->scdb_ip, skb->data+WLAN_ETHHDR_LEN+12, 4);
-					padapter->scdb_entry->ageing_timer = jiffies;
-					do_nat25 = 0;
-				}
-			} else {
-				if (padapter->scdb_entry) {
-					padapter->scdb_entry->ageing_timer = jiffies;
-					do_nat25 = 0;
-				} else {
-					memset(padapter->scdb_mac, 0, MACADDRLEN);
-					memset(padapter->scdb_ip, 0, 4);
-				}
-			}
-		}
-		spin_unlock_bh(&padapter->br_ext_lock);
-		if (do_nat25) {
-			if (nat25_db_handle(padapter, skb, NAT25_CHECK) == 0) {
-				struct sk_buff *newskb;
-
-				if (is_vlan_tag) {
-					skb_push(skb, 4);
-					for (i = 0; i < 6; i++)
-						*((unsigned short *)(skb->data+i*2)) = *((unsigned short *)(skb->data+4+i*2));
-					*((__be16 *)(skb->data+MACADDRLEN*2)) = __constant_htons(ETH_P_8021Q);
-					*((unsigned short *)(skb->data+MACADDRLEN*2+2)) = vlan_hdr;
-				}
-
-				newskb = skb_copy(skb, GFP_ATOMIC);
-				if (newskb == NULL) {
-					DEBUG_ERR("TX DROP: skb_copy fail!\n");
-					return -1;
-				}
-				dev_kfree_skb_any(skb);
-
-				*pskb = skb = newskb;
-				if (is_vlan_tag) {
-					vlan_hdr = *((unsigned short *)(skb->data+MACADDRLEN*2+2));
-					for (i = 0; i < 6; i++)
-						*((unsigned short *)(skb->data+MACADDRLEN*2+2-i*2)) = *((unsigned short *)(skb->data+MACADDRLEN*2-2-i*2));
-					skb_pull(skb, 4);
-				}
-			}
-
-			if (skb_is_nonlinear(skb))
-				DEBUG_ERR("%s(): skb_is_nonlinear!!\n", __func__);
-
-			res = skb_linearize(skb);
-			if (res < 0) {
-					DEBUG_ERR("TX DROP: skb_linearize fail!\n");
-					return -1;
-			}
-
-			res = nat25_db_handle(padapter, skb, NAT25_INSERT);
-			if (res < 0) {
-				if (res == -2) {
-					DEBUG_ERR("TX DROP: nat25_db_handle fail!\n");
-					return -1;
-				}
-				return 0;
-			}
-		}
-
-		memcpy(skb->data+MACADDRLEN, GET_MY_HWADDR(padapter), MACADDRLEN);
-
-		dhcp_flag_bcast(padapter, skb);
-
-		if (is_vlan_tag) {
-			skb_push(skb, 4);
-			for (i = 0; i < 6; i++)
-				*((unsigned short *)(skb->data+i*2)) = *((unsigned short *)(skb->data+4+i*2));
-			*((__be16 *)(skb->data+MACADDRLEN*2)) = __constant_htons(ETH_P_8021Q);
-			*((unsigned short *)(skb->data+MACADDRLEN*2+2)) = vlan_hdr;
-		}
-	}
-
-	/*  check if SA is equal to our MAC */
-	if (memcmp(skb->data+MACADDRLEN, GET_MY_HWADDR(padapter), MACADDRLEN)) {
-		DEBUG_ERR("TX DROP: untransformed frame SA:%02X%02X%02X%02X%02X%02X!\n",
-			  skb->data[6], skb->data[7], skb->data[8], skb->data[9], skb->data[10], skb->data[11]);
-			return -1;
-	}
-	return 0;
-}
-
 u32 rtw_get_ff_hwaddr(struct xmit_frame *pxmitframe)
 {
 	u32 addr;
@@ -1856,8 +1735,6 @@ s32 rtw_xmit(struct adapter *padapter, struct sk_buff **ppkt)
 {
 	struct xmit_priv *pxmitpriv = &padapter->xmitpriv;
 	struct xmit_frame *pxmitframe = NULL;
-	struct mlme_priv	*pmlmepriv = &padapter->mlmepriv;
-	void *br_port = NULL;
 	s32 res;
 
 	pxmitframe = rtw_alloc_xmitframe(pxmitpriv);
@@ -1867,18 +1744,6 @@ s32 rtw_xmit(struct adapter *padapter, struct sk_buff **ppkt)
 		return -1;
 	}
 
-	rcu_read_lock();
-	br_port = rcu_dereference(padapter->pnetdev->rx_handler_data);
-	rcu_read_unlock();
-
-	if (br_port && check_fwstate(pmlmepriv, WIFI_STATION_STATE|WIFI_ADHOC_STATE)) {
-		res = rtw_br_client_tx(padapter, ppkt);
-		if (res == -1) {
-			rtw_free_xmitframe(pxmitpriv, pxmitframe);
-			return -1;
-		}
-	}
-
 	res = update_attrib(padapter, *ppkt, &pxmitframe->attrib);
 
 	if (res == _FAIL) {
-- 
1.7.10.4

