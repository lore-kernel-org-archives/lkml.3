Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751780AbaL2Fss (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 00:48:48 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:61136 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843AbaL2Fsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 00:48:47 -0500
Date: Sun, 28 Dec 2014 21:47:06 -0800
From: Serguey Parkhomovsky <sergueyparkhomovsky@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        navin patidar <navin.patidar@gmail.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Elena Oat <oat.elena@gmail.com>, Tim Jester-Pfadt <t.jp@gmx.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: rtl8188eu: rtw_mlme.c: fix sparse warning
Message-ID: <20141229054706.GA8062@fedora.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes the following sparse warning for rtw_mlme.c:

drivers/staging/rtl8188eu/core/rtw_mlme.c:810:9: warning: context imbalance in 'rtw_free_assoc_resources' - different lock contexts for basic block

Signed-off-by: Serguey Parkhomovsky <sergueyparkhomovsky@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_mlme.c | 37 ++++++++++++++++++++-----------
 1 file changed, 24 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_mlme.c b/drivers/staging/rtl8188eu/core/rtw_mlme.c
index d4632da..a47717a 100644
--- a/drivers/staging/rtl8188eu/core/rtw_mlme.c
+++ b/drivers/staging/rtl8188eu/core/rtw_mlme.c
@@ -755,12 +755,30 @@ static void free_scanqueue(struct	mlme_priv *pmlmepriv)
 	spin_unlock_bh(&scan_queue->lock);
 }
 
+static void rtw_free_current_network(struct adapter *adapter)
+{
+	struct wlan_network *pwlan = NULL;
+	struct mlme_priv *pmlmepriv = &adapter->mlmepriv;
+	struct wlan_network *tgt_network = &pmlmepriv->cur_network;
+
+	pwlan = rtw_find_network(&pmlmepriv->scanned_queue,
+				 tgt_network->network.MacAddress);
+	if (pwlan)
+		pwlan->fixed = false;
+	else
+		RT_TRACE(_module_rtl871x_mlme_c_, _drv_err_,
+			("rtw_free_assoc_resources:pwlan==NULL\n\n"));
+
+	if (check_fwstate(pmlmepriv, WIFI_ADHOC_MASTER_STATE) &&
+			 (adapter->stapriv.asoc_sta_count == 1))
+		rtw_free_network_nolock(pmlmepriv, pwlan);
+}
+
 /*
 *rtw_free_assoc_resources: the caller has to lock pmlmepriv->lock
 */
 void rtw_free_assoc_resources(struct adapter *adapter, int lock_scanned_queue)
 {
-	struct wlan_network *pwlan = NULL;
 	struct	mlme_priv *pmlmepriv = &adapter->mlmepriv;
 	struct	sta_priv *pstapriv = &adapter->stapriv;
 	struct wlan_network *tgt_network = &pmlmepriv->cur_network;
@@ -793,20 +811,13 @@ void rtw_free_assoc_resources(struct adapter *adapter, int lock_scanned_queue)
 		rtw_init_bcmc_stainfo(adapter);
 	}
 
-	if (lock_scanned_queue)
+	if (lock_scanned_queue) {
 		spin_lock_bh(&(pmlmepriv->scanned_queue.lock));
-
-	pwlan = rtw_find_network(&pmlmepriv->scanned_queue, tgt_network->network.MacAddress);
-	if (pwlan)
-		pwlan->fixed = false;
-	else
-		RT_TRACE(_module_rtl871x_mlme_c_, _drv_err_, ("rtw_free_assoc_resources:pwlan==NULL\n\n"));
-
-	if ((check_fwstate(pmlmepriv, WIFI_ADHOC_MASTER_STATE) && (adapter->stapriv.asoc_sta_count == 1)))
-		rtw_free_network_nolock(pmlmepriv, pwlan);
-
-	if (lock_scanned_queue)
+		rtw_free_current_network(adapter);
 		spin_unlock_bh(&pmlmepriv->scanned_queue.lock);
+	} else
+		rtw_free_current_network(adapter);
+
 	pmlmepriv->key_mask = 0;
 }
 
-- 
1.9.3

