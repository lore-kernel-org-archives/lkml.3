Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757939AbaFAMUc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 08:20:32 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:35887 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757829AbaFAMUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 08:20:30 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 25/26] staging: rtl8188eu: Remove unused function nat25_handle_frame()
Date: Sun,  1 Jun 2014 17:46:51 +0530
Message-Id: <1401625013-11208-25-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401625013-11208-1-git-send-email-navin.patidar@gmail.com>
References: <1401625013-11208-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/Makefile             |   32 ++++++-------
 drivers/staging/rtl8188eu/core/rtw_br_ext.c    |   61 ------------------------
 drivers/staging/rtl8188eu/include/recv_osdep.h |    1 -
 3 files changed, 16 insertions(+), 78 deletions(-)

diff --git a/drivers/staging/rtl8188eu/Makefile b/drivers/staging/rtl8188eu/Makefile
index 2ed35a0..450394e 100644
--- a/drivers/staging/rtl8188eu/Makefile
+++ b/drivers/staging/rtl8188eu/Makefile
@@ -1,4 +1,19 @@
 r8188eu-y :=				\
+		hal/rtl8188e_xmit.o	\
+		hal/rtl8188eu_led.o	\
+		hal/rtl8188eu_recv.o	\
+		hal/rtl8188eu_xmit.o	\
+		hal/usb_halinit.o	\
+		hal/usb_ops_linux.o	\
+		os_dep/ioctl_linux.o	\
+		os_dep/mlme_linux.o	\
+		os_dep/os_intfs.o	\
+		os_dep/osdep_service.o	\
+		os_dep/recv_linux.o	\
+		os_dep/rtw_android.o	\
+		os_dep/usb_intf.o	\
+		os_dep/usb_ops_linux.o	\
+		os_dep/xmit_linux.o		\
 		core/rtw_ap.o		\
 		core/rtw_br_ext.o	\
 		core/rtw_cmd.o		\
@@ -42,22 +57,7 @@ r8188eu-y :=				\
 		hal/rtl8188e_mp.o	\
 		hal/rtl8188e_phycfg.o	\
 		hal/rtl8188e_rf6052.o	\
-		hal/rtl8188e_rxdesc.o	\
-		hal/rtl8188e_xmit.o	\
-		hal/rtl8188eu_led.o	\
-		hal/rtl8188eu_recv.o	\
-		hal/rtl8188eu_xmit.o	\
-		hal/usb_halinit.o	\
-		hal/usb_ops_linux.o	\
-		os_dep/ioctl_linux.o	\
-		os_dep/mlme_linux.o	\
-		os_dep/os_intfs.o	\
-		os_dep/osdep_service.o	\
-		os_dep/recv_linux.o	\
-		os_dep/rtw_android.o	\
-		os_dep/usb_intf.o	\
-		os_dep/usb_ops_linux.o	\
-		os_dep/xmit_linux.o
+		hal/rtl8188e_rxdesc.o
 
 obj-$(CONFIG_R8188EU)	:= r8188eu.o
 
diff --git a/drivers/staging/rtl8188eu/core/rtw_br_ext.c b/drivers/staging/rtl8188eu/core/rtw_br_ext.c
index f97f05f..3f602bc 100644
--- a/drivers/staging/rtl8188eu/core/rtw_br_ext.c
+++ b/drivers/staging/rtl8188eu/core/rtw_br_ext.c
@@ -1042,67 +1042,6 @@ int nat25_db_handle(struct adapter *priv, struct sk_buff *skb, int method)
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

