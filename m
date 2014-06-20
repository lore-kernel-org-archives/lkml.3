Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073AbaFTPDg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 11:03:36 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:45755 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141AbaFTPDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 11:03:31 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 24/41] staging: rtl8188eu: Remove function rtw_BT_efuse_map_read()
Date: Fri, 20 Jun 2014 20:29:30 +0530
Message-Id: <1403276387-11841-25-git-send-email-navin.patidar@gmail.com>
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
 drivers/staging/rtl8188eu/core/rtw_efuse.c     |   17 ------
 drivers/staging/rtl8188eu/include/rtw_efuse.h  |    2 -
 drivers/staging/rtl8188eu/os_dep/ioctl_linux.c |   78 ------------------------
 3 files changed, 97 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_efuse.c b/drivers/staging/rtl8188eu/core/rtw_efuse.c
index f2ca6d4..7e126ce 100644
--- a/drivers/staging/rtl8188eu/core/rtw_efuse.c
+++ b/drivers/staging/rtl8188eu/core/rtw_efuse.c
@@ -345,23 +345,6 @@ u8 rtw_efuse_map_read(struct adapter *padapter, u16 addr, u16 cnts, u8 *data)
 	return _SUCCESS;
 }
 
-u8 rtw_BT_efuse_map_read(struct adapter *padapter, u16 addr, u16 cnts, u8 *data)
-{
-	u16 mapLen = 0;
-
-	EFUSE_GetEfuseDefinition(padapter, EFUSE_BT, TYPE_EFUSE_MAP_LEN, (void *)&mapLen);
-
-	if ((addr + cnts) > mapLen)
-		return _FAIL;
-
-	Efuse_PowerSwitch(padapter, false, true);
-
-	efuse_ReadEFuse(padapter, EFUSE_BT, addr, cnts, data, false);
-
-	Efuse_PowerSwitch(padapter, false, false);
-
-	return _SUCCESS;
-}
 /*  */
 u8 rtw_efuse_map_write(struct adapter *padapter, u16 addr, u16 cnts, u8 *data)
 {
diff --git a/drivers/staging/rtl8188eu/include/rtw_efuse.h b/drivers/staging/rtl8188eu/include/rtw_efuse.h
index 7df0441..41d6cf2 100644
--- a/drivers/staging/rtl8188eu/include/rtw_efuse.h
+++ b/drivers/staging/rtl8188eu/include/rtw_efuse.h
@@ -123,8 +123,6 @@ u8 rtw_efuse_access(struct adapter *adapter, u8 read, u16 start_addr,
 		    u16 cnts, u8 *data);
 u8 rtw_efuse_map_read(struct adapter *adapter, u16 addr, u16 cnts, u8 *data);
 u8 rtw_efuse_map_write(struct adapter *adapter, u16 addr, u16 cnts, u8 *data);
-u8 rtw_BT_efuse_map_read(struct adapter *adapter, u16 addr,
-			 u16 cnts, u8 *data);
 u16 Efuse_GetCurrentSize(struct adapter *adapter, bool test);
 u8 Efuse_CalculateWordCnts(u8 word_en);
 void ReadEFuseByte(struct adapter *adapter, u16 _offset, u8 *pbuf, bool test);
diff --git a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
index 79a1ac4..56e24fa 100644
--- a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
@@ -5883,77 +5883,6 @@ static int rtw_mp_efuse_get(struct net_device *dev,
 		efuse_GetCurrentSize(padapter, &raw_cursize);
 		raw_maxsize = efuse_GetMaxSize(padapter);
 		sprintf(extra, "[available raw size] = %d bytes", raw_maxsize-raw_cursize);
-	} else if (strcmp(tmp[0], "btfmap") == 0) {
-		mapLen = EFUSE_BT_MAX_MAP_LEN;
-		if (rtw_BT_efuse_map_read(padapter, 0, mapLen, pEfuseHal->BTEfuseInitMap) == _FAIL) {
-			DBG_88E("%s: rtw_BT_efuse_map_read Fail!!\n", __func__);
-			err = -EFAULT;
-			goto exit;
-		}
-
-		sprintf(extra, "\n");
-		for (i = 0; i < 512; i += 16) {
-			/*  set 512 because the iwpriv's extra size have limit 0x7FF */
-			sprintf(extra, "%s0x%03x\t", extra, i);
-			for (j = 0; j < 8; j++)
-				sprintf(extra, "%s%02X ", extra, pEfuseHal->BTEfuseInitMap[i+j]);
-			sprintf(extra, "%s\t", extra);
-			for (; j < 16; j++)
-				sprintf(extra, "%s%02X ", extra, pEfuseHal->BTEfuseInitMap[i+j]);
-			sprintf(extra, "%s\n", extra);
-		}
-	} else if (strcmp(tmp[0], "btbmap") == 0) {
-		mapLen = EFUSE_BT_MAX_MAP_LEN;
-		if (rtw_BT_efuse_map_read(padapter, 0, mapLen, pEfuseHal->BTEfuseInitMap) == _FAIL) {
-			DBG_88E("%s: rtw_BT_efuse_map_read Fail!!\n", __func__);
-			err = -EFAULT;
-			goto exit;
-		}
-
-		sprintf(extra, "\n");
-		for (i = 512; i < 1024; i += 16) {
-			sprintf(extra, "%s0x%03x\t", extra, i);
-			for (j = 0; j < 8; j++)
-				sprintf(extra, "%s%02X ", extra, pEfuseHal->BTEfuseInitMap[i+j]);
-			sprintf(extra, "%s\t", extra);
-			for (; j < 16; j++)
-				sprintf(extra, "%s%02X ", extra, pEfuseHal->BTEfuseInitMap[i+j]);
-			sprintf(extra, "%s\n", extra);
-		}
-	} else if (strcmp(tmp[0], "btrmap") == 0) {
-		if ((tmp[1] == NULL) || (tmp[2] == NULL)) {
-			err = -EINVAL;
-			goto exit;
-		}
-
-		/*  rmap addr cnts */
-		addr = simple_strtoul(tmp[1], &ptmp, 16);
-		DBG_88E("%s: addr = 0x%X\n", __func__, addr);
-
-		cnts = simple_strtoul(tmp[2], &ptmp, 10);
-		if (cnts == 0) {
-			DBG_88E("%s: btrmap Fail!! cnts error!\n", __func__);
-			err = -EINVAL;
-			goto exit;
-		}
-		DBG_88E("%s: cnts =%d\n", __func__, cnts);
-
-		EFUSE_GetEfuseDefinition(padapter, EFUSE_BT, TYPE_AVAILABLE_EFUSE_BYTES_TOTAL, (void *)&max_available_size);
-		if ((addr + cnts) > max_available_size) {
-			DBG_88E("%s: addr(0x%X)+cnts(%d) parameter error!\n", __func__, addr, cnts);
-			err = -EFAULT;
-			goto exit;
-		}
-
-		if (rtw_BT_efuse_map_read(padapter, addr, cnts, data) == _FAIL) {
-			DBG_88E("%s: rtw_BT_efuse_map_read error!!\n", __func__);
-			err = -EFAULT;
-			goto exit;
-		}
-
-		*extra = 0;
-		for (i = 0; i < cnts; i++)
-			sprintf(extra, "%s 0x%02X ", extra, data[i]);
 	} else if (strcmp(tmp[0], "btffake") == 0) {
 		sprintf(extra, "\n");
 		for (i = 0; i < 512; i += 16) {
@@ -6279,13 +6208,6 @@ static int rtw_mp_efuse_set(struct net_device *dev,
 
 		for (jj = 0, kk = 0; jj < cnts; jj++, kk += 2)
 			pEfuseHal->fakeBTEfuseModifiedMap[addr+jj] = key_2char2num(tmp[2][kk], tmp[2][kk + 1]);
-	} else if (strcmp(tmp[0], "btdumpfake") == 0) {
-		if (rtw_BT_efuse_map_read(padapter, 0, EFUSE_BT_MAX_MAP_LEN, pEfuseHal->fakeBTEfuseModifiedMap) == _SUCCESS) {
-			DBG_88E("%s: BT read all map success\n", __func__);
-		} else {
-			DBG_88E("%s: BT read all map Fail!\n", __func__);
-			err = -EFAULT;
-		}
 	} else if (strcmp(tmp[0], "wldumpfake") == 0) {
 		if (rtw_efuse_map_read(padapter, 0, EFUSE_BT_MAX_MAP_LEN,  pEfuseHal->fakeEfuseModifiedMap) == _SUCCESS) {
 			DBG_88E("%s: BT read all map success\n", __func__);
-- 
1.7.10.4

