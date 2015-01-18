Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751622AbbARAiR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 19:38:17 -0500
Received: from mail-we0-f176.google.com ([74.125.82.176]:64143 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbbARAiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 19:38:16 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Larry Finger <Larry.Finger@lwfinger.net>,
        Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Vaishali Thakkar <vthakkar1994@gmail.com>,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] staging: rtl8723au: os_dep: usb_intf: Remove unused functions
Date: Sun, 18 Jan 2015 01:41:23 +0100
Message-Id: <1421541683-17523-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes some functions that are not used anywhere:
rtw_hw_resume23a() rtw_hw_suspend23a()

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/rtl8723au/include/osdep_intf.h |    3 -
 drivers/staging/rtl8723au/os_dep/usb_intf.c    |   98 ------------------------
 2 files changed, 101 deletions(-)

diff --git a/drivers/staging/rtl8723au/include/osdep_intf.h b/drivers/staging/rtl8723au/include/osdep_intf.h
index 33afa62..a157eb2 100644
--- a/drivers/staging/rtl8723au/include/osdep_intf.h
+++ b/drivers/staging/rtl8723au/include/osdep_intf.h
@@ -19,9 +19,6 @@
 #include <osdep_service.h>
 #include <drv_types.h>
 
-int rtw_hw_suspend23a(struct rtw_adapter *padapter);
-int rtw_hw_resume23a(struct rtw_adapter *padapter);
-
 int rtw_init_drv_sw23a(struct rtw_adapter *padapter);
 int rtw_free_drv_sw23a(struct rtw_adapter *padapter);
 int rtw_reset_drv_sw23a(struct rtw_adapter *padapter);
diff --git a/drivers/staging/rtl8723au/os_dep/usb_intf.c b/drivers/staging/rtl8723au/os_dep/usb_intf.c
index 373a617..936414d 100644
--- a/drivers/staging/rtl8723au/os_dep/usb_intf.c
+++ b/drivers/staging/rtl8723au/os_dep/usb_intf.c
@@ -273,104 +273,6 @@ static void rtw_dev_unload(struct rtw_adapter *padapter)
 	RT_TRACE(_module_hci_intfs_c_, _drv_err_, ("-rtw_dev_unload\n"));
 }
 
-int rtw_hw_suspend23a(struct rtw_adapter *padapter)
-{
-	struct pwrctrl_priv *pwrpriv = &padapter->pwrctrlpriv;
-	struct net_device *pnetdev = padapter->pnetdev;
-	struct mlme_priv *pmlmepriv = &padapter->mlmepriv;
-
-	if ((!padapter->bup) || (padapter->bDriverStopped) ||
-	    (padapter->bSurpriseRemoved)) {
-		DBG_8723A("padapter->bup =%d bDriverStopped =%d bSurpriseRemoved = %d\n",
-			  padapter->bup, padapter->bDriverStopped,
-			  padapter->bSurpriseRemoved);
-		goto error_exit;
-	}
-
-	if (padapter) { /* system suspend */
-		LeaveAllPowerSaveMode23a(padapter);
-
-		DBG_8723A("==> rtw_hw_suspend23a\n");
-		down(&pwrpriv->lock);
-		pwrpriv->bips_processing = true;
-		/* padapter->net_closed = true; */
-		/* s1. */
-		if (pnetdev) {
-			netif_carrier_off(pnetdev);
-			netif_tx_stop_all_queues(pnetdev);
-		}
-
-		/* s2. */
-		rtw_disassoc_cmd23a(padapter, 500, false);
-
-		/* s2-2.  indicate disconnect to os */
-		/* rtw_indicate_disconnect23a(padapter); */
-		if (check_fwstate(pmlmepriv, _FW_LINKED)) {
-			_clr_fwstate_(pmlmepriv, _FW_LINKED);
-
-			rtw_os_indicate_disconnect23a(padapter);
-
-			/* donnot enqueue cmd */
-			rtw_lps_ctrl_wk_cmd23a(padapter,
-					       LPS_CTRL_DISCONNECT, 0);
-		}
-		/* s2-3. */
-		rtw_free_assoc_resources23a(padapter, 1);
-
-		/* s2-4. */
-		rtw_free_network_queue23a(padapter);
-		rtw_ips_dev_unload23a(padapter);
-		pwrpriv->rf_pwrstate = rf_off;
-		pwrpriv->bips_processing = false;
-		up(&pwrpriv->lock);
-	} else {
-		goto error_exit;
-	}
-	return 0;
-error_exit:
-	DBG_8723A("%s, failed\n", __func__);
-	return -1;
-}
-
-int rtw_hw_resume23a(struct rtw_adapter *padapter)
-{
-	struct pwrctrl_priv *pwrpriv = &padapter->pwrctrlpriv;
-	struct net_device *pnetdev = padapter->pnetdev;
-
-	if (padapter) { /* system resume */
-		DBG_8723A("==> rtw_hw_resume23a\n");
-		down(&pwrpriv->lock);
-		pwrpriv->bips_processing = true;
-		rtw_reset_drv_sw23a(padapter);
-
-		if (pm_netdev_open23a(pnetdev, false)) {
-			up(&pwrpriv->lock);
-			goto error_exit;
-		}
-
-		netif_device_attach(pnetdev);
-		netif_carrier_on(pnetdev);
-
-		if (!rtw_netif_queue_stopped(pnetdev))
-			netif_tx_start_all_queues(pnetdev);
-		else
-			netif_tx_wake_all_queues(pnetdev);
-
-		pwrpriv->bkeepfwalive = false;
-
-		pwrpriv->rf_pwrstate = rf_on;
-		pwrpriv->bips_processing = false;
-
-		up(&pwrpriv->lock);
-	} else {
-		goto error_exit;
-	}
-	return 0;
-error_exit:
-	DBG_8723A("%s, Open net dev failed\n", __func__);
-	return -1;
-}
-
 static int rtw_suspend(struct usb_interface *pusb_intf, pm_message_t message)
 {
 	struct dvobj_priv *dvobj = usb_get_intfdata(pusb_intf);
-- 
1.7.10.4

