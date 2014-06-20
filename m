Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965325AbaFTPEn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 11:04:43 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:49749 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965054AbaFTPEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 11:04:40 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 35/41] staging: rtl8188eu: Remove bool bPseudoTest parameter from efuse functions
Date: Fri, 20 Jun 2014 20:29:41 +0530
Message-Id: <1403276387-11841-36-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403276387-11841-1-git-send-email-navin.patidar@gmail.com>
References: <1403276387-11841-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In most of the functions bPseudoTest is not used and in remaining ones
it's always false.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_efuse.c        |    2 +-
 drivers/staging/rtl8188eu/core/rtw_mp_ioctl.c     |    4 +-
 drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c |   68 +++++++++------------
 drivers/staging/rtl8188eu/include/rtw_efuse.h     |    5 +-
 4 files changed, 33 insertions(+), 46 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_efuse.c b/drivers/staging/rtl8188eu/core/rtw_efuse.c
index bfa6588..a0204ed 100644
--- a/drivers/staging/rtl8188eu/core/rtw_efuse.c
+++ b/drivers/staging/rtl8188eu/core/rtw_efuse.c
@@ -306,7 +306,7 @@ u8 rtw_efuse_map_write(struct adapter *padapter, u16 addr, u16 cnts, u8 *data)
 		}
 
 		if (word_en != 0xF) {
-			ret = Efuse_PgPacketWrite(padapter, offset, word_en, newdata, false);
+			ret = Efuse_PgPacketWrite(padapter, offset, word_en, newdata);
 			DBG_88E("offset=%x\n", offset);
 			DBG_88E("word_en=%x\n", word_en);
 
diff --git a/drivers/staging/rtl8188eu/core/rtw_mp_ioctl.c b/drivers/staging/rtl8188eu/core/rtw_mp_ioctl.c
index e62cca8..10c9b6d 100644
--- a/drivers/staging/rtl8188eu/core/rtw_mp_ioctl.c
+++ b/drivers/staging/rtl8188eu/core/rtw_mp_ioctl.c
@@ -1179,7 +1179,7 @@ int rtl8188eu_oid_rt_pro_rw_efuse_pgpkt_hdl(struct oid_par_priv *poid_par_priv)
 			 ppgpkt->offset));
 
 		Efuse_PowerSwitch(Adapter, false, true);
-		if (Efuse_PgPacketRead(Adapter, ppgpkt->offset, ppgpkt->data, false) == true)
+		if (Efuse_PgPacketRead(Adapter, ppgpkt->offset, ppgpkt->data) == true)
 			*poid_par_priv->bytes_rw = poid_par_priv->information_buf_len;
 		else
 			status = NDIS_STATUS_FAILURE;
@@ -1190,7 +1190,7 @@ int rtl8188eu_oid_rt_pro_rw_efuse_pgpkt_hdl(struct oid_par_priv *poid_par_priv)
 			 ppgpkt->offset, ppgpkt->word_en));
 
 		Efuse_PowerSwitch(Adapter, true, true);
