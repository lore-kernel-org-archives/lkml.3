Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018AbaGGSk6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 14:40:58 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:59463 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876AbaGGSk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 14:40:57 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 02/13] staging: rtl8188eu: Remove function rtw_alloc_etherdev()
Date: Tue,  8 Jul 2014 00:10:02 +0530
Message-Id: <1404758413-12859-2-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1404758413-12859-1-git-send-email-navin.patidar@gmail.com>
References: <1404758413-12859-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rtw_alloc_etherdev() is used in rtw_init_netdev() but never gets called
because old_padapter is never NULL.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/include/osdep_service.h |    1 -
 drivers/staging/rtl8188eu/os_dep/os_intfs.c       |    4 +---
 drivers/staging/rtl8188eu/os_dep/osdep_service.c  |   23 ---------------------
 3 files changed, 1 insertion(+), 27 deletions(-)

diff --git a/drivers/staging/rtl8188eu/include/osdep_service.h b/drivers/staging/rtl8188eu/include/osdep_service.h
index 95131fe..a52dcd5 100644
--- a/drivers/staging/rtl8188eu/include/osdep_service.h
+++ b/drivers/staging/rtl8188eu/include/osdep_service.h
@@ -164,7 +164,6 @@ struct rtw_netdev_priv_indicator {
 };
 struct net_device *rtw_alloc_etherdev_with_old_priv(int sizeof_priv,
 						    void *old_priv);
-struct net_device *rtw_alloc_etherdev(int sizeof_priv);
 
 #define rtw_netdev_priv(netdev)					\
 	(((struct rtw_netdev_priv_indicator *)netdev_priv(netdev))->priv)
diff --git a/drivers/staging/rtl8188eu/os_dep/os_intfs.c b/drivers/staging/rtl8188eu/os_dep/os_intfs.c
index b0c38a4..c7a44ab 100644
--- a/drivers/staging/rtl8188eu/os_dep/os_intfs.c
+++ b/drivers/staging/rtl8188eu/os_dep/os_intfs.c
@@ -707,14 +707,12 @@ static const struct device_type wlan_type = {
 struct net_device *rtw_init_netdev(struct adapter *old_padapter)
 {
 	struct adapter *padapter;
-	struct net_device *pnetdev;
+	struct net_device *pnetdev = NULL;
 
 	RT_TRACE(_module_os_intfs_c_, _drv_info_, ("+init_net_dev\n"));
 
 	if (old_padapter != NULL)
 		pnetdev = rtw_alloc_etherdev_with_old_priv(sizeof(struct adapter), (void *)old_padapter);
-	else
-		pnetdev = rtw_alloc_etherdev(sizeof(struct adapter));
 
 	if (!pnetdev)
 		return NULL;
diff --git a/drivers/staging/rtl8188eu/os_dep/osdep_service.c b/drivers/staging/rtl8188eu/os_dep/osdep_service.c
index 76eddcd..93c76d7 100644
--- a/drivers/staging/rtl8188eu/os_dep/osdep_service.c
+++ b/drivers/staging/rtl8188eu/os_dep/osdep_service.c
@@ -111,29 +111,6 @@ RETURN:
 	return pnetdev;
 }
 
-struct net_device *rtw_alloc_etherdev(int sizeof_priv)
-{
-	struct net_device *pnetdev;
-	struct rtw_netdev_priv_indicator *pnpi;
-
-	pnetdev = alloc_etherdev_mq(sizeof(struct rtw_netdev_priv_indicator), 4);
-	if (!pnetdev)
-		goto RETURN;
-
-	pnpi = netdev_priv(pnetdev);
-
-	pnpi->priv = vzalloc(sizeof_priv);
-	if (!pnpi->priv) {
-		free_netdev(pnetdev);
-		pnetdev = NULL;
-		goto RETURN;
-	}
-
-	pnpi->sizeof_priv = sizeof_priv;
-RETURN:
-	return pnetdev;
-}
-
 void rtw_free_netdev(struct net_device *netdev)
 {
 	struct rtw_netdev_priv_indicator *pnpi;
-- 
1.7.10.4

