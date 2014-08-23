Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752644AbaHWOVN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 10:21:13 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:40732 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752593AbaHWOVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 10:21:10 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 16/20] staging: rtl8188eu: Rework function PHY_SwChnl8188E()
Date: Sat, 23 Aug 2014 19:48:37 +0530
Message-Id: <1408803521-13715-16-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1408803521-13715-1-git-send-email-navin.patidar@gmail.com>
References: <1408803521-13715-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename CamelCase variables and function name.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c  |    2 +-
 drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c    |   27 +++++++++-----------
 drivers/staging/rtl8188eu/include/Hal8188EPhyCfg.h |    2 --
 drivers/staging/rtl8188eu/include/phy.h            |    1 +
 4 files changed, 14 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
index f41e83d..7a8fe53 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
@@ -222,7 +222,7 @@ void rtl8188e_set_hal_ops(struct hal_ops *pHalFunc)
 	pHalFunc->read_chip_version = &rtl8188e_read_chip_version;
 
 	pHalFunc->set_bwmode_handler = &phy_set_bw_mode;
-	pHalFunc->set_channel_handler = &PHY_SwChnl8188E;
+	pHalFunc->set_channel_handler = &phy_sw_chnl;
 
 	pHalFunc->hal_dm_watchdog = &rtl8188e_HalDmWatchDog;
 
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c b/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
index b1ff892..5041da0 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
@@ -355,30 +355,27 @@ static void phy_sw_chnl_callback(struct adapter *adapt, u8 channel)
 	}
 }
 
-void PHY_SwChnl8188E(struct adapter *Adapter, u8 channel)
+void phy_sw_chnl(struct adapter *adapt, u8 channel)
 {
-	/*  Call after initialization */
-	struct hal_data_8188e	*pHalData = GET_HAL_DATA(Adapter);
-	u8 tmpchannel = pHalData->CurrentChannel;
-	bool  bResult = true;
+	struct hal_data_8188e *hal_data = GET_HAL_DATA(adapt);
+	u8 tmpchannel = hal_data->CurrentChannel;
+	bool  result = true;
 
-	if (pHalData->rf_chip == RF_PSEUDO_11N)
-		return;		/* return immediately if it is peudo-phy */
+	if (hal_data->rf_chip == RF_PSEUDO_11N)
+		return;
 
 	if (channel == 0)
 		channel = 1;
 
-	pHalData->CurrentChannel = channel;
+	hal_data->CurrentChannel = channel;
 
-	if ((!Adapter->bDriverStopped) && (!Adapter->bSurpriseRemoved)) {
-		phy_sw_chnl_callback(Adapter, channel);
+	if ((!adapt->bDriverStopped) && (!adapt->bSurpriseRemoved)) {
+		phy_sw_chnl_callback(adapt, channel);
 
-		if (bResult)
-			;
-		else
-			pHalData->CurrentChannel = tmpchannel;
+		if (!result)
+			hal_data->CurrentChannel = tmpchannel;
 
 	} else {
-		pHalData->CurrentChannel = tmpchannel;
+		hal_data->CurrentChannel = tmpchannel;
 	}
 }
diff --git a/drivers/staging/rtl8188eu/include/Hal8188EPhyCfg.h b/drivers/staging/rtl8188eu/include/Hal8188EPhyCfg.h
index f8bc63c..20e6b40 100644
--- a/drivers/staging/rtl8188eu/include/Hal8188EPhyCfg.h
+++ b/drivers/staging/rtl8188eu/include/Hal8188EPhyCfg.h
@@ -207,8 +207,6 @@ void PHY_GetTxPowerLevel8188E(struct adapter *adapter, u32 *powerlevel);
 
 void PHY_ScanOperationBackup8188E(struct adapter *Adapter, u8 Operation);
 
-/*  channel switch related funciton */
-void PHY_SwChnl8188E(struct adapter *adapter, u8 channel);
 /*  Call after initialization */
 void ChkFwCmdIoDone(struct adapter *adapter);
 
diff --git a/drivers/staging/rtl8188eu/include/phy.h b/drivers/staging/rtl8188eu/include/phy.h
index 5b93987..defed4a 100644
--- a/drivers/staging/rtl8188eu/include/phy.h
+++ b/drivers/staging/rtl8188eu/include/phy.h
@@ -13,3 +13,4 @@ void phy_set_tx_power_level(struct adapter *adapt, u8 channel);
 
 void phy_set_bw_mode(struct adapter *adapt, enum ht_channel_width bandwidth,
 		     unsigned char offset);
+void phy_sw_chnl(struct adapter *adapt, u8 channel);
-- 
1.7.10.4