-		if (Efuse_PgPacketWrite(Adapter, ppgpkt->offset, ppgpkt->word_en, ppgpkt->data, false) == true)
+		if (Efuse_PgPacketWrite(Adapter, ppgpkt->offset, ppgpkt->word_en, ppgpkt->data) == true)
 			*poid_par_priv->bytes_rw = poid_par_priv->information_buf_len;
 		else
 			status = NDIS_STATUS_FAILURE;
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
index ed9e42c..0de4a91 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
@@ -733,22 +733,19 @@ hal_EfusePgPacketWrite2ByteHeader(
 		struct adapter *pAdapter,
 		u8 efuseType,
 		u16				*pAddr,
-		struct pgpkt *pTargetPkt,
-		bool bPseudoTest);
+		struct pgpkt *pTargetPkt);
 static bool
 hal_EfusePgPacketWrite1ByteHeader(
 		struct adapter *pAdapter,
 		u8 efuseType,
 		u16				*pAddr,
-		struct pgpkt *pTargetPkt,
-		bool bPseudoTest);
+		struct pgpkt *pTargetPkt);
 static bool
 hal_EfusePgPacketWriteData(
 		struct adapter *pAdapter,
 		u8 efuseType,
 		u16				*pAddr,
-		struct pgpkt *pTargetPkt,
-		bool bPseudoTest);
+		struct pgpkt *pTargetPkt);
 
 /*
  * Function:	Efuse_PowerSwitch
@@ -975,7 +972,7 @@ u16 Efuse_GetCurrentSize(struct adapter *pAdapter)
 	return efuse_addr;
 }
 
-int Efuse_PgPacketRead(struct adapter *pAdapter, u8 offset, u8 *data, bool bPseudoTest)
+int Efuse_PgPacketRead(struct adapter *pAdapter, u8 offset, u8 *data)
 {
 	u8 ReadState = PG_STATE_HEADER;
 	int	bContinual = true;
@@ -1061,7 +1058,7 @@ int Efuse_PgPacketRead(struct adapter *pAdapter, u8 offset, u8 *data, bool bPseu
 		return true;
 }
 
-static bool hal_EfuseFixHeaderProcess(struct adapter *pAdapter, u8 efuseType, struct pgpkt *pFixPkt, u16 *pAddr, bool bPseudoTest)
+static bool hal_EfuseFixHeaderProcess(struct adapter *pAdapter, u8 efuseType, struct pgpkt *pFixPkt, u16 *pAddr)
 {
 	u8 originaldata[8], badworden = 0;
 	u16	efuse_addr = *pAddr;
@@ -1069,12 +1066,12 @@ static bool hal_EfuseFixHeaderProcess(struct adapter *pAdapter, u8 efuseType, st
 
 	_rtw_memset((void *)originaldata, 0xff, 8);
 
-	if (Efuse_PgPacketRead(pAdapter, pFixPkt->offset, originaldata, bPseudoTest)) {
+	if (Efuse_PgPacketRead(pAdapter, pFixPkt->offset, originaldata)) {
 		/* check if data exist */
 		badworden = Efuse_WordEnableDataWrite(pAdapter, efuse_addr+1, pFixPkt->word_en, originaldata);
 
 		if (badworden != 0xf) {	/*  write fail */
-			PgWriteSuccess = Efuse_PgPacketWrite(pAdapter, pFixPkt->offset, badworden, originaldata, bPseudoTest);
+			PgWriteSuccess = Efuse_PgPacketWrite(pAdapter, pFixPkt->offset, badworden, originaldata);
 
 			if (!PgWriteSuccess)
 				return false;
@@ -1090,7 +1087,7 @@ static bool hal_EfuseFixHeaderProcess(struct adapter *pAdapter, u8 efuseType, st
 	return true;
 }
 
-static bool hal_EfusePgPacketWrite2ByteHeader(struct adapter *pAdapter, u8 efuseType, u16 *pAddr, struct pgpkt *pTargetPkt, bool bPseudoTest)
+static bool hal_EfusePgPacketWrite2ByteHeader(struct adapter *pAdapter, u8 efuseType, u16 *pAddr, struct pgpkt *pTargetPkt)
 {
 	bool bRet = false;
 	u16	efuse_addr = *pAddr, efuse_max_available_len = 0;
@@ -1141,7 +1138,7 @@ static bool hal_EfusePgPacketWrite2ByteHeader(struct adapter *pAdapter, u8 efuse
 				fixPkt.offset = ((pg_header_temp & 0xE0) >> 5) | ((tmp_header & 0xF0) >> 1);
 				fixPkt.word_en = tmp_header & 0x0F;
 				fixPkt.word_cnts = Efuse_CalculateWordCnts(fixPkt.word_en);
-				if (!hal_EfuseFixHeaderProcess(pAdapter, efuseType, &fixPkt, &efuse_addr, bPseudoTest))
+				if (!hal_EfuseFixHeaderProcess(pAdapter, efuseType, &fixPkt, &efuse_addr))
 					return false;
 			} else {
 				bRet = true;
@@ -1157,7 +1154,7 @@ static bool hal_EfusePgPacketWrite2ByteHeader(struct adapter *pAdapter, u8 efuse
 	return bRet;
 }
 
-static bool hal_EfusePgPacketWrite1ByteHeader(struct adapter *pAdapter, u8 efuseType, u16 *pAddr, struct pgpkt *pTargetPkt, bool bPseudoTest)
+static bool hal_EfusePgPacketWrite1ByteHeader(struct adapter *pAdapter, u8 efuseType, u16 *pAddr, struct pgpkt *pTargetPkt)
 {
 	bool bRet = false;
 	u8 pg_header = 0, tmp_header = 0;
@@ -1183,7 +1180,7 @@ static bool hal_EfusePgPacketWrite1ByteHeader(struct adapter *pAdapter, u8 efuse
 		fixPkt.offset = (tmp_header>>4) & 0x0F;
 		fixPkt.word_en = tmp_header & 0x0F;
 		fixPkt.word_cnts = Efuse_CalculateWordCnts(fixPkt.word_en);
-		if (!hal_EfuseFixHeaderProcess(pAdapter, efuseType, &fixPkt, &efuse_addr, bPseudoTest))
+		if (!hal_EfuseFixHeaderProcess(pAdapter, efuseType, &fixPkt, &efuse_addr))
 			return false;
 	}
 
@@ -1191,7 +1188,7 @@ static bool hal_EfusePgPacketWrite1ByteHeader(struct adapter *pAdapter, u8 efuse
 	return bRet;
 }
 
-static bool hal_EfusePgPacketWriteData(struct adapter *pAdapter, u8 efuseType, u16 *pAddr, struct pgpkt *pTargetPkt, bool bPseudoTest)
+static bool hal_EfusePgPacketWriteData(struct adapter *pAdapter, u8 efuseType, u16 *pAddr, struct pgpkt *pTargetPkt)
 {
 	u16	efuse_addr = *pAddr;
 	u8 badworden = 0;
@@ -1204,7 +1201,7 @@ static bool hal_EfusePgPacketWriteData(struct adapter *pAdapter, u8 efuseType, u
 		return true;
 	} else {
 		/* reorganize other pg packet */
-		PgWriteSuccess = Efuse_PgPacketWrite(pAdapter, pTargetPkt->offset, badworden, pTargetPkt->data, bPseudoTest);
+		PgWriteSuccess = Efuse_PgPacketWrite(pAdapter, pTargetPkt->offset, badworden, pTargetPkt->data);
 		if (!PgWriteSuccess)
 			return false;
 		else
@@ -1217,15 +1214,14 @@ hal_EfusePgPacketWriteHeader(
 				struct adapter *pAdapter,
 				u8 efuseType,
 				u16				*pAddr,
-				struct pgpkt *pTargetPkt,
-				bool bPseudoTest)
+				struct pgpkt *pTargetPkt)
 {
 	bool bRet = false;
 
 	if (pTargetPkt->offset >= EFUSE_MAX_SECTION_BASE)
-		bRet = hal_EfusePgPacketWrite2ByteHeader(pAdapter, efuseType, pAddr, pTargetPkt, bPseudoTest);
+		bRet = hal_EfusePgPacketWrite2ByteHeader(pAdapter, efuseType, pAddr, pTargetPkt);
 	else
-		bRet = hal_EfusePgPacketWrite1ByteHeader(pAdapter, efuseType, pAddr, pTargetPkt, bPseudoTest);
+		bRet = hal_EfusePgPacketWrite1ByteHeader(pAdapter, efuseType, pAddr, pTargetPkt);
 
 	return bRet;
 }
@@ -1269,7 +1265,7 @@ static bool hal_EfuseCheckIfDatafollowed(struct adapter *pAdapter, u8 word_cnts,
 	return bRet;
 }
 
-static bool hal_EfusePartialWriteCheck(struct adapter *pAdapter, u8 efuseType, u16 *pAddr, struct pgpkt *pTargetPkt, bool bPseudoTest)
+static bool hal_EfusePartialWriteCheck(struct adapter *pAdapter, u8 efuseType, u16 *pAddr, struct pgpkt *pTargetPkt)
 {
 	bool bRet = false;
 	u8 i, efuse_data = 0, cur_header = 0;
@@ -1281,17 +1277,10 @@ static bool hal_EfusePartialWriteCheck(struct adapter *pAdapter, u8 efuseType, u
 	EFUSE_GetEfuseDefinition(pAdapter, efuseType, TYPE_EFUSE_REAL_CONTENT_LEN, (void *)&efuse_max);
 
 	if (efuseType == EFUSE_WIFI) {
-		if (bPseudoTest) {
-			startAddr = (u16)(fakeEfuseUsedBytes%EFUSE_REAL_CONTENT_LEN);
-		} else {
-			rtw_hal_get_hwreg(pAdapter, HW_VAR_EFUSE_BYTES, (u8 *)&startAddr);
-			startAddr %= EFUSE_REAL_CONTENT_LEN;
-		}
+		rtw_hal_get_hwreg(pAdapter, HW_VAR_EFUSE_BYTES, (u8 *)&startAddr);
+		startAddr %= EFUSE_REAL_CONTENT_LEN;
 	} else {
-		if (bPseudoTest)
-			startAddr = (u16)(fakeBTEfuseUsedBytes%EFUSE_REAL_CONTENT_LEN);
-		else
-			startAddr = (u16)(BTEfuseUsedBytes%EFUSE_REAL_CONTENT_LEN);
+		startAddr = (u16)(BTEfuseUsedBytes%EFUSE_REAL_CONTENT_LEN);
 	}
 
 	while (1) {
@@ -1322,7 +1311,7 @@ static bool hal_EfusePartialWriteCheck(struct adapter *pAdapter, u8 efuseType, u
 			/*  if same header is found but no data followed */
 			/*  write some part of data followed by the header. */
 			if ((curPkt.offset == pTargetPkt->offset) &&
-			    (!hal_EfuseCheckIfDatafollowed(pAdapter, curPkt.word_cnts, startAddr+1, bPseudoTest)) &&
+			    (!hal_EfuseCheckIfDatafollowed(pAdapter, curPkt.word_cnts, startAddr+1)) &&
 			    wordEnMatched(pTargetPkt, &curPkt, &matched_wden)) {
 				/*  Here to write partial data */
 				badworden = Efuse_WordEnableDataWrite(pAdapter, startAddr+1, matched_wden, pTargetPkt->data);
@@ -1330,7 +1319,7 @@ static bool hal_EfusePartialWriteCheck(struct adapter *pAdapter, u8 efuseType, u
 					u32	PgWriteSuccess = 0;
 					/*  if write fail on some words, write these bad words again */
 
-					PgWriteSuccess = Efuse_PgPacketWrite(pAdapter, pTargetPkt->offset, badworden, pTargetPkt->data, bPseudoTest);
+					PgWriteSuccess = Efuse_PgPacketWrite(pAdapter, pTargetPkt->offset, badworden, pTargetPkt->data);
 
 					if (!PgWriteSuccess) {
 						bRet = false;	/*  write fail, return */
@@ -1359,8 +1348,7 @@ static bool hal_EfusePartialWriteCheck(struct adapter *pAdapter, u8 efuseType, u
 static bool
 hal_EfusePgCheckAvailableAddr(
 		struct adapter *pAdapter,
-		u8 efuseType,
-		bool bPseudoTest
+		u8 efuseType
 	)
 {
 	u16	efuse_max_available_len = 0;
@@ -1382,24 +1370,24 @@ static void hal_EfuseConstructPGPkt(u8 offset, u8 word_en, u8 *pData, struct pgp
 	pTargetPkt->word_cnts = Efuse_CalculateWordCnts(pTargetPkt->word_en);
 }
 
-bool Efuse_PgPacketWrite(struct adapter *pAdapter, u8 offset, u8 word_en, u8 *pData, bool bPseudoTest)
+bool Efuse_PgPacketWrite(struct adapter *pAdapter, u8 offset, u8 word_en, u8 *pData)
 {
 	struct pgpkt	targetPkt;
 	u16			startAddr = 0;
 	u8 efuseType = EFUSE_WIFI;
 
-	if (!hal_EfusePgCheckAvailableAddr(pAdapter, efuseType, bPseudoTest))
+	if (!hal_EfusePgCheckAvailableAddr(pAdapter, efuseType))
 		return false;
 
 	hal_EfuseConstructPGPkt(offset, word_en, pData, &targetPkt);
 
-	if (!hal_EfusePartialWriteCheck(pAdapter, efuseType, &startAddr, &targetPkt, bPseudoTest))
+	if (!hal_EfusePartialWriteCheck(pAdapter, efuseType, &startAddr, &targetPkt))
 		return false;
 
-	if (!hal_EfusePgPacketWriteHeader(pAdapter, efuseType, &startAddr, &targetPkt, bPseudoTest))
+	if (!hal_EfusePgPacketWriteHeader(pAdapter, efuseType, &startAddr, &targetPkt))
 		return false;
 
-	if (!hal_EfusePgPacketWriteData(pAdapter, efuseType, &startAddr, &targetPkt, bPseudoTest))
+	if (!hal_EfusePgPacketWriteData(pAdapter, efuseType, &startAddr, &targetPkt))
 		return false;
 
 	return true;
diff --git a/drivers/staging/rtl8188eu/include/rtw_efuse.h b/drivers/staging/rtl8188eu/include/rtw_efuse.h
index f8737a4..00f8797 100644
--- a/drivers/staging/rtl8188eu/include/rtw_efuse.h
+++ b/drivers/staging/rtl8188eu/include/rtw_efuse.h
@@ -133,9 +133,8 @@ u8 efuse_OneByteWrite(struct adapter *adapter, u16 addr, u8 data);
 void efuse_ReadEFuse(struct adapter *Adapter, u8 efuseType, u16 _offset,
 		u16 _size_byte, u8 *pbuf);
 void Efuse_PowerSwitch(struct adapter *adapt, u8 bWrite, u8  PwrState);
-int Efuse_PgPacketRead(struct adapter *adapt, u8 offset, u8 *data, bool test);
-bool Efuse_PgPacketWrite(struct adapter *adapter, u8 offset, u8 word, u8 *data,
-			bool test);
+int Efuse_PgPacketRead(struct adapter *adapt, u8 offset, u8 *data);
+bool Efuse_PgPacketWrite(struct adapter *adapter, u8 offset, u8 word, u8 *data);
 void efuse_WordEnableDataRead(u8 word_en, u8 *sourdata, u8 *targetdata);
 u8 Efuse_WordEnableDataWrite(struct adapter *adapter, u16 efuse_addr,
 			     u8 word_en, u8 *data);
-- 
1.7.10.4

