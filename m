Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934560AbaFTPHy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 11:07:54 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:33814 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934351AbaFTPEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 11:04:09 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 30/41] staging: rtl8188eu: Efuse_GetCurrentSize(): Remove parameter bool test
Date: Fri, 20 Jun 2014 20:29:36 +0530
Message-Id: <1403276387-11841-31-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403276387-11841-1-git-send-email-navin.patidar@gmail.com>
References: <1403276387-11841-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

test is always false.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_efuse.c        |    2 +-
 drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c |   16 +++++-----------
 drivers/staging/rtl8188eu/include/rtw_efuse.h     |    2 +-
 3 files changed, 7 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_efuse.c b/drivers/staging/rtl8188eu/core/rtw_efuse.c
index ecfd311..dfbb774 100644
--- a/drivers/staging/rtl8188eu/core/rtw_efuse.c
+++ b/drivers/staging/rtl8188eu/core/rtw_efuse.c
@@ -215,7 +215,7 @@ u16 efuse_GetMaxSize(struct adapter *padapter)
 u8 efuse_GetCurrentSize(struct adapter *padapter, u16 *size)
 {
 	Efuse_PowerSwitch(padapter, false, true);
-	*size = Efuse_GetCurrentSize(padapter, false);
+	*size = Efuse_GetCurrentSize(padapter);
 	Efuse_PowerSwitch(padapter, false, false);
 
 	return _SUCCESS;
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
index 7ef2313..61bff1a 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
@@ -934,17 +934,14 @@ u8 Efuse_WordEnableDataWrite(struct adapter *pAdapter, u16 efuse_addr, u8 word_e
 	return badworden;
 }
 
-u16 Efuse_GetCurrentSize(struct adapter *pAdapter, bool bPseudoTest)
+u16 Efuse_GetCurrentSize(struct adapter *pAdapter)
 {
 	int	bContinual = true;
 	u16	efuse_addr = 0;
 	u8 hoffset = 0, hworden = 0;
 	u8 efuse_data, word_cnts = 0;
 
-	if (bPseudoTest)
-		efuse_addr = (u16)(fakeEfuseUsedBytes);
-	else
-		rtw_hal_get_hwreg(pAdapter, HW_VAR_EFUSE_BYTES, (u8 *)&efuse_addr);
+	rtw_hal_get_hwreg(pAdapter, HW_VAR_EFUSE_BYTES, (u8 *)&efuse_addr);
 
 	while (bContinual &&
 	       efuse_OneByteRead(pAdapter, efuse_addr, &efuse_data) &&
@@ -973,10 +970,7 @@ u16 Efuse_GetCurrentSize(struct adapter *pAdapter, bool bPseudoTest)
 		}
 	}
 
-	if (bPseudoTest)
-		fakeEfuseUsedBytes = efuse_addr;
-	else
-		rtw_hal_set_hwreg(pAdapter, HW_VAR_EFUSE_BYTES, (u8 *)&efuse_addr);
+	rtw_hal_set_hwreg(pAdapter, HW_VAR_EFUSE_BYTES, (u8 *)&efuse_addr);
 
 	return efuse_addr;
 }
@@ -1085,7 +1079,7 @@ static bool hal_EfuseFixHeaderProcess(struct adapter *pAdapter, u8 efuseType, st
 			if (!PgWriteSuccess)
 				return false;
 			else
-				efuse_addr = Efuse_GetCurrentSize(pAdapter, bPseudoTest);
+				efuse_addr = Efuse_GetCurrentSize(pAdapter);
 		} else {
 			efuse_addr = efuse_addr + (pFixPkt->word_cnts*2) + 1;
 		}
@@ -1374,7 +1368,7 @@ hal_EfusePgCheckAvailableAddr(
 	/* Change to check TYPE_EFUSE_MAP_LEN , because 8188E raw 256, logic map over 256. */
 	EFUSE_GetEfuseDefinition(pAdapter, EFUSE_WIFI, TYPE_EFUSE_MAP_LEN, (void *)&efuse_max_available_len);
 
-	if (Efuse_GetCurrentSize(pAdapter, bPseudoTest) >= efuse_max_available_len)
+	if (Efuse_GetCurrentSize(pAdapter) >= efuse_max_available_len)
 		return false;
 	return true;
 }
diff --git a/drivers/staging/rtl8188eu/include/rtw_efuse.h b/drivers/staging/rtl8188eu/include/rtw_efuse.h
index fc87388..23a0168 100644
--- a/drivers/staging/rtl8188eu/include/rtw_efuse.h
+++ b/drivers/staging/rtl8188eu/include/rtw_efuse.h
@@ -123,7 +123,7 @@ u8 rtw_efuse_access(struct adapter *adapter, u8 read, u16 start_addr,
 		    u16 cnts, u8 *data);
 u8 rtw_efuse_map_read(struct adapter *adapter, u16 addr, u16 cnts, u8 *data);
 u8 rtw_efuse_map_write(struct adapter *adapter, u16 addr, u16 cnts, u8 *data);
-u16 Efuse_GetCurrentSize(struct adapter *adapter, bool test);
+u16 Efuse_GetCurrentSize(struct adapter *adapter);
 u8 Efuse_CalculateWordCnts(u8 word_en);
 void EFUSE_GetEfuseDefinition(struct adapter *adapt, u8 type, u8 type1,
 			      void *out);
-- 
1.7.10.4

