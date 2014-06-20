Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755106AbaFTPAp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 11:00:45 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:47243 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108AbaFTPAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 11:00:41 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 04/41] staging: rtl8188eu: Remove rtl8188e_EfuseGetCurrentSize()
Date: Fri, 20 Jun 2014 20:29:10 +0530
Message-Id: <1403276387-11841-5-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403276387-11841-1-git-send-email-navin.patidar@gmail.com>
References: <1403276387-11841-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rtl8188e_EfuseGetCurrentSize() checks bool bPseudoTest and then calls suitable
function to get efuse size, hal_EfuseGetCurrentSize_8188e() also does same thing.
So use hal_EfuseGetCurrentSize_8188e() and drop rtl8188e_EfuseGetCurrentSize().

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_efuse.c        |    5 ++---
 drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c |   17 +++--------------
 drivers/staging/rtl8188eu/include/hal_intf.h      |    2 +-
 drivers/staging/rtl8188eu/include/rtw_efuse.h     |    2 +-
 4 files changed, 7 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_efuse.c b/drivers/staging/rtl8188eu/core/rtw_efuse.c
index 31507e7..b450458 100644
--- a/drivers/staging/rtl8188eu/core/rtw_efuse.c
+++ b/drivers/staging/rtl8188eu/core/rtw_efuse.c
@@ -128,12 +128,11 @@ Efuse_PowerSwitch(
 u16
 Efuse_GetCurrentSize(
 	struct adapter *pAdapter,
-	u8 efuseType,
 	bool pseudo)
 {
 	u16 ret = 0;
 
-	ret = pAdapter->HalFunc.EfuseGetCurrentSize(pAdapter, efuseType, pseudo);
+	ret = pAdapter->HalFunc.EfuseGetCurrentSize(pAdapter, pseudo);
 
 	return ret;
 }
@@ -490,7 +489,7 @@ u16 efuse_GetMaxSize(struct adapter *padapter)
 u8 efuse_GetCurrentSize(struct adapter *padapter, u16 *size)
 {
 	Efuse_PowerSwitch(padapter, false, true);
-	*size = Efuse_GetCurrentSize(padapter, EFUSE_WIFI, false);
+	*size = Efuse_GetCurrentSize(padapter, false);
 	Efuse_PowerSwitch(padapter, false, false);
 
 	return _SUCCESS;
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
index b7066cb..84393aa 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
@@ -1215,17 +1215,6 @@ static u16 Hal_EfuseGetCurrentSize_Pseudo(struct adapter *pAdapter, bool bPseudo
 	return ret;
 }
 
-static u16 rtl8188e_EfuseGetCurrentSize(struct adapter *pAdapter, u8 efuseType, bool bPseudoTest)
-{
-	u16	ret = 0;
-
-	if (bPseudoTest)
-		ret = Hal_EfuseGetCurrentSize_Pseudo(pAdapter, bPseudoTest);
-	else
-		ret = hal_EfuseGetCurrentSize_8188e(pAdapter, bPseudoTest);
-	return ret;
-}
-
 static int hal_EfusePgPacketRead_8188e(struct adapter *pAdapter, u8 offset, u8 *data, bool bPseudoTest)
 {
 	u8 ReadState = PG_STATE_HEADER;
@@ -1357,7 +1346,7 @@ static bool hal_EfuseFixHeaderProcess(struct adapter *pAdapter, u8 efuseType, st
 			if (!PgWriteSuccess)
 				return false;
 			else
-				efuse_addr = Efuse_GetCurrentSize(pAdapter, efuseType, bPseudoTest);
+				efuse_addr = Efuse_GetCurrentSize(pAdapter, bPseudoTest);
 		} else {
 			efuse_addr = efuse_addr + (pFixPkt->word_cnts*2) + 1;
 		}
@@ -1646,7 +1635,7 @@ hal_EfusePgCheckAvailableAddr(
 	/* Change to check TYPE_EFUSE_MAP_LEN , because 8188E raw 256, logic map over 256. */
 	EFUSE_GetEfuseDefinition(pAdapter, EFUSE_WIFI, TYPE_EFUSE_MAP_LEN, (void *)&efuse_max_available_len, false);
 
-	if (Efuse_GetCurrentSize(pAdapter, efuseType, bPseudoTest) >= efuse_max_available_len)
+	if (Efuse_GetCurrentSize(pAdapter, bPseudoTest) >= efuse_max_available_len)
 		return false;
 	return true;
 }
@@ -1836,7 +1825,7 @@ void rtl8188e_set_hal_ops(struct hal_ops *pHalFunc)
 	pHalFunc->EfusePowerSwitch = &rtl8188e_EfusePowerSwitch;
 	pHalFunc->ReadEFuse = &ReadEFuseByIC;
 	pHalFunc->EFUSEGetEfuseDefinition = &rtl8188e_EFUSE_GetEfuseDefinition;
-	pHalFunc->EfuseGetCurrentSize = &rtl8188e_EfuseGetCurrentSize;
+	pHalFunc->EfuseGetCurrentSize = &hal_EfuseGetCurrentSize_8188e;
 	pHalFunc->Efuse_PgPacketRead = &rtl8188e_Efuse_PgPacketRead;
 	pHalFunc->Efuse_PgPacketWrite = &rtl8188e_Efuse_PgPacketWrite;
 	pHalFunc->Efuse_WordEnableDataWrite = &rtl8188e_Efuse_WordEnableDataWrite;
diff --git a/drivers/staging/rtl8188eu/include/hal_intf.h b/drivers/staging/rtl8188eu/include/hal_intf.h
index ca29676..ecc92a6 100644
--- a/drivers/staging/rtl8188eu/include/hal_intf.h
+++ b/drivers/staging/rtl8188eu/include/hal_intf.h
@@ -239,7 +239,7 @@ struct hal_ops {
 			  u16 _size_byte, u8 *pbuf, bool bPseudoTest);
 	void (*EFUSEGetEfuseDefinition)(struct adapter *padapter, u8 efuseType,
 					u8 type, void *pOut, bool bPseudoTest);
-	u16	(*EfuseGetCurrentSize)(struct adapter *padapter, u8 efuseType,
+	u16	(*EfuseGetCurrentSize)(struct adapter *padapter,
 				       bool bPseudoTest);
 	int	(*Efuse_PgPacketRead)(struct adapter *adapter, u8 offset,
 				      u8 *data, bool bPseudoTest);
diff --git a/drivers/staging/rtl8188eu/include/rtw_efuse.h b/drivers/staging/rtl8188eu/include/rtw_efuse.h
index df51355..cc19e19 100644
--- a/drivers/staging/rtl8188eu/include/rtw_efuse.h
+++ b/drivers/staging/rtl8188eu/include/rtw_efuse.h
@@ -127,7 +127,7 @@ u8 rtw_BT_efuse_map_read(struct adapter *adapter, u16 addr,
 			 u16 cnts, u8 *data);
 u8 rtw_BT_efuse_map_write(struct adapter *adapter, u16 addr,
 			  u16 cnts, u8 *data);
-u16 Efuse_GetCurrentSize(struct adapter *adapter, u8 efusetype, bool test);
+u16 Efuse_GetCurrentSize(struct adapter *adapter, bool test);
 u8 Efuse_CalculateWordCnts(u8 word_en);
 void ReadEFuseByte(struct adapter *adapter, u16 _offset, u8 *pbuf, bool test);
 void EFUSE_GetEfuseDefinition(struct adapter *adapt, u8 type, u8 type1,
-- 
1.7.10.4

