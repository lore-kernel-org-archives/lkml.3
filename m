Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933870AbaFTPDA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 11:03:00 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:45593 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933726AbaFTPC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 11:02:58 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 19/41] staging: rtl8188eu: Rename hal_EfusePgPacketWrite_8188e()
Date: Fri, 20 Jun 2014 20:29:25 +0530
Message-Id: <1403276387-11841-20-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403276387-11841-1-git-send-email-navin.patidar@gmail.com>
References: <1403276387-11841-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename hal_EfusePgPacketWrite_8188e() to Efuse_PgPacketWrite()
and remove original Efuse_PgPacketWrite() function,
so that driver can call hal_EfusePgPacketWrite_8188e() directly
without going through Efuse_PgPacketWrite().

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_efuse.c        |   10 ----------
 drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c |    5 +----
 drivers/staging/rtl8188eu/include/hal_intf.h      |    2 --
 drivers/staging/rtl8188eu/include/rtw_efuse.h     |    2 +-
 4 files changed, 2 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_efuse.c b/drivers/staging/rtl8188eu/core/rtw_efuse.c
index e15784e..de211a7 100644
--- a/drivers/staging/rtl8188eu/core/rtw_efuse.c
+++ b/drivers/staging/rtl8188eu/core/rtw_efuse.c
@@ -264,16 +264,6 @@ u8 efuse_OneByteWrite(struct adapter *pAdapter, u16 addr, u8 data, bool pseudo)
 	return result;
 }
 
-int Efuse_PgPacketWrite(struct adapter *pAdapter, u8 offset, u8 word_en, u8 *data, bool pseudo)
-{
-	int ret;
-
-	ret =  pAdapter->HalFunc.Efuse_PgPacketWrite(pAdapter, offset, word_en, data, pseudo);
-
-	return ret;
-}
-
-
 static int Efuse_PgPacketWrite_BT(struct adapter *pAdapter, u8 offset, u8 word_en, u8 *data, bool pseudo)
 {
 	int ret;
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
index 24d3993..1e9ece2 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
@@ -1396,7 +1396,7 @@ static void hal_EfuseConstructPGPkt(u8 offset, u8 word_en, u8 *pData, struct pgp
 	pTargetPkt->word_cnts = Efuse_CalculateWordCnts(pTargetPkt->word_en);
 }
 
-static bool hal_EfusePgPacketWrite_8188e(struct adapter *pAdapter, u8 offset, u8 word_en, u8 *pData, bool bPseudoTest)
+bool Efuse_PgPacketWrite(struct adapter *pAdapter, u8 offset, u8 word_en, u8 *pData, bool bPseudoTest)
 {
 	struct pgpkt	targetPkt;
 	u16			startAddr = 0;
@@ -1541,9 +1541,6 @@ void rtl8188e_set_hal_ops(struct hal_ops *pHalFunc)
 	pHalFunc->read_rfreg = &rtl8188e_PHY_QueryRFReg;
 	pHalFunc->write_rfreg = &rtl8188e_PHY_SetRFReg;
 
-	/*  Efuse related function */
-	pHalFunc->Efuse_PgPacketWrite = &hal_EfusePgPacketWrite_8188e;
-
 	pHalFunc->sreset_init_value = &sreset_init_value;
 	pHalFunc->sreset_get_wifi_status  = &sreset_get_wifi_status;
 
diff --git a/drivers/staging/rtl8188eu/include/hal_intf.h b/drivers/staging/rtl8188eu/include/hal_intf.h
index 9597c35..cacf9df 100644
--- a/drivers/staging/rtl8188eu/include/hal_intf.h
+++ b/drivers/staging/rtl8188eu/include/hal_intf.h
@@ -233,8 +233,6 @@ struct hal_ops {
 			       enum rf_radio_path eRFPath, u32 RegAddr,
 			       u32 BitMask, u32 Data);
 
-	bool	(*Efuse_PgPacketWrite)(struct adapter *padapter, u8 offset,
-				       u8 word_en, u8 *data, bool bPseudoTest);
 	bool	(*Efuse_PgPacketWrite_BT)(struct adapter *padapter, u8 offset,
 					  u8 word_en, u8 *data, bool test);
 
diff --git a/drivers/staging/rtl8188eu/include/rtw_efuse.h b/drivers/staging/rtl8188eu/include/rtw_efuse.h
index 63a6c6e..dba8296 100644
--- a/drivers/staging/rtl8188eu/include/rtw_efuse.h
+++ b/drivers/staging/rtl8188eu/include/rtw_efuse.h
@@ -139,7 +139,7 @@ void efuse_ReadEFuse(struct adapter *Adapter, u8 efuseType, u16 _offset,
 		u16 _size_byte, u8 *pbuf, bool bPseudoTest);
 void Efuse_PowerSwitch(struct adapter *adapt, u8 bWrite, u8  PwrState);
 int Efuse_PgPacketRead(struct adapter *adapt, u8 offset, u8 *data, bool test);
-int Efuse_PgPacketWrite(struct adapter *adapter, u8 offset, u8 word, u8 *data,
+bool Efuse_PgPacketWrite(struct adapter *adapter, u8 offset, u8 word, u8 *data,
 			bool test);
 void efuse_WordEnableDataRead(u8 word_en, u8 *sourdata, u8 *targetdata);
 u8 Efuse_WordEnableDataWrite(struct adapter *adapter, u16 efuse_addr,
-- 
1.7.10.4

