Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555AbaEVT5P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 15:57:15 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:35046 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456AbaEVT5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 15:57:13 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Larry Finger <Larry.Finger@lwfinger.net>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Manu Gupta <manugupt1@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: rtl8188eu: os_dep: usb_intf.c:  Fix to remove null pointer checks that could never happen
Date: Thu, 22 May 2014 21:58:02 +0200
Message-Id: <1400788682-10787-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removal of null pointer checks that could never happen

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/rtl8188eu/os_dep/usb_intf.c |  110 +++++++++++++--------------
 1 file changed, 52 insertions(+), 58 deletions(-)

diff --git a/drivers/staging/rtl8188eu/os_dep/usb_intf.c b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
index 2e49cd5..3454e1b 100644
--- a/drivers/staging/rtl8188eu/os_dep/usb_intf.c
+++ b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
@@ -396,49 +396,47 @@ int rtw_hw_suspend(struct adapter *padapter)
 		goto error_exit;
 	}
 
-	if (padapter) { /* system suspend */
-		LeaveAllPowerSaveMode(padapter);
+	/* system suspend */
+	LeaveAllPowerSaveMode(padapter);
 
-		DBG_88E("==> rtw_hw_suspend\n");
-		_enter_pwrlock(&pwrpriv->lock);
-		pwrpriv->bips_processing = true;
-		/* s1. */
-		if (pnetdev) {
-			netif_carrier_off(pnetdev);
-			rtw_netif_stop_queue(pnetdev);
-		}
+	DBG_88E("==> rtw_hw_suspend\n");
+	_enter_pwrlock(&pwrpriv->lock);
+	pwrpriv->bips_processing = true;
+	/* s1. */
+	if (pnetdev) {
+		netif_carrier_off(pnetdev);
+		rtw_netif_stop_queue(pnetdev);
+	}
 
-		/* s2. */
-		rtw_disassoc_cmd(padapter, 500, false);
+	/* s2. */
+	rtw_disassoc_cmd(padapter, 500, false);
 
-		/* s2-2.  indicate disconnect to os */
-		{
-			struct	mlme_priv *pmlmepriv = &padapter->mlmepriv;
+	/* s2-2.  indicate disconnect to os */
+	{
+		struct	mlme_priv *pmlmepriv = &padapter->mlmepriv;
 
-			if (check_fwstate(pmlmepriv, _FW_LINKED)) {
-				_clr_fwstate_(pmlmepriv, _FW_LINKED);
+		if (check_fwstate(pmlmepriv, _FW_LINKED)) {
+			_clr_fwstate_(pmlmepriv, _FW_LINKED);
 
-				rtw_led_control(padapter, LED_CTL_NO_LINK);
+			rtw_led_control(padapter, LED_CTL_NO_LINK);
 
-				rtw_os_indicate_disconnect(padapter);
+			rtw_os_indicate_disconnect(padapter);
 
-				/* donnot enqueue cmd */
-				rtw_lps_ctrl_wk_cmd(padapter, LPS_CTRL_DISCONNECT, 0);
-			}
+			/* donnot enqueue cmd */
+			rtw_lps_ctrl_wk_cmd(padapter, LPS_CTRL_DISCONNECT, 0);
 		}
-		/* s2-3. */
-		rtw_free_assoc_resources(padapter, 1);
+	}
+	/* s2-3. */
+	rtw_free_assoc_resources(padapter, 1);
 
-		/* s2-4. */
-		rtw_free_network_queue(padapter, true);
-		rtw_ips_dev_unload(padapter);
-		pwrpriv->rf_pwrstate = rf_off;
-		pwrpriv->bips_processing = false;
+	/* s2-4. */
+	rtw_free_network_queue(padapter, true);
+	rtw_ips_dev_unload(padapter);
+	pwrpriv->rf_pwrstate = rf_off;
+	pwrpriv->bips_processing = false;
+
+	_exit_pwrlock(&pwrpriv->lock);
 
-		_exit_pwrlock(&pwrpriv->lock);
-	} else {
-		goto error_exit;
-	}
 	return 0;
 
 error_exit:
@@ -452,35 +450,32 @@ int rtw_hw_resume(struct adapter *padapter)
 	struct net_device *pnetdev = padapter->pnetdev;
 
 
-	if (padapter) { /* system resume */
-		DBG_88E("==> rtw_hw_resume\n");
-		_enter_pwrlock(&pwrpriv->lock);
-		pwrpriv->bips_processing = true;
-		rtw_reset_drv_sw(padapter);
+	/* system resume */
+	DBG_88E("==> rtw_hw_resume\n");
+	_enter_pwrlock(&pwrpriv->lock);
+	pwrpriv->bips_processing = true;
+	rtw_reset_drv_sw(padapter);
 
-		if (pm_netdev_open(pnetdev, false) != 0) {
-			_exit_pwrlock(&pwrpriv->lock);
-			goto error_exit;
-		}
+	if (pm_netdev_open(pnetdev, false) != 0) {
+		_exit_pwrlock(&pwrpriv->lock);
+		goto error_exit;
+	}
 
-		netif_device_attach(pnetdev);
-		netif_carrier_on(pnetdev);
+	netif_device_attach(pnetdev);
+	netif_carrier_on(pnetdev);
 
-		if (!netif_queue_stopped(pnetdev))
-			netif_start_queue(pnetdev);
-		else
-			netif_wake_queue(pnetdev);
+	if (!netif_queue_stopped(pnetdev))
+		netif_start_queue(pnetdev);
+	else
+		netif_wake_queue(pnetdev);
 
-		pwrpriv->bkeepfwalive = false;
-		pwrpriv->brfoffbyhw = false;
+	pwrpriv->bkeepfwalive = false;
+	pwrpriv->brfoffbyhw = false;
 
-		pwrpriv->rf_pwrstate = rf_on;
-		pwrpriv->bips_processing = false;
+	pwrpriv->rf_pwrstate = rf_on;
+	pwrpriv->bips_processing = false;
 
-		_exit_pwrlock(&pwrpriv->lock);
-	} else {
-		goto error_exit;
-	}
+	_exit_pwrlock(&pwrpriv->lock);
 
 
 	return 0;
@@ -591,8 +586,7 @@ int rtw_resume_process(struct adapter *padapter)
 
 	_enter_pwrlock(&pwrpriv->lock);
 	rtw_reset_drv_sw(padapter);
-	if (pwrpriv)
-		pwrpriv->bkeepfwalive = false;
+	pwrpriv->bkeepfwalive = false;
 
 	DBG_88E("bkeepfwalive(%x)\n", pwrpriv->bkeepfwalive);
 	if (pm_netdev_open(pnetdev, true) != 0)
-- 
1.7.10.4

