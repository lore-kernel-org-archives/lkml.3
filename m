Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751575AbaEYNFe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 09:05:34 -0400
Received: from mout.gmx.net ([212.227.15.15]:55721 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751399AbaEYNFc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 09:05:32 -0400
From: =?UTF-8?q?Manuel=20Sch=C3=B6lling?= <manuel.schoelling@gmx.de>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        =?UTF-8?q?Manuel=20Sch=C3=B6lling?= <manuel.schoelling@gmx.de>
Subject: [PATCH] rtl8188eu: use time_before/time_after and change type of ips_deny_time
Date: Sun, 25 May 2014 15:05:24 +0200
Message-Id: <1401023124-28732-1-git-send-email-manuel.schoelling@gmx.de>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:RCopUYngBYBrrSpuRFTFTUBqTV3Mrf5n2l5E3/hlX02YzZGo+9M
 fUwBeiTKbXhlfR/IGRP4WOV1s3gY1GUu36geISjZBtxsZa2+wL58YGXshdP1Yq6OCIFLTS6
 VdCA0NDtsze3sV6uhDGDDZAgjthi9WA6VljXCdCB4+YYikRs3vSJEsTHZNg2P93YCG4gp0N
 SmfY5eHqPY3S/M5p77YMQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To be future-proof and for better readability the time comparisons are
modified to use time_before/_after() instead of plain, error-prone math.
To suppress compiler warnings the type of ips_deny_time was changed.

Signed-off-by: Manuel Schölling <manuel.schoelling@gmx.de>
---
 drivers/staging/rtl8188eu/core/rtw_pwrctrl.c    |    9 ++++++---
 drivers/staging/rtl8188eu/include/rtw_pwrctrl.h |    2 +-
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_pwrctrl.c b/drivers/staging/rtl8188eu/core/rtw_pwrctrl.c
index f658373..eaf2630 100644
--- a/drivers/staging/rtl8188eu/core/rtw_pwrctrl.c
+++ b/drivers/staging/rtl8188eu/core/rtw_pwrctrl.c
@@ -122,7 +122,7 @@ static bool rtw_pwr_unassociated_idle(struct adapter *adapter)
 
 	bool ret = false;
 
-	if (adapter->pwrctrlpriv.ips_deny_time >= jiffies)
+	if (time_after_eq(adapter->pwrctrlpriv.ips_deny_time, jiffies))
 		goto exit;
 
 	if (check_fwstate(pmlmepriv, WIFI_ASOC_STATE|WIFI_SITE_MONITOR) ||
@@ -523,9 +523,11 @@ int _rtw_pwr_wakeup(struct adapter *padapter, u32 ips_deffer_ms, const char *cal
 {
 	struct pwrctrl_priv *pwrpriv = &padapter->pwrctrlpriv;
 	struct mlme_priv *pmlmepriv = &padapter->mlmepriv;
+	unsigned long expires;
 	int ret = _SUCCESS;
 
-	if (pwrpriv->ips_deny_time < jiffies + rtw_ms_to_systime(ips_deffer_ms))
+	expires = jiffies + rtw_ms_to_systime(ips_deffer_ms);
+	if (time_before(pwrpriv->ips_deny_time, expires))
 		pwrpriv->ips_deny_time = jiffies + rtw_ms_to_systime(ips_deffer_ms);
 
 {
@@ -580,7 +582,8 @@ int _rtw_pwr_wakeup(struct adapter *padapter, u32 ips_deffer_ms, const char *cal
 	}
 
 exit:
-	if (pwrpriv->ips_deny_time < jiffies + rtw_ms_to_systime(ips_deffer_ms))
+	expires = jiffies + rtw_ms_to_systime(ips_deffer_ms);
+	if (time_before(pwrpriv->ips_deny_time, expires))
 		pwrpriv->ips_deny_time = jiffies + rtw_ms_to_systime(ips_deffer_ms);
 	return ret;
 }
diff --git a/drivers/staging/rtl8188eu/include/rtw_pwrctrl.h b/drivers/staging/rtl8188eu/include/rtw_pwrctrl.h
index 9a42859..4211023 100644
--- a/drivers/staging/rtl8188eu/include/rtw_pwrctrl.h
+++ b/drivers/staging/rtl8188eu/include/rtw_pwrctrl.h
@@ -192,7 +192,7 @@ struct pwrctrl_priv {
 	u8	ips_mode_req;	/*  used to accept the mode setting request,
 				 *  will update to ipsmode later */
 	uint bips_processing;
-	u32 ips_deny_time; /* will deny IPS when system time less than this */
+	unsigned long ips_deny_time; /* will deny IPS when system time less than this */
 	u8 ps_processing; /* temp used to mark whether in rtw_ps_processor */
 
 	u8	bLeisurePs;
-- 
1.7.10.4

