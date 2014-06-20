Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934149AbaFTPDW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 11:03:22 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:34182 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837AbaFTPDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 11:03:18 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 22/41] staging: rtl8188eu: Remove function rtw_BT_efuse_map_write()
Date: Fri, 20 Jun 2014 20:29:28 +0530
Message-Id: <1403276387-11841-23-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403276387-11841-1-git-send-email-navin.patidar@gmail.com>
References: <1403276387-11841-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rtl8188eu is not a wifi/bluetooth combo device, so remove bluetooth
related code.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_efuse.c     |   97 ------------------------
 drivers/staging/rtl8188eu/include/rtw_efuse.h  |    2 -
 drivers/staging/rtl8188eu/os_dep/ioctl_linux.c |   10 ---
 3 files changed, 109 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_efuse.c b/drivers/staging/rtl8188eu/core/rtw_efuse.c
index 937ebce..9321546 100644
--- a/drivers/staging/rtl8188eu/core/rtw_efuse.c
+++ b/drivers/staging/rtl8188eu/core/rtw_efuse.c
@@ -463,103 +463,6 @@ exit:
 	return ret;
 }
 
-/*  */
-u8 rtw_BT_efuse_map_write(struct adapter *padapter, u16 addr, u16 cnts, u8 *data)
-{
-	u8 offset, word_en;
-	u8 *map;
-	u8 newdata[PGPKT_DATA_SIZE + 1];
-	s32	i, idx;
-	u8 ret = _SUCCESS;
-	u16 mapLen = 0;
-
-	EFUSE_GetEfuseDefinition(padapter, EFUSE_BT, TYPE_EFUSE_MAP_LEN, (void *)&mapLen);
-
-	if ((addr + cnts) > mapLen)
-		return _FAIL;
-
-	map = rtw_zmalloc(mapLen);
-	if (map == NULL)
-		return _FAIL;
-
-	ret = rtw_BT_efuse_map_read(padapter, 0, mapLen, map);
-	if (ret == _FAIL)
-		goto exit;
-
-	Efuse_PowerSwitch(padapter, true, true);
-
-	offset = (addr >> 3);
-	word_en = 0xF;
-	_rtw_memset(newdata, 0xFF, PGPKT_DATA_SIZE + 1);
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
-			DBG_88E("%s: offset=%#X\n", __func__, offset);
-			DBG_88E("%s: word_en=%#X\n", __func__, word_en);
-			DBG_88E("%s: data=", __func__);
-			for (i = 0; i < PGPKT_DATA_SIZE; i++)
-				DBG_88E("0x%02X ", newdata[i]);
-			DBG_88E("\n");
-
-			ret = Efuse_PgPacketWrite_BT(padapter, offset, word_en, newdata, false);
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
-		_rtw_memset(newdata, 0xFF, PGPKT_DATA_SIZE);
-	} while (1);
-
-	Efuse_PowerSwitch(padapter, true, false);
-
-exit:
-
-	kfree(map);
-
-	return ret;
-}
-
 /*-----------------------------------------------------------------------------
  * Function:	efuse_ShadowRead1Byte
  *			efuse_ShadowRead2Byte
diff --git a/drivers/staging/rtl8188eu/include/rtw_efuse.h b/drivers/staging/rtl8188eu/include/rtw_efuse.h
index dba8296..7df0441 100644
--- a/drivers/staging/rtl8188eu/include/rtw_efuse.h
+++ b/drivers/staging/rtl8188eu/include/rtw_efuse.h
@@ -125,8 +125,6 @@ u8 rtw_efuse_map_read(struct adapter *adapter, u16 addr, u16 cnts, u8 *data);
 u8 rtw_efuse_map_write(struct adapter *adapter, u16 addr, u16 cnts, u8 *data);
 u8 rtw_BT_efuse_map_read(struct adapter *adapter, u16 addr,
 			 u16 cnts, u8 *data);
-u8 rtw_BT_efuse_map_write(struct adapter *adapter, u16 addr,
-			  u16 cnts, u8 *data);
 u16 Efuse_GetCurrentSize(struct adapter *adapter, bool test);
 u8 Efuse_CalculateWordCnts(u8 word_en);
 void ReadEFuseByte(struct adapter *adapter, u16 _offset, u8 *pbuf, bool test);
diff --git a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
index c43322d..79a1ac4 100644
--- a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
@@ -6253,11 +6253,6 @@ static int rtw_mp_efuse_set(struct net_device *dev,
 			goto exit;
 		}
 
-		if (rtw_BT_efuse_map_write(padapter, addr, cnts, setdata) == _FAIL) {
-			DBG_88E("%s: rtw_BT_efuse_map_write error!!\n", __func__);
-			err = -EFAULT;
-			goto exit;
-		}
 	} else if (strcmp(tmp[0], "btwfake") == 0) {
 		if ((tmp[1] == NULL) || (tmp[2] == NULL)) {
 			err = -EINVAL;
@@ -6307,11 +6302,6 @@ static int rtw_mp_efuse_set(struct net_device *dev,
 			goto exit;
 		}
 
-		if (rtw_BT_efuse_map_write(padapter, 0x00, EFUSE_BT_MAX_MAP_LEN, pEfuseHal->fakeBTEfuseModifiedMap) == _FAIL) {
-			DBG_88E("%s: rtw_BT_efuse_map_write error!\n", __func__);
-			err = -EFAULT;
-			goto exit;
-		}
 	} else if (strcmp(tmp[0], "wlfk2map") == 0) {
 		EFUSE_GetEfuseDefinition(padapter, EFUSE_WIFI, TYPE_AVAILABLE_EFUSE_BYTES_TOTAL, (void *)&max_available_size);
 		if (max_available_size < 1) {
-- 
1.7.10.4

