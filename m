Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757319AbaFAMSI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 08:18:08 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:50923 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757248AbaFAMSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 08:18:06 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 04/26] staging: rtl8188eu: Remove hw_init_mutex from struct rtw_usb_drv
Date: Sun,  1 Jun 2014 17:46:30 +0530
Message-Id: <1401625013-11208-4-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401625013-11208-1-git-send-email-navin.patidar@gmail.com>
References: <1401625013-11208-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/include/drv_types.h |    2 +-
 drivers/staging/rtl8188eu/os_dep/os_intfs.c   |    6 ++++--
 drivers/staging/rtl8188eu/os_dep/usb_intf.c   |    6 +-----
 3 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/rtl8188eu/include/drv_types.h b/drivers/staging/rtl8188eu/include/drv_types.h
index 10cc1a1..f40db1a 100644
--- a/drivers/staging/rtl8188eu/include/drv_types.h
+++ b/drivers/staging/rtl8188eu/include/drv_types.h
@@ -307,7 +307,7 @@ struct adapter {
 #endif
 	struct adapter *pbuddy_adapter;
 
-	struct mutex *hw_init_mutex;
+	struct mutex hw_init_mutex;
 
 	spinlock_t br_ext_lock;
 	struct nat25_network_db_entry	*nethash[NAT25_HASH_SIZE];
diff --git a/drivers/staging/rtl8188eu/os_dep/os_intfs.c b/drivers/staging/rtl8188eu/os_dep/os_intfs.c
index a220c57..c9906e3 100644
--- a/drivers/staging/rtl8188eu/os_dep/os_intfs.c
+++ b/drivers/staging/rtl8188eu/os_dep/os_intfs.c
@@ -997,6 +997,8 @@ u8 rtw_free_drv_sw(struct adapter *padapter)
 	if (padapter->pbuddy_adapter != NULL)
 		padapter->pbuddy_adapter->pbuddy_adapter = NULL;
 
+	mutex_destroy(&padapter->hw_init_mutex);
+
 	RT_TRACE(_module_os_intfs_c_, _drv_info_, ("-rtw_free_drv_sw\n"));
 
 	return _SUCCESS;
@@ -1105,9 +1107,9 @@ int netdev_open(struct net_device *pnetdev)
 	int ret;
 	struct adapter *padapter = (struct adapter *)rtw_netdev_priv(pnetdev);
 
-	_enter_critical_mutex(padapter->hw_init_mutex, NULL);
+	_enter_critical_mutex(&padapter->hw_init_mutex, NULL);
 	ret = _netdev_open(pnetdev);
-	mutex_unlock(padapter->hw_init_mutex);
+	mutex_unlock(&padapter->hw_init_mutex);
 	return ret;
 }
 
diff --git a/drivers/staging/rtl8188eu/os_dep/usb_intf.c b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
index d17218f..523d500 100644
--- a/drivers/staging/rtl8188eu/os_dep/usb_intf.c
+++ b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
@@ -63,7 +63,6 @@ MODULE_DEVICE_TABLE(usb, rtw_usb_id_tbl);
 struct rtw_usb_drv {
 	struct usb_driver usbdrv;
 	int drv_registered;
-	struct mutex hw_init_mutex;
 };
 
 static struct rtw_usb_drv rtl8188e_usb_drv = {
@@ -537,7 +536,7 @@ static struct adapter *rtw_usb_if1_init(struct dvobj_priv *dvobj,
 	dvobj->if1 = padapter;
 
 	padapter->bDriverStopped = true;
-	padapter->hw_init_mutex = &usb_drv->hw_init_mutex;
+	mutex_init(&padapter->hw_init_mutex);
 	padapter->chip_type = RTL8188E;
 
 	pnetdev = rtw_init_netdev(padapter);
@@ -732,8 +731,6 @@ static int __init rtw_drv_entry(void)
 
 	DBG_88E(DRV_NAME " driver version=%s\n", DRIVERVERSION);
 
-	mutex_init(&usb_drv->hw_init_mutex);
-
 	usb_drv->drv_registered = true;
 	return usb_register(&usb_drv->usbdrv);
 }
@@ -746,7 +743,6 @@ static void __exit rtw_drv_halt(void)
 	usb_drv->drv_registered = false;
 	usb_deregister(&usb_drv->usbdrv);
 
-	mutex_destroy(&usb_drv->hw_init_mutex);
 	DBG_88E("-rtw_drv_halt\n");
 }
 
-- 
1.7.10.4

