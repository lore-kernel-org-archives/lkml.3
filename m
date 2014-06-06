Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449AbaFFQPu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 12:15:50 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:64135 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401AbaFFQPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 12:15:49 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 04/13] staging: rtl8188eu:Move rtw_hw_[suspend,resume]() to rtw_pwrctrl.c
Date: Fri,  6 Jun 2014 21:45:12 +0530
Message-Id: <1402071320-14400-3-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1402071320-14400-1-git-send-email-navin.patidar@gmail.com>
References: <1402071320-14400-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rtw_hw_[suspend,resume]() functions are used only in rtw_pwrctrl.c,
so move these functions there.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_pwrctrl.c   |  103 ++++++++++++++++++++++++
 drivers/staging/rtl8188eu/include/osdep_intf.h |    2 -
 drivers/staging/rtl8188eu/os_dep/usb_intf.c    |  102 -----------------------
 3 files changed, 103 insertions(+), 104 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_pwrctrl.c b/drivers/staging/rtl8188eu/core/rtw_pwrctrl.c
index 599f2b6..be4c094 100644
--- a/drivers/staging/rtl8188eu/core/rtw_pwrctrl.c
+++ b/drivers/staging/rtl8188eu/core/rtw_pwrctrl.c
@@ -23,6 +23,109 @@
 #include <drv_types.h>
 #include <osdep_intf.h>
 #include <linux/usb.h>
+#include <usb_osintf.h>
+
+static int rtw_hw_suspend(struct adapter *padapter)
+{
+	struct pwrctrl_priv *pwrpriv = &padapter->pwrctrlpriv;
+	struct net_device *pnetdev = padapter->pnetdev;
+
+
+	if ((!padapter->bup) || (padapter->bDriverStopped) ||
+	    (padapter->bSurpriseRemoved)) {
+		DBG_88E("padapter->bup=%d bDriverStopped=%d bSurpriseRemoved = %d\n",
+			padapter->bup, padapter->bDriverStopped,
+			padapter->bSurpriseRemoved);
+		goto error_exit;
+	}
+
+	/* system suspend */
+	LeaveAllPowerSaveMode(padapter);
+
+	DBG_88E("==> rtw_hw_suspend\n");
+	_enter_pwrlock(&pwrpriv->lock);
+	pwrpriv->bips_processing = true;
+	/* s1. */
+	if (pnetdev) {
+		netif_carrier_off(pnetdev);
+		netif_tx_stop_all_queues(pnetdev);
+	}
+
+	/* s2. */
+	rtw_disassoc_cmd(padapter, 500, false);
+
+	/* s2-2.  indicate disconnect to os */
+	{
+		struct	mlme_priv *pmlmepriv = &padapter->mlmepriv;
+
+		if (check_fwstate(pmlmepriv, _FW_LINKED)) {
+			_clr_fwstate_(pmlmepriv, _FW_LINKED);
+
+			rtw_led_control(padapter, LED_CTL_NO_LINK);
+
+			rtw_os_indicate_disconnect(padapter);
+
+			/* donnot enqueue cmd */
+			rtw_lps_ctrl_wk_cmd(padapter, LPS_CTRL_DISCONNECT, 0);
+		}
+	}
+	/* s2-3. */
+	rtw_free_assoc_resources(padapter, 1);
+
+	/* s2-4. */
+	rtw_free_network_queue(padapter, true);
+	rtw_ips_dev_unload(padapter);
+	pwrpriv->rf_pwrstate = rf_off;
+	pwrpriv->bips_processing = false;
+
+	_exit_pwrlock(&pwrpriv->lock);
+
+	return 0;
+
+error_exit:
+	DBG_88E("%s, failed\n", __func__);
+	return -1;
+}
+
+static int rtw_hw_resume(struct adapter *padapter)
+{
+	struct pwrctrl_priv *pwrpriv = &padapter->pwrctrlpriv;
+	struct net_device *pnetdev = padapter->pnetdev;
+
+
+	/* system resume */
+	DBG_88E("==> rtw_hw_resume\n");
+	_enter_pwrlock(&pwrpriv->lock);
+	pwrpriv->bips_processing = true;
+	rtw_reset_drv_sw(padapter);
+
+	if (pm_netdev_open(pnetdev, false) != 0) {
+		_exit_pwrlock(&pwrpriv->lock);
+		goto error_exit;
+	}
+
+	netif_device_attach(pnetdev);
+	netif_carrier_on(pnetdev);
+
+	if (!netif_queue_stopped(pnetdev))
+		netif_start_queue(pnetdev);
+	else
+		netif_wake_queue(pnetdev);
+
+	pwrpriv->bkeepfwalive = false;
+	pwrpriv->brfoffbyhw = false;
+
+	pwrpriv->rf_pwrstate = rf_on;
+	pwrpriv->bips_processing = false;
+
+	_exit_pwrlock(&pwrpriv->lock);
+
+
+	return 0;
+error_exit:
+	DBG_88E("%s, Open net dev failed\n", __func__);
+	return -1;
+}
 
 void ips_enter(struct adapter *padapter)
 {
diff --git a/drivers/staging/rtl8188eu/include/osdep_intf.h b/drivers/staging/rtl8188eu/include/osdep_intf.h
index c4599c5..a5b3bd3 100644
--- a/drivers/staging/rtl8188eu/include/osdep_intf.h
+++ b/drivers/staging/rtl8188eu/include/osdep_intf.h
@@ -77,7 +77,5 @@ void rtw_ips_dev_unload(struct adapter *padapter);
 
 int rtw_ips_pwr_up(struct adapter *padapter);
 void rtw_ips_pwr_down(struct adapter *padapter);
-int rtw_hw_suspend(struct adapter *padapter);
-int rtw_hw_resume(struct adapter *padapter);
 
 #endif	/* _OSDEP_INTF_H_ */
diff --git a/drivers/staging/rtl8188eu/os_dep/usb_intf.c b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
index a84ee97..25a931a 100644
--- a/drivers/staging/rtl8188eu/os_dep/usb_intf.c
+++ b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
@@ -234,108 +234,6 @@ static void rtw_dev_unload(struct adapter *padapter)
 	RT_TRACE(_module_hci_intfs_c_, _drv_err_, ("-rtw_dev_unload\n"));
 }
 
