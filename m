Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030604Ab3HBKMV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:12:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37485 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030570Ab3HBKMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:12:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Richard Genoud <richard.genoud@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 87/99] rtlwifi: Initialize power-setting callback for USB devices
Date: Fri,  2 Aug 2013 18:08:40 +0800
Message-Id: <20130802100238.053650687@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.4.841.g1a3f60e
In-Reply-To: <20130802100225.478715166@linuxfoundation.org>
References: <20130802100225.478715166@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit bcfb879432094c267c35a7ff75d953d3a66c193a upstream.

Commit a269913c5 entitled "rtlwifi: Rework rtl_lps_leave() and
rtl_lps_enter() to use work queue" has two bugs for USB drivers.
Firstly, the work queue in question was not initialized. Secondly,
the callback routine used by this queue is contained within the
file used for PCI devices. As a result, it is not available for
architectures without PCI hardware.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Reported-by: Richard Genoud <richard.genoud@gmail.com>
Tested-by: Richard Genoud <richard.genoud@gmail.com>
Cc: Richard Genoud <richard.genoud@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/rtlwifi/pci.c |   13 -------------
 drivers/net/wireless/rtlwifi/ps.c  |   12 ++++++++++++
 drivers/net/wireless/rtlwifi/ps.h  |    1 +
 drivers/net/wireless/rtlwifi/usb.c |    2 ++
 4 files changed, 15 insertions(+), 13 deletions(-)

--- a/drivers/net/wireless/rtlwifi/pci.c
+++ b/drivers/net/wireless/rtlwifi/pci.c
@@ -1008,19 +1008,6 @@ static void _rtl_pci_prepare_bcn_tasklet
 	return;
 }
 
-static void rtl_lps_change_work_callback(struct work_struct *work)
-{
-	struct rtl_works *rtlworks =
-	    container_of(work, struct rtl_works, lps_change_work);
-	struct ieee80211_hw *hw = rtlworks->hw;
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
-
-	if (rtlpriv->enter_ps)
-		rtl_lps_enter(hw);
-	else
-		rtl_lps_leave(hw);
-}
-
 static void _rtl_pci_init_trx_var(struct ieee80211_hw *hw)
 {
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
--- a/drivers/net/wireless/rtlwifi/ps.c
+++ b/drivers/net/wireless/rtlwifi/ps.c
@@ -611,6 +611,18 @@ void rtl_swlps_rf_sleep(struct ieee80211
 			MSECS(sleep_intv * mac->vif->bss_conf.beacon_int - 40));
 }
 
+void rtl_lps_change_work_callback(struct work_struct *work)
+{
+	struct rtl_works *rtlworks =
+	    container_of(work, struct rtl_works, lps_change_work);
+	struct ieee80211_hw *hw = rtlworks->hw;
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+
+	if (rtlpriv->enter_ps)
+		rtl_lps_enter(hw);
+	else
+		rtl_lps_leave(hw);
+}
 
 void rtl_swlps_wq_callback(void *data)
 {
--- a/drivers/net/wireless/rtlwifi/ps.h
+++ b/drivers/net/wireless/rtlwifi/ps.h
@@ -49,5 +49,6 @@ void rtl_swlps_rf_awake(struct ieee80211
 void rtl_swlps_rf_sleep(struct ieee80211_hw *hw);
 void rtl_p2p_ps_cmd(struct ieee80211_hw *hw, u8 p2p_ps_state);
 void rtl_p2p_info(struct ieee80211_hw *hw, void *data, unsigned int len);
+void rtl_lps_change_work_callback(struct work_struct *work);
 
 #endif
--- a/drivers/net/wireless/rtlwifi/usb.c
+++ b/drivers/net/wireless/rtlwifi/usb.c
@@ -1070,6 +1070,8 @@ int rtl_usb_probe(struct usb_interface *
 	spin_lock_init(&rtlpriv->locks.usb_lock);
 	INIT_WORK(&rtlpriv->works.fill_h2c_cmd,
 		  rtl_fill_h2c_cmd_work_callback);
+	INIT_WORK(&rtlpriv->works.lps_change_work,
+		  rtl_lps_change_work_callback);
 
 	rtlpriv->usb_data_index = 0;
 	init_completion(&rtlpriv->firmware_loading_complete);


