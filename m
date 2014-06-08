Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477AbaFHOFG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 10:05:06 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:39439 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187AbaFHOFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 10:05:04 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH v2 25/26] staging: rtl8188eu: Remove unused function nat25_handle_frame()
Date: Sun,  8 Jun 2014 19:34:33 +0530
Message-Id: <1402236273-16240-1-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401625013-11208-25-git-send-email-navin.patidar@gmail.com>
References: <1401625013-11208-25-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
V2:
Restore sequence of source code compilation, sequence was changed by v1
of this patch.

 drivers/staging/rtl8188eu/core/rtw_br_ext.c    |   61 ------------------------
 drivers/staging/rtl8188eu/include/recv_osdep.h |    1 -
 2 files changed, 62 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_br_ext.c b/drivers/staging/rtl8188eu/core/rtw_br_ext.c
index 9d9e89a..70b8f07 100644
--- a/drivers/staging/rtl8188eu/core/rtw_br_ext.c
+++ b/drivers/staging/rtl8188eu/core/rtw_br_ext.c
@@ -1030,67 +1030,6 @@ int nat25_db_handle(struct adapter *priv, struct sk_buff *skb, int method)
 	return -1;
 }

-int nat25_handle_frame(struct adapter *priv, struct sk_buff *skb)
-{
-	if (!(skb->data[0] & 1)) {
-		int is_vlan_tag = 0, i, retval = 0;
-		unsigned short vlan_hdr = 0;
-		unsigned short protocol;
-
-		protocol = be16_to_cpu(*((__be16 *)(skb->data + 2 * ETH_ALEN)));
-		if (protocol == ETH_P_8021Q) {
-			is_vlan_tag = 1;
-			vlan_hdr = *((unsigned short *)(skb->data+ETH_ALEN*2+2));
-			for (i = 0; i < 6; i++)
-				*((unsigned short *)(skb->data+ETH_ALEN*2+2-i*2)) = *((unsigned short *)(skb->data+ETH_ALEN*2-2-i*2));
-			skb_pull(skb, 4);
-		}
-
-		if (!priv->ethBrExtInfo.nat25_disable) {
-			spin_lock_bh(&priv->br_ext_lock);
-			/*
-			 *	This function look up the destination network address from
-			 *	the NAT2.5 database. Return value = -1 means that the
-			 *	corresponding network protocol is NOT support.
-			 */
-			if (!priv->ethBrExtInfo.nat25sc_disable &&
-			    (be16_to_cpu(*((__be16 *)(skb->data+ETH_ALEN*2))) == ETH_P_IP) &&
-			    !memcmp(priv->scdb_ip, skb->data+ETH_HLEN+16, 4)) {
-				memcpy(skb->data, priv->scdb_mac, ETH_ALEN);
-
-				spin_unlock_bh(&priv->br_ext_lock);
-			} else {
-				spin_unlock_bh(&priv->br_ext_lock);
-
-				retval = nat25_db_handle(priv, skb, NAT25_LOOKUP);
-			}
-		} else {
-			if (((be16_to_cpu(*((__be16 *)(skb->data+ETH_ALEN*2))) == ETH_P_IP) &&
-			    !memcmp(priv->br_ip, skb->data+ETH_HLEN+16, 4)) ||
-			    ((be16_to_cpu(*((__be16 *)(skb->data+ETH_ALEN*2))) == ETH_P_ARP) &&
-			    !memcmp(priv->br_ip, skb->data+ETH_HLEN+24, 4))) {
-				/*  for traffic to upper TCP/IP */
-				retval = nat25_db_handle(priv, skb, NAT25_LOOKUP);
-			}
-		}
-
-		if (is_vlan_tag) {
-			skb_push(skb, 4);
-			for (i = 0; i < 6; i++)
-				*((unsigned short *)(skb->data+i*2)) = *((unsigned short *)(skb->data+4+i*2));
-			*((__be16 *)(skb->data+ETH_ALEN*2)) = __constant_htons(ETH_P_8021Q);
-			*((unsigned short *)(skb->data+ETH_ALEN*2+2)) = vlan_hdr;
-		}
-
-		if (retval == -1) {
-			/* DEBUG_ERR("NAT25: Lookup fail!\n"); */
-			return -1;
-		}
-	}
-
-	return 0;
-}
-
 #define SERVER_PORT			67
 #define CLIENT_PORT			68
 #define DHCP_MAGIC			0x63825363
diff --git a/drivers/staging/rtl8188eu/include/recv_osdep.h b/drivers/staging/rtl8188eu/include/recv_osdep.h
index a4fd957..a52a696 100644
--- a/drivers/staging/rtl8188eu/include/recv_osdep.h
+++ b/drivers/staging/rtl8188eu/include/recv_osdep.h
@@ -46,7 +46,6 @@ int rtw_os_recvbuf_resource_alloc(struct adapter *adapt, struct recv_buf *buf);
 void rtw_os_read_port(struct adapter *padapter, struct recv_buf *precvbuf);

 void rtw_init_recv_timer(struct recv_reorder_ctrl *preorder_ctrl);
-int nat25_handle_frame(struct adapter *priv, struct sk_buff *skb);
 int _netdev_open(struct net_device *pnetdev);
 int netdev_open(struct net_device *pnetdev);
 int netdev_close(struct net_device *pnetdev);
--
1.7.10.4