-int rtw_hw_suspend(struct adapter *padapter)
-{
-	struct pwrctrl_priv *pwrpriv = &padapter->pwrctrlpriv;
-	struct net_device *pnetdev = padapter->pnetdev;
-
-
-	if ((!padapter->bup) || (padapter->bDriverStopped) ||
-	    (padapter->bSurpriseRemoved)) {
-		DBG_88E("padapter->bup=%d bDriverStopped=%d bSurpriseRemoved = %d\n",
-			padapter->bup, padapter->bDriverStopped,
-			padapter->bSurpriseRemoved);
-		goto error_exit;
-	}
-
-	/* system suspend */
-	LeaveAllPowerSaveMode(padapter);
-
-	DBG_88E("==> rtw_hw_suspend\n");
-	_enter_pwrlock(&pwrpriv->lock);
-	pwrpriv->bips_processing = true;
-	/* s1. */
-	if (pnetdev) {
-		netif_carrier_off(pnetdev);
-		netif_tx_stop_all_queues(pnetdev);
-	}
-
-	/* s2. */
-	rtw_disassoc_cmd(padapter, 500, false);
-
-	/* s2-2.  indicate disconnect to os */
-	{
-		struct	mlme_priv *pmlmepriv = &padapter->mlmepriv;
-
-		if (check_fwstate(pmlmepriv, _FW_LINKED)) {
-			_clr_fwstate_(pmlmepriv, _FW_LINKED);
-
-			rtw_led_control(padapter, LED_CTL_NO_LINK);
-
-			rtw_os_indicate_disconnect(padapter);
-
-			/* donnot enqueue cmd */
-			rtw_lps_ctrl_wk_cmd(padapter, LPS_CTRL_DISCONNECT, 0);
-		}
-	}
-	/* s2-3. */
-	rtw_free_assoc_resources(padapter, 1);
-
-	/* s2-4. */
-	rtw_free_network_queue(padapter, true);
-	rtw_ips_dev_unload(padapter);
-	pwrpriv->rf_pwrstate = rf_off;
-	pwrpriv->bips_processing = false;
-
-	_exit_pwrlock(&pwrpriv->lock);
-
-	return 0;
-
-error_exit:
-	DBG_88E("%s, failed\n", __func__);
-	return -1;
-}
-
-int rtw_hw_resume(struct adapter *padapter)
-{
-	struct pwrctrl_priv *pwrpriv = &padapter->pwrctrlpriv;
-	struct net_device *pnetdev = padapter->pnetdev;
-
-
-	/* system resume */
-	DBG_88E("==> rtw_hw_resume\n");
-	_enter_pwrlock(&pwrpriv->lock);
-	pwrpriv->bips_processing = true;
-	rtw_reset_drv_sw(padapter);
-
-	if (pm_netdev_open(pnetdev, false) != 0) {
-		_exit_pwrlock(&pwrpriv->lock);
-		goto error_exit;
-	}
-
-	netif_device_attach(pnetdev);
-	netif_carrier_on(pnetdev);
-
-	if (!netif_queue_stopped(pnetdev))
-		netif_start_queue(pnetdev);
-	else
-		netif_wake_queue(pnetdev);
-
-	pwrpriv->bkeepfwalive = false;
-	pwrpriv->brfoffbyhw = false;
-
-	pwrpriv->rf_pwrstate = rf_on;
-	pwrpriv->bips_processing = false;
-
-	_exit_pwrlock(&pwrpriv->lock);
-
-
-	return 0;
-error_exit:
-	DBG_88E("%s, Open net dev failed\n", __func__);
-	return -1;
-}
-
 static int rtw_suspend(struct usb_interface *pusb_intf, pm_message_t message)
 {
 	struct dvobj_priv *dvobj = usb_get_intfdata(pusb_intf);
-- 
1.7.10.4

