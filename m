Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661AbaGGSly (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 14:41:54 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:59861 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607AbaGGSlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 14:41:52 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 06/13] staging: rtl8188eu: Remove unused functions rtw_efuse_map_[read,write]()
Date: Tue,  8 Jul 2014 00:10:06 +0530
Message-Id: <1404758413-12859-6-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1404758413-12859-1-git-send-email-navin.patidar@gmail.com>
References: <1404758413-12859-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_efuse.c    |  113 -------------------------
 drivers/staging/rtl8188eu/include/rtw_efuse.h |    2 -
 2 files changed, 115 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_efuse.c b/drivers/staging/rtl8188eu/core/rtw_efuse.c
index 2189183..df8d934 100644
--- a/drivers/staging/rtl8188eu/core/rtw_efuse.c
+++ b/drivers/staging/rtl8188eu/core/rtw_efuse.c
@@ -983,119 +983,6 @@ void efuse_WordEnableDataRead(u8 word_en, u8 *sourdata, u8 *targetdata)
 }
 
 /*
- * read/wirte raw efuse data
- */
-
-u8 rtw_efuse_map_read(struct adapter *padapter, u16 addr, u16 cnts, u8 *data)
-{
-	u16 mapLen = 0;
-
-	EFUSE_GetEfuseDefinition(padapter, EFUSE_WIFI, TYPE_EFUSE_MAP_LEN, (void *)&mapLen);
-
-	if ((addr + cnts) > mapLen)
-		return _FAIL;
-
-	Efuse_PowerSwitch(padapter, false, true);
-
-	efuse_ReadEFuse(padapter, EFUSE_WIFI, addr, cnts, data);
-
-	Efuse_PowerSwitch(padapter, false, false);
-
-	return _SUCCESS;
-}
-
-u8 rtw_efuse_map_write(struct adapter *padapter, u16 addr, u16 cnts, u8 *data)
-{
-	u8 offset, word_en;
-	u8 *map;
-	u8 newdata[PGPKT_DATA_SIZE + 1];
-	s32	i, idx;
-	u8 ret = _SUCCESS;
-	u16 mapLen = 0;
-
-	EFUSE_GetEfuseDefinition(padapter, EFUSE_WIFI, TYPE_EFUSE_MAP_LEN, (void *)&mapLen);
-
-	if ((addr + cnts) > mapLen)
-		return _FAIL;
-
-	map = kzalloc(mapLen, GFP_KERNEL);
-	if (map == NULL)
-		return _FAIL;
-
-	ret = rtw_efuse_map_read(padapter, 0, mapLen, map);
-	if (ret == _FAIL)
-		goto exit;
-
-	Efuse_PowerSwitch(padapter, true, true);
-
-	offset = (addr >> 3);
-	word_en = 0xF;
-	memset(newdata, 0xFF, PGPKT_DATA_SIZE + 1);
-	i = addr & 0x7;	/*  index of one package */
-	idx = 0;	/*  data index */
-
-	if (i & 0x1) {
-		/*  odd start */
-		if (data[idx] != map[addr+idx]) {
-			word_en &= ~BIT(i >> 1);
-			newdata[i-1] = map[addr+idx-1];
-			newdata[i] = data[idx];
-		}
-		i++;
-		idx++;
-	}
-	do {
-		for (; i < PGPKT_DATA_SIZE; i += 2) {
-			if (cnts == idx)
-				break;
-			if ((cnts - idx) == 1) {
-				if (data[idx] != map[addr+idx]) {
-					word_en &= ~BIT(i >> 1);
-					newdata[i] = data[idx];
-					newdata[i+1] = map[addr+idx+1];
-				}
-				idx++;
-				break;
-			} else {
-				if ((data[idx] != map[addr+idx]) ||
-				    (data[idx+1] != map[addr+idx+1])) {
-					word_en &= ~BIT(i >> 1);
-					newdata[i] = data[idx];
-					newdata[i+1] = data[idx + 1];
-				}
-				idx += 2;
-			}
-			if (idx == cnts)
-				break;
-		}
-
-		if (word_en != 0xF) {
-			ret = Efuse_PgPacketWrite(padapter, offset, word_en, newdata);
-			DBG_88E("offset=%x\n", offset);
-			DBG_88E("word_en=%x\n", word_en);
-
-			for (i = 0; i < PGPKT_DATA_SIZE; i++)
-				DBG_88E("data=%x \t", newdata[i]);
-			if (ret == _FAIL)
-				break;
-		}
-
-		if (idx == cnts)
-			break;
-
-		offset++;
-		i = 0;
-		word_en = 0xF;
-		memset(newdata, 0xFF, PGPKT_DATA_SIZE);
-	} while (1);
-
-	Efuse_PowerSwitch(padapter, true, false);
-exit:
-	kfree(map);
-	return ret;
-}
-
-/*
  * Function:   efuse_ShadowRead1Byte
  *             efuse_ShadowRead2Byte
  *             efuse_ShadowRead4Byte
diff --git a/drivers/staging/rtl8188eu/include/rtw_efuse.h b/drivers/staging/rtl8188eu/include/rtw_efuse.h
index 6d20fcc..adeb501 100644
--- a/drivers/staging/rtl8188eu/include/rtw_efuse.h
+++ b/drivers/staging/rtl8188eu/include/rtw_efuse.h
@@ -99,8 +99,6 @@ struct efuse_hal {
 	u8 fakeBTEfuseModifiedMap[EFUSE_BT_MAX_MAP_LEN];
 };
 
-u8 rtw_efuse_map_read(struct adapter *adapter, u16 addr, u16 cnts, u8 *data);
-u8 rtw_efuse_map_write(struct adapter *adapter, u16 addr, u16 cnts, u8 *data);
 u16 Efuse_GetCurrentSize(struct adapter *adapter);
 u8 Efuse_CalculateWordCnts(u8 word_en);
 void EFUSE_GetEfuseDefinition(struct adapter *adapt, u8 type, u8 type1,
-- 
1.7.10.4

