Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932297AbaFPQHF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 12:07:05 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:43147 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932284AbaFPQHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 12:07:02 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 6/9] staging: rtl8188eu: Remove function netdev_br_init()
Date: Mon, 16 Jun 2014 21:35:43 +0530
Message-Id: <1402934746-29422-7-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1402934746-29422-1-git-send-email-navin.patidar@gmail.com>
References: <1402934746-29422-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

netdev_br_init() tries to find MAC address of network interface named "br0",
then that MAC address is assigned to adapter->br_netdev and used by driver's
NAT implementation code.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/include/usb_osintf.h |    1 -
 drivers/staging/rtl8188eu/os_dep/os_intfs.c    |   28 ------------------------
 2 files changed, 29 deletions(-)

diff --git a/drivers/staging/rtl8188eu/include/usb_osintf.h b/drivers/staging/rtl8188eu/include/usb_osintf.h
index 484411f..85805ca 100644
--- a/drivers/staging/rtl8188eu/include/usb_osintf.h
+++ b/drivers/staging/rtl8188eu/include/usb_osintf.h
@@ -29,7 +29,6 @@ extern int rtw_mc2u_disable;
 #define USBD_HALTED(Status) ((u32)(Status) >> 30 == 3)
 
 int pm_netdev_open(struct net_device *pnetdev, u8 bnormal);
-void netdev_br_init(struct net_device *netdev);
 void dhcp_flag_bcast(struct adapter *priv, struct sk_buff *skb);
 void *scdb_findEntry(struct adapter *priv, unsigned char *macAddr,
 		     unsigned char *ipAddr);
diff --git a/drivers/staging/rtl8188eu/os_dep/os_intfs.c b/drivers/staging/rtl8188eu/os_dep/os_intfs.c
index 43eaba0..1c30f4c 100644
--- a/drivers/staging/rtl8188eu/os_dep/os_intfs.c
+++ b/drivers/staging/rtl8188eu/os_dep/os_intfs.c
@@ -36,7 +36,6 @@ MODULE_DESCRIPTION("Realtek Wireless Lan Driver");
 MODULE_AUTHOR("Realtek Semiconductor Corp.");
 MODULE_VERSION(DRIVERVERSION);
 
-#define CONFIG_BR_EXT_BRNAME "br0"
 #define RTW_NOTCH_FILTER 0 /* 0:Disable, 1:Enable, */
 
 /* module param defaults */
@@ -1001,31 +1000,6 @@ u8 rtw_free_drv_sw(struct adapter *padapter)
 	return _SUCCESS;
 }
 
-void netdev_br_init(struct net_device *netdev)
-{
-	struct adapter *adapter = (struct adapter *)rtw_netdev_priv(netdev);
-
-	rcu_read_lock();
-
-	if (rcu_dereference(adapter->pnetdev->rx_handler_data)) {
-		struct net_device *br_netdev;
-		struct net *devnet = NULL;
-
-		devnet = dev_net(netdev);
-		br_netdev = dev_get_by_name(devnet, CONFIG_BR_EXT_BRNAME);
-		if (br_netdev) {
-			memcpy(adapter->br_mac, br_netdev->dev_addr, ETH_ALEN);
-			dev_put(br_netdev);
-		} else {
-			pr_info("%s()-%d: dev_get_by_name(%s) failed!",
-				__func__, __LINE__, CONFIG_BR_EXT_BRNAME);
-		}
-	}
-	adapter->ethBrExtInfo.addPPPoETag = 1;
-
-	rcu_read_unlock();
-}
-
 int _netdev_open(struct net_device *pnetdev)
 {
 	uint status;
@@ -1082,8 +1056,6 @@ int _netdev_open(struct net_device *pnetdev)
 	else
 		netif_tx_wake_all_queues(pnetdev);
 
-	netdev_br_init(pnetdev);
-
 netdev_open_normal_process:
 	RT_TRACE(_module_os_intfs_c_, _drv_info_, ("-88eu_drv - dev_open\n"));
 	DBG_88E("-88eu_drv - drv_open, bup =%d\n", padapter->bup);
-- 
1.7.10.4

